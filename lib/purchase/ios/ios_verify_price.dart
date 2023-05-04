// id = "asvab.vip"
// title = "ASVAB Premium"
// description = "Unlock all content&features"
// price = "$4.99"
// rawPrice = 4.99
// currencyCode = "USD"
// currencySymbol = "$"

class IOSVerifyPrice {
  IOSVerifyPrice({
    String? sku,
    String? price,
    double? rawPrice,
    String? currencySymbol,
  }) {
    _sku = sku;
    _price = price;
    _rawPrice = rawPrice;
    _currencySymbol = currencySymbol;
  }

  IOSVerifyPrice.fromJson(dynamic json) {
    _sku = json['id'];
    _price = json['price'];
    _rawPrice = json['rawPrice'];
    _currencySymbol = json['currencySymbol'];
  }

  String? _sku;
  String? _price;
  double? _rawPrice;
  String? _currencySymbol;

  double? get getRawPrice => _rawPrice;

  String? get getSku => _sku;

  String? get getPrice => _price;

  String? get getCurrencySymbol => _currencySymbol;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _sku;
    map['price'] = _price;
    map['rawPrice'] = _rawPrice;
    map['currencySymbol'] = _currencySymbol;

    return map;
  }
}
