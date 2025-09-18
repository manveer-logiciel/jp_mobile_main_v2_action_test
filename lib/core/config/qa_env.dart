import 'package:jobprogress/core/config/firebase/firebase_config.dart';
import 'package:jobprogress/core/config/mix_panel/config.dart';
import 'package:jobprogress/core/config/pendo/index.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/justifi/client_id.dart';
import 'package:jobprogress/core/constants/launchdarkly/mobile_keys.dart';
import 'package:jobprogress/core/constants/mix_panel/index.dart';

import '../constants/beacon_client_id.dart';
import 'maps/config.dart';

class QaEnv {
  static Map<String, dynamic> config = {
    "API_URL_PREFIX": "https://qa.jobprog.net/mobile/public/api/v1/",
    "API_URL_PREFIX_V2": "https://qa.jobprog.net/mobile/public/api/v2/",
    "L5_API_URL_PREFIX": "https://qa-l5.jobprog.net/api/v1/",
    "API_URL_PREFIX_SERVER_LESS": "https://sls-qa.jobprog.net/api/v1/",
    "EXTERNAL_TEMPLATE_URL_PREFIX" : "https://qa.jobprog.net/ma/#/mobile/",
    "SRS_ORDER_ATTACHMENT_URL_PREFIX" : "https://scdn.jobprog.net/resources/",
    "FIREBASE_OPTIONS": DefaultFirebaseOptions.currentPlatform['FIREBASE_QA'],
    "GOOGLE_MAPS_API_URL_PREFIX": "https://maps.googleapis.com/maps/api/",
    "GOOGLE_MAPS_KEY": GoogleMapsKeyConfig().qa,
    "APP_URL_PREFIX" : "https://qa.jobprog.net/app/#/",
    "APP_URL_PREFIX_2" : "https://qa-app.jobprog.net/",
    CommonConstants.suppliersIds: {
      CommonConstants.srsId: 3,
      CommonConstants.srsV2Id: 206,
      CommonConstants.abcId: 1,
      CommonConstants.beaconId: 204,
      CommonConstants.abcSupplierId: 27
    },
    CommonConstants.secondFirebaseAppName: DefaultFirebaseOptions.currentPlatform['FIREBASE_QA_DATA'],

    // mix-panel configuration
    MixPanelConstants.mixPanelTokenKey : MixPanelConfig.qaToken,
    MixPanelConstants.mixPanelAnalyticsEnabledKey : MixPanelConfig.analyticsEnabled,
    CommonConstants.apiGatewayUrl : "https://pcdn.jobprog.net/api-gateway/qa-api.json",
    CommonConstants.justifiClientId: JustifiClientId.qa,
    CommonConstants.ldMobileKey: LDMobileKeys.qa,
    CommonConstants.beaconClientId: BeaconClientId.qa,
    CommonConstants.beaconBaseUrl: "https://beacon-uat-ng.becn.com/",
    CommonConstants.pendoKey: PendoKeyConfig.qa,
    CommonConstants.pendoAnalyticsEnabled: PendoKeyConfig.analyticsEnabled,
  };
}