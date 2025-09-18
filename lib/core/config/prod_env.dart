import 'package:jobprogress/core/config/firebase/firebase_config.dart';
import 'package:jobprogress/core/config/mix_panel/config.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/justifi/client_id.dart';
import 'package:jobprogress/core/constants/launchdarkly/mobile_keys.dart';
import 'package:jobprogress/core/constants/mix_panel/index.dart';

import '../constants/beacon_client_id.dart';
import 'maps/config.dart';
import 'pendo/index.dart';

class ProdEnv {
  static Map<String, dynamic> config = {
    "API_URL_PREFIX": "https://jobprogress.com/api/public/api/v1/",
    "API_URL_PREFIX_V2": "https://jobprogress.com/api/public/api/v2/",
    "L5_API_URL_PREFIX": "https://api-prod.jobprogress.com/l5/api/v1/",
    "API_URL_PREFIX_SERVER_LESS" : "https://sls-api.jobprogress.com/api/v1/",
    "FIREBASE_OPTIONS": DefaultFirebaseOptions.currentPlatform['FIREBASE_PROD'],
    "GOOGLE_MAPS_API_URL_PREFIX": "https://maps.googleapis.com/maps/api/",
    "GOOGLE_MAPS_KEY": GoogleMapsKeyConfig().prod,
    "SRS_ORDER_ATTACHMENT_URL_PREFIX" : "https://cdn.jobprogress.com/resources/",
    "EXTERNAL_TEMPLATE_URL_PREFIX" : "https://jobprogress.com/app/#/mobile/",
    "APP_URL_PREFIX" : "https://jobprogress.com/app/#/",
    "APP_URL_PREFIX_2" : "https://www.jobprogress.com/",
    CommonConstants.suppliersIds: {
      CommonConstants.srsId: 89,
      CommonConstants.srsV2Id: 6408,
      CommonConstants.abcId: 1,
      CommonConstants.beaconId: 6131,
      CommonConstants.abcSupplierId: 6593
    },
    CommonConstants.secondFirebaseAppName : DefaultFirebaseOptions.currentPlatform['FIREBASE_PROD_DATA'],
    CommonConstants.externalTemplateCompanyIds: [151],
    // mix-panel configuration
    MixPanelConstants.mixPanelTokenKey : MixPanelConfig.prodToken,
    MixPanelConstants.mixPanelAnalyticsEnabledKey : MixPanelConfig.analyticsEnabled,
    CommonConstants.justifiClientId: JustifiClientId.prod,
    CommonConstants.apiGatewayUrl : "https://pcdn.jobprogress.com/api-gateway/api.json",
    CommonConstants.ldMobileKey: LDMobileKeys.prod,
    CommonConstants.beaconClientId: BeaconClientId.prod,
    CommonConstants.beaconBaseUrl: "https://beaconproplus.com/",
    CommonConstants.pendoKey: PendoKeyConfig.prod,
    CommonConstants.pendoAnalyticsEnabled: PendoKeyConfig.analyticsEnabled,
  };
}