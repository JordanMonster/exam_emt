import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';

import '../../commons/global.dart';

const String kErrorMsgPurchaseManageSkuNotFound = "SKU not found";
const String kErrorCodePurchaseManageSkuNotFound =
    "purchase_manage_sku_not_found";
const String kErrorCodePurchaseManagePurchaseError = "purchase_error";
const String kErrorCodePurchaseManageQueryProductError = "query_product_error";
const String kErrorCodePurchaseManageRestoreError = "restore_error";
const String kErrorCodePurchaseManageVerifyError = "verify_error";
const String kSourcePurchaseManage = "purchase_manage";

class PurchaseManager {
  //用于验证购买的密钥
  final String _key;
  static PurchaseManager? _instance;

  static const String kSilverSubscriptionId = "Global.config!.SKU";
  static const String kSilverSubscriptionMonthId = "Global.config!.SKU03";
  static const String kSilverSubscriptionYearsId = "Global.config!.SKU02";

  //当前应用的sku
  List<String> _kProductIds() => <String>[
        kSilverSubscriptionId,
        kSilverSubscriptionMonthId,
        kSilverSubscriptionYearsId
      ];

  List<String> get kProductIds => _kProductIds();

  final Map<String, ProductDetails> _products = {};
  Completer<VerifiedPurchaseInfo>? _currentPurchaseCallback;
  String? _currentPurchaseProductId;
  StreamController<VerifiedPurchaseInfo>? _currentRestoreCallback;

  final Map<String, VerifiedPurchaseInfo> _purchased = {};
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  ///
  /// 初始始化
  ///
  /// [_key] :用于验证购买的密钥
  static void initialize(String key) {
    _instance ??= PurchaseManager._(key);
  }

  ///
  /// 获取 PurchaseManage 实例
  static PurchaseManager get instance => _instance!;

  /// 私有构造函数
  ///
  /// [_key] :用于验证购买的密钥
  PurchaseManager._(this._key) {
    _loadPurchaseInfoFromStore();
    _subscription = InAppPurchase.instance.purchaseStream.listen(
        (event) => _onPurchaseEvent(event),
        onError: _onPurchaseError,
        onDone: _onPurchaseDone);
  }

  /// 使用指定的 [sku] 执行购买操作
  ///
  /// 购买成功返回 VerifiedPurchaseDetails；
  /// 用户取消了交易 error = [CancelPurchaseException]；
  /// 发生错其它错误 error != [CancelPurchaseException]。
  Future<VerifiedPurchaseInfo> purchase(String sku) {
    Completer<VerifiedPurchaseInfo> completer = Completer();

    if (_currentRestoreCallback != null) {
      _currentRestoreCallback!.close();
      _cleanRestoreCallback();
    }

    queryProductDetailBySku(sku).then((product) {
      _purchase(product, completer);
    }, onError: (Object error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  Future<List<ProductDetails>> queryProductDetails() async {
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(kProductIds.toSet());

    if (response.productDetails.isEmpty) {
      return [
        ProductDetails(
            title: 'Weekly',
            description: '0.72/day',
            currencyCode: 'US',
            id: kSilverSubscriptionId,
            price: '\$5.99',
            rawPrice: 5.99),
        ProductDetails(
            title: 'Month',
            description: '0.47/day',
            currencyCode: 'US',
            id: kSilverSubscriptionMonthId,
            price: '\$13.99',
            rawPrice: 13.99),
        ProductDetails(
            title: 'Half year',
            description: '0.17/day',
            currencyCode: 'US',
            id: kSilverSubscriptionYearsId,
            price: '\$29.99',
            rawPrice: 29.99),
      ];
    }
    return response.productDetails;
  }

  /// 查询商品信息
  ///
  /// [sku] 待查询的 SKU
  ///
  /// 查询到返回 [ProductDetails]，未找到或查询时出错则调用 onError
  Future<ProductDetails> queryProductDetailBySku(String sku) {
    ProductDetails? product = _products[sku];

    if (product != null) {
      return Future.value(product);
    }

    Future<ProductDetailsResponse> response =
        InAppPurchase.instance.queryProductDetails({sku});
    return response.then((response) {
      if (response.error != null) {
        return Future.error(response.error!);
      }

      _handleProductDetailsResponse(response);
      product = _products[sku];
      if (product != null) {
        return Future.value(product);
      } else {
        print(
            "InAppPurchaseException $kSourcePurchaseManage $kErrorCodePurchaseManageSkuNotFound $kErrorMsgPurchaseManageSkuNotFound");
        return Future.error(InAppPurchaseException(
            source: kSourcePurchaseManage,
            code: kErrorCodePurchaseManageSkuNotFound,
            message: kErrorMsgPurchaseManageSkuNotFound));
      }
    }, onError: (error, stackTrace) {
      return Future.error(error ??
          InAppPurchaseException(
              source: kSourcePurchaseManage,
              code: kErrorCodePurchaseManageQueryProductError));
    });
  }

  // 检查指定的 [sku] 是否购买了
  bool isPurchased({String? sku}) {
    if (Global.isDebug()) {
      return true;
    }

    if (sku != null) {
      VerifiedPurchaseInfo? purchase = _purchased[sku];
      if (purchase == null) {
        return false;
      }
      return true;
    }

    for (VerifiedPurchaseInfo info in _purchased.values) {
      if (kDebugMode) {
        print("[PurchasesManager]:_purchased.values: start ${info.isValid()}");
      }
      if (info.isValid()) {
        return true;
      }
    }

    return false;
  }

  //
  // 恢复购买
  // 如果成功的恢复了购买则先发送一个 [VerifiedPurchaseInfo.empty] 数据，然后每个有效的购买将会发送一次数据。
  // 如果发生了错误将触发 onError，onError 之后流将被关闭。
  //
  // 注意，如果恢复购买成功则流不会结束，所以不能在流中进行卡 UI 操作。
  //
  Stream<VerifiedPurchaseInfo> restore() {
    //单订阅模式的 Stream
    StreamController<VerifiedPurchaseInfo> controller =
        StreamController<VerifiedPurchaseInfo>();

    _currentRestoreCallback = controller;

    InAppPurchase.instance.restorePurchases().then((value) {
      //恢复操作成功，不能结束流操作，因为还需要等待返回购买数据
      controller.add(VerifiedPurchaseInfo.empty());
    }, onError: (error, stackTrace) {
      controller.addError(error ??
          InAppPurchaseException(
              source: kSourcePurchaseManage,
              code: kErrorCodePurchaseManageRestoreError));
      controller.close();
      _cleanRestoreCallback();
    });

    return controller.stream;
  }

  void _handleProductDetailsResponse(ProductDetailsResponse response) {
    for (ProductDetails product in response.productDetails) {
      _products[product.id] = product;
    }
  }

  void _purchase(
      ProductDetails product, Completer<VerifiedPurchaseInfo> completer) {
    //消耗型与非消耗型的底层购逻辑相同，消耗型多了一个购买成功后自动消耗的操作，这里我们统一使用非消耗方法
    PurchaseParam param = PurchaseParam(productDetails: product);
    _currentPurchaseProductId = product.id;
    _currentPurchaseCallback = completer;

    Future<bool> future =
        InAppPurchase.instance.buyNonConsumable(purchaseParam: param);

    future.then((value) {
      if (value) {
        //成功发送了购买请求，等待购买事件
      } else {
        //发送购买请求失败;
        _invokePurchaseErrorCallback(product.id, null);
      }
    }, onError: (error, stackTrace) {
      if (error is PlatformException) {
        if (error.code == "storekit_duplicate_product_object") {
          //沙合下测试时，重复购买时仍能调起支付弹窗，所以不需要发送错误回调，
          //但是生产环境下没有验证过时否表现相同
          return;
        }
      }
      _invokePurchaseErrorCallback(product.id, error);
    });
  }

  void _onPurchaseEvent(List<PurchaseDetails> details) {
    List<PurchaseDetails> pending = [];

    for (PurchaseDetails purchase in details) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          break;

        case PurchaseStatus.purchased:
          pending.add(purchase);
          break;

        case PurchaseStatus.error:
          //购买时发生了错误
          if (Platform.isIOS) {
            if (purchase.error!.details is Map) {
              var err = purchase.error!.details["NSUnderlyingError"];
              if (err is Map) {
                var userInfo = err["userInfo"];
                if (userInfo is Map) {
                  err = userInfo["NSUnderlyingError"];
                  if (err is Map) {
                    if (err["code"] == 6) {
                      //用户取消了购买弹窗
                      _invokePurchaseErrorCallback(
                          purchase.productID, CancelPurchaseException());
                      InAppPurchase.instance.completePurchase(purchase);
                      break;
                    }
                  }
                }
              }
            }
          } else if (Platform.isAndroid) {
            if ("1" == purchase.error!.code) {
              //用户取消了购买弹窗
              _invokePurchaseErrorCallback(
                  purchase.productID, CancelPurchaseException());
              InAppPurchase.instance.completePurchase(purchase);
              break;
            }
          }

          _invokePurchaseErrorCallback(purchase.productID, purchase.error);
          InAppPurchase.instance.completePurchase(purchase);
          break;

        case PurchaseStatus.restored:
          pending.add(purchase);
          break;

        case PurchaseStatus.canceled:
          //目前还不清楚这个枚举是什么时候调用，官网上没有找到相应的调用逻辑
          _invokePurchaseErrorCallback(
              purchase.productID, CancelPurchaseException());
          InAppPurchase.instance.completePurchase(purchase);
          break;
      }
    }

    _verifyPurchase(pending);
  }

  void _onPurchaseError(Object error) {
    //购买发生了错误
    _invokePurchaseErrorCallback(null, error);
  }

  void _onPurchaseDone() {
    if (_subscription != null) {
      _subscription!.cancel();
      _subscription = null;
    }
  }

  void _verifyPurchase(List<PurchaseDetails> pending) {
    for (PurchaseDetails details in pending) {
      Future<List<VerifiedPurchaseInfo>> future;
      if (Platform.isIOS) {
        future = _verifyPurchaseForIos(details);
      } else if (Platform.isAndroid) {
        future = _verifyPurchaseForAndroid(details);
      } else {
        continue;
      }

      future.then((list) {
        bool found = false;
        for (VerifiedPurchaseInfo info in list) {
          if (info.isValid()) {
            //找到有效的购买信息，则尝试发送成功事件。
            _purchased[info.productId] = info;
            _invokePurchaseCallback(info);
            _invokeRestoreCallback(info);
            _onValidPurchase(info, details.status == PurchaseStatus.restored);
            found = true;
          } else {
            //更新已存在的购买信息
            VerifiedPurchaseInfo? old = _purchased[info.productId];
            if (old != null && old.transactionId == info.transactionId) {
              _purchased[info.productId] = info;
            }
          }
        }

        if (details.status == PurchaseStatus.purchased &&
            !found &&
            _currentPurchaseCallback != null &&
            _currentPurchaseProductId == details.productID) {
          //购买成功却没有有效的购买信息，则可能是手机上的时间不正确，这里发送一个错误回调
          _invokePurchaseErrorCallback(
              details.productID, DeviceStatusException());
        }
        return _savePurchaseInfoToStore();
      }, onError: (error, stackTrace) {
        error = error ??
            InAppPurchaseException(
                source: kSourcePurchaseManage,
                code: kErrorCodePurchaseManageVerifyError);
        //验证失败
        _invokePurchaseErrorCallback(details.productID, error);
      }).whenComplete(() {
        //结束购买流程
        if (details.pendingCompletePurchase)
          InAppPurchase.instance.completePurchase(details);
      });
    }
  }

  Future<String?> getUserId() async {
    return Global.getUserId();
  }

  ///
  /// 可以在这里记录事件
  void _onValidPurchase(VerifiedPurchaseInfo info, bool isRestored) {
    var products = _products[info.productId];

    getUserId().then((value) {
      String userId = value ?? "";

      print("resultValue: transactionId${info.transactionId}");

      //TODO:国家码：cn
      FlutterSimCountryCode.simCountryCode.then((value) {
        try {
          //   //TODO:订单上传
          // PurchaseSuccessUtil.getOrderUpload(dioUrl,
          //     userId: userId,
          //     orderId: info.transactionId,
          //     currency: products!.currencyCode,
          //     country: value ?? "us",
          //     price: products.rawPrice,
          //     purchaseTime: DateTime.now().millisecondsSinceEpoch.toString());
        } catch (e) {}
      }).onError((error, stackTrace) {
        print("resultValue: country model us");
        //TODO：未插sim卡默认us
        try {
          //   //TODO:订单上传 ==威哥：订单可以重复上传没关系，只要是前端发起的就可以上传 对，不需管是否是第一次
          // PurchaseSuccessUtil.getOrderUpload(dioUrl,
          //     userId: userId,
          //     orderId: info.transactionId,
          //     currency: products!.currencyCode,
          //     country: "us",
          //     price: products.rawPrice,
          //     purchaseTime: DateTime.now().millisecondsSinceEpoch.toString());
        } catch (e) {}
      });

      if (info.isSubscription() && info.isFirstSubscription()) {
        //首次订阅，注意需要判断 isRestored，如果是恢复购买的情况需要酌情处理
        if (!isRestored) {
          print(
              "price = ${products?.price.toString()} , currencyCode = ${products?.currencyCode} , transactionId = ${info.transactionId} , receipt = ${info.receipt} , TransactionDate = ${info.purchaseDate.toString()}");
        } else {}
      }
      if (!info.isSubscription()) {
        //续期或非订阅类型商品
        //意需要判断 isRestored，如果是恢复购买的情况需要酌情处理
        if (!isRestored) {
        } else {}
      }
    });
  }

  Future _loadPurchaseInfoFromStore() {
    return SharedPreferences.getInstance().then((prefs) {
      String? data = prefs.getString("verified_purchased_info");
      if (data != null) {
        var json = jsonDecode(data);
        //todo 把json打印出来
        print("data = $data");
        for (var value in (json as Map).values) {
          VerifiedPurchaseInfo info = VerifiedPurchaseInfo.formJson(value);
          _purchased[info.productId] = info;
        }
      }
    });
  }

  Future _savePurchaseInfoToStore() {
    return SharedPreferences.getInstance().then((prefs) {
      String json = jsonEncode(_purchased);
      prefs.setString("verified_purchased_info", json);
    });
  }

  void _invokePurchaseErrorCallback(String? productId, Object? error) {
    String? targetProductId = _currentPurchaseProductId;
    Completer<VerifiedPurchaseInfo>? completer = _currentPurchaseCallback;
    if (completer != null && !completer.isCompleted) {
      if (productId != null && productId != targetProductId) {
        return;
      }

      completer.completeError(error ??
          InAppPurchaseException(
              source: kSourcePurchaseManage,
              code: kErrorCodePurchaseManagePurchaseError));
      _cleanPurchaseCallback();
    }
  }

  void _invokePurchaseCallback(VerifiedPurchaseInfo info) {
    if (info.productId == _currentPurchaseProductId) {
      Completer<VerifiedPurchaseInfo>? completer = _currentPurchaseCallback;
      if (completer != null) {
        completer.complete(info);
        _cleanPurchaseCallback();
      }
    }
  }

  void _cleanPurchaseCallback() {
    _currentPurchaseCallback = null;
    _currentPurchaseProductId = null;
  }

  void _invokeRestoreCallback(VerifiedPurchaseInfo info) {
    StreamController<VerifiedPurchaseInfo>? controller =
        _currentRestoreCallback;
    if (controller != null) {
      controller.add(info);
    }
  }

  void _cleanRestoreCallback() {
    _currentRestoreCallback = null;
  }

  Future<List<VerifiedPurchaseInfo>> _verifyPurchaseForIos(
      PurchaseDetails details) {
    Options options = Options(method: 'post');
    options.sendTimeout = 60000;
    options.receiveTimeout = 60000;
    options.responseType = ResponseType.json;

    return _verifyPurchaseForAppleServer(
        "https://buy.itunes.apple.com/verifyReceipt",
        options,
        details.verificationData.localVerificationData);
  }

  Future<List<VerifiedPurchaseInfo>> _verifyPurchaseForAppleServer(
      String url, Options options, String receipt) {
    Dio dio = Dio();
    Future<Response> future = dio.post(url,
        data: {"receipt-data": receipt, "password": _key}, options: options);

    return future.then((response) {
      if (response.statusCode == HttpStatus.ok) {
        if (response.data["status"] == 21007) {
          //沙盒验证
          return _verifyPurchaseForAppleServer(
              "https://sandbox.itunes.apple.com/verifyReceipt",
              options,
              receipt);
        } else if (response.data["status"] != 0) {
          return Future.error(InAppPurchaseException(
              source: kSourcePurchaseManage,
              code: kErrorCodePurchaseManageVerifyError,
              message: "status code: ${response.data["status"]}"));
        } else {
          //JSON -> Model
          return VerifiedPurchaseInfo.fromResponse(response, receipt);
        }
      } else {
        return Future.error(HttpException(
            "Http status code: ${response.statusCode}",
            uri: response.realUri));
      }
    }, onError: (error, stackTrace) {
      return Future.error(error ??
          InAppPurchaseException(
              source: kSourcePurchaseManage,
              code: kErrorCodePurchaseManageVerifyError));
    });
  }

  Future<List<VerifiedPurchaseInfo>> _verifyPurchaseForAndroid(
      PurchaseDetails details) {
    Completer<List<VerifiedPurchaseInfo>>? completer = Completer();
    completer.completeError(InAppPurchaseException(
        source: kSourcePurchaseManage,
        code: kErrorCodePurchaseManageVerifyError,
        message: "not support"));
    return completer.future;
  }
}

class CancelPurchaseException implements Exception {
  CancelPurchaseException();
}

class ReInvokeException implements Exception {
  ReInvokeException();
}

class DeviceStatusException implements Exception {
  DeviceStatusException();
}

class VerifiedPurchaseInfo {
  String? _productId;
  int? _expiresDate;
  String? _transactionId;
  String? _originalTransactionId;
  int? _purchaseDate;
  int? _originalPurchaseDate;
  bool? _isTrialPeriod;
  bool? _isSandbox;
  int? _cancellationDate;
  String? _receipt;

  ///商品 ID
  String get productId => _productId!;

  String? get receipt => _receipt!;

  set setReceipt(String? receipt) {
    this._receipt = receipt;
  }

  ///订阅过期时间，自 1970 年以来的毫秒数。非订阅商品此值为 -1。
  int get expiresDate => _expiresDate!;

  ///交易 ID
  String get transactionId => _transactionId!;

  ///原始交易 ID，如果是首笔交易则与 transactionId 相同
  String get originalTransactionId => _originalTransactionId!;

  ///购买时间，自 1970 年以来的毫秒数。
  int get purchaseDate => _purchaseDate!;

  ///原始交易购买时间，自 1970 年以来的毫秒数。
  int get originalPurchaseDate => _originalPurchaseDate!;

  ///是否是试用期
  bool get isTrialPeriod => _isTrialPeriod!;

  ///交易取消（退款或撤消）的时间，自 1970 年以来的毫秒数。-1 表示没有取消。
  int get cancellationDate => _cancellationDate!;

  ///是否是沙盒环境
  bool get isSandbox => _isSandbox!;

  VerifiedPurchaseInfo.formJson(var json, {bool? sandbox, String? receipt}) {
    _productId = json["product_id"];
    _transactionId = json["transaction_id"];
    _receipt = receipt;
    _originalTransactionId = json["original_transaction_id"] ?? _transactionId;
    _purchaseDate = int.parse(json["purchase_date_ms"]);
    _originalPurchaseDate = int.parse(
        json["original_purchase_date_ms"] ?? json["purchase_date_ms"]);
    _isTrialPeriod = false;
    String? value = json["is_trial_period"];
    if (value != null) {
      _isTrialPeriod = value == "true";
    }

    value = json["expires_date_ms"];
    if (value != null) {
      _expiresDate = int.parse(value);
    } else {
      _expiresDate = -1;
    }

    value = json["cancellation_date_ms"];
    if (value != null) {
      _cancellationDate = int.parse(value);
    } else {
      _cancellationDate = -1;
    }

    _isSandbox = sandbox ?? false;
    value = json["is_sandbox"]; //自定义的属性
    if (value != null) {
      _isSandbox = value == "true";
    }
  }

  static List<VerifiedPurchaseInfo> fromResponse(
      Response response, String receipt) {
    List<VerifiedPurchaseInfo> results = [];
    var json = response.data;
    bool isSandbox = "Sandbox" == json["environment"] ? true : false;

    List receipts = json["latest_receipt_info"] as List;
    for (var receipt in receipts) {
      results.add(VerifiedPurchaseInfo.formJson(receipt,
          sandbox: isSandbox, receipt: json["latest_receipt"]));
    }
    return results;
  }

  ///
  /// 交易是否有效
  bool isValid() {
    if (_cancellationDate! > -1) {
      return false;
    }

    if (_expiresDate! > -1 &&
        DateTime.now().millisecondsSinceEpoch > _expiresDate!) {
      return false;
    }

    return true;
  }

  Map toJson() {
    Map<String, Object> json = {};
    json["product_id"] = _productId!;
    json["transaction_id"] = _transactionId!;
    json["original_transaction_id"] = _originalTransactionId!;
    json["purchase_date_ms"] = _purchaseDate!.toString();
    json["original_purchase_date_ms"] = _originalPurchaseDate!.toString();
    json["is_trial_period"] = _isTrialPeriod!.toString();
    json["expires_date_ms"] = _expiresDate!.toString();
    json["cancellation_date_ms"] = _cancellationDate!.toString();
    json["is_sandbox"] = _isSandbox!.toString();
    return json;
  }

  VerifiedPurchaseInfo._empty() {
    _productId = "";
    _transactionId = "";
    _originalTransactionId = "";
    _purchaseDate = 0;
    _originalPurchaseDate = 0;
    _isTrialPeriod = false;
    _expiresDate = -1;
    _cancellationDate = 0;
    _isSandbox = false;
  }

  ///是否是订阅商品
  bool isSubscription() {
    return _expiresDate! > 0;
  }

  ///是否是首次订阅
  bool isFirstSubscription() {
    return _transactionId == _originalTransactionId;
  }

  bool isEmpty() {
    return _productId == "";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerifiedPurchaseInfo &&
          runtimeType == other.runtimeType &&
          _productId == other._productId &&
          _transactionId == other._transactionId;

  @override
  int get hashCode => _productId.hashCode ^ _transactionId.hashCode;

  static VerifiedPurchaseInfo? _emptyInstance;

  factory VerifiedPurchaseInfo.empty() {
    _emptyInstance ??= VerifiedPurchaseInfo._empty();
    return _emptyInstance!;
  }
}
