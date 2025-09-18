import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/appointment_form_type.dart';
import 'package:jobprogress/common/enums/calendars.dart';
import 'package:jobprogress/common/enums/page_type.dart';
import 'package:jobprogress/common/enums/quick_action_type.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/models/schedules/schedules.dart';
import 'package:jobprogress/common/repositories/schedule.dart';
import 'package:jobprogress/common/repositories/task_listing.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_dialogs.dart';
import 'package:jobprogress/common/services/intent_receiver/index.dart';
import 'package:jobprogress/common/services/job/index.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/common/services/progress_board/add_to_progress_board.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/mix_panel/event/filter_events.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/upgrade_plan_helper.dart';
import 'package:jobprogress/modules/recent_jobs/index.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/core/constants/dropdown_list_constants.dart';
import 'package:jp_mobile_flutter_ui/IconButton/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../common/models/customer/customer.dart';
import '../../../common/models/job/job.dart';
import '../../../common/repositories/job.dart';
import '../../../routes/pages.dart';
import '../../common/enums/file_listing.dart';
import '../../common/enums/file_upload.dart';
import '../../common/enums/job_quick_action_callback_type.dart';
import '../../common/models/customer_job_search/customer_job_search_filters.dart';
import '../../common/models/files_listing/files_listing_model.dart';
import '../../common/models/sql/uploader/file_uploader_params.dart';
import '../../common/repositories/company_files.dart';
import '../../common/repositories/customer_listing.dart';
import '../../common/repositories/instant_photo_gallery.dart';
import '../../common/services/customer/quick_action_helper.dart';
import '../../common/services/job/quick_action_helper.dart';
import '../../common/services/upload.dart';
import '../../core/constants/date_formats.dart';
import '../../core/utils/date_time_helpers.dart';
import '../../core/utils/helpers.dart';
import '../../global_widgets/bottom_sheet/index.dart';
import '../../global_widgets/loader/index.dart';
import '../../global_widgets/safearea/safearea.dart';
import '../cutomer_job_list/index.dart';
import '../files_listing/controller.dart';
import '../files_listing/widgets/index.dart';

class CustomerJobSearchController extends GetxController {
  CustomerJobSearchController() {
    scaffoldKey = GlobalKey<ScaffoldState>();
  }

  late GlobalKey<ScaffoldState> scaffoldKey;
  CustomerJobSearchFilterModel filterKeys = CustomerJobSearchFilterModel();

  late PageType pageType;
  List<String>? fileIds;
  FLModule? flModule;

  bool isLoading = false;
  bool isLoadMore = false;
  bool canShowLoadMore = false;
  bool isSearchEnable = false;

  List<CustomerModel> customerList = [];
  List<JobModel> jobList = [];
  List<JPMultiSelectModel> progressBoardsList = [];
  List<JPSingleSelectModel> get shareToOptions => [
    JPSingleSelectModel(label: 'measurements'.tr, id: FileUploadType.measurements),
    // Removing estimates action in case [LDFlagKeyConstants.salesProForEstimate] is enabled
    if (!LDService.hasFeatureEnabled(LDFlagKeyConstants.salesProForEstimate))
      JPSingleSelectModel(label: 'estimates'.tr, id: FileUploadType.estimations),
    JPSingleSelectModel(label: 'forms_proposals'.tr, id: FileUploadType.formProposals),
    if(FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.production]))...{
      JPSingleSelectModel(label: 'materials'.tr, id: FileUploadType.materialList),
      JPSingleSelectModel(label: 'work_orders'.tr, id: FileUploadType.workOrder),
    },
    JPSingleSelectModel(label: 'photos_documents'.tr, id: FileUploadType.photosAndDocs),
  ];

  TextEditingController searchTextController = TextEditingController();

  bool get doOpenPhotosDocumentDirectly => flModule == FLModule.companyFiles
      || flModule == FLModule.instantPhotoGallery
      || flModule == FLModule.companyCamProjectImages
      || flModule == FLModule.stageResources
      || CommonConstants.restrictFolderStructure;

  int? jobId = Get.arguments?[NavigationParams.jobId];
  int? taskId = Get.arguments?[NavigationParams.taskId];

  @override
  void onInit() {
    super.onInit();
    pageType = Get.arguments?[NavigationParams.pageType] ?? PageType.home;
    fileIds = Get.arguments?[NavigationParams.fileId];
    flModule = Get.arguments?[NavigationParams.flModule];
    if(pageType == PageType.selectCustomer){
      filterKeys.isWithJob = false;
    }
  }

  void updateListType() {
    filterKeys.isWithJob = !filterKeys.isWithJob;

    MixPanelService.trackEvent(event: filterKeys.isWithJob ? MixPanelFilterEvent.job : MixPanelFilterEvent.customer);

    if (searchTextController.text.isNotEmpty) {
      search(searchTextController.text.trim());
    } else {
      update();
    }
  }

  void updateSearch() {
    isSearchEnable = !isSearchEnable;
    update();
  }

  Map<String, dynamic> getQueryParams() {
    Map<String, dynamic> queryParams = {
      "includes[0]": "address",
      "includes[1]": "contacts",
      "includes[2]": "custom_fields.options.sub_options",
      "includes[3]": "jobs",
      "includes[4]": "phones",
      "includes[5]": "appointments",
      "includes[6]": "flags",
      "includes[7]": "referred_by",
      "includes[8]": "flags.color",
      ...filterKeys.toJson()
        ..removeWhere(
            (dynamic key, dynamic value) => (key == null || value == null)),
    };
    if (!(filterKeys.isWithJob)) {
      queryParams.removeWhere((key, value) => key == "with_job");
    }
    return queryParams;
  }

  void selectJobAndNavigateBack({JobModel? jobModel,CustomerModel? customerModel}) {
    if(pageType == PageType.selectCustomer){
      Get.back(result: customerModel);
    } else if(pageType == PageType.linkToJob) {
      linkToJob(jobModel!.id);
    }
    else {
      Get.back(result: jobModel);
    }
  }

  void showShareToOptions({JobModel? jobModel, int? jobId, int? customerId}) {

    SingleSelectHelper.openSingleSelect(
        shareToOptions, null, 'copy_to'.tr.toUpperCase(), (type) async {
      Get.back();
      if(type == FileUploadType.photosAndDocs) {
        showShareFilePopUp(
          jobModel: jobModel,
          jobId: jobId,
          customerId: customerId,
          value: type,
        );
      } else {
        bool showUpgradeDialog = await UpgradePlanHelper.showUpgradePlanOnDocumentLimit();
        if(showUpgradeDialog){
          return;
        }
        uploadFile(jobModel, IntentReceiverService.filePaths, type);
        await Future<void>.delayed(const Duration(milliseconds: 300));
        IntentReceiverService.clearData();
        Get.back();
        Get.back();
      }
    });
  }

  void showShareFilePopUp({JobModel? jobModel, int? jobId, int? customerId, required String value}) {
    FilesListQuickActionPopups.showShareFilePopUp(
      FilesListingQuickActionParams(
        fileList: [],
        type: uploadTypeToModule(value),
        sharedFilesPath: IntentReceiverService.filePaths,
        jobModel: jobModel ?? JobModel(id: jobId!, customerId: customerId!),
        onActionComplete: (_, __) async {
          await Future<void>.delayed(const Duration(milliseconds: 300));
          IntentReceiverService.clearData();
          Get.back();
          Get.back();
        },
      ),
    );
  }

  ///////////////////////    NAVIGATE TO DETAIL SCREEN   ///////////////////////

  void navigateToJobDetailScreen({int? jobID, int? currentIndex}) {
    if (pageType == PageType.selectJob) {
      Get.back(result: jobList[currentIndex ?? 0]);
    } else if (pageType == PageType.shareTo) {
      openCopyToBottomSheet(jobModel: jobList[currentIndex!], jobId: jobID);
    }
    else if(pageType == PageType.linkToJob) {
      linkToJob(jobID!);
    } else {
      switch (flModule) {
        case FLModule.companyFiles:
        case FLModule.instantPhotoGallery:
        case FLModule.dropBoxListing:
        case FLModule.companyCamProjectImages:
        case FLModule.stageResources:
          openCopyToBottomSheet(jobModel: jobList[currentIndex!], jobId: jobID);
          break;
        default:
          Get.toNamed(Routes.jobSummary,
              arguments: {NavigationParams.jobId: jobID, NavigationParams.customerId: jobList[currentIndex!].customerId},
              preventDuplicates: false);
          break;
      }
    }
  }

  ///////////////////    NAVIGATE TO CUSTOMER DETAIL SCREEN   //////////////////

  void navigateToCustomerDetailScreen({int? customerID, int? index}) {
    if (pageType == PageType.selectCustomer) {
      Get.back(result: customerList[index?? 0]);
    } else if (pageType == PageType.shareTo) {
      showJobsSheet(customerID: customerID);
    } else {
      switch (flModule) {
        case FLModule.companyFiles:
        case FLModule.dropBoxListing:
        case FLModule.instantPhotoGallery:
        case FLModule.companyCamProjectImages:
        case FLModule.stageResources:
          showJobsSheet(customerID: customerID);
          break;
        default:
          Get.toNamed(Routes.customerDetailing,arguments: {NavigationParams.customerId: customerID!})?.then((value) {
            customerList[index!] = value;
            update();
          });
          break;
      }
    }
  }

  /////////////////////////   DESC DIALOG HANDLER   ////////////////////////////

  void openDescDialog({JobModel? job, int? index}) async{
    JobModel? jobModel = await fetchJob(job?.id);
    JobService.openDescDialog(job: jobModel, updateScreen: (){
      jobList[index!] = job!;
      update();
    });
  }

  //////////////////////////////   SEARCH    ///////////////////////////////////

  void search(String val) {
    if(val.length >= 2) {
      filterKeys.page = 1;
      filterKeys.keyword = val;
      isLoading = true;
      update();
      if (val.isNotEmpty) {
        fetchSearchResults();
      } else {
        clearSearch();
      }
    } else {
        clearSearch();
    }
  }

  ////////////////////////////   FETCH SEARCH DATA   ///////////////////////////

  Future<void> fetchSearchResults() async {
    try {
      Map<String, dynamic> queryParams = getQueryParams();
      Map<String, dynamic> response = await (filterKeys.isWithJob
          ? JobRepository.searchJob(params: queryParams)
          : CustomerListingRepository().fetchCustomerList(queryParams));
      if (filterKeys.isWithJob) {
        if (!isLoadMore) {
          jobList.clear();
        }
        jobList.addAll(response["list"]);
        customerList.clear();
      } else {
        if (!isLoadMore) {
          customerList.clear();
        }
        customerList.addAll(response["list"]);
        jobList.clear();
      }
      canShowLoadMore = (filterKeys.isWithJob ? jobList.length : customerList.length) < response["pagination"]["total"];
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      isLoadMore = false;
      update();
    }
  }

  //////////////////////////////   REFRESH LIST   //////////////////////////////

  ///showLoading is used to show shimmer if refresh is pressed from main drawer
  Future<void> refreshList({bool? showLoading}) async {
    filterKeys.page = 1;

    ///   show shimmer if showLoading = true
    isLoading = showLoading ?? false;
    update();
    fetchSearchResults();
  }

  ////////////////////////////   FETCH NEXT PAGE   /////////////////////////////

  Future<void> loadMore() async {
    filterKeys.page += 1;
    isLoadMore = true;
    await fetchSearchResults();
  }

  ////////////////////////////   CLEAR SEARCH  /////////////////////////////
  
  void clearSearch({bool clearText = false}) {
    if(clearText) searchTextController.text = "";
    customerList.clear();
    jobList.clear();
    isLoading = false;
    update();
  }

  ///////////////////////    JOB QUICK ACTION HANDLER    ///////////////////////

  void openJobQuickActions({JobModel? job, int? index}) {
    switch (pageType) {
      case PageType.fileListing:
      case PageType.shareTo:
      case PageType.linkToJob:
        break;
      default:
        JobQuickActionHelper().openQuickActions(
          job: job!,
          index: index!,
          deleteCallback: jobDeleteCallback,
          quickActionCallback: jobQuickActionCallback,
          quickActionType: QuickActionType.jobSearch
        );
        break;
    }
  }

  void jobQuickActionCallback(
      {JobModel? job,
      int? currentIndex,
      JobQuickActionCallbackType? callbackType}) {
    switch (callbackType) {
      case JobQuickActionCallbackType.navigateToDetailScreenCallback:
      case JobQuickActionCallbackType.flagCallback:
      case JobQuickActionCallbackType.addToProgressBoard:
        jobList[currentIndex!] = job!;
        break;
      case JobQuickActionCallbackType.markAsLostJobCallback:
        jobList[currentIndex!].jobLostDate = DateTime.now().toString();
        break;
      case JobQuickActionCallbackType.reinstateJob:
        jobList[currentIndex!].jobLostDate = null;
        break;
      case JobQuickActionCallbackType.archive:
        jobList[currentIndex!].archived = DateTimeHelper.formatDate(
            DateTime.now().toString(),
            DateFormatConstants.dateTimeFormatWithoutSeconds);
        break;
      case JobQuickActionCallbackType.unarchive:
        jobList[currentIndex!].archived = null;
        break;
      default:
        update();
        break;
    }
    update();
  }

  ////////    DELETE CUSTOMER   ///////

  void jobDeleteCallback(dynamic model, dynamic action) {
    jobList.removeAt(jobList.indexWhere((element) => element.id == model.id));
    Get.back();
    update();
  }

  /////////////////////    CUSTOMER QUICK ACTION HANDLER    ////////////////////

  void openCustomerQuickActions({CustomerModel? customer, int? index}) {
    if(pageType == PageType.selectCustomer) return;
    switch (pageType) {
      case PageType.fileListing:
        break;
      default:
        CustomerQuickActionHelper().openQuickActions(
          customer: customer!,
          index: index!,
          navigateToDetailScreen: navigateToCustomerDetailScreen,
          deleteCallback: customerDeleteCallback,
          flagCallback: customerFlagCallback,
          navigateToEditScreen: navigateToEditScreen,
          appointmentCallback: navigateToCreateAppointmentScreen
        );
        break;
    }
  }

  ////////    DELETE    ///////

  void customerDeleteCallback(dynamic modal, dynamic action) {
    customerList.removeAt(
        customerList.indexWhere((element) => element.id == modal!.id));
    Get.back();
    update();
  }

  ////////    FLAGS    ///////

  customerFlagCallback({CustomerModel? customer, int? customerIndex}) {
    customerList[customerIndex!] = customer!;
    update();
  }

  /////////////////////////    COPY TO ACTION HANDLING    ///////////////////////

  Widget getMoreIconButtons() {
    switch (pageType) {
      case PageType.fileListing:
      case PageType.selectJob:
      case PageType.shareTo:
      case PageType.linkToJob:
        return JPIconButton(
          backgroundColor: JPAppTheme.themeColors.base,
          onTap: () => showJPBottomSheet(
            child: (_) => RecentJobBottomSheet(
              pageType: pageType,
              callback: pageType == PageType.selectJob || pageType == PageType.linkToJob
                  ? selectJobAndNavigateBack
                  : openCopyToBottomSheet,
            ),
            isScrollControlled: true,
          ),
          icon: Icons.history_outlined,
          iconColor: JPAppTheme.themeColors.text,
          iconSize: 24,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void openCopyToBottomSheet({JobModel? jobModel, int? jobId, int? customerId}) {

    if (jobModel?.isMultiJob ?? false) {
      showJobsSheet(parentJobId: jobModel!.id);
    } else if (pageType == PageType.shareTo) {
      showShareToOptions(jobModel: jobModel, jobId: jobId, customerId: customerId);
    } else if (doOpenPhotosDocumentDirectly) {
      showFileSelectionBottomSheet(moduleType: flModule, jobId: jobModel?.id ?? jobId);
    } else {
      SingleSelectHelper.openSingleSelect(
          DropdownListConstants.copyToJobTypeList,
          "",
          "copy_here".tr.toUpperCase(), (value) {
        FLModule? moduleType;

        switch (value) {
          case "estimating":
            moduleType = FLModule.estimate;
            break;
          case "form_proposals":
            moduleType = FLModule.jobProposal;
            break;
          case "photos_and_documents":
            moduleType = FLModule.jobPhotos;
            break;
          default:
            break;
        }
        Get.back();
        showFileSelectionBottomSheet(
            moduleType: moduleType, jobId: jobModel?.id ?? jobId);
      });
    }
  }

  void showJobsSheet({int? customerID, int? parentJobId}) {
    showJPBottomSheet(
        child: (_) {
          return CustomerJobListing(
            customerId: customerID,
            parentJobId: parentJobId,
            isWithJob: filterKeys.isWithJob,
            title: "select_job".tr.toUpperCase(),
            multiJobTitle: "select_project".tr.toUpperCase(),
            pageType: pageType,
            callback: (jobModel) {
              Get.back();
              if (jobModel.isMultiJob) {
                Future.delayed(const Duration(milliseconds: 200),
                    () => showJobsSheet(parentJobId: jobModel.id));
              } else if (pageType == PageType.shareTo) {
                openCopyToBottomSheet(
                    jobId: jobModel.id, customerId: customerID);
              } else {
                switch (flModule) {
                  case FLModule.companyFiles:
                  case FLModule.instantPhotoGallery:
                  case FLModule.companyCamProjectImages:
                  case FLModule.stageResources:
                    showFileSelectionBottomSheet(
                        moduleType: flModule, jobId: jobModel.id);
                    break;
                  case FLModule.estimate:
                  case FLModule.jobProposal:
                  case FLModule.dropBoxListing:
                  case FLModule.jobPhotos:
                    openCopyToBottomSheet(jobId: jobModel.id);
                    break;
                  default:
                    break;
                }
              }
            },
          );
        },
        isScrollControlled: true);
  }

  void showFileSelectionBottomSheet({required FLModule? moduleType, int? jobId}) {

    if(CommonConstants.restrictFolderStructure) {
      moduleType = flModule == FLModule.instantPhotoGallery
        ? FLModule.instantPhotoGallery
        : FLModule.jobPhotos;
    }

    showJPBottomSheet(
      child: (_) => GetBuilder<FilesListingController>(
        init: FilesListingController(
          attachType: moduleType == FLModule.stageResources ? FLModule.jobPhotos : moduleType,
          mode: flModule == FLModule.instantPhotoGallery
              ? FLViewMode.moveToJob
              : FLViewMode.copy,
          attachJobId: jobId,
          allowMultipleSelection: false,
        ),
        global: false,
        builder: (FilesListingController controller) {
          return JPSafeArea(
            bottom: false,
            child: FilesView(
              controller: controller,
              onTapAttach: (List<FilesListingModel> selectedFiles) async {
                controller.toggleIsMovingFile();
                if (flModule == FLModule.instantPhotoGallery) {
                  moveFileToJob(selectedFiles, controller: controller);
                } else if (flModule == FLModule.stageResources || CommonConstants.restrictFolderStructure) {
                  copyFile(selectedFiles, flModule!, jobId: jobId, controller: controller);
                } else {
                  copyFile(selectedFiles, moduleType!,
                      jobId: jobId, controller: controller);
                }
              },
            ),
          );
        },
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }

  String fileToAttachmentUploadType(FLModule type) {
    switch (type) {
      case FLModule.estimate:
        return "estimate";
      case FLModule.jobProposal:
        return "proposal";
      case FLModule.measurements:
        return "measurement";
      case FLModule.materialLists:
        return 'material_list';
      case FLModule.workOrder:
        return 'workorder';
      default:
        return "resource";
    }
  }

  void copyFile(List<FilesListingModel> selectedFiles, FLModule type,
      {int? jobId, FilesListingController? controller}) {

    if (fileIds?.isEmpty ?? true) {
      onFileSelect(selectedFiles,
          jobId: selectedFiles.isNotEmpty ? selectedFiles.first.jobId : jobId);
    }

    Map<String, dynamic> params = <String, dynamic>{};

    switch (type) {
      case FLModule.companyFiles:
      case FLModule.stageResources:
        params = {
          "copy_to": selectedFiles.isNotEmpty
              ? selectedFiles.first.id
              : controller?.resourceList.first.parentId,
        };
        fileIds?.asMap().forEach((i, value) =>
            params.addEntries({"resource_ids[$i]": value}.entries));
        break;

      case FLModule.companyCamProjectImages:

        if(fileIds?.isNotEmpty ?? false) {
          params = {
            "save_to": selectedFiles.isNotEmpty
                ? selectedFiles.first.id
                : controller?.resourceList.first.parentId,
            "photo_id": fileIds![0]
          };
        }
        break;

      case FLModule.estimate:
      case FLModule.jobProposal:
      case FLModule.jobPhotos:
        params = {
          "file_id": fileIds?.first,
          "job_id":
              selectedFiles.isNotEmpty ? selectedFiles.first.jobId : jobId,
          "save_as": fileToAttachmentUploadType(type),
          "parent_id": selectedFiles.isNotEmpty
              ? selectedFiles.first.id
              : (controller?.resourceList.isNotEmpty ?? false)
                  ? controller?.resourceList.first.parentId
                  : null
        };
        break;
      default:
        break;
    }

    params.removeWhere(
        (dynamic key, dynamic value) => (key == null || value == null));

    if (params.isNotEmpty) {
      CompanyFilesRepository.resourceCopyTo(params, type).then((value) {
        if (value) {
          if ((type != FLModule.companyFiles || type != FLModule.stageResources) && type == FLModule.companyCamProjectImages) {
            if (fileIds?.isNotEmpty ?? false) {
              fileIds?.removeAt(0);
              copyFile(selectedFiles, type, jobId: jobId, controller: controller);
            } else {
              onFileSelect(selectedFiles,
                  jobId: selectedFiles.isNotEmpty
                      ? selectedFiles.first.jobId
                      : jobId);
            }
          } else {
            onFileSelect(selectedFiles,
                jobId: selectedFiles.isNotEmpty
                    ? selectedFiles.first.jobId
                    : jobId);
          }
        }
      }).catchError((onError) {
        controller?.toggleIsMovingFile();
      });
    }
  }

  void moveFileToJob(List<FilesListingModel> selectedFiles, {FilesListingController? controller}) {
    Map<String, dynamic> params = {
      "move_to": selectedFiles.isNotEmpty
          ? selectedFiles.first.id
          : controller?.resourceList.first.parentId,
    };
    fileIds?.asMap().forEach((i, value) =>  
      params.addEntries({"resource_ids[$i]": value}.entries));
    InstantPhotoGalleryRepository.moveResourceToJob(params).then((value) {
      if (value) {
        onFileSelect(selectedFiles);
      }
    }).catchError((onError) {
      controller?.toggleIsMovingFile();
    });
  }

  void onFileSelect(List<FilesListingModel> selectedFiles, {int? jobId}) {
    if (selectedFiles.isNotEmpty || (jobId?.toString().isNotEmpty ?? false)) {
      if (flModule == FLModule.instantPhotoGallery) {
        Helper.showToastMessage("resource_moved".tr);
      } else {
        Helper.showToastMessage("resource_copied".tr);
      }
    }
    Get.back();
    Get.back(result: fileIds);
  }

  FLModule uploadTypeToModule(String val) {
    switch (val) {
      case FileUploadType.estimations:
        return FLModule.estimate;
      case FileUploadType.photosAndDocs:
        return FLModule.jobPhotos;
      case FileUploadType.formProposals:
        return FLModule.jobProposal;
      case FileUploadType.measurements:
        return FLModule.measurements;
      case FileUploadType.materialList:
        return FLModule.materialLists;
      case FileUploadType.workOrder:
        return FLModule.workOrder;
      default:
        return FLModule.companyFiles;
    }
  }
  //////////////////////////////////////////////////////////////////////////////

  Future<bool> willPopScope() async {
    IntentReceiverService.clearData();
    Get.back();
    return false;
  }

  @override
  void onClose() {
    searchTextController.clear();
    super.onClose();
  }

  void linkToJob(int jobId,{ JobModel? jobmodel}) async {
    Map<String, dynamic> param = {
      'job_id': jobmodel?.id ?? jobId,
      'task_id': taskId
    };
    bool isLinkedToJob = await TaskListingRepository().linkToJob(param);
    
    if(isLinkedToJob) {
      Helper.showToastMessage('task_linked_job'.tr);
      Get.back(result: true);
    }
  }

  Future<JobModel?> fetchJob(int? jobId) async {
    try {
      showJPLoader();
      Map<String, dynamic> params = {
            'id': jobId,
            'includes[0]': 'flags.color'
          };
      final response = await JobRepository.fetchJob(jobId!, params: params);

      return response['job'];
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  void navigateToEditScreen({int? customerID, int? index}) {
    Get.toNamed(Routes.customerForm, arguments: {
      NavigationParams.customerId: customerID
    })?.then((value) {
      if (value!= null && value) {
        refreshList(showLoading: true);
      }
    });
  }

   Future<void> navigateToCreateAppointmentScreen({CustomerModel? customer}) async {
    final result = await Get.toNamed(
      Routes.createAppointmentForm , arguments: {
        NavigationParams.customer: customer,
        NavigationParams.pageType: AppointmentFormType.createForm,
      }
    );
    if(result != null) {
      refreshList(showLoading: true);
    }
  }

  void uploadFile(JobModel? jobModel, List<String>? filePaths, String type) {

    final params = FileUploaderParams(
      type: type,
      job: jobModel,
    );

    if (filePaths != null) {
      UploadService.parseParamsAndAddToQueue(filePaths, params);
    } else {
      UploadService.uploadFrom(from: UploadFileFrom.popup, params: params);
    }
  }

  /// [openAppointment] opens appointment details screen
  Future<void> openAppointment(int index) async {
    // Get the appointment for the customer at the given index.
    AppointmentModel? appointment = customerList[index].getAppointment();

    // If the appointment is recurring, open the details screen for it.
    if (appointment?.recurringId == null) return;

    // Navigate to the appointment details screen, passing the recurring ID as an argument.
    await Get.toNamed(
      Routes.appointmentDetails,
      arguments: {
        NavigationParams.appointmentId : appointment?.recurringId
      },
    );
  }

  /// Navigates to the job schedule screen for a specific job.
  ///
  /// If the job has more than one schedule, it navigates to the calendar screen.
  /// If the job has only one schedule, it fetches the schedule details and navigates
  /// to the schedule detail screen. Depending on the response from the schedule
  /// detail screen, it updates the job's metadata or marks the job as unscheduled.
  ///
  /// Params:
  /// - [index]: The index of the job in the [jobList].
  Future<void> openJobSchedule(int index) async {
    // Get the job at the specified index.
    final job = jobList[index];

    // Check if the job has more than one schedule.
    if (job.scheduleCount! > 1) {
      // Navigate to the calendar screen with the job's ID.
      Get.toNamed(Routes.calendar,
          arguments: {
            'type': CalendarType.production,
            'job_id': job.id,
          },
          preventDuplicates: false
      );
    } else {
      // Fetch the schedule details for the job.
      final schedule = await fetchSchedule(index);
      // Navigate to the schedule detail screen with the schedule ID.
      final response = await Get.toNamed(Routes.scheduleDetail, arguments: {'id': schedule!.id});
      // If the schedule was updated, fetch the metadata for the job.
      if (response is Map && response['action'] == 'delete') {
        job.scheduled = null;
        update();
      }
    }
  }

  Future<SchedulesModel?> fetchSchedule(int index) async {
    Map<String, dynamic> params = {
      'job_id': jobList[index].id
    };
    try {
      showJPLoader(msg: 'fetching_schedule'.tr);
      return (await ScheduleRepository().fetchScheduleList(params))["list"]?[0];
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  /// [openProgressBoard] - Navigates to the progress board screen for a specific job.
  ///
  /// If the job has exactly one production board, it navigates directly to the
  /// progress board screen. If the job has more than one production board, it
  /// opens a helper to handle the selection of the appropriate progress board.
  ///
  /// Params:
  /// - [index]: The index of the job in the [jobList].
  Future<void> openProgressBoard(int index) async {
    // Get the job at the specified index.
    final job = jobList[index];

    // Check if the job has exactly one production board.
    if (job.productionBoards?.length == 1) {
      // Navigate to the progress board screen with the job's production board ID and job number.
      await Get.toNamed(Routes.progressBoard, preventDuplicates: false, arguments: {
        NavigationParams.id: job.productionBoards?[0].id,
        NavigationParams.jobNumber: job.number.toString()
      });
    } else {
      // Open the helper to handle the selection of the appropriate progress board.
      AddToProgressBoardHelper.inProgressBoard(
        jobModel: job,
        index: 0,
        onCallback: ({JobModel? job, int? currentIndex, JobQuickActionCallbackType? callbackType}) {},
      );
    }
  }
 
}
