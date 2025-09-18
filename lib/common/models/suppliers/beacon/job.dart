class BeaconJobModel {
  int? accountId;
  String? jobName;
  String? jobNumber;
  int? isChecked;
  int? hasJobAccount;
  int? poRequired;
  int? extendPoRequired;
  int? hasJobNumber;
  int? isJobAccountRequired;

  BeaconJobModel({
    this.accountId,
    this.jobName,
    this.jobNumber,
    this.isChecked,
    this.hasJobAccount,
    this.poRequired,
    this.extendPoRequired,
    this.hasJobNumber,
    this.isJobAccountRequired,
  });

  BeaconJobModel.fromJson(Map<String, dynamic> json) {
    if (json['account_id'] != null) {
      accountId = int.tryParse(json['account_id'].toString());
    }
    jobName = json['job_name'];
    jobNumber = json['job_number'];
    isChecked = json['is_checked'];
    hasJobAccount = json['has_job_account'];
    poRequired = json['po_required'];
    extendPoRequired = json['extend_po_required'];
    hasJobNumber = json['has_job_number'];
    isJobAccountRequired = json['is_job_account_required'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['account_id'] = accountId;
    data['job_name'] = jobName;
    data['job_number'] = jobNumber;
    data['is_checked'] = isChecked;
    data['has_job_account'] = hasJobAccount;
    data['po_required'] = poRequired;
    data['extend_po_required'] = extendPoRequired;
    data['has_job_number'] = hasJobNumber;
    data['is_job_account_required'] = isJobAccountRequired;
    return data;
  }
}
