import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/core/constants/auth_constant.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';

import '../../customer/customer.dart';
import '../../job/job_division.dart';

/// this modal is used in division & tags modal
/// we are using limited keys values in relation
class UserLimitedModel {
  late int id;
  late int groupId;
  int? companyId;
  int? resourceId;
  bool? active;
  late String firstName;
  late String fullName;
  late String email;
  String? groupName;
  String? lastName;
  String? profilePic;
  String? subCompanyName;
  String? companyName;
  String? color;
  String? companyInitial;
  String? intial;
  String? roleName;
  String? status;
  int? groupCount;
  int? unreadMessageCount;
   List<PhoneModel>? phones;
  String? type;
  late bool isCustomer;
  CustomerModel? profile;
  List<DivisionModel>? division;

  UserLimitedModel({
      required this.id,
      required this.firstName,
      required this.fullName,
      required this.email,
      required this.groupId,
      this.companyId,
      this.groupName,
      this.lastName,
      this.profilePic,
      this.active,
      this.subCompanyName,
      this.color,
      this.resourceId,
      this.companyInitial,
      this.intial,
      this.roleName,
      this.companyName,
      this.phones,
      this.status,
      this.unreadMessageCount,
      this.type,
      this.isCustomer = false,
      this.profile,
      this.division,
  });

  factory UserLimitedModel.copy(UserLimitedModel userLimitedModel) => UserLimitedModel(
    id: userLimitedModel.id,
    firstName: userLimitedModel.firstName,
    fullName: userLimitedModel.fullName,
    email: userLimitedModel.email,
    groupId: userLimitedModel.groupId,
    companyId: userLimitedModel.companyId,
    groupName: userLimitedModel.groupName,
    lastName: userLimitedModel.lastName,
    profilePic: userLimitedModel.profilePic,
    active: userLimitedModel.active,
    subCompanyName: userLimitedModel.subCompanyName,
    color: userLimitedModel.color,
    resourceId: userLimitedModel.resourceId,
    companyInitial: userLimitedModel.companyInitial,
    intial: userLimitedModel.intial,
    roleName: userLimitedModel.roleName,
    companyName: userLimitedModel.companyName,
    phones: userLimitedModel.phones,
    status: userLimitedModel.status,
    unreadMessageCount: userLimitedModel.unreadMessageCount,
    type: userLimitedModel.type,
    isCustomer: userLimitedModel.isCustomer,
    profile: userLimitedModel.profile,
    division: userLimitedModel.division,
  );



  UserLimitedModel.fromJson(Map<dynamic, dynamic> json) {
    id = int.parse(json['id'].toString());
    firstName = json['first_name'] ?? "";
    lastName = json['last_name'] ?? "";
    fullName = json['full_name'] ?? "";
    email = json['email'] ?? '';
    groupId = json['group_id'] ?? -1;
    groupName = json['group_name'] ?? '';
    companyId = int.tryParse(json['company_id'].toString());
    companyName = json['company_name'];
    profilePic = json['profile_pic'];
    active = json['active'] == 1;
    subCompanyName = json['sub_company_name'];
    color = json['color'];
    resourceId = json['resource_id'];
    status = json['status'];
    phones = <PhoneModel>[];
    if(json['profile'] != null) {
      if (json['profile']['additional_phone'] != null && json['profile']['additional_phone'].isNotEmpty) {
        json['profile']['additional_phone'].forEach((dynamic division) {
          phones!.add(PhoneModel.fromJson(division));
        });
      }
    }

    if (companyName != '' && companyName != null) {
      companyInitial = companyName![0].toString().toUpperCase();
    }

    intial = Helper.isValueNullOrEmpty(firstName) ? "" : (!Helper.isValueNullOrEmpty(lastName)) ? firstName[0] + (lastName?[0] ?? '') : firstName.substring(0, 2);
    roleName = (json['role'] != null &&
            json['role'][0] != null &&
            json['role'][0]['name'] != null)
        ? json['role'][0]['name']
        : '';

    groupCount = int.tryParse(json['groups_count'].toString()) ?? 0;
    unreadMessageCount = json['unread_message_count'] ?? 0;
    type = json['type'];
    isCustomer = type == CommonConstants.customerUserType;
    profile = (json['profile'] != null && (json['profile'] is Map)) ? CustomerModel.fromJson(json['profile']) : null;

    if(json['divisions'] is Map && (json['divisions']?['data']?.isNotEmpty ?? false)) {
      division = [];
      json['divisions']['data'].forEach((dynamic div) {
        division!.add(DivisionModel.fromJson(div));
      });
    }
  }

  Map<String, dynamic> toSuggestionJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id.toString();
    data['display'] = roleName == AuthConstant.subContractorPrime && !Helper.isValueNullOrEmpty(companyName) ? fullName + ' (' + companyName! + ')' : fullName;
    data['photo'] = profilePic;
    data['border_color'] = color;
    data['initial'] = intial;
    data['suffix-text'] = roleName == AuthConstant.subContractorPrime ? '(Sub)' : '';
    return data;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['full_name'] = fullName;
    data['email'] = email;
    data['group_id'] = groupId;
    data['group_name'] = groupName;
    data['company_name'] = companyName;
    data['company_id'] = companyId;
    data['profile_pic'] = profilePic;
    data['active'] = active == true ? 1 : 0;
    data['sub_company_name'] = subCompanyName;
    data['color'] = color;
    data['resource_id'] = resourceId;
    data['status'] = status;
    return data;
  }
}