import 'package:jobprogress/core/config/firebase/firebase_config.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/justifi/client_id.dart';
import 'package:jobprogress/core/constants/launchdarkly/mobile_keys.dart';
import 'package:jobprogress/core/constants/mix_panel/index.dart';

import '../constants/beacon_client_id.dart';
import 'maps/config.dart';
import 'mix_panel/config.dart';
import 'pendo/index.dart';

class QaRcEnv {
  static Map<String, dynamic> config = {
    "API_URL_PREFIX": "https://qa-rc-api.jobprog.net/api/public/api/v1/",
    "API_URL_PREFIX_V2": "https://qa-rc-api.jobprog.net/api/public/api/v2/",
    "L5_API_URL_PREFIX": "https://qa-rc-l5.jobprog.net/api/v1/",
    "API_URL_PREFIX_SERVER_LESS": "https://sls-qa-rc.jobprog.net/api/v1/",
    "EXTERNAL_TEMPLATE_URL_PREFIX" : "https://qa-rc-app.jobprog.net/#/mobile/",
    "SRS_ORDER_ATTACHMENT_URL_PREFIX" : "https://scdn.jobprog.net/resources/",
    "FIREBASE_OPTIONS": DefaultFirebaseOptions.currentPlatform['FIREBASE_QA_RC'],
    "GOOGLE_MAPS_API_URL_PREFIX": "https://maps.googleapis.com/maps/api/",
    "GOOGLE_MAPS_KEY": GoogleMapsKeyConfig().qa,
    "APP_URL_PREFIX" : "https://qa-rc-app.jobprog.net/#/",
    "APP_URL_PREFIX_2" : "https://qa-rc-app.jobprog.net/",
    CommonConstants.suppliersIds: {
      CommonConstants.srsId: 2,
      CommonConstants.srsV2Id: 25,
      CommonConstants.abcId: 1,
      CommonConstants.beaconId: 22,
      CommonConstants.abcSupplierId: 27
    },
    CommonConstants.secondFirebaseAppName : DefaultFirebaseOptions.currentPlatform['FIREBASE_QA_RC_DATA'],
    CommonConstants.externalTemplateCompanyIds: [151],

    // mix-panel configuration
    MixPanelConstants.mixPanelTokenKey : MixPanelConfig.qaRCToken,
    MixPanelConstants.mixPanelAnalyticsEnabledKey : MixPanelConfig.analyticsEnabled,
    CommonConstants.apiGatewayUrl : "https://pcdn.jobprog.net/api-gateway/qa-rc-api.json",
    CommonConstants.justifiClientId: JustifiClientId.qaRc,
    CommonConstants.ldMobileKey: LDMobileKeys.qaRC,
    CommonConstants.beaconClientId: BeaconClientId.qaRc,
    CommonConstants.beaconBaseUrl: "https://beacon-uat-ng.becn.com/",
    CommonConstants.pendoKey: PendoKeyConfig.qaRc,
    CommonConstants.pendoAnalyticsEnabled: PendoKeyConfig.analyticsEnabled,
  };
}