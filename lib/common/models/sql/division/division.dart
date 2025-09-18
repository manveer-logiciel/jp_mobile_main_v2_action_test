import 'dart:convert';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/sql/user/user_division.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';

class DivisionModel {
  late dynamic id;
  late int companyId;
  late String name;
  String? code;
  String? color;
  String? email;
  String? phone;
  String? phoneExt;
  bool? active;
  List<UserDivisionModel>? userDivisions;
  List<UserLimitedModel>? users;

  DivisionModel({
    required this.id,
    required this.companyId,
    required this.name,
    this.code,
    this.color,
    this.email,
    this.phone,
    this.phoneExt,
    this.active,
    this.userDivisions,
    this.users
  });

  static DivisionModel get none => DivisionModel(
    id: '',
    name: 'none'.tr,
    companyId: -1
  );

  // convert from api json -> modal
  DivisionModel.fromApiJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    code = json['code'];
    color = json['color'];
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    phoneExt = json['phone_ext'];
    active = (json['active'] != null) ? json['active'] : true;
    if (json['users'] != null && json['users']['data'].length > 0) {
      userDivisions = [];
      json['users']['data'].forEach((dynamic v) {
        userDivisions!
            .add(UserDivisionModel.fromJson({'user_id': v['id'], 'division_id': json['id']}));
      });
    }
  }
  // converting from local db data -> modal
  DivisionModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    code = json['code'];
    color = json['color'];
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    phoneExt = json['phone_ext'];
    active = json['active'] == 1;
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
    data['code'] = code;
    data['color'] = color;
    data['email'] = email;
    data['name'] = name;
    data['phone'] = phone;
    data['phone_ext'] = phoneExt;
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
