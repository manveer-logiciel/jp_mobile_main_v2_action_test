class PaymentStatusSyncModel {
  String? status;
  String? paymentId;
  String? failedReason;

  bool get isSucceeded => status?.toLowerCase() == 'succeeded';
  bool get isFailed => status?.toLowerCase() == 'failed';

  PaymentStatusSyncModel({this.status, this.paymentId, this.failedReason});

  PaymentStatusSyncModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;
    status = json['status'];
    paymentId = json['payment_id'];
    failedReason = json['failed_reason'];
  }
}