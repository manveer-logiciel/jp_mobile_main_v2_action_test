import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/templates/form_proposal/template.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_model.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_handlers.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/common/services/worksheet/helpers.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jp_mobile_flutter_ui/Thumb/type.dart';
import '../../../core/constants/worksheet.dart';
import '../../models/forms/worksheet/supplier_form_params.dart';
import '../../models/suppliers/beacon/default_branch_model.dart';
import '../../models/suppliers/suppliers.dart';
import '../auth.dart';
import '../connected_third_party.dart';
import 'quick_action_dialogs.dart';
import '../quick_book.dart';

// FileListingQuickActionHelpers contains common that return something
// as per the type of quick action or module
class FileListingQuickActionHelpers {

  // getToastMessage()
  // Parameters : actions[required], params[optional]
  // 1.) actions - it is being used as a differentiator to display different message as per quick action
  // 2.) params - it contains data of the item on which quick action being performed
  static String getToastMessage(
      FLQuickActions actions, [
        FilesListingQuickActionParams? params,
        bool isDir = false,
      ]) {
    switch (actions) {
      case FLQuickActions.rename:
        if(isDir) {
          return 'folder_renamed'.tr;
        } else {
          return 'file_renamed'.tr;
        }
      case FLQuickActions.move:
        return params!.fileList.length == 1 ? 'file_moved'.tr : 'files_moved'.tr;
      case FLQuickActions.rotate:
        return params!.fileList.length == 1 ? 'image_rotated'.tr : 'images_rotated'.tr;
      case FLQuickActions.markAsCompleted:
        return 'marked_as_completed'.tr.capitalizeFirst!;
      case FLQuickActions.markAsPending:
        return 'marked_as_pending'.tr.capitalizeFirst!;
      case FLQuickActions.unMarkAsFavourite:
        return 'unmarked_as_favourite'.tr;
      case FLQuickActions.showOnCustomerWebPage:
        return 'shared_on_customer_web_page'.tr;
      case FLQuickActions.removeFromCustomerWebPage:
        return 'removed_from_customer_web_page'.tr;
      case FLQuickActions.makeACopy:
        return 'file_copied'.tr;
      case FLQuickActions.formProposalNote:
        return 'note_updated'.tr;
      case FLQuickActions.upgradeToHoverRoofOnly:
        return 'hover_deliverable_updated'.tr;
      case FLQuickActions.updateStatus:
        return 'status_updated'.tr;
      case FLQuickActions.markAsFavourite:
        return 'marked_as_favourite'.tr;
      case FLQuickActions.delete:
        if (params!.fileList.length == 1) {
          if (params.fileList.first.isDir == 1) {
            return 'directory_deleted'.tr;
          } else {
            return 'file_deleted'.tr;
          }
        }
        else {
          return 'files_deleted'.tr;
        }
      case FLQuickActions.assignTo:
        return params!.fileList.first.workOrderAssignedUser!.isEmpty ? 
          '${'users'.tr.capitalize!} ${'removed'.tr}' :
          'user_assigned'.tr.capitalizeFirst! ;
      
      default:
        return '';
    }
  }

  // getConfirmationMessage()
  // This function does the same job as getToastMessage() but it helps in displaying conformation message on dialog
  static String getConfirmationMessage(
      FilesListingQuickActionParams params, FLQuickActions action, [Map<String, dynamic>? arguments]) {
    String confirmationMessage = (params.doShowThankYouEmailToggle ?? false) ? 'do_you_wish_to_proceed'.tr : 'press_confirm_to_proceed'.tr;
    switch (action) {
      case FLQuickActions.delete:
        return deleteConfirmationMessages(params);
      case FLQuickActions.markAsCompleted:
        return markAsCompleted(params);
      case FLQuickActions.markAsPending:
        return markAsPending(params);
      case FLQuickActions.showOnCustomerWebPage:
        return 'you_are_about_to_show_this_on_customer_web_page_press_confirm_to_proceed'
            .tr;
      case FLQuickActions.removeFromCustomerWebPage:
        return 'you_are_about_to_remove_this_from_customer_web_page_press_confirm_to_proceed'
            .tr;
      case FLQuickActions.unMarkAsFavourite:
        return 'you_are_about_to_remove_this_worksheet_from_favorites_press_confirm_to_proceed'
            .tr;
      case FLQuickActions.updateStatus:
        return "${'you_are_about_to_manually_update_proposal_status_for_this_job_from'.tr} ${arguments!['oldStatus']} ${'to'.tr.toLowerCase()} ${arguments['newStatus']}. $confirmationMessage";
      case FLQuickActions.updateJobPrice:
        return "${'resource_update_job_price_desc'.tr} ${'press_confirm_to_proceed'.tr.capitalizeFirst!}";
      default:
        return '';
    }
  }

  static String markAsCompleted(FilesListingQuickActionParams params) {
    switch (params.type) {
      case FLModule.workOrder:
        return 'you_are_about_to_mark_this_workorder_as_completed_press_confirm_to_proceed'.tr;
      case FLModule.materialLists:
        return 'you_are_about_to_mark_this_material_as_completed_press_confirm_to_proceed'.tr;
      default:
        return '';
    }
  }

  static String markAsPending(FilesListingQuickActionParams params) {
    switch (params.type) {
      case FLModule.workOrder:
        return 'you_are_about_to_mark_this_workorder_as_pending_press_confirm_to_proceed'.tr;
      case FLModule.materialLists:
        return 'you_are_about_to_mark_this_material_as_pending_press_confirm_to_proceed'.tr;
      default:
        return '';
    }
  }

  static String deleteConfirmationMessages(
      FilesListingQuickActionParams params) {
    if (params.fileList.length == 1) {
      if (params.fileList.first.isDir == 1) {
        return '${'are_you_sure_you_want_to_delete'.tr} ${params.fileList.first.name} ${'directory_and_all_its_content'.tr}';
      } else {
        return '${'are_you_sure_you_want_to_delete'.tr} ${params.fileList.first.name} ?';
      }
    } else {
      return 'you_are_about_to_delete'.tr + ' ${params.fileList.length} ' + "files".tr + ". "  + 'press_confirm_to_proceed'.tr;
    }
  }

  // checkIfAllSelectedFilesAreImages()
  // This function checks whether all the selected files are images
  static bool checkIfAllSelectedFilesAreImages(
      FilesListingQuickActionParams params) {
    return params.fileList.any((FilesListingModel element) =>
    element.jpThumbType != JPThumbType.image);
  }

  // checkIfAllShowOnCustomerWebPage()
  // This function checks whether all the selected files are show on customer web page
  static bool checkIfAllShowOnCustomerWebPage(
      FilesListingQuickActionParams params) {
    return params.fileList.every((FilesListingModel element) =>
    element.isShownOnCustomerWebPage!);
  }

  // checkIfAnyShowOnCustomerWebPage()
  // This function checks whether any selected files are show on customer web page
  static bool checkIfAnyShowOnCustomerWebPage(
      FilesListingQuickActionParams params) {
    return params.fileList.any((FilesListingModel element) =>
    element.isShownOnCustomerWebPage!);
  }

  static List<FilesListingModel> getSelectedTemplates(List<FilesListingModel> resourceList) {

    List<FilesListingModel> selectedTemplates = [];

    for (FilesListingModel file in resourceList) {
      if (file.isSelected ?? false) {
        selectedTemplates.add(file);
      } else {
        List<FormProposalTemplateModel> selectedPages = file.proposalTemplatePages
            ?.where((page) => page.isSelected).toList() ?? [];
        if (selectedPages.isNotEmpty) {
          selectedTemplates.add(FilesListingModel(proposalTemplatePages: selectedPages, pageType: file.pageType));
        }
      }
    }

    return selectedTemplates;
  }

  static String flModuleToWorksheetLinkType(FLModule? type) {
    switch (type) {
      case FLModule.estimate:
        return 'estimate';

      case FLModule.jobProposal:
        return 'proposal';

      case FLModule.materialLists:
        return 'material_list';

      default:
        return "";
    }
  }

  /// [getWorksheetColorValidationMsg] gives message and description message based on the provided MaterialSupplierType.
  ///
  /// If the type is null, it returns an empty record.
  /// If the type is [MaterialSupplierType.srs], it returns the title and description messages for SRS material color.
  /// If the type is [MaterialSupplierType.beacon], it returns the title and description messages for beacon material color.
  static (String, String) getWorksheetColorValidationMsg(MaterialSupplierType? type) {
    if (type == null) return ("", "");
    switch (type) {
      case MaterialSupplierType.srs:
        return ('srs_material_color_required'.tr, 'srs_material_color_desc'.tr);
      case MaterialSupplierType.beacon:
        return ('beacon_material_color_required'.tr, 'beacon_material_color_desc'.tr);
      case MaterialSupplierType.abc:
        return ('abc_material_color_required'.tr, 'abc_material_color_desc'.tr);
    }
  }

  /// [saveWorksheet] is responsible for performing validating the generated worksheets data
  /// and opens up the save dialog if validation is passed
  static Future<void> saveWorksheet(FilesListingQuickActionParams params, WorksheetModel worksheet, {
    required String type,
  }) async {
    params.tempModule = WorksheetHelpers.typeToFLModule(type);
    worksheet.lineItems = await WorksheetHelpers.filterLineItemsByCategory(worksheet, type);
    // Skipping color check, worksheet does not have a supplier selected
    bool skipColorCheck = worksheet.supplierType == null;

    if (worksheet.lineItems?.isEmpty ?? false) return;

    bool isColorMissing = WorksheetHelpers.isColorMissing(worksheet);

    if (isColorMissing && !skipColorCheck) {
      // If color is missing, show confirmation
      final (String title, String subTitle) = getWorksheetColorValidationMsg(worksheet.supplierType);

      WorksheetHelpers.showConfirmation(
          title: title,
          subTitle: subTitle,
          suffixTitle: 'edit'.tr,
          onConfirmed: () {
            FileListQuickActionHandlers.navigateToWorksheet(params);
          }
      );
    } else if (worksheet.lineItems!.isNotEmpty) {
      FilesListQuickActionPopups.showSaveWorksheetDialog(
        worksheetType: type,
        worksheet: worksheet,
        params: params,
      );
    }
  }

  static bool canShowWorksheetInvoiceQuickActions(JobModel? job, FilesListingModel file, bool hasManagePermission, bool isInvoiceGenerated) {

    num? overhead = num.tryParse(file.worksheet?.overhead ?? '0');
    num? profit = num.tryParse(file.worksheet?.profit ?? '0');
    num? discount = num.tryParse(file.worksheet?.discount ?? '0');
    
    return Helper.isTrue(file.isWorkSheet) && !Helper.isTrue(job?.isMultiJob) 
    && hasManagePermission && (Helper.isValueNullOrEmpty(file.worksheet?.commission)
    && (Helper.isValueNullOrEmpty(file.worksheet?.discount) || discount == 0) 
    && (Helper.isValueNullOrEmpty(overhead.toString()) || overhead == 0) && (Helper.isValueNullOrEmpty(profit.toString()) || profit == 0) 
    && !(file.worksheet?.lineTax != 0) && !(file.worksheet?.lineMarginMarkup != 0)) 
    && !Helper.isTrue(job?.financialDetails?.canBlockFinancial) 
    && isInvoiceGenerated && checkIsMoreThanTwoTaxAvailable(file);

    // OLD CONDITION
    // return !(Helper.isTrue(file.isWorkSheet)) || Helper.isTrue(job?.financialDetails?.canBlockFinancial)
    //   || !Helper.isValueNullOrEmpty(file.linkedInvoicesLists) || Helper.isTrue(job?.isMultiJob) || !hasManagePermission
    //   || !Helper.isValueNullOrEmpty(job?.jobInvoices?.firstWhereOrNull((element) => element.proposalId != null))
    //   || !Helper.isValueNullOrEmpty(file.worksheet?.overhead) || !Helper.isValueNullOrEmpty(file.worksheet?.profit) || !Helper.isValueNullOrEmpty(file.worksheet?.commission)
    //   || (file.worksheet?.lineTax != 0) || (file.worksheet?.lineMarginMarkup != 0)
    //   || checkIsMoreThanTwoTaxAvailable(file);
  }

  static bool checkIsMoreThanTwoTaxAvailable(FilesListingModel file) {
    if ((QuickBookService.isQuickBookConnected() || QuickBookService.isQBDConnected())) {
      int typesOfTaxApplied = 0;
      if(Helper.isValueNullOrEmpty(file.worksheet?.laborTaxRate)) typesOfTaxApplied++;
      if(Helper.isValueNullOrEmpty(file.worksheet?.materialTaxRate)) typesOfTaxApplied++;
      if(Helper.isValueNullOrEmpty(file.worksheet?.taxRate)) typesOfTaxApplied++;

      if(typesOfTaxApplied == 1 && Helper.isValueNullOrEmpty(file.worksheet?.taxRate)) return false;
      ///   TODO - Job proposal (Invoice quick action condition): quickbookTaxCodeId is not known
      // if(typesOfTaxApplied == 1 && (file.worksheet.quickbookTaxCodeId != null)) return true;
      return typesOfTaxApplied > 1;
    } else {
      return (Helper.isTrue(file.isWorkSheet))
          && (Helper.isValueNullOrEmpty(file.worksheet?.laborTaxRate)
          && Helper.isValueNullOrEmpty(file.worksheet?.materialTaxRate));
    }
  }

  /// [getJobPrice] checks whether job price can be updated or not and returns the job price
  static String? getJobPrice(FilesListingModel? file, JobModel? job) {
    String jobPrice = JobFinancialHelper.getCurrencyFormattedValue(value: WorksheetHelpers.getFileWorksheetParams(file)?['total']);
    bool canManageFinancials = PermissionService.hasUserPermissions([PermissionConstants.manageFinancial]);
    bool canViewAndUpdateJobPrice = PermissionService.hasUserPermissions([PermissionConstants.viewFinancial, PermissionConstants.updateJobPrice], isAllRequired: true);
    bool hasJobInvoice = Helper.isValueNullOrEmpty(job?.jobInvoices);

    bool doShowUpdateJobPrice = hasJobInvoice && (canManageFinancials || canViewAndUpdateJobPrice);

    return doShowUpdateJobPrice ? jobPrice : null;
  }

  /// [isChooseSupplierSettings] checks whether the supplier settings are to be chosen or not
  /// [worksheet] is the worksheet model
  static bool isChooseSupplierSettings(WorksheetModel? worksheet) {
    final suppliers = worksheet?.suppliers;
    return (worksheet?.origin == WorksheetConstants.salesPro && suppliers != null)
        && ((Helper.isSupplierHaveSrsItem(suppliers) && worksheet?.srsShipToAddressModel == null)
            || (Helper.isSupplierHaveBeaconItem(suppliers) && worksheet?.beaconAccountId == null)
            || (Helper.isSupplierHaveABCItem(suppliers) && worksheet?.abcAccountModel == null));
  }



  /// [getSupplierType] returns the supplier type based on the suppliers
  static MaterialSupplierType? getSupplierType(List<SuppliersModel>? suppliers) {
    if(Helper.isSupplierHaveSrsItem(suppliers)) {
      return MaterialSupplierType.srs;
    } else if(Helper.isSupplierHaveBeaconItem(suppliers)) {
      return MaterialSupplierType.beacon;
    } else if(Helper.isSupplierHaveABCItem(suppliers)) {
      return MaterialSupplierType.abc;
    } else {
      return null;
    }
  }

  /// [showDialogForSupplierSettings] shows the dialog for supplier settings
  static Future<void> showDialogForSupplierSettings(FilesListingQuickActionParams params) async {
    final WorksheetModel? worksheet = params.fileList.first.worksheet;
    if(isIntegratedSupplierConnected(worksheet?.suppliers)) {
      if (getSupplierType(worksheet?.suppliers) == MaterialSupplierType.beacon && !AuthService.isUserBeaconConnected()) {
        WorksheetHelpers.showBeaconLoginConfirmationDialog((isBeaconConnecting) async {
          if(isBeaconConnecting) {
            selectIntegratedSupplierAccountBranch(worksheet, params);
          }
        });
      } else {
        selectIntegratedSupplierAccountBranch(worksheet, params);
      }
    } else {
      FilesListQuickActionPopups.showIntegratedSupplierDeactivationWarningDialog(params, getSupplierType(worksheet?.suppliers)!.name.toString().toUpperCase());
    }
  }

  /// [isIntegratedSupplierConnected] checks if the integrated supplier is connected or not
  static bool isIntegratedSupplierConnected(List<SuppliersModel>? suppliers) {
    return (Helper.isSupplierHaveSrsItem(suppliers) && ConnectedThirdPartyService.isSrsConnected())
        || (Helper.isSupplierHaveBeaconItem(suppliers) && ConnectedThirdPartyService.isBeaconConnected())
        || (Helper.isSupplierHaveABCItem(suppliers) && ConnectedThirdPartyService.isAbcConnected());
  }

  /// [get]
  static getSrsSupplierId(List<SuppliersModel>? suppliers) {
    if (!Helper.isValueNullOrEmpty(suppliers)) {
      int? supplierId = suppliers?.first.id;
      if (Helper.isSRSv1Id(supplierId) || Helper.isSRSv2Id(supplierId)) {
        return supplierId;
      }
    }
    return Helper.getSupplierId();
  }

  /// [saveDefaultBranchForIntegratedSupplier] saves the default branch for the integrated supplier
  static saveDefaultBranchForIntegratedSupplier(WorksheetModel? worksheet, MaterialSupplierFormParams materialSupplierFormParams) {
    WorksheetHelpers.saveDefaultBranchSettings(
        DefaultBranchModel(
            srsShipToAddress: materialSupplierFormParams.type == MaterialSupplierType.srs ? materialSupplierFormParams.srsShipToAddress : null,
            beaconAccount: materialSupplierFormParams.type == MaterialSupplierType.beacon ? materialSupplierFormParams.beaconAccount : null,
            abcAccount: materialSupplierFormParams.type == MaterialSupplierType.abc ? materialSupplierFormParams.abcAccount : null,
            branch: WorksheetHelpers.getSupplierBranch(
              materialSupplierFormParams.type!,
              selectedSrsBranch: materialSupplierFormParams.srsBranch,
              selectedBeaconBranch: materialSupplierFormParams.beaconBranch,
              selectedAbcBranch: materialSupplierFormParams.abcBranch,
            ),
            jobAccount: materialSupplierFormParams.beaconJob
        ),
        materialSupplierFormParams.type!
    );
  }

  /// [selectIntegratedSupplierAccountBranch] selects the integrated supplier account branch
  static Future<void> selectIntegratedSupplierAccountBranch(WorksheetModel? worksheet, FilesListingQuickActionParams params) async {
    await FilesListQuickActionPopups.showIntegratedSupplierAccountSelectionDialog(worksheet, onSupplierSelect: (materialSupplierFormParams) async {
      if(materialSupplierFormParams != null) {
        if(materialSupplierFormParams.isBranchMakeDefault) {
          await saveDefaultBranchForIntegratedSupplier(worksheet, materialSupplierFormParams);
        }
        await FileListQuickActionHandlers.navigateToWorksheet(params, materialSupplierFormParams: materialSupplierFormParams);
      }
    });
  }
}
