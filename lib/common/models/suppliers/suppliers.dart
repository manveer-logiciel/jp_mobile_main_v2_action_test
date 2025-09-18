import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../core/utils/helpers.dart';
import '../job/job_division.dart';

class SuppliersModel {

  int? id;
  String? name;
  int? companyId;
  String? branchId;
  String? branchName;
  String? branchCode;
  String? branchAddress;
  String? managerName;
  String? email;
  String? phone;
  String? shipToAddress;
  String? srsBranchDetail;
  String? updatedAt;
  List<DivisionModel>? divisions;

  SuppliersModel({
    this.id,
    this.name,
    this.companyId,
    this.branchId,
    this.branchName,
    this.branchCode,
    this.branchAddress,
    this.managerName,
    this.email,
    this.phone,
    this.shipToAddress,
    this.srsBranchDetail,
    this.updatedAt,
    this.divisions
  });

  SuppliersModel.fromJson(Map<String, dynamic>? json) {

    if (json == null) return;

    id = int.tryParse(json['id']?.toString() ?? '');
    name = json['name'];
    companyId = json['company_id'];
    branchId = json['branch_id'];
    branchName = json['branch_name'];
    branchCode = json['branch_code'];
    branchAddress = json['branch_address'];
    managerName = json['manager_name'];
    email = json['email'];
    phone = json['phone'];
    if(json['ship_to_address'] is String) {
      shipToAddress = json['ship_to_address'];
    }
    srsBranchDetail = json['srs_branch_detail'];
    updatedAt = json['updated_at'];
    if(json['divisions'] != null) {
      divisions = [];
      if(json['divisions'] is List) {
        json['divisions'].forEach((dynamic map) => divisions?.add(DivisionModel.fromJson(map)));
      } else if(!Helper.isValueNullOrEmpty(json['divisions']['data'])) {
        json['divisions']['data'].forEach((dynamic map) => divisions?.add(DivisionModel.fromJson(map)));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['company_id'] = companyId;
    data['branch_id'] = branchId;
    data['branch_name'] = branchName;
    data['branch_code'] = branchCode;
    data['branch_address'] = branchAddress;
    data['manager_name'] = managerName;
    data['email'] = email;
    data['phone'] = phone;
    data['ship_to_address'] = shipToAddress;
    data['srs_branch_detail'] = srsBranchDetail;
    data['updated_at'] = updatedAt;
    if (divisions != null) {
      data['divisions'] = divisions!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  JPSingleSelectModel toSingleSelect() {
    return JPSingleSelectModel(
      id: id.toString(),
      label: name.toString(),
      additionalData: this
    );
  }
}