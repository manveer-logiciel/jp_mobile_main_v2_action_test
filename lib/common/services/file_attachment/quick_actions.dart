import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/attach_file.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/repositories/job_financial.dart';
import 'package:jobprogress/common/repositories/templates.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/common/services/file_picker.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/core/constants/connected_third_party_constants.dart';
import 'package:jobprogress/core/constants/mix_panel/event/common_events.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/upload_progress_dialog/index.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';
import 'package:jobprogress/modules/files_listing/widgets/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import 'package:jp_mobile_flutter_ui/Thumb/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../core/constants/navigation_parms_constants.dart';
import '../../../routes/pages.dart';

class FileAttachService {

  /// getQuickActions() : will filter and return quick actions
  List<JPQuickActionModel> getQuickActions({
    int? jobId, String? companyCamProjectId,
    AttachmentOptionType type = AttachmentOptionType.jobDependent,
  }) {

    bool isCompanyCamConnected = (ConnectedThirdPartyService.getConnectedPartyKey(ConnectedThirdPartyConstants.companyCam) ?? false);
    bool isWorksheetPhotos = type == AttachmentOptionType.attachWorksheetPhoto;
    bool isJobDependent = jobId != null && type == AttachmentOptionType.jobDependent;
    bool canShowGallery = (type != AttachmentOptionType.attachPhoto || type == AttachmentOptionType.imageTemplate) && !isWorksheetPhotos;
    bool isFinanceFeatureAllowed = FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.financeAndAccounting]);
    bool isProductionFeatureAllowed = FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.production]);
    
    if(type == AttachmentOptionType.srsOrderAttachment) {
      return [
         JPQuickActionModel(id: AttachFileType.gallery.toString(), child: const JPIcon(Icons.image_outlined, size: 20), label: 'gallery'.tr),
         JPQuickActionModel(id: AttachFileType.document.toString(), child: const JPIcon(Icons.description_outlined, size: 20), label: 'document'.tr),
      ];
    }
    
    return [
      if (type == AttachmentOptionType.dynamicImage) ...{
        JPQuickActionModel(id: AttachFileType.camera.toString(), child: const JPIcon(Icons.camera_alt_outlined, size: 20), label: 'camera'.tr),
      },

      if (canShowGallery) ...{
        JPQuickActionModel(id: AttachFileType.gallery.toString(), child: const JPIcon(Icons.image_outlined, size: 20), label: 'gallery'.tr),
      },

      if (type == AttachmentOptionType.jobDependent)
        JPQuickActionModel(id: AttachFileType.document.toString(), child: const JPIcon(Icons.description_outlined, size: 20), label: 'document'.tr),

      if (jobId != null || type == AttachmentOptionType.dynamicImage) ...{
        JPQuickActionModel(id: AttachFileType.photosDocument.toString(), child: const JPIcon(Icons.image_outlined, size: 20), label: 'photos_documents'.tr),
      },

      if(isJobDependent && PermissionService.hasUserPermissions([PermissionConstants.manageFinancial, PermissionConstants.viewFinancial]) && isFinanceFeatureAllowed)
        JPQuickActionModel(id: AttachFileType.invoices.toString(), child:  JPIcon(JobFinancialHelper.getCurrencyIcon(), size: 20), label: 'invoices'.tr),

      if(isJobDependent || isWorksheetPhotos) ...{
        if(PermissionService.hasUserPermissions([PermissionConstants.manageEstimates]))
          JPQuickActionModel(id: AttachFileType.estimates.toString(), child: const JPIcon(Icons.description_outlined, size: 20), label: 'estimates'.tr),

        if(PermissionService.hasUserPermissions([PermissionConstants.manageProposals, PermissionConstants.viewProposals]))
          JPQuickActionModel(id: AttachFileType.proposals.toString(), child: const JPIcon(Icons.description_outlined, size: 20), label: 'proposals'.tr),
      },

      if(jobId != null && type == AttachmentOptionType.jobDependent)...{
        JPQuickActionModel(id: AttachFileType.measurements.toString(), child: const JPIcon(Icons.square_foot, size: 20), label: 'measurements'.tr),
        JPQuickActionModel(id: AttachFileType.materials.toString(), child: const JPIcon(Icons.assignment_outlined, size: 20), label: 'materials'.tr),
        if(isProductionFeatureAllowed)
          JPQuickActionModel(id: AttachFileType.workOrders.toString(), child: const JPIcon(Icons.assignment_outlined, size: 20), label: 'work_orders'.tr),
        if(PermissionService.hasUserPermissions([PermissionConstants.manageFinancial, PermissionConstants.viewFinancial]) && isFinanceFeatureAllowed)
          JPQuickActionModel(id: AttachFileType.depositReceipts.toString(), child: const JPIcon(Icons.receipt_outlined, size: 20), label: 'deposit_receipts'.tr),
      },

      if (isCompanyCamConnected && (type == AttachmentOptionType.dynamicImage || type == AttachmentOptionType.imageTemplate))
        JPQuickActionModel(id: AttachFileType.companyCam.toString(), child: SvgPicture.asset('assets/svg/company_cam_icon.svg',
            colorFilter: ColorFilter.mode(JPAppTheme.themeColors.text, BlendMode.srcIn)),
            label: 'companycam'.tr, chipTitle: companyCamProjectId == null ? "company_cam_not_linked".tr : null),

      if(PermissionService.hasUserPermissions([PermissionConstants.manageCompanyFiles, PermissionConstants.viewCompanyFiles]) && type != AttachmentOptionType.dynamicImage)
        JPQuickActionModel(id: AttachFileType.companyFiles.toString(), child: const JPIcon(Icons.perm_media_outlined, size: 20), label: 'company_files'.tr),

      if(PermissionService.hasUserPermissions([PermissionConstants.manageResourceViewer, PermissionConstants.viewResourceViewer]))
        JPQuickActionModel(id: AttachFileType.stageResources.toString(), child: const JPIcon(Icons.folder_copy_outlined, size: 20), label: 'stage_resources'.tr),
    ];
  }

  /// openQuickActions() : Opens up the bottom sheet to select action from
  static openQuickActions({
    int? jobId,
    int? customerId,
    String? companyCamProjectId,
    bool allowMultiple = true,
    bool dirWithImageOnly = false,
    String? uploadType,
    bool isSrs = false,
    required int maxSize,
    AttachmentOptionType type = AttachmentOptionType.jobDependent,
    required Function(List<AttachmentResourceModel> selectedFiles) onFilesSelected,
  }) {
    MixPanelService.trackEvent(event: MixPanelCommonEvent.attachmentView);
    showJPBottomSheet(
        child: (_) => JPQuickAction(
          title: 'select_option'.tr.toUpperCase(),
          mainList: FileAttachService().getQuickActions(jobId: jobId, type: type, companyCamProjectId: companyCamProjectId,),
          onItemSelect: (value) {
            Get.back();
            handleQuickActions(value,
                jobId: jobId,
                customerId: customerId,
                companyCamProjectId: companyCamProjectId,
                onFilesSelected: onFilesSelected,
                allowMultiple: allowMultiple,
                dirWithImageOnly: dirWithImageOnly,
                uploadType: uploadType,
                isSrs: isSrs,
                maxSize: maxSize,
            );
          },
        ),
        isScrollControlled: true
    );
  }

  /// handleQuickActions() : Handles quick action tap
  static void handleQuickActions(String action, {
    int? jobId,
    int? customerId,
    String? companyCamProjectId,
    bool allowMultiple = true,
    bool dirWithImageOnly = false,
    String? uploadType,
    bool isSrs = false,
    required int maxSize,
    required Function(List<AttachmentResourceModel> selectedFiles) onFilesSelected,
  }) async {

    FLModule? moduleType;

    switch (action) {

      case "AttachFileType.camera":
        uploadFiles(onFilesUploaded: onFilesSelected, fromCamera: true, uploadType: uploadType, maxSize: maxSize);
        break;
      case "AttachFileType.gallery":
        uploadFiles(onFilesUploaded: onFilesSelected, onlyImages: true, allowMultiple: allowMultiple, uploadType: uploadType, maxSize: maxSize);
        break;
      case "AttachFileType.document":
        uploadFiles(onFilesUploaded: onFilesSelected, onlyImages: false, allowMultiple: allowMultiple, uploadType: uploadType, isSrs: isSrs, maxSize: maxSize);
        break;
      case "AttachFileType.invoices":
        moduleType = FLModule.attachmentInvoice;
        break;
      case "AttachFileType.depositReceipts":
        moduleType = FLModule.paymentReceipt;
        break;
      case "AttachFileType.photosDocument":
        moduleType = FLModule.jobPhotos;
        break;
      case "AttachFileType.measurements":
        moduleType = FLModule.measurements;
        break;
      case "AttachFileType.estimates":
        moduleType = FLModule.estimate;
        break;
      case "AttachFileType.proposals":
        moduleType = FLModule.jobProposal;
        break;
      case "AttachFileType.materials":
        moduleType = FLModule.materialLists;
        break;
      case "AttachFileType.workOrders":
        moduleType = FLModule.workOrder;
        break;
      case "AttachFileType.companyFiles":
        moduleType = FLModule.companyFiles;
        break;
      case "AttachFileType.stageResources":
        moduleType = FLModule.stageResources;
        break;
      case "AttachFileType.companyCam":
        if(companyCamProjectId == null) return;
        moduleType = FLModule.companyCamProjectImages;
        break;
    }

    if(moduleType != null) {
      showAttachDialog(
        moduleType,
        jobId: jobId,
        companyCamProjectId: companyCamProjectId,
        onFilesSelected: onFilesSelected,
        allowMultiple: allowMultiple,
        dirWithImageOnly: dirWithImageOnly,
        uploadType: uploadType,
      );
    }

  }

  /// showAttachDialog() : opens up files listing dialog to select/attach files
  ///                    - onFilesSelected : will return list of selected files
  static void showAttachDialog(
      FLModule type, {
        int? jobId,
        String? companyCamProjectId,
        bool allowMultiple = true,
        bool dirWithImageOnly = false,
        String? uploadType,
        required Function(List<AttachmentResourceModel> seletecedFiles) onFilesSelected,
      }) {

    showJPBottomSheet(
        child: (_) => GetBuilder<FilesListingController>(
          init: FilesListingController(
              mode: FLViewMode.attach,
              attachType: type,
              attachJobId: jobId,
              projectIdParam: companyCamProjectId,
              allowMultipleSelection: allowMultiple,
              dirWithImageOnly: dirWithImageOnly
          ),
          global: false,
          builder: (FilesListingController controller) {
            return JPSafeArea(
              bottom: false,
              child: FilesView(
                controller: controller,
                onTapAttach: (List<FilesListingModel> selectedFiles) async {
                  controller.toggleIsMovingFile();
                  
                  if(selectedFiles.isNotEmpty) {
                    List<AttachmentResourceModel> attachments = [];
                    if(type != FLModule.paymentReceipt) {
                      if (uploadType != null) {
                        await uploadTypeToSelectedAttachments(selectedFiles, type, uploadType).then((files) {
                          attachments.addAll(files);
                          controller.toggleIsMovingFile();
                        }).catchError((e) {
                          controller.toggleIsMovingFile();
                        });
                      } else {
                        for (FilesListingModel file in selectedFiles) {
                          if (dirWithImageOnly && file.jpThumbType != JPThumbType.image) continue;
                          attachments.add(
                              AttachmentResourceModel.fromJson(file.toJson())
                                ..type = Helper.resourceType(type)
                          );
                        }  
                      }
                    } else {
                      attachments =  await getPaymentReceiptList(selectedFiles);
                    }
                    onFilesSelected(attachments);
                    Get.back();
                  }
                },
              ),
            );
          },
        ),
        ignoreSafeArea: false,
        isScrollControlled: true
    );
  }

  /// uploadFiles() : will open files selector, upload files to server and
  /// T is Generic type -> it will be AttachmentResourceModel or Map<String, dynamic>
  /// then returns files list
  static Future<void> uploadFiles<T>({
    required Function(List<T> seletecedFiles) onFilesUploaded,
    bool onlyImages = true,
    bool allowMultiple = true,
    bool fromCamera = false,
    String? uploadType,
    int? maxSize,
    bool isSrs = false,
  }) async {

    List<String> paths = [];

    if (fromCamera) {
      final imagePath = await FilePickerService.takePhoto();
      if (imagePath != null) paths.add(imagePath);
    } else {
      paths = await FilePickerService.pickFile(
        onlyImages: onlyImages,
        allowMultiple: allowMultiple,
        isSrs: isSrs
      );
    }

    if (paths.isNotEmpty) {
      if (maxSize != null) {
        // Collect valid paths and show toast for each oversized file
        List<String> validPaths = [];
        for (final path in paths) {
          if (File(path).lengthSync() > maxSize) {
            Helper.showToastMessage('max_file_size'.tr + ' ' + (FileHelper.fileInMegaBytes(maxSize).toString()) + ' ' + 'mb'.tr);
          } else {
            validPaths.add(path);
          }
        }
        if (validPaths.isNotEmpty) {
          showJPGeneralDialog(
            child: (_) => UploadProgressDialog(
              paths: validPaths,
              onAllFilesUploaded: onFilesUploaded,
              uploadType: uploadType,
            ),
            isDismissible: false,
          );
        }
        // If no valid files, do nothing (all toasts already shown)
      } else {
        showJPGeneralDialog(
          child: (_) => UploadProgressDialog(
            paths: paths,
            onAllFilesUploaded: onFilesUploaded,
            uploadType: uploadType,
          ),
          isDismissible: false,
        );
      }
    }
  }

  static void navigateToFileListing(int jobId, int customerId) {
    Get.toNamed(
        Routes.filesListing,
        arguments: {
          NavigationParams.type: FLModule.financialInvoice,
          'jobId': jobId,
          'customerId': customerId
        },
        preventDuplicates: false);
  }

  static Future<List<AttachmentResourceModel>> uploadTypeToSelectedAttachments(
      List<FilesListingModel> selectedFiles, FLModule type, String uploadType) async {
    try {
      List<AttachmentResourceModel> attachments = [];

      switch (uploadType) {
        case FileUploadType.template:
          final files = await TemplatesRepository.uploadImages(selectedFiles, type);
          attachments.addAll(files);
          break;

        default:
          for (var file in selectedFiles) {
            attachments.add(
                AttachmentResourceModel.fromJson(file.toJson())
                  ..type = Helper.resourceType(type)
            );
          }
      }

      return attachments;
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<AttachmentResourceModel>> getPaymentReceiptList(
      List<FilesListingModel> selectedFiles,) async {
    try {
      List<AttachmentResourceModel> attachments = [];
    
          for (var selectedFile in selectedFiles) {
            Map<String,dynamic> params = {
              'id': selectedFile.id,
              'save_as_attachment': '1'
            };
            final attachment = await JobFinancialRepository.getPaymentSlipAsAttachment(selectedFile.id!, params);
            attachments.add(attachment);
          }
    
      return attachments;
    } catch (e) {
      rethrow;
    }
  }

}