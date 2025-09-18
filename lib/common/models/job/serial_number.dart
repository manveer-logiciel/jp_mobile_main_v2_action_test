
class SerialNumberModel {

  String? jobAltId;
  String? jobLeadNumber;

  SerialNumberModel({
    this.jobAltId,
    this.jobLeadNumber,
  });

  SerialNumberModel.fromJson(Map<String, dynamic> json) {
    jobAltId = json['job_alt_id'].toString();
    jobLeadNumber = json['job_lead_number'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['job_alt_id'] = jobAltId;
    data['job_lead_number'] = jobLeadNumber;
    return data;
  }
}
