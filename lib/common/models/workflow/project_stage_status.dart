import 'package:jobprogress/common/models/workflow/project_stages.dart';

class ProjectStatusModel {
  int? id;
  int? customerId;
  String? name;
  String? divisionCode;
  String? duration;
  String? createdAt;
  String? createdDate;
  String? updatedAt;
  String? description;
  int? parentId;
  ProjectStageModel? status;
  int? awarded;

  ProjectStatusModel(
      {this.id,
        this.customerId,
        this.name,
        this.divisionCode,
        this.duration,
        this.createdAt,
        this.createdDate,
        this.updatedAt,
        this.description,
        this.parentId,
        this.status,
        this.awarded,
      });

  ProjectStatusModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    name = json['name'];
    divisionCode = json['division_code'];
    duration = json['duration'];
    createdAt = json['created_at'];
    createdDate = json['created_date'];
    updatedAt = json['updated_at'];
    description = json['description'];
    parentId = json['parent_id'];
    status = json['status'] != null ? ProjectStageModel.fromJson(json['status']) : null;
    awarded = json['awarded'];
  }
}

