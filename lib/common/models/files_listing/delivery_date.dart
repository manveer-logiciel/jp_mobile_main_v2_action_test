import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';

class DeliveryDateModel {
  int? id;
  int? jobId;
  String? deliveryDate;
  String? note;
  String? materialId;
  bool? isSrs;
  bool? isABC;
  FilesListingModel? materialsList;

  DeliveryDateModel({
    this.id,
    this.jobId,
    this.deliveryDate,
    this.note,
    this.materialId,
    this.materialsList,
    this.isSrs = false,
    this.isABC = false
  });

  DeliveryDateModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
    jobId = int.tryParse(json['job_id']?.toString() ?? '');
    deliveryDate = DateTimeHelper.convertHyphenIntoSlash((json['delivery_date']?.toString() ?? ""));
    note = json['note']?.toString();
    materialId = json['material_id']?.toString();
    if(json['material_list'] != null) {
      materialsList = FilesListingModel.fromMaterialListsJson(json['material_list']);
      materialsList?.deliveryDateModel = this;
      isSrs = materialsList?.isSrs ?? false;
      isABC = materialsList?.isABC ?? false;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['job_id'] = jobId;
    data['delivery_date'] = deliveryDate;
    data['note'] = note;
    data['material_id'] = materialId;
    return data;
  }

}
