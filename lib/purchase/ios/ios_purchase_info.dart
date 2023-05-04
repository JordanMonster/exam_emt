/// original-purchase-date-pst : "2017-08-29 23:52:45 America/Los_Angeles"
/// purchase-date-ms : "1504144439749"
/// unique-identifier : "a063c2c321dd885642a5cddd9160e0ad8291d978"
/// original-transaction-id : "1000000328915948"
/// expires-date : "1504144739749"
/// transaction-id : "1000000329310742"
/// original-purchase-date-ms : "1504075965000"
/// web-order-line-item-id : "1000000036091900"
/// bvrs : "1"
/// unique-vendor-identifier : "B78549AC-58D4-4750-8E6F-F4CCE6138A5A"
/// expires-date-formatted-pst : "2017-08-30 18:58:59 America/Los_Angeles"
/// item-id : "1276511095"
/// expires-date-formatted : "2017-08-31 01:58:59 Etc/GMT"
/// product-id : "lcm.denachina.pickle.38.1month"
/// purchase-date : "2017-08-31 01:53:59 Etc/GMT"
/// original-purchase-date : "2017-08-30 06:52:45 Etc/GMT"
/// bid : "com.denachina.pickle"
/// purchase-date-pst : "2017-08-30 18:53:59 America/Los_Angeles"
/// quantity : "1"

class IOSPurchaseInfo {
  IOSPurchaseInfo({
    String? originalPurchaseDatePst,
    String? purchaseDateMs,
    String? uniqueIdentifier,
    String? originalTransactionId,
    String? expiresDate,
    String? transactionId,
    String? originalPurchaseDateMs,
    String? webOrderLineItemId,
    String? bvrs,
    String? uniqueVendorIdentifier,
    String? expiresDateFormattedPst,
    String? itemId,
    String? expiresDateFormatted,
    String? productId,
    String? purchaseDate,
    String? originalPurchaseDate,
    String? bid,
    String? purchaseDatePst,
    String? quantity,
  }) {
    _originalPurchaseDatePst = originalPurchaseDatePst;
    _purchaseDateMs = purchaseDateMs;
    _uniqueIdentifier = uniqueIdentifier;
    _originalTransactionId = originalTransactionId;
    _expiresDate = expiresDate;
    _transactionId = transactionId;
    _originalPurchaseDateMs = originalPurchaseDateMs;
    _webOrderLineItemId = webOrderLineItemId;
    _bvrs = bvrs;
    _uniqueVendorIdentifier = uniqueVendorIdentifier;
    _expiresDateFormattedPst = expiresDateFormattedPst;
    _itemId = itemId;
    _expiresDateFormatted = expiresDateFormatted;
    _productId = productId;
    _purchaseDate = purchaseDate;
    _originalPurchaseDate = originalPurchaseDate;
    _bid = bid;
    _purchaseDatePst = purchaseDatePst;
    _quantity = quantity;
  }

  IOSPurchaseInfo.fromJson(dynamic json) {
    _originalPurchaseDatePst = json['original-purchase-date-pst'];
    _purchaseDateMs = json['purchase-date-ms'];
    _uniqueIdentifier = json['unique-identifier'];
    _originalTransactionId = json['original-transaction-id'];
    _expiresDate = json['expires-date'];
    _transactionId = json['transaction-id'];
    _originalPurchaseDateMs = json['original-purchase-date-ms'];
    _webOrderLineItemId = json['web-order-line-item-id'];
    _bvrs = json['bvrs'];
    _uniqueVendorIdentifier = json['unique-vendor-identifier'];
    _expiresDateFormattedPst = json['expires-date-formatted-pst'];
    _itemId = json['item-id'];
    _expiresDateFormatted = json['expires-date-formatted'];
    _productId = json['product-id'];
    _purchaseDate = json['purchase-date'];
    _originalPurchaseDate = json['original-purchase-date'];
    _bid = json['bid'];
    _purchaseDatePst = json['purchase-date-pst'];
    _quantity = json['quantity'];
  }

  String? _originalPurchaseDatePst;
  String? _purchaseDateMs;
  String? _uniqueIdentifier;
  String? _originalTransactionId;
  String? _expiresDate;
  String? _transactionId;
  String? _originalPurchaseDateMs;
  String? _webOrderLineItemId;
  String? _bvrs;
  String? _uniqueVendorIdentifier;
  String? _expiresDateFormattedPst;
  String? _itemId;
  String? _expiresDateFormatted;
  String? _productId;
  String? _purchaseDate;
  String? _originalPurchaseDate;
  String? _bid;
  String? _purchaseDatePst;
  String? _quantity;

  String? get originalPurchaseDatePst => _originalPurchaseDatePst;

  String? get purchaseDateMs => _purchaseDateMs;

  String? get uniqueIdentifier => _uniqueIdentifier;

  String? get originalTransactionId => _originalTransactionId;

  String? get expiresDate => _expiresDate;

  String? get transactionId => _transactionId;

  String? get originalPurchaseDateMs => _originalPurchaseDateMs;

  String? get webOrderLineItemId => _webOrderLineItemId;

  String? get bvrs => _bvrs;

  String? get uniqueVendorIdentifier => _uniqueVendorIdentifier;

  String? get expiresDateFormattedPst => _expiresDateFormattedPst;

  String? get itemId => _itemId;

  String? get expiresDateFormatted => _expiresDateFormatted;

  String? get productId => _productId;

  String? get purchaseDate => _purchaseDate;

  String? get originalPurchaseDate => _originalPurchaseDate;

  String? get bid => _bid;

  String? get purchaseDatePst => _purchaseDatePst;

  String? get quantity => _quantity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['original-purchase-date-pst'] = _originalPurchaseDatePst;
    map['purchase-date-ms'] = _purchaseDateMs;
    map['unique-identifier'] = _uniqueIdentifier;
    map['original-transaction-id'] = _originalTransactionId;
    map['expires-date'] = _expiresDate;
    map['transaction-id'] = _transactionId;
    map['original-purchase-date-ms'] = _originalPurchaseDateMs;
    map['web-order-line-item-id'] = _webOrderLineItemId;
    map['bvrs'] = _bvrs;
    map['unique-vendor-identifier'] = _uniqueVendorIdentifier;
    map['expires-date-formatted-pst'] = _expiresDateFormattedPst;
    map['item-id'] = _itemId;
    map['expires-date-formatted'] = _expiresDateFormatted;
    map['product-id'] = _productId;
    map['purchase-date'] = _purchaseDate;
    map['original-purchase-date'] = _originalPurchaseDate;
    map['bid'] = _bid;
    map['purchase-date-pst'] = _purchaseDatePst;
    map['quantity'] = _quantity;
    return map;
  }
}
