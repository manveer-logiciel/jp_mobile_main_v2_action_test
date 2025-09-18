import 'package:jobprogress/common/models/sql/user/user_limited.dart';

class FinancialJobPriceRequestDetail {
  int? id;
  int? jobId;
  String? amount;
  int? taxable;
  num? taxRate;
  int? isDerivedTax;
  UserLimitedModel? requestedBy;

  FinancialJobPriceRequestDetail({
    this.id,
    this.jobId,
    this.amount,
    this.taxable,
    this.taxRate,
    this.isDerivedTax,
    this.requestedBy
  });

  FinancialJobPriceRequestDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobId = json['job_id'];
    amount = json['amount'];
    taxable = json['taxable'];
    taxRate = json['tax_rate'];
    isDerivedTax = json['is_derived_tax'];
    requestedBy = json['requested_by'] != null ?  UserLimitedModel.fromJson(json['requested_by']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['job_id'] = jobId;
    data['amount'] = amount;
    data['taxable'] = taxable;
    data['tax_rate'] = taxRate;
    data['is_derived_tax'] = isDerivedTax;
    if (requestedBy != null) {
      data['requested_by'] = requestedBy!.toJson();
    }
    return data;
  }
}