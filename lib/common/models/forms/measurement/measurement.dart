import 'package:jobprogress/common/models/forms/measurement/measurement_data.dart';

import '../../../../core/utils/helpers.dart';

class MeasurementModel {
  int? id;
  String? title;
  String? filePath;
  int? jobId;
  List<MeasurementDataModel>? measurements;
  String? type;
  bool? isHoverWasteFactor;

  MeasurementModel({
    this.id, 
    this.title, 
    this.measurements,
    this.filePath
  });

  MeasurementModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    jobId = json['job_id'];
    filePath =  json['file_path'];
    if (json['measurement_details'] != null && json['measurement_details']['data'] != null) {
      measurements = <MeasurementDataModel>[];
      json['measurement_details']['data'].forEach((dynamic measurement) {
        measurements!.add(MeasurementDataModel.fromJson(measurement));
      });
    }
    type = json['type']?.toString();
    isHoverWasteFactor = Helper.isTrue(json['is_hover_waste_factor']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['job_id'] = jobId;
    data['file_path'] = filePath;
    if (measurements != null) {
      for (var v in measurements!) {
        data['measurement_details']?['data'].add(v.toJson());
      }
    }
    data['type'] = type;
    data['is_hover_waste_factor'] = isHoverWasteFactor;
    return data;
  }
}
