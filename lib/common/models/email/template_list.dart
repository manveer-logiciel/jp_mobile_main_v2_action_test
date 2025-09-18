
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/email/recipients_setting.dart';
import 'package:jobprogress/common/models/job/recurring_email.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/email/quick_action.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class EmailTemplateListingModel {
  int? id;
  late bool active;
  List<String>? bcc;
  List<String>? cc;
  List<String>? to;
  late bool newFormat;
  String? subject;
  String? template;
  String? actualTemplate;
  String? title;
  RecipientSettingModel? recipientSetting; 
  List<AttachmentResourceModel>? attachments;
  RecurringEmailModel ? recurringEmailData;
  String? parsedHtmlContent;
  String? shareUrl;
  bool isRepeatEnable = false;
  bool hideSendButton = false;
  bool isChecked = true;
  bool isToEmpty = false;
  bool isSubjectEmpty = false;
  bool? isApiRequestFailed;
  bool dataSent = true;
  bool dataValidate = true;
  List<int>? favoriteFor;
  bool favorite = false;
  bool isLoading = false;
  bool? sendToCustomer;

  EmailTemplateListingModel({
    this.id,
    this.active = false,
    this.bcc,
    this.cc,
    this.to,
    this.recurringEmailData,
    this.isApiRequestFailed,
    this.hideSendButton = false,
    this.newFormat = false,
    this.subject,
    this.isRepeatEnable = false,
    this.recipientSetting,
    this.isChecked = true,
    this.template,
    this.isSubjectEmpty = false,
    this.isToEmpty = false,
    this.dataSent = true,
    this.dataValidate = true,
    this.title,
    this.attachments,
    this.parsedHtmlContent,
    this.shareUrl,
    this.sendToCustomer,
    this.favoriteFor,
    this.favorite = false,
    this.isLoading = false
  });

  EmailTemplateListingModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    actualTemplate = json['template'];
    template = json['template'] != null ? EmailService.getHtmlData(json['template']) : null;

    if(actualTemplate == null && json['content'] != null) {
      actualTemplate = json['content'];
      template = json['content'] != null ? EmailService.getHtmlData(json['content']) : null;
    }
    shareUrl = json['share_url'];
    if(!Helper.isValueNullOrEmpty(json['favourite_for'])) {
      favoriteFor = <int>[];
      json['favourite_for'].forEach((dynamic v) {
        favoriteFor!.add(v);
      });
    }
    favorite = favoriteFor?.contains(AuthService.userDetails!.id)?? false;
    title = json['title'] ?? '--';
    active = json['active'] == 1 ? true : false;
    recipientSetting = (json['recipients_setting'] != null) ? RecipientSettingModel.fromJson(json['recipients_setting']) : null;
    newFormat = json['new_format'] == 1 ? true : false;
    parsedHtmlContent = json['template'] != null ? Helper.parseHtmlToText(json['template']) : null;
    to = json['to']['data'].cast<String>();
    cc = json['cc']['data'].cast<String>();
    bcc = json['bcc']['data'].cast<String>();
    if(json['attachments'] != null && json['attachments']['data'] != null) {
      attachments = <AttachmentResourceModel>[];
      json['attachments']['data'].forEach((dynamic v) {
        attachments!.add(AttachmentResourceModel.fromJson(v));
      });
    }
    sendToCustomer = Helper.isTrue(json['send_to_customer']);
  }

  EmailTemplateListingModel.fromReccuringEmailJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    template = json['content'] != null ? EmailService.getHtmlData(json['content']) : null;
    parsedHtmlContent = json['content'] != null ? Helper.parseHtmlToText(json['content']) : null;
    to = json['to'].cast<String>();
    cc = json['cc'].cast<String>();
    bcc = json['bcc'].cast<String>();
    if(json['attachments'] != null && json['attachments']['data'] != null) {
      attachments = <AttachmentResourceModel>[];
      json['attachments']['data'].forEach((dynamic v) {
        attachments!.add(AttachmentResourceModel.fromJson(v));
      });
    }
  }

}