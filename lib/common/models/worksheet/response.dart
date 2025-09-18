import 'worksheet_model.dart';

class WorksheetResponseModel {

  int? jobId;
  String? jobPrice;
  String? taxRate;
  WorksheetModel? worksheet;
  Map<String, dynamic>? settingsJson;

  WorksheetResponseModel({
    this.jobId,
    this.jobPrice,
    this.taxRate,
    this.worksheet
  });

  WorksheetResponseModel.fromJson(Map<String, dynamic> json) {
    jobId = int.tryParse(json['job_id'].toString());
    jobPrice = json['job_price']?.toString();
    taxRate = json['tax_rate']?.toString();
    settingsJson = json['worksheet'] is Map ? json['worksheet'] : null;
    worksheet = json['worksheet'] is Map
        ? WorksheetModel.fromWorksheetJson(json['worksheet']) : null;
    if (worksheet != null) worksheet?.setWorksheetFile(json['worksheet']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =<String, dynamic>{};
    data['job_id'] = jobId;
    data['job_price'] = jobPrice;
    data['tax_rate'] = taxRate;
    if (worksheet != null) {
      data['worksheet'] = worksheet!.toJson();
    }
    return data;
  }
}