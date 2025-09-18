import 'package:jobprogress/common/services/language.dart';
import 'package:jobprogress/common/services/subscriber_details.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:pendo_sdk/pendo_sdk.dart';
import '../../../core/config/app_env.dart';
import '../../../core/utils/helpers.dart';
import '../auth.dart';

class PendoService {

  /// [analyticsEnabled] helps is deciding whether events should be tracked or not
  static bool analyticsEnabled = AppEnv.config[CommonConstants.pendoAnalyticsEnabled] ?? false;

  /// [init] initializes Pendo SDK and starts a session for the current user.
  static Future<void> init() async {
    // No need to start service if analytics are not enabled
    if (!analyticsEnabled) return;

    try {
      // Retrieve the Pendo API key from the app's environment configuration.
      var pendoKey = AppEnv.envConfig[CommonConstants.pendoKey];

      // Define Pendo SDK options (using Observable integration type).
      final dynamic options = getPendoOptions();

      // Set up the Pendo SDK with the API key and options.
      await PendoSDK.setup(pendoKey, pendoOptions: options);

      // Start a Pendo session for the current user.
      await startSession();
    } catch (e) {
      Helper.recordError(e);
    }
  }

  /// [getPendoOptions] Define Pendo SDK options (using Observable integration type).
  static Map<String, dynamic> getPendoOptions() {
    return {
      'IntegrationType': 'Observable'
    };
  }

  /// Starts a Pendo session for the current user.
  static Future<void> startSession() async {
    // No need to start session if analytics are not enabled
    if (!analyticsEnabled) return;

    // Get the current user's ID.
    final visitorId = AuthService.userDetails?.id.toString();

    // If the user ID is invalid, do not start a session.
    if (Helper.isValueNullOrEmpty(visitorId)) return;

    // Gather user and account data for Pendo analytics.
    final pendoData = getPendoData();
    final String accountId = AuthService.userDetails?.companyDetails?.id.toString() ?? "";
    final Map<String, dynamic> visitorData = pendoData['visitor'];
    final Map<String, dynamic> accountData = pendoData['account'];

    // Start the Pendo session with the collected data.
    await PendoSDK.startSession(
      visitorId,
      accountId,
      visitorData,
      accountData,
    );
  }

  /// [getPendoData] Collects user and account data to be sent to Pendo.
  static Map<String, dynamic> getPendoData() {

    // Retrieve user details and company details.
    final userData = AuthService.userDetails;
    final companyDetails = SubscriberDetailsService.subscriberDetails;

    // Construct a map containing user-specific information.
    Map<String, dynamic> visitor = {
      "id": userData?.id,
      "email": userData?.email,
      "userName":  userData?.fullName,
      "userRole": userData?.groupName ?? "",
      "appLanguageMobile": LanguageService.languageCode,
    };

    // Construct a map containing company-related information.
    Map<String, dynamic> account = {
      "id": companyDetails?.id ?? "",
      "companyName": companyDetails?.companyName ?? "",
      "noOfUserLicenses": companyDetails?.licenseList?.length ?? 0,
      "noOfSubLicenses": companyDetails?.subscription?.subContractorUserLicenses ?? 0,
      "companyPlan": companyDetails?.subscription?.plan?.product ?? "",
      "abcSupplier": companyDetails?.thirdPartyConnections?.abcSupplier ?? false,
      "srsSupplier": companyDetails?.thirdPartyConnections?.srsSupplier ?? false,
      "eagleview": companyDetails?.thirdPartyConnections?.eagleview ?? false,
      "companyCam": companyDetails?.thirdPartyConnections?.companyCam ?? false,
      "googleSheet": companyDetails?.thirdPartyConnections?.googleSheet ?? false,
      "qbOnline": companyDetails?.thirdPartyConnections?.quickbook ?? false,
      "qbDesktop": companyDetails?.thirdPartyConnections?.quickbookDesktop ?? false,
      "qbPay": companyDetails?.thirdPartyConnections?.quickbookPay ?? false,
      "hover": companyDetails?.thirdPartyConnections?.hover ?? false,
      "quickMeasure": companyDetails?.thirdPartyConnections?.quickmeasure ?? false,
      "dropbox": companyDetails?.thirdPartyConnections?.dropbox ?? false,
      "angiLeads": companyDetails?.thirdPartyConnections?.homeAdvisor ?? false,
      "projectMapIt": companyDetails?.thirdPartyConnections?.projectMapIt ?? false,
      "greenSky": companyDetails?.thirdPartyConnections?.greensky,
    };

    // Return a map containing both visitor and account data.
    return {
      'visitor': visitor,
      'account': account
    };
  }

  static Future<void> updatedVisitorLanguage() async {
    await PendoSDK.setVisitorData({
      "appLanguageMobile": LanguageService.languageCode
    });
  }
}