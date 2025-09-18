import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/file_upload.dart';
import 'package:jobprogress/common/enums/resource_type.dart';
import 'package:jobprogress/common/enums/templates.dart';
import 'package:jobprogress/common/models/bread_crumb.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/email/email_params.dart';
import 'package:jobprogress/common/models/files_listing/file_listing_type_to_api_params.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_request_param.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/models/forms/hover_order_form/params.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/models/photo_viewer_model.dart';
import 'package:jobprogress/common/models/popover_action.dart';
import 'package:jobprogress/common/models/sql/tag/tag_param.dart';
import 'package:jobprogress/common/models/sql/uploader/file_uploader_params.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/sql/user/user_param.dart';
import 'package:jobprogress/common/models/sql/user/user_response.dart';
import 'package:jobprogress/common/models/subscriber/subscriber_details.dart';
import 'package:jobprogress/common/models/templates/form_proposal/template.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/common/repositories/company_files.dart';
import 'package:jobprogress/common/repositories/company_trades.dart';
import 'package:jobprogress/common/repositories/companycam.dart';
import 'package:jobprogress/common/repositories/contracts.dart';
import 'package:jobprogress/common/repositories/customer.dart';
import 'package:jobprogress/common/repositories/customer_files.dart';
import 'package:jobprogress/common/repositories/drop_box.dart';
import 'package:jobprogress/common/repositories/estimations.dart';
import 'package:jobprogress/common/repositories/google_sheet.dart';
import 'package:jobprogress/common/repositories/instant_photo_gallery.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/repositories/job_financial.dart';
import 'package:jobprogress/common/repositories/job_photos.dart';
import 'package:jobprogress/common/repositories/job_proposal.dart';
import 'package:jobprogress/common/repositories/material_lists.dart';
import 'package:jobprogress/common/repositories/measurements.dart';
import 'package:jobprogress/common/repositories/sql/tag.dart';
import 'package:jobprogress/common/repositories/sql/user.dart';
import 'package:jobprogress/common/repositories/stage_resources.dart';
import 'package:jobprogress/common/repositories/subscriber_details.dart';
import 'package:jobprogress/common/repositories/templates.dart';
import 'package:jobprogress/common/repositories/user_documents.dart';
import 'package:jobprogress/common/repositories/work_order.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/common/services/cookies.dart';
import 'package:jobprogress/common/services/drawing_tool/index.dart';
import 'package:jobprogress/common/services/external_temlate_web_view/index.dart';
import 'package:jobprogress/common/services/file_attachment/quick_action_dialogs.dart';
import 'package:jobprogress/common/services/files_listing/add_more_actions/more_action_handler.dart';
import 'package:jobprogress/common/services/files_listing/instant_photo_gallery_filter.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_dialogs.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_handlers.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_helpers.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_repo/job_photos_repo.dart';
import 'package:jobprogress/common/services/files_listing/quick_actions.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/common/services/upload.dart';
import 'package:jobprogress/common/services/worksheet/helpers.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/connected_third_party_constants.dart';
import 'package:jobprogress/core/constants/dropdown_list_constants.dart';
import 'package:jobprogress/core/constants/financial_quick_actions.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/mix_panel/event/add_events.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/pagination_constants.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/constants/phases_visibility.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/core/constants/work_flow_stage_color.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/measurement_helper.dart';
import 'package:jobprogress/core/utils/upgrade_plan_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/controller.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/custom_date_dialog/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/photo_viewer_dialog/index.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jobprogress/global_widgets/recent_files/controller.dart';
import 'package:jobprogress/modules/files_listing/widgets/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/tag_modal.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/position.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/type.dart';
import 'package:jp_mobile_flutter_ui/Thumb/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../common/enums/beacon_access_denied_type.dart';
import '../../common/enums/page_type.dart';
import '../../common/enums/unsaved_resource_type.dart';
import '../../common/enums/invoice_form_type.dart';
import '../../common/enums/worksheet.dart';
import '../../common/models/files_listing/create_file_actions.dart';
import '../../common/models/home/filter_model.dart';
import '../../common/repositories/division.dart';
import '../../common/repositories/favourite_listing.dart';
import '../../common/repositories/proposal_template.dart';
import '../../common/services/files_listing/add_more_actions/more_actions.dart';
import '../../core/constants/order_status_constants.dart';
import '../../core/constants/date_formats.dart';
import '../../core/constants/user_roles.dart';
import '../../core/utils/form/db_helper.dart';
import '../../core/utils/single_select_helper.dart';
import '../../global_widgets/safearea/safearea.dart';
import 'filter_dialog/index.dart';
import 'package:jobprogress/common/models/sql/division/division.dart';

class FilesListingController extends GetxController {
  // isInMoveFile: It can be used when we only want to display
  //               folder to move file/files from source to destination folder
  // isInAttachFileMode : It can we used when we want to select files as an attachment
  FilesListingController({
    this.mode = FLViewMode.view,
    this.attachType = FLModule.companyFiles,
    this.attachJobId,
    this.allowMultipleSelection = true,
    this.jobIdParam,
    this.typeParam,
    this.dirWithImageOnly = false,
    this.additionalParams,
    this.suffixIconText,
    this.projectIdParam,
    this.parentModule,
    this.parentWorksheetId
  });

  bool isLoading = true;
  bool isLoadMore = false;
  bool showListView = false;
  bool canShowLoadMore = false;
  bool isMovingFile = false;
  bool isInSelectionMode = false;
  bool isGoalSelected = false;
  bool isPlaceHolderFixed = false;
  bool allowMultipleSelection = true;
  bool dirWithImageOnly = false;
  String? selectedFilterByOptions;
  List<JPSingleSelectModel> filterByList = [JPSingleSelectModel(id: 'all',label: 'ALL')];

  int? jobIdParam;
  String? projectIdParam;
  List<int> selectedFileOrder = [];
  int selectedFileCount = 0;
  int companyCamphotoCount = 0;
  int collapseAt = 1;
  int? jobId = Get.arguments?['jobId'];
  int? customerId = Get.arguments?['customerId'];
  String? projectId = Get.arguments?['projectId'];
  String? projectName;
  String ? suffixIconText ;
  String? selectedStageCode = Get.arguments?['selectedStageCode'];
  String? selectedTabForStageResources = Get.arguments?['selectedTabForStageResources'];
  String? proposalPageType = Get.arguments?['proposalPageType'];
  String? templateListType = Get.arguments?[NavigationParams.templatesListType] ?? 'proposal';
  FLModule? parentModule;
  CreateFileActions? action = Get.arguments?['action'];

  List<WorkFlowStageModel> stages = [];
  List<JPSingleSelectModel> stageResourcesFilter = [];
  List<FilesListingModel> selectedItems =[];
  FocusNode createFolderDialogFocusNode = FocusNode();
  HomeFilterModel favouritefilterkey = HomeFilterModel();
  HomeFilterModel defaultFilters = HomeFilterModel();
  late GlobalKey<ScaffoldState> scaffoldKey;
  late GlobalKey<ScaffoldState> secondaryDrawerKey;

  final searchController = TextEditingController();
  FLViewMode mode;
  FLModule? typeParam;
  FLModule type = Get.arguments == null ? FLModule.companyFiles : Get.arguments['type'] ?? FLModule.companyFiles;

  List<FilesListingModel> resourceList = []; // Resource list will contain all the files/folders
  List<BreadCrumbModel> folderPath = []; // folderPath list displays bread crumb
  int? totalResults; // totalResults will contain number of total items on search
  int? rootId;
  bool? isInMoveFileMode;
  bool? isInCopyFileMode;
  int? lastSelectedDir;
  int? lastSelectedFile;
  FilesListingRequestParam? fileListingRequestParam;
  JobModel? jobModel = Get.arguments?['job'];
  CustomerModel? customerModel;
  String? currentGoal;
  FLModule? attachType;
  int? attachJobId;
  String previousSelectedOption = '';
  String? nextPageToken;
  String? selectedPageType;
  UserModel? loggedInUser;
  List<UserModel> userList = [];
  List<String> selectedUsers = [];
  List<JPMultiSelectModel> mainList = [];
  List<JPMultiSelectModel> tagsList = [];
  List<JPMultiSelectModel> tradeList = [];
  EmailListingParamModel paramKeys = EmailListingParamModel(users: AuthService.userDetails?.id);
  List<FinancialListingModel>? financialUnAppliedCreditList;
  InstantPhotoGalleryFilterModel filterKeys = InstantPhotoGalleryFilterModel();
  String instantPhotoGallerySelectedFilterByOptions = 'none';
  List<JPSingleSelectModel> instantPhotoGallerySortByList = [
    JPSingleSelectModel(id: 'none', label: 'none'.tr),
    JPSingleSelectModel(id: 'today', label: 'today'.tr),
    JPSingleSelectModel(id: 'yesterday', label: 'yesterday'.tr),
    JPSingleSelectModel(id: 'this_week', label: 'this_week'.tr),
    JPSingleSelectModel(id: 'last_week', label: 'last_week'.tr),
    JPSingleSelectModel(id: 'this_month', label: 'this_month'.tr),
    JPSingleSelectModel(id: 'custom', label: 'custom_date'.tr),
  ];

  Map<String, dynamic>? additionalParams;

  SubscriberDetailsModel? subscriberDetails;

  static get timeZone => null;

  bool get doSupportFolderStructure => FilesListingService.doSupportFolderStructure(type);
  bool get doShowModuleName => FilesListingService.doShowModuleName(type);
  String get moduleToUploadType => FilesListingService.moduleTypeToUploadType(type);
  bool get isSubContractorPrime => AuthService.isPrimeSubUser(); 
  bool get isDropBoxConnected =>  AuthService.userDetails?.isDropBoxConnected ?? false;
  /// [isSalesProForEstimate] helps to check whether sales pro for estimate is enabled or not
  bool get isSalesProForEstimate => LDService.hasFeatureEnabled(LDFlagKeyConstants.salesProForEstimate);
  /// [canFilterByModule] is used to enable selector on module name
  bool get canFilterByModule => (type == FLModule.templatesListing && !isSalesProForEstimate);
  bool isCompanyCamConnected = (ConnectedThirdPartyService.getConnectedPartyKey(ConnectedThirdPartyConstants.companyCam) ?? false);
  bool hasCompanyFilesManageAccess = PermissionService.hasUserPermissions([PermissionConstants.manageCompanyFiles]);

  int? parentWorksheetId;

  @override
  void onInit() {
    parentModule ??= Get.arguments?['parent_module'];
    setUpDrawerKeys();

    if (jobIdParam != null) jobId = jobIdParam;
    if (typeParam != null) type = typeParam!;
    if (projectIdParam != null) projectId = projectIdParam;

    setTemplatesListingType();
    getLoggedInData();
    getUsers();
    getTags();
    getProjectDetail();
    fetchResources(); // Will call api
    fetchCompanyTrades();
    super.onInit();
  }

  /// [setTemplatesListingType] - Sets the template list type based on the current module type and sales pro status.
  ///
  /// If the current module type is [FLModule.templatesListing], this method sets the
  /// [templateListType] property to either "proposal" (if [isSalesProForEstimate] is true)
  /// or "estimate" (if [isSalesProForEstimate] is false). Otherwise, the [templateListType]
  /// property remains unchanged.
  void setTemplatesListingType() {
    if(type == FLModule.templatesListing) {
      templateListType = isSalesProForEstimate ? 'proposal' : 'estimate';
    }
  }

  Future<void> getProjectDetail() async {
    if(type == FLModule.companyCamImagesFromJob){
      FilesListingModel file = await CompanyCamListingRepository.fetchFile(projectId ??'');
      projectName = file.name;
      companyCamphotoCount = file.photoCount ?? 0;
    }
  }

   bool doShowAddEditButton(FLModule type){
    if(PhasesVisibility.canShowSecondPhase){
      switch (type) {
        case  FLModule.measurements:
          bool isSubUser = AuthService.isSubUser();
          bool canShowMeasurementForm = !((jobModel?.isMultiJob ?? false) && PhasesVisibility.canShowSecondPhase);
          bool canShowEagleView = (ConnectedThirdPartyService.isEagleViewConnected() && !isSubUser && PermissionService.hasUserPermissions([PermissionConstants.manageEagleView]));
          bool canShowHover = (ConnectedThirdPartyService.isQuickMeasureConnected() && !isSubUser && PermissionService.hasUserPermissions([PermissionConstants.manageHover]));
          bool canShowQuickMeasure = ConnectedThirdPartyService.isQuickMeasureConnected() && !isSubUser;
          return canShowMeasurementForm || canShowEagleView || canShowHover || canShowQuickMeasure;
        case FLModule.estimate:
        case FLModule.materialLists:
        case FLModule.workOrder:
        case FLModule.jobProposal:
          return true;
        default:
          return false;
      }
    }
    return false;
  }

  void unFavoriteEstimate() {
    FilesListQuickActionPopups.showConfirmationBottomSheet(
      FilesListingQuickActionParams(
        fileList: [resourceList.where((element) => element.isSelected == true).first], 
        onActionComplete:(file, action){
          resourceList.removeAt(resourceList.indexWhere((element) => element.id == file.id));
          lastSelectedFile = null;
          selectedFileCount = 0;
          update();
        },
        type: FLModule.favouriteListing
      ),
    FLQuickActions.unMarkAsFavourite);
  }

  String attachmentHeaderTitle() {
    switch (type) {
      case FLModule.paymentReceipt:
        return 'select_deposit_receipts'.tr.toUpperCase();
      
      case FLModule.companyCamProjects:
        return 'select_company_cam_project'.tr.toUpperCase();
        
      default:
        return 'select_files'.tr.toUpperCase();
    }
  }

  Future<dynamic> getLoggedInData() async {
    loggedInUser = await AuthService.getLoggedInUser();
  }

  void openTradeFilterDialog() {
    showJPGeneralDialog(
        child: (controller) => FavouriteFilterDialogView(
          selectedFilters: favouritefilterkey,
          defaultFilters: defaultFilters,
          onApply: (HomeFilterModel params) {
            if (defaultFilters != params) {
              favouritefilterkey = params;
              isLoading = true;
              lastSelectedFile = null;
              selectedFileCount = 0;
              update();
              fetchResources();
            }
          },
        ));
  }

  void getTags() async {
    try {
      TagParamModel tagsParams = TagParamModel(includes: ['users'],);

      SqlTagsRepository().get(params: tagsParams).then((tags) {
        for (var element in tags.data) {
          tagsList.add(JPMultiSelectModel(id: element.id.toString(),
            label: element.name, isSelect: false,
            subListLength: element.users?.length,
          ));
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  void getUsers() async {
    try {
      UserParamModel requestParams = UserParamModel(limit: 0, withSubContractorPrime: true, includes: ['tags']);
      UserResponseModel userResponse = await SqlUserRepository().get(params: requestParams);
      userList = userResponse.data;
    } catch (e) {
      rethrow;
    }
  }

  void initRequiredVariables() {
    isInMoveFileMode = false;
    isInCopyFileMode = false;
    switch (mode) {  
      case FLViewMode.attach:
        type = attachType!;
        jobId = attachJobId;
        isInSelectionMode = true;
        break;
      case FLViewMode.apply:
        type = attachType!;
        jobId = attachJobId;
        isInSelectionMode = true;
        break;
      case FLViewMode.move:
        isInMoveFileMode = true;
        break;
      case FLViewMode.copy:
      case FLViewMode.moveToJob:
        type = attachType!;
        jobId = attachJobId;
        isInSelectionMode = false;
        isInCopyFileMode = true;
        showListView = true;
        break;
      default:
        break;
    }
    if (type == FLModule.stageResources &&
        selectedTabForStageResources == 'goal') {
      isGoalSelected = true;
      update();
    }
  }

  void setUpDrawerKeys() {
    scaffoldKey = GlobalKey<ScaffoldState>();
    secondaryDrawerKey = GlobalKey<ScaffoldState>();
  }

  String getSelectedRoute() {
    switch (type) {
      case FLModule.instantPhotoGallery:
        return 'instant_photo_gallery';
      case FLModule.companyFiles:
        return "company_files";
      case FLModule.dropBoxListing:
        return "dropbox";
      case FLModule.companyCamProjects:
      case FLModule.companyCamProjectImages:
        return "companycam";
      case FLModule.templatesListing:
        return "templates";
      default:
        return "";
    }
  }

  String removeZeroValue(int? value, bool canShowValue){
    return canShowValue ? '' : value == 0 ? '' : ' ($value)';
  }

  String getModuleNameWithCount(){
    bool isJobNull = jobModel == null;
    switch(type){
      case FLModule.estimate:
        return 'estimates'.tr.toUpperCase() + removeZeroValue(jobModel?.count?.estimates, isLoading);

      case FLModule.jobPhotos:
        return 'photos_documents'.tr.toUpperCase() + removeZeroValue(jobModel?.count?.jobResources, isJobNull);

      case FLModule.jobProposal:
        return 'forms_proposals'.tr.toUpperCase() + removeZeroValue(jobModel?.count?.proposals, isLoading);

      case FLModule.measurements:
        return 'measurements'.tr.toUpperCase() + removeZeroValue(jobModel?.count?.measurements, isLoading);

      case FLModule.materialLists:
        return 'materials'.tr.toUpperCase() + removeZeroValue(jobModel?.count?.materialLists, isLoading);

      case FLModule.workOrder:
        return 'work_orders'.tr.toUpperCase() + removeZeroValue(jobModel?.count?.workOrders, isLoading);

      case FLModule.templates:
        return (parentModule == FLModule.estimate ? 'handwritten_template' : 'form_proposal_template').tr.toUpperCase() + removeZeroValue(totalResults, isLoading);

        case FLModule.templatesListing:
        return (templateListType == "estimate" ? 'handwritten_template' : 'form_proposal_template').tr.toUpperCase() + removeZeroValue(totalResults, isLoading);

      case FLModule.mergeTemplate:
        return 'merge_template'.tr.toUpperCase();

      case FLModule.googleSheetTemplate:
        return 'google_spreadsheet_template'.tr.toUpperCase() + removeZeroValue(totalResults, isLoading);

      case FLModule.jobContracts:
        return 'contracts'.tr.toUpperCase() + removeZeroValue(jobModel?.count?.contracts, isLoading);

      default:
          return "";  
    }
  }

  void onPopUpMenuItemTap(PopoverActionModel selected) async {
    switch (selected.value) {
      case 'dropbox':
      showDropBoxListBottomSheet();
      break;
      case 'company_cam_photos':
      navigateToCompanyCam();
      break;
      case 'unlink_company_cam':
      unLinkCompanyCam();
      break;
      case 'link_job_to_company_cam':
      showCompanyCamListBottomSheet();
      break;
    }
  }

  Future<void> unLinkCompanyCam() async {
    showJPLoader();
    try{
      Map<String,dynamic> deleteParams = {
      'job_id' : jobModel?.id
    };
    
    await JobPhotosRepository.unLinkCompanyCam(deleteParams);
    
      jobModel?.meta?.companyCamId = null;
      Helper.showToastMessage('job_unlinked'.tr);
    
    update();

    }catch(e){
      rethrow;
    }finally {
      Get.back();
    }
    
  }

  Future<void> linkJobToCompanyCam(String? projectId, FilesListingController controller) async {
    try {
      Map<String,dynamic> linkParams = {
        'job_id' : jobModel?.id,
        'project_id' : projectId
      };

      await JobPhotosRepository.linkCompanyCam(linkParams);
      jobModel?.meta?.companyCamId = projectId;
      Get.back();
      Helper.showToastMessage('job_linked'.tr);
      update();
      
    } catch (e) {
      rethrow;
    } finally {
      controller.toggleIsMovingFile();
    }
  }

  Future<void> navigateToCompanyCam() async{
    Get.toNamed(Routes.filesListing, arguments: {
      'projectId' : jobModel?.meta?.companyCamId ?? '',
      'type' : FLModule.companyCamImagesFromJob,
      'customerId' : jobModel?.customerId,
      'jobId' : jobModel?.id
    }); 
  }

  Future<void> showCompanyCamListBottomSheet() async {
    showJPBottomSheet(
      child: (_) => GetBuilder<FilesListingController>(
        init: FilesListingController(
            mode: FLViewMode.attach,
            attachType: FLModule.companyCamProjects,
            allowMultipleSelection: false
        ),
        global: false,
        
        builder: (FilesListingController controller) {
          return JPSafeArea(
            bottom: false,
            child: FilesView(
              controller: controller,
              onTapAttach: (List<FilesListingModel> selectedFiles) async {
                controller.toggleIsMovingFile();
                await linkJobToCompanyCam(selectedFiles.first.id, controller);
              },
            ),
          );
        },
      ),
    ignoreSafeArea: false,
    isScrollControlled: true);
  }

  Future<void> showDropBoxListBottomSheet() async {
    showJPBottomSheet(
      child: (_) => GetBuilder<FilesListingController>(
        init: FilesListingController(
            mode: FLViewMode.attach,
            suffixIconText: 'copy'.tr.toUpperCase(),
            attachType: FLModule.dropBoxListing,
            allowMultipleSelection: true),
        global: false,
        builder: (FilesListingController controller) {
          return JPSafeArea(
            bottom: false,
            child: FilesView(
              controller: controller,
              onTapAttach: (List<FilesListingModel> selectedFiles) async {
                Get.back();
                showFileSelectionBottomSheet(selectedFiles);
              },
            ),
          );
        },
      ),
    ignoreSafeArea: false,
    isScrollControlled: true);
  }

  Future<void> showFileSelectionBottomSheet(List<FilesListingModel> selectedFiles) async{
    showJPBottomSheet(
      child: (_) => GetBuilder<FilesListingController>(
        init: FilesListingController(
          attachType: FLModule.jobPhotos,
          mode: FLViewMode.copy,
          attachJobId: jobId,
          allowMultipleSelection: false,
        ),
        global: false,
        builder: (FilesListingController controller) {
          return JPSafeArea(
            bottom: false,
            child: FilesView(
              controller: controller,
              onTapAttach: (_) async {
                controller.toggleIsMovingFile();
                await FileListingPhotosQuickActionRepo.copyFile(selectedFiles, jobId ?? -1, type, 'resource', dirId: controller.getSelectedDirID());  
                controller.toggleIsMovingFile();
                Get.back();
                Get.back();
                Helper.showToastMessage('file_saved'.tr);
              },
            ),
          );
        },
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }

  bool get showMoreAction {
      if (type != FLModule.jobPhotos || isSubContractorPrime) {
        return false;
      }
      return isDropBoxConnected || isCompanyCamConnected;
  }
  
  String getTitle() {
    if (isInSelectionMode && selectedFileCount > 0) {
      return '$selectedFileCount ${'selected'.tr}';
    } else if (jobModel != null) {
      return jobModel!.customer!.fullName!;
    } else {
      switch (type) {
        case FLModule.companyFiles:
          return 'company_files'.tr;

        case FLModule.estimate:
          return 'estimates'.tr;

        case FLModule.jobPhotos:
          return 'photos_documents'.tr;

        case FLModule.jobProposal:
          return 'forms_proposals'.tr;

        case FLModule.measurements:
          return 'measurements'.tr;

        case FLModule.materialLists:
          return 'materials'.tr;

        case FLModule.workOrder:
          return 'work_orders'.tr;

        case FLModule.stageResources:
          return int.tryParse(selectedStageCode ?? "") == null
              ? selectedStageCode ?? "stage_resources".tr
              : "stage_resources".tr;

        case FLModule.userDocuments:
          return 'user_documents'.tr;

        case FLModule.customerFiles:
          return 'customer_files'.tr;

        case FLModule.instantPhotoGallery:
          return 'instant_photos'.tr;

        case FLModule.dropBoxListing:
          return 'dropbox'.tr;

        case FLModule.templatesListing:
          return 'templates'.tr;

        case FLModule.financialInvoice:
          return '';

        case FLModule.companyCamProjects:
          return 'companycam_projects'.tr;
        case FLModule.companyCamProjectImages:
          return 'companycam_projects'.tr;
        case FLModule.companyCamImagesFromJob:
          return projectName ?? '';

        case FLModule.jobContracts:
          return 'contracts'.tr;

        default:
          return "";
      }
    }
  }

  // initParam() is called before calling any api to set root id and
  // to initialize companyFileListRequestParam only when these values are null
  Future<void> initParam() async {
    initRequiredVariables();

    if (fileListingRequestParam != null) return;

    if (isInCopyFileMode! && (type == FLModule.companyFiles || type == FLModule.companyCamProjectImages || type == FLModule.instantPhotoGallery)) {
      return await getJobPhotosParams();
    }

    switch (type) {
      case FLModule.companyFiles:
        return await getCompanyFilesParams();

      case FLModule.estimate:
        return await getJobEstimateParams();

      case FLModule.jobPhotos:
        return await getJobPhotosParams();

      case FLModule.jobProposal:
        return await getJobProposalParams();

      case FLModule.measurements:
        return await getMeasurementsParams();

      case FLModule.materialLists:
        return await getMaterialListsParam();

      case FLModule.workOrder:
        return await getWorkOrderParam();

      case FLModule.stageResources:
        return await getStageResourcesParam();

      case FLModule.userDocuments:
        return await getUserDocumentsParam();

      case FLModule.customerFiles:
        return await getCustomerFileParam();

      case FLModule.instantPhotoGallery:
        return await getinstantPhotoGalleryParam();

      case FLModule.dropBoxListing:
        return await getDropBoxParams();

      case FLModule.companyCamProjects:
        return await getCompanyCamParam();
      case FLModule.favouriteListing:
        return await getFavouriteListingParams();

      case FLModule.googleSheetTemplate:
        return await getGoogleSpreadsheetTemplateParams();  

      case FLModule.templates:
      case FLModule.mergeTemplate:
        return await getTemplateParams();

      case FLModule.templatesListing:
        return await getTemplatesListingParams();
      
      case FLModule.companyCamImagesFromJob:
        return await getCompanyCamPhotoFromJobParam();

      case FLModule.jobContracts:
        return await getJobContractsParams();

      default:
        break;
    }
  }

  Future<void> getDropBoxParams() async {
    fileListingRequestParam = FilesListingRequestParam(parent: null, parentId: null);
    folderPath.add(BreadCrumbModel(id: '-1', name: 'root'.tr));
    update();
  }

  Future<void> getCompanyFilesParams() async {
    final user = await AuthService.getLoggedInUser();
    if (user.companyDetails?.resourceId == null) {
      isLoading = false;
      update();
      return;
    }

    rootId = user.companyDetails?.resourceId;
    
    fileListingRequestParam = FilesListingRequestParam(parentId: user.companyDetails!.resourceId);
    fileListingRequestParam?.dirWithImageOnly = dirWithImageOnly;
    folderPath.add(
      BreadCrumbModel(
        id: fileListingRequestParam!.parentId!.toString(),
        name: 'root'.tr, // 'Root' is default name of first folder
      ),
    );
    update();
  }
 
  Future<void> getJobEstimateParams() async {
    fileListingRequestParam = FilesListingRequestParam(parentId: null);
    fileListingRequestParam?.dirWithImageOnly = dirWithImageOnly;
    folderPath.add(BreadCrumbModel(id: '-1', name: 'root'.tr));
    update();
  }

  Future<void> getJobContractsParams() async {
    fileListingRequestParam = FilesListingRequestParam(parentId: null);
    fileListingRequestParam?.dirWithImageOnly = dirWithImageOnly;
    folderPath.add(BreadCrumbModel(id: '-1', name: 'root'.tr));
    update();
  }

  Future<void> getinstantPhotoGalleryParam() async {
    fileListingRequestParam = FilesListingRequestParam(parentId: null);
  }

  Future<void> getJobPhotosParams() async {
    if (jobId == null) return;

    jobModel = (await JobRepository.fetchJob(jobId!, loadJobWithCounts: true))['job'];

    if (jobModel == null || jobModel?.meta?.resourceId == null) return;

    fileListingRequestParam = FilesListingRequestParam(parentId: int.parse(jobModel!.meta!.resourceId!));
    fileListingRequestParam?.dirWithImageOnly = dirWithImageOnly;
    folderPath.add(BreadCrumbModel(id: jobModel!.meta!.resourceId!, name: 'root'.tr));
    update();
  }

  Future<void> getJobProposalParams() async {
    fileListingRequestParam = FilesListingRequestParam(parentId: null);
    fileListingRequestParam?.dirWithImageOnly = dirWithImageOnly;
    folderPath.add(BreadCrumbModel(id: '-1', name: 'root'.tr));
    update();
  }

  Future<void> getMeasurementsParams() async {
    fileListingRequestParam = FilesListingRequestParam(parentId: null);
    folderPath.add(BreadCrumbModel(id: '-1', name: 'root'.tr));
    update();
  }
  Future<void> getFavouriteListingParams() async {
    fileListingRequestParam = FilesListingRequestParam(parentId: null);
    folderPath.add(BreadCrumbModel(id: '-1', name: 'root'.tr));
    update();
  }

  Future<void> getMaterialListsParam() async {
    fileListingRequestParam = FilesListingRequestParam(parentId: null);
    folderPath.add(BreadCrumbModel(id: '-1', name: 'root'.tr));
    update();
  }

  Future<void> getWorkOrderParam() async {
    fileListingRequestParam = FilesListingRequestParam(parentId: null);
    folderPath.add(BreadCrumbModel(id: '-1', name: 'root'.tr));
    update();
  }

  Future<void> getCompanyCamParam() async {
    fileListingRequestParam = FilesListingRequestParam(parentId: null);
    fileListingRequestParam?.dirWithImageOnly = dirWithImageOnly;
    folderPath.add(BreadCrumbModel(id: '-1', name: 'root'.tr));
    update();
  }

  Future<void> getCompanyCamPhotoFromJobParam() async {
    fileListingRequestParam = FilesListingRequestParam(parentId: null);
    fileListingRequestParam?.dirWithImageOnly = dirWithImageOnly;
    folderPath.add(BreadCrumbModel(id: '-1', name: 'root'.tr));
    update();
  }

  Future<void> getTemplateParams() async {
    fileListingRequestParam = FilesListingRequestParam(parentId: null);
    fileListingRequestParam?.templatesListType = templateListType;
    folderPath.add(BreadCrumbModel(id: '-1', name: 'root'.tr));
    update();
  }

  Future<void> getTemplatesListingParams() async {
    fileListingRequestParam = FilesListingRequestParam(parentId: null);
    folderPath.add(BreadCrumbModel(id: '-1', name: 'root'.tr));
    update();
  }

  Future<void> getGoogleSpreadsheetTemplateParams() async {
    fileListingRequestParam = FilesListingRequestParam(parentId: null);
    folderPath.add(BreadCrumbModel(id: '-1', name: 'root'.tr));
    update();
  }

  Future<void> getStageResourcesParam() async {
    int? resId;
    stages = [];

    if (jobId == null) {
      stages = await StageResourcesRepository.fetchStages();
      if (selectedStageCode != null) {
        final stage = stages.firstWhere((element) => element.code == selectedStageCode);
        selectedStageCode = stage.name;
        resId = stage.resourceId;
      } else {
        resId = stages.first.resourceId;
      }
    } else {
      Map<String, dynamic> params = {"includes[]": "workflow"};

      jobModel = (await JobRepository.fetchJob(jobId!, params: params, loadJobWithCounts: true))['job'];
      resId = jobModel?.currentStage!.resourceId;
      if (jobModel == null || resId == null) return;
      stages = jobModel?.stages ?? [];
    }

    if (resId == null) return;

    if (selectedStageCode != null && type == FLModule.stageResources) {
      setCurrentStageGoalDescription(selectedStageCode!);
    }

    for (var stage in stages) {
      stageResourcesFilter.add(
        JPSingleSelectModel(label: stage.name.toString().capitalizeFirst ?? '',
          id: stage.resourceId.toString(), color: WorkFlowStageConstants.colors[stage.color]),
      );
    }

    setCurrentStageGoalDescription(resId.toString());

    fileListingRequestParam = FilesListingRequestParam(parentId: resId);
    fileListingRequestParam?.dirWithImageOnly = dirWithImageOnly;
    update();
  }

  Future<void> getUserDocumentsParam() async {
    final user = await AuthService.getLoggedInUser();

    if (user.resourceId == null) {
      isLoading = false;
      update();
      return;
    }

    rootId = user.resourceId;
    fileListingRequestParam = FilesListingRequestParam(parentId: user.resourceId);
    folderPath.add(BreadCrumbModel(
        id: fileListingRequestParam!.parentId!.toString(),
        name: 'root'.tr, // 'Root' is default name of first folder
      ),
    );
    update();
  }

  Future<void> getCustomerFileParam() async {
    if (customerId == null) return;

    Map<String, dynamic> params = {'id': customerId, 'includes[]': 'meta'};

    customerModel = (await CustomerRepository.getCustomer(params));

    if (customerModel == null || customerModel!.meta == null) {
      rootId = await CustomerFilesRepository.setUpCustomerResources(customerId!);
    } else {
      rootId = int.parse(customerModel!.meta!.resourceId.toString());
    }

    fileListingRequestParam = FilesListingRequestParam(parentId: rootId);
    folderPath.add(BreadCrumbModel(
        id: fileListingRequestParam!.parentId!.toString(),
        name: 'root'.tr, // 'Root' is default name of first folder
      ),
    );
    update();
  }

  // Switches between listview and gridview
  void toggleView() {
    showListView = !showListView;
    Helper.hideKeyboard();
    update();
  }

  // Makes an Api call to fetch data
  // params : search (optional)
  // 1.) search - it is false by default and can be true in case we want to search
  Future<void> fetchResources({bool search = false, int? index}) async {
    if(type == FLModule.companyCamProjectImages && index != null && !Helper.isValueNullOrEmpty(resourceList)) {
      companyCamphotoCount = resourceList[index].photoCount ?? 0;
    }   
    try {
      await initParam();
      await CookiesService.validateAndRefreshCookiesIfNeeded();
      dynamic response = await typeToApi(FileListingTypeToApiParams(search: search, index: index));
      List<FilesListingModel> list = response['list'];
      if (!isLoadMore) {
        resourceList = [];
      }
      ///   Get unsaved resources from db
      if(resourceList.isEmpty && mode == FLViewMode.view) {
        list.insertAll(0, await fetchUnsavedResources());
      }

      resourceList.addAll(list);

      nextPageToken = response["next_page_token"]; //In dropbox we are getting next page token
      PaginationModel pagination = PaginationModel();
      canShowLoadMore = false;
      if (response["pagination"] != null && type != FLModule.companyCamProjects) {
        pagination = PaginationModel.fromJson(response["pagination"]);
        totalResults = pagination.total;
        canShowLoadMore = resourceList.length < totalResults!;
      } else if (type == FLModule.companyCamProjects) {
        pagination = PaginationModel.fromCompanyCamJson(response["pagination"]);
        int currentPage = pagination.currentPage ?? 0;
        int perPage = PaginationConstants.pageLimit;
        if (perPage * currentPage < resourceList.length + 1) {
          canShowLoadMore = true;
        } else {
          canShowLoadMore = false;
        }
      } else if (type == FLModule.companyCamProjectImages || type == FLModule.companyCamImagesFromJob) {
        canShowLoadMore = resourceList.length < companyCamphotoCount;
      } else if (nextPageToken != null) {
        canShowLoadMore = true;
      }
    } catch (e) {
      if (folderPath.length > 1) {
        folderPath.length = folderPath.length - 1;
      }
      rethrow;
    } finally {
      isLoading = false;
      isLoadMore = false;
      update();
      getBeaconOrderStatuses();
    }
  }

  Future<void> onRefresh({bool showLoading = false}) async {
    if (isInSelectionMode) return; // will avoid refreshing in selection mode

    isLoading = showLoading;
    fileListingRequestParam?.page = 1;
    fileListingRequestParam?.nextPageToken = null;
    fileListingRequestParam?.query = searchController.text.isNotEmpty ? searchController.text : '';
    update();
    if(type == FLModule.companyCamProjectImages && !Helper.isValueNullOrEmpty(resourceList)) {
      projectIdParam = resourceList.first.projectId;
    }
    await fetchResources(search: searchController.text.isNotEmpty);
  }

  Future<void> onLoadMore() async {
    if (FLModule.dropBoxListing == type && nextPageToken != null) {fileListingRequestParam?.nextPageToken = nextPageToken;
    } else if (type == FLModule.companyCamProjects && searchController.text != '') {
      fileListingRequestParam?.query = searchController.text;
      fileListingRequestParam?.page += 1;
    } else {
      if(type == FLModule.companyCamProjectImages && !Helper.isValueNullOrEmpty(resourceList)) {
      projectIdParam = resourceList.first.projectId;
    }
      fileListingRequestParam?.page += 1;
    }
    isLoadMore = true;
    await fetchResources();
  }

  // onSearchChanged() will be called when user search for something
  // Params : val (required)
  // 1.) val :- it is a keyword / set of characters that user search for
  void onSearchChanged(String val) {
    fileListingRequestParam?.page = 1;
    fileListingRequestParam?.nextPageToken = null;
    fileListingRequestParam?.keyword = val;
    fileListingRequestParam?.query = val;
    isInSelectionMode = false;
    selectedFileCount = 0;
    isLoading = true;
    totalResults = null;
    update();
    fetchResources(search: val.isNotEmpty);
  }

  void openDirectory(int index) {
    
    if (selectedFileCount > 0) {     
      showResetSelectionDialog(isOpeningFolder: true);
      return;
    }   
    if (type == FLModule.companyCamProjects) {
      type = FLModule.companyCamProjectImages;
      update();
    }
    fileListingRequestParam?.keyword = '';
    fileListingRequestParam?.page = 1;
    if (type == FLModule.dropBoxListing && resourceList[index].id != null && resourceList.isNotEmpty) {
      fileListingRequestParam?.parent = resourceList[index].id;
      fileListingRequestParam!.nextPageToken = null;
    } else {    
      fileListingRequestParam?.parentId = int.parse(resourceList[index].id!);
    } 
    collapseAt++;
    folderPath.add(
      BreadCrumbModel(
          id: type == FLModule.dropBoxListing && resourceList[index].id != null
              ? fileListingRequestParam!.parent!
              : fileListingRequestParam!.parentId!.toString(),
          name: resourceList[index].name.toString(),
          collapseAt: collapseAt),
    );
    isLoading = true;
    searchController.text = '';
    lastSelectedFile = null;
    update();
    fetchResources(index: index);
  }

  Future<void> onTapBreadCrumbItem(int index, {bool isUpdateTemplateType = false}) async {
    Helper.hideKeyboard();
    // Will avoid reloading of list while clicking on folder whose items are actively displaying
    if ((index == folderPath.length - 1 || isLoading) && !isUpdateTemplateType) return;

    isLoading = true;
    update();
    await Future<void>.delayed(const Duration(milliseconds: 200));
    fileListingRequestParam?.page = 1;
    if (type == FLModule.dropBoxListing) {
      fileListingRequestParam!.parent = getParent(index);
      fileListingRequestParam!.nextPageToken = null;
    } else if (type == FLModule.companyCamProjectImages) {
      fileListingRequestParam?.parentId = null;
      type = FLModule.companyCamProjects;
      update();
    } else {
      fileListingRequestParam?.parentId = getParentId(index);
    }
    folderPath.length = index + 1;
    selectedFileCount = 0;
    isInSelectionMode = mode == FLViewMode.attach || mode == FLViewMode.apply;
    collapseAt = folderPath[index].collapseAt;
    lastSelectedDir = null;
    lastSelectedFile = null;
    update();
    fetchResources();
  }

  int? getParentId(int index) {
    if (folderPath.isEmpty) return null;
    return folderPath[index].id == '-1' ? null : int.parse(folderPath[index].id);
  }

  String? getParent(int index) {
    if (folderPath.isEmpty) return null;
    return folderPath[index].id == '-1' ? null : folderPath[index].id;
  }

  // onWillPop check if
  // search field is empty - clears it
  // current directory is a sub directory - load parent directory
  // current directory is root directory - exit page
  Future<bool> onWillPop() async {
    if (searchController.text.isNotEmpty) {
      searchController.text = '';
      Helper.hideKeyboard();
      update();
      onSearchChanged('');
      return false;
    }

    if (folderPath.length > 1) {
      onTapBreadCrumbItem(folderPath.length - 2);
      return false;
    } else {
      Get.back();
      return true;
    }
  }

  // Bottom sheet to create new directory
  Future<void> showCreateFolderDialog() async {
    Helper.hideKeyboard();
    toggleIsPlaceHolderFixed();

    Timer(const Duration(milliseconds: 400), () => createFolderDialogFocusNode.requestFocus());

    await showJPGeneralDialog(child: (controller) {
      return JPQuickEditDialog(
        type: JPQuickEditDialogType.inputBox,
        label: 'folder_name'.tr,
        focusNode: createFolderDialogFocusNode,
        onSuffixTap: (val) async {
          controller.toggleIsLoading();
          await createNewDirectory(val);
          controller.toggleIsLoading();
        },
        errorText: 'please_enter_folder_name'.tr,
        suffixIcon: showJPConfirmationLoader(show: controller.isLoading),
        disableButton: controller.isLoading,
        suffixTitle: 'create'.tr.toUpperCase(),
        maxLength: 50,
        position: JPQuickEditDialogPosition.bottom,
      );
    });

    await Future<void>.delayed(const Duration(milliseconds: 500));

    toggleIsPlaceHolderFixed();
  }

  void toggleIsPlaceHolderFixed() {
    isPlaceHolderFixed = !isPlaceHolderFixed;
    update();
  }

  // onTapResource() will perform action as per type of resource and selection mode
  void onTapResource(int index) async {
    if(resourceList[index].isRestricted){
      Helper.showToastMessage('you_do_not_have_access_to_this_folder'.tr);
      return;
    }
    if(resourceList[index].isDir == 0 && type == FLModule.mergeTemplate){
      isInSelectionMode = true;
     update();
    }
    Helper.hideKeyboard();

    if (isInMoveFileMode! || isInCopyFileMode!) {
      onSelectMoveToDir(index);
    } else if (isInSelectionMode) {

      if (Helper.isTrue(resourceList[index].isUnSupportedFile)) {
        Helper.showToastMessage("unsupported_file_cannot_be_selected".tr);
      } else if (resourceList[index].isDir == 1 && type != FLModule.companyCamProjects) {
        openDirectory(index);
      } else {
        if (allowMultipleSelection) {
          switch (resourceList[index].isSelected) {
            case true:
              removeOnSingleAddOnMultiple(index);
              break;
            case false:
              addToSelectedFiles(index);
              break;
            default:
              break;
          }
        } else {
          selectSingleFile(index);
        }
      }

    } else if(type == FLModule.templatesListing && (resourceList[index].isFile ?? false)) {
      selectJob(index);
    } else if (type == FLModule.templates && (resourceList[index].isFile ?? false)) {
      await loadTemplate(index);
    } else if(type == FLModule.googleSheetTemplate && (resourceList[index].isFile ?? false)){
      openNameDialog(index);
    } else {
      switch (resourceList[index].jpThumbType) {
        case JPThumbType.folder:
          openDirectory(index);
          break;
        case JPThumbType.image:
          goToPhotoViewer(index);
          break;
        case JPThumbType.icon:
          handleIconTypeTap(type,index);
          break;
        default:
          break;
      }
    }
  }

  Future<void> loadTemplate(int index) async {
    if(AuthService.hasExternalTemplateUser()) {
      if((type == FLModule.templates || type == FLModule.templatesListing) && templateListType == 'proposal') {
        String url = await ExternalTemplateWebViewService.createProposalTemplateUrl(jobModel, resourceList[index].id);
        debugPrint("Create proposal template url : $url");
        ExternalTemplateWebViewService.navigateToExternalTemplateWebView(url, onRefresh, type: type);
      } else {
        navigateTypeToTemplate(index);
      }      
    } else {
      navigateTypeToTemplate(index);
    }
  }

  Future<void> handleIconTypeTap(FLModule type,int index) async {
    if ((type == FLModule.estimate || type == FLModule.jobProposal) && Helper.isTrue(resourceList[index].isGoogleSheet)) {
      Helper.launchUrl(resourceList[index].googleSheetLink!,isInExternalMode: false);
    } else if (type == FLModule.dropBoxListing) {
      String token = await AuthService.getAccessToken();
      resourceList[index].originalFilePath = '${Urls.dropBoxDownLoading}?file_id=${resourceList[index].id}&access_token=$token';
      FileListQuickActionHandlers.downloadAndOpenFile(resourceList[index].originalFilePath ?? '', classType: resourceList[index].classType);
    }
    else if(resourceList[index].type == ResourceType.unsavedResource) {
      FileListQuickActionHandlers.navigateToEditUnsavedResource(
          FilesListingQuickActionParams(fileList: [resourceList[index]],
              jobModel: jobModel,
              type: type,
              onActionComplete: (_, __) {
            onRefresh(showLoading: true);
          })
      );
    } else {
      if(FileListingQuickActionHelpers.isChooseSupplierSettings(resourceList[index].worksheet)) {
        FileListingQuickActionHelpers.showDialogForSupplierSettings(FilesListingQuickActionParams(
          fileList: [
            resourceList[index]
          ], onActionComplete: (_, __) {
              onRefresh(showLoading: true);
            },
          jobModel: jobModel,
          type: type
        )
        );
      } else {
        FileListQuickActionHandlers.downloadAndOpenFile(resourceList[index].originalFilePath ?? '', classType: resourceList[index].classType);
      }
    }
  }

  void onLongPressResource(int index) {
    if (mode == FLViewMode.attach || mode == FLViewMode.apply) {
      onTapResource(index);
      return;
    }

    Helper.hideKeyboard();

    if (isInMoveFileMode!) return; // will not work in move file mode

    // Show toast message and prevent quick actions for locked directories
    if (isResourceLocked(resourceList[index])) {
      Helper.showToastMessage('directory_locked'.tr);
      return;
    }

    if (showQuickActionsOrMultiSelectOnLongPress(index)) {
      if(doShowQuickAction(resourceList[index])){
        showQuickAction(index: index);
      }
      return;
    }

    isInSelectionMode = true;
    onTapResource(index);
    update();
  }

  void addToSelectedFiles(int index) {
    if (resourceList[index].isDir == 1) return;

    if (!doFileHaveSamePageType(resourceList[index])) return;
    selectedFileOrder.add(index);
    bool isGroupMergeTemplate = type == FLModule.mergeTemplate && (resourceList[index].isGroup ?? false);

    if (selectedFileCount >= 20) {
      Helper.showToastMessage("cant_select_more_then_20_files".tr);
      return;
    } else if (isGroupMergeTemplate) {
      selectMergeGroupTemplate(index);
    } else {
      selectedFileCount++;
      resourceList[index].isSelected = true;
      selectedPageType = resourceList[index].pageType;
      update();
    }
  }

  void selectMergeGroupTemplate(int index, {bool doSelect = true}) {
    final tappedFile = resourceList[index];
    int countToAdd = 0;
    int totalPages = tappedFile.totalPages ?? 0;
    tappedFile.isSelected = doSelect;
    if (tappedFile.proposalTemplatePages?.length == totalPages) {
      tappedFile.proposalTemplatePages?.forEach((page) {
        if (!page.isSelected) countToAdd++;
        page.isSelected = doSelect;
      });
    } else {
      countToAdd = totalPages;
    }
    selectedPageType = resourceList[index].pageType;
    selectedFileCount = selectedFileCount + (doSelect ? countToAdd : -totalPages);
    update();
  }

  void removeOnSingleAddOnMultiple(int index) {

    bool isGroupMergeTemplate = type == FLModule.mergeTemplate && (resourceList[index].isGroup ?? false);
    selectedFileOrder.removeWhere((element) => element == index);
    if (isGroupMergeTemplate) {
      selectMergeGroupTemplate(index, doSelect: false);
      if (selectedFileCount == 0 && mode == FLViewMode.view) {
        isInSelectionMode = false;
        selectedPageType = null;
      }
    } else if (resourceList[index].isSelected!) {
      resourceList[index].isSelected = false;
      selectedFileCount--;
      if (selectedFileCount == 0 && mode == FLViewMode.view) {
        isInSelectionMode = false;
        selectedPageType = null;
      }
    } else {
      resourceList[index].isSelected = true;
    }
    update();
  }

  void selectSingleFile(int index) {
    if (resourceList[index].isSelected!) {
      resourceList[index].isSelected = false;
      selectedFileCount--;
      lastSelectedFile = null;
    } else {
      if (lastSelectedFile != null) {
        resourceList[lastSelectedFile!].isSelected = false;
      }
      resourceList[index].isSelected = true;
      lastSelectedFile = index;
      selectedFileCount = 1;
    }
    update();
  }

  void onCancelSelection() {
    if (mode == FLViewMode.attach || mode == FLViewMode.apply) {
      Get.back();
      return;
    }
    selectedFileOrder = [];
    for (var resource in resourceList) {
      resource.isSelected = false;
    }
    isInSelectionMode = false;
    selectedPageType = null;
    selectedFileCount = 0;
    update();
  }

  void showQuickAction({int? index}) {
    Helper.hideKeyboard();

    List<FilesListingModel> selectedItems = index != null
      ? <FilesListingModel>[resourceList[index]]
      : resourceList.where((element) => element.isSelected ?? false).toList(); // Filtering selected items from all items

    FilesListingService.openQuickAction(
      FilesListingQuickActionParams(
        type: type,
        fileList: selectedItems,
        jobModel: jobModel,
        customerModel: customerModel,
        unAppliedCreditList: financialUnAppliedCreditList,
        subscriberDetails: subscriberDetails,
        isInSelectionMode: selectedItems.length > 1,
        onActionComplete: (FilesListingModel model, action) async {
          switch (action) {
            case FinancialQuickAction.unlinkProposal:
              int index = resourceList.indexWhere((element) => element.id == model.id);
              if (index != -1) {
                for (int i = 0; i <= resourceList.length - 1; i++) {
                  resourceList[i].proposalId = null;
                }
              }
              update();
              break;
            case FLModule.jobProposal:  
            case FinancialQuickAction.applyCredit:
              onRefresh();
              break;
            case FinancialQuickAction.linkProposal:
              int index = resourceList.indexWhere((element) => element.id == model.id);
              if (index != -1) {
                for (int i = 0; i <= resourceList.length - 1; i++) {
                  resourceList[i].proposalId = model.proposalId;
                  resourceList[i].proposalUrl = model.proposalUrl;
                }
              }
              break;
            case FinancialQuickAction.deleteInvoice:
              resourceList.removeWhere((element) => element.id == model.id);
              update();
              break;
            case FLQuickActions.rename:
              int position = resourceList.indexWhere((element) => element.id == model.id);
              resourceList[position] = model;
              isInSelectionMode = false;
              selectedFileCount = 0;
              update();
              break;
            case FinancialQuickAction.recordPayment:
            case FinancialQuickAction.unsavedResourceEdit:
            case FinancialQuickAction.unsavedResourceDelete:
              onRefresh();
              break;
            case FLQuickActions.generateJobInvoice:
            case FLQuickActions.updateJobInvoice:
              jobModel = null;
              onRefresh(showLoading: true);
              break;
            case FLQuickActions.delete:
              resourceList.removeWhere((element) => element.isSelected == true || element.id == model.id);
              await updateFileCountOnDelete(type,selectedFileCount,model);
              isInSelectionMode = false;
              selectedFileCount = 0;
              refreshRecentFilesListing();
              onRefresh(showLoading: true);
              break;
            case FLQuickActions.markAsCompleted:
            case FLQuickActions.markAsPending:
              int position = resourceList.indexWhere((element) => element.id == model.id);
              resourceList[position].status = model.status;
              update();
              break;
            case FLQuickActions.rotate:
              int position = resourceList.indexWhere((element) => element.id == model.id);
              resourceList[position] = model;
              if(isInSelectionMode) selectedFileCount--;
              if (selectedFileCount == 0) isInSelectionMode = false;
              update();
              break;
            case FLQuickActions.move:
              isLoading = true;
              selectedFileCount = 0;
              isInSelectionMode = false;
              onRefresh();
              break;
            case FLQuickActions.moveToJob:
              isLoading = true;
              selectedFileCount = 0;
              isInSelectionMode = false;
              update();
              fetchResources();
              break;
            case FLQuickActions.unMarkAsFavourite:
              int position = resourceList.indexWhere((element) => element.id == model.id);
              resourceList[position] = model;
              update();
              break;
            case FLQuickActions.markAsFavourite:
              int position = resourceList.indexWhere((element) => element.id == model.id);
              resourceList[position] = model;
              update();
              break;
            case FLQuickActions.showOnCustomerWebPage:
              int position = resourceList.indexWhere((element) => element.id == model.id);
              resourceList[position] = model;
              resourceList[position].isSelected = false;
              selectedFileCount = 0;
              isInSelectionMode = false;
              update();
              break;
            case FLQuickActions.makeACopy:
              isLoading = true;
              selectedFileCount = 0;
              isInSelectionMode = false;
              update();
              fetchResources();
              break;
            case FLQuickActions.updateStatus:
              int position = resourceList.indexWhere((element) => element.id == model.id);
              resourceList[position] = model;
              update();
              break;
            case FLQuickActions.expireOn:
              int position = resourceList.indexWhere((element) => element.id == model.id);
              resourceList[position] = model;
              selectedFileCount = 0;
              isInSelectionMode = false;
              update();
              break;
            case FLQuickActions.setDeliveryDate:
              int position = resourceList.indexWhere((element) => element.id == model.id);
              resourceList[position] = model;
              selectedFileCount = 0;
              isInSelectionMode = false;
              update();
              break;
            case FLQuickActions.upgradeToHoverRoofOnly:
              int position = resourceList.indexWhere((element) => element.id == model.id);
              resourceList[position] = model;
              selectedFileCount = 0;
              isInSelectionMode = false;
              update();
              break;
            case FLQuickActions.copyToJob:
              for (var element in resourceList) {
                if (element.isSelected ?? false) element.isSelected = false;
              }
              selectedFileCount = 0;
              isInSelectionMode = false;
              update();
              break;
            case FLQuickActions.edit:
              int position = resourceList.indexWhere((element) => element.id == model.id);
              resourceList[position] = model;
              selectedFileCount = 0;
              isInSelectionMode = false;
              update();
              break;
            case FinancialQuickAction.edit:
              navigateToInvoiceOrChangeOrder(model.beaconAccountId, model.type!, int.parse(model.id!));
              break;

            case FLQuickActions.assignTo:
              int position = resourceList.indexWhere((element) => element.id == model.id);
              resourceList[position].workOrderAssignedUser = model.workOrderAssignedUser;
              update();
              break;
            case FLQuickActions.email:
              if(type == FLModule.jobProposal) {
                onRefresh(showLoading: true);
              } else {
                for (var element in resourceList) {
                  if (element.isSelected ?? false) element.isSelected = false;
                }
                isInSelectionMode = false;
                selectedFileCount = 0;
                update();
              }
              break;
            case FLQuickActions.editMeasurement:
            case FLQuickActions.editInsurance:
            case FLQuickActions.editProposalTemplate:
            case FLQuickActions.editUnsavedResource:
            case FLQuickActions.deleteUnsavedResource:
            case FLQuickActions.unsavedResourceUpdated:
            case FLQuickActions.handwrittenTemplate:
            case FLQuickActions.worksheet:
            case FLQuickActions.placeSRSOrder:
            case FLQuickActions.placeBeaconOrder:
            case FLQuickActions.placeABCOrder:
            case FLQuickActions.schedule:
            case FLQuickActions.emailCumulativeInvoice:
            case FLQuickActions.generateWorkSheet:
            case FLQuickActions.editWorksheet:
            case FLQuickActions.worksheetSignFormProposal:
              onRefresh(showLoading: true);
              break;
            default:
              break;
          }
        },
      ),
    );
  }

  int decreaseCount(int number){
    return number - 1;
  }
  // Handle recent files(Recent photos & documents, estimates and proposals) section refresh on deletion of file
  void refreshRecentFilesListing() {
    final String controllerTag = moduleToUploadType + (jobId ?? "").toString();

    // if recent files is active or in job overview screen is active
    if(Get.isRegistered<RecentFilesController>(tag: controllerTag)) {
      final recentFileController = Get.find<RecentFilesController>(tag: controllerTag);
      recentFileController.onRefresh(
          showLoading: recentFileController.resourceList.isNotEmpty,
      );
    }
  } 

  Future<void> updateFileCountOnDelete(FLModule module, int selectedFileCount, FilesListingModel model) async {
    switch(module){
      case FLModule.estimate:
        jobModel!.count!.estimates = decreaseCount(jobModel!.count!.estimates!);
        break;
      case FLModule.jobProposal:
        jobModel!.count!.proposals = decreaseCount(jobModel!.count!.proposals!);
        break;
      case FLModule.materialLists:
        jobModel!.count!.materialLists = decreaseCount(jobModel!.count!.materialLists!);
        break;
      case FLModule.measurements:
        jobModel!.count!.measurements = decreaseCount(jobModel!.count!.measurements!);
        break;
      case FLModule.workOrder:
        jobModel!.count!.workOrders = decreaseCount(jobModel!.count!.workOrders!);
        break;
      case FLModule.jobPhotos:
        if(selectedFileCount > 0) {
          jobModel!.count!.jobResources = jobModel!.count!.jobResources! - selectedFileCount;
        } else {
          if(model.isDir == 1){
            await jobPhotoListingApiCall();
          } else{
            jobModel!.count!.jobResources = decreaseCount(jobModel!.count!.jobResources!);
          }
        }
        break;
      default:
        break;  
    }
  }

  Future<void> createNewDirectory(String dirName) async {
    try {
      final newDirName = dirName.trim();
      FilesListingModel data = await typeToCreateDirectoryApi(newDirName);

      if (searchController.text == '') {
        isLoading = true;
        update();

        resourceList.insert(0, data);
        isLoading = false;
      } else if (data.name!.contains(searchController.text)) {
        update();
      }

      MixPanelService.trackEvent(event: MixPanelAddEvent.createDirectorySuccess);
      Helper.showToastMessage('folder_created'.tr);
    } catch (e) {
      MixPanelService.trackEvent(event: MixPanelAddEvent.createDirectoryFailure);
      Helper.handleError(e);
    } finally {
      Get.back();
    }
  }

  // onSelectMoveToDir() will be in use when listing is opened in selection mode
  // it will select a directory with 0 folders and opens up directory with more than 0 folders
  void onSelectMoveToDir(int index) {
    if (lastSelectedDir == index) {
      resourceList[lastSelectedDir!].isSelected = false;
      lastSelectedDir = null;
      update();
      return;
    }

    if (lastSelectedDir != null) {
      resourceList[lastSelectedDir!].isSelected = false;
    }

    if ((resourceList[index].noOfChildDir ?? 0) > 0) {
      lastSelectedDir = null;
      openDirectory(index);
    } else {
      resourceList[index].isSelected = true;
      lastSelectedDir = index;
    }
    update();
  }

  int getSelectedDirID() => lastSelectedDir == null
      ? resourceList.isEmpty ? -1 : resourceList[0].parentId!
      : int.parse(resourceList[lastSelectedDir!].id!);

  void onTapMore(int index) {
    if (!isInSelectionMode) {
      // The tooltip is handled in the UI layer (files_grid_view.dart and files_list_tile.dart)
      // This prevents users from attempting to modify locked directories
      if (isResourceLocked(resourceList[index])) return;
      showQuickAction(index: index);
    } else {
      onTapResource(index);
    }
  }

  // A resource is considered locked if it's a directory (isDir == 1) AND
  // either has locked=1 OR isRestricted=true
  // This centralizes the lock checking logic for reuse across multiple methods
  bool isResourceLocked(FilesListingModel data) => data.isDir == 1 && (data.locked == 1 || data.isRestricted);

  // Will differentiate api call as per search parameter and module type
  Future<dynamic> typeToApi(FileListingTypeToApiParams params) async {
    if (isInCopyFileMode! && (type == FLModule.companyFiles
        || type == FLModule.companyCamProjectImages
        || type == FLModule.instantPhotoGallery || type == FLModule.companyCamImagesFromJob)) {
      return await jobPhotoListingApiCall();
    }

    switch (type) {
      case FLModule.companyFiles:
        return await companyFilesApiCall(params.search, typeToApiParams: params);

      case FLModule.templates:
        return await formProposalTemplateListingApiCall(params.search);

      case FLModule.templatesListing:
        return await formTemplateListingApiCall(params.search);

      case FLModule.mergeTemplate:
        return await mergeTemplateListingApiasCall(params.search);

      case FLModule.googleSheetTemplate:
        return await estimatesGoogleSpreadsheetTemplateListingApiCall(params.search);

      case FLModule.estimate:
        return await estimatesApiCall(typeToApiParams: params);

      case FLModule.jobPhotos:
        return await jobPhotoListingApiCall(typeToApiParams: params);

      case FLModule.jobProposal:
        return await jobProposalApiCall(typeToApiParams: params);

      case FLModule.measurements:
        return await measurementsApiCall(typeToApiParams: params);

      case FLModule.materialLists:
        return await materialListsApiCall(typeToApiParams: params);

      case FLModule.workOrder:
        return await workOrdersApiCall(typeToApiParams: params);

      case FLModule.stageResources:
        return await stageResourcesApiCall(typeToApiParams: params);

      case FLModule.userDocuments:
        return await userDocumentsApiCall(params.search);

      case FLModule.customerFiles:
        return await customerFilesApiCall(params.search, typeToApiParams: params);

      case FLModule.instantPhotoGallery:
        return await instantPhotoGalleryApiCall(typeToApiParams: params);

      case FLModule.dropBoxListing:
        return await dropBoxApiCall();
      case FLModule.companyCamProjects:
        return await companyCamApiCall(params.search);

      case FLModule.companyCamProjectImages:
        return await companyCamApiImagesCall(index: params.index);
      
      case FLModule.companyCamImagesFromJob:
        return await companyCamApiImagesCall(id: projectId);

      case FLModule.financialInvoice:
      case FLModule.attachmentInvoice:
        return await financialInvoiceApiCall();
      case FLModule.favouriteListing:
        return await favouriteListingApiCall();
      case FLModule.paymentReceipt:
        return await paymentReceiveApiCall();

      case FLModule.jobContracts:
        return await jobContractsApiCall();

      default:
        break;
    }
  }

  void setInstantPhotoGalleryFilterKeys(
      InstantPhotoGalleryFilterModel? params) {
    filterKeys = InstantPhotoGalleryFilterModel();

    switch (instantPhotoGallerySelectedFilterByOptions) {
      case 'today':
        String today = DateTime.now().toString();
        filterKeys.date = DateTimeHelper.formatDate(today, DateFormatConstants.dateServerFormat);
        break;

      case 'yesterday':
        String yesterday = DateTime.now().subtract(const Duration(days: 1)).toString();
        filterKeys.date = DateTimeHelper.formatDate(yesterday, DateFormatConstants.dateServerFormat);
        break;
      case 'this_week':
        filterKeys.startDate = Jiffy.now().add(weeks: 0).startOf(Unit.week).format(pattern: DateFormatConstants.dateServerFormat);
        filterKeys.endDate = Jiffy.now().add(weeks: 0).endOf(Unit.week).format(pattern: DateFormatConstants.dateServerFormat);
        break;

      case 'last_week':
        filterKeys.startDate = Jiffy.now().add(weeks: -1).startOf(Unit.week).format(pattern: DateFormatConstants.dateServerFormat);
        filterKeys.endDate = Jiffy.now().add(weeks: -1).endOf(Unit.week).format(pattern: DateFormatConstants.dateServerFormat);
        break;

      case 'this_month':
        filterKeys.startDate = Jiffy.now().add(months: 0).startOf(Unit.month).format(pattern: DateFormatConstants.dateServerFormat);
        filterKeys.endDate = Jiffy.now().add(months: 0).endOf(Unit.month).format(pattern: DateFormatConstants.dateServerFormat);
        break;

      case 'custom':
        if (params != null) {
          filterKeys.startDate = params.startDate;
          filterKeys.endDate = params.endDate;
        }
        break;
    }
  }

  void instantPhotoGalleryFilterby(InstantPhotoGalleryFilterModel? params) {
    setInstantPhotoGalleryFilterKeys(params);
    isLoading = true;
    update();
    fetchResources();
  }

  void instantPhotoGalleryFilterbyUsers() {
    isLoading = true;
    fileListingRequestParam?.page = 1;
    update();
    fetchResources();
  }

  void onBackofCustomDateDialog() {
    instantPhotoGallerySelectedFilterByOptions = previousSelectedOption;
    fetchResources();
  }

  void openInstantPhotoGalleryFilterBy() {
    SingleSelectHelper.openSingleSelect(instantPhotoGallerySortByList,
        instantPhotoGallerySelectedFilterByOptions, 'sort_by'.tr, (value) {
          if (value == 'custom') {
            previousSelectedOption = instantPhotoGallerySelectedFilterByOptions;
          }
          instantPhotoGallerySelectedFilterByOptions = value;
          Get.back();
          if (instantPhotoGallerySelectedFilterByOptions == 'custom') {
            openInstantPhotoGalleryCustomFilters();
          } else {
            instantPhotoGalleryFilterby(null);
          }
        }, isFilterSheet: true);
  }

  void openInstantPhotoGalleryCustomFilters() {
    showJPGeneralDialog(
      child: (_) => CustomDateDialog(
          onBack: () => onBackofCustomDateDialog(),
          selectedFilters: filterKeys,
          onApply: (InstantPhotoGalleryFilterModel params) {
            instantPhotoGalleryFilterby(params);
          }),
    );
  }

  Future<dynamic> instantPhotoGalleryApiCall({FileListingTypeToApiParams? typeToApiParams}) async {
    Map<String, dynamic> params = {
      ...FilesListingRequestParam.getInstantPhotoGalleryParams(),
      ...fileListingRequestParam!.toJson(),
      ...filterKeys.toJson(),
      ...?typeToApiParams?.toOnlyImages(),
    };

    for (int i = 0; i < selectedUsers.length; i++) {
      params['user_ids[$i]'] = selectedUsers[i];
    }

    return await InstantPhotoGalleryRepository.fetchFiles(params);
  }

  Future<dynamic> dropBoxApiCall() async {
    Map<String, dynamic> params = {
      ...fileListingRequestParam!.toJson(),
      ...filterKeys.toJson(),
    };
    return await DropBoxRepository.fetchFiles(params);
  }

  Future<dynamic> companyCamApiCall(bool search) async {
    Map<String, dynamic> params = {
      ...fileListingRequestParam!.toJson(),
    };
    return await CompanyCamListingRepository.fetchFiles(params);
  }

  Future<dynamic> companyCamApiImagesCall({int? index , String? id}) async {

    Map<String, dynamic> params = {
      ...FilesListingRequestParam.getCompanyCamImagesParams(id ?? (projectIdParam ?? resourceList[index ?? 0].id)),
      ...(fileListingRequestParam != null ? fileListingRequestParam!.toJson() : {}),
    };
    return await CompanyCamListingRepository.fetchImages(params);
  }

  Future<dynamic> companyFilesApiCall(bool search, {FileListingTypeToApiParams? typeToApiParams}) async {
    switch (search) {
      case true:
        Map<String, dynamic> param = {
          ...FilesListingRequestParam.getCompanyFilesSearchParams(rootId),
          ...fileListingRequestParam!.toJson(),
          ...?typeToApiParams?.toOnlyImages(),
        };
        return await CompanyFilesRepository.recursiveSearch(param);
      case false:
        Map<String, dynamic> param = {
          ...FilesListingRequestParam.getCompanyFilesParams(isInMoveFileMode! || isInCopyFileMode!),
          ...fileListingRequestParam!.toJson(),
          ...?typeToApiParams?.toOnlyImages(),
        };     
        return await CompanyFilesRepository.fetchFiles(param);
    }
  }

  Future<dynamic> formProposalTemplateListingApiCall (bool search) async {
    switch (search) {
      case true:
        Map<String, dynamic> param = {
          ...FilesListingRequestParam.getFormProposalTemplateListingSearchParams(fileListingRequestParam!.query),
          ...fileListingRequestParam!.templateListingtoJson(),
        };
        return await ProposalTemplateRepository.searchTemplateListingFile(param);
      case false:
        Map<String, dynamic> param = {
          ...FilesListingRequestParam.getFormProposalTemplateListingParams(selectedFilterByOptions),
          ...fileListingRequestParam!.templateListingtoJson(),
        };
       
        return await ProposalTemplateRepository.fetchFiles(param);
    }
  }

  Future<dynamic> formTemplateListingApiCall (bool search) async {
    switch (search) {
      case true:
        Map<String, dynamic> param = {
          ...FilesListingRequestParam.getTemplateListingSearchParams(fileListingRequestParam!.query),
          ...fileListingRequestParam!.templateListingtoJson(templateType: templateListType),
        };
        return await ProposalTemplateRepository.searchTemplateListingFile(param);
      case false:
        Map<String, dynamic> param = {
          ...FilesListingRequestParam.getTemplateListingParams(selectedFilterByOptions),
          ...fileListingRequestParam!.templateListingtoJson(templateType: templateListType),
        };

        return await ProposalTemplateRepository.fetchFiles(param);
    }
  }

  Future<dynamic> estimatesGoogleSpreadsheetTemplateListingApiCall (bool search) async {
    switch (search) {
      case true:
        Map<String, dynamic> param = {
          ...FilesListingRequestParam.getGoogleSheetTemplateListingSearchParams(fileListingRequestParam!.query,parentModule!),
          ...fileListingRequestParam!.googlesheetTemplateListingtoJson(parentModule!),
        };
        return await ProposalTemplateRepository.searchTemplateListingFile(param);
      case false:
        Map<String, dynamic> param = {
          ...FilesListingRequestParam.getGoogleSheetTemplateListingParams(selectedFilterByOptions,parentModule!),
          ...fileListingRequestParam!.googlesheetTemplateListingtoJson(parentModule!),
        };
        return await ProposalTemplateRepository.fetchFiles(param);
    }
    
  }

  // ---
  Future<dynamic> mergeTemplateListingApiasCall (bool search) async {
    switch (search) {
      case true:
        Map<String, dynamic> param = {
          ...FilesListingRequestParam.getMergeTemplateListingSearchParams(fileListingRequestParam!.query),
          ...fileListingRequestParam!.templateListingtoJson(),
        };
        return await ProposalTemplateRepository.searchTemplateListingFile(param);
      case false:
        Map<String, dynamic> param = {
          ...FilesListingRequestParam.getMergeTemplateListingParams(proposalPageType),
          ...fileListingRequestParam!.templateListingtoJson(),
        };
       
        return await ProposalTemplateRepository.fetchFiles(param, includeMergeTemplates: !isLoadMore);
    }
  }

  Future<dynamic> estimatesApiCall({FileListingTypeToApiParams? typeToApiParams}) async {
    if (jobId == null) return;

    Map<String, dynamic> params = {
      ...FilesListingRequestParam.getJobEstimateParams(
          isInMoveFileMode! || isInCopyFileMode!, jobId!),
      ...fileListingRequestParam!.toJson(),
      ...?typeToApiParams?.toOnlyImages(),
    };
    
    // If only images are requested (pagination), don't fetch job details
    if (Helper.isTrue(typeToApiParams?.onlyImages)) {
      return await EstimatesRepository.fetchFiles(params);
    }
    
    List<Map<String, dynamic>> response;
    response = (await Future.wait([EstimatesRepository.fetchFiles(params),
      JobRepository.fetchJob(jobId!, loadJobWithCounts: true)
    ]));
    jobModel = response[1]['job'];
    return response[0];
  }

  Future<dynamic> jobContractsApiCall() async {
    if (jobId == null) return;

    Map<String, dynamic> params = {
      ...FilesListingRequestParam.getJobContractParams(jobId!),
      ...fileListingRequestParam!.toJson(),
    };
    List<Map<String, dynamic>> response;
    response = (await Future.wait([JobContractsRepository.fetchFiles(params),
      JobRepository.fetchJob(jobId!, loadJobWithCounts: true)
    ]));
    jobModel = response[1]['job'];
    return response[0];
  }

  Future<dynamic> financialInvoiceApiCall() async {
    if (jobId == null) return;

    Map<String, dynamic> params = {
      'id': jobId.toString(),
      ...FilesListingRequestParam.getFinancialInvoiceParams(),
      ...filterKeys.toJson(),
    };

    Map<String, dynamic> creditParams = {
      'customer_id': customerId,
      'job_id': jobId,
      'limit': 0,
      'unapplied_only': 1
    };

    List<Map<String, dynamic>> response;
    if (jobModel == null) {
      response = (await Future.wait([JobFinancialRepository.fetchFiles(params),
      JobRepository.fetchJob(jobId!, loadJobWithCounts: true),
      ]));
      jobModel = response[1]['job'];
    } else {
      response = (await Future.wait([JobFinancialRepository.fetchFiles(params),
      ]));
    }
    financialUnAppliedCreditList = await JobFinancialRepository.fetchCreditList(creditParams);

    List<FilesListingModel> unsavedResources = (await FormsDBHelper.getMultipleTypesOfUnsavedResources<FilesListingModel>(types: [UnsavedResourceType.invoice], jobId: jobId!));
    (response[0]["list"]).insertAll(0, unsavedResources);
    return response[0];
  }

  Future<dynamic> paymentReceiveApiCall() async {
    if (jobId == null) return;

    Map<String, dynamic> params = {
      'id': jobId.toString(),
      ...FilesListingRequestParam.getPaymentReceiveParams(),
    };

    List<Map<String, dynamic>> response;
    
    if (jobModel == null) {
      response = (await Future.wait([
        JobFinancialRepository.fetchPaymentReceiveForFileListing(params),
        JobRepository.fetchJob(jobId!, loadJobWithCounts: true),
      ]));
      jobModel = response[1]['job'];
    } else {
      response = (await Future.wait([JobFinancialRepository.fetchFiles(params),]));
    }

    List<FilesListingModel> unsavedResources = (
      await FormsDBHelper.getAllUnsavedResources(
      type: UnsavedResourceType.invoice, jobId: jobId!)) as List<FilesListingModel>;
    
    (response[0]["list"] as List<FilesListingModel>).insertAll(0, unsavedResources);
    
    return response[0];
  }

  Future<dynamic> jobPhotoListingApiCall({FileListingTypeToApiParams? typeToApiParams}) async {
    Map<String, dynamic> param = {
      ...FilesListingRequestParam.getJobPhotosParams(isInMoveFileMode! || isInCopyFileMode!),
      ...fileListingRequestParam!.toJson(),
      ...?typeToApiParams?.toOnlyImages()
    };
    List<Map<String, dynamic>> response;
    bool doLoadJob = !Helper.isTrue(typeToApiParams?.onlyImages);

    response = (await Future.wait([
      JobPhotosRepository.fetchFiles(param),
      // No need to load job if only images are to be fetched
      if (doLoadJob) ...{
        JobRepository.fetchJob(jobId!, loadJobWithCounts: true)
      },
    ]));

    if (doLoadJob) jobModel = response[1]['job'];

    return response[0];
  }

  Future<dynamic> jobProposalApiCall({FileListingTypeToApiParams? typeToApiParams}) async {
    if (jobId == null) return;

    Map<String, dynamic> params = {
      ...FilesListingRequestParam.getJobProposalParams(isInMoveFileMode! || isInCopyFileMode!, jobId!),
      ...fileListingRequestParam!.toJson(),
      ...?typeToApiParams?.toOnlyImages(),
    };
    
    // If only images are requested (pagination), don't fetch job details
    if (Helper.isTrue(typeToApiParams?.onlyImages)) {
      return await JobProposalRepository.fetchFiles(params);
    }
    
    List<Map<String, dynamic>> response;
    response = (await Future.wait([JobProposalRepository.fetchFiles(params),
      JobRepository.fetchJob(jobId!, loadJobWithCounts: true)
    ]));
    jobModel = response[1]['job'];

    return response[0];
  }

  Future<dynamic> measurementsApiCall({FileListingTypeToApiParams? typeToApiParams}) async {
    if (jobId == null) return;

    Map<String, dynamic> params = {
      ...FilesListingRequestParam.getMeasurementsParams(isInMoveFileMode! || isInCopyFileMode!, jobId!),
      ...fileListingRequestParam!.toJson(),
      ...?typeToApiParams?.toOnlyImages(),
    };
    
    // If only images are requested (pagination), don't fetch job details
    if (Helper.isTrue(typeToApiParams?.onlyImages)) {
      return await MeasurementsRepository.fetchFiles(params);
    }
    
    List<Map<String, dynamic>> response;
    response = (await Future.wait([
      MeasurementsRepository.fetchFiles(params),
      JobRepository.fetchJob(jobId!, loadJobWithCounts: true),
      SubscriberDetailsRepo.getDetails(),
    ]));
    jobModel = response[1]['job'];
    subscriberDetails = response[2]['details'];

    return response[0];
  }

  Future<dynamic> favouriteListingApiCall() async {
    Map<String, dynamic> params = {
      ...FilesListingRequestParam.getFavouriteListingParams(favouritefilterkey,
          additionalParams: additionalParams
      ),
      ...fileListingRequestParam!.toJson(),
    };

    List<Map<String, dynamic>> response = (await Future.wait([
      FavouriteListingRepository.fetchFavouriteListing(params),
    ]));

    return response[0];
  }

  Future<dynamic> materialListsApiCall({FileListingTypeToApiParams? typeToApiParams}) async {
    if (jobId == null) return;

    Map<String, dynamic> params = {
      ...FilesListingRequestParam.getMaterialListParams(isInMoveFileMode!, jobId!),
      ...fileListingRequestParam!.toJson(),
      ...?typeToApiParams?.toOnlyImages(),
    };
    
    // If only images are requested (pagination), don't fetch job details
    if (Helper.isTrue(typeToApiParams?.onlyImages)) {
      return await MaterialListsRepository.fetchFiles(params);
    }
    
    List<Map<String, dynamic>> response;
    response = (await Future.wait([
      MaterialListsRepository.fetchFiles(params),
      JobRepository.fetchJob(jobId!, loadJobWithCounts: true)
    ]));
    jobModel = response[1]['job'];
    return response[0];
  }

  Future<dynamic> workOrdersApiCall({FileListingTypeToApiParams? typeToApiParams}) async {
    if (jobId == null) return;

    Map<String, dynamic> params = {
      ...FilesListingRequestParam.getWorkOrderParams(isInMoveFileMode!, jobId!),
      ...fileListingRequestParam!.toJson(),
      ...?typeToApiParams?.toOnlyImages(),
    };
    
    // If only images are requested (pagination), don't fetch job details
    if (Helper.isTrue(typeToApiParams?.onlyImages)) {
      return await WorkOrderRepository.fetchFiles(params);
    }
    
    List<Map<String, dynamic>> response;
    response = (await Future.wait([
      WorkOrderRepository.fetchFiles(params),
      JobRepository.fetchJob(jobId!, loadJobWithCounts: true)
    ]));
    jobModel = response[1]['job'];

    return response[0];
  }

  Future<dynamic> stageResourcesApiCall({FileListingTypeToApiParams? typeToApiParams}) async {
    Map<String, dynamic> param = {
      ...FilesListingRequestParam.getStageResourceParams(isInMoveFileMode!),
      ...fileListingRequestParam!.toJson(),
      ...?typeToApiParams?.toOnlyImages(),
    };
    return await StageResourcesRepository.fetchFiles(param);
  }

  Future<dynamic> userDocumentsApiCall(bool search) async {
    switch (search) {
      case true:
        Map<String, dynamic> param = {
          ...FilesListingRequestParam.getUserDocumentsSearchParam(rootId),
          ...fileListingRequestParam!.toJson(),
        };
        return await UserDocumentsRepository.recursiveSearch(param);
      case false:
        Map<String, dynamic> param = {
          ...FilesListingRequestParam.getUserDocumentsParams(isInMoveFileMode!),
          ...fileListingRequestParam!.toJson(),
        };
        return await UserDocumentsRepository.fetchFiles(param);
    }
  }

  Future<dynamic> customerFilesApiCall(bool search, {FileListingTypeToApiParams? typeToApiParams}) async {
    switch (search) {
      case true:
        Map<String, dynamic> param = {
          ...FilesListingRequestParam.getUserDocumentsSearchParam(rootId),
          ...fileListingRequestParam!.toJson(),
          ...?typeToApiParams?.toOnlyImages(),
        };
        return await CustomerFilesRepository.recursiveSearch(param);
      case false:
        Map<String, dynamic> param = {
          ...FilesListingRequestParam.getUserDocumentsParams(isInMoveFileMode!),
          ...fileListingRequestParam!.toJson(),
          ...?typeToApiParams?.toOnlyImages(),
        };
        return await CustomerFilesRepository.fetchFiles(param);
    }
  }

  void toggleIsMovingFile() {
    isMovingFile = !isMovingFile;
    update();
  }

  // goToPhotoViewer() will fetches only images from displayed documents and
  // send them to PhotoViewer()
  void goToPhotoViewer(int index) async {
    DrawingToolService.fileList = [];
    List<FilesListingModel> tempList = resourceList.where((element) => element.jpThumbType == JPThumbType.image).toList();
    List<PhotoDetails> imageList = [];

    for (FilesListingModel file in tempList) {
      imageList.add(file.toPhotoDetailModel(type));
    }

    int scrollToIndex = 0;

    scrollToIndex = tempList.indexWhere((element) => element.id == resourceList[index].id);

    final data = PhotoViewerModel<FilesListingController>(scrollToIndex, imageList, controller: this);

    dynamic result = await showJPGeneralDialog(child: (_) => PhotosViewerDialog<FilesListingController>(data: data, type: type, jobId: jobModel?.id), allowFullWidth: true);

    if(!Helper.isValueNullOrEmpty(result)) {

      if(Helper.isTrue(result['save_as'])){
        onRefresh(showLoading: true);
      } else {
        for(FilesListingModel file in result['file']){
          int position = resourceList.indexWhere((element) => element.id == file.id);
          // In case editing a file from the photo viewer that is not present in the list as of now
          // it should not be updated in the list.
          if (position > 0) {
            resourceList[position] = file;
            update();
          }
        }
      }
      
    }
  }

  bool showQuickActionsOrMultiSelectOnLongPress(int index) {
    switch (type) {
      case FLModule.companyFiles:
        return resourceList[index].isDir == 1 && !isInSelectionMode;
      case FLModule.mergeTemplate:
        return resourceList[index].isDir == 1 && !isInSelectionMode;
      case FLModule.templates:
        return resourceList[index].isDir == 1 && !isInSelectionMode;
      case FLModule.googleSheetTemplate:
        return resourceList[index].isDir == 1 && !isInSelectionMode;  
      case FLModule.stageResources:
        return resourceList[index].isDir == 1 && !isInSelectionMode;
      case FLModule.jobPhotos:
        return resourceList[index].isDir == 1 && !isInSelectionMode;
      case FLModule.instantPhotoGallery:
        return resourceList[index].isDir == 1 && !isInSelectionMode;
      case FLModule.companyCamProjectImages:
        return resourceList[index].isDir == 1 && !isInSelectionMode;
      case FLModule.dropBoxListing:
        return resourceList[index].isDir == 1 && !isInSelectionMode;
      case FLModule.templatesListing:
        return false;
      default:
        return true;
    }
  }

  bool doShowQuickAction(FilesListingModel file) {
    switch (type) {  
      case FLModule.measurements:
        return MeasurementHelper.doShowMeasurementQuickAction(file);
      case FLModule.jobPhotos:
        return !((file.isDir == 1) && !PermissionService.hasUserPermissions([PermissionConstants.manageJobDirectory]));
      case FLModule.companyFiles:
        return !((file.isDir == 1) && !PermissionService.hasUserPermissions([PermissionConstants.manageCompanyFiles]));
      case FLModule.templatesListing:
      case FLModule.companyCamImagesFromJob:
      case FLModule.companyCamProjectImages:
        return false;
        default:
        return true;
    }   
  }

  // typeToCreateDirectoryApi will differentiate api calls for creating directory
  Future<dynamic> typeToCreateDirectoryApi(String dirName) async {
    final parentId = (folderPath[folderPath.length - 1].id);

    Map<String, dynamic> params = {
      if (jobId != null) 'job_id': jobId,
      if (parentId != '-1') 'parent_id': parentId,
      'name': dirName.trim(),
    };

    switch (type) {
      case FLModule.estimate:
        return await EstimatesRepository.createDirectory(params);
      case FLModule.companyFiles:
        return await CompanyFilesRepository.createDirectory(params);
      case FLModule.jobPhotos:
        return await JobPhotosRepository.createDirectory(params);
      case FLModule.jobProposal:
        return await JobProposalRepository.createDirectory(params);
      case FLModule.measurements:
        return await MeasurementsRepository.createDirectory(params);
      case FLModule.materialLists:
        return await MaterialListsRepository.createDirectory(params);
      case FLModule.workOrder:
        return await WorkOrderRepository.createDirectory(params);
      case FLModule.userDocuments:
        return await UserDocumentsRepository.createDirectory(params);
      case FLModule.customerFiles:
        return await CustomerFilesRepository.createDirectory(params);
      default:
        return;
    }
  }

  bool doShowCreateFolder() {
    switch (type) {
      case FLModule.companyFiles:
        return PermissionService.hasUserPermissions([PermissionConstants.manageCompanyFiles]); 
      case FLModule.stageResources:
      case FLModule.templates:
      case FLModule.templatesListing:
      case FLModule.googleSheetTemplate:
      case FLModule.mergeTemplate:
      case FLModule.instantPhotoGallery:
      case FLModule.dropBoxListing:
      case FLModule.financialInvoice:
      case FLModule.companyCamProjects:
      case FLModule.companyCamProjectImages:
      case FLModule.paymentReceipt:  
        return false;
      default:
        return doSupportFolderStructure;
    }
  }

  // showStageResourceFilters() will show bottom sheet to select filters from when
  // type is equal to [FLModule.stageResources]
  void showStageResourceFilters() {
    showJPBottomSheet(
      child: (_) => JPSingleSelect(
        mainList: stageResourcesFilter,
        inputHintText: 'search_filter_here'.tr,
        selectedItemId: fileListingRequestParam?.parentId.toString(),
        title: 'select_filter'.tr,
        onItemSelect: (resourceId) {
          Get.back();
          onSelectingStageResourceFilter(resourceId);
        },
      ),
      isScrollControlled: true,
    );
  }

  // onSelectingStageResourceFilter() :- This function will filter list and switch to stage resource view
  // Parameters :- resourceId[required]
  // resourceId :- It is the id of the selected stage which will be chosen from showStageResourceFilters()
  void onSelectingStageResourceFilter(String resourceId) {
    isLoading = true;
    isInSelectionMode = mode == FLViewMode.attach ||  mode == FLViewMode.apply;
    selectedFileCount = 0;
    fileListingRequestParam?.parentId = int.parse(resourceId);
    setCurrentStageGoalDescription(resourceId);
    toggleIsGoalSelected(false);
    update();
    fetchResources();
  }

  void toggleIsGoalSelected(bool isGoal) {
    if (isGoal) {
      selectedFileCount = 0;
      isInSelectionMode = false;
      for (var resource in resourceList) {
        resource.isSelected = false;
      }
    }
    isGoalSelected = isGoal;
    update();
  }

  void setCurrentStageGoalDescription(String resourceId) async {
    if(Helper.isValueNullOrEmpty(stages)){
      final stage = stages.firstWhere((stage) => stage.resourceId.toString() == resourceId);
      selectedStageCode = stage.name;
      currentGoal = stage.workStageOptions?.description;
    }
  }

  void handleBreadCrumbOverFlow() {
    collapseAt--;
    folderPath.last.collapseAt = collapseAt;
    update();
  }

  bool doShowSecondaryHeader() {
    if (isInMoveFileMode! || mode == FLViewMode.attach ||mode == FLViewMode.apply || isInCopyFileMode!) {
      return false;
    }

    switch (type) {
      case FLModule.companyFiles:
      case FLModule.stageResources:
      case FLModule.instantPhotoGallery:
      case FLModule.dropBoxListing:
      case FLModule.customerFiles:
      case FLModule.companyCamProjects:
      case FLModule.companyCamProjectImages:
      case FLModule.companyCamImagesFromJob:
        return false;
      case FLModule.templates:
      case FLModule.templatesListing:
        return false;
      case FLModule.googleSheetTemplate:
        return false;  
      case FLModule.mergeTemplate:
        return false;
      default:
        return true;
    }
  }

  bool get doShowDrawer {
    switch (type) {
      case FLModule.companyCamImagesFromJob:
        return false;
      default:
        return true;
    }
  }

  void uploadFile(
      {UploadFileFrom from = UploadFileFrom.popup, List<String>? filePaths, int? selectedFolderId}) {
      final int parentId;
      if(selectedFolderId == null){
        parentId = int.tryParse(folderPath.last.id) ?? -1;
      }
      else{
        parentId = selectedFolderId;
      }

    final params = FileUploaderParams(
      type: FilesListingService.moduleTypeToUploadType(type),
      job: jobModel,
      parentId: parentId == -1 ? null : parentId,
    );

    if (filePaths != null) {
      UploadService.parseParamsAndAddToQueue(filePaths, params);
    } else {
      UploadService.uploadFrom(from: from, params: params);
    }
  }

  Future<bool> showUpgradePlanDialogTypeBase(FLModule type) async {
    switch (type) {
      case FLModule.measurements:
      case FLModule.estimate:
      case FLModule.jobProposal:
        return await UpgradePlanHelper.showUpgradePlanOnDocumentLimit();
      default:
        return false;
    }
  }

  

  void openAddMoreQuickAction({UploadFileFrom from = UploadFileFrom.popup, List<String>? filePaths}) async{
      bool showUpgradeDialog = await showUpgradePlanDialogTypeBase(type);
      if(showUpgradeDialog){
        return;
      }
      FilesListingMoreActionsService.openMoreAction(CreateFileActions(
      type: type,
      jobModel: jobModel,
      subscriberDetails: subscriberDetails,
      fileList: [],
      onActionComplete: (FilesListingModel model, action) {
        switch (action) {
          case "FLQuickActions.upload":
            uploadFile();
            break;
          case "FLQuickActions.hover":
            navigateToHoverForm();
            break;
          case "FLQuickActions.measurementForm":
          case "FLQuickActions.createInsurance":
          case "FLQuickActions.uploadInsurance":
          case "FLQuickActions.uploadExcel":
          case "FLQuickActions.spreadSheetTemplate":
          case "FLQuickActions.newSpreadsheet":
          case "FLQuickActions.dropBox":
          case "FLQuickActions.handwrittenTemplate":
          case "FLQuickActions.worksheet":
          case "FLQuickActions.jobFormProposalMerge":
          case "FLQuickActions.jobFormProposalTemplate":
            onRefresh(showLoading: true);
            break;
        }
      }));
  }

  void handleChangeJob(int id) {
    jobId = id;
    jobModel = null;
    fileListingRequestParam = null;
    folderPath = [];
    onRefresh(showLoading: true);
  }

  @override
  void dispose() {
    cancelOnGoingRequest();
    super.dispose();
  }

  void cancelOnGoingRequest() => Helper.cancelApiRequest();

  bool isNotInDefaultMode() => isInMoveFileMode! || mode == FLViewMode.attach ||mode == FLViewMode.apply || isInCopyFileMode!;

  bool isFolderDisabled(FilesListingModel data) {
    if (mode == FLViewMode.attach || mode == FLViewMode.apply) {
      return false;
    } else {
      return isInSelectionMode && !data.isSelected! && data.isDir == 1;
    }
  }

  List<FilesListingModel> getSelectedFiles() => resourceList.where((element) => element.isSelected ?? false).toList();

  void showResetSelectionDialog({bool isOpeningFolder = false}) {
    FileAttachmentQuickActionDialogs.resetSelectionDialog(
        isOpeningFolder: isOpeningFolder,
        onTapSuffix: () {
          resetAllSelections();
          Get.back();
        });
  }

  void resetAllSelections() {
    for (var resource in resourceList) {
      resource.isSelected = false;
    }
    selectedFileCount = 0;
    isInSelectionMode = mode == FLViewMode.attach || mode == FLViewMode.apply;
    selectedPageType = null;
    update();
  }

  String? getUserNameInInstantGalleryFilter(
      List<FilesListingModel> data, int index) {
    if (type == FLModule.instantPhotoGallery) {
      if (data[index].createdByDetails != null || data[index].createdBy != null ) {
        if (loggedInUser!.id.toString() == data[index].createdByDetails?.id.toString()) {
          return 'Me';
        } else {
          return data[index].createdByDetails!.name;
        }
      }
    }
    return null;
  }

  void filterInstantPhotoGalleryByUser() {
    mainList.clear();

    if (userList.isNotEmpty) {
      for (int i = 0; i < userList.length; i++) {
        List<TagLimitedModel> tag = [];
        if (userList[i].tags != null) {
          for (int j = 0; j < userList[i].tags!.length; j++) {
            tag.add(TagLimitedModel(
                id: userList[i].tags![j].id, name: userList[i].tags![j].name));
          }
        }
        mainList.add(JPMultiSelectModel(
            child: JPProfileImage(
              src: userList[i].profilePic,
              color: userList[i].color,
              initial: userList[i].intial,
            ),
            id: userList[i].id.toString(),
            tags: tag,
            label: userList[i].groupId == UserGroupIdConstants.subContractorPrime
                ? '${userList[i].fullName} (${'sub'.tr})'
                : userList[i].fullName,
            isSelect: false));

        for (int j = 0; j < selectedUsers.length; j++) {
          if (userList[i].id.toString() == selectedUsers[j]) {
            mainList[i].isSelect = true;
            break;
          }
        }
        tag = [];
      }
    } else {
      for (var user in userList) {
        List<TagLimitedModel> tag = [];
        if (user.tags != null) {
          for (var e in user.tags!) {
            tag.add(TagLimitedModel(id: e.id, name: e.name));
          }
        }
        mainList.add(JPMultiSelectModel(
            child: JPProfileImage(
              src: user.profilePic,
              color: user.color,
              initial: user.intial,
            ),
            id: user.id.toString(),
            label: user.fullName,
            tags: tag,
            isSelect: false));
        tag = [];
      }
    }

    showJPBottomSheet(
      child: (JPBottomSheetController controller) {
        return JPMultiSelect(
          mainList: mainList,
          inputHintText: 'search_user'.tr,
          title: 'select_users'.tr,
          subList: tagsList,
          canShowSubList: tagsList.isNotEmpty ? true : false,
          onDone: ((value) {
            for (var list in value) {
              if (list.isSelect && !selectedUsers.contains(list.id)) {
                selectedUsers.add(list.id);
              }
              if (!list.isSelect && selectedUsers.contains(list.id)) {
                selectedUsers.remove(list.id);
              }
            }
            Get.back();
            instantPhotoGalleryFilterbyUsers();
          }),
        );
      },
      isScrollControlled: true,
    );
  }

  void openCumulativeInvoiceActions() {
    FilesListingService.openQuickAction(
      FilesListingQuickActionParams(
        type: FLModule.cumulativeInvoices,
        fileList: [],
        jobModel: jobModel,
        onActionComplete: (FilesListingModel model, action) async {
          switch (action) {
            default:
              break;
          }
        },
      ),
    );
  }

  String getPlaceHolderText() {
    switch (type) {
      case FLModule.instantPhotoGallery:
        return 'no_photo_found'.tr.capitalize!;
      default:
        return doSupportFolderStructure ? 'no_file_folder_found'.tr.capitalize! : 'no_file_found'.tr.capitalize!;
    }
  }

  Future<void> navigateToHoverForm() async {
    final result = await Get.toNamed(Routes.hoverOrderForm, arguments: {
      NavigationParams.params : HoverOrderFormParams(
          customer: jobModel?.customer,
          jobId: jobId,
          hoverUser: jobModel?.hoverJob?.hoverUser
      )
    });

    if(result != null) {
      jobModel = null;
      onRefresh(showLoading: true);
    }
  }

  

  void openFilters() {
    showJPBottomSheet(
      child: (_) => JPSingleSelect(
        mainList: filterByList,
        selectedItemId: selectedFilterByOptions?.isEmpty ?? true ? "all" : selectedFilterByOptions,
        title: 'select_trade'.tr.toUpperCase(),
        isFilterSheet: true,
        onItemSelect: (value) {
          Get.back();
          onSelectingFilter(value);
        },
      ),
      enableDrag: false,
      isScrollControlled: true,
    );
  }

  void openModuleNameFilters() {
    showJPBottomSheet(
      child: (_) => JPSingleSelect(
        mainList: DropdownListConstants.templateTypeList,
        selectedItemId: templateListType,
        title: 'select_template_type'.tr.toUpperCase(),
        isFilterSheet: true,
        onItemSelect: (value) {
          templateListType = value;
          Get.back();
          fileListingRequestParam?.page = 1;
          fileListingRequestParam?.nextPageToken = null;
          fileListingRequestParam?.query = '';
          update();
          onTapBreadCrumbItem(0, isUpdateTemplateType: true);
        },
      ),
      enableDrag: false,
      isScrollControlled: true,
    );
  }

  void onSelectingFilter(String value) {
    fileListingRequestParam?.keyword = '';
    fileListingRequestParam?.page = 1;
    if(value == 'all'){
      selectedFilterByOptions = '';
      isLoading = true;
      fetchResources();
      update();
    }else{
      selectedFilterByOptions = value;
      isLoading = true;      
      fetchResources();
      // fetchData();
      update();
    } 
  }

  Future<void> fetchCompanyTrades() async {
    if (Get.testMode) return;
    try {
      List<JPSingleSelectModel> response = await CompanyTradesRepository().fetchTradeList({});
      if (!Helper.isValueNullOrEmpty(response)) {
        filterByList.addAll(response);
      }
    } catch (e) {
      rethrow;
    } finally {
      update();
    }
  }

  bool doFileHaveSamePageType(FilesListingModel? selectedFile) {

    if (type != FLModule.mergeTemplate || selectedPageType == null) return true;
    if (selectedFile?.pageType != selectedPageType) {
      selectedFileOrder.removeWhere((index) => index == selectedFile?.index);
      Helper.showToastMessage("only_same_type_templates_can_be_selected".tr);
      return false;
    }
    
    return true;
  }

  Future<void> onTapCreateMergeTemplate() async {
    if(AuthService.hasExternalTemplateUser()) {
      String url = await ExternalTemplateWebViewService.createMergeTemplateUrl(selectedFileOrder,resourceList,jobModel);
      ExternalTemplateWebViewService.navigateToExternalTemplateWebView(url,onRefresh);
    } else {
      navigateToMergeTemplate();
    }
    
  }

  void onTapTemplate(int index, int templateIndex) {
    final templateGroup = resourceList[index];
    
    if (!doFileHaveSamePageType(resourceList[index])) return;

    final tappedTemplate = templateGroup.proposalTemplatePages![templateIndex];
    tappedTemplate.isSelected = !tappedTemplate.isSelected;
    if (tappedTemplate.isSelected) {
      selectedFileOrder.add(index);
      selectedFileCount++;
      isInSelectionMode = true;
      selectedPageType = templateGroup.pageType;
    } else {
      selectedFileOrder.removeLast();
      selectedFileCount--;
    }
    if (selectedFileCount == 0 && mode == FLViewMode.view) {
      isInSelectionMode = false;
      selectedPageType = null;
    }
    templateGroup.isSelected = (templateGroup.proposalTemplatePages?.every((page) => page.isSelected) ?? false);
    update();
  }

  Future<void> onTapTemplateGroup(int index) async {
    final tappedFile = resourceList[index];
    if (tappedFile.totalPages != tappedFile.proposalTemplatePages?.length) {
      final pages = await getTemplatePagesFromGroup(tappedFile.groupId!);
      tappedFile.proposalTemplatePages = [];
      tappedFile.proposalTemplatePages?.addAll(pages);
      if (tappedFile.isSelected ?? false) {
        tappedFile.proposalTemplatePages?.forEach((page) {
          page.isSelected = true;
        });
      }
      
    }
    tappedFile.showSubPages = !tappedFile.showSubPages!;
    update();
  }

  Future<List<FormProposalTemplateModel>> getTemplatePagesFromGroup(String groupId) async {
    try {
      showJPLoader();
      final params = FilesListingRequestParam.getTemplateGroupParams(groupId);
      final files = await TemplatesRepository.getTemplatesByGroups(params);
      List<FormProposalTemplateModel> pages = files.map((file) => file.proposalTemplatePages!.first).toList();
      return pages;
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  void navigateTypeToTemplate(int index) async {
    final tappedFile = resourceList[index];
    final templateType = templateListType ?? 'proposal';
    dynamic result = await FileListMoreActionHandlers.templateTypeToNavigate(tappedFile, jobModel, templateType, type);
    if (result is bool && result) {
      if(type == FLModule.templatesListing) {
        await onRefresh(showLoading: true);
      } else {
        Get.back(result: result);
      }
    } else {
      if(type != FLModule.templatesListing) {
        onCancelSelection();
        await onRefresh(showLoading: true);
      }
    }
  }

  Future<void> openNameDialog(int index) async {
    FileListMoreActionHandlers.showSaveDialog(action!,onTapSuffix: (fileName) async {
      Map<String,dynamic> param = {
        "file_name":fileName,
        "job_id": action!.jobModel?.id,
        "google_sheet_id": resourceList[index].googleSheetId
      };
      
      await GoogleSheetActionRepo.createGoogleSheet(action!,"FLQuickActions.spreadSheetTemplate",param,action!.type).then((value) async {
        if(value.isNotEmpty){
          Helper.showToastMessage('file_added'.tr);

          Get.back();
          Get.back();

          action?.onActionComplete(FilesListingModel(),"FLQuickActions.spreadSheetTemplate");

          await Future<void>.delayed(const Duration(milliseconds: 500));

          Helper.launchUrl(value["google_sheet_url"],isInExternalMode: false);
        }
      });
    },
    initialValue: resourceList[index].name
    );
  }

  Future<void> navigateToMergeTemplate() async {
    List<FilesListingModel> selectedTemplates = FileListingQuickActionHelpers.getSelectedTemplates(resourceList);
    for (var resource in resourceList) {
      resource.isSelected = false;
    }

    if (Get.previousRoute == Routes.formProposalMergeTemplate) {
      Get.back(result: selectedTemplates);
      return;
    }

    dynamic result = await Get.toNamed(Routes.formProposalMergeTemplate, arguments: {
      NavigationParams.proposalType: ProposalTemplateFormType.add,
      NavigationParams.jobId : jobModel?.id,
      NavigationParams.list : selectedTemplates
    });

    if (result is bool && result) {
      Get.back(result: result);
    } else {
      onCancelSelection();
      await onRefresh(showLoading: true);
    }
  }

  Future<List<FilesListingModel>> fetchUnsavedResources() async {
    List<FilesListingModel> list = [];
    switch (type) {
      case FLModule.jobProposal:
        list = (await FormsDBHelper.getMultipleTypesOfUnsavedResources<FilesListingModel>(
          types: [UnsavedResourceType.proposalForm, UnsavedResourceType.mergeTemplate, UnsavedResourceType.proposalWorksheet],
          jobId: jobId!
        ));
        break;
      case FLModule.estimate:
        list = (await FormsDBHelper.getMultipleTypesOfUnsavedResources<FilesListingModel>(
            types: [UnsavedResourceType.estimateWorksheet, UnsavedResourceType.handWrittenTemplate],
            jobId: jobId!
        ));
        break;
      case FLModule.materialLists:
        list = (await FormsDBHelper.getMultipleTypesOfUnsavedResources<FilesListingModel>(
            types: [UnsavedResourceType.materialWorksheet],
            jobId: jobId!
        ));
        break;
      case FLModule.workOrder:
        list = (await FormsDBHelper.getMultipleTypesOfUnsavedResources<FilesListingModel>(
            types: [UnsavedResourceType.workOrderWorksheet],
            jobId: jobId!
        ));
        break;
      default:
        break;
    }
    return list;
  }

  void navigateToInvoiceOrChangeOrder(int? beaconAccountId, String type, int id) {
    WorksheetHelpers.checkIsNotBeaconOrBeaconAccountExist(beaconAccountId.toString(), (isNotBeaconOrBeaconAccountExist) async {
      if(isNotBeaconOrBeaconAccountExist) {
        final result = await Get.toNamed(Routes.invoiceForm, arguments: {
          NavigationParams.jobId : jobModel?.id,
          NavigationParams.invoiceId : id,
          NavigationParams.id : type == 'change_order' ? null : id,
          NavigationParams.pageType : type == 'change_order' ?
          InvoiceFormType.changeOrderEditForm
              : InvoiceFormType.invoiceEditForm
        });
        if(result != null) {
          onRefresh(showLoading: true);
        }
      }
    }, type: type == 'change_order' ?
    BeaconAccessDeniedType.changeOrder : BeaconAccessDeniedType.invoice);
  }

  bool isAddOrUploadButtonEnable(String moduleToUploadType) {
    // Deciding whether to hide or show create button in estimates module
    bool hideForEstimate = type == FLModule.estimate && isSalesProForEstimate;
    return isInSelectionMode || moduleToUploadType.isEmpty ||
        type == FLModule.companyCamProjects ||
        type == FLModule.instantPhotoGallery ||
        type == FLModule.templates ||
        type == FLModule.templatesListing ||
        type == FLModule.stageResources ||
        type == FLModule.mergeTemplate||
        type == FLModule.googleSheetTemplate ||
        type == FLModule.dropBoxListing ||
        type == FLModule.financialInvoice ||
        type == FLModule.jobContracts ||
        hideForEstimate;
  }

  Future<void> selectJob(int index) async {
    var job = await Get.toNamed(Routes.customerJobSearch, arguments: {
      NavigationParams.pageType : PageType.selectJob,
    }, preventDuplicates: false);

    if(job is JobModel) {
      jobModel = job;
      if (type == FLModule.templatesListing) {
        await loadTemplate(index);
      }
    }
    update();
  }

  bool hasPermissionToManage() {
    switch(type) {
      case FLModule.jobProposal:
        return PermissionService.hasUserPermissions([PermissionConstants.manageProposals]);
      case FLModule.estimate :
        return PermissionService.hasUserPermissions([PermissionConstants.manageEstimates]);
      case FLModule.companyFiles :
        return PermissionService.hasUserPermissions([PermissionConstants.manageCompanyFiles]);
      default:
      return true;
    }
  }

  Future<void> getBeaconOrderStatuses() async {
    List<String> beaconOrderIds = getBeaconOrderIds();
    if (!Helper.isValueNullOrEmpty(beaconOrderIds)) {
      try {
        if(type == FLModule.materialLists && AuthService.isUserBeaconConnected()) {
          Map<String, dynamic> params = {
            'order_ids': beaconOrderIds
          };
          final beaconOrders = await MaterialListsRepository().getBeaconOrderStatuses(params);
          updateBeaconOrderStatus(beaconOrders);
          update();
        }
      } catch (e) {
        rethrow;
      }
    }
  }

  List<String> getBeaconOrderIds() {
    List<String> beaconOrderIds = [];
    for (FilesListingModel resource in resourceList) {
      if(resource.beaconOrderDetails?.beaconOrderId != null && resource.beaconOrderDetails?.orderStatus != OrderStatusConstants.delivered) {
        beaconOrderIds.add(resource.beaconOrderDetails!.beaconOrderId!);
      }
    }
    return beaconOrderIds;
  }

  void updateBeaconOrderStatus(List<FilesListingModel> beaconOrders) {
    for (FilesListingModel resource in resourceList) {
      for(FilesListingModel beaconOrder in beaconOrders) {
        if(resource.beaconOrderDetails?.beaconOrderId?.toString() == beaconOrder.id) {
          resource.beaconOrderDetails?.orderStatus = beaconOrder.status;
          resource.beaconOrderDetails?.orderStatusLabel = Helper.replaceUnderscoreWithSpace(beaconOrder.status);
        }
      }
    }
  }

  bool isSupplierOrder(FilesListingModel data) => data.srsOrderDetail != null || data.beaconOrderDetails != null || data.abcOrderDetail != null;

  /// [tapOnEditFavouriteWorksheet] - helps to navigate to worksheet form
  void tapOnEditFavouriteWorksheet() async {
    JobModel? job = resourceList[lastSelectedFile!].job;
    bool restrictedAccess = Helper.isTrue(CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.restrictedWorkflow));
    bool isStandardUser = AuthService.isStandardUser();
    bool isSubUser = AuthService.isPrimeSubUser();

    // Check if the user has access to the job
    if((restrictedAccess && isStandardUser) || isSubUser) {
      bool isAssignToJob = (job?.reps?.any((rep) => rep.id == loggedInUser?.id) ?? false)
          || (job?.estimators?.any((estimator) => estimator.id == loggedInUser?.id) ?? false)
          || (job?.subContractors?.any((sub) => sub.id == loggedInUser?.id) ?? false);


      if(!isAssignToJob) {
        WorksheetHelpers.showEditWorksheetRestrictionDialog();
        return;
      }
    }

    // Check if the user has access to the customer
    if(Helper.isValueNullOrEmpty(job?.customer?.id)) {
      return;
    }

    List<DivisionModel> divisionList = await getDivisions();
    // Check if the user has access to the division
    if(!Helper.isValueNullOrEmpty(job?.division)
        && !(loggedInUser?.allDivisionsAccess ?? false)
        && divisionList.isNotEmpty) {
      DivisionModel? division = divisionList.firstWhereOrNull((division) => division.id == job?.division?.id);
      if(Helper.isValueNullOrEmpty(division)) {
        WorksheetHelpers.showEditWorksheetRestrictionDialog();
        return;
      }
    }

    String? beaconAccountId = resourceList[lastSelectedFile!].favouriteFile?.worksheet?.beaconAccountId;
    WorksheetHelpers.checkIsNotBeaconOrBeaconAccountExist(beaconAccountId, (isNotBeaconOrBeaconAccountExist) async {
      if(isNotBeaconOrBeaconAccountExist) {
        navigateToWorksheet();
      }
    });
  }

  /// [navigateToWorksheet] - helps to navigate to worksheet form
  Future<void> navigateToWorksheet() async {
    int? worksheetId = int.tryParse(resourceList[lastSelectedFile!].favouriteFile?.worksheetId ?? '');
    int? jobId = resourceList[lastSelectedFile!].job?.id;
    lastSelectedFile = null;
    resetAllSelections();
    dynamic success = await Get.toNamed(Routes.worksheetForm, arguments: {
      NavigationParams.jobId: jobId,
      NavigationParams.worksheetId: worksheetId,
      NavigationParams.worksheetType: parentModule,
      NavigationParams.worksheetFormType: WorksheetFormType.edit,
    }, preventDuplicates: false);
    if(success == true) {
      // isInSelectionMode need to set true to refresh the favourite listing
      isInSelectionMode = false;
      onRefresh(showLoading: true);
      // revert the selection mode to false
      isInSelectionMode = true;
    }
  }

  /// [isSelectedWorksheetSame] - helps to check if the selected worksheet is same as the parent worksheet
  bool isSelectedWorksheetSame() {
    if (lastSelectedFile == null) {
      return false;
    }
    return resourceList[lastSelectedFile!].favouriteFile?.worksheetId == parentWorksheetId?.toString();
  }

  Future<List<DivisionModel>> getDivisions() async {
    if(!(loggedInUser?.allDivisionsAccess ?? false)) {
      return await DivisionRepository().getAll();
    } else {
      return <DivisionModel>[];
    }
  }
}