import 'dart:convert';

import 'package:get/get.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/models/sql/company/company.dart';
import 'package:jobprogress/common/models/sql/division/division_limited.dart';
import 'package:jobprogress/common/models/sql/state/state.dart';
import 'package:jobprogress/common/models/sql/tag/tag_limited.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/user_roles.dart';
import 'package:jobprogress/core/utils/helpers.dart';

import '../../beacon_client_model.dart';

class UserModel {
  late dynamic id;
  int? customerId;
  int? companyId;
  int? groupId;
  int? resourceId;
  bool? active;
  bool? allDivisionsAccess;
  late String firstName;
  late String fullName;
  String? email;
  String? groupName;
  String? lastName;
  String? profilePic;
  String? companyName;
  String? subCompanyName;
  String? color;
  String? totalCommission;
  String? paidCommission;
  String? unpaidCommission;
  String? intial;
  String? companyInitial;
  CompanyModel? companyDetails;
  List<CompanyModel>? allCompanies;
  List<TagLimitedModel>? tags;
  List<DivisionLimitedModel>? divisions;
  List<PhoneModel>? phones;
  AddressModel? address;
  String? convertedAddress;
  late bool dataMasking;
  bool? isDropBoxConnected;
  bool? isRestricted;
  BeaconClientModel? beaconClient;

  UserModel({
    required this.id,
    required this.firstName,
    required this.fullName,
    required this.email,
    this.customerId,
    this.companyId,
    this.groupName,
    this.groupId,
    this.lastName,
    this.profilePic,
    this.active,
    this.companyName,
    this.subCompanyName,
    this.companyInitial,
    this.color,
    this.resourceId,
    this.allDivisionsAccess,
    this.totalCommission,
    this.paidCommission,
    this.unpaidCommission,
    this.intial,
    this.tags,
    this.divisions,
    this.companyDetails,
    this.allCompanies,
    this.phones,
    this.address,
    this.convertedAddress,
    this.dataMasking = false,
    this.isDropBoxConnected = false,
    this.isRestricted = false,
    this.beaconClient,
  });

  static UserModel get unAssignedUser => UserModel(
      id: CommonConstants.unAssignedUserId,
      firstName: 'unassigned'.tr,
      fullName: 'unassigned'.tr,
      email: '',
      intial: 'unassigned'.tr.substring(0, 2).toUpperCase(),
  );

  static UserModel get otherOption => UserModel(
    id: CommonConstants.otherOptionId,
    firstName: 'other'.tr.capitalize!,
    fullName: 'other'.tr.capitalize!,
    email: '',
    intial: 'other'.tr.substring(0, 2).toUpperCase(),
  );

  // converting from shared preference data -> modal
  UserModel.fromSharedPrefJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    fullName = json['full_name'];
    email = json['email'];
    companyId = json['company_id'];
    customerId = json['customer_id'];
    groupId = json['group']['id'];
    groupName = json['group']['name'];
    profilePic = json['profile_pic'];
    color = json['color'];
    active = json['active'];
    subCompanyName = json['company_name'];
    resourceId = json['resource_id'];
    totalCommission = json['total_commission'];
    paidCommission = json['paid_commission'];
    unpaidCommission = json['unpaid_commission'];
    allDivisionsAccess = json['all_divisions_access'];
    intial = Helper.isValueNullOrEmpty(firstName) ? '' : firstName[0] + 
      (Helper.isValueNullOrEmpty(lastName) ? '' : lastName![0]); 
    dataMasking = json['data_masking'] == 1 ? true : false;
    isDropBoxConnected = json['dropbox_client'] != null ? true : false;
    companyDetails = json['company_details'] != null
        ? CompanyModel.fromApiJson(json['company_details'])
        : null;
    if (json['all_companies'] != null) {
      allCompanies = <CompanyModel>[];
      json['all_companies']['data'].forEach((dynamic v) {
        allCompanies!.add(CompanyModel.fromJson(v));
      });
    }

    if (json['divisions'] != null) {
      divisions = <DivisionLimitedModel>[];
      json['divisions']['data'].forEach((dynamic division) {
        divisions!.add(DivisionLimitedModel.fromJson(division));
      });
    }
    
    phones = <PhoneModel>[];
    
    if (json['phones'] != null) {
      json['phones']['data'].forEach((dynamic division) {
        phones!.add(PhoneModel.fromJson(division));
      });
    }

    if(json['profile'] != null) {
      if (json['profile']['additional_phone'] != null) {
        json['profile']['additional_phone'].forEach((dynamic division) {
          phones!.add(PhoneModel.fromJson(division));
        });
      }

      if(json['profile']?['address'] != null) {
          address = AddressModel(
          id: json['profile']?['id'] ?? 0,
          address: json['profile']?['address'] ?? "",
          addressLine1: json['profile']?['address_line_1'] ?? "",
          city: json['profile']?['city'] ?? "",
          state: StateModel(
              id: json['profile']?['state_id'] ?? 0,
              name: json['profile']?['state'] ?? "",
              code: json['profile']?['state_code'] ?? "",
              countryId: json['profile']?['country_id'] ?? 0
          ),
          zip: json['profile']?['zip'] ?? "",
        );
        convertedAddress = Helper.convertAddress(address);
      }
    }

    isRestricted = Helper.isTrue(json["is_restricted"]);
    beaconClient = json['beacon_client'] is Map ? BeaconClientModel.fromJson(json['beacon_client']) : null;
  }

  // converting from local db data -> modal
  UserModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'] ?? "";
    lastName = json['last_name'];
    fullName = json['full_name'] ?? "";
    email = json['email'];
    groupId = json['group_id'];
    groupName = json['group_name'];
    companyId = json['company_id'];
    customerId = json['customer_id'];
    profilePic = json['profile_pic'];
    active = json['active'] == 1;
    subCompanyName = json['sub_company_name'];
    companyName = json['company_name'] ?? json['company'];
    totalCommission = json['total_commission'];
    paidCommission = json['paid_commission'];
    unpaidCommission = json['unpaid_commission'];
    color = json['color'];
    resourceId = json['resource_id'];
    allDivisionsAccess = json['all_divisions_access'] == 1;
    intial = Helper.isValueNullOrEmpty(firstName) ? '' : firstName[0] + 
      (Helper.isValueNullOrEmpty(lastName) ? '' : lastName![0]);
    dataMasking = json['data_masking'] == 1 ? true : false;
    companyDetails = json['company_details'] != null
        ? CompanyModel.fromJson(json['company_details'])
        : null;

    if (json['all_companies'] != null) {
      allCompanies = <CompanyModel>[];
      json['all_companies']['data'].forEach((dynamic v) {
        allCompanies!.add(CompanyModel.fromJson(v));
      });
    }

    if (json['tags'] != null && jsonDecode(json['tags']).length > 0) {
      List<TagLimitedModel> tags = [];
      jsonDecode(json['tags'])
          .forEach((dynamic tag) => {tags.add(TagLimitedModel.fromJson(tag))});

      this.tags = tags.cast<TagLimitedModel>();
    }

    if (json['divisions'] != null && jsonDecode(json['divisions']).length > 0) {
      List<DivisionLimitedModel> divisions = [];
      jsonDecode(json['divisions']).forEach(
          (dynamic tag) => {divisions.add(DivisionLimitedModel.fromJson(tag))});

      this.divisions = divisions.cast<DivisionLimitedModel>();
    }

    if (!Helper.isValueNullOrEmpty(companyName)) {
      companyInitial = companyName![0].toString().toUpperCase();
    }
  }

  // convert from api json -> modal
  UserModel.fromApiJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    fullName = json['full_name'];
    email = json['email'];
    groupId = json['group']?['id'];
    groupName = json['group']?['name'];
    companyId = json['company_id'];
    profilePic = json['profile_pic'];
    active = json['active'];
    companyName = json['company'];
    subCompanyName = json['company_name'];
    color = json['color'];
    resourceId = json['resource_id'];
    totalCommission = json['total_commission'];
    paidCommission = json['paid_commission'];
    unpaidCommission = json['unpaid_commission'];
    allDivisionsAccess = json['all_divisions_access'];
    if (Helper.isValueNullOrEmpty(companyName)) {
      companyInitial = companyName![0].toString().toUpperCase();
    }
    dataMasking = json['data_masking'] == 1 ? true : false;
    if (json['divisions'] != null) {
      divisions = <DivisionLimitedModel>[];
      json['divisions']['data'].forEach((dynamic division) {
        divisions!.add(DivisionLimitedModel.fromJson(division));
      });
    }
  }

  // convert from api json -> modal
  UserModel.fromSubContractorApiJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    fullName = json['full_name'];
    email = json['email'];
    groupId = json['group_id'];
    companyName = json['company_name'];

    if (json['group_id'] == UserGroupIdConstants.subContractor) {
      groupName = 'sub contractor';
    } else if (json['group_id'] == UserGroupIdConstants.subContractorPrime) {
      groupName = 'sub contractor prime';
    }

    companyId = json['company_id'];
    profilePic = json['profile_pic'];
    active = json['is_active'];
    subCompanyName = json['company_name'];
    color = json['color'];
    resourceId = json['resource_id'];
    totalCommission = json['total_commission'];
    paidCommission = json['paid_commission'];
    unpaidCommission = json['unpaid_commission'];
    if (!Helper.isValueNullOrEmpty(companyName)) {
      companyInitial = companyName![0].toString().toUpperCase();
    }
    allDivisionsAccess = (json['all_divisions_access'] == true ||
        json['all_divisions_access'] == 1);
    dataMasking = json['data_masking'] == 1 ? true : false;
  }

  // this function is used while inserting data in to local db
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['local_id'] = '${id}_$companyId';
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['full_name'] = fullName;
    data['email'] = email;
    data['group_id'] = groupId;
    data['group_name'] = groupName;
    data['company_id'] = companyId;
    data['customer_id'] = customerId;
    data['profile_pic'] = profilePic;
    data['active'] = active == true ? 1 : 0;
    data['company_name'] = companyName;
    data['sub_company_name'] = subCompanyName;
    data['color'] = color;
    data['resource_id'] = resourceId;
    data['total_commission'] = totalCommission;
    data['paid_commission'] = paidCommission;
    data['unpaid_commission'] = unpaidCommission;
    data['all_divisions_access'] = allDivisionsAccess == true ? 1 : 0;
    data['data_masking'] = dataMasking ? 1 : 0;
    if (tags != null && tags!.isNotEmpty) {
      final List<dynamic> tagsList = [];

      for (var element in tags!) {
        tagsList.add(element.toJson());
      }

      data['tags'] = tagsList;
    }
    if (divisions != null && divisions!.isNotEmpty) {
      final List<dynamic> divisionsList = [];

      for (var element in divisions!) {
        divisionsList.add(element.toJson());
      }

      data['divisions'] = divisionsList;
    }
    if (companyDetails != null) {
      data['company_details'] = companyDetails!.toJson();
    }
    return data;
  }
}
