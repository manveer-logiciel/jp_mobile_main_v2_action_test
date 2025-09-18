class SubscriptionPlanModel {
  int? productId;
  String? title;
  int? amount;
  String? product;
  String? code;

  SubscriptionPlanModel({
    this.productId,
    this.title,
    this.amount,
    this.product,
    this.code,
  });

  SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    title = json['title'];
    amount = json['amount'];
    product = json['product'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['product_id'] = productId;
    data['title'] = title;
    data['amount'] = amount;
    data['product'] = product;
    data['code'] = code;
    return data;
  }
}
