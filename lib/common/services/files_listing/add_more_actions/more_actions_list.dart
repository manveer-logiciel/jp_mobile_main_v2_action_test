import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/constants/phases_visibility.dart';
import 'package:jobprogress/common/services/files_listing/forms/hover_order_form/index.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import '../../../enums/file_listing.dart';
import '../../../models/files_listing/create_file_actions.dart';
import '../quick_action_options.dart';

class FileListingMoreActionsList {
  static String fileActions = 'file_actions';
  static String folderActions = 'folder_actions';

  static Map<String, List<JPQuickActionModel>> getActions(CreateFileActions params) {
    switch (params.type) {
      case FLModule.measurements:
        return getAddMoreMeasurementListActions(params);
      case FLModule.estimate:
        return getAddMoreEstimateListActions(params);
      case FLModule.jobProposal:
        return getJobProposalListActions(params);
      case FLModule.workOrder:
        return getWorkOrderListActions(params);
      case FLModule.materialLists:
        return getMaterialListActions(params);
      default:
        return {};
    }
  }

  static Map<String, List<JPQuickActionModel>> getAddMoreEstimateListActions(CreateFileActions params) {
    bool isPrimeSubUser = AuthService.isPrimeSubUser();
    bool hasViewUnitCostPermission = PermissionService.hasUserPermissions([PermissionConstants.viewUnitCost]);
    bool canCreateEstimateWorksheet = !isPrimeSubUser ||  PermissionService.hasUserPermissions([PermissionConstants.createEstimateWorksheet]);
    List<JPQuickActionModel> quickActionList = [
      FileListingQuickActionOptions.upload,
      if(!isPrimeSubUser)
        FileListingQuickActionOptions.handwrittenTemplate,
      if(canCreateEstimateWorksheet)
        FileListingQuickActionOptions.worksheet,
      if(!isPrimeSubUser && hasViewUnitCostPermission)
        FileListingQuickActionOptions.insurance,
      if(CompanySettingsService.companyGoogleAccount[CompanySettingConstants.companyGoogleAcountStatus] && !isPrimeSubUser)
        FileListingQuickActionOptions.spreadSheetTemplate,
      if(CompanySettingsService.companyGoogleAccount[CompanySettingConstants.companyGoogleAcountStatus])
        FileListingQuickActionOptions.newSpreadsheet,
      if(CompanySettingsService.companyGoogleAccount[CompanySettingConstants.companyGoogleAcountStatus])
        FileListingQuickActionOptions.uploadExcel,
      if(AuthService.userDetails?.isDropBoxConnected ?? false)
        FileListingQuickActionOptions.dropBox,
    ];

    return {
      fileActions: quickActionList,
      folderActions: [],
    };
  }


  static Map<String, List<JPQuickActionModel>> getAddMoreMeasurementListActions(CreateFileActions params) {
    bool isSubUser = AuthService.isSubUser();
    bool isPrimeSubUser = AuthService.isPrimeSubUser();
    bool isHoverConnectedAndSync = ConnectedThirdPartyService.isHoverConnected() && HoverOrderFormService.canSyncHover(params.jobModel, params.subscriberDetails) ;
    bool hasManageEagleViewPermission = PermissionService.hasUserPermissions([PermissionConstants.manageEagleView]);
    bool hasManageHoverPermission = PermissionService.hasUserPermissions([PermissionConstants.manageHover]);
    bool canCreateMeasurement = !isPrimeSubUser || PermissionService.hasUserPermissions([PermissionConstants.createMeasurements]);
    List<JPQuickActionModel> quickActionList = [
      if(!Helper.isTrue(params.jobModel?.isMultiJob) && PhasesVisibility.canShowSecondPhase && canCreateMeasurement)
        FileListingQuickActionOptions.measurementForm,
      if(isHoverConnectedAndSync && !isSubUser && hasManageHoverPermission)
        FileListingQuickActionOptions.hover,
      if(ConnectedThirdPartyService.isEagleViewConnected() && !isSubUser && hasManageEagleViewPermission)
        FileListingQuickActionOptions.eagleView,
      if(ConnectedThirdPartyService.isQuickMeasureConnected() && !isSubUser)
        FileListingQuickActionOptions.quickMeasure,
      FileListingQuickActionOptions.upload,
    ];

    return {
      fileActions: quickActionList,
      folderActions: [],
    };
  }

  static Map<String, List<JPQuickActionModel>> getAddEstimatesListActions(CreateFileActions params) {
    List<JPQuickActionModel> quickActionList = [
      FileListingQuickActionOptions.upload,
      FileListingQuickActionOptions.dropBox,
    ];

    return {
      fileActions: quickActionList,
      folderActions: [],
    };
  }

  static Map<String, List<JPQuickActionModel>> getJobProposalListActions(CreateFileActions params) {
    bool isPrimeSubUser = AuthService.isPrimeSubUser();
     bool canCreateDocumentWorksheet = !isPrimeSubUser || PermissionService.hasUserPermissions([PermissionConstants.createDocumentWorksheet]);
     List<JPQuickActionModel> quickActionList = [
      if(canCreateDocumentWorksheet)
        FileListingQuickActionOptions.worksheet,
       if(!isPrimeSubUser)...{
         FileListingQuickActionOptions.jobFormProposalTemplate,
         FileListingQuickActionOptions.jobFormProposalMerge,
       },
      if(CompanySettingsService.companyGoogleAccount[CompanySettingConstants.companyGoogleAcountStatus] && !isPrimeSubUser)
        FileListingQuickActionOptions.spreadSheetTemplate,
      if(CompanySettingsService.companyGoogleAccount[CompanySettingConstants.companyGoogleAcountStatus])
        FileListingQuickActionOptions.newSpreadsheet,
      if(CompanySettingsService.companyGoogleAccount[CompanySettingConstants.companyGoogleAcountStatus])
        FileListingQuickActionOptions.uploadExcel,
      FileListingQuickActionOptions.upload,
      if(AuthService.userDetails?.isDropBoxConnected ?? false)
        FileListingQuickActionOptions.dropBox,
     ];
     return {
       fileActions: quickActionList,
       folderActions: [],
     };
  }

  static Map<String, List<JPQuickActionModel>> getWorkOrderListActions(CreateFileActions params) {
    bool isPrimeSubUser = AuthService.isPrimeSubUser();
    bool canCreateWorkOrder = !isPrimeSubUser || PermissionService.hasUserPermissions([PermissionConstants.createWorkOrder]);
    List<JPQuickActionModel> quickActionList = [
      if(canCreateWorkOrder)
        FileListingQuickActionOptions.worksheet,
      FileListingQuickActionOptions.upload,
    ];
    return {
      fileActions: quickActionList,
      folderActions: [],
    };
  }

  static Map<String, List<JPQuickActionModel>> getMaterialListActions(CreateFileActions params) {
    bool isPrimeSubUser = AuthService.isPrimeSubUser();
    bool canCreateMaterialsWorksheet = !isPrimeSubUser || PermissionService.hasUserPermissions([PermissionConstants.createMaterialsWorksheet]);
    List<JPQuickActionModel> quickActionList = [
      if(canCreateMaterialsWorksheet)
      FileListingQuickActionOptions.worksheet,
      FileListingQuickActionOptions.upload,
    ];
    return {
      fileActions: quickActionList,
      folderActions: [],
    };
  }

}