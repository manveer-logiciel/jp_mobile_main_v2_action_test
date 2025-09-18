import 'package:jobprogress/common/models/sql/division/division_limited.dart';

class SupplierBranchModel {
  int? id;
  String? branchId;
  String? branchCode;
  String? name;
  String? address;
  dynamic city;
  dynamic state;
  dynamic zip;
  num? lat;
  num? long;
  dynamic email;
  String? phone;
  dynamic managerName;
  String? logo;
  int? defaultCompanyBranch;
  List<dynamic>? deliveryTypeNames;
  List<DivisionLimitedModel>? divisions;
  dynamic deliveryTypeName;
  int? isActive;

  SupplierBranchModel({
    this.id,
    this.branchId,
    this.branchCode,
    this.name,
    this.address,
    this.city,
    this.state,
    this.zip,
    this.lat,
    this.long,
    this.email,
    this.phone,
    this.managerName,
    this.logo,
    this.defaultCompanyBranch,
    this.deliveryTypeNames,
    this.divisions,
    this.deliveryTypeName,
    this.isActive,
  });

  SupplierBranchModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchId = json['branch_id'];
    branchCode = json['branch_code'];
    name = json['name'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
    lat = json['lat'];
    long = json['long'];
    email = json['email'];
    phone = json['phone'];
    managerName = json['manager_name'];
    logo = json['logo'];
    defaultCompanyBranch = json['default_company_branch'];
    deliveryTypeNames = json['delivery_type_name'];
    divisions = json['divisions'] != null && json['divisions'] is List
        ? json['divisions']!.map((Map<String, dynamic> divisionJson) => DivisionLimitedModel.fromJson(divisionJson)).toList()
        : null;
    deliveryTypeName = json['delivery_type_name'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['branch_id'] = branchId;
    data['branch_code'] = branchCode;
    data['name'] = name;
    data['address'] = address;
    data['city'] = city;
    data['state'] = state;
    data['zip'] = zip;
    data['lat'] = lat;
    data['long'] = long;
    data['email'] = email;
    data['phone'] = phone;
    data['manager_name'] = managerName;
    data['logo'] = logo;
    data['default_company_branch'] = defaultCompanyBranch;
    data['delivery_type_name'] = deliveryTypeNames;
    if (divisions != null) {
      data['divisions'] = divisions!.map((v) => v.toJson()).toList();
    }
    data['delivery_type_name'] = deliveryTypeName;
    data['is_active'] = isActive;
    return data;
  }
}