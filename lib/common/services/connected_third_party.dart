import 'package:jobprogress/common/models/leappay/fee_model.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/connected_third_party_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class ConnectedThirdPartyService {
  static Map<String, dynamic> connectedThirdParty = {};

  static setConnectedParty(Map<String, dynamic> values) {
    connectedThirdParty = values;
  }

  static getConnectedPartyKey(String key) {
    if(connectedThirdParty.isNotEmpty && connectedThirdParty[key] != null) {
      return connectedThirdParty[key];
    }
    return null;
  }

  static bool isEagleViewConnected () {
    dynamic eagleView = getConnectedPartyKey(ConnectedThirdPartyConstants.eagleView);
    bool isEagleViewConnected = eagleView is Map && eagleView[ConnectedThirdPartyConstants.eagleViewUserName] != null && eagleView[ConnectedThirdPartyConstants.eagleViewUserName].toString().isNotEmpty;
    return isEagleViewConnected;
  }

  static bool isQuickMeasureConnected () {
    dynamic quickMeasure = getConnectedPartyKey(ConnectedThirdPartyConstants.quickMeasure);
    bool isQuickMeasureConnected = quickMeasure != null && !Helper.isValueNullOrEmpty(quickMeasure[ConnectedThirdPartyConstants.quickMeasureAccountId]);
    return isQuickMeasureConnected;
  }

  static bool isHoverConnected() {
    dynamic hover = getConnectedPartyKey(ConnectedThirdPartyConstants.hover);
    bool isHoverConnected = hover != null && hover[ConnectedThirdPartyConstants.hoverOwnerId] != null;
    return isHoverConnected;
  }

  static bool isSrsConnected() {
    dynamic isSrsConnected = getConnectedPartyKey(ConnectedThirdPartyConstants.srs);
    return isSrsConnected ?? false;
  }

  static bool isBeaconConnected() {
    dynamic isBeaconConnected = getConnectedPartyKey(ConnectedThirdPartyConstants.beacon);
    return isBeaconConnected ?? false;
  }

  static bool isLeapPayEnabled() {
    dynamic leapPayDetails = getConnectedPartyKey(ConnectedThirdPartyConstants.leapPay);
    dynamic defaultPaymentOption = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.defaultPaymentOption);
    return defaultPaymentOption == 'leappay'
        && leapPayDetails?['status'] == 'enabled';
  }

  static bool isAbcConnected() {
    dynamic isAbcConnected = getConnectedPartyKey(ConnectedThirdPartyConstants.abc);
    return isAbcConnected ?? false;
  }

  static LeapPayFeeModel getLeapPayCompanyRate() {
    dynamic leapPayDetails = getConnectedPartyKey(ConnectedThirdPartyConstants.leapPay);
    if(!Helper.isValueNullOrEmpty(leapPayDetails?['company_rate']?['rate']?['rate'])) { 
      return LeapPayFeeModel.fromJson(leapPayDetails['company_rate']['rate']['rate']);
    }

    return LeapPayFeeModel();
  }
}
