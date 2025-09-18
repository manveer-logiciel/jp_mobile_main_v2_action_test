import 'package:jobprogress/common/models/suppliers/branch.dart';

class BeaconAccountModel {
  int? id;
  String? name;
  int? accountId;
  SupplierBranchModel? supplierBranch;

  BeaconAccountModel({
    this.id,
    this.name,
    this.accountId,
    this.supplierBranch,
  });

  BeaconAccountModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['account_id'] != null) {
      accountId = int.tryParse(json['account_id'].toString());
    }
    supplierBranch = json['supplier_branch'] is Map
        ? SupplierBranchModel.fromJson(json['supplier_branch'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['account_id'] = accountId;
    if (supplierBranch != null) {
      data['supplier_branch'] = supplierBranch!.toJson();
    }
    return data;
  }
}
