
import 'package:jobprogress/common/repositories/company_settings.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/utils/firebase/firestore.dart';
import 'package:jobprogress/core/utils/helpers.dart';

import 'auth.dart';

class SendAsEmailService {

  static bool isSendACopyAsEmailEnabled() {

    final userDefaultSettings = CompanySettingsService.getCompanySettingByKey(
        CompanySettingConstants.userDefaultSetting);

    if(userDefaultSettings is Map) {
      return Helper.isTrue(userDefaultSettings['message']?['copy_as_email']);
    } else {
      return false;
    }
  }

  static Future<void> updateSendCopyAsEmail(bool val) async {

    if(FirestoreHelpers.instance.isMessagingEnabled) return;

    try {

      dynamic params = CompanySettingsService.getCompanySettingByKey(
          CompanySettingConstants.userDefaultSetting, onlyValue: false);

      if(params is Map){
        params['value']?['message']?['copy_as_email'] = val ? 1 : 0;
      } else if (params is bool) {
        params = null;
      }

      params ??= {
        'user_id': AuthService.userDetails?.id,
        'company_id': AuthService.userDetails?.companyDetails?.id,
        'key': CompanySettingConstants.userDefaultSetting,
        'name': CompanySettingConstants.userDefaultSetting,
        'value': {
          'message': {
            'copy_as_email': val ? 1 : 0
          }
        }
      };

      await CompanySettingRepository.saveSettings(params);

    } catch (e) {
      rethrow;
    }
  }

}