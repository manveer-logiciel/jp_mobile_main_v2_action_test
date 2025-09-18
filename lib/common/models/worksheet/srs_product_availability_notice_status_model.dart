import '../../../core/constants/company_seetings.dart';

class SRSProductAvailabilityNoticeStatusModel {
  int userId;
  int companyId;
  bool checked;

  SRSProductAvailabilityNoticeStatusModel({
    required this.userId,
    required this.companyId,
    required this.checked
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['company_id'] = companyId;
    data['user_id'] = userId;
    data['key'] = CompanySettingConstants.srsProductAvailabilityNoticeStatus;
    data['name'] = CompanySettingConstants.srsProductAvailabilityNoticeStatus;
    data['value'] = checked;
    return data;
  }
}