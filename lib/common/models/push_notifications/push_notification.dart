import 'dart:convert';

import 'package:jobprogress/common/models/push_notifications/notification_data.dart';

class PushNotificationModel {

  String? body;
  String? type;
  String? title;
  PushNotificationDataModel? eData;
  PushNotificationDataModel? data;

  PushNotificationModel({
    this.eData,
    this.data,
    this.body,
    this.type,
    this.title,
  });

  PushNotificationModel.fromJson(Map<String, dynamic> json) {

    dynamic tempEData = json['edata'] == '[]' ? <String, dynamic>{} : json['edata'];
    dynamic tempData = json['data'] == '[]' ? <String, dynamic>{} : json['data'];

    eData = tempEData != null
        ? PushNotificationDataModel.fromJson(tempEData is String ? jsonDecode(tempEData) : tempEData)
        : null;
    data = tempData != null
        ? PushNotificationDataModel.fromJson(tempData is String ? jsonDecode(tempData) : tempData)
        : null;
    body = json['body'] ?? json['message_string'];
    type = json['type'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (eData != null) {
      data['edata'] = eData!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['body'] = body;
    data['type'] = type;
    data['title'] = title;
    return data;
  }
}
