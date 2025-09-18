
class FinancialProductPrice {
  String? color;
  String? itemCode;
  String? message;
  int? messageCode;
  String? price;
  String? selllingPrice;
  String? unit;
  int? unitConversionFactor;

  FinancialProductPrice({
    this.color,
    this.itemCode,
    this.message,
    this.messageCode,
    this.price,
    this.selllingPrice,
    this.unit,
    this.unitConversionFactor,
  });

  FinancialProductPrice.fromJson(Map<String,dynamic> json) {
    color = json['color'];
    itemCode = (json['item_code'] ?? json['itemCode'])?.toString();
    if(json['message'] is String) {
      message = json['message'];
    }
    messageCode = json['message_code'];
    price = json['price']?.toString();
    selllingPrice = json['selling_price']?.toString();
    unit = json['unit'];
    unitConversionFactor = json['unit_conversion_factor'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['color'] = color;
    map['item_code'] = itemCode;
    map['message'] = message;
    map['message_code'] = messageCode;
    map['price'] = price;
    map['selling_price'] = selllingPrice;
    map['unit'] = unit;
    map['unit_conversion_factor'] = unitConversionFactor;
    
    return map;
  }

}