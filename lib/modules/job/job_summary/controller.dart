
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/calendars.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/file_upload.dart';
import 'package:jobprogress/common/extensions/mix_panel/extension.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/job/customer_info.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/request_params.dart';
import 'package:jobprogress/common/models/job_summary/customize/section_item.dart';
import 'package:jobprogress/common/models/job_summary/customize/settings.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/models/schedules/schedules.dart';
import 'package:jobprogress/common/models/sql/uploader/file_uploader_params.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/sql/user/user_param.dart';
import 'package:jobprogress/common/models/sql/user/user_response.dart';
import 'package:jobprogress/common/models/workflow/service_params.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/common/repositories/chats.dart';
import 'package:jobprogress/common/repositories/customer_listing.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/repositories/schedule.dart';
import 'package:jobprogress/common/repositories/sql/user.dart';
import 'package:jobprogress/common/repositories/work_flow_stages.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/cookies.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/common/services/files_listing/quick_actions.dart';
import 'package:jobprogress/common/services/job/index.dart';
import 'package:jobprogress/common/services/job/quick_action_helper.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/common/services/upload.dart';
import 'package:jobprogress/common/services/workflow_stages/index.dart';
import 'package:jobprogress/core/constants/chats.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/constants/mix_panel/titles.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jobprogress/global_widgets/recent_files/controller.dart';
import 'package:jobprogress/modules/call_logs/index.dart';
import 'package:jobprogress/modules/task/listing/page.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../common/enums/job_quick_action_callback_type.dart';
import '../../../common/services/job/job_summary/quick_actions.dart';
import '../../../common/services/auth.dart';
import '../../../common/services/progress_board/add_to_progress_board.dart';
import '../../../core/utils/job_price_update_helper.dart';

class JobSummaryController extends GetxController with GetTickerProviderStateMixin{

  JobModel? job; // job model is used to store job data
  WorkFlowStagesServiceParams? workFlowStagesParams; // It is used to store workflow stages data

  String selectedSlug = 'job_overview';
  int? recurringEmailCount;

  bool isLoading = true; // isLoading is used used to manage loading state
  bool isSubContractorPrime = AuthService.isPrimeSubUser();
  bool isJobDetailExpanded = true; // isJobDetailExpanded is used to expand details on click of details

  late TabController tabController; // It helps in switching between, Job Info, customer info and contact persons

  List<CustomerInfo> customerInfo = []; // It is used to store all the available data data for customer
  List<JPMultiSelectModel> users = [];

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> secondaryDrawerKey = GlobalKey<ScaffoldState>();

  SchedulesModel? schedule;

  String? jobAwardedStageCode ;

  /// List of section items to display in the job overview.
  ///
  /// This list contains items that can be customized by the user.
  /// It includes sections like job, customer, and contact persons.
  List<JobOverviewSectionItem> sectionItems = [];

  int jobId = Get.arguments == null ? -1 : Get.arguments[NavigationParams.jobId] ?? -1; // jobId is used to load job
  int customerId = Get.arguments == null ? -1 : Get.arguments[NavigationParams.customerId] ?? -1;
  bool autoNavigateToJobDetails = Get.arguments?[NavigationParams.autoNavigateToJobDetails] ?? false;
  bool autoNavigateToSaleAutomation = Get.arguments?[NavigationParams.showSaleAutomationScreen] ?? false;
  @override
  void onInit() {
    // initializing tab controller
    tabController = TabController(length: 3, vsync: this);

    // setting up listener to update state when tab is changed
    tabController.addListener(() {
      toggleIsJobExpanded(true);
      update();
    });

    // loading job from server
    if(!RunModeService.isUnitTestMode) {
      // setting up overview tabs based on user settings
      setOverviewTabs();
      fetchJob();
      setUserData();
    }

    super.onInit();
  }

  // setUserData() : is used to update user data is user model does not have customer ID
  Future<void> setUserData() async {
    UserModel? userDetails = AuthService.userDetails;
    if(userDetails?.customerId == null) {
      Map<String, dynamic> data = {"customer_id": customerId};
      await AuthService.updateUserData(data);
    }
  }

  // fetchJob() : is used to load job from server along with initializing necessary things
  Future<void> fetchJob() async {

    try {
      List<dynamic> customerFlagsIncludes = ["customer.flags","customer.flags.color"];

      // getting request params
      Map<String, dynamic> params = JobRequestParams.forJobSummary(jobId, additionalIncludes: customerFlagsIncludes);

      final List<dynamic> responses = await Future.wait([
        JobRepository.fetchJob(jobId, params: params),
        fetchRecurringEmailCount(),
        JobRepository.getJobAwardedStage()
      ]);

      if(responses[0]['job'] != null) {
        job = responses[0]['job']; // initializing job

        setUpCustomerInfo(); // setting up customer info

        workFlowStagesParams = await WorkFlowStagesService.setUpWorkFlowStagesParams(job!); // setting up workflow stages

        if(workFlowStagesParams!.isProject) {
          await getAllUsers();
        }

        List<Future<dynamic>> pendingApis = [
          fetchCustomerMeta(),
        ];

        if(!(job?.isContactSameAsCustomer?? false)) {
          pendingApis.add(fetchJobMeta());
        }
        pendingApis.add(fetchTextsMeta());

        await Future.wait(pendingApis);
      }

      if(responses[2] is String) {
        jobAwardedStageCode = responses[2];
        setDataForMoveStagePermission();
      }

      if(autoNavigateToJobDetails) {
        navigateToJobDetails();
      }

      await CookiesService.validateAndRefreshCookiesIfNeeded();
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      autoNavigateToJobDetails = false;
      showSalesAutomationScreen(job);
      update();
    }
  }

  Future<void> showSalesAutomationScreen(JobModel? job) async {
    if (Helper.isValueNullOrEmpty(job?.stages)) return;

    WorkFlowStageModel? stage = job?.stages?.firstOrNull;

    dynamic companySettingForSaleAutomation  = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.saleAutomation);
    bool doShowSalesAutomation = Helper.isTrue(companySettingForSaleAutomation is Map ? companySettingForSaleAutomation[CompanySettingConstants.enableForMobile] : <String, dynamic>{});
  
    if (!(autoNavigateToSaleAutomation && doShowSalesAutomation && 
      ((stage?.sendCustomerEmail ?? false) || (stage?.createTasks ?? false)))) {
      return;
    }

    if (stage?.sendCustomerEmail ?? false) {
      await Get.toNamed(
        Routes.jobSaleAutomationEmailListing,
        arguments: {
          NavigationParams.stageCode: stage?.code,
          NavigationParams.jobID : job?.id,
          NavigationParams.createTask : stage?.createTasks,
          NavigationParams.sendCustomerEmail: stage?.sendCustomerEmail
        },
      );
    } else if (stage?.createTasks ?? false) {
      Get.toNamed(
        Routes.jobSaleAutomationTaskListing,
        arguments: {
          NavigationParams.stageCode : stage?.code,
          NavigationParams.jobID: job?.id,
          NavigationParams.sendCustomerEmail: stage?.sendCustomerEmail
        },
      );
    }
    autoNavigateToSaleAutomation = false;
    update();
  }

  Future<void> fetchTextsMeta() async {
    try {
      // Determine SMS types based on LaunchDarkly flag
      List<String> smsTypes = LDService.hasFeatureEnabled(LDFlagKeyConstants.textNotificationsAutomation)
          ? [ChatsConstants.smsTypeConversations, ChatsConstants.smsTypeAutomated]
          : [ChatsConstants.smsTypeConversations];
      
      Map<String, dynamic> params = {
        "page": 1,
        "limit": 1,
        "type[]": smsTypes,
        "customer_id": job?.customerId,
        "customer_all_user_messages": 1,
      };

      final threads = await ApiChatsRepo.fetchThreads(params);
      final pagination = PaginationModel.fromJson(threads['pagination']);
      job?.jobTextCount = pagination.total ?? 0;
    } catch (e) {
      Helper.recordError(e);
    }
  }
  
  Future<void> fetchCustomerMeta() async {
    Map<String, dynamic> queryParams = {
      "type[0]": "phone_consents",
      "customer_ids[]" : customerId
    };

    try {
      Map<String, dynamic> metaListApiResponse = await CustomerListingRepository().fetchMetaList(queryParams);
      List<CustomerModel> metaDataList = metaListApiResponse["list"];
      CustomerModel? firstMetaData = metaDataList.isNotEmpty ? metaDataList.first : null;
    
      if (!Helper.isValueNullOrEmpty(firstMetaData?.phoneConsents)) {
        for (int i = 0; i < firstMetaData!.phoneConsents!.length; i++) {
          var phoneConsent = firstMetaData.phoneConsents![i];
          for (int j = 0; j < customerInfo.length; j++) {
            if (phoneConsent.phoneNumber == customerInfo[j].phone?.number) {
              customerInfo[j].phone!.consentStatus = phoneConsent.status;
              customerInfo[j].phone!.consentCreatedAt = phoneConsent.createdAt;
              customerInfo[j].phone!.consentEmail = phoneConsent.email;
            }
          }
        }
        if(job?.isContactSameAsCustomer ?? false){
          setUpContactConsentData(firstMetaData);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  void setUpContactConsentData(CustomerModel? firstMetaData){
    for (var metaIndex = 0; metaIndex < (firstMetaData?.phoneConsents?.length ?? 0); metaIndex++) {
      for (var index = 0; index < (job?.contactPerson?.length ?? 0); index++) {
        for (PhoneModel phoneData in job?.contactPerson?[index].phones ?? []) {
          if (phoneData.number == firstMetaData?.phoneConsents?[metaIndex].phoneNumber) {
            phoneData.consentStatus = firstMetaData?.phoneConsents?[metaIndex].status;
            phoneData.consentCreatedAt = firstMetaData?.phoneConsents?[metaIndex].createdAt;
            phoneData.consentEmail = firstMetaData?.phoneConsents?[metaIndex].email;
          }
        }
      }
    }
  }

  void navigateToEmailHistory() {
    Get.toNamed(Routes.email, arguments: {NavigationParams.jobId: jobId, NavigationParams.customerId: customerId});
  }

  Future<void> fetchJobMeta() async {
    Map<String, dynamic> queryParams = {
      "type[0]": "phone_consents",
      "job_ids[]" : jobId
    };

    try {
      Map<String, dynamic> response = await JobRepository.fetchMetaList(queryParams);
      List<JobModel> jobs = response["list"];
      JobModel? metaData = jobs.isNotEmpty ? jobs.first : null;
      
      for (var metaIndex = 0; metaIndex < (metaData?.phoneConsents?.length ?? 0); metaIndex++) {
        for (var index = 0; index < (job?.contactPerson?.length ?? 0); index++) {
          for (PhoneModel phoneData in job?.contactPerson?[index].phones ?? []) {
            if (phoneData.number == metaData?.phoneConsents?[metaIndex].phoneNumber) {
              phoneData.consentStatus = metaData?.phoneConsents?[metaIndex].status;
              phoneData.consentCreatedAt = metaData?.phoneConsents?[metaIndex].createdAt;
              phoneData.consentEmail = metaData?.phoneConsents?[metaIndex].email;
            }
          }
        }
      }
     
      update();
    }catch (e) {
      rethrow;
    }
  }

  void setDataForMoveStagePermission () {
    String  awardedStageCode =  jobAwardedStageCode ?? "";
    bool  canPushKey = false;

    for (var stage in (job?.stages ?? [])) {
      if (stage.code == awardedStageCode) canPushKey = true;
      stage.isOrAfterAwardedStage = canPushKey;
    }
  }

  Future<void> fetchSchedule() async {
    Map<String, dynamic> params ={
      'job_id':  Get.arguments[NavigationParams.jobId]
    };
    try {
      showJPLoader(
          msg: 'fetching_schedule'.tr
      );
      await ScheduleRepository().fetchScheduleList(params)
          .then((Map<String, dynamic> response) {
        schedule = response["list"][0];
      });
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  Future<void> fetchRecurringEmailCount() async {
    try {
      // getting request params
      Map<String, dynamic> params = {
        'customer_id': customerId,
        'job_id': jobId,
        'include_canceled_campaign': 1,
      };
      // calling api to load job
      recurringEmailCount =  (await JobRepository.fetchRecurringEmailList(params: params)).length;
    } catch (e) {
      rethrow;
    }
  }

  // handleChangeJob() : is used to update job
  void handleChangeJob(int id) {
    jobId = id;
    isLoading = true;
    tabController.animateTo(0);
    update();
    fetchJob().trackUpdateEvent((job?.isProject ?? false) ? MixPanelEventTitle.selectedProjectUpdate : MixPanelEventTitle.selectedJobUpdate);
  }

  // uploadFile() : displays upload popup and upload selected files
  //        param : [from] ca be used to handle upload from (scanner or pop-up selection)
  void uploadFile({UploadFileFrom from = UploadFileFrom.popup}) async {

    final params = FileUploaderParams(
      type: FileUploadType.photosAndDocs,
      job: job,
      parentId: int.parse(job?.meta?.resourceId ?? '0'),
    );

    UploadService.uploadFrom(from: from, params: params);
  }

  // setUpDrawerKeys() : is used to handle duplicate key issue by setting up new keys
  void setUpDrawerKeys() {
    scaffoldKey = GlobalKey<ScaffoldState>();
    secondaryDrawerKey = GlobalKey<ScaffoldState>();
  }

  // refreshPage() : is used to refresh page data
  Future<void> refreshPage({bool showLoading = false, bool refreshRecentListing = false}) async {
    isLoading = showLoading;
    update();
    if(RunModeService.isAppMode) {
      await fetchJob();
      if (refreshRecentListing) {
        Future.wait([
          refreshRecentFilesListing(FLModule.estimate),
          refreshRecentFilesListing(FLModule.jobProposal),
          refreshRecentFilesListing(FLModule.jobPhotos),
        ]);
      }
    }
  }

  // setUpCustomerInfo() : will set up customerInfo list to display customer data
  void setUpCustomerInfo() {
    customerInfo.clear();
    if(job?.customer?.email?.isNotEmpty ?? false) {
      customerInfo.add(CustomerInfo(label: 'email'.tr, email: job?.customer?.email));
    }
    job?.customer?.additionalEmails?.forEach((element) {
      customerInfo.add(CustomerInfo(label: 'email'.tr, email: element));
    });

    job?.customer?.phones?.forEach((element) {
      customerInfo.add(CustomerInfo(label: element.label.toString().capitalize!, phone: element));
    });

    if(job?.customer?.addressString?.isNotEmpty ?? false) {
      customerInfo.add(CustomerInfo(label: 'customer_address'.tr, address: job?.customer?.address, addressString: job?.customer?.addressString));
    }

    setLeadSource();
  }

  void showCallLogs() {
    showJPBottomSheet(
      child: (_){
        return CallLogListingBottomSheet(customer: job!.customer!);
      },
      isScrollControlled: true,
    );
  }

  // onTapCount() : will handle tap on count items and take action accordingly
  void onTapCount(String type) {
    switch (type) {
      case 'tasks':
        navigateToTask();
        break;
      case 'notes':
        navigateToJobNotes();
        break;
      case 'message':
        navigateToChatScreen();
        break;
      case 'appts':
        navigateToStaffCalendar();
        break;
      case 'text':
        navigateToChatScreen(
          switchToTexts: true,
        );
        break;
      default:
        break;
    }
  }

  // setLeadSource() : will add lead source to customerInfo list based on referredByType
  void setLeadSource() {
    String? leadSource = Helper.getCustomerReferredBy(job?.customer, showExistingCustomerLabel: true);

    if(!Helper.isValueNullOrEmpty(leadSource)) {
      customerInfo.add(CustomerInfo(label: 'lead_source'.tr, leadSource: leadSource));
    }
  }


  // getAllUsers() will load all users from sql and parse it to multiselect
  Future<void> getAllUsers() async {

    users = []; // initializing list

    UserParamModel params = UserParamModel(
        limit: -1,
        withSubContractorPrime: false
    );

    UserResponseModel allUsers = await SqlUserRepository().get(params: params);
    for (UserModel user in allUsers.data) {
      users.add(
        JPMultiSelectModel(
            label: user.fullName,
            id: user.id.toString(),
            isSelect: false,
            child: JPProfileImage(
              size: JPAvatarSize.small,
              src: user.profilePic,
              color: user.color,
              initial: user.intial,
            )
        ),
      );
    }
  }

  void awardedStageConfirmation() {

    final isAwarded = workFlowStagesParams!.job.isAwarded!;

    showJPBottomSheet(
      child: (controller) {
        return JPConfirmationDialog(
          icon: Icons.warning_amber_outlined,
          title: 'confirmation'.tr,
          subTitle: !isAwarded
              ? 'you_are_about_to_change_the_status_of_this_project_to_not_awarded'.tr
              : 'you_are_about_to_change_the_status_of_this_project_to_awarded'.tr,
          suffixBtnIcon: showJPConfirmationLoader(
              show: controller.isLoading
          ),
          disableButtons: controller.isLoading,
          onTapSuffix: () async {
            controller.toggleIsLoading();
            await awardUnAwardProject(isAwarded ? 1 : 0);
            controller.toggleIsLoading();
          },
        );
      },
    );
  }

  Future<void> awardUnAwardProject(int newAwardedStage) async {
    try {

      Map<String, dynamic> params = {
        'awarded' : newAwardedStage,
        'id' : jobId
      };

      await WorkflowStagesRepository.makeProjectAwarded(params);

      workFlowStagesParams?.job.isAwarded = newAwardedStage == 0;

    } catch (e) {
      rethrow;
    } finally {
      Get.back();
      update();
    }
  }

  // lastStageUpdateStatusConfirmationDialog() : is used to confirm reinstate lost job
  void reinstateJobConfirmation() {
    showJPBottomSheet(
      child: (controller) {
        return JPConfirmationDialog(
          title: 'confirmation'.tr,
          subTitle: 'you_are_about_to_reinstate_this_job_into_this_workflow'.tr,
          suffixBtnText: 'confirm'.tr,
          suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
          disableButtons: controller.isLoading,
          icon: Icons.warning_amber_outlined,
          onTapSuffix: () async {
            controller.toggleIsLoading();
            // reinstating job
            await reinstateJob();
            controller.toggleIsLoading();
          },
        );
      },
    );
  }

  Future<void> reinstateJob() async {
    try {

      Map<String, dynamic> params = {
        'id' : job?.followUpStatus?.id
      };

      await JobRepository.reinstateJob(params);

    } catch (e) {
      rethrow;
    } finally {
      Get.back();
      refreshPage(showLoading: true);
    }
  }

  void shareCustomerWebPage() {
    JobQuickActionHelper().shareWebPage(job: job!);
  }

  void toggleIsJobExpanded(bool val) {
    isJobDetailExpanded = val;
  }

  // NAVIGATION

  void navigateToTask() {
    Get.to(() => const TaskListingView(), arguments: {'jobId': job!.id, 'customerId': job!.customerId}, preventDuplicates: true);
  }

  void navigateToJobNotes() {
    Get.toNamed(Routes.jobNoteListing, arguments: {'jobId': job!.id, 'customerId': job!.customerId});
  }

  void navigateToChatScreen({bool switchToTexts = false}) {
    Get.toNamed(Routes.chatsListing, arguments: {NavigationParams.jobModel: job, 'switchToTexts' : switchToTexts}, preventDuplicates: false);
  }

  void navigateToStaffCalendar() {
    Get.toNamed(Routes.calendar,arguments: {'job_id': job!.id}, preventDuplicates: false);
  }

  void navigateToJobDetails() {
    Get.toNamed(Routes.jobDetailing, arguments: {
      NavigationParams.jobId : jobId,
      NavigationParams.emailCount : recurringEmailCount
    });
  }

  void onTapDescription(String pageType) async{
    switch(pageType) {
      case "email_recurring":
        Get.toNamed(Routes.jobRecurringEmail, arguments: {
          NavigationParams.jobId: jobId,
          NavigationParams.customerId: customerId
        });
        break;
      case "job_scheduled":
        if(job!.scheduleCount! > 1){
          Get.toNamed(
              Routes.calendar, arguments: {'type' : CalendarType.production, 'job_id':job!.id},
              preventDuplicates: false
          );
        } else {
          await fetchSchedule();
          Get.toNamed(Routes.scheduleDetail, arguments: {'id' :schedule!.id});
        }
        break;
      case "progress_board":
        openProgressBoardBottomSheet();
        break;
    }
  }

  void openProgressBoardBottomSheet() {
    AddToProgressBoardHelper.inProgressBoard(
      jobModel: job ?? JobModel(id: 0, customerId: 0),
      index: 0,
      onCallback: ({JobModel? job, int? currentIndex, JobQuickActionCallbackType? callbackType}) {
        this.job?.productionBoards = job?.productionBoards;
        update();
      },
    );
  }

  ///////////////////////    UPDATE JOB PRICE   ///////////////////////////

  void onTapTotalJobPrice() => JobPriceUpdateHelper.openJobPriceDialog(
    jobId: jobId,
    onApply: () {
      Get.back();
      refreshPage(showLoading: true);
    },
  );

  void openDescDialog(){
    JobService.openDescDialog(job: job, updateScreen: update);
  }

  void openAddQuickAction() {
    JobSummaryService.openQuickActions(job,(action) {
      switch (action) {
        case "JobSummaryActions.jobProjectNote":
        case "JobSummaryActions.workCrew":
        case "JobSummaryActions.followUps":
          refreshPage(showLoading: true);
        break;
      }
    }, onRecentFileUpdated: (type) {
      refreshRecentFilesListing(type);
    });
  }

  // Handle recent files(Recent photos & documents, estimates and proposals) section refresh on deletion of file
  Future<void> refreshRecentFilesListing(FLModule type) async {
    final moduleType = FilesListingService.moduleTypeToUploadType(type);
    final String controllerTag = moduleType + jobId.toString();

    // if recent files is active or in job overview screen is active
    if(Get.isRegistered<RecentFilesController>(tag: controllerTag)) {
      final recentFileController = Get.find<RecentFilesController>(tag: controllerTag);
      await recentFileController.onRefresh(
        showLoading: recentFileController.resourceList.isNotEmpty,
      );
    }
  }

  /// Sets up the overview tabs based on user settings.
  ///
  /// This method:
  /// 1. Retrieves user default settings from company settings
  /// 2. Extracts job overview customization settings
  /// 3. Sets section items based on customized settings or defaults
  /// 4. Animates to the selected tab based on the first selected item
  /// 5. Falls back to default sections if any error occurs
  void setOverviewTabs() {
    try {
      // Get user default settings from company settings service
      final userDefaultSettings = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.userDefaultSettings);

      if (userDefaultSettings is! Map<String, dynamic>) {
        // If user default settings is not a map, fall back to default sections
        sectionItems = JobOverviewSectionItem.defaultSections;
        return;
      }

      // Parse job overview settings from the user defaults
      final jobOverviewSettings = JobOverviewCustomizeSettings.fromJson(userDefaultSettings['job_overview']);

      // Set section items from settings or use defaults if not available
      sectionItems = jobOverviewSettings.customize?.leftSection ?? JobOverviewSectionItem.defaultSections;
      
      // Find the first item that is marked as selected
      final selectedItemIndex = sectionItems.firstWhereOrNull((item) => Helper.isTrue(item.selected));

      // Animate to the selected tab or default to the first tab (index 0)
      tabController.animateTo(selectedItemIndex?.index ?? 0);
    } catch (e) {
      // If any error occurs, fall back to default sections
      sectionItems = JobOverviewSectionItem.defaultSections;
      // Log the error for debugging
      Helper.recordError(e);
    }
  }
}