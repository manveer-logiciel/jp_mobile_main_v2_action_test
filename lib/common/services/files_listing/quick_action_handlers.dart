import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/beacon_access_denied_type.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/insurance_form_type.dart';
import 'package:jobprogress/common/enums/invoice_form_type.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/enums/templates.dart';
import 'package:jobprogress/common/enums/worksheet.dart';
import 'package:jobprogress/common/extensions/mix_panel/extension.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/models/files_listing/hover/hover_image.dart';
import 'package:jobprogress/common/models/forms/worksheet/supplier_form_params.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/models/photo_viewer_model.dart';
import 'package:jobprogress/common/models/suppliers/srs/srs_ship_to_address.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_model.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/repositories/worksheet.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/common/services/download.dart';
import 'package:jobprogress/common/services/external_temlate_web_view/index.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_dialogs.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_repo/index.dart';
import 'package:jobprogress/common/services/job_financial/quick_action_handler.dart';
import 'package:jobprogress/common/services/worksheet/helpers.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/mix_panel/titles.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/upgrade_plan_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/photo_viewer_dialog/index.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';
import 'package:jobprogress/modules/job_financial/form/leappay_preferences/controller.dart';
import '../../../core/constants/date_formats.dart';
import '../../../core/constants/launchdarkly/flag_keys.dart';
import '../../../core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/routes/pages.dart';
import '../../../core/utils/date_time_helpers.dart';
import '../../../core/utils/form/unsaved_resources_helper/unsaved_resources_helper.dart';
import '../../../global_widgets/loader/index.dart';
import '../../enums/event_form_type.dart';
import '../../enums/page_type.dart';
import '../../enums/unsaved_resource_type.dart';
import '../../models/worksheet/response.dart';
import '../../repositories/job_financial.dart';
import '../launch_darkly/index.dart';
import 'quick_action_helpers.dart';

// FileListQuickActionHandlers separates API calls as per type of FilesListing
// This class contains function to every quick action
class FileListQuickActionHandlers {
  static String folderPath = 'Files'; // name of the folder where all files will stored on device

  static Future<dynamic> printFile(FilesListingModel model, FLModule? type, {String? action}) async {
    try {
      showJPLoader(msg: 'downloading_file'.tr);

      switch (type) {
        case FLModule.dropBoxListing:
          String token = await AuthService.getAccessToken();
          model.originalFilePath = '${Urls.dropBoxDownLoading}?file_id=${model.id}&access_token=$token';

          String fileName = FileHelper.getFileName(model.name!);
          await DownloadService.downloadFile(model.originalFilePath!, fileName, action: action, classType: model.classType);
          break;
        case FLModule.cumulativeInvoices:
          String token = await AuthService.getAccessToken();
          model.originalFilePath = '${Urls.cumulativeInvoice(model.jobId!)}?access_token=$token&download=1';

          String fileName = FileHelper.getFileName("cumulative invoice - ${model.jobId!.toString()}.pdf");
          await DownloadService.downloadFile(model.originalFilePath!, fileName, action: action, classType: model.classType);
          break;
        default:
          if (model.originalFilePath == null) return;
          String fileName = FileHelper.getFileName(model.originalFilePath!);
          await DownloadService.downloadFile(model.originalFilePath!, fileName, action: action, classType: model.classType);
          break;
      }
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  static Future<dynamic> viewFile(FilesListingModel model, FLModule? type, {String? action}) async {
    try {
      showJPLoader(msg: 'downloading_file'.tr);

      switch (type) {
        case FLModule.dropBoxListing:
          String token = await AuthService.getAccessToken();
          model.originalFilePath = '${Urls.dropBoxDownLoading}?file_id=${model.id}&access_token=$token';

          String fileName = FileHelper.getFileName(model.name!);
          await DownloadService.downloadFile(model.originalFilePath!, fileName, action: 'open', classType: model.classType);
          break;
        case FLModule.cumulativeInvoices:
          String token = await AuthService.getAccessToken();
          model.originalFilePath = '${Urls.cumulativeInvoice(model.jobId!)}?access_token=$token&download=1';

          String fileName = FileHelper.getFileName("${DateTime.now().millisecondsSinceEpoch}.pdf");
          String? filePath = await DownloadService.downloadFile(model.originalFilePath!, fileName, action: action, classType: model.classType);
          return filePath;
        case FLModule.companyCamProjectImages:
          String fileName = FileHelper.getFileName(model.originalFilePath!);
          await DownloadService.downloadFile(model.originalFilePath!, fileName, action: 'view', classType: model.classType);
          break;
        case FLModule.jobProposal:
        case FLModule.estimate:
          Helper.launchUrl(model.googleSheetLink!,isInExternalMode: false);
          break;
        default:
          return;
      }
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  static Future<FilesListingModel?> rename(FLModule type, FilesListingModel model, String newName) async {
    try {
      return await FileListingQuickActionRepo.rename(type, model, newName);
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  static Future<dynamic> email({FLModule? type, List<FilesListingModel>? model, String? email, String? fullName, int? jobId, VoidCallback? onEmailSent}) async {
    try {
      if (email != null && fullName != null) {
        if (type == FLModule.cumulativeInvoices) {
          String filePath = await viewFile(FilesListingModel(jobId: jobId), type, action: 'getFilePath');
          return await FileListingQuickActionRepo.email(
              files: model!,
              type: type!,
              email: email,
              fullName: fullName,
              jobId: jobId,
              pathList: [filePath],
              onEmailSent: onEmailSent
          );
        } else {
          return await FileListingQuickActionRepo.email(
              files: model!,
              type: type!,
              email: email,
              fullName: fullName,
              jobId: jobId,
              onEmailSent: onEmailSent
          );
        }
      } else {
        return await FileListingQuickActionRepo.email(files: model!, type: type!, onEmailSent: onEmailSent);
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> delete(FilesListingQuickActionParams params) async {
    try {
      await FileListingQuickActionRepo.delete(params).trackDeleteEvent(MixPanelEventTitle.fileDelete);
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  static Future<dynamic> markAs(FilesListingQuickActionParams params, FLQuickActions action) async {
    try {
      await FileListingQuickActionRepo.markAs(params, action);
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }


  static Future<dynamic> rotate(FilesListingQuickActionParams params, String angle,) async {
    try {
      showJPLoader();
      await FileListingQuickActionRepo.rotate(params, angle);
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  static Future<dynamic> move(FilesListingQuickActionParams params, {required int dirId}) async {
    if (params.fileList.first.parentId == dirId) {
      Helper.showToastMessage('source_and_destination_are_the_same'.tr);
      return;
    }

    try {
      await FileListingQuickActionRepo.move(params, dirId: dirId);
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  static Future<dynamic> downloadAndOpenFile(String? url, {
    String? action = 'open',
    String? classType
  }) async {
    if (url == null) return;

    try {
      showJPLoader(msg: 'downloading_file'.tr);
      String fileName = FileHelper.getFileName(url);
      await DownloadService.downloadFile(url, fileName, action: action, classType: classType);
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  /// Handles the "Send via JobProgress" action for files
  ///
  /// Opens a dialog to send files via JobProgress with consent handling
  /// [model] - File listing model to be shared
  /// [jobModel] - Optional job model associated with the file
  /// [type] - Module type of the file
  /// [phone] - Optional phone number to send the file to
  /// [customerModel] - Optional customer model associated with the phone
  /// [onTextSent] - Optional callback to be executed when text is sent
  /// [phoneModel] - Contains consent information for the phone number
  /// [consentStatus] - Current consent status for messaging the phone number
  static Future<dynamic> sendViaJobProgress({FilesListingModel? model, JobModel? jobModel, FLModule? type, String? phone, CustomerModel? customerModel, VoidCallback? onTextSent, PhoneModel? phoneModel, String? consentStatus}) async {
    FilesListQuickActionPopups.showShareFileViaJobProgressPopUp(
      model: model,
      jobModel: jobModel,
      type: type,
      phone: phone,
      customerModel: customerModel,
      onTextSent: onTextSent,
      phoneModel: phoneModel,
      consentStatus: consentStatus
    );
  }

  static Future<dynamic> showHideOnCustomerWebPage(FilesListingQuickActionParams params, FLQuickActions? action) async {
    try {
      await FileListingQuickActionRepo.showHideOnCustomerWebPage(params, action);
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  static Future<dynamic> unMarkAsFavourite(FilesListingQuickActionParams params) async {
    try {
      await FileListingQuickActionRepo.unMarkAsFavourite(params);
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  static Future<dynamic> openPublicForm(FilesListingQuickActionParams params) async {
    try {
      showJPLoader();
      await FileListingQuickActionRepo.openPublicForm(params);
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  static Future<dynamic> makeACopy(FilesListingQuickActionParams params, String newName) async {
    try {
      return await FileListingQuickActionRepo.makeACopy(params, newName);
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  static Future<dynamic> updateStatus(FilesListingQuickActionParams params, Map<String,dynamic> args) async {
    try {
      await FileListingQuickActionRepo.updateStatus(params, args);
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  static Future<dynamic> formProposalNote(FilesListingQuickActionParams params, String newNote) async {
    try {
      await FileListingQuickActionRepo.formProposalNote(params, newNote);
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  static void openHoverImages(FilesListingQuickActionParams params) {
    List<PhotoDetails> imageList = [];

    for (HoverImage file in params.fileList.first.hoverJob!.hoverImages!) {
      imageList.add(PhotoDetails('hover_images'.tr, urls: [file.url!], id: file.id!.toString()));
    }

    showJPGeneralDialog(
      child: (_) {
        return PhotosViewerDialog(data: PhotoViewerModel<FilesListingController>(0, imageList),);
      },
      allowFullWidth: true,
    );
  }

  static Future<dynamic> updateDeliverableStatus(FilesListingQuickActionParams params, int status) async {
    try {
      showJPLoader();
      await FileListingQuickActionRepo.updateDeliverableStatus(params, status);
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  static Future<dynamic>? navigateToJobSearch(FilesListingQuickActionParams params, FLQuickActions flQuickActions) {
    List<String> fileIds = params.fileList.map((file) => file.id!).toList();

    if (flQuickActions == FLQuickActions.copyToJob || flQuickActions == FLQuickActions.moveToJob) {
      return Get.toNamed(Routes.customerJobSearch, arguments: {
        NavigationParams.pageType: PageType.fileListing,
        NavigationParams.fileId: fileIds,
        NavigationParams.flModule: params.type
      })?.then((value) {
        params.onActionComplete(params.fileList.first,
            flQuickActions == FLQuickActions.copyToJob
                ? FLQuickActions.copyToJob
                : FLQuickActions.moveToJob);
      });
    } else {
      return null;
    }
  }

  static Future<dynamic>? navigateToMeasurementForm(FilesListingQuickActionParams params) async {
    dynamic success = await Get.toNamed(Routes.measurementForm, arguments: {
      NavigationParams.measurementId: params.fileList.first.id,
      NavigationParams.isEdit: true
    });
    if (success != null && success) {
      params.onActionComplete(params.fileList.first, FLQuickActions.editMeasurement);
    }
  }

  static Future<dynamic>? navigateToEditInsuranceForm(FilesListingQuickActionParams params) async {
    dynamic success = await Get.toNamed(Routes.insuranceForm, arguments: {
      NavigationParams.id: params.fileList.first.worksheetId,
      NavigationParams.jobModel: params.jobModel,
      NavigationParams.pageType: InsuranceFormType.edit,
    });
    if (success != null && success) {
      params.onActionComplete(params.fileList.first, FLQuickActions.editInsurance);
    }
  }

  static Future<dynamic>? navigateToPlaceOrderForm(FilesListingQuickActionParams params, {
    required MaterialSupplierType type, WorksheetModel? worksheetModel
  }) async {
    bool? isProductPriceListEmpty = await WorksheetHelpers.isProductPriceListEmpty(worksheetModel,
        type, params.fileList.first.forSupplierId, params.fileList.first.id);
    if(isProductPriceListEmpty == null) return;
    if(!isProductPriceListEmpty) {
      WorksheetHelpers.showProductAvailabilityConfirmationModal(
          placeOrder: true,
          onProceed: () {
            navigateToWorksheet(params, type: FLModule.materialLists, worksheetId: worksheetModel?.id, hidePriceDialog: true);
          }
      );
      return;
    }
    dynamic success = await Get.toNamed(
        Routes.placeSupplierOrderForm, arguments: {
      NavigationParams.id: params.fileList.first.worksheet?.id,
      NavigationParams.jobId: params.jobModel?.id,
      NavigationParams.jobModel: params.jobModel,
      NavigationParams.supplierType: type,
      NavigationParams.forSupplierId: params.fileList.first.forSupplierId,
      NavigationParams.deliveryDate: params.fileList.first.deliveryDateModel?.deliveryDate
    }
    );
    if (success != null && success) {
      FLQuickActions flQuickActionType = getSupplierFlQuickActionType(type);

      params.onActionComplete(params.fileList.first, flQuickActionType);
    }
  }

  static Future<dynamic>? navigateToProposalTemplate(FilesListingQuickActionParams params) async {
    if(AuthService.hasExternalTemplateUser()) {
      String url = await ExternalTemplateWebViewService.getEditTemplateUrl(params);
      debugPrint("EDIT URL : $url");
      Map<String, dynamic> args = {
        NavigationParams.operationType : 'edit',
        NavigationParams.url : url
      };
      dynamic result = await Get.toNamed(Routes.externalTemplateWebView,arguments: args);
      if((result is bool) ? result : result != null){
        params.onActionComplete(FilesListingModel(),params.type);
      }
    } else {
      bool isMerge = params.fileList.first.insuranceEstimate ?? false;

      Map<String, dynamic> args = {
        NavigationParams.jobId: params.jobModel?.id,
        if(!isMerge) ...{
          NavigationParams.templateType: ProposalTemplateFormType.edit,
          NavigationParams.templateId: params.fileList.first.id
        } else...{
          NavigationParams.proposalType: ProposalTemplateFormType.edit,
          NavigationParams.id: int.tryParse(params.fileList.first.id ?? "0"),
        }
      };

      dynamic success = await Get.toNamed(isMerge
          ? Routes.formProposalMergeTemplate
          : Routes.formProposalTemplate, arguments: args);

      if ((success is bool) ? success : success != null) {
        params.onActionComplete(params.fileList.first, FLQuickActions.editProposalTemplate);
      }
    }

  }

  static Future<void> navigateToEstimateTemplate(FilesListingQuickActionParams params) async {
    Map<String, dynamic> args = {
      NavigationParams.jobId: params.jobModel?.id,
      NavigationParams.handwrittenTemplateType: EstimateTemplateFormType.edit,
      NavigationParams.templateId: params.fileList.first.id.toString(),
    };

    final success = await Get.toNamed(Routes.handWrittenTemplate, arguments: args);

    if (success != null && success) {
      params.onActionComplete(params.fileList.first, FLQuickActions.handwrittenTemplate);
    }
  }

  static Future<dynamic>? navigateToWorksheet(FilesListingQuickActionParams params, {
    FLModule? type,
    int? worksheetId,
    bool? hidePriceDialog,
    bool removeIntegratedSupplierItems = false,
    MaterialSupplierFormParams? materialSupplierFormParams,
    bool showVariationConfirmationValidation = false
  }) async{

    dynamic success = await Get.toNamed(Routes.worksheetForm, arguments: {
      NavigationParams.jobId: params.jobModel?.id,
      NavigationParams.worksheetType: type ?? params.type,
      NavigationParams.worksheetId: worksheetId ?? int.tryParse(params.fileList.first.worksheetId ?? ""),
      NavigationParams.worksheetFormType: WorksheetFormType.edit,
      NavigationParams.hidePriceDialog: hidePriceDialog,
      NavigationParams.removeIntegratedSupplierItems: removeIntegratedSupplierItems,
      NavigationParams.materialSupplierFormParams: materialSupplierFormParams,
      NavigationParams.showVariationConfirmationValidation: showVariationConfirmationValidation
    });

    if(worksheetId != null || (success is bool) ? success : success != null){
      params.onActionComplete(params.fileList.first, FLQuickActions.editWorksheet);
    }
  }

  static Future<void> editImage(FilesListingQuickActionParams params) async {
    dynamic result = await Get.toNamed(
      Routes.imageEditor,
      arguments: {
        'id': params.fileList.first.id,
        'module': params.type,
        'title': params.fileList.first.name ?? "",
        'jobId': params.jobModel?.id,
        NavigationParams.parentId: params.fileList.first.parentId.toString(),
      },
    );

    if(result != null) {
      if(Helper.isTrue(result["save_as"])) {
        params.onActionComplete(params.fileList.first, FLQuickActions.makeACopy);
      } else {
        params.onActionComplete(result['file'], FLQuickActions.edit);
      }
    }
  }

  static Future<void> sendViaDevice({FilesListingModel? model, required List<String> recipients}) async {
    try {
      if(model == null) {
        Helper.sendMms(
          recipients: recipients,
        );
        return;
      }

      showJPLoader(
          msg: 'downloading_file'.tr
      );

      String fileName = FileHelper.getFileName(model.name!);
      String? filePath = await DownloadService.downloadFile(model.originalFilePath!, fileName, action: 'mms', classType: model.classType);
      Helper.sendMms(
        recipients: recipients,
        filePath: filePath,
      );
    } catch (e) {
      rethrow;
    } finally {
      if(model != null) Get.back();
    }
  }

  static Future<void> cumulativeInvoiceNote({int? jobId, FilesListingQuickActionParams? params, FLModule? type, String? action}) async {
    try {
      switch (action) {
        case "fetch":
          showJPLoader();
          await FileListingQuickActionRepo.notes(jobId, type!, action!).then((value) async {
            Get.back();
            params!.fileList.add(FilesListingModel(note: value));
            // ignore: inference_failure_on_instance_creation
            await Future.delayed(const Duration(milliseconds: 250));
            await FilesListQuickActionPopups.showTextAreaDialog(params, FLQuickActions.cumulativeInvoiceNote);
          });
          break;
        case "save":
          await FileListingQuickActionRepo.notes(params?.jobModel?.id, type!, action!, note: params?.fileList.first.note).then((value) {
            if (value) {
              Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.formProposalNote));
            }
          }).whenComplete(() => Get.back());
          break;
        default:
          break;
      }
    } catch (e) {
      rethrow;
    }
  }

  static void actionComplete(FilesListingQuickActionParams params, String action) {
    params.onActionComplete(FilesListingModel(), action);
  }

  static Future<void> navigateToEditUnsavedResource(FilesListingQuickActionParams params) async {
    dynamic result;
    switch (params.type) {
      case FLModule.jobProposal:
        if (params.fileList.first.unsavedResourceType == UnsavedResourcesHelper.getUnsavedResourcesString(UnsavedResourceType.mergeTemplate)) {
          result = await Get.toNamed(Routes.formProposalMergeTemplate, arguments: {
            NavigationParams.type: ProposalTemplateFormType.add,
            NavigationParams.jobId: params.jobModel?.id,
            NavigationParams.id: int.tryParse(params.fileList.first.id ?? "0"),
            NavigationParams.dbUnsavedResourceId: params.fileList.first.unsavedResourceId
          });
        } else if(params.fileList.first.unsavedResourceType == UnsavedResourcesHelper.getUnsavedResourcesString(UnsavedResourceType.proposalWorksheet)) {
          result = await Get.toNamed(Routes.worksheetForm, arguments: {
            NavigationParams.jobId: params.jobModel?.id,
            NavigationParams.worksheetType: params.type,
            NavigationParams.worksheetFormType: WorksheetFormType.edit,
            NavigationParams.dbUnsavedResourceId: params.fileList.first.unsavedResourceId
          });
        } else {
          result = await Get.toNamed(Routes.formProposalTemplate, arguments: {
            NavigationParams.templateType: ProposalTemplateFormType.add,
            NavigationParams.jobId: params.jobModel?.id,
            NavigationParams.templateId: params.fileList.first.id,
            NavigationParams.dbUnsavedResourceId: params.fileList.first
                .unsavedResourceId
          });
        }
        break;
      case FLModule.estimate:
        if(params.fileList.first.unsavedResourceType == UnsavedResourcesHelper.getUnsavedResourcesString(UnsavedResourceType.handWrittenTemplate)) {
          result = await Get.toNamed(Routes.handWrittenTemplate, arguments: {
            NavigationParams.jobId: params.jobModel?.id,
            NavigationParams.templateId: params.fileList.first.id.toString(),
            NavigationParams.dbUnsavedResourceId: params.fileList.first.unsavedResourceId
          });
        } else if(params.fileList.first.unsavedResourceType == UnsavedResourcesHelper.getUnsavedResourcesString(UnsavedResourceType.estimateWorksheet)) {
          result = await Get.toNamed(Routes.worksheetForm, arguments: {
            NavigationParams.jobId: params.jobModel?.id,
            NavigationParams.worksheetType: params.type,
            NavigationParams.worksheetFormType: WorksheetFormType.edit,
            NavigationParams.dbUnsavedResourceId: params.fileList.first.unsavedResourceId
          });
        }
        break;
      case FLModule.materialLists:
      case FLModule.workOrder:
        result = await Get.toNamed(Routes.worksheetForm, arguments: {
          NavigationParams.jobId: params.jobModel?.id,
          NavigationParams.worksheetType: params.type,
          NavigationParams.worksheetFormType: WorksheetFormType.edit,
          NavigationParams.dbUnsavedResourceId: params.fileList.first.unsavedResourceId
        });
        break;
      case FLModule.financialInvoice:
        WorksheetHelpers.checkIsNotBeaconOrBeaconAccountExist(params.fileList.first.beaconAccountId.toString(),
                (isNotBeaconOrBeaconAccountExist) async {
                  if(isNotBeaconOrBeaconAccountExist) {
                    result = await JobFinancialListQuickActionHandlers.navigateToInvoiceForm(
                        jobId: params.jobModel?.id,
                        unsavedResourceId: params.fileList.first.unsavedResourceId,
                        pageType: params.fileList.first.id == null
                            ? InvoiceFormType.invoiceCreateForm
                            : InvoiceFormType.invoiceEditForm
                    );
                    if (result != null) {
                      params.onActionComplete(params.fileList.first, FLQuickActions.editUnsavedResource);
                    }
                  }
                },
            type: BeaconAccessDeniedType.invoice
        );
        break;
      default:
        break;
    }

    if (result != null) {
      params.onActionComplete(params.fileList.first, FLQuickActions.editUnsavedResource);
    }
  }

  static Future<void> navigateToDeleteUnsavedResource(FilesListingQuickActionParams params) async {
    showJPLoader(msg: "deleting_auto_saved_resource");
    dynamic result = await UnsavedResourcesHelper.deleteUnsavedResource(id: params.fileList.first.unsavedResourceId ?? 0);
    Get.back();
    if (result != null) {
      params.onActionComplete(params.fileList.first, FLQuickActions.deleteUnsavedResource);
    }
  }

  static Future<dynamic>? navigateToViewMeasurementForm(FilesListingQuickActionParams params) async {
    dynamic success = await Get.toNamed(Routes.measurementForm, arguments: {
      NavigationParams.measurementId: params.fileList.first.id,
      NavigationParams.title: params.fileList.first.name,
      NavigationParams.hoverJobId: params.fileList.first.hoverJob?.hoverJobId
    });
    if (success != null && success) {
      params.onActionComplete(params.fileList.first, FLQuickActions.editMeasurement);
    }
  }
  static Future<void> navigateToSupplierOrderDetail(FilesListingQuickActionParams params, {
    MaterialSupplierType? type = MaterialSupplierType.srs,
  }) async{
    String? orderId = "";

    if (type == MaterialSupplierType.srs) {
      orderId = params.fileList.first.srsOrderDetail?.orderId;
    } else if (type == MaterialSupplierType.beacon) {
      orderId = params.fileList.first.beaconOrderDetails?.beaconOrderId;
    }

    Get.toNamed(Routes.supplierOrderDetail, arguments: {
      NavigationParams.supplierOrderId: orderId ?? "",
      NavigationParams.supplierType: type,
      NavigationParams.srsSupplierId: WorksheetHelpers.getSrsSupplierId(params.fileList.first.worksheet)
    }
    );
  }

  static Future<void> navigateToSchedule(FilesListingQuickActionParams params, JobModel jobModel) async {
    final result = await Get.toNamed(Routes.createEventForm, preventDuplicates: false, arguments: {
      NavigationParams.pageType: EventFormType.createScheduleForm,
      NavigationParams.jobModel: jobModel,
      NavigationParams.resourceId: params.fileList.first.id,
      NavigationParams.schedulesModel: jobModel.upcomingSchedules,
      NavigationParams.selectedFile: params.fileList.first,
    });

    if (result != null) {
      params.onActionComplete(FilesListingModel(), FLQuickActions.schedule);
    }
  }

  static void generateJobInvoice(FilesListingQuickActionParams quickActionParams) async {
    try {
      bool isLeapPayEnabled = ConnectedThirdPartyService.isLeapPayEnabled();
      LeapPayPreferencesController leapPayPreferencesController = LeapPayPreferencesController();

      showJPLoader(msg: "fetching_worksheet".tr);
      Map<String, dynamic> worksheetParams = {
        "includes[0]":"suppliers",
        "includes[1]":"custom_tax",
        "includes[2]":"attachments",
        "includes[3]":"material_custom_tax",
        "includes[4]":"labor_custom_tax",
        "includes[5]":"srs_ship_to_address",
        "includes[6]":"branch",
        "includes[7]":"division",
        "id": quickActionParams.fileList.first.worksheetId,
      };
      WorksheetModel? worksheetModel = await JobFinancialRepository.fetchWorkSheet(worksheetParams);
      if(worksheetModel.proposalId != null) {
        quickActionParams.fileList.first.worksheet = worksheetModel;
        final amounts = WorksheetHelpers.getFileWorksheetParams(quickActionParams.fileList.first);
        Get.back();

        WorksheetHelpers.checkIsNotBeaconOrBeaconAccountExist(
            worksheetModel.beaconAccountId, (isNotBeaconOrBeaconAccountExist) async {
          if (isNotBeaconOrBeaconAccountExist) {
            if (isLeapPayEnabled) {
              final result = await Get.toNamed(Routes.leapPayPreferences, arguments: {
                NavigationParams.changeOrderAmount : double.tryParse(amounts?['total']?.toString() ?? "0.0") ?? 0.0
              });
              if (result is LeapPayPreferencesController) {
                leapPayPreferencesController = result;
              } else {
                return;
              }
            }

            showJPLoader(msg: "creating_invoice".tr);

            Map<String, dynamic> invoiceParams = {
              "lines" : getGenerateInvoiceLineItems(worksheetModel),
              "update_job_price": "1",
              "from_worksheet": "1",
              "job_id": worksheetModel.jobId,
              "proposal_id": worksheetModel.proposalId,
              "date": DateTimeHelper.formatDate(DateTime.now().toString(), DateFormatConstants.dateOnlyFormat),
              "division_id": worksheetModel.division?.id,
              "branch_code": worksheetModel.supplierBranch?.branchCode,
              "branch_id": worksheetModel.supplierBranch?.branchId,
              "beacon_account_id": worksheetModel.beaconAccountId,
              "taxable": worksheetModel.taxable,
              "line_tax": worksheetModel.lineTax
            };
            if(worksheetModel.abcAccountModel != null) {
              invoiceParams["supplier_account_id"] = worksheetModel.abcAccountModel?.shipToId;
              invoiceParams["ship_to_sequence_number"] = "";
            } else {
              invoiceParams["ship_to_sequence_number"] = worksheetModel.shipToSequenceNumber;
            }
            invoiceParams.addAllIf(isTaxApplied(worksheetModel), getTaxParams(worksheetModel) ?? {});
            invoiceParams.addIf(isLeapPayEnabled, "leap_pay_enabled", Helper.isTrueReverse(leapPayPreferencesController.acceptingLeapPay));
            invoiceParams.addIf(isLeapPayEnabled, "payment_method", leapPayPreferencesController.getEnabledPaymentMethod());
            Map<String, dynamic> response = await JobFinancialRepository.createInvoice(invoiceParams);
            if(response["status"]) {
              Helper.showToastMessage("invoice_generated".tr);
              quickActionParams.onActionComplete(quickActionParams.fileList.first, FLQuickActions.generateJobInvoice);
            }
            Get.back();
          }
        });
      }
    } catch (e) {
      Get.back();
      rethrow;
    }
  }

  static bool isTaxApplied(WorksheetModel worksheetModel) {
    return Helper.isTrue(worksheetModel.taxable) || !Helper.isValueNullOrEmpty(worksheetModel.laborTaxRate) || !Helper.isValueNullOrEmpty(worksheetModel.materialTaxRate);
  }

  static bool getTaxAppliedType(WorksheetModel worksheetModel, SheetLineItemModel item) {
    if(!Helper.isValueNullOrEmpty(worksheetModel.laborTaxRate) && item.category?.name == WorksheetConstants.categoryLabor){
      return true;
    }
    if(!Helper.isValueNullOrEmpty(worksheetModel.materialTaxRate) && item.category?.name == WorksheetConstants.categoryMaterials){
      return true;
    }
    if(Helper.isTrue(worksheetModel.taxable)){
      return true;
    }
    return false;
  }

  /// [getGenerateInvoiceLineItems] parses the worksheet line items to api payload after
  /// deciding whether processing fee line item is to be excluded externally or not
  static List<Map<String, dynamic>> getGenerateInvoiceLineItems(WorksheetModel worksheetModel) {
    WorksheetHelpers.checkAndAddProcessingFeeItem(worksheetModel);
    return worksheetModel.lineItems?.map((item) => item.toJobProposeQuickActionJson(
        isSellingPrice: worksheetModel.isEnableSellingPrice, isTaxable: getTaxAppliedType(worksheetModel, item))).toList() ?? [];
  }

  static Map<String,dynamic>? getTaxParams(WorksheetModel worksheetModel){
    if(!Helper.isValueNullOrEmpty(worksheetModel.laborTaxRate)){
      return {
        "taxable": 1,
        "tax_rate": worksheetModel.laborTaxRate,
        "custom_tax_id": worksheetModel.laborCustomTaxId,
        "line_tax" : worksheetModel.lineTax
      };
    }
    if(!Helper.isValueNullOrEmpty(worksheetModel.materialTaxRate)){
      return {
        "taxable": 1,
        "tax_rate": worksheetModel.materialTaxRate,
        "custom_tax_id": worksheetModel.materialCustomTaxId,
        "line_tax" : worksheetModel.lineTax
      };
    }
    if(Helper.isTrue(worksheetModel.taxable)) {
      return {
        "taxable": 1,
        "tax_rate": worksheetModel.taxRate,
        "custom_tax_id": worksheetModel.customTaxId,
        "line_tax" : worksheetModel.lineTax
      };
    }
    return null;
  }

  static void updateJobInvoice(FilesListingQuickActionParams quickActionParams) async {
    try {
      bool isLeapPayEnabled = ConnectedThirdPartyService.isLeapPayEnabled();
      LeapPayPreferencesController leapPayPreferencesController = LeapPayPreferencesController();

      showJPLoader(msg: "fetching_worksheet".tr);
      Map<String, dynamic> worksheetParams = {
        "includes[0]":"suppliers",
        "includes[1]":"custom_tax",
        "includes[2]":"attachments",
        "includes[3]":"material_custom_tax",
        "includes[4]":"labor_custom_tax",
        "includes[5]":"srs_ship_to_address",
        "includes[6]":"branch",
        "includes[7]":"division",
        "id": quickActionParams.fileList.first.worksheetId,
      };
      WorksheetModel? worksheetModel = await JobFinancialRepository.fetchWorkSheet(worksheetParams);

      if(worksheetModel.proposalId != null) {
        quickActionParams.fileList.first.worksheet = worksheetModel;
        final amounts = WorksheetHelpers.getFileWorksheetParams(quickActionParams.fileList.first);
        Get.back();
        if (isLeapPayEnabled) {
          final result = await Get.toNamed(Routes.leapPayPreferences, arguments: {
            NavigationParams.changeOrderAmount : double.tryParse(amounts?['total']?.toString() ?? "0.0") ?? 0.0
          });
          if (result is LeapPayPreferencesController) {
            leapPayPreferencesController = result;
          } else {
            return;
          }
        }

        showJPLoader(msg: "updating_invoice".tr);
        Map<String, dynamic> invoiceParams = {
          "lines" : getGenerateInvoiceLineItems(worksheetModel),
          "update_job_price": "1",
          "from_worksheet": "1",
          "job_id": quickActionParams.jobModel?.id,
          "proposal_id": worksheetModel.proposalId,
          "branch_code": worksheetModel.branchCode,
          "branch_id": worksheetModel.supplierBranch?.branchId,
          "beacon_account_id": worksheetModel.beaconAccountId,
          "taxable": worksheetModel.taxable,
          "line_tax": worksheetModel.lineTax
        };
        if(worksheetModel.abcAccountModel == null) {
          invoiceParams["ship_to_sequence_number"] = worksheetModel.shipToSequenceNumber;
        } else {
          invoiceParams["supplier_account_id"] = worksheetModel.abcAccountModel?.shipToId;
          invoiceParams["ship_to_sequence_number"] = "";
        }
        invoiceParams.addAllIf(isTaxApplied(worksheetModel), getTaxParams(worksheetModel) ?? {});
        invoiceParams.addIf(isLeapPayEnabled, "leap_pay_enabled", Helper.isTrueReverse(leapPayPreferencesController.acceptingLeapPay));
        invoiceParams.addIf(isLeapPayEnabled, "payment_method", leapPayPreferencesController.getEnabledPaymentMethod());
        Map<String, dynamic> response = await JobFinancialRepository.updateInvoice(quickActionParams.jobModel?.jobInvoices?.first.id, invoiceParams);
        if(response["status"]) {
          Helper.showToastMessage("invoice_updated".tr);
          quickActionParams.onActionComplete(quickActionParams.fileList.first, FLQuickActions.updateJobInvoice);
        }
        Get.back();
      }
    } catch (e) {
      Get.back();
      rethrow;
    }
  }

  static void navigateToInvoiceListing(FilesListingQuickActionParams params) {
    Get.toNamed(Routes.filesListing, arguments: {
      NavigationParams.type: FLModule.financialInvoice,
      'jobId' : params.jobModel?.id,
      'customerId' : params.jobModel?.customerId
    }, preventDuplicates: false);
  }

  static Future<void> generateWorksheet(FilesListingQuickActionParams params, {
    String type = "",
  }) async {

    WorksheetModel? worksheet;
    bool showUpgradeDialog = await UpgradePlanHelper.showUpgradePlanOnDocumentLimit();
    if(showUpgradeDialog) {
      return;
    }
    try {
      showJPLoader(msg: 'preparing_worksheet'.tr);
      Map<String, dynamic> param = {
        "id": params.fileList.first.worksheetId,
        "includes[0]": "suppliers",
        "includes[1]": "custom_tax",
        "includes[2]": "attachments",
        "includes[3]": "material_custom_tax",
        "includes[4]": "labor_custom_tax",
        "includes[5]": "srs_ship_to_address",
        "includes[6]": "branch",
        "includes[7]": "division",
        "includes[8]": "beacon_account",
        "includes[9]": "beacon_job",
        if(LDService.hasFeatureEnabled(LDFlagKeyConstants.abcMaterialIntegration))
         "includes[10]": "supplier_account",
      };

      final response = await WorksheetRepository.getWorksheet(param);
      worksheet = response.worksheet;
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
      if (worksheet != null) {
        WorksheetHelpers.checkIsNotBeaconOrBeaconAccountExist(worksheet.beaconAccountId, (isNotBeaconOrBeaconAccountExist) async {
          if (isNotBeaconOrBeaconAccountExist) {
            FileListingQuickActionHelpers.saveWorksheet(params, worksheet!, type: type);
          }
        });
      }
    }
  }

  static Future<FilesListingModel?> signFile(FilesListingQuickActionParams params, String signature) async {
    try {
      return await FileListingQuickActionRepo.signFile(params, signature);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> updateJobPrice(FilesListingQuickActionParams params) async {
    bool isAllowedToUpdate = Helper.isTrue(await CompanySettingsService.getCompanySettingByKey(
        CompanySettingConstants.enableJobPriceRequestSubmitFeature
    ));

    Map<String, dynamic>? requestParam = WorksheetHelpers.getFileWorksheetParams(params.fileList.first);
    if (requestParam == null) return;
    if(isAllowedToUpdate) {
      requestParam.removeWhere((key, value) => key == "id");
      requestParam['job_id'] = params.jobModel?.id;
    }
    try {
      final response = await JobRepository.updateJobPrice(requestParam, isAllowedToUpdate);
      if (response != null) Helper.showToastMessage('job_price_updated'.tr);
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  static Future<void> navigateSchedulesListing(FilesListingQuickActionParams params) async {

    final file = params.fileList.first;

    final schedules = await Get.toNamed(Routes.schedulesListing, arguments: {
      NavigationParams.resourceId: file.id,
      NavigationParams.title: file.name,
      NavigationParams.jobId: params.jobModel?.id,
    });

    if (schedules is List && schedules.isEmpty) {
      file.schedules = schedules;
    }
  }

  static Future<void> getWorksheet(String worksheetId, FilesListingQuickActionParams filesListingQuickActionParams, {
    required MaterialSupplierType type
  }) async {
    try {
      showJPLoader();
      final Map<String, dynamic> params = {
        'id': worksheetId,
        'includes[0]': 'branch',
        if(LDService.hasFeatureEnabled(LDFlagKeyConstants.abcMaterialIntegration))
         'includes[1]': 'supplier_account',
      };
      WorksheetResponseModel? worksheetResponseModel = await WorksheetRepository.getWorksheet(params);

      Get.back();

      WorksheetModel worksheetModel = worksheetResponseModel.worksheet!;
      int? supplierId = filesListingQuickActionParams.fileList.first.forSupplierId;
      if(Helper.isIntegratedSupplier(supplierId)) {
        worksheetModel.lineItems = WorksheetHelpers.getParsedItems(lineItems: worksheetModel.lineItems ?? []);
      }
      worksheetModel.srsShipToAddressModel = SrsShipToAddressModel();
      bool isColorMissing = WorksheetHelpers.isColorMissing(worksheetModel);
      bool isBeaconOrABCQuantityZero = WorksheetHelpers.isBeaconOrABCQuantityZero(worksheetModel.lineItems ?? []);
      if (isColorMissing) {
        WorksheetHelpers.showConfirmation(
            title: 'srs_material_color_required'.tr,
            subTitle: 'srs_material_color_desc'.tr,
            suffixTitle: 'edit'.tr,
            onConfirmed: () {
              showBeaconAccessDeniedOrNavigateToWorksheet(worksheetModel, filesListingQuickActionParams);
            }
        );
      } else if((type == MaterialSupplierType.beacon || type == MaterialSupplierType.abc) && isBeaconOrABCQuantityZero) {
        WorksheetHelpers.showQuantityWarningDialog(
            isAbcOrder: type == MaterialSupplierType.abc,
            isFromQuickAction: true,
            onTapUpdate: () => FileListQuickActionHandlers.navigateToWorksheet(filesListingQuickActionParams));
      } else if(WorksheetHelpers.isVariationConfirmationRequired(worksheetModel.lineItems ?? [])) {
        WorksheetHelpers.showConfirmationVariationDialog(onUpdate: () {
          WorksheetHelpers.checkIsNotBeaconOrBeaconAccountExist(worksheetModel.beaconAccountId, (isBeaconConnecting) {
            if(isBeaconConnecting) {
              FileListQuickActionHandlers.navigateToWorksheet(
                  filesListingQuickActionParams,
                  showVariationConfirmationValidation: true
              );
            }
          });
        });
      } else {
        beaconLoginOrNavigateToPlaceOrder(type, filesListingQuickActionParams, worksheetModel);
      }
    } catch (e) {
      rethrow;
    }
  }

  static void showBeaconAccessDeniedOrNavigateToWorksheet(WorksheetModel worksheetModel, FilesListingQuickActionParams filesListingQuickActionParams) {
    WorksheetHelpers.checkIsNotBeaconOrBeaconAccountExist(worksheetModel.beaconAccountId, (isNotBeaconOrBeaconAccountExist) async {
      if (isNotBeaconOrBeaconAccountExist) {
        FileListQuickActionHandlers.navigateToWorksheet(filesListingQuickActionParams);
      }
    });
  }

  static void beaconLoginOrNavigateToPlaceOrder(MaterialSupplierType type, FilesListingQuickActionParams filesListingQuickActionParams, WorksheetModel worksheetModel) {
    if (Helper.isTrue(filesListingQuickActionParams.fileList.first.isBeaconOrder)
        && !AuthService.isUserBeaconConnected()) {
      WorksheetHelpers.showBeaconLoginConfirmationDialog((isBeaconConnecting) {
        if (isBeaconConnecting) {
          navigateToPlaceOrderForm(filesListingQuickActionParams, type: type, worksheetModel: worksheetModel);
        }
      });
    } else {
      navigateToPlaceOrderForm(filesListingQuickActionParams, type: type, worksheetModel: worksheetModel);
    }
  }

  static FLQuickActions getSupplierFlQuickActionType(MaterialSupplierType type) {
    if(type == MaterialSupplierType.srs) {
      return FLQuickActions.placeSRSOrder;
    } else if(type == MaterialSupplierType.beacon) {
      return FLQuickActions.placeBeaconOrder;
    } else {
      return FLQuickActions.placeABCOrder;
    }
  }
}
