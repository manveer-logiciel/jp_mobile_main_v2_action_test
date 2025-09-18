import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import '../job/job.dart';
import '../sql/user/user.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/appointment/appointment_result/appointment_result_option_fields.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/reminder.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'appointment_result/appointment_result_options.dart';

class AppointmentModel {
  int? id;
  String? title;
  String? description;
  String? startDateTime;
  String? endDateTime;
  String? location;
  int? customerId;
  int? jobId;
  int? userId;
  String? locationType;
  String? repeat;
  String? untilDate;
  String? seriesId;
  late bool isRecurring;
  late bool isAllDay;
  int? interval;
  bool? isCompleted;
  String? updatedAt;
  String? createdAt;
  UserModel? user;
  List<JobModel>? job;
  late bool isMultiDay;
  List<String>? byDay;
  String? occurrence;
  List<ReminderModel>? reminders;
  List<UserLimitedModel>? attendees;
  List<AttachmentResourceModel>? attachments;
  List<AppointmentResultOptionFieldModel>? results;
  AppointmentResultOptionsModel? resultOption;
  List<String>? resultOptionIds;
  UserModel? createdBy;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  CustomerModel? customer;
  List<String>? invites;
  String? formattedStartDateTime;
  String? formattedEndDateTime;

  /// [recurringId] is helps in loading appointment details,
  /// In case it is available under customer, job
  int? recurringId;

  AppointmentModel({
    this.id,
    this.title,
    this.description,
    this.startDateTime,
    this.endDateTime,
    this.location,
    this.customerId,
    this.jobId,
    this.userId,
    this.locationType,
    this.repeat,
    this.untilDate,
    this.seriesId,
    this.isRecurring = false,
    this.isAllDay = false,
    this.interval,
    this.isCompleted,
    this.updatedAt,
    this.createdAt,
    this.user,
    this.job,
    this.isMultiDay = false,
    this.attachments,
    this.byDay,
    this.occurrence,
    this.reminders,
    this.attendees,
    this.createdBy,
    this.resultOptionIds,
    this.results,
    this.customer,
    this.invites,
    this.recurringId,
  });

  AppointmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    startDateTime = json['start_date_time'];
    endDateTime = json['end_date_time'];
    location = json['location'];
    customerId = json['customer_id'];
    jobId = json['job_id'];
    userId = json['user_id'];
    locationType = json['location_type'];
    repeat = json['repeat'];
    untilDate = json['until_date'];
    seriesId = json['series_id'];
    isRecurring = json['is_recurring'] ?? false;
    isAllDay = json['full_day'] == 1 ? true : false;
    interval = json['interval'];
    isCompleted = json['is_completed'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    if(json['attendees']?['data'] != null) {
      attendees = [];
      json['attendees']['data'].forEach((dynamic attendee) {
        attendees!.add(UserLimitedModel.fromJson(attendee));
      });
    }
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    if (json['jobs'] != null) {
      job = <JobModel>[];
      json['jobs']['data'].forEach((dynamic v) {
        job!.add(JobModel.fromJson(v));
      });
    }

    if (json['attachments'] != null) {
      attachments = <AttachmentResourceModel>[];
      json['attachments']['data'].forEach((dynamic v) {
        attachments!.add(AttachmentResourceModel.fromJson(v));
      });
    }

    if (json['reminders']?['data'] != null) {
      reminders = <ReminderModel>[];
      json['reminders']['data'].forEach((dynamic v) {
        reminders!.add(ReminderModel.fromJson(v));
      });
    }
    if(json['attendees']?['data'] != null) {
      attendees = [];
      json['attendees']['data'].forEach((dynamic attendee) {
        attendees!.add(UserLimitedModel.fromJson(attendee));
      });
    }
    createdBy = json['created_by'] != null && json['created_by'] is Map<dynamic, dynamic>  ? UserModel.fromJson(json['created_by']) : null;

    if(json['attachments']?['data'] != null) {
      attachments = [];
      json['attachments']['data'].forEach((dynamic attendee) {
        attachments!.add(AttachmentResourceModel.fromJson(attendee));
      });
    }

    if (startDateTime != null) {
      startDate = DateTimeHelper.formatDate(
          startDateTime.toString(),
          DateFormatConstants.dateMonthOnlyDateLetterFormat
      );
      startTime = DateTimeHelper.formatDate(
          startDateTime.toString(),
          DateFormatConstants.timeOnlyFormat
      );
    }

    if (endDateTime != null) {
      endDate = DateTimeHelper.formatDate(
          endDateTime.toString(),
          DateFormatConstants.dateMonthOnlyDateLetterFormat
      );
      endTime = DateTimeHelper.formatDate(
          endDateTime.toString(),
          DateFormatConstants.timeOnlyFormat
      );
    }

    if(json['result_option_ids'] != null) {
      resultOptionIds = [];
      json['result_option_ids'].forEach((dynamic v) {
        resultOptionIds!.add(v.toString());
      });
    }

  
    if(json['result'] != null) {
      results = [];
      json['result'].forEach((dynamic v) {
        results!.add(AppointmentResultOptionFieldModel.fromJson(v));
      });
    }

    resultOption = json['result_option'] != null ? AppointmentResultOptionsModel.fromJson(json['result_option']) : null;

    customer = json['customer'] != null ? CustomerModel.fromJson(json['customer']) : null;

    if(json['invites'] != null) {
      invites = [];
      for(int i=0 ; i<json['invites'].length;i++){
        if(json['invites'][i] !=null){
        invites!.add(json['invites'][i]);
      }}
    }

    byDay = json['by_day']?.cast<String>();
    occurrence = json['occurence'].toString();

    if (startDateTime != null) {
      formattedStartDateTime = DateTimeHelper.formatDate(startDateTime!, DateFormatConstants.dateTimeFormatWithoutSeconds);
    }

    if (endDateTime != null) {
      formattedEndDateTime = DateTimeHelper.formatDate(endDateTime!, DateFormatConstants.dateTimeFormatWithoutSeconds);
    }

    recurringId = int.tryParse(json['recurring_id'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['start_date_time'] = startDateTime;
    data['end_date_time'] = endDateTime;
    data['location'] = location;
    data['customer_id'] = customerId;
    data['job_id'] = jobId;
    data['user_id'] = userId;
    data['location_type'] = locationType;
    data['repeat'] = repeat;
    data['until_date'] = untilDate;
    data['series_id'] = seriesId;
    data['is_recurring'] = isRecurring;
    data['interval'] = interval;
    data['is_completed'] = isCompleted;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['full_day'] = isAllDay ? 1 : 0;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (job != null) {
      data['jobs'] = job!.map((dynamic v) => v.toJson()).toList();
    }
    if (createdBy != null) {
      data['created_by'] = createdBy!.toJson();
    }
    
    if (attachments != null) {
      data['attachments'] = attachments!.map((v) => v.toJson()).toList();
    }
    data['by_day'] = byDay;
    data['occurence'] = occurrence;
    return data;
  }

   AppointmentModel.fromJobModel(JobModel jobModel) {
    customer = jobModel.customer;
    job = [jobModel];
    locationType = 'job';
    location = '';
    isAllDay = false;
  }

}
