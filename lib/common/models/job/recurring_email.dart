import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/job/recurring_email_scheduler.dart';

class RecurringEmailModel{
  int? id;
  String? repeat;
  String? occurrence;
  String? status;
  String? currentStageCode;
  String? endStageCode;
  String? startDateTime;
  List<String>? byDay;
  String? byMonth;
  int? interval;
  String? subject;
  String? untilDate;
  List<AttachmentResourceModel>? attachments;
  List<RecurringEmailSchedulerModel>? scheduleEmail;
  String? cancelNote;
  String? updatedAt;
  String? createdAt;
  String? endDateTime;
  bool occuranceActive = false;
  bool occuranceNever = true;
  bool occuranceOn = false;
  bool showHistoryButton = false;
  bool showHistory = false;
  String? canceledBy;

  RecurringEmailModel({
    this.id,
    this.repeat,
    this.scheduleEmail,
    this.subject,
    this.endDateTime,
    this.untilDate,
    this.updatedAt,
    this.createdAt,
    this.startDateTime,
    this.occurrence,
    this.byDay,
    this.status,
    this.interval,
    this.byMonth,
    this.attachments,
    this.currentStageCode,
    this.endStageCode,
    this.occuranceNever = true,
    this.occuranceActive = false,
    this.occuranceOn =false,
    this.showHistory = false,
    this.showHistoryButton = false,
    this.canceledBy,
  });

  RecurringEmailModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
    repeat = json['repeat'];
    if(json['email'] != null && json['email']['subject'] != null){
      subject = json['email']['subject'];
    }
    occurrence = json['occurence'];
    status = json['status'];
    interval = json['interval'];
    untilDate = json['until_date'];
    currentStageCode = json['job_current_stage_code'];
    endStageCode = json['job_end_stage_code'];
    if (json['email'] != null && json['email']['attachments'] != null) {
      attachments = <AttachmentResourceModel>[];
      json['email']['attachments']['data'].forEach((dynamic v) {
        attachments!.add(AttachmentResourceModel.fromJson(v));
      });
    }

    if (json['drip_campaign_schedulers'] != null) {
      scheduleEmail = <RecurringEmailSchedulerModel>[];
      json['drip_campaign_schedulers']['data'].forEach((dynamic v) {
           scheduleEmail!.add(RecurringEmailSchedulerModel.fromJson(v));
      });
    }
   if(json['canceled_by'] != null && json['canceled_by']['full_name'] !=null){
    canceledBy = json['canceled_by']['full_name'];
   }  
   cancelNote = json['canceled_note']?? ''; 
    byDay = json['by_day'].cast<String>();
  }
}

