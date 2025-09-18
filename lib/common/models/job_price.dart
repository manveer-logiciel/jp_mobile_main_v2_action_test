class JobPriceModel {
  int? id;
  int? approvedBy;
  int? companyId;
  int? jobId;
  int? rejectedBy;
  int? requestedBy;
  String? amount;

  JobPriceModel({
    this.id,
    this.approvedBy,
    this.companyId,
    this.jobId,
    this.rejectedBy,
    this.requestedBy,
    this.amount,
  });

  JobPriceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    approvedBy = json['approved_by'];
    companyId = json['company_id'];
    jobId = json['job_id'];
    rejectedBy = json['rejected_by'];
    requestedBy = json['requested_by'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['approved_by'] = approvedBy;
    data['company_id'] = companyId;
    data['job_id'] = jobId;
    data['rejected_by'] = rejectedBy;
    data['requested_by'] = requestedBy;
    data['amount'] = amount;
    return data;
  }
}