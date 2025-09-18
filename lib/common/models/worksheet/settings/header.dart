import 'package:jobprogress/core/utils/helpers.dart';

class WorksheetHeaderSetting {
  bool? jobId;
  bool? jobName;
  bool? jobNumber;
  bool? estimateNumber;
  bool? estimateDate;
  bool? contractorLicenseNumber;
  bool? customerRepName;
  bool? customerRepEmail;
  bool? customerRepPhone;
  bool? hideAmount;

  WorksheetHeaderSetting({
    this.jobId,
    this.jobName,
    this.jobNumber,
    this.estimateNumber,
    this.estimateDate,
    this.contractorLicenseNumber,
    this.customerRepName,
    this.customerRepEmail,
    this.customerRepPhone,
    this.hideAmount,
  });

  WorksheetHeaderSetting.fromJson(Map<String, dynamic>? json) {
    jobId = Helper.isTrue(json?['job_id']);
    jobName = Helper.isTrue(json?['job_name']);
    jobNumber = Helper.isTrue(json?['job_number']);
    estimateNumber = Helper.isTrue(json?['estimate_number']);
    estimateDate = Helper.isTrue(json?['estimate_date']);
    contractorLicenseNumber = Helper.isTrue(json?['contractor_license_number']);
    customerRepName = Helper.isTrue(json?['customer_rep_name']);
    customerRepEmail = Helper.isTrue(json?['customer_rep_email']);
    customerRepPhone = Helper.isTrue(json?['customer_rep_phone']);
    hideAmount = Helper.isTrue(json?['hide_amount']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['job_id'] = jobId;
    data['job_name'] = jobName;
    data['job_number'] = jobNumber;
    data['estimate_number'] = estimateNumber;
    data['estimate_date'] = estimateDate;
    data['contractor_license_number'] = contractorLicenseNumber;
    data['customer_rep_name'] = customerRepName;
    data['customer_rep_email'] = customerRepEmail;
    data['customer_rep_phone'] = customerRepPhone;
    data['hide_amount'] = hideAmount;
    return data;
  }
}
