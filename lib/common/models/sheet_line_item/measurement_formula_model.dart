class MeasurementFormulaModel {
  late int id;
  late int tradeId;
  late int productId;
  late String formula;

  MeasurementFormulaModel({
    required this.id,
    required this.tradeId,
    required this.productId,
    required this.formula
  });

  MeasurementFormulaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tradeId = json['trade_id'];
    productId = json['product_id'];
    formula = json['formula'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = id;
    json['trade_id'] = tradeId;
    json['product_id'] = productId;
    json['formula'] = formula;
    return json;
  }
}

  

