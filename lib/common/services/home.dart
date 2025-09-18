import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/api_status.dart';
import 'package:jobprogress/common/enums/app_state.dart';
import 'package:jobprogress/common/libraries/global.dart' as globals;
import 'package:jobprogress/common/models/api_status.dart';
import 'package:jobprogress/common/models/application_info.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/common/repositories/appointment.dart';
import 'package:jobprogress/common/repositories/automation.dart';
import 'package:jobprogress/common/repositories/company_settings.dart';
import 'package:jobprogress/common/repositories/connected_third_party.dart';
import 'package:jobprogress/common/repositories/cookies.dart';
import 'package:jobprogress/common/repositories/daily_plan.dart';
import 'package:jobprogress/common/repositories/upgrade_plan.dart';
import 'package:jobprogress/common/repositories/device.dart';
import 'package:jobprogress/common/repositories/feature_flag.dart';
import 'package:jobprogress/common/repositories/firebase/firebase_realtime.dart';
import 'package:jobprogress/common/repositories/permission.dart';
import 'package:jobprogress/common/repositories/subscriber_details.dart';
import 'package:jobprogress/common/repositories/user.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/cookies.dart';
import 'package:jobprogress/common/services/dev_console/index.dart';
import 'package:jobprogress/common/services/firebase_crashlytics.dart';
import 'package:jobprogress/common/services/firestore/index.dart';
import 'package:jobprogress/common/services/free_trial_user_data/index.dart';
import 'package:jobprogress/common/services/language.dart';
import 'package:jobprogress/common/services/location/background_location_service.dart';
import 'package:jobprogress/common/services/location/loaction_service.dart';
import 'package:jobprogress/common/services/push_notifications/index.dart';
import 'package:jobprogress/common/services/shared_pref.dart';
import 'package:jobprogress/common/services/sql.dart';
import 'package:jobprogress/common/services/subscriber_details.dart';
import 'package:jobprogress/common/services/user_preferences.dart';
import 'package:jobprogress/core/constants/api_status.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/shared_pref_constants.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/core/utils/consent_helper.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/controller.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/home/controller.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/confirmation_dialog_type.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import 'connectivity.dart';
import 'firestore/auth/index.dart';

/// [HomeService] is responsible for all the required api calls that are necessary
/// for using/viewing the app. It is also responsible for all the logic related to
/// re-fetching the failed APIs and managing the status of APIs with flags
class HomeService {

  /// [apiStatuses] holds the api status along with [reCall] to be made
  Map<String, ApiStatusModel> apiStatuses = {};

  /// [update] is used to update the home page from with in service
  VoidCallback update;

  /// [homeController] is used to access data of home page with in service
  HomeController homeController;

  /// [appLifeCycleState] is a broadcast stream for listening the app life cycle state globally
  static StreamController<String> appLifeCycleState = StreamController<String>.broadcast();

  /// [HomeService] constructor call the [initApiStatusHolder] as soon as it is used
  /// It creates new status holder for holding api statuses
  HomeService({
    required this.update,
    required this.homeController,
  }) {
    initApiStatusHolder();
  }

  /// [initApiStatusHolder] - helps in initializing the api status holder with fresh data
  void initApiStatusHolder() {
    apiStatuses = {
      ApiStatusConstants.user: ApiStatusModel(reCall: loadUserData),
      ApiStatusConstants.companySettings: ApiStatusModel(reCall: loadSettingsAndStages),
      ApiStatusConstants.workflowStages: ApiStatusModel(reCall: fetchWorkflowStages),
      ApiStatusConstants.featureFlags: ApiStatusModel(reCall: getFeatureFlags),
      ApiStatusConstants.userPermissions: ApiStatusModel(reCall: getPermissions),
      ApiStatusConstants.localDbSync: ApiStatusModel(reCall: syncLocalDb),
      ApiStatusConstants.subscriberDetails: ApiStatusModel(reCall: getSubscriberDetails),
      ApiStatusConstants.registerDevice: ApiStatusModel(reCall: registerDevice),
      ApiStatusConstants.thirdParties: ApiStatusModel(reCall: fetchConnectedThirdParties),
      ApiStatusConstants.googleAccountStatus: ApiStatusModel(reCall: getGoogleAccountStatus),
      ApiStatusConstants.appointmentCount: ApiStatusModel(reCall: getAppointmentCount),
      ApiStatusConstants.dailyPlanCount: ApiStatusModel(reCall: getDailyPlanCount),
    };
  }

  /// [updateApiStatus] Updates the status of an API.
  ///
  /// Parameters:
  ///   - key: The key associated with the API.
  ///   - status: The new status of the API.
  void updateApiStatus(String key, ApiStatus status) {
      // Get the current status of the API.
      final ApiStatusModel? apiStatus = apiStatuses[key];
      
      // Update the status if the API exists.
      apiStatus?.status = status;
  }

  /// [checkAndReFetchFailedApis] Checks and re-fetches failed APIs.
  ///
  /// This function checks the status of each API in the [apiStatuses] map and
  /// re-calls the APIs that have a status of [ApiStatus.failure] or [ApiStatus.pending].
  /// If there are un-synced tables in the database, it also fetches the un-synced tables.
  ///
  /// This function is asynchronous and returns a [Future] that completes when all
  /// the APIs have been re-called and the un-synced tables have been fetched.
  Future<void> checkAndReFetchFailedApis() async {
    // Additional delay for network to set up
    await Future<void>.delayed(const Duration(seconds: 2));
    // Check if the app state is already set up, only then check for failed apis
    if (appState != JPAppState.setUpDone || !ConnectivityService.isInternetConnected) return;
  
    // List of API functions to be re-called
    List<Future<dynamic> Function()> apisToLoad = [];
  
    // Check if there are un-synced tables
    bool hasUnSyncedTable = SqlService.getUnSyncedTables().isNotEmpty;
  
    // Iterate over each API status
    apiStatuses.forEach((key, value) {
      // Check if the API status is failure or pending
      bool doReCall = (value.status == ApiStatus.failure) || (value.status == ApiStatus.pending);
      if (doReCall) {
        // Add the API re-call function to the list
        apisToLoad.add(value.reCall);
      }
    });
  
    // If there are APIs to be re-called or un-synced tables, perform the necessary actions
    if (apisToLoad.isNotEmpty || hasUnSyncedTable) {
      // Show the JP loader
      showJPLoader();
      await Future.wait([
        // Re-call each API function and catch any errors
        ...apisToLoad.map((apiToLoad) => apiToLoad.call().catchError(Helper.recordError)),
        // Fetch un-synced tables if there are any
        if (hasUnSyncedTable) SqlService.fetchUnSyncedTables(),
      ]).then((value) => initializeGlobalServices());
      // Update the UI
      update();
      // Close the JP loader
      Get.back();
    }
  }

  Future<void> requestPermissions() async {
    try {
      await PushNotificationsService.init();
    } catch (e) {
      Helper.recordError(e);
    }

    try {
      await LocationService.requestPermission();
    } catch (e) {
      Helper.recordError(e);
    }
  }

  Future<void> loadUserData() async {
    try {
      UserModel loggedInUser = await AuthService.getLoggedInUser();

      Map<String, dynamic> userParams = {
        "id": loggedInUser.id,
        "includes[0]": "company_details",
        "includes[1]": "google_client",
        "includes[2]": "dropbox_client",
        "includes[3]": "beacon_client",
        "includes[4]": "divisions",
        "includes[5]": "all_companies",
        "includes[6]": "primary_device"
      };

      Map<String, dynamic> response = await UserRepository.getUser(userParams);
      await AuthService.saveUserData(response['data']);
      updateApiStatus(ApiStatusConstants.user, ApiStatus.success);
    } catch (e) {
      updateApiStatus(ApiStatusConstants.user, ApiStatus.failure);
      Helper.recordError(e);
    }
  }

  Future<void> getCookies() async {
    try {
      await CookiesRepository.getCookies();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getFeatureFlags() async {
    try {
      await FeatureFlagRepository.getFeatureFlag();
      updateApiStatus(ApiStatusConstants.featureFlags, ApiStatus.success);
    } catch (e) {
      updateApiStatus(ApiStatusConstants.featureFlags, ApiStatus.failure);
      rethrow;
    }
  }

  Future<void> getPermissions() async {
    try {
      await PermissionRepository.getPermissions();
      UserPreferences.getUserPermission();
      updateApiStatus(ApiStatusConstants.userPermissions, ApiStatus.success);
    } catch (e) {
      updateApiStatus(ApiStatusConstants.userPermissions, ApiStatus.failure);
      rethrow;
    }
  }

  Future<void> registerDevice() async {
    try {
      await DeviceRepository.registerDevice();
      updateApiStatus(ApiStatusConstants.registerDevice, ApiStatus.success);
    } catch (e) {
      updateApiStatus(ApiStatusConstants.registerDevice, ApiStatus.failure);
      Helper.recordError(e);
    }
  }

  Future<void> getSubscriberDetails() async {
    try {
      await SubscriberDetailsRepo.getDetails();
      homeController.subscriberDetails = SubscriberDetailsService.subscriberDetails;
      updateApiStatus(ApiStatusConstants.subscriberDetails, ApiStatus.success);
    } catch (e) {
      updateApiStatus(ApiStatusConstants.subscriberDetails, ApiStatus.failure);
      rethrow;
    }
  }

  Future<void> getAutomationListing() async {
    Map<String, dynamic> param = {
      "page": 1,
    };
    try {
      await AutomationRepository().fetchAutomation(param, fromHomeScreen: true);
      updateApiStatus(ApiStatusConstants.automation, ApiStatus.success);
    } catch (e) {
      updateApiStatus(ApiStatusConstants.automation, ApiStatus.failure);
      Helper.recordError(e);
    }
  }

  Future<void> getBillingCode() async {
    try {
      String billingCode = await UpgradePlanRepository.getBillingCode();
      FreeTrialUserDataService.setBillingCode(billingCode);
      updateApiStatus(ApiStatusConstants.billingCode, ApiStatus.success);
    } catch (e) {
      updateApiStatus(ApiStatusConstants.billingCode, ApiStatus.failure);
      rethrow;
    }
  }

  Future<void> initializeGlobalServices() async {
    try {
      FirebaseRealtimeRepo.initAllStreams();
      Crashlytics.setUserAndCompanyId();
      DateTimeHelper.setUpTimeZone();
      FirestoreService.initAllStreams();
    } catch (e) {
      Helper.recordError(e);
    }
  }

  Future<void> fetchConnectedThirdParties() async {
    try {
      final connectedThirdPartyParam = <String, dynamic>{
        'name[0]': 'quickbook',
        'name[1]': 'quickbook_pay',
        'name[2]': 'quickbook_desktop',
        'name[3]': 'quickmeasure',
        'name[4]': 'eagleview',
        'name[5]': 'companycam',
        'name[6]': 'hover',
        'name[7]': 'srs',
        'name[8]': 'leappay',
        'name[9]': 'beacon',
        'name[10]': 'abc',
        'includes[0]': 'company_rate'
      };

      ConnectedThirdPartyRepository.fetchConnectedThirdParty(connectedThirdPartyParam);
      updateApiStatus(ApiStatusConstants.thirdParties, ApiStatus.success);
    } catch (e) {
      updateApiStatus(ApiStatusConstants.thirdParties, ApiStatus.failure);
      rethrow;
    }
  }

  Future<void> syncLocalDb() async {
    try {
      await SqlService.syncLocalDb();
      updateApiStatus(ApiStatusConstants.localDbSync, ApiStatus.success);
    } catch (e) {
      updateApiStatus(ApiStatusConstants.localDbSync, ApiStatus.failure);
      rethrow;
    }
  }

  Future<void> migrateOldDB() async {
    try {
      await SqlService.migrateOldDB();
      updateApiStatus(ApiStatusConstants.oldAppDbSync, ApiStatus.success);
    } catch (e) {
      Helper.recordError(e);
    }
  }

  Future<void> checkForAppUpdate() async {
    try {
      ApplicationInfo? applicationInfo = await DeviceRepository.checkForAppUpdate();
      verifyAppUpdate(applicationInfo);
    } catch (e) {
      Helper.recordError(e);
    }
  }

  Future<void> verifyAppUpdate(ApplicationInfo? applicationInfo) async {

    if (applicationInfo == null) return;

    if(applicationInfo.isApproved) {
      int oldVersion = Helper.getExtendedVersionNumber(globals.appVersion);
      int newVersion = Helper.getExtendedVersionNumber(applicationInfo.version ?? "");
      dynamic ignoredVersion = await SharedPrefService().read(PrefConstants.ignoreThisUpdate);
      ignoredVersion = Helper.getExtendedVersionNumber(ignoredVersion?.toString() ?? (globals.appVersion));
      if(oldVersion < newVersion && ignoredVersion < newVersion) {
        showAppUpdateDialog(applicationInfo);
      }
    }
  }

  void showAppUpdateDialog(ApplicationInfo? applicationInfo) {
    showJPBottomSheet(
        isDismissible: !(applicationInfo?.isForced ?? false),
        child: (JPBottomSheetController controller) {
          return JPWillPopScope(
            onWillPop: () async => (applicationInfo?.isForced ?? false) ? false : true,
            child: JPConfirmationDialog(
              icon: Icons.security_update,
              title: "new_version_available".tr
                  + (applicationInfo?.version?.isNotEmpty ?? false
                      ? "\n(${applicationInfo?.version ?? ""})" : ""),
              subTitle: "app_update_available_note".tr,
              type: applicationInfo?.isForced ?? false
                  ? JPConfirmationDialogType.alert
                  : JPConfirmationDialogType.message,
              suffixBtnText: "update".tr,
              prefixBtnText: (applicationInfo?.isForced ?? false) ? "update".tr : "later".tr,
              prefixBtnColorType: (applicationInfo?.isForced ?? false) ? JPButtonColorType.primary : null,
              onTapSuffix: () => launchAppUpdate(applicationInfo),
              onTapPrefix: (applicationInfo?.isForced ?? false)
                  ? () => launchAppUpdate(applicationInfo)
                  : () async {
                await SharedPrefService().save(PrefConstants.ignoreThisUpdate, applicationInfo?.version);
                Get.back();
              },
            ),
          );
        });
  }

  void launchAppUpdate(ApplicationInfo? applicationInfo) {
    if (!Helper.isValueNullOrEmpty(applicationInfo?.url)) {
      Helper.launchUrl(applicationInfo!.url!);
    } else {
      (applicationInfo?.device?.toLowerCase().contains("android") ?? false)
          ? Helper.launchUrl(Urls.playStoreURL)
          : Helper.launchUrl(Urls.appStoreURL);
    }
  }

  Future<void> backgroundFetches() async {
    await Future.wait([
      getGoogleAccountStatus(),
      getAppointmentCount(),
      getDailyPlanCount(),
      setTwilioTextStatus(),
      getBillingCode(),
    ]);
  }

  Future<void> getGoogleAccountStatus() async {
    await CompanySettingRepository.fetchCompanyGoogleAccountStatus().then((value) {
      updateApiStatus(ApiStatusConstants.googleAccountStatus, ApiStatus.success);
      update();
    }).catchError((dynamic e) {
      updateApiStatus(ApiStatusConstants.googleAccountStatus, ApiStatus.failure);
      Helper.recordError(e);
    });
  }

  Future<void> getAppointmentCount() async {
    await AppointmentRepository().fetchAppointmentCount().then((value) {
      updateApiStatus(ApiStatusConstants.appointmentCount, ApiStatus.success);
      update();
    }).catchError((dynamic e) {
      updateApiStatus(ApiStatusConstants.appointmentCount, ApiStatus.failure);
      Helper.recordError(e);
    });
  }

  Future<void> getDailyPlanCount() async {
    await DailyPlanRepository.setDailyPlanCount().then((value) {
      updateApiStatus(ApiStatusConstants.dailyPlanCount, ApiStatus.success);
      update();
    }).catchError((dynamic  e) {
      updateApiStatus(ApiStatusConstants.dailyPlanCount, ApiStatus.failure);
      Helper.recordError(e);
    });
  }


  Future<void> loadSettingsAndStages() async {
    try {
      await CompanySettingRepository.fetchCompanySettings();
      updateApiStatus(ApiStatusConstants.companySettings, ApiStatus.success);
      fetchWorkflowStages();
    } catch (e) {
      updateApiStatus(ApiStatusConstants.companySettings, ApiStatus.failure);
      rethrow;
    }
  }

  Future<void> fetchWorkflowStages() async {
    try {
      dynamic filterSetting = CompanySettingsService.getCompanySettingByKey(
        CompanySettingConstants.workFlowFilters,
        onlyValue: false,
      );
      homeController.fetchWorkflow.call(filterSetting);
      updateApiStatus(ApiStatusConstants.workflowStages, ApiStatus.success);
    } catch (e) {
      updateApiStatus(ApiStatusConstants.workflowStages, ApiStatus.failure);
      Helper.recordError(e);
    }
  }

  Future<void> setTwilioTextStatus() async {
    try {
      await ConsentHelper.setTwilioTextStatus();
    } catch (e) {
      Helper.recordError(e);
    }
  }

  Future<void> setFirebaseLoginToken() async {
    try {
      await FirebaseAuthService.setFirebaseLoginToken();
    } catch (e) {
      Helper.recordError(e);
    }
  }

  void setAppStateListener() {
    SystemChannels.lifecycle.setMessageHandler((state) async {
      appLifeCycleState.add(state ?? "");

      if (appState == JPAppState.setUpDone) {
        switch(state) {
          case "AppLifecycleState.resumed":
            // Helps is retaining selected language when coming from background settings
            LanguageService.initializeLanguage();
            if(Get.currentRoute != Routes.login) {
              checkAndReFetchFailedApis();
              CookiesService.validateAndRefreshCookiesIfNeeded();
              BackgroundLocationService.stopAndInitiateService();
            }
            break;
        }
      }
      return "";
    });
  }

  /// [showRetryPopup] - displays the retry pop-up with appropriate message in case:
  /// 1. No internet connection available
  /// 2. Available internet connection is unstable
  /// 3. App level or Api level error occurred
  void showRetryPopup() {
    final blockDetails = getRetryDialogDetails();
    showJPDialog(child: (_) {
      return Center(
        child: Material(
          color: JPColor.transparent,
          child: JPConfirmationDialog(
            onTapIcon: DevConsoleService.forceOpenDevConsole,
            title: blockDetails.$1,
            subTitle: blockDetails.$2,
            icon: blockDetails.$3,
            type: JPConfirmationDialogType.alert,
            prefixBtnColorType: JPButtonColorType.tertiary,
            prefixBtnText: 'retry'.tr.toUpperCase(),
            onTapPrefix: onRetryClick,
          ),
        ),
      );
    });
  }

  /// [onRetryClick] - handles the click on retry button of the retry pop-up
  void onRetryClick() {
    if (!ConnectivityService.isInternetConnected) {
      Helper.showToastMessage('please_check_your_internet_connection'.tr);
    } else {
      Get.back();
      homeController.loadAppData();
    }
  }

  /// [getRetryDialogDetails] - decides the type of message to be displayed along with icon and title
  (String title, String message, IconData icon) getRetryDialogDetails() {
    if (!ConnectivityService.isInternetConnected) {
      return ('no_connection'.tr, 'no_connection_desc'.tr, Icons.wifi_off_outlined);
    } else if (ApiProvider.isUnstableConnection) {
      return ('unstable_connection'.tr, "unstable_connection_desc".tr, Icons.perm_scan_wifi_outlined);
    } else {
      return ('error_occurred'.tr, "error_occurred_desc".tr, Icons.error_outline);
    }
  }

}