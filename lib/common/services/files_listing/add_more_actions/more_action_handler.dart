import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/insurance_form_type.dart';
import 'package:jobprogress/common/enums/templates.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/enums/worksheet.dart';
import 'package:jobprogress/common/models/sql/uploader/file_uploader_params.dart';
import 'package:jobprogress/common/repositories/google_sheet.dart';
import 'package:jobprogress/common/services/file_attachment/quick_actions.dart';
import 'package:jobprogress/common/services/file_picker.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_repo/job_estimate_repo.dart';
import 'package:jobprogress/common/services/files_listing/quick_actions.dart';
import 'package:jobprogress/common/services/upload.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';
import 'package:jobprogress/modules/files_listing/page.dart';
import 'package:jobprogress/modules/files_listing/widgets/index.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/index.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/type.dart';
import '../../../../core/constants/navigation_parms_constants.dart';
import '../../../../routes/pages.dart';
import '../../../enums/eagle_view_form_type.dart';
import '../../../models/files_listing/create_file_actions.dart';
import '../../../models/files_listing/files_listing_model.dart';

class FileListMoreActionHandlers {
  static void navigateToEagleViewForm(CreateFileActions params, FLQuickActions eagleView) {
    Get.toNamed(Routes.eagleViewForm, arguments: {
      NavigationParams.jobModel: params.jobModel,
      NavigationParams.pageType: EagleViewFormType.createForm
    });
  }

  static void navigateToQuickMeasureForm(CreateFileActions params, FLQuickActions eagleView) {
    Get.toNamed(Routes.quickMeasureForm, arguments: {
      NavigationParams.jobModel: params.jobModel,
    });
  }

  static void navigateToCreateInsuranceScreen(CreateFileActions params, String action, {Map<String, dynamic>? insurancePdfJson}) async {
    dynamic success = await Get.toNamed(Routes.insuranceForm, arguments: {
      NavigationParams.jobModel: params.jobModel,
      NavigationParams.pageType: InsuranceFormType.add,
      if (insurancePdfJson != null) NavigationParams.insurancePdfJson: insurancePdfJson,
      }
    );
    if(success != null && success) {
      params.onActionComplete(FilesListingModel(), action);
    }
  }

  static void navigateToMeasureForm(CreateFileActions params, String action) async {
    dynamic success = await Get.toNamed(Routes.measurementForm,
        arguments: {NavigationParams.jobId: params.jobModel!.id});
    if (success != null && success) {
      params.onActionComplete(FilesListingModel(), action);
    }
  }

  static void navigateToCreateWorksheet(CreateFileActions params, String action) async {
    dynamic success = await Get.toNamed(Routes.worksheetForm, arguments: {
      NavigationParams.jobId: params.jobModel?.id,
      NavigationParams.worksheetType: params.type,
      NavigationParams.worksheetFormType: WorksheetFormType.add,
    }
    );
    if(success != null && Helper.isTrue(success)) {
      params.onActionComplete(FilesListingModel(), action);
    }
  }

  static void actionComplete(CreateFileActions params, String action) =>
      params.onActionComplete(FilesListingModel(), action);
      
  static Future<void> uploadExcel(CreateFileActions params,String quickActionType) async {
    
    List<String> docs = await FilePickerService.pickFile(allowMultiple: false,onlyXls: true);
    if(docs.isEmpty) return;
    if(File(docs.first).lengthSync() < CommonConstants.maxAllowedFileSize) {
      await showSaveDialog(params,onTapSuffix: (val) async {
        Get.back();
        final uploadParams = FileUploaderParams(
          type: FilesListingService.moduleTypeToUploadType(params.type),
          job: params.jobModel,
          parentId: null,
        );
        Map<String,dynamic> fileParam = {
          "file_name":val,
          "job_id": params.jobModel?.id,
          "file_path": docs.first
        };
        UploadService.parseParamsAndAddToQueue(docs, uploadParams,isGoogleSheet: true, additionalParams: fileParam);
      },);
    } else {  
      Helper.showToastMessage('max_file_size'.tr + ' ' + FileHelper.fileInMegaBytes(CommonConstants.maxAllowedFileSize).toString() + ' ' + 'mb'.tr);
    }
    
  }    

  static void showAttachFileSheet(FLModule type, CreateFileActions params,
      {required String saveAs, int? jobId, bool allowMultiple = true, String? action}) {
    showJPBottomSheet(
        child: (_) => GetBuilder<FilesListingController>(
              init: FilesListingController(
                  mode: FLViewMode.attach,
                  attachType: type,
                  attachJobId: jobId,
                  allowMultipleSelection: allowMultiple),
              global: false,
              builder: (FilesListingController controller) {
                return JPSafeArea(
                  bottom: false,
                  child: FilesView(
                    controller: controller,
                    onTapAttach: (List<FilesListingModel> selectedFiles) async {
                      controller.toggleIsMovingFile();
                      await FileListingJobEstimateQuickActionRepo.uploadFile(selectedFiles, jobId!, type, saveAs);
                      controller.toggleIsMovingFile();
                      Get.back();
                      Helper.showToastMessage("files_uploaded".tr);
                      params.onActionComplete(FilesListingModel(), action);
                    },
                  ),
                );
              },
            ),
        ignoreSafeArea: false,
        isScrollControlled: true);
  }

  static void navigateToTemplates(CreateFileActions params, String? action, {bool merge = false}) async {
    final type = merge ? FLModule.mergeTemplate : FLModule.templates;
    final result = await Get.to(() => FilesListingView(refTag: "$type${params.jobModel?.id}"), arguments: {
      'type': type,
      'customerId': params.customerModel?.id,
      'job': params.jobModel,
      'parent_module': params.type,
    },
      preventDuplicates: false,
    );
    if ((result is bool) ? result : result != null) {
      params.onActionComplete(FilesListingModel(), action);
    }
  }

  static Future<void> navigateToHandwrittenTemplates(CreateFileActions params, String? action) async {
    FLModule type = FLModule.templates;
    var templateId = params.templateId;
    templateId ??= await Get.to(() => FilesListingView(refTag: "$type${params.jobModel?.id}"), arguments: {
        'type': type,
        'customerId': params.customerModel?.id,
        'job': params.jobModel,
        'templates_list_type': 'estimate',
        'parent_module': params.type,
      },
        preventDuplicates: false,
      );

    if (templateId != null) {
      dynamic result = await Get.toNamed(Routes.handWrittenTemplate, arguments: {
        NavigationParams.handwrittenTemplateType: EstimateTemplateFormType.add,
        NavigationParams.jobId : params.jobModel?.id,
        NavigationParams.templateId : templateId,
      });

      if (result is bool && result) {
        params.onActionComplete(FilesListingModel(), action);
      }
    }
  }

  static Future<dynamic> templateTypeToNavigate(FilesListingModel tappedFile, JobModel? job, String type, FLModule flModule) async {
    if(flModule == FLModule.templatesListing) {
      switch (type) {
        case 'estimate':
          return navigateToHandwrittenTemplates(CreateFileActions(
              fileList: [tappedFile],
              jobModel: job,
              templateId: tappedFile.id,
              onActionComplete: (FilesListingModel model, action) {  }),
              type);

        case 'proposal':
          return navigateToFormProposalTemplate(tappedFile, job);
      }
    } else {
      switch (type) {
        case 'estimate':
          return Get.back(result: tappedFile.id);

        case 'proposal':
          return navigateToFormProposalTemplate(tappedFile, job);
      }
    }
  }

  static Future<dynamic> navigateToFormProposalTemplate(FilesListingModel tappedFile, JobModel? job) async {
    final result = await Get.toNamed(Routes.formProposalTemplate, arguments: {
      NavigationParams.templateType: ProposalTemplateFormType.add,
      NavigationParams.jobId : job?.id,
      NavigationParams.templateId : tappedFile.id
    }, preventDuplicates: false);

    return result;
  }
  
  static void navigateToEstimatesTemplates(CreateFileActions params) async {
    const type = FLModule.googleSheetTemplate;
    Get.to(() => FilesListingView(refTag: "$type${params.jobModel?.id}"), arguments: {
      'parent_module': params.type,
      'type': type,
      'customerId': params.customerModel?.id,
      'job': params.jobModel,
      'action':params
    },
      preventDuplicates: false,
    );
  }  

  static void pickInsuranceDocsAndUpload(CreateFileActions params, String action) {
    FileAttachService.uploadFiles<Map<String, dynamic>>(
      onlyImages: false,
      allowMultiple: false,
      uploadType: FileUploadType.xactimate,
      maxSize: Helper.flagBasedUploadSize(fileSize: CommonConstants.maxAllowedFileSize),
      onFilesUploaded: (onFilesUploaded) {
        if (onFilesUploaded.isNotEmpty) {
          Future.delayed(const Duration(seconds: 1), () {
            navigateToCreateInsuranceScreen(params, action, insurancePdfJson: onFilesUploaded[0]);
          });
        }
      },
    );
  }


  static Future<void> showSaveDialog(CreateFileActions params,{
    String? initialValue,
    Future<void> Function(String val)? onTapSuffix
  }) async {
    FocusNode createDialogFocusNode = FocusNode();

    showJPGeneralDialog(
        child: (controller){
          return JPQuickEditDialog(
            type: JPQuickEditDialogType.inputBox,
            label: 'enter_name'.tr,
            fillValue: initialValue,
            title: 'create_google_sheet'.tr.toUpperCase(),
            suffixIcon: showJPConfirmationLoader(show: controller.isLoading),
            disableButton: controller.isLoading,
            errorText: 'please_enter_sheet_name'.tr,
            onCancel: controller.isLoading ? null : Get.back<void>,
            onSuffixTap: (val) async{
              if (val.isEmpty) return;
              
              controller.toggleIsLoading();
              await onTapSuffix?.call(val).then((value) {
                controller.toggleIsLoading();
              }).catchError((e) {
                controller.toggleIsLoading();
              });
            },
            focusNode: createDialogFocusNode,
            suffixTitle: controller.isLoading ? '' : 'save'.tr.toUpperCase(),
            maxLength: 50,
          );
        },
        isDismissible: false
    );

    await Future<void>.delayed(const Duration(milliseconds: 400));

    createDialogFocusNode.requestFocus();
  }

  static Future<void> saveSpreadsheet(CreateFileActions params, String quickAction) async{
    showSaveDialog(params,onTapSuffix: (fileName) async {
      Map<String,dynamic> param = {
        "file_name":fileName,
        "job_id": params.jobModel?.id,
      };
      await GoogleSheetActionRepo.createGoogleSheet(params,quickAction,param,params.type).then((value) async {
        if(value.isNotEmpty){
          Helper.showToastMessage('file_added'.tr);

          Get.back();

          params.onActionComplete(FilesListingModel(),quickAction);

          await Future<void>.delayed(const Duration(milliseconds: 500));

          Helper.launchUrl(value["google_sheet_url"],isInExternalMode: false);
        }
      });
    });
  }
}
