import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/core/constants/consent_status_constants.dart';
import 'package:jobprogress/core/utils/consent_helper.dart';

class PhoneConsentModel {
  String? id;
  String? phoneNumber;
  String? status;
  String? email;
  String? createdAt;

  PhoneConsentModel({
    this.id,
    this.phoneNumber,
    this.status,
    this.email,
    this.createdAt
  });

  PhoneConsentModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    phoneNumber = json['phone_number']?.toString();
    if(ConsentHelper.isStatusResendStatus(json['status']?.toString(), json['created_at']?.toString())){
      status = ConsentStatusConstants.resend;
    } else {
      status = json['status']?.toString();
    }
    email = json['email']?.toString();
    createdAt = json['created_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['phone_number'] = phoneNumber;
    data['status'] = status;
    data['email'] = email;
    data['created_at'] = createdAt;
    return data;
  }

  /// [toPhoneModel] will convert [PhoneConsentModel] to [PhoneModel]
  PhoneModel? toPhoneModel() {
    // Checking if consent was sent 48 hours ago and still in pending state
    // manually setting the status to resend consent
    if(ConsentHelper.isStatusResendStatus(status, createdAt)){
      status = ConsentStatusConstants.resend;
    }
    return PhoneModel(
      number: phoneNumber,
      consentStatus: status,
      consentEmail: email,
      consentCreatedAt: createdAt
    );
  }
}
