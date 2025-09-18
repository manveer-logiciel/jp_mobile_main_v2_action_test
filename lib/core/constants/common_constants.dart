
class CommonConstants {

  /// avoidGlobalCancelToken : can be used when don't want to use global
  /// cancelToken for cancelling api request
  /// Use : pass [CommonConstants.avoidGlobalCancelToken] in query params of api request
  static Map<String, dynamic> avoidGlobalCancelToken = {
    'isGlobalCancelTokenAvoided' : true
  };

  /// ignoreToastQueryParam can be used when don't want to show toast message
  /// on api call error
  static Map<String, dynamic> ignoreToastQueryParam = {
    'ignoreToast' : true,
  };

  static String customerUserType = 'customer';
  static String unAssignedUserId = 'unassigned';
  static String otherOptionId = 'other';
  static String customerOptionId = 'customer';
  static String suppliersIds = 'SUPPLIERS_IDS';
  static String abcId = 'ABC_ID';
  static String srsId = 'SRS_ID';
  static String srsV2Id = 'SRS_V2_ID';
  static String beaconId = 'BEACON_ID';
  static String noneId = 'none';
  static String secondFirebaseAppName = 'JP_DATA_FIREBASE_PROJECT';
  static String externalTemplateCompanyIds = 'external_template_company_ids';
  static String apiGatewayUrl = 'API_GATEWAY_URL';
  static String justifiClientId = 'JUSTIFI_CLIENT_ID';
  static String ldMobileKey = 'LD_MOBILE_KEY';
  static String beaconClientId = 'BEACON_CLIENT_ID';
  static String beaconBaseUrl = 'BEACON_BASE_URL';
  static String pendoKey = 'PENDO_KEY';
  static String pendoAnalyticsEnabled = 'PENDO_ANALYTICS_ENABLED';
  static String abcSupplierId = 'ABC_SUPPLIER_ID';

  static int maxAllowedFileSize = 52428800; // Size is in bytes
  static int maxAllowedEmailFileSize = 7340032; // Size is in bytes
  static int singleAttachmentMaxSize = 10 * 1024 * 1024; // 10MB
  static int totalAttachmentMaxSize = 20 * 1024 * 1024; // 20MB
  static int flagBaseSize = 157286400; // 150MB
  
  static bool restrictFolderStructure = true;
  static const int transitionDuration = 150;

  static const String leapSupportUrl = 'https://leaptodigital.com/contact/';
  static String unAssignedStageGroup = 'unassigned';
  static String group = 'group';

  static int templateWidth = 794;
}