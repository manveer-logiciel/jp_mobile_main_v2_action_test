import 'package:jobprogress/core/constants/company_seetings.dart';

class CompanySettingsService {
  static Map<String, dynamic> companySettings = {};
  static Map<String, dynamic> companyGoogleAccount = {};

  static setCompanySettings(List<dynamic> settings) {
    companySettings.clear();
    for (var setting in settings) {
      companySettings[setting['key']] =  setting;
    }
  }

  static getCompanySettingByKey(String key, {bool onlyValue = true}) {
    if(companySettings.isNotEmpty && companySettings[key] != null) {
      return onlyValue ? companySettings[key]['value'] : companySettings[key];
    }

    return false;
  }

  static bool updateCompanySettingByKey(String key, String value) {
    if(companySettings.isNotEmpty && companySettings[key] != null) {
      if(companySettings[key] is Map) {
        companySettings[key]["value"] = value;
      } else {
        companySettings[key] = value;
      }
      return true;
    }
    return false;
  }

  static void removeSettings() {
    companySettings = {};
  }

  static void addOrReplaceCompanySetting(String key, dynamic setting) {
    companySettings[key] = setting;
  }

  static String getDefaultPaymentOption() {
    dynamic defaultPaymentOption = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.defaultPaymentOption);
    return defaultPaymentOption is List ? '' : defaultPaymentOption;
  }

  static void mapDivisionCompanySettingsWithGlobalSettings(List<dynamic> divisionSettings) {
    List<String> divisionSettingKeys = [
      CompanySettingConstants.defaultPaymentOption,
      CompanySettingConstants.defaultLeapPayPaymentMethod,
      CompanySettingConstants.leapPayFeePassOverEnabled
    ];

    for (var setting in divisionSettings) {
      if(divisionSettingKeys.contains(setting['key'])) {
        companySettings[setting['key']] = setting;
      }
    }
  }
}