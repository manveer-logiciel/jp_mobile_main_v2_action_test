import 'package:flutter/material.dart';
import 'package:jobprogress/common/enums/notification.dart';
import 'package:jobprogress/common/models/announcement.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job_price.dart';
import 'package:jobprogress/common/models/note_list/note_listing.dart';
import 'package:jobprogress/common/models/notification/notification_body.dart';
import 'package:jobprogress/common/models/schedules/schedules.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';

class NotificationListingModel {
  late int id;
  String? createdAt;
  String? subject;
  String? sentAt;
  String? objectType;
  String? threadId;
  late bool isRead;
  int? senderId;
  dynamic object;
  NotificationBodyModel? body;
  UserLimitedModel? sender;
  List<UserLimitedModel>? recipients;
  NotificationType? notificationType;
  TaskListModel? task;
  CustomerModel? customer;
  JobModel? job;
  List<JobModel>? jobs;
  AppointmentModel? appointment;
  SchedulesModel? schedule;
  JobPriceModel? jobPrice;
  NoteListModel? noteDetail;
  AnnouncementModel? announcement;

  NotificationListingModel({
    required this.id,
    this.subject,
    this.isRead = false,
    this.createdAt,
    this.senderId,
    this.sentAt,
    this.object,
    this.objectType,
    this.threadId,
    this.recipients,
    this.body,
    this.customer,
    this.job,
    this.jobs,
    this.notificationType,
    this.sender,
    this.appointment,
    this.schedule,
    this.jobPrice,
    this.noteDetail,
    this.announcement
  });

  NotificationListingModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    isRead = json['is_read'] == 1;
    createdAt = json['created_at'];
    senderId = json['sender_id'];
    sentAt = json['sent_at'];
    objectType = json['object_type'];
    object = json['object'];
    
    if(json['body'] != null && json['body'] is Map<String, dynamic>) {
      body = NotificationBodyModel.fromJson(json['body']);
    }
    
    if(json['sender'] != null && json['sender'] is Map<String, dynamic>) {
      sender = UserLimitedModel.fromJson(json['sender']);
    }

    if (json['recipients'] != null && json['recipients']['data'] != null) {
      recipients = <UserLimitedModel>[];
      json['recipients']['data'].forEach((dynamic v) {
        recipients!.add(UserLimitedModel.fromJson(v));
      });
    }

    if (json['recipients'] != null && json['recipients']['data'] != null) {
      recipients = <UserLimitedModel>[];
      json['recipients']['data'].forEach((dynamic v) {
        recipients!.add(UserLimitedModel.fromJson(v));
      });
    }

    if (json['jobs'] != null && json['jobs']['data'] != null) {
      jobs = <JobModel>[];
      json['jobs']['data'].forEach((dynamic v) {
        jobs!.add(JobModel.fromNotificationJson(v));
      });
    }

    if(json['job'] != null && json['job'] is Map<String, dynamic>) {
      job = JobModel.fromNotificationJson(json['job']);
    }

    if(json['customer'] != null && json['customer'] is Map<String, dynamic>) {
      customer = CustomerModel.fromJson(json['customer']);
    }

    notificationType = getNotificationType(json['object_type']);
    
    if (json['object'] is Map<String, dynamic>) {
      switch (notificationType) {
        case NotificationType.jobPriceRequest:
          jobPrice = JobPriceModel.fromJson(json['object']);
          break;
        case NotificationType.task:
          task = TaskListModel.fromJson(json['object']);
          break;
        case NotificationType.customer:
          customer = CustomerModel.fromJson(json['object']);
          break;
        case NotificationType.job:
          job = JobModel.fromJson(json['object']);
          break;
        case NotificationType.appointment:
          appointment = AppointmentModel.fromJson(json['object']);
          break;
        case NotificationType.jobSchedule:
          schedule = SchedulesModel.fromApiJson(json['object']);
          break;
        case NotificationType.jobNote:
        case NotificationType.workCrewNote:
        case NotificationType.jobFollowUp:
          noteDetail = NoteListModel.fromJson(json['object']);
          break;
        case NotificationType.announcement:
          announcement = AnnouncementModel.fromJson(json['object']);
          break;
        default:
          break;
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['subject'] = subject;
    data['is_read'] = isRead ? 1 : 0;
    data['created_at'] = createdAt;
    data['sender_id'] = senderId;
    data['sent_at'] = sentAt;
    data['object_type'] = objectType;
    if (body != null) data['body'] = body!.toJson();
    if (sender != null) data['sender'] = sender!.toJson();

    return data;
  }

  NotificationType getNotificationType(String? type) {
    switch (type) {
      case 'Task':
        return NotificationType.task;
      case 'Appointment':
        return NotificationType.appointment;
      case 'Job':
        return NotificationType.job;
      case 'document_expired':
        return NotificationType.documentExpired;
      case 'JobSchedule':
        return NotificationType.jobSchedule;
      case 'JobPriceRequest':
        return NotificationType.jobPriceRequest;
      case 'WorkCrewNote':
        return NotificationType.workCrewNote;
      case 'Message':
        return NotificationType.message;
      case 'JobFollowUp':
        return NotificationType.jobFollowUp;
      case 'JobNote':
        return NotificationType.jobNote;
      case 'Customer':
        return NotificationType.customer;
      case 'Worksheet':
        return NotificationType.worksheet;
      case 'Announcement':
        return NotificationType.announcement;
      case 'MaterialList':
        return NotificationType.materialList;
      case 'JobPayment':
        return NotificationType.leapPay;
      case 'UserRegistrationInvite':
        return NotificationType.userRegistrationInvite;
      default:
        return NotificationType.notification;
    }
  }

  IconData getIcon() {
    switch (notificationType) {
      case NotificationType.task:
        return Icons.task_alt_outlined;
      case NotificationType.appointment:
        return Icons.event_note_outlined;
      case NotificationType.job:
        return Icons.work_outline;
      case NotificationType.documentExpired:
        return Icons.insert_drive_file_outlined;
      case NotificationType.jobSchedule:
        return Icons.calendar_month_outlined;
      case NotificationType.jobPriceRequest:
        return JobFinancialHelper.getCurrencyIcon();
      case NotificationType.workCrewNote:
        return Icons.three_p_outlined;
      case NotificationType.message:
        return Icons.textsms_outlined;
      case NotificationType.jobFollowUp:
        return Icons.three_p_outlined;
      case NotificationType.jobNote:
        return Icons.three_p_outlined;
      case NotificationType.customer:
        return Icons.person_outlined;
      case NotificationType.worksheet:
        return Icons.description_outlined;
      case NotificationType.announcement:
        return Icons.campaign_outlined;
      case NotificationType.materialList:
        return Icons.description_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }
}
