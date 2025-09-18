import 'dart:convert';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/models/sql/user/user_tag.dart';
import 'package:jobprogress/common/models/sql/tag/tag_counts.dart';

class TagModel {
  late int id;
  int? companyId;
  late String name;
  String? type;
  String? updatedAt;
  bool? active;
  TagCounts? counts;
  List<UserTagModel>? userTags;
  List<UserLimitedModel>? users;

  TagModel({
    required this.id,
    required this.name,
    this.companyId,
    this.type,
    this.updatedAt,
    this.userTags,
    this.active,
    this.users,
    this.counts
  });
  // convert from api json -> modal
  TagModel.fromApiJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    name = json['name'];
    type = json['type'];
    updatedAt = json['updated_at'];
    active = (json['active'] != null) ? json['active'] : true;
    if (json['users'] != null && json['users']['data'].length > 0) {
      userTags = [];
      json['users']['data'].forEach((dynamic v) {
        userTags!
            .add(UserTagModel.fromJson({'user_id': v['id'], 'tag_id': json['id']}));
      });
    }
  }
  // converting from local db data -> modal
  TagModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    name = json['name'];
    type = json['type'];
    updatedAt = json['updated_at'];
    active = json['active'] == 1;
    counts = json['counts'] != null ? TagCounts.fromJson(json['counts']) : null;
    if (json['user'] != null && jsonDecode(json['user']).length > 0) {
      List<UserLimitedModel> users = [];
      jsonDecode(json['user'])
          .forEach((dynamic user) => {users.add(UserLimitedModel.fromJson(user))});

      this.users = users.cast<UserLimitedModel>();
    }
  }
  // this function is used while inserting data in to local db
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_id'] = companyId;
    data['local_id'] = '${id}_$companyId';
    data['name'] = name;
    data['type'] = type;
    data['updated_at'] = updatedAt;
    data['active'] = active == true ? 1 : 0;
    if (users != null && users!.isNotEmpty) {
      final List<dynamic> userList = [];

      for (var element in users!) {
        userList.add(element.toJson());
      }

      data['users'] = userList;
    }
    return data;
  }
}
