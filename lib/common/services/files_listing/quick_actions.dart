import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/job_financial_listing.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/models/popover_action.dart';
import 'package:jobprogress/common/models/suppliers/suppliers.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_model.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_dialogs.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_handlers.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_helpers.dart';
import 'package:jobprogress/common/services/files_listing/quick_actions_list.dart';
import 'package:jobprogress/common/services/job_financial/quick_action.dart';
import 'package:jobprogress/common/services/worksheet/helpers.dart';
import 'package:jobprogress/core/config/app_env.dart';
import 'package:jobprogress/core/constants/assets_files.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/connected_third_party_constants.dart';
import 'package:jobprogress/core/constants/consent_status_constants.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/constants/files_lisitng.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jobprogress/core/utils/consent_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jp_mobile_flutter_ui/Icon/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';
import '../../../core/utils/job_financial_helper.dart';

// FilesListingService is root class for FileListing Quick Actions
// It make calls to handlers or dialogs as per type
class FilesListingService {
  static List<JPQuickActionModel> rotationOptions = [
    JPQuickActionModel(
        id: FLQuickActions.clockWise90degree.toString(),
        label: '90_clockwise'.tr,
        child: const JPIcon(Icons.rotate_right, size: 20)),
    JPQuickActionModel(
        id: FLQuickActions.clockWise180degree.toString(),
        label: '180_clockwise'.tr,
        child: const JPIcon(Icons.rotate_right, size: 20)),
    JPQuickActionModel(
        id: FLQuickActions.antiClockWise90degree.toString(),
        label: '90_anti_clockwise'.tr,
        child: const JPIcon(Icons.rotate_left, size: 20)),
  ];

  static List<JPQuickActionModel> sendViaTextOptions({String? consentStatus, bool? overrideConsentStatus}) {
    return [
      JPQuickActionModel(
        id: FLQuickActions.sendViaDevice.toString(),
        label: 'send_via_device'.tr,
        child: const JPIcon(Icons.send_to_mobile_outlined, size: 20)),
      JPQuickActionModel(
        id: FLQuickActions.sendViaJobProgress.toString(),
        label: 'send_via_leap'.tr,
        disable: !haveConsent(consentStatus, overrideConsentStatus: overrideConsentStatus),
        child: Image.asset(AssetsFiles.leapFrog,scale: 0.9,)
        ),
    ];
  }

  static bool haveConsent(String? status, {bool? overrideConsentStatus}) {
    if(overrideConsentStatus != null && !overrideConsentStatus) {
      if (ConsentHelper.isTransactionalConsent()) {
        return status == ConsentStatusConstants.byPass
            || status == ConsentStatusConstants.optedIn
            || status == ConsentStatusConstants.expressConsent
            || status == ConsentStatusConstants.expressOptInPending
            || status == ConsentStatusConstants.resend;
      } else if (status != null) {
        return status == ConsentStatusConstants.byPass
            || status == ConsentStatusConstants.optedIn;
      }
      return false;
    }
    return true;
  }

  static List<JPQuickActionModel> insuranceOptions = [
    JPQuickActionModel(
      id: FLQuickActions.createInsurance.toString(),
      label: 'create'.tr.capitalize!, 
      child: const JPIcon(Icons.add_box_outlined, size: 20), 
    ),
    JPQuickActionModel(
      id: FLQuickActions.uploadInsurance.toString(),
      label: 'upload'.tr,
      child: const JPIcon(Icons.cloud_upload_outlined, size: 20),
    ),
  ];

  static List<JPQuickActionModel> invoiceOptions = [
    JPQuickActionModel(
      id: FLQuickActions.createChangeOrder.toString(),
      label: 'change_order'.tr.capitalize!,
      child: const JPIcon(Icons.change_circle_outlined, size: 20),
    ),
    JPQuickActionModel(
      id: FLQuickActions.createInvoice.toString(),
      label: 'invoice'.tr,
      child: JPIcon(JobFinancialHelper.getCurrencyIcon(), size: 20),
    ),
  ];

    static List<PopoverActionModel> getPhotoDocMoreAcion({JobModel? jobModel}) {
    List<PopoverActionModel> actionList = 
    [
      PopoverActionModel(label:'view_company_cam_photos'.tr, value: FilesListingConstants.companyCamPhotos,icon: const JPIcon(Icons.visibility_outlined, size: 20,)), 
      PopoverActionModel(label: 'unlink_company_cam'.tr, value: FilesListingConstants.unlinkCompanyCam, icon: const JPIcon(Icons.link_off_outlined, size: 20)),
      PopoverActionModel(label: 'link_job_to_company_cam'.tr, value: FilesListingConstants.linkJobToCompanyCam, icon: const JPIcon(Icons.link_outlined, size: 20)),
      PopoverActionModel(label: 'dropbox'.tr.capitalize!, value: FilesListingConstants.dropbox, icon: SvgPicture.asset(AssetsFiles.dropBox, width: 20, height: 20, colorFilter: ColorFilter.mode(JPAppTheme.themeColors.text.withValues(alpha: 0.8), BlendMode.srcIn)))
    ];

    if(!(ConnectedThirdPartyService.getConnectedPartyKey(ConnectedThirdPartyConstants.companyCam) ?? false)) {
      actionList.removeWhere((element) => element.value == FilesListingConstants.linkJobToCompanyCam);
      actionList.removeWhere((element) => element.value == FilesListingConstants.companyCamPhotos);
      actionList.removeWhere((element) => element.value == FilesListingConstants.unlinkCompanyCam);
    }
    
    if(Helper.isValueNullOrEmpty(jobModel?.meta?.companyCamId)){
      actionList.removeWhere((element) => element.value == FilesListingConstants.companyCamPhotos);
      actionList.removeWhere((element) => element.value == FilesListingConstants.unlinkCompanyCam);
    } else {
      actionList.removeWhere((element) => element.value == FilesListingConstants.linkJobToCompanyCam);
    }

    if(!(AuthService.userDetails?.isDropBoxConnected ?? false)) {
      actionList.removeWhere((element) => element.value == FilesListingConstants.dropbox);
    }

    return actionList;
  }

  static Future<void> openQuickAction(
      FilesListingQuickActionParams params) async {
    Map<String, List<JPQuickActionModel>> actions = FileListingQuickActionsList.getActions(params);
    showJPBottomSheet(
        child: (_) => JPQuickAction(
              mainList:
                  params.fileList.isEmpty || params.fileList.first.isDir == 0
                      ? actions[FileListingQuickActionsList.fileActions]!
                      : actions[FileListingQuickActionsList.folderActions]!,
              title: params.type == FLModule.cumulativeInvoices
                  ? "cumulative_invoice_actions".tr
                  : "quick_actions".tr,
              onItemSelect: (value) {
                Get.back();

                if (params.type == FLModule.financialInvoice) {
                  FinancialListingModel modal = FinancialListingModel.fromJobInvoicesJson(params.fileList[0].toJobInvoiceJson());
                  JobFinancialService.handleQuickAction(
                    val: value,
                    type: JFListingType.jobInvoicesWithoutThumb,
                    job: params.jobModel!,
                    model: modal,
                    unAppliedCreditList: params.unAppliedCreditList,
                    onActionComplete: (dynamic model, action) {
                      params.onActionComplete(
                          FilesListingModel.fromFinancialInvoiceJson(
                              model.toJobInvoiceJson()),
                          action);
                    },
                  );
                } else {
                  handleQuickAction(value, params,
                      job: params.jobModel,
                      customerModel: params.customerModel);
                }
              },
            ),
        isScrollControlled: true);
  }

  bool get canShowThankYouMailToggle => Helper.isTrue(CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.proposalThankYouEmail));

  static Future<void> handleQuickAction(
      String val, FilesListingQuickActionParams params,
      {String? phone, JobModel? job, CustomerModel? customerModel, PhoneModel? phoneModel, String? consentStatus}) async {

    if (handleMultipleUrlFiles(val, [
      FLQuickActions.viewReportsSubOption,
      FLQuickActions.viewLinkedMaterialList,
      FLQuickActions.viewLinkedSRSOrderForm,
      FLQuickActions.viewLinkedBeaconOrderForm,
      FLQuickActions.viewLinkedABCOrderForm,
      FLQuickActions.insurancePdf,
    ])) {
      return;
    }

    switch (val) {
      case 'FLQuickActions.rename':
        await Future<void>.delayed(const Duration(milliseconds: 300));
        FilesListQuickActionPopups.showRenameDialog(
            params, FLQuickActions.rename);
        break;
      case "FLQuickActions.print":
        FileListQuickActionHandlers.printFile(
            params.fileList.first, params.type,
            action: 'print');
        break;
      case "FLQuickActions.markAsCompleted":
        FilesListQuickActionPopups.showConfirmationBottomSheet(
            params, FLQuickActions.markAsCompleted);
        break;
      case "FLQuickActions.markAsPending":
        FilesListQuickActionPopups.showConfirmationBottomSheet(
            params, FLQuickActions.markAsPending);
        break;
      case "FLQuickActions.move":
        FilesListQuickActionPopups.showMoveFilePopUp(params);
        break;
      case "FLQuickActions.moveToJob":
        FileListQuickActionHandlers.navigateToJobSearch(
            params, FLQuickActions.moveToJob);
        break;
      case "FLQuickActions.editMeasurement":
        FileListQuickActionHandlers.navigateToMeasurementForm(params);
        break;
      case "FLQuickActions.editInsurance":
        FileListQuickActionHandlers.navigateToEditInsuranceForm(params);
        break;
      case "FLQuickActions.rotate":
        break;
      case "FLQuickActions.delete":
        if (FLModule.instantPhotoGallery == params.type &&
            params.fileList[0].createdBy != AuthService.userDetails!.id) {
          Helper.showToastMessage(
              "you_are_allowed_to_delete_files_added_by_you_only".tr);
          return;
        }
        FilesListQuickActionPopups.showConfirmationBottomSheet(
            params, FLQuickActions.delete);
        break;
      case "FLQuickActions.sendViaText":
        break;
      case "FLQuickActions.sendViaDevice":
        FilesListQuickActionPopups.showJobContacts(
            params: params, phone: phone);
        break;
      case "FLQuickActions.sendViaJobProgress":
        final fileToShare =
            params.fileList.isEmpty ? null : params.fileList.first;

        if (phone != null && job == null) {
          if (customerModel != null) {
            FileListQuickActionHandlers.sendViaJobProgress(
                model: fileToShare, phone: phone, customerModel: customerModel, phoneModel: phoneModel, consentStatus: consentStatus);
          } else {
            FileListQuickActionHandlers.sendViaJobProgress(
                model: fileToShare, phone: phone, phoneModel: phoneModel, consentStatus: consentStatus);
          }
        } else if (job != null) {
          FileListQuickActionHandlers.sendViaJobProgress(
              model: fileToShare, phone: phone, jobModel: job, type: params.type, phoneModel: phoneModel, consentStatus: consentStatus);
        } else {
          FileListQuickActionHandlers.sendViaJobProgress(
              model: fileToShare, jobModel: params.jobModel, type: params.type, phoneModel: phoneModel, consentStatus: consentStatus);
        }
        break;
      case "FLQuickActions.info":
        FilesListQuickActionPopups.showFileInfoPopUp(params);
        break;
      case "FLQuickActions.viewLinkedForm":
        FileListQuickActionHandlers.downloadAndOpenFile(
            params.fileList.first.linkedWorkProposal?.filePath);
        break;
      case "FLQuickActions.viewLinkedWorkOrder":
        FileListQuickActionHandlers.downloadAndOpenFile(
            params.fileList.first.linkedWorkOrder?.filePath);
        break;
      case "FLQuickActions.viewLinkedMeasurement":
        FileListQuickActionHandlers.downloadAndOpenFile(
            params.fileList.first.linkedMeasurement?.filePath);
        break;
      case "FLQuickActions.viewLinkedInvoices":
        FileListQuickActionHandlers.navigateToInvoiceListing(params);
        break;
      case "FLQuickActions.viewLinkedEstimate":
        FileListQuickActionHandlers.downloadAndOpenFile(
            params.fileList.first.linkedEstimate?.filePath);
        break;
      case "FLQuickActions.clockWise90degree":
        FileListQuickActionHandlers.rotate(params, '-90');
        break;
      case "FLQuickActions.clockWise180degree":
        FileListQuickActionHandlers.rotate(params, '180');
        break;
      case "FLQuickActions.antiClockWise90degree":
        FileListQuickActionHandlers.rotate(params, '90');
        break;
      case "FLQuickActions.share":
        FileListQuickActionHandlers.printFile(
            params.fileList.first, params.type,
            action: 'share');
        break;
      case "FLQuickActions.showOnCustomerWebPage":
        FilesListQuickActionPopups.showConfirmationBottomSheet(
            params, FLQuickActions.showOnCustomerWebPage);
        break;
      case "FLQuickActions.removeFromCustomerWebPage":
        FilesListQuickActionPopups.showConfirmationBottomSheet(
            params, FLQuickActions.removeFromCustomerWebPage);
        break;
      case "FLQuickActions.unMarkAsFavourite":
        FilesListQuickActionPopups.showConfirmationBottomSheet(
            params, FLQuickActions.unMarkAsFavourite);
        break;
      case "FLQuickActions.openPublicForm":
        FileListQuickActionHandlers.openPublicForm(params);
        break;
      case "FLQuickActions.makeACopy":
        await Future<void>.delayed(const Duration(milliseconds: 300));
        FilesListQuickActionPopups.showRenameDialog(
            params, FLQuickActions.makeACopy);
        break;
      case "FLQuickActions.updateStatus":
        FilesListQuickActionPopups.showFilterList(params);
        break;
      case "FLQuickActions.formProposalNote":
        FilesListQuickActionPopups.showTextAreaDialog(
            params, FLQuickActions.formProposalNote);
        break;
      case "FLQuickActions.edit":
        FileListQuickActionHandlers.editImage(params);
        break;
      case "FLQuickActions.editGoogleSheet":
        Helper.launchUrl(params.fileList.first.googleSheetLink!,isInExternalMode: false);
        break;  
      case "FLQuickActions.email":
        if (params.jobModel != null) {
          await FileListQuickActionHandlers.email(
              type: params.type,
              model: params.fileList,
              jobId: params.jobModel!.id,
              email: params.jobModel!.customer!.email,
              fullName: params.jobModel!.customer!.fullName,
            onEmailSent: () => params.onActionComplete(params.fileList.first, FLQuickActions.email));
        } else {
          await FileListQuickActionHandlers.email(
              type: params.type, model: params.fileList,
              onEmailSent: () => params.onActionComplete(params.fileList.first, FLQuickActions.email));
        }
        break;
      case "FLQuickActions.generateJobInvoice":
        FileListQuickActionHandlers.generateJobInvoice(params);
        break;
      case "FLQuickActions.generateMaterialList":
        FileListQuickActionHandlers.generateWorksheet(params, type: WorksheetConstants.materialList);
        break;
      case "FLQuickActions.generateSRSOrderForm":
        FileListQuickActionHandlers.generateWorksheet(params, type: WorksheetConstants.srsMaterialList);
        break;
      case "FLQuickActions.generateBeaconOrderForm":
        FileListQuickActionHandlers.generateWorksheet(params, type: WorksheetConstants.beaconMaterialList);
        break;
      case "FLQuickActions.generateABCOrderForm":
        FileListQuickActionHandlers.generateWorksheet(params, type: WorksheetConstants.abcMaterialList);
        break;
      case "FLQuickActions.generateWorkOrder":
        FileListQuickActionHandlers.generateWorksheet(params, type: WorksheetConstants.workOrder);
        break;
      case "FLQuickActions.syncWithQBD":
        Helper.showToastMessage('to_be_implemented'.tr);
        //TODO: FilesListing (Quick Actions): syncWithQBD quick action pending
        break;
      case "FLQuickActions.updateJobInvoice":
        FileListQuickActionHandlers.updateJobInvoice(params);
        break;
      case "FLQuickActions.markAsFavourite":
        FilesListQuickActionPopups.showMarkAsFavouriteDialog(params);
        break;
      case "FLQuickActions.generateForm":
        FileListQuickActionHandlers.generateWorksheet(params, type: WorksheetConstants.proposal);
        break;
      case "FLQuickActions.expireOn":
        FilesListQuickActionPopups.showExpireOnDialog(params);
        break;
      case "FLQuickActions.viewMeasurementValues":
        FileListQuickActionHandlers.navigateToViewMeasurementForm(params);
        break;
      case "FLQuickActions.open3DModel":
        Helper.openHoverApp(
          params.fileList.first.hoverJob!.hoverJobId.toString(),
          '3d',
        );
        break;
      case "FLQuickActions.viewReports":
        break;
      case "FLQuickActions.viewInfo":
        Helper.openHoverApp(
          params.fileList.first.hoverJob!.hoverJobId.toString(),
          'details',
        );
        break;
      case "FLQuickActions.hoverImages":
        FileListQuickActionHandlers.openHoverImages(params);
        break;
      case "FLQuickActions.setDeliveryDate":
        FilesListQuickActionPopups.showSetViewDeliveryDateDialog(
            params, FLQuickActions.setDeliveryDate);
        break;
      case "FLQuickActions.schedule":
        FileListQuickActionHandlers.navigateToSchedule(params, params.jobModel!);
        break;
      case "FLQuickActions.copyToJob":
        FileListQuickActionHandlers.navigateToJobSearch(
            params, FLQuickActions.copyToJob);
        break;
      case "FLQuickActions.view":
        FileListQuickActionHandlers.viewFile(
            params.fileList.first, params.type);
        break;
      case "FLQuickActions.viewCumulativeInvoice":
        FileListQuickActionHandlers.viewFile(
            FilesListingModel(jobId: params.jobModel?.id), params.type,
            action: 'view');
        break;
      case "FLQuickActions.printCumulativeInvoice":
        FileListQuickActionHandlers.printFile(
            FilesListingModel(jobId: params.jobModel?.id), params.type,
            action: 'print');
        break;

      case "FLQuickActions.emailCumulativeInvoice":
        FileListQuickActionHandlers.email(
            type: params.type,
            model: [FilesListingModel(jobId: params.jobModel?.id)],
            jobId: params.jobModel!.id,
            email: params.jobModel!.customer!.email,
            fullName: params.jobModel!.customer!.fullName);
        break;
      case "FLQuickActions.cumulativeInvoiceNote":
        FileListQuickActionHandlers.cumulativeInvoiceNote(
            jobId: params.jobModel?.id,
            params: params,
            type: params.type,
            action: "fetch");
        break;
      case "FLQuickActions.viewLinkedJobSchedules":
        FileListQuickActionHandlers.navigateSchedulesListing(params);
        break;
      case "FLQuickActions.placeSRSOrder":
        FileListQuickActionHandlers.getWorksheet(params.fileList.first.worksheetId!, params, type: MaterialSupplierType.srs);
        break;
      case "FLQuickActions.placeBeaconOrder":
        FileListQuickActionHandlers.getWorksheet(params.fileList.first.worksheetId!, params, type: MaterialSupplierType.beacon);
        break;
      case "FLQuickActions.placeABCOrder":
        FileListQuickActionHandlers.getWorksheet(params.fileList.first.worksheetId!, params, type: MaterialSupplierType.abc);
        break;
      case "FLQuickActions.viewOrderDetails":
        FileListQuickActionHandlers.navigateToSupplierOrderDetail(params, type: MaterialSupplierType.srs);
        break;
      case "FLQuickActions.viewBeaconOrderDetails":
        FileListQuickActionHandlers.navigateToSupplierOrderDetail(params, type: MaterialSupplierType.beacon);
        break;
      case "FLQuickActions.viewDeliveryDate":
        FilesListQuickActionPopups.showSetViewDeliveryDateDialog(
            params, FLQuickActions.viewDeliveryDate);
        break;
      case "FLQuickActions.upgradeToHoverRoofOnly":
        FileListQuickActionHandlers.updateDeliverableStatus(params, 2);
        break;
      case "FLQuickActions.upgradeToHoverRoofComplete":
        FileListQuickActionHandlers.updateDeliverableStatus(params, 3);
        break;
      case "FLQuickActions.eagleView":
        FileListQuickActionHandlers.actionComplete(params, val);
        break;
      case "FLQuickActions.quickMeasure":
        FileListQuickActionHandlers.actionComplete(params, val);
        break;
      case "FLQuickActions.upload":
        FileListQuickActionHandlers.actionComplete(params, val);
        break;
      case "FLQuickActions.assignTo":
        FilesListQuickActionPopups.showAssignedUserBottomSheet(params);
        break;
      case "FLQuickActions.editProposalTemplate":
      case "FLQuickActions.signTemplateFormProposal":
        FileListQuickActionHandlers.navigateToProposalTemplate(params);
        break;
      case "FLQuickActions.editUnsavedResource":
        FileListQuickActionHandlers.navigateToEditUnsavedResource(params);
        break;
      case "FLQuickActions.deleteUnsavedResource":
        FileListQuickActionHandlers.navigateToDeleteUnsavedResource(params);
        break;
      case "FLQuickActions.editEstimateTemplate":
        FileListQuickActionHandlers.navigateToEstimateTemplate(params);
        break;
      case "FLQuickActions.editWorksheet":
        navigateToEditWorksheet(params);
        break;
      case "FLQuickActions.worksheetSignFormProposal":
        worksheetSignFormProposal(params);
        break;
      case "FLQuickActions.updateJobPrice":
        FilesListQuickActionPopups.showConfirmationBottomSheet(params, FLQuickActions.updateJobPrice);
        break;
      case "FLQuickActions.chooseSupplierSettings":
        FileListingQuickActionHelpers.showDialogForSupplierSettings(params);
        break;
    }
  }

  static worksheetSignFormProposal(FilesListingQuickActionParams params) {
    if(Helper.isTrue(params.fileList.first.worksheet?.pagesExist)){
      FileListQuickActionHandlers.openPublicForm(params);
    } else {
      FilesListQuickActionPopups.showSignatureDialog(params);
    }
  }

  static bool handleMultipleUrlFiles(String val, List<FLQuickActions> actions) {
    bool hasOptionWithMultipleFiles = false;

    for (FLQuickActions action in actions) {
      if (val.contains(action.toString())) {
        String url = val.replaceAll(action.toString(), '').trim();
        FileListQuickActionHandlers.downloadAndOpenFile(url);
        hasOptionWithMultipleFiles = true;
        break;
      }
    }

    return hasOptionWithMultipleFiles;
  }

  static bool isAbcOrderForm(List<SuppliersModel>? suppliers) {
    return !(suppliers?.any((supplier) =>
            supplier.id ==
            AppEnv.envConfig[CommonConstants.suppliersIds]
                [CommonConstants.abcId]) ??
        false);
  }

  // doSupportFolderStructure(): helps in identifying whether folder structure is enabled for a module or not
  static bool doSupportFolderStructure(FLModule type) {
    if (CommonConstants.restrictFolderStructure) {
      switch (type) {
        case FLModule.companyFiles:
        case FLModule.jobPhotos:
        case FLModule.companyCamProjects:
        case FLModule.companyCamProjectImages:
        case FLModule.dropBoxListing:
        case FLModule.templates:
        case FLModule.templatesListing:
        case FLModule.mergeTemplate:
        case FLModule.googleSheetTemplate:
          return true;
        default:
          return false;
      }
    } else {
      return true;
    }
  }

  static bool doShowModuleName(FLModule type){
    switch(type){
      case FLModule.estimate:
      case FLModule.jobProposal:
      case FLModule.measurements:
      case FLModule.materialLists:
      case FLModule.workOrder:
      case FLModule.jobPhotos:
      case FLModule.templates:
      case FLModule.templatesListing:
      case FLModule.mergeTemplate:
      case FLModule.googleSheetTemplate:
      case FLModule.jobContracts:
        return true;
      default:
        return false;  
    }
  }

  // moduleTypeToUploadType(): returns the upload type based on module type
  //    It is required to uniquely identify each module
  //    Helps in updating controller when files are uploaded
  static String moduleTypeToUploadType(FLModule? type) {
    type ??= FLModule.companyFiles;

    switch (type) {
      case FLModule.companyFiles:
        return FileUploadType.companyFiles;

      case FLModule.estimate:
        return FileUploadType.estimations;

      case FLModule.jobPhotos:
        return FileUploadType.photosAndDocs;

      case FLModule.jobProposal:
        return FileUploadType.formProposals;

      case FLModule.measurements:
        return FileUploadType.measurements;

      case FLModule.materialLists:
        return FileUploadType.materialList;

      case FLModule.workOrder:
        return FileUploadType.workOrder;

      case FLModule.stageResources:
        return '';

      case FLModule.userDocuments:
        return '';

      case FLModule.customerFiles:
        return '';

      case FLModule.instantPhotoGallery:
        return FileUploadType.instantPhoto;

      case FLModule.dropBoxListing:
        return FileUploadType.dropBoxList;

      case FLModule.jobContracts:
        return FileUploadType.contracts;

      default:
        return '';
    }
  }

  static Future<void> navigateToEditWorksheet(FilesListingQuickActionParams params) async {
    WorksheetModel? worksheetModel = await WorksheetHelpers.fetchWorksheet(int.tryParse(params.fileList.first.worksheetId!));

    WorksheetHelpers.checkIsNotBeaconOrBeaconAccountExist(
        worksheetModel?.beaconAccountId, (isNotBeaconOrBeaconAccountExist) async {
      if (isNotBeaconOrBeaconAccountExist) {
        FileListQuickActionHandlers.navigateToWorksheet(params);
      }
    });
  }
}
