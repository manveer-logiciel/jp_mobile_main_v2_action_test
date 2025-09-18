class RecurringEmailSchedulerModel{
  int? id;
  String? status;
  String? createdAt;
  String? scheduleDate;
  String? statusUpdatedAt;
  bool isFirstEmail = false;
  bool isLastEmail = false;
  int? emailDetailId;

  RecurringEmailSchedulerModel({
    this.id,
    this.createdAt,
    this.scheduleDate,
    this.statusUpdatedAt,
    this.emailDetailId,
    this.status,
    this.isLastEmail = false,
    this.isFirstEmail = false,
    
  });

  RecurringEmailSchedulerModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['drip_campaign_id']?.toString() ?? '');
    if(json['email_details'] != null && json['email_details']['created_at'] != null ){
      createdAt =  json['email_details']['created_at'];
    }
    if(json['email_details'] != null && json['email_details']['id'] != null ){
      emailDetailId =  json['email_details']['id'];
    }
    status = json['status'];
    scheduleDate = json['schedule_date'];
    statusUpdatedAt = json['status_updated_at'];
  }
}

