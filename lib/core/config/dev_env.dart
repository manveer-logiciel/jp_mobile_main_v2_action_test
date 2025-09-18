import 'package:jobprogress/core/config/firebase/firebase_config.dart';
import 'package:jobprogress/core/config/maps/config.dart';
import 'package:jobprogress/core/config/pendo/index.dart';
import 'package:jobprogress/core/constants/beacon_client_id.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/justifi/client_id.dart';
import 'package:jobprogress/core/constants/launchdarkly/mobile_keys.dart';
import 'package:jobprogress/core/constants/mix_panel/index.dart';

import 'mix_panel/config.dart';

class DevEnv {
  static Map<String, dynamic> config = {
    "API_URL_PREFIX": "https://dev.jobprog.net/api/v1/",
    "API_URL_PREFIX_V2": "https://dev.jobprog.net/api/v2/",
    "L5_API_URL_PREFIX": "https://dev-l5.jobprog.net/api/v1/",
    "API_URL_PREFIX_SERVER_LESS": "https://sls-dev.jobprog.net/api/v1/",
    "FIREBASE_OPTIONS": DefaultFirebaseOptions.currentPlatform['FIREBASE_DEV'],
    "GOOGLE_MAPS_API_URL_PREFIX": "https://maps.googleapis.com/maps/api/",
    "SRS_ORDER_ATTACHMENT_URL_PREFIX" : "https://scdn.jobprog.net/resources/",
    "GOOGLE_MAPS_KEY": GoogleMapsKeyConfig().dev,
    "EXTERNAL_TEMPLATE_URL_PREFIX" : "https://dev.jobprog.net/qb/#/mobile/",
    "APP_URL_PREFIX" : "https://dev-app.jobprog.net/#/",
    "APP_URL_PREFIX_2" : "https://dev-app.jobprog.net/",
    CommonConstants.suppliersIds: {
      CommonConstants.srsId: 3,
      CommonConstants.srsV2Id: 181,
      CommonConstants.abcId: 1,
      CommonConstants.beaconId: 173,
      CommonConstants.abcSupplierId: 188
    },
    CommonConstants.secondFirebaseAppName: DefaultFirebaseOptions.currentPlatform['FIREBASE_DEV_DATA'],

    // These company ids are for opening proposal and merge templates in external Web-view.
    // 15396 : shivay.test@trade.com
    // 15012 : pawan.arora@logicielsolutions.co.in
    CommonConstants.externalTemplateCompanyIds: [15396],

    // mix-panel configuration
    MixPanelConstants.mixPanelTokenKey : MixPanelConfig.devToken,
    MixPanelConstants.mixPanelAnalyticsEnabledKey : MixPanelConfig.analyticsEnabled,
    CommonConstants.apiGatewayUrl : "https://pcdn.jobprog.net/api-gateway/dev-api.json",
    CommonConstants.justifiClientId: JustifiClientId.dev,
    CommonConstants.ldMobileKey: LDMobileKeys.dev,
    CommonConstants.beaconClientId: BeaconClientId.dev,
    CommonConstants.beaconBaseUrl: "https://beacon-uat-ng.becn.com/",
    CommonConstants.pendoKey: PendoKeyConfig.dev,
    CommonConstants.pendoAnalyticsEnabled: PendoKeyConfig.analyticsEnabled,
  };
}