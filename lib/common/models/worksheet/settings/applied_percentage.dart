class WorksheetAppliedPercentage {
  String? id;
  String? type;
  num? rate;
  num? discount; 
  num? commission;
  num? feeRate;
  late bool isDefault;

  WorksheetAppliedPercentage({
    this.id,
    this.type,
    this.rate,
    this.discount,
    this.isDefault = true,
    this.commission,
    this.feeRate,
  });

  WorksheetAppliedPercentage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    rate = num.tryParse(json['tax_rate'].toString());
    discount = num.tryParse(json['discount'].toString());
    rate ??= commission = num.tryParse(json['commission'].toString());
    rate ??= feeRate = num.tryParse(json['fee_rate'].toString());
    isDefault = type == 'default';
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['tax_rate'] = rate;
    data['discount'] = discount;
    if (commission != null)data['commission'] = commission;
    if (feeRate != null) data['fee_rate'] = feeRate;
    return data;
  }
}
