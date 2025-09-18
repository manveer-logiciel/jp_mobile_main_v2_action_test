class NotificationBodyModel {
  String? type;
  String? objectType;
  String? completedBy;
  String? threadId;
  int? appointmentId;
  int? scheduleId;
  int? customerId;
  int? objectId;
  int? jobId;

  NotificationBodyModel({
    this.type,
    this.completedBy,
    this.appointmentId,
    this.scheduleId,
    this.customerId,
    this.jobId,
    this.objectId
  });

  NotificationBodyModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    completedBy = json['completed_by'];
    threadId = json['thread_id'];
    appointmentId = json['appointment_id'];
    scheduleId = json['schedule_id'];
    objectId = json['object_id'];
    objectType = json['object_type'];
    if(json['customer_id'] is int) {
      customerId = json['customer_id'];
    }
    if(json['job_id'] is int) {
      jobId = json['job_id'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['completed_by'] = completedBy;
    data['thread_id'] = threadId;
    return data;
  }
}
