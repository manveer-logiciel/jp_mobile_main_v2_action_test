import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/common/models/subscriber/subscriber_details.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_helpers.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_options.dart';
import 'package:jobprogress/common/services/files_listing/quick_actions.dart';
import 'package:jobprogress/common/services/job_financial/quick_action_list.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/config/app_env.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/core/constants/measurement_constant.dart';
import 'package:jobprogress/core/constants/phases_visibility.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import 'package:jp_mobile_flutter_ui/Thumb/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../core/constants/permission.dart';
import '../../enums/resource_type.dart';

// FileListingQuickActionsList contains all the quick actions module wise
class FileListingQuickActionsList {

  static String fileActions = 'file_actions';
  static String folderActions = 'folder_actions';

  static bool isShowEdit(FilesListingModel file) {
    bool isSubContractorPrime =  AuthService.isPrimeSubUser(); 
    if(
      file.smOrder != null &&
      (file.smOrder!.status!.toLowerCase() == 'refunded' ||
      file.smOrder!.status!.toLowerCase() == 'partial refund' ||
      file.smOrder!.status!.toLowerCase() == 'completed')) {
        return false;
    }
    
    if(file.evOrder != null && file.evOrder!.status!.name!.toLowerCase() == 'completed') {
      return false;
    }

    if(file.type?.toLowerCase() == MeasurementConstant.quickMeasure) {
      return false;
    }

    if(isSubContractorPrime && file.smOrder != null) {
      return false;
    }

    if((file.isFile?? false) && file.hoverJob == null) {
      return false;
    }

    if(file.hoverJob != null && !file.isHoverJobCompleted!) {
      return false;
    }

    if(file.evReportId != null
        || file.smOrderId != null
        || file.hoverJob != null
        || file.quickMeasureOrder != null
    ) {
      return false;
    }
    
    return true;
  }

  /// [hideMaterialEdit] Hides the material edit based on various conditions.
  /// Edit option should hide when
  /// - For placed order
  /// - When supplier is not known
  /// - For image files
  /// - Supplier is not active
  static bool hideMaterialEdit(FilesListingModel file) {
    final srsSupplierId = Helper.getSupplierId();
    final srsV1SupplierId = Helper.getSupplierId(forceV1: true);
    final beaconSupplierId = Helper.getSupplierId(key: CommonConstants.beaconId);
    final abcSupplierId = Helper.getSupplierId(key: CommonConstants.abcSupplierId);
    // Check if the order ID is present
    bool orderIdPresent = !Helper.isValueNullOrEmpty(file.srsOrderDetail?.orderId)
        || !Helper.isValueNullOrEmpty(file.beaconOrderDetails?.orderId)
        || !Helper.isValueNullOrEmpty(file.abcOrderDetail?.orderId);
    // Check if the supplier ID is not matching with SRS or Beacon or ABC
    bool supplierIdNotMatching = file.forSupplierId != null &&
        file.forSupplierId != srsSupplierId &&
        file.forSupplierId != srsV1SupplierId &&
        file.forSupplierId != beaconSupplierId &&
        file.forSupplierId != abcSupplierId;
    // Check if the file is an image
    bool isImage = file.jpThumbType == JPThumbType.image;

    bool isSupplierNotConnected = false;
    // Checking whether supplier is connected or not
    if (!Helper.isValueNullOrEmpty(file.worksheet?.suppliers)) {
      if (file.worksheet?.suppliers?.any((supplier) => supplier.id == srsSupplierId || supplier.id == srsV1SupplierId) ?? false) {
        isSupplierNotConnected = !ConnectedThirdPartyService.isSrsConnected();
      } else if (file.worksheet?.suppliers?.any((supplier) => supplier.id == beaconSupplierId) ?? false) {
        isSupplierNotConnected = !ConnectedThirdPartyService.isBeaconConnected();
      } else if(Helper.isSupplierHaveABCItem(file.worksheet?.suppliers)) {
        isSupplierNotConnected = !ConnectedThirdPartyService.isAbcConnected();
      }
    }
    return orderIdPresent || supplierIdNotMatching || isImage || isSupplierNotConnected;
  }

  static bool hideMaterialMarkFavorite(FilesListingModel file){
    Map<String, dynamic> supplierIds = AppEnv.envConfig[CommonConstants.suppliersIds];
    return supplierIds.containsValue(file.forSupplierId);
  }
  
  // getActions()
  // This function differentiate quick actions as per the
  // type of FileListing being displayed
  static Map<String, List<JPQuickActionModel>> getActions(
      FilesListingQuickActionParams params) {
    switch (params.type) {
      case FLModule.companyFiles:
        return getCompanyFilesActionsList(params);

      case FLModule.estimate:
        return getJobEstimateActionList(params);

      case FLModule.jobPhotos:
        return getJobPhotosActionsList(params);

      case FLModule.jobProposal:
        return getJobProposalActionList(params);

      case FLModule.measurements:
        return getMeasurementsActionList(params);

      case FLModule.materialLists:
        return getMaterialListActions(params);

      case FLModule.workOrder:
        return getWorkOrderActions(params);

      case FLModule.stageResources:
        return getStageResourcesActionList(params);

      case FLModule.userDocuments:
        return getUserDocumentsActionsList(params);

      case FLModule.customerFiles:
        return getCustomerFilesActionsList(params);
      
      case FLModule.instantPhotoGallery:
        return  getInstantPhotoGalleryActionsList(params);  

      case FLModule.dropBoxListing:
        return  getDropboxActionsList(params);  

      case FLModule.financialInvoice:
        FinancialListingModel modal = FinancialListingModel.fromJobInvoicesJson(params.fileList[0].toJobInvoiceJson());
        return {
          fileActions: JobFinancialListingQuickActionsList.getJobInvoicesActionList(modal: modal, job: params.jobModel, type: FLModule.financialInvoice)
        };

      case FLModule.cumulativeInvoices:
        return getCumulativeInvoicesList(params);

      case FLModule.companyCamProjectImages:
       return getCompanyCamActionsList(params);

      case FLModule.jobContracts:
       return getContractsActionsList(params);

      default:
        return {};
    }
  }

   static Map<String, List<JPQuickActionModel>> getInstantPhotoGalleryActionsList(
      FilesListingQuickActionParams params) {
    List<JPQuickActionModel> quickActionList = [
      if (!params.isInSelectionMode!) FileListingQuickActionOptions.rename,
      if (!params.isInSelectionMode!) FileListingQuickActionOptions.print,
      if (!params.isInSelectionMode!) FileListingQuickActionOptions.sendViaText,
      FileListingQuickActionOptions.moveToJob,
      if (!FileListingQuickActionHelpers.checkIfAllSelectedFilesAreImages(params))
      FileListingQuickActionOptions.rotate,
      // if (!params.isInSelectionMode!) FileListingQuickActionOptions.expiresOn,
      FileListingQuickActionOptions.delete,
      if (!params.isInSelectionMode!) FileListingQuickActionOptions.info,
    ];
    return {
      fileActions: quickActionList,
    };
  }

  static Map<String, List<JPQuickActionModel>> getDropboxActionsList(
      FilesListingQuickActionParams params) {
    List<JPQuickActionModel> quickActionList = [
      if (!params.isInSelectionMode!) FileListingQuickActionOptions.view,
      if (!params.isInSelectionMode!) FileListingQuickActionOptions.print,
      if (!params.isInSelectionMode!) FileListingQuickActionOptions.share,
      FileListingQuickActionOptions.copyToJob,
      if (!params.isInSelectionMode!) FileListingQuickActionOptions.info,
    ];
    return {
      fileActions: quickActionList
    };
  }

  static Map<String, List<JPQuickActionModel>> getCompanyFilesActionsList(
      FilesListingQuickActionParams params) {
    
    bool hasManageCompanyFilesPermission = PermissionService.hasUserPermissions([PermissionConstants.manageCompanyFiles]);
    List<JPQuickActionModel> quickActionList = [
      if (!params.isInSelectionMode! & hasManageCompanyFilesPermission) FileListingQuickActionOptions.rename,
      if (!params.isInSelectionMode!) FileListingQuickActionOptions.print,
      FileListingQuickActionOptions.email,
      FileListingQuickActionOptions.copyToJob,
      if(hasManageCompanyFilesPermission) FileListingQuickActionOptions.move,
      if (!FileListingQuickActionHelpers.checkIfAllSelectedFilesAreImages(params) & hasManageCompanyFilesPermission) ...{
        FileListingQuickActionOptions.rotate,
      },
      if (!params.isInSelectionMode!) ...{
        if (params.fileList.first.jpThumbType == JPThumbType.image) ...{
          FileListingQuickActionOptions.sendViaText,
        } else ...{
          FileListingQuickActionOptions.sendViaJobProgress,
        }
      },
      if (!params.isInSelectionMode! & hasManageCompanyFilesPermission) FileListingQuickActionOptions.expiresOn,
      if(hasManageCompanyFilesPermission)FileListingQuickActionOptions.delete,
      if (!params.isInSelectionMode!) FileListingQuickActionOptions.info,
    ];

    List<JPQuickActionModel> folderQuickActions = [
      if (params.fileList.first.locked == 0) FileListingQuickActionOptions.rename,
      if (params.fileList.first.locked == 0) FileListingQuickActionOptions.delete,
    ];

    return {
      fileActions: quickActionList,
      folderActions: folderQuickActions,
    };
  }

    static Map<String, List<JPQuickActionModel>> getCompanyCamActionsList(
      FilesListingQuickActionParams params) {
    List<JPQuickActionModel> quickActionList = [
      FileListingQuickActionOptions.copyToJob,
    ];
    return {
      fileActions: quickActionList,
    };
  }

  /// [getContractsActionsList] gives the actions to be shown on Contract file
  static Map<String, List<JPQuickActionModel>> getContractsActionsList(FilesListingQuickActionParams params) {
    FilesListingModel file = params.fileList.first;
    JobModel? job = params.jobModel;
    bool isDisplayedOnCustomerWebPage = !file.isShownOnCustomerWebPage! && (job != null && job.bidCustomer == 0);

    List<JPQuickActionModel> quickActionList = [
      FileListingQuickActionOptions.rename,
      FileListingQuickActionOptions.print,
      FileListingQuickActionOptions.email,
      isDisplayedOnCustomerWebPage
          ? FileListingQuickActionOptions.showOnCustomerWebPage
          : FileListingQuickActionOptions.removeFromCustomerWebPage,
      FileListingQuickActionOptions.makeACopy,
      FileListingQuickActionOptions.expiresOn,
      FileListingQuickActionOptions.sendViaText,
      FileListingQuickActionOptions.delete,
      FileListingQuickActionOptions.info,
    ];
    return {
      fileActions: quickActionList,
    };
  }

  static Map<String, List<JPQuickActionModel>> getJobEstimateActionList(
      FilesListingQuickActionParams params) {

    FilesListingModel file = params.fileList.first;
    JobModel? job = params.jobModel;
    String? jobPrice = FileListingQuickActionHelpers.getJobPrice(file, job);
    bool hideEditInsurance = file.type == 'xactimate' && AuthService.isPrimeSubUser();
    bool isCustomerJobFeatureAllowed = FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.customerJobFeatures]);
    bool isFavMarkedByMe = AuthService.userDetails?.id.toString() == file.myFavouriteEntity?.markedBy.toString();
    List<JPQuickActionModel> quickActionList;

    if(file.type == ResourceType.unsavedResource) {
      quickActionList = [
        FileListingQuickActionOptions.editUnsavedResource,
        FileListingQuickActionOptions.deleteUnsavedResource,
      ];
    } else if (file.isGoogleSheet!) {
      quickActionList = [
        FileListingQuickActionOptions.view,
        FileListingQuickActionOptions.editGoogleSheet,
        FileListingQuickActionOptions.rename,
        FileListingQuickActionOptions.expiresOn,
        FileListingQuickActionOptions.delete,
        FileListingQuickActionOptions.info,
      ];
    } else if(FileListingQuickActionHelpers.isChooseSupplierSettings(file.worksheet)) {
      quickActionList = [
        FileListingQuickActionOptions.chooseSupplierSettings
      ];
    } else {
      quickActionList = [
        FileListingQuickActionOptions.email,
        if(file.isTemplate! && PhasesVisibility.canShowSecondPhase)
          FileListingQuickActionOptions.editEstimateTemplate,
        if(file.isWorkSheet! && PhasesVisibility.canShowSecondPhase) ...{
          if (file.type == 'worksheet') ...{
            FileListingQuickActionOptions.editWorksheet,
            ...getWorksheetAction(params),
            if (jobPrice != null) FileListingQuickActionOptions.updateJobPrice(jobPrice),
          } else if (!hideEditInsurance)...{
            FileListingQuickActionOptions.editInsurance,
            if (!Helper.isValueNullOrEmpty(file.xactimateFilePath))
              FileListingQuickActionOptions.insurancePDF(file.xactimateFilePath!),
          }
        },
        if(file.jpThumbType == JPThumbType.image)
          FileListingQuickActionOptions.edit,
        if(file.isWorkSheet!)...{
          // FileListingQuickActionOptions.syncWithQBD,
        },
        if (file.isWorkSheet! && file.linkedMeasurement != null)
          FileListingQuickActionOptions.viewLinkedMeasurement,
        if (file.isShownOnCustomerWebPage! && getUserShowOnPagePermission() && isCustomerJobFeatureAllowed)
          FileListingQuickActionOptions.removeFromCustomerWebPage,
        if (!file.isShownOnCustomerWebPage! && (job != null && job.bidCustomer == 0) && getUserShowOnPagePermission() && isCustomerJobFeatureAllowed)
          FileListingQuickActionOptions.showOnCustomerWebPage,
        if (isFavMarkedByMe && file.isWorkSheet!)
          FileListingQuickActionOptions.unMarkAsFavourite,
        if (file.myFavouriteEntity == null && file.isWorkSheet!)
          FileListingQuickActionOptions.markAsFavourite,
        FileListingQuickActionOptions.rename,
        if (!file.isGoogleSheet!) FileListingQuickActionOptions.print,
        if (file.jpThumbType == JPThumbType.image && !file.isWorkSheet!) ...{
          FileListingQuickActionOptions.rotate,
          FileListingQuickActionOptions.sendViaText,
        } else ...{
          FileListingQuickActionOptions.sendViaJobProgress,
        },
        if (params.fileList.first.jpThumbType == JPThumbType.image && !AuthService.isPrimeSubUser())
          FileListingQuickActionOptions.share,
        FileListingQuickActionOptions.expiresOn,
        if(!CommonConstants.restrictFolderStructure) FileListingQuickActionOptions.move,
        FileListingQuickActionOptions.delete,
        FileListingQuickActionOptions.info,
      ];
    }
    List<JPQuickActionModel> folderQuickActions = file.locked == 1 ? [] : [
      FileListingQuickActionOptions.rename,
      FileListingQuickActionOptions.delete,
    ];

    return {
      fileActions: quickActionList,
      folderActions: folderQuickActions,
    };
  }

  static Map<String, List<JPQuickActionModel>> getJobPhotosActionsList(
      FilesListingQuickActionParams params) {

    FilesListingModel file = params.fileList.first;
    JobModel? job = params.jobModel;
    bool isCustomerJobFeatureAllowed = FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.customerJobFeatures]);
    bool isImage = FileHelper.checkIfImagePhotosDocument(file.path ?? '');
    bool hasShareCustomerWebPagePermission = PermissionService.hasUserPermissions(['share_customer_web_page']);

    List<JPQuickActionModel> quickActionList = [
      FileListingQuickActionOptions.email,
      if(!(params.isInSelectionMode!) && (file.jpThumbType == JPThumbType.image)) FileListingQuickActionOptions.edit,
      if (!params.isInSelectionMode!) FileListingQuickActionOptions.rename,
      if (!params.isInSelectionMode! && !file.isGoogleDriveLink!) FileListingQuickActionOptions.print,
      if(hasShareCustomerWebPagePermission && isCustomerJobFeatureAllowed)...{
        if(params.isInSelectionMode!)...{
          if(!FileListingQuickActionHelpers.checkIfAllShowOnCustomerWebPage(params))...{
            FileListingQuickActionOptions.showOnCustomerWebPage,
            if(FileListingQuickActionHelpers.checkIfAnyShowOnCustomerWebPage(params))FileListingQuickActionOptions.removeFromCustomerWebPage,
          } else ...{
            FileListingQuickActionOptions.removeFromCustomerWebPage,
          }
        } else...{
          if (!file.isShownOnCustomerWebPage! && (job != null && job.bidCustomer == 0))
          FileListingQuickActionOptions.showOnCustomerWebPage,
          if (file.isShownOnCustomerWebPage!)
          FileListingQuickActionOptions.removeFromCustomerWebPage,
        },
      },
      
      if (params.fileList.first.jpThumbType == JPThumbType.image && (!params.isInSelectionMode!))
        FileListingQuickActionOptions.share,
      if (!FileListingQuickActionHelpers.checkIfAllSelectedFilesAreImages(params)) ...{
        if(isImage) FileListingQuickActionOptions.rotate,
        if(!params.isInSelectionMode!) FileListingQuickActionOptions.sendViaText,
      } else ...{
        if(!params.isInSelectionMode!) FileListingQuickActionOptions.sendViaJobProgress,
      },
      FileListingQuickActionOptions.move,
      if (!params.isInSelectionMode!) FileListingQuickActionOptions.expiresOn,
        FileListingQuickActionOptions.delete,
      if (!params.isInSelectionMode!) FileListingQuickActionOptions.info,
    ];

    List<JPQuickActionModel> folderQuickActions = [
      if (params.fileList.first.locked == 0) FileListingQuickActionOptions.rename,
      if (params.fileList.first.locked == 0) FileListingQuickActionOptions.delete,
    ];

    return {
      fileActions: quickActionList,
      folderActions: folderQuickActions,
    };
  }

  static Map<String, List<JPQuickActionModel>> getJobProposalActionList(
      FilesListingQuickActionParams params) {
    FilesListingModel file = params.fileList.first;
    JobModel? job = params.jobModel;
    String? jobPrice = FileListingQuickActionHelpers.getJobPrice(file, job);
    bool hasManagePermission = PermissionService.hasUserPermissions([PermissionConstants.manageProposals]);
    bool hasStatusUpdatePermission = hasManagePermission || PermissionService.hasUserPermissions([PermissionConstants.changeProposalStatus]);
    bool openProposalPublicPage = hasManagePermission || Helper.isTrue(PermissionService.hasUserPermissions([PermissionConstants.openProposalPublicPage]));
    bool manageShareCustomerWebPage = hasManagePermission ||  PermissionService.hasUserPermissions([PermissionConstants.manageShareCustomerWebPage]);
    bool canEditProposal = (file.status == 'draft' || file.status == 'sent') && file.digitalSignStatus == null;
    bool canShowLinkedEstimate = Helper.isTrue(PermissionService.hasUserPermissions([PermissionConstants.manageEstimates]));
    bool hasSignFileStatus = file.status == 'draft' || file.status == 'sent' || file.status == 'viewed';
    bool isWorksheet = file.type == 'worksheet' && !file.insuranceEstimate!;
    bool showWorksheetSignProposal = hasSignFileStatus && hasStatusUpdatePermission;
    bool isCustomerJobFeatureAllowed = FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.customerJobFeatures]);
    bool isFinanceFeatureAllowed = FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.financeAndAccounting]);
    bool hasManageFinancialPermission = PermissionService.hasUserPermissions([PermissionConstants.manageFinancial]);
    bool isInvoiceGenerated = job?.jobInvoices?.indexWhere((element) => element.proposalId != null) == -1 && Helper.isValueNullOrEmpty(file.linkedInvoicesLists);
    bool isFavMarkedByMe = AuthService.userDetails?.id.toString() == file.myFavouriteEntity?.markedBy.toString();
    List<JPQuickActionModel> quickActionList;

    if(file.type == ResourceType.unsavedResource) {
      quickActionList = [
        FileListingQuickActionOptions.editUnsavedResource,
        FileListingQuickActionOptions.deleteUnsavedResource,
      ];
    } else {
      quickActionList = [
        if(file.isGoogleSheet!)...{
          FileListingQuickActionOptions.view,
          FileListingQuickActionOptions.editGoogleSheet,
          FileListingQuickActionOptions.rename,
          FileListingQuickActionOptions.formProposalNote,
          FileListingQuickActionOptions.updateStatus,
          FileListingQuickActionOptions.expiresOn,
          FileListingQuickActionOptions.delete,
          FileListingQuickActionOptions.info,
        } else if(FileListingQuickActionHelpers.isChooseSupplierSettings(file.worksheet)) ...{
          FileListingQuickActionOptions.chooseSupplierSettings
        } else...{
          FileListingQuickActionOptions.email,
          FileListingQuickActionOptions.email,
          if(isWorksheet)...{
            if (hasManagePermission && PhasesVisibility.canShowSecondPhase) ...{
              if (canEditProposal) FileListingQuickActionOptions.editWorksheet,
              if (showWorksheetSignProposal) FileListingQuickActionOptions.worksheetSignProposal,
              if (canEditProposal)
                if (canShowLinkedEstimate && file.linkedEstimate != null) FileListingQuickActionOptions.viewLinkedEstimate,
              ...getWorksheetAction(params, excludeProposal: true),
              if (jobPrice != null) FileListingQuickActionOptions.updateJobPrice(jobPrice),
            },
            // FileListingQuickActionOptions.syncWithQBD,
            if(PhasesVisibility.canShowSecondPhase && isFinanceFeatureAllowed) FileListingQuickActionOptions.generateJobInvoice,
            if(PhasesVisibility.canShowSecondPhase && (isFinanceFeatureAllowed && hasManageFinancialPermission)) FileListingQuickActionOptions.updateJobInvoice,
            if(PhasesVisibility.canShowSecondPhase) FileListingQuickActionOptions.viewLinkedInvoices,
            if(file.myFavouriteEntity == null && hasManagePermission) FileListingQuickActionOptions.markAsFavourite,
            if(isFavMarkedByMe && hasManagePermission) FileListingQuickActionOptions.unMarkAsFavourite,
        } else if (file.jpThumbType != JPThumbType.image && file.type != "file") ...{
          if(hasManagePermission && PhasesVisibility.canShowSecondPhase) ...{
            if (canEditProposal) FileListingQuickActionOptions.editProposalTemplate,
            if (showWorksheetSignProposal) FileListingQuickActionOptions.signTemplateProposal,
          },
        } else ...{
          if((file.jpThumbType == JPThumbType.image) && hasManagePermission) FileListingQuickActionOptions.edit,
        },
        if (file.isWorkSheet! && file.linkedMeasurement != null)
          FileListingQuickActionOptions.viewLinkedMeasurement,
        if (file.isShownOnCustomerWebPage! && manageShareCustomerWebPage && isCustomerJobFeatureAllowed)
          FileListingQuickActionOptions.removeFromCustomerWebPage,
        if (!file.isShownOnCustomerWebPage! && (job != null && job.bidCustomer == 0) && manageShareCustomerWebPage && isCustomerJobFeatureAllowed)
          FileListingQuickActionOptions.showOnCustomerWebPage,
        if(!file.isGoogleSheet! && openProposalPublicPage)
          FileListingQuickActionOptions.openPublicForm,
        if(hasManagePermission) FileListingQuickActionOptions.formProposalNote,
        if(!file.isGoogleSheet! && hasStatusUpdatePermission && file.digitalSignStatus == null && !AuthService.isPrimeSubUser()) FileListingQuickActionOptions.updateStatus,
        if(!file.isGoogleSheet! && hasManagePermission)
          FileListingQuickActionOptions.makeACopy,

        if(hasManagePermission) FileListingQuickActionOptions.rename,
        if (!file.isGoogleSheet!) FileListingQuickActionOptions.print,
        if (file.jpThumbType == JPThumbType.image && !file.isWorkSheet!) ...{
          if(hasManagePermission) FileListingQuickActionOptions.rotate,
          FileListingQuickActionOptions.sendViaText,
        } else ...{
          FileListingQuickActionOptions.sendViaJobProgress,
        },
        if(!CommonConstants.restrictFolderStructure && hasManagePermission) FileListingQuickActionOptions.move,
        if(hasManagePermission) ...{
            FileListingQuickActionOptions.expiresOn,
            FileListingQuickActionOptions.delete,
          },
          FileListingQuickActionOptions.info,
        }
      
      ];
    }

    ///   Remove generate job invoice
    if(!FileListingQuickActionHelpers.canShowWorksheetInvoiceQuickActions(job, file, hasManagePermission, isInvoiceGenerated) && PhasesVisibility.canShowSecondPhase) {
      Helper.removeMultipleKeysFromArray(quickActionList, [FLQuickActions.generateJobInvoice.toString()]);
    }
    
    ///   Remove update job invoice
    if((!FileListingQuickActionHelpers.canShowWorksheetInvoiceQuickActions(job, file, hasManagePermission, !isInvoiceGenerated) || (job?.jobInvoices?.length ?? 0) > 1) && PhasesVisibility.canShowSecondPhase) {
      
      Helper.removeMultipleKeysFromArray(quickActionList, [FLQuickActions.updateJobInvoice.toString()]);
    }

    ///   Remove view linked invoices
    if((Helper.isValueNullOrEmpty(file.linkedInvoicesLists) || Helper.isTrue(job?.financialDetails?.canBlockFinancial)
        || Helper.isTrue(job?.isMultiJob) || !hasManagePermission) && PhasesVisibility.canShowSecondPhase) {
      Helper.removeMultipleKeysFromArray(quickActionList, [FLQuickActions.viewLinkedInvoices.toString()]);
    }

    List<JPQuickActionModel> folderQuickActions = file.locked == 1 ? [] : [
      FileListingQuickActionOptions.rename,
      FileListingQuickActionOptions.delete
    ];

    return {
      fileActions: quickActionList,
      folderActions: folderQuickActions,
    };
  }

  static bool isAnyInvoiceCreatedByProposal(JobModel? job) =>
    job?.jobInvoices?.firstWhere((element) => element.proposalId != null) != null;

  static Map<String, List<JPQuickActionModel>> getMeasurementsActionList(
      FilesListingQuickActionParams params) {

    FilesListingModel file = params.fileList.first;
    SubscriberDetailsModel? subscriberDetails = params.subscriberDetails;
    List<JPQuickActionModel> quickActionList = [
      if(isNormalMeasurement(file)) FileListingQuickActionOptions.email,
      if(!file.isHoverJobCompleted!) FileListingQuickActionOptions.rename,
      if(isShowEdit(params.fileList.first) && PhasesVisibility.canShowSecondPhase) FileListingQuickActionOptions.editMeasurement,
      if (file.jpThumbType == JPThumbType.image && !file.isMeasurement!)
        if(file.isHoverJobCompleted != null && !file.isHoverJobCompleted!) FileListingQuickActionOptions.rotate,

      if(!file.isHoverJobCompleted!) FileListingQuickActionOptions.print,
      if((file.isHover == true && (file.isHoverJobCompleted != null && file.isHoverJobCompleted!)) || file.totalValues != 0)
        FileListingQuickActionOptions.viewMeasurementValues,

      if (!FileListingQuickActionHelpers.checkIfAllSelectedFilesAreImages(params)) ...{
        if(file.isHoverJobCompleted != null && !file.isHoverJobCompleted!)
          FileListingQuickActionOptions.sendViaText,
      } else ...{
        if(file.isHoverJobCompleted != null && !file.isHoverJobCompleted!)
          FileListingQuickActionOptions.sendViaJobProgress,
        },
      if (file.jpThumbType == JPThumbType.image)
        if(!file.isHoverJobCompleted!) FileListingQuickActionOptions.share,

      if(!Helper.isValueNullOrEmpty(file.reportFiles))
        FileListingQuickActionOptions.viewReports(
            subList: file.reportFiles?.map((report) {
              return JPQuickActionModel(
                child: const JPIcon(Icons.remove_red_eye_outlined, size: 20),
                label: report.fileName.toString(),
                id: '${FLQuickActions.viewReportsSubOption} ${report.filePath}',
              );
            }).toList()
        ),

      if(file.hoverJob != null)...{
        if(file.hoverJob!.hoverImages != null) FileListingQuickActionOptions.hoverImages,
        if(file.isHoverJobCompleted != null && !file.isHoverJobCompleted!) FileListingQuickActionOptions.open3DModel,
        if(subscriberDetails?.hoverClient != null && subscriberDetails!.hoverClient!.ownerId == file.hoverJob?.ownerId)...{
          if(file.isUpgradeToHoverRoofOnlyVisible ?? false)
            FileListingQuickActionOptions.upgradeToHoverRoofOnly,
          if(file.isUpgradeToHoverRoofCompleteVisible ?? false)
            FileListingQuickActionOptions.upgradeToHoverRoofComplete,
        }
      },

      FileListingQuickActionOptions.expiresOn,
      if(!CommonConstants.restrictFolderStructure) FileListingQuickActionOptions.move,
      if(isNormalMeasurement(file)) FileListingQuickActionOptions.delete,
      if(file.hoverJob != null)
        if(!file.isHoverJobCompleted!) FileListingQuickActionOptions.viewInfo,
      if(!file.isHoverJobCompleted!) FileListingQuickActionOptions.info,
    ];

    List<JPQuickActionModel> folderQuickActions = file.locked == 1 ? [] : [
      FileListingQuickActionOptions.rename,
      FileListingQuickActionOptions.delete,
    ];

    return {
      fileActions: quickActionList,
      folderActions: folderQuickActions,
    };
  }

  static Map<String, List<JPQuickActionModel>> getMaterialListActions(FilesListingQuickActionParams params) {

    FilesListingModel file = params.fileList.first;
    bool hideEdit = hideMaterialEdit(file) || Helper.isTrue(file.isFile);
    bool hasGeneratedSRSOrder = Helper.isSRSv1Id(file.forSupplierId) || Helper.isSRSv2Id(file.forSupplierId);
    bool hasGeneratedBeaconOrder = Helper.getSupplierId(key: CommonConstants.beaconId) == file.forSupplierId;
    bool hasGeneratedABCOrder = Helper.getSupplierId(key: CommonConstants.abcSupplierId) == file.forSupplierId;
    bool showSrsOrder = !hasGeneratedSRSOrder
        && !AuthService.isPrimeSubUser()
        && Helper.isSupplierHaveSrsItem(file.worksheet?.suppliers);
    bool showBeaconOrder = !hasGeneratedBeaconOrder
        && !AuthService.isPrimeSubUser()
        && Helper.isSupplierHaveBeaconItem(file.worksheet?.suppliers);
    bool showABCOrder = !hasGeneratedABCOrder
        && !AuthService.isPrimeSubUser()
        && Helper.isSupplierHaveABCItem(file.worksheet?.suppliers);
    bool isMultiJob = params.jobModel?.isMultiJob ?? false;
    bool canShowLinkedEstimate = Helper.isTrue(PermissionService.hasUserPermissions([PermissionConstants.manageEstimates]));
    bool isFavMarkedByMe = AuthService.userDetails?.id.toString() == file.myFavouriteEntity?.markedBy.toString();

    List<JPQuickActionModel> quickActionList;

    if(file.type == ResourceType.unsavedResource) {
      quickActionList = [
        FileListingQuickActionOptions.editUnsavedResource,
        FileListingQuickActionOptions.deleteUnsavedResource,
      ];
    } else if(FileListingQuickActionHelpers.isChooseSupplierSettings(file.worksheet)) {
      quickActionList = [
        FileListingQuickActionOptions.chooseSupplierSettings
      ];
    } else {
      quickActionList = [
        FileListingQuickActionOptions.email,
        if (PhasesVisibility.canShowSecondPhase && !hideEdit)
          FileListingQuickActionOptions.editWorksheet,
        if (canShowLinkedEstimate && file.isMaterialList! && file.linkedEstimate != null)
          FileListingQuickActionOptions.viewLinkedEstimate,
        if (file.isMaterialList! && file.linkedWorkProposal != null)
          FileListingQuickActionOptions.viewLinkedForm,
        if (file.isMaterialList! && file.linkedWorkOrder != null)
          FileListingQuickActionOptions.viewLinkedWorkOrder,
        if (file.isMaterialList! && file.linkedMeasurement != null)
          FileListingQuickActionOptions.viewLinkedMeasurement,
        if (file.isMaterialList! && file.linkedMaterialLists != null)
          FileListingQuickActionOptions.viewLinkedMaterialList(materials: file.linkedMaterialLists),
        if(file.status == 'completed')...{
          FileListingQuickActionOptions.markAsPending,
        } else...{
          FileListingQuickActionOptions.markAsCompleted,
        },
        // Worksheet with SRS products option
        if (file.isMaterialList! && showSrsOrder && !isMultiJob)
          FileListingQuickActionOptions.generateSRSOrderForm,
        if (file.isWorkSheet! && Helper.isSupplierHaveSrsItem(file.worksheet?.suppliers) && ConnectedThirdPartyService.isSrsConnected()) ...[
          if (file.deliveryDateModel?.deliveryDate != null && file.isSrs)
            FileListingQuickActionOptions.viewOrderDetails
          else if (Helper.isSRSv1Id(file.forSupplierId) || Helper.isSRSv2Id(file.forSupplierId))
            FileListingQuickActionOptions.placeSRSOrder,
        ],

        // Worksheet with beacon products option
        if (file.isMaterialList! && showBeaconOrder && !isMultiJob)
          FileListingQuickActionOptions.generateBeaconOrderForm,

        // Worksheet with ABC products option
        if (file.isMaterialList! && showABCOrder && !isMultiJob)
          FileListingQuickActionOptions.generateABCOrderForm,
        // Beacon Order Options
        if (file.isWorkSheet! && Helper.isSupplierHaveBeaconItem(file.worksheet?.suppliers) && ConnectedThirdPartyService.isBeaconConnected()) ...[
          // if (!Helper.isValueNullOrEmpty(file.beaconOrderDetails))
          //   FileListingQuickActionOptions.viewBeaconOrderDetails
          if (Helper.isValueNullOrEmpty(file.beaconOrderDetails) && hasGeneratedBeaconOrder)
            FileListingQuickActionOptions.placeBeaconOrder,
        ],

        if (file.isWorkSheet! && Helper.isSupplierHaveABCItem(file.worksheet?.suppliers)
            && ConnectedThirdPartyService.isAbcConnected()
            && Helper.isABCSupplierId(file.forSupplierId)
            && file.abcOrderDetail == null
        ) ...[
            FileListingQuickActionOptions.placeABCOrder,
        ],

        if(file.deliveryDateModel != null)...{
          FileListingQuickActionOptions.viewDeliveryDate
        } else if(FilesListingService.isAbcOrderForm(file.worksheet?.suppliers))...{
          FileListingQuickActionOptions.setDeliveryDate,
        },

      if(file.myFavouriteEntity == null && file.isWorkSheet! && !hideMaterialMarkFavorite(file))
        FileListingQuickActionOptions.markAsFavourite,
      if(isFavMarkedByMe && file.isWorkSheet! &&  !hideMaterialMarkFavorite(file))
        FileListingQuickActionOptions.unMarkAsFavourite,

        FileListingQuickActionOptions.rename,
        if (file.jpThumbType == JPThumbType.image)
          FileListingQuickActionOptions.rotate,
        FileListingQuickActionOptions.print,

        if(!FileListingQuickActionHelpers.checkIfAllSelectedFilesAreImages(params)) ...{
          FileListingQuickActionOptions.sendViaText,
        } else ...{
          FileListingQuickActionOptions.sendViaJobProgress,
        },

      if (params.fileList.first.jpThumbType == JPThumbType.image && !AuthService.isPrimeSubUser())
        FileListingQuickActionOptions.share,
      if(!CommonConstants.restrictFolderStructure) FileListingQuickActionOptions.move,
      FileListingQuickActionOptions.delete,
      FileListingQuickActionOptions.info,
    ];
    }

    List<JPQuickActionModel> folderQuickActions = file.locked == 1 ? [] : [
      FileListingQuickActionOptions.rename,
      FileListingQuickActionOptions.delete,
    ];

    return {
      fileActions: quickActionList,
      folderActions: folderQuickActions,
    };
  }

  static Map<String, List<JPQuickActionModel>> getWorkOrderActions(
      FilesListingQuickActionParams params) {

    FilesListingModel file = params.fileList.first;
    bool hideEdit = hideMaterialEdit(file) || Helper.isTrue(file.isFile);
    bool hasSchedulesLinked = file.schedules != null && file.schedules!.isNotEmpty;
    bool canShowLinkedEstimate = Helper.isTrue(PermissionService.hasUserPermissions([PermissionConstants.manageEstimates]));
    bool isFavMarkedByMe = AuthService.userDetails?.id.toString() == file.myFavouriteEntity?.markedBy.toString();
    List<JPQuickActionModel> quickActionList = [];

    if(file.type == ResourceType.unsavedResource) {
      quickActionList = [
        FileListingQuickActionOptions.editUnsavedResource,
        FileListingQuickActionOptions.deleteUnsavedResource,
      ];
    } else {
      quickActionList = [
        FileListingQuickActionOptions.email,
        if (PhasesVisibility.canShowSecondPhase && !hideEdit) FileListingQuickActionOptions.editWorksheet,
        if (canShowLinkedEstimate && file.isWorkOrder! && file.linkedEstimate != null)
          FileListingQuickActionOptions.viewLinkedEstimate,
        if (file.isWorkOrder! && file.linkedWorkProposal != null)
          FileListingQuickActionOptions.viewLinkedForm,
        if (file.isWorkOrder! && file.linkedWorkOrder != null)
          FileListingQuickActionOptions.viewLinkedWorkOrder,
        if (file.isWorkOrder! && file.linkedMeasurement != null)
          FileListingQuickActionOptions.viewLinkedMeasurement,
        if (file.isWorkOrder! && file.linkedMaterialLists != null)
          FileListingQuickActionOptions.viewLinkedMaterialList(materials: file.linkedMaterialLists),
        if (hasSchedulesLinked)
          FileListingQuickActionOptions.viewLinkedJobSchedules,
        FileListingQuickActionOptions.assignTo,
        if(file.status == 'completed')...{
          FileListingQuickActionOptions.markAsPending,
        } else...{
          FileListingQuickActionOptions.markAsCompleted,
        },
        if (isFavMarkedByMe && file.isWorkSheet!)
          FileListingQuickActionOptions.unMarkAsFavourite,
        if(file.myFavouriteEntity == null && file.isWorkSheet!)
          FileListingQuickActionOptions.markAsFavourite,

        FileListingQuickActionOptions.rename,
        if (file.jpThumbType == JPThumbType.image)
          FileListingQuickActionOptions.rotate,
        FileListingQuickActionOptions.print,
        if(PermissionService.hasUserPermissions([PermissionConstants.manageJobSchedule]) && !hasSchedulesLinked)
          FileListingQuickActionOptions.schedule,
        if(!FileListingQuickActionHelpers.checkIfAllSelectedFilesAreImages(params)) ...{
          FileListingQuickActionOptions.sendViaText
        } else ...{
          FileListingQuickActionOptions.sendViaJobProgress,
        },
        if(params.fileList.first.jpThumbType == JPThumbType.image && !AuthService.isPrimeSubUser())
          FileListingQuickActionOptions.share,
        if(!CommonConstants.restrictFolderStructure) FileListingQuickActionOptions.move,
        FileListingQuickActionOptions.delete,
        FileListingQuickActionOptions.info,
      ];
    }

    List<JPQuickActionModel> folderQuickActions = file.locked == 1 ? [] : [
      FileListingQuickActionOptions.rename,
      FileListingQuickActionOptions.delete,
    ];

    return {
      fileActions: quickActionList,
      folderActions: folderQuickActions,
    };
  }

  static Map<String, List<JPQuickActionModel>> getStageResourcesActionList(
      FilesListingQuickActionParams params) {
    bool hasManagePermission = PermissionService.hasUserPermissions([PermissionConstants.manageResourceViewer]);
    List<JPQuickActionModel> quickActionList = [
      FileListingQuickActionOptions.email,
      if(hasManagePermission)...{
        if (!params.isInSelectionMode!) FileListingQuickActionOptions.rename,
      },
      if (!params.isInSelectionMode!) FileListingQuickActionOptions.print,
      if(hasManagePermission)...{
        if (!FileListingQuickActionHelpers.checkIfAllSelectedFilesAreImages(params)) ...{
          FileListingQuickActionOptions.rotate,
          if(params.fileList.length == 1)
            FileListingQuickActionOptions.sendViaText,
        },
      } else if (!params.isInSelectionMode!) ...{
        FileListingQuickActionOptions.sendViaJobProgress
      },
      FileListingQuickActionOptions.copyToJob,
      if(hasManagePermission)...{
        if ((!params.isInSelectionMode! && params.fileList.first.jpThumbType == JPThumbType.image)) FileListingQuickActionOptions.share,
        if (!params.isInSelectionMode!) FileListingQuickActionOptions.expiresOn,
        FileListingQuickActionOptions.delete,
      },
      if (!params.isInSelectionMode!) FileListingQuickActionOptions.info,
    ];

    return {
      fileActions: quickActionList,
      folderActions: [],
    };
  }

  static Map<String, List<JPQuickActionModel>> getUserDocumentsActionsList(
      FilesListingQuickActionParams params) {
    List<JPQuickActionModel> quickActionList = [
      if (!params.isInSelectionMode!) FileListingQuickActionOptions.rename,
      if (!params.isInSelectionMode!) FileListingQuickActionOptions.print,
      // if (!params.isInSelectionMode!) FileListingQuickActionOptions.copyToJob,
      FileListingQuickActionOptions.move,
      if (!FileListingQuickActionHelpers.checkIfAllSelectedFilesAreImages(params))
        FileListingQuickActionOptions.rotate,
      if (params.fileList.first.jpThumbType == JPThumbType.image)
        FileListingQuickActionOptions.share,
      if (!params.isInSelectionMode!) FileListingQuickActionOptions.expiresOn,
      FileListingQuickActionOptions.delete,
      if (!params.isInSelectionMode!) FileListingQuickActionOptions.info,
    ];

    List<JPQuickActionModel> folderQuickActions = [
      if (params.fileList.first.locked == 0) FileListingQuickActionOptions.rename,
      if (params.fileList.first.locked == 0) FileListingQuickActionOptions.delete,
    ];

    return {
      fileActions: quickActionList,
      folderActions: folderQuickActions,
    };
  }

  static Map<String, List<JPQuickActionModel>> getCustomerFilesActionsList(
      FilesListingQuickActionParams params) {

    final file = params.fileList.first;
    final customer = params.customerModel;

    bool isCustomerJobFeatureAllowed = FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.customerJobFeatures]);

    List<JPQuickActionModel> quickActionList = [

      if (!params.isInSelectionMode! && file.isShownOnCustomerWebPage! && PermissionService.hasUserPermissions(['share_customer_web_page']) && isCustomerJobFeatureAllowed)
        FileListingQuickActionOptions.removeFromCustomerWebPage,
      if (!params.isInSelectionMode! && !file.isShownOnCustomerWebPage! && (customer != null && customer.isBidCustomer == false) && PermissionService.hasUserPermissions(['share_customer_web_page']) && isCustomerJobFeatureAllowed)
        FileListingQuickActionOptions.showOnCustomerWebPage,

      if (!params.isInSelectionMode!) FileListingQuickActionOptions.rename,
      if (!params.isInSelectionMode!) FileListingQuickActionOptions.print,
      // if (!params.isInSelectionMode!) FileListingQuickActionOptions.copyToJob,
      if(!CommonConstants.restrictFolderStructure) FileListingQuickActionOptions.move,
      if (!FileListingQuickActionHelpers.checkIfAllSelectedFilesAreImages(params))
        FileListingQuickActionOptions.rotate,
      if (params.fileList.first.jpThumbType == JPThumbType.image)
        FileListingQuickActionOptions.share,
      if (!params.isInSelectionMode!) FileListingQuickActionOptions.expiresOn,
      FileListingQuickActionOptions.delete,
      if (!params.isInSelectionMode!) FileListingQuickActionOptions.info,
    ];

    List<JPQuickActionModel> folderQuickActions = [
      if (params.fileList.first.locked == 0) FileListingQuickActionOptions.rename,
      if (params.fileList.first.locked == 0) FileListingQuickActionOptions.delete,
    ];

    return {
      fileActions: quickActionList,
      folderActions: folderQuickActions,
    };
  }

  static Map<String, List<JPQuickActionModel>> getCumulativeInvoicesList(
      FilesListingQuickActionParams params) {
    List<JPQuickActionModel> quickActionList = [
      FileListingQuickActionOptions.viewCumulativeInvoice,
      FileListingQuickActionOptions.printCumulativeInvoice,
      FileListingQuickActionOptions.emailCumulativeInvoice,
      FileListingQuickActionOptions.cumulativeInvoiceNote,
    ];
    return {
      fileActions: quickActionList,
    };
  }

  static List<JPQuickActionModel> getWorksheetAction(FilesListingQuickActionParams params, {
    bool excludeProposal = false
  }) {

    final file = params.fileList.first;
    bool isSubContractorPrime =  AuthService.isPrimeSubUser(); 
    bool hasSRSItem = Helper.isSupplierHaveSrsItem(file.worksheet?.suppliers);
    bool hasBeaconItem = Helper.isSupplierHaveBeaconItem(file.worksheet?.suppliers);
    bool hasABCItem = Helper.isSupplierHaveABCItem(file.worksheet?.suppliers);
    bool hasSRSOrderLinked = file.hasLinkedMaterialItem(key: CommonConstants.srsId);
    bool hasBeaconOrderLinked = file.hasLinkedMaterialItem(key: CommonConstants.beaconId);
    bool hasABCOrderLinked = file.hasLinkedMaterialItem(key: CommonConstants.abcSupplierId);
    bool hasMaterialListOrderLinked = file.hasLinkedMaterialItem();
    bool isMultiJob = params.jobModel?.isMultiJob ?? false;
    bool isProject = params.jobModel?.isProject ?? false;
    bool canManageProposal = PermissionService.hasUserPermissions([PermissionConstants.manageProposals]);
    bool hasMultipleItems = (file.linkedMaterialLists?.length ?? 0) > 1;
    bool showGenerateSRSOrderForm = !isSubContractorPrime && !hasSRSOrderLinked && hasSRSItem;
    bool showGenerateBeaconOrderForm = !isSubContractorPrime && !hasBeaconOrderLinked && hasBeaconItem;
    bool showGenerateABCOrderForm = !isSubContractorPrime && !hasABCOrderLinked && hasABCItem;
    bool isProductionFeatureAllowed = FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.production]);
    bool hasAnyOrderLinked = (hasSRSOrderLinked || hasMaterialListOrderLinked || hasBeaconOrderLinked || hasABCOrderLinked);
    
    bool canCreateDocumentWorksheet = !isSubContractorPrime || PermissionService.hasUserPermissions([PermissionConstants.createDocumentWorksheet]);
    bool canCreateWorkOrder = !isSubContractorPrime || PermissionService.hasUserPermissions([PermissionConstants.createWorkOrder]);
    bool canCreateMaterialsWorksheet = !isSubContractorPrime || PermissionService.hasUserPermissions([PermissionConstants.createMaterialsWorksheet]);
    bool hasAnyItemOrCreateAccess = (hasBeaconItem || hasSRSItem || hasABCItem || canCreateMaterialsWorksheet);
    return [
      if (!isMultiJob) ...{

        /// View Actions
        if (hasAnyOrderLinked) ...{
          if (!hasMultipleItems) ...{
            if (hasSRSOrderLinked) FileListingQuickActionOptions.viewLinkedSRSOrderForm(file.linkedMaterialLists?.first.filePath),
            if (hasBeaconOrderLinked) FileListingQuickActionOptions.viewLinkedBeaconOrderForm(file.linkedMaterialLists?.first.filePath),
            if (hasABCOrderLinked) FileListingQuickActionOptions.viewLinkedABCOrderForm(file.linkedMaterialLists?.first.filePath),
          },
          if (hasMaterialListOrderLinked) FileListingQuickActionOptions.viewLinkedMaterialList(materials: file.linkedMaterialLists)
        } else if (!(file.linkedMaterialLists == null && hasSRSItem)) ...{
          if (hasMaterialListOrderLinked) FileListingQuickActionOptions.viewLinkedMaterialList(materials: file.linkedMaterialLists)
        },

        if (file.linkedWorkOrder != null) FileListingQuickActionOptions.viewLinkedWorkOrder,
        if (!excludeProposal && file.linkedWorkProposal != null) FileListingQuickActionOptions.viewLinkedForm,

        /// Generate Actions
        if (hasAnyOrderLinked) ...{
          if (isProductionFeatureAllowed) ...{
            if (showGenerateSRSOrderForm) FileListingQuickActionOptions.generateSRSOrderForm,
            if (showGenerateBeaconOrderForm) FileListingQuickActionOptions.generateBeaconOrderForm,
            if (showGenerateABCOrderForm) FileListingQuickActionOptions.generateABCOrderForm,
            if (!hasMaterialListOrderLinked) FileListingQuickActionOptions.generateMaterialList
          },
        } else if (file.linkedMaterialLists == null && isProductionFeatureAllowed && hasAnyItemOrCreateAccess) ...{
          FileListingQuickActionOptions.materialList(hasSRSItem, hasBeaconItem, hasABCItem, canCreateMaterialsWorksheet)
        } else ...{
          if (!hasMaterialListOrderLinked && isProductionFeatureAllowed && canCreateMaterialsWorksheet) FileListingQuickActionOptions.generateMaterialList,
        },

        if (file.linkedWorkOrder == null && isProductionFeatureAllowed && canCreateWorkOrder) FileListingQuickActionOptions.generateWorkOrder,
        if (!excludeProposal  && !isProject)
          if (file.linkedWorkProposal == null && canManageProposal && canCreateDocumentWorksheet) FileListingQuickActionOptions.generateFormProposal,
      },

      if(!excludeProposal && !isProject)...{
        if (canManageProposal && file.linkedWorkProposal == null && canCreateDocumentWorksheet) FileListingQuickActionOptions.generateFormProposal,
        if (file.linkedWorkProposal != null) FileListingQuickActionOptions.viewLinkedForm,
      }
      
    ];
  }

  static List<JPSingleSelectModel> jobProposalStatusList = [
    JPSingleSelectModel(label: 'draft'.tr, id: 'draft'),
    JPSingleSelectModel(label: 'sent'.tr, id: 'sent'),
    JPSingleSelectModel(label: 'viewed'.tr, id: 'viewed'),
    JPSingleSelectModel(label: 'accepted'.tr, id: 'accepted'),
    JPSingleSelectModel(label: 'rejected'.tr, id: 'rejected'),
  ];

  static bool getUserShowOnPagePermission() {
    return PermissionService.hasUserPermissions(['share_customer_web_page']);
  }

  static isNormalMeasurement(FilesListingModel file) {
    return file.evOrder == null
        && file.smOrder == null
        && file.hoverJob == null
        && file.quickMeasureOrder == null;
  }
}
