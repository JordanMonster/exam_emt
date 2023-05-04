/// signature : "dfreree...."
/// purchase-info : "ewoJIm9x....."
/// environment : "Sandbox"
/// pod : "100"
/// signing-status : "0"

class IOSVerifyData {
  IOSVerifyData({
    String? signature,
    String? purchaseInfo,
    String? environment,
    String? pod,
    String? signingStatus,
  }) {
    _signature = signature;
    _purchaseInfo = purchaseInfo;
    _environment = environment;
    _pod = pod;
    _signingStatus = signingStatus;
  }

  IOSVerifyData.fromJson(dynamic json) {
    _signature = json['signature'];
    _purchaseInfo = json['purchase-info'];
    _environment = json['environment'];
    _pod = json['pod'];
    _signingStatus = json['signing-status'];
  }

  String? _signature;
  String? _purchaseInfo;
  String? _environment;
  String? _pod;
  String? _signingStatus;

  String? get signature => _signature;

  String? get purchaseInfo => _purchaseInfo;

  String? get environment => _environment;

  String? get pod => _pod;

  String? get signingStatus => _signingStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['signature'] = _signature;
    map['purchase-info'] = _purchaseInfo;
    map['environment'] = _environment;
    map['pod'] = _pod;
    map['signing-status'] = _signingStatus;
    return map;
  }
}
