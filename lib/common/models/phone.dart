import 'package:get/get.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class PhoneModel {
  int? id;
  String? number;
  String? label;
  String? ext;
  int? isPrimary;
  String? consentStatus;
  String? consentCreatedAt;
  String? consentEmail;
  bool showConsentStatus = false;

  /// [consentStatusObs] helps in refreshing the UI of consent badges all over the place
  Rx<String> consentStatusObs = "".obs;

  PhoneModel({
    this.id,
    this.label,
    required this.number,
    this.ext,
    this.isPrimary,
    this.consentStatus,
    this.consentCreatedAt,
    this.consentEmail,
    this.showConsentStatus = false
  });

  PhoneModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? "") ?? -1;
    label = json['label']?.toString();
    
    if(json['number'] != null) {
      number = json['number']?.toString();
    }

    if(json['phone'] != null) {
      number = json['phone']?.toString();
    }
    if(!Helper.isValueNullOrEmpty(json['ext'])) {
      ext = json['ext']?.toString();
    }

    if(!Helper.isValueNullOrEmpty(json['extension'])) {
      ext = json['extension']?.toString();
    }
    
    isPrimary = json['is_primary']?.toInt();
  }

  Map<String, dynamic> toJson({bool withUnmaskNumber = false}) {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['label'] = label;
    data['number'] = withUnmaskNumber ? PhoneMasking.unmaskPhoneNumber(PhoneMasking.maskPhoneNumber(number ?? '')) : number;
    data['ext'] = ext;
    data['is_primary'] = isPrimary;
    return data;
  }

  /// [setObsConsentStatus] helps in setting up the [consentStatusObs] from the [consentStatus]
  void setObsConsentStatus() {
    consentStatusObs.value = consentStatus ?? "";
  }
}
