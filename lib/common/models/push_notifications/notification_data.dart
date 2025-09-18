class PushNotificationDataModel {
  int? stageResourceId;
  String? jobResourceId;
  int? objectId;
  String? objectType;
  int? companyId;
  int? jobId;
  int? customerId;
  String? type;
  int? scheduleId;
  int? jobFollowUpId;
  String? mentionBy;
  int? jobNoteId;
  int? workCrewId;
  int? appointmentId;
  int? id;
  String? threadId;
  String? email;
  bool? multiJob;
  int? jobParentId;
  String? action;
  String? subType;
  int? worksheetId;
  String? worksheetType;
  String? customerName;
  String? customerNameMobile;
  String? jobNumber;
  int? queueId;
  int? taskId;

  PushNotificationDataModel({
    this.stageResourceId,
    this.jobResourceId,
    this.companyId,
    this.jobId,
    this.customerId,
    this.type,
    this.objectId,
    this.objectType,
    this.scheduleId,
    this.jobFollowUpId,
    this.mentionBy,
    this.jobNoteId,
    this.workCrewId,
    this.appointmentId,
    this.id,
    this.taskId,
  });

  PushNotificationDataModel.fromJson(Map<String, dynamic> json) {
    stageResourceId = json['stage_resource_id'];
    jobResourceId = json['job_resource_id'];
    companyId = json['company_id'] != null ? int.tryParse(json['company_id'].toString()) : null;
    jobId = int.tryParse(json['job_id'].toString());
    objectType = json['object_type'];
    objectId = json['object_id'];
    customerId = json['customer_id'];
    type = json['type'];
    scheduleId = json['schedule_id'];
    jobFollowUpId = json['job_follow_up_id'];
    mentionBy = json['mention_by'];
    jobNoteId = json['job_note_id'];
    workCrewId = json['work_crew_id'];
    appointmentId = json['appointment_id'];
    id = int.parse((json['id'] ?? -1).toString());
    threadId = json['thread_id'];
    email = json['email'];
    multiJob = json['multi_job'];
    jobParentId = json['job_parent_id'];
    action = json['action'];
    subType = json['sub_type'];
    worksheetId = json['worksheet_id'];
    worksheetType = json['worksheet_type'];
    customerName = json['customer_name'];
    customerNameMobile = json['customer_name_mobile'];
    jobNumber = json['job_number'];
    queueId = json['queue_id'];
    taskId =  int.tryParse(json['task_id'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['stage_resource_id'] = stageResourceId;
    data['job_resource_id'] = jobResourceId;
    data['company_id'] = companyId;
    data['job_id'] = jobId;
    data['customer_id'] = customerId;
    data['type'] = type;
    data['schedule_id'] = scheduleId;
    data['job_follow_up_id'] = jobFollowUpId;
    data['mention_by'] = mentionBy;
    data['job_note_id'] = jobNoteId;
    data['work_crew_id'] = workCrewId;
    data['appointment_id'] = appointmentId;
    data['thread_id'] = threadId;
    data['email'] = email;
    data['id'] = id;
    data['multi_job'] = multiJob;
    data['job_parent_id'] = jobParentId;
    data['action'] = action;
    data['sub_type'] = subType;
    data['worksheet_id'] = worksheetId;
    data['worksheet_type'] = worksheetType;
    data['customer_name'] = customerName;
    data['customer_name_mobile'] = customerNameMobile;
    data['job_number'] = jobNumber;
    data['queue_id'] = queueId;
    data['object_type'] = objectType;
    data['object_id'] = objectId;
    data['task_id'] = taskId;
    return data;
  }
}
