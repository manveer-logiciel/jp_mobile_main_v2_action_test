import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/email/recipients.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/services/email/quick_action.dart';
import 'package:jobprogress/core/utils/email_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class EmailListingModel {
  int? id;
  String? subject;
  String? htmlContent;
  String? htmlFromApi;
  String? parseHtmlContent;
  String? from;
  String? type;
  String? status;
  bool? isRead;
  String? createdAt;
  String? updatedAt;
  int? count;
  String? threadId;
  String? label;
  int? labelId;
  bool? isMoved;
  bool? newFormat;
  List<String>? to;
  List<String>? cc;
  List<String>? bcc;
  CustomerModel? customer;
  List<JobModel>? jobs;
  List<AttachmentResourceModel>? attachments;
  List<RecipientModel>? recipients;
  UserLimitedModel? createdBy;
  String? allEmails;
  double? height;
  late bool checked;
  Color? color;
  double? actualHeight;
  String? emailToName;

  EmailListingModel(
      {this.id,
      this.subject,
      this.htmlContent,
      this.parseHtmlContent,
      this.from,
      this.type,
      this.status,
      this.isRead,
      this.createdAt,
      this.updatedAt,
      this.count,
      this.newFormat,
      this.threadId,
      this.label,
      this.labelId,
      this.isMoved,
      this.to,
      this.cc,
      this.bcc,
      this.htmlFromApi,
      this.customer,
      this.jobs,
      this.attachments,
      this.recipients,
      this.allEmails,
      this.height,
      this.createdBy,
      this.checked = false,
      this.color,
      this.actualHeight,
      this.emailToName,
      });

  EmailListingModel.fromJson(Map<dynamic, dynamic> json) {
    checked = false;
    color = null;
    id = json['id'];
    subject = json['subject'];
    htmlFromApi =  json['content'];
    final html = EmailService.getHtmlData(htmlFromApi!);
    htmlContent = html;
    parseHtmlContent = Helper.parseHtmlToText(htmlFromApi!);
    height = 1;
    actualHeight = 1;
    from = json['from'];
    type = json['type'];
    status = json['status'];
    isRead = json['is_read'] == 1 ? true : false;
    newFormat = json['new_format'] == 1 ? true : false; 
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    count = json['count'];
    threadId = json['thread_id'];
    label = json['label'];
    labelId = json['label_id'];
    isMoved = json['is_moved'] == 1 ? true : false;
    to = json['to'].cast<String>();
    if(!Helper.isValueNullOrEmpty(json['cc'])) {
      cc = json['cc'].cast<String>();
    }
    if(!Helper.isValueNullOrEmpty(json['bcc'])) {
      bcc = json['bcc'].cast<String>();
    }
    
    List<String> array = [];
    if(to!.isNotEmpty) {
      array.addAll(to!);
    }
    if(!Helper.isValueNullOrEmpty(cc)) {
      array.addAll(cc!);
    }
    if(!Helper.isValueNullOrEmpty(bcc)) {
      array.addAll(bcc!);
    }

    allEmails = array.map((email) => Helper.getEmailTo(email)).join(', ');

    customer = (json['customer'] != null
        ? CustomerModel.fromJson(json['customer'])
        : null);
    if (json['jobs'] != null) {
      jobs = <JobModel>[];
      json['jobs']['data'].forEach((dynamic v) {
        jobs!.add(JobModel.fromJson(v));
      });
    }
    if (json['recipients'] != null) {
      recipients = <RecipientModel>[];
      json['recipients']['data'].forEach((dynamic v) {
        recipients!.add(RecipientModel.fromJson(v));
      });
    }
    createdBy = json['createdBy'] != null ? UserLimitedModel.fromJson(json['createdBy']) : null;
    if (json['attachments'] != null) {
      attachments = <AttachmentResourceModel>[];
      json['attachments']['data'].forEach((dynamic v) {
        attachments!.add(AttachmentResourceModel.fromJson(v));
      });
    }

    if(to?.isNotEmpty ?? false) {
      emailToName = EmailHelpers.getEmailToName(to ?? []);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['subject'] = subject;
    data['content'] = htmlContent;
    data['from'] = from;
    data['type'] = type;
    data['status'] = status;
    data['is_read'] = isRead! ? 1 : 0;
    data['new_format'] = newFormat! ? 1 : 0;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['count'] = count;
    data['thread_id'] = threadId;
    data['label'] = label;
    data['label_id'] = labelId;
    data['is_moved'] = isMoved! ? 1 : 0;
    data['to'] = to;
    data['cc'] = cc;
    data['bcc'] = bcc;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (jobs != null) {
      data['jobs'] = jobs!.map((v) => v.toJson()).toList();
    }
    if (attachments != null) {
      data['attachments'] = attachments!.map((v) => v.toJson()).toList();
    }
    if (recipients != null) {
      data['recipients'] = recipients!.map((v) => v.toJson()).toList();
    }
    if (createdBy != null) {
      data['createdBy'] = createdBy!.toJson();
    }
    return data;
  }

}
