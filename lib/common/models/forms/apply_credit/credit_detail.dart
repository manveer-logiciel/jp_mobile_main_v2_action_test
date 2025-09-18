class CreditDetailModel {
  num? amount;
  int? creditId;

  CreditDetailModel({   
    this.creditId,
    this.amount,
  });

  CreditDetailModel.fromJson(Map<String, dynamic> json) {
    creditId = json['credit_id'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['credit_id'] = creditId;
    data['amount'] = amount;
    return data;
  }
}