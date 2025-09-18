class JobPriceDialogModel {
  int? taxable;
  num? amount;
  num? total;
  num? taxRate;
  num? taxAmount;
  int? jobId;
  int? customTaxId;
  bool? isDerivedTax;

  JobPriceDialogModel({
    this.taxable = 1,
    this.amount,
    this.total,
    this.taxRate,
    this.taxAmount,
    this.jobId,
    this.customTaxId,
    this.isDerivedTax = false,
  });

  @override
  bool operator ==(Object other) {
    return (other is JobPriceDialogModel)
        && other.taxable == taxable
        && other.amount == amount
        && other.total == total
        && other.taxRate == taxRate
        && other.taxAmount == taxAmount
        && other.jobId == jobId
        && other.customTaxId == customTaxId
        && other.isDerivedTax == isDerivedTax;
  }

  @override
  int get hashCode => 0;

  factory JobPriceDialogModel.copy(JobPriceDialogModel params) => JobPriceDialogModel(
    taxable: params.taxable,
    amount: params.amount,
    total: params.total,
    taxRate: params.taxRate,
    taxAmount: params.taxAmount,
    jobId: params.jobId,
    customTaxId: params.customTaxId,
    isDerivedTax: params.isDerivedTax,
  );

  JobPriceDialogModel.fromJson(Map<String, dynamic> json) {
    amount = double.parse(json['amount']?.toString() ?? "0");
    taxRate = double.parse(json['tax_rate']?.toString() ?? "0");
    taxable = int.parse(json['taxable']?.toString() ?? "0");
    customTaxId = int.tryParse(json['custom_tax_id']?.toString() ?? "");
    total = double.parse(json['total']?.toString() ?? "0");
    taxAmount = double.parse(json['taxAmount']?.toString() ?? "0");
    isDerivedTax = int.parse(json['is_derived_tax']?.toString() ?? "0") == 1;
    jobId = int.tryParse(json['job_id']?.toString() ?? "");
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      "includes[0]": "created_by"
    };
    data['amount'] = amount;
    data['tax_rate'] = taxable == 0 ? '' : taxRate;
    data['taxable'] = taxRate == 0 ? 0 : taxable;
    data['custom_tax_id'] = customTaxId;
    data['total'] = total;
    data['taxAmount'] =  taxable == 0 ? 0 : taxAmount;
    data['is_derived_tax'] = (isDerivedTax ?? false) ? 1 : 0;
    data['job_id'] = jobId;
    return data;
  }
}