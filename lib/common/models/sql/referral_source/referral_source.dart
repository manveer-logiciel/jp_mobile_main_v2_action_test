import 'package:get/get.dart';
import 'package:jobprogress/core/constants/common_constants.dart';

class ReferralSourcesModel {
  late dynamic id;
  int? companyId;
  late String name;
  bool? active;
  String? cost;

  ReferralSourcesModel({
    required this.id,
    required this.name,
    this.companyId,
    this.active,
    this.cost
  });

  static ReferralSourcesModel get otherOption => ReferralSourcesModel(
    id: CommonConstants.otherOptionId,
    active: true,
    name: 'other'.tr.capitalize!,
  );

  static ReferralSourcesModel get noneOption => ReferralSourcesModel(
    id: CommonConstants.noneId,
    active: true,
    name: 'none'.tr.capitalize!,
  );

  static ReferralSourcesModel get customer => ReferralSourcesModel(
    id: CommonConstants.customerOptionId,
    active: true,
    name: 'existing_customer'.tr,
  );

  // converting from local db data -> modal
  ReferralSourcesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    companyId = json['company_id'];
    cost = json['cost'].toString();
    active = json['active'] == 1;
  }
  // convert from api json -> modal
  ReferralSourcesModel.fromApiJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    companyId = json['company_id'];
    cost = json['cost'].toString();
    active = (json['active'] != null) ? json['active'] : true;
  }
  // this function is used while inserting data in to local db
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['company_id'] = companyId;
    data['local_id'] = '${id}_$companyId';
    data['cost'] = cost;
    data['active'] = active == true ? 1 : 0;
    return data;
  }
}
