import 'package:jobprogress/core/utils/date_time_helpers.dart';

class JobWorkFlowHistoryModel {
  int? id;
  String? stage;
  String? startDate;
  String? completedDate;
  int? modifiedBy;
  dynamic approvedBy;
  String? createdAt;
  String? updatedAt;

  JobWorkFlowHistoryModel(
      {this.id,
        this.stage,
        this.startDate,
        this.completedDate,
        this.modifiedBy,
        this.approvedBy,
        this.createdAt,
        this.updatedAt});

  JobWorkFlowHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stage = json['stage'];
    startDate = json['start_date'];
    completedDate = parseDate(json['completed_date']);
    modifiedBy = json['modified_by'];
    approvedBy = json['approved_by'];
    createdAt = parseDate(json['created_at']);
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['stage'] = stage;
    data['start_date'] = startDate;
    data['completed_date'] = completedDate;
    data['modified_by'] = modifiedBy;
    data['approved_by'] = approvedBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  static String? parseDate(String? date) {
    if(date == null) return null;
    // final tempDate = DateTimeHelper.formatDate(date, DateFormatConstants.dateServerFormat);
    return DateTimeHelper.convertHyphenIntoSlash(date.substring(0,10));
  }
}
