import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/app_state.dart';
import 'package:jobprogress/common/enums/page_type.dart';
import 'package:jobprogress/common/extensions/get_navigation/extension.dart';
import 'package:jobprogress/common/extensions/mix_panel/extension.dart';
import 'package:jobprogress/common/models/application_info.dart';
import 'package:jobprogress/common/services/background_session_tracking_service.dart';
import 'package:jobprogress/common/services/count.dart';
import 'package:jobprogress/common/services/dev_console/index.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/common/services/home.dart';
import 'package:jobprogress/common/models/subscriber/subscriber_details.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/common/repositories/firebase/firebase_realtime.dart';
import 'package:jobprogress/common/repositories/workflow.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/clock_in_clock_out.dart';
import 'package:jobprogress/common/services/connectivity.dart';
import 'package:jobprogress/common/services/intent_receiver/index.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/common/services/local_notifications/tap_handler.dart';
import 'package:jobprogress/common/services/pendo/index.dart';
import 'package:jobprogress/common/services/shared_pref.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/common/services/upload.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/automation_listing/index.dart';
import 'package:jobprogress/modules/home/widgets/filter_dialog/index.dart';
import 'package:jobprogress/routes/pages.dart';
import '../../common/models/home/filter_model.dart';
import '../../common/services/api_gateway/index.dart';
import '../../common/services/location/background_location_service.dart';
import '../../common/services/workflow_stages/workflow_service.dart';
import '../../global_widgets/bottom_sheet/index.dart';
import '../../common/services/text_selection.dart';

SharedPrefService preferences = SharedPrefService();

class HomeController extends GetxController {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  List<WorkFlowStageModel> stages = [];
  List<String> logsList = [];

  bool isStageListLoading = false;

  bool isSubContractorPrime = AuthService.isPrimeSubUser();

  SubscriberDetailsModel? subscriberDetails;
  ApplicationInfo? applicationInfo;

  HomeFilterModel filterKeys = HomeFilterModel();
  HomeFilterModel defaultFilters = HomeFilterModel();

  WorkFlowService? workFlowService;

  StreamSubscription<List<WorkFlowStageModel>>? stagesListener;

  late HomeService service;

  late ApiGatewayService apiGatewayService;

  BackgroundSessionTrackingService? sessionTrackingService;

  Map<String, dynamic> getFilterParams(String filterQueryType) {
    Map<String, dynamic> filterParams;
    switch (filterQueryType) {
      case "getStages":
        filterParams = filterKeys.toJsonForStateAPI()
          ..removeWhere(
              (dynamic key, dynamic value) => (key == null || value == null));
        break;
      case "setSetting":
        filterParams = filterKeys.toJsonForSettingAPI()
          ..removeWhere(
              (dynamic key, dynamic value) => key == null || value == null);
        break;
      default:
        filterParams = <String, dynamic>{};
        break;
    }

    return filterParams;
  }

  Future<void> loadAppData() async {
    /// NOTE: any api which can halt the entire process in case of error
    /// is marked as [important]
    if (!ConnectivityService.isInternetConnected) {
      service.showRetryPopup();
      return;
    }

    showJPLoader();
    try {
      await Future.wait([
        apiGatewayService.init(),
        // [important] - cookies api will be responsible for logging out
        // user in case of session expired or token expired
        service.getCookies(),
      ]).catchError((dynamic e) {
        // In case authorization error occurs no need to show pop-up
        if (!(e is DioException && e.type == DioExceptionType.badResponse)) {
          Get.back();
          service.showRetryPopup();
        }
        throw e;
      });

      await service.requestPermissions();

      ClockInClockOutService.init();

      await Future.wait([
        // helps in loading user data and updating throughout app
        // not marked as important as user data is already available even if
        // this api fails somehow user data is still available to be used
        service.loadUserData(),
        // [important] - used to fetch updated subscriber details
        service.getSubscriberDetails(),
        // [important] - used to load stages and company settings
        service.loadSettingsAndStages(),
        // [important] - used to load feature flags available for user
        service.getFeatureFlags(),
        // [important] - used to load user permissions
        service.getPermissions(),
        // [important] - used to set up local data
        service.syncLocalDb(),
        // [important] - used to fetch connected third parties
        service.fetchConnectedThirdParties(),
        // used to fetch user token in case in firebase messaging is enabled
        service.setFirebaseLoginToken(),
      ]).catchError((dynamic e) {
        Get.back();
        service.showRetryPopup();
        throw e;
      });

      // if everything goes well finally global services will be initialized
      await service.initializeGlobalServices();
      update();
      Get.back();
      appState = JPAppState.setUpDone;

      Future.wait([
        // set of api calls that are of low importance
        service.backgroundFetches(),
        // register device has no direct use on home so it can be a no blocking process
        service.registerDevice(),
        // checking for updated can also be done in background, update dialog will be displayed
        // any active screen and will block the entire process
        service.checkForAppUpdate(),
        // used to set up local data from old app
        service.migrateOldDB(),
        // initializing LaunchDarkly Service
        LDService.init(),
        // used to fetch automation listing if feature flag is enabled
      ]).then((value) {
        // initializing Pendo Service
        // Temporarily moving Pendo initialization after LD initialization
        // to add language details in pendo's visitor data
        PendoService.init();
        // Initialize text selection service after LaunchDarkly
        TextSelectionService.initialize();

        if(LDService.hasFeatureEnabled(LDFlagKeyConstants.workflowAutomationLogs) && FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.automation])) {
          service.getAutomationListing();
        }
        // location tracker needs not block the entire process so it is marked as
        // not awaiting operation
        BackgroundLocationService.init();
        sessionTrackingService?.startApiCallTimer();
      });
    } catch (e) {
      rethrow;
    } finally {
      if (appState == JPAppState.setUpDone) {
        LocalNotificationHandler.checkForPendingPayloadAndView();
        IntentReceiverService.setUp();
      }
      DevConsoleService.init();
    }
  }

  void navigateToJobListing(String stageID) {
    Get.toNamed(Routes.jobListing, arguments: {
      NavigationParams.stageId: stageID,
      NavigationParams.filterParams: filterKeys
    });
  }

  void navigateToCustomerNdJobSearch() {
    Get.offCurrentToNamed(Routes.customerJobSearch,
        arguments: {NavigationParams.pageType: PageType.home});
  }

  void showNotificationView() {
    Get.offCurrentToNamed(Routes.notificationListing);
  }


 void showAutomationView() {
    CountService.automationCount = 0;
    update();
    showJPBottomSheet(
      child: (_) => const AutomationListingView(), 
      isScrollControlled: true
    );
  }

  void refreshPage() async {
    await loadAppData();
  }

  @override
  void onInit() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      apiGatewayService = Get.find();
      service = HomeService(update: update, homeController: this);
      service.setAppStateListener();
      initWorkFlowService();
      initSessionTrackingService();
      await loadAppData();
    });
    super.onInit();
  }

  /////////////////////////   FILTER DIALOG HANDLING    ////////////////////////

  void openFilterDialog() {
    showJPGeneralDialog(
        child: (controller) => HomeFilterDialogView(
              selectedFilters: filterKeys,
              defaultFilters: defaultFilters,
              onApply: (HomeFilterModel params) {
                if (defaultFilters != params) {
                  filterKeys = params;
                  updateFilterSettingsOnServer();
                }
              },
            ));
  }

  void updateFilterSettingsOnServer() {
    toggleIsStageLoading(true);
    WorkflowRepository.updateWorkflowSetting(getFilterParams("setSetting"))
        .whenComplete(() {
      defaultFilters = HomeFilterModel.copy(filterKeys);
      workFlowService?.fetchStages(params: getFilterParams("getStages"));
    }).trackFilterEvents();
  }

  //////////////////////   APPLICATION UPDATE HANDLING    //////////////////////


  @override
  void onClose() async {
    await FirebaseRealtimeRepo.disposeAllStreams();
    await UploadService.pauseAllUploads();
    await ConnectivityService.disposeConnectivity();
    super.onClose();
  }

  void refreshWorkFlowStages(List<WorkFlowStageModel> stages) {
    this.stages = stages;
    toggleIsStageLoading(false);
  }

  void workFlowStagesListener() {
    stagesListener = workFlowService?.listen((stages) {
      if(stages.isNotEmpty) {
        refreshWorkFlowStages(stages);
      }
    });
  }

  void initWorkFlowService() async {
    workFlowService = WorkFlowService.get();
    await workFlowService?.destroyAllListeners();
    workFlowStagesListener();
  }

  Future<void> fetchWorkflow(dynamic filterSetting) async {
    try {
      toggleIsStageLoading(true);
      if (filterSetting is Map<String, dynamic>) {
        filterKeys = HomeFilterModel.fromJson(filterSetting);
      }
      defaultFilters = HomeFilterModel.copy(filterKeys);
      await workFlowService?.fetchStages(params: getFilterParams("getStages"));
    } catch (e) {
      rethrow;
    } finally {
      toggleIsStageLoading(false);
    }
  }

  void toggleIsStageLoading(bool value) {
    isStageListLoading = value;
    update();
  }

  void initSessionTrackingService() async {
    sessionTrackingService = BackgroundSessionTrackingService.get();
  }

}
