import 'dart:convert';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/sql/work_type/work_type.dart';

class TradeTypeModel {
  late int id;
  bool? active;
  int? companyId;
  late String name;
  String? color;
  List<WorkTypeModel>? workType;

  TradeTypeModel({
    required this.id,
    required this.name,
    this.companyId,
    this.color,
    this.active,
    this.workType
  });

  static TradeTypeModel get none => TradeTypeModel(
    id: 0,
    name: 'none'.tr,
  );

  // convert from api json -> modal
  TradeTypeModel.fromApiJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    name = json['name'];
    color = json['color'];
    active = (json['active'] != null) ? json['active'] : true;
    if (json['work_types'] != null && json['work_types']['data'].length > 0) {
      workType = [];
      json['work_types']['data'].forEach((dynamic item) {
        workType!.add(WorkTypeModel.fromApiJson(item));
      });
    }
  }
  // converting from local db data -> modal
  TradeTypeModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString()) ?? 0;
    companyId = json['company_id'];
    name = json['name'];
    color = json['color'];
    active = json['active'] == 1;
    if (json['work_type'] != null && jsonDecode(json['work_type']).length > 0) {
      List<WorkTypeModel> workType = [];
      jsonDecode(json['work_type']).forEach((dynamic item) {
        final model = WorkTypeModel.fromJson(item);
        if(model.companyId == companyId) {
          workType.add(model);
        }
      });

      this.workType = workType.cast<WorkTypeModel>();
    }
  }
  // this function is used while inserting data in to local db
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_id'] = companyId;
    data['local_id'] = '${id}_$companyId';
    data['name'] = name;
    data['color'] = color;
    data['active'] = active == true ? 1 : 0;
    if (workType != null && workType!.isNotEmpty) {
      final List<dynamic> workTypeList = [];

      for (var element in workType!) {
        workTypeList.add(element.toJson());
      }

      data['workType'] = workTypeList;
    }
    return data;
  }
}
