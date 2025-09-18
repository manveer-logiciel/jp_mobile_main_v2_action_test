class CallLogCaptureModel {
  late int customerId;
  late String phoneNumber;
  late String phoneLabel;
  int? jobId;
  int? jobContactId;

  CallLogCaptureModel({
    required this.customerId,
    required this.phoneNumber,
    required this.phoneLabel,
    this.jobId,
    this.jobContactId
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_id'] =customerId;
    data['phone_number'] =phoneNumber;
    data['phone_label'] =phoneLabel;
    data['job_id'] =jobId;
    data['job_contact_id'] =jobContactId;
    return data;
  }
}