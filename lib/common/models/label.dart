import 'package:flutter/cupertino.dart';
import 'package:jobprogress/common/enums/firebase.dart';

class EmailLabelModel {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  int? unreadCount;
  IconData? icon;
  List<RealTimeKeyType>? keyType;

  EmailLabelModel({this.id, this.name, this.createdAt, this.updatedAt, this.unreadCount, this.keyType, this.icon});

  EmailLabelModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    unreadCount = json['unread_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['unread_count'] = unreadCount;
    return data;
  }
}
