import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:jobprogress/common/models/firebase/firestore/message_media.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/firestore/streams/groups/data.dart';
import 'package:jobprogress/core/constants/chats.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/firebase/firestore.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class GroupMessageModel {
  int? id;
  late String companyId;
  late String groupId;
  String? content;
  late int sendAsEmail;
  String? sender;
  String? source;
  String? sourceInfo;
  UserLimitedModel? user;
  String? actionOn;
  String? actionBy;
  String? action;
  String? unreadMessageSeparatorText;
  DateTime? createdAt;
  late bool isAction;
  late bool isMultilineText;
  late bool isLastLineOfFullWidth;
  late bool doShowDate;
  late bool isMyMessage;
  late DateTime updatedAt;
  List<String>? actionOnIds;
  List<MessageMediaModel>? media;
  DocumentSnapshot<Map<String, dynamic>>? doc;
  String? error;
  String? taskId;
  ValueNotifier<bool>? isTryingAgain;

  GroupMessageModel({
    required this.companyId,
    required this.groupId,
    required this.updatedAt,
    this.createdAt,
    this.doShowDate = false,
    this.content,
    this.sendAsEmail = 0,
    this.sender,
    this.source,
    this.sourceInfo,
    this.doc,
    this.isMyMessage = false,
    this.isMultilineText = false,
    this.isLastLineOfFullWidth = false,
    this.action,
    this.actionOn,
    this.actionBy,
    this.isAction = false,
    this.unreadMessageSeparatorText,
    this.error,
    this.isTryingAgain,
    this.taskId,
  });

  GroupMessageModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final json = snapshot.data()!;
    doc = snapshot;
    companyId = json['company_id'];
    content = json['content']?.toString().trim();
    createdAt = (json['created_at'] as Timestamp).toDate();
    groupId = json['group_id'];
    sendAsEmail = json['send_as_email'];
    sender = json['sender'];
    source = json['source'];
    sourceInfo = json['source_info'];
    updatedAt = (json['updated_at'] as Timestamp).toDate();
    isMyMessage = sender == AuthService.userDetails?.id.toString();
    user = GroupsData.allUsers[sender];
    doShowDate = false;

    isAction = json['action'] != null;

    if (isAction) {
      action = FirestoreHelpers.actionTypeToName(json['action']);
      actionBy = FirestoreHelpers.getActionBy(json['sender']);
      actionOn = FirestoreHelpers.getActionOn(
          json['action_detail']?['action_data_new']);

      if(json['action_detail']?['action_data_new'] != null) {
        actionOnIds = json['action_detail']['action_data_new'].cast<String>();
      }
    }

    isMultilineText = Helper.checkIfMultilineText(
      text: content ?? "",
      maxWidth: ChatsConstants.maxMessageWidth,
    );

    if(content?.trim().isEmpty ?? true) {
      isLastLineOfFullWidth = false;
    } else {
      isLastLineOfFullWidth = Helper.checkIfLastLineOfFullWidth(
          text: content ?? " ",
          textWidth: ChatsConstants.maxMessageWidth,
          reduceFromMaxWidth: ChatsConstants.timeWidth);
    }

    if(json['task_id'] != null) {
      taskId = json['task_id'].toString();
    }

  }

  GroupMessageModel.fromApiJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = '';
    content = json['content']?.toString().trim();
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(getConvertedTime(json));
    groupId = json['thread_id'];
    sendAsEmail = json['send_as_email'] ?? 0;

    // Parsing sender details only if available.
    // In case sender details are not available then it is assumed that message belongs to other user
    if (json['sender'] is Map) {
      user = UserLimitedModel.fromJson(json['sender']);
    }

    sender = user?.id.toString();
    isMyMessage = sender == AuthService.userDetails?.id.toString();

    doShowDate = false;

    isAction = json['action'] != null;

    isMultilineText = Helper.checkIfMultilineText(
      text: content ?? "",
      maxWidth: ChatsConstants.maxMessageWidth,
    );

    if(json['media']?['data'] != null) {
      media = [];
      json['media']?['data'].forEach((dynamic data) {
        media?.add(MessageMediaModel.fromJson(data));
      });
    }

    if(content?.trim().isEmpty ?? true) {
      isLastLineOfFullWidth = false;
    } else {
      isLastLineOfFullWidth = Helper.checkIfLastLineOfFullWidth(
          text: content ?? " ",
          textWidth: ChatsConstants.maxMessageWidth,
          reduceFromMaxWidth: ChatsConstants.timeWidth + (isMyMessage ? 0 : 100),
      );
    }

    error = json['error'];
    if(json['task_id'] != null) {
      taskId = json['task_id'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['company_id'] = companyId;
    data['content'] = content;
    data['created_at'] = Timestamp.fromDate(createdAt ?? DateTime.now());
    data['group_id'] = groupId;
    data['send_as_email'] = sendAsEmail;
    data['sender'] = sender;
    data['source'] = 'mobile';
    data['source_info'] = sourceInfo;
    data['updated_at'] = Timestamp.fromDate(updatedAt);
    if(error != null) {
      data['error'] = error;
    }
    data['task_id'] = taskId;
    return data;
  }

  /// [getConvertedTime] helps in converting time coming from api to user's app time zone
  String getConvertedTime(Map<String, dynamic> json) {
    try {
      return DateTimeHelper.formatDate(json['created_at'], DateFormatConstants.dateTimeServerFormat);
    } catch (e) {
      /// In case formatting fails for some reason going to use server time
      return json['created_at'] ?? "";
    }
  }
}
