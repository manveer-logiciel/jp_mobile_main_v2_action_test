import 'package:jobprogress/common/models/sql/user/user_limited.dart';

class CustomFieldsModel {
  int? active;
  int? id;
  String? name;
  int? requiredData;
  String? type;
  String? value;
  List<CustomFieldsModel?>? options;
  List<CustomFieldsModel?>? subOptions;
  List<UserLimitedModel>? usersList;
  bool isVisible = true;
  List<CustomFieldsModel>? linkedParentOptions;

  CustomFieldsModel({
    this.active,
    this.id,
    this.name,
    this.requiredData,
    this.type,
    this.value,
    this.isVisible = true,
    this.usersList,
  });

  CustomFieldsModel.fromJson(Map<String, dynamic> json) {
    active = json['active']?.toInt();
    id = json['id']?.toInt();
    name = json['name']?.toString();
    requiredData = json['required']?.toInt();
    type = json['type']?.toString();
    value = json['value']?.toString();
    if (json['options']?['data'] != null) {
      options = [];
      json['options']['data'].forEach((dynamic v) {
        options!.add(CustomFieldsModel.fromJson(v));
      });
    }
    if(json['users']?['data']?.isNotEmpty ?? false) {
      usersList = [];
      json['users']['data'].forEach((dynamic user) {
        usersList!.add(UserLimitedModel.fromJson(user));
      });
    }
    if (json['sub_options']?['data'] != null) {
      subOptions = [];
      json['sub_options']['data'].forEach((dynamic v) {
        subOptions!.add(CustomFieldsModel.fromJson(v));
      });
    }
    if(json['linked_parent_options']?['data']?.isNotEmpty ?? false) {
      linkedParentOptions = [];
      json['linked_parent_options']?['data']?.forEach((dynamic option) {
        linkedParentOptions?.add(CustomFieldsModel.fromJson(option));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['active'] = active;
    data['id'] = id;
    data['name'] = name;
    data['required'] = requiredData;
    data['type'] = type;
    data['value'] = value;
    if (options != null) {
      for (var v in options!) {
        data['options']['data'].add(v!.toJson());
      }
    }
    if (subOptions != null) {
      for (var v in subOptions!) {
        data['sub_options']['data'].add(v!.toJson());
      }
    }
    return data;
  }
}