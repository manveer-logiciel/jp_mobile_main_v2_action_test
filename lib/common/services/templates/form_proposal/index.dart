import 'dart:async';

import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/templates/form_proposal/more_action.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/attach_file.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/index.dart';

class FormProposalTemplateService {

  FormProposalTemplateService(this.params, {
    required this.update,
    this.dbUnsavedResourceId,
    this.stream,
  });

  late FormProposalParamsModel params; // used to handling controller actions

  late VoidCallback update;

  int? dbUnsavedResourceId;

  StreamSubscription<void>? stream;

  static List<JPQuickActionModel> getMoreActionList({bool isEditForm = false}) {
    List<JPQuickActionModel> quickActionList = [
      JPQuickActionModel(id: 'attach', child: const JPIcon(Icons.photo_outlined, size: 20), label: 'attach_photos'.tr),
      JPQuickActionModel(id: 'snippet', child: const JPIcon(Icons.list_alt, size: 20), label: 'snippets'.tr),
      if (isEditForm)
        JPQuickActionModel(id: 'save_as', child: const JPIcon(Icons.save_outlined, size: 20), label: 'save_as'.tr),
    ];

    return quickActionList;
  }

  static List<JPQuickActionModel> getMergeTemplateActionList(bool showAddImages, bool showAddPages) {
    List<JPQuickActionModel> quickActionList = [
      if (showAddImages)
        JPQuickActionModel(id: 'add_images', child: const JPIcon(Icons.image_outlined, size: 20), label: 'add_images'.tr),
      if (showAddPages)
        JPQuickActionModel(id: 'add_pages', child: const JPIcon(Icons.description_outlined, size: 20), label: 'add_pages'.tr),
      JPQuickActionModel(id: 'manage_pages', child: const JPIcon(Icons.edit_outlined, size: 20), label: 'manage_pages'.tr),
      JPQuickActionModel(id: 'snippet', child: const JPIcon(Icons.list_alt, size: 20), label: 'snippets'.tr),
      JPQuickActionModel(id: 'reload', child: const JPIcon(Icons.refresh_outlined, size: 20), label: 'reload'.tr),
      JPQuickActionModel(id: 'save', child: const JPIcon(Icons.save_outlined, size: 20), label: 'save'.tr),
    ];

    return quickActionList;
  }

  void showMoreActions({
    bool isMerge = false,
    bool showAddPages = true,
    bool showAddImages = false,
    Function(String)? onAction,
  }) {
    List<JPQuickActionModel> quickActions = isMerge
        ? getMergeTemplateActionList(showAddImages, showAddPages)
        : getMoreActionList(isEditForm: params.isEditForm);

    showJPBottomSheet(child: (_) => JPQuickAction(
      mainList: quickActions,
      title: "more_actions".tr,
      onItemSelect: (action) => handleMoreAction(action, onAction: onAction),
    ));
  }

  void handleMoreAction(String action, {Function(String)? onAction}) {

    Get.back();

    switch (action) {
      case 'attach':
        showFileAttachmentSheet();
        break;

      case 'snippet':
        Get.toNamed(Routes.snippetsListing, preventDuplicates: false);
        break;

      case 'save_as':
        params.onTapSaveAs?.call();
        break;

      default:
        onAction?.call(action);
    }
  }

  void removeAttachedItem(int index) {
    if (params.attachments.isEmpty) return;
    if (params.attachments.length <= index) return;
    params.attachments.removeAt(index);
    if (params.attachments.isEmpty) Get.back();
    update();
  }

  // showFileAttachmentSheet() : displays quick actions sheet to select files from
  void showFileAttachmentSheet() {
    FormValueSelectorService.selectAttachments(
        type: AttachmentOptionType.attachPhoto,
        dirWithImageOnly: true,
        attachments: params.attachments,
        jobId: params.jobId,
        maxSize: Helper.flagBasedUploadSize(fileSize: CommonConstants.maxAllowedFileSize),
        onSelectionDone: () {
          update();
        });
  }

  String getImageTitle(FLModule? type, JobModel? job) {
    String title = "";

    if (job != null) {
      title = job.number ?? "";

      if (job.parent != null) {
        //in case of project append trade type
        if (job.trades?.isNotEmpty ?? false) {
          var trades = job.trades!.map((trade) => trade.name).toList();
          title += " - ${trades.join("/")}";
        }
      }
    }

    switch (type) {
      case FLModule.companyFiles:
        title = 'company_files'.tr;
        break;

      case FLModule.stageResources:
        title = 'resource_viewer'.tr;
        break;

      default:
        break;
    }

    return title;
  }

  void handleMergeTemplateMoreActions({
    bool showAddImages = false,
    bool showAddPages = true,
    VoidCallback? onTapSaveAction,
    VoidCallback? reloadTemplate,
    VoidCallback? showManagePagesSheet,
    VoidCallback? addPages,
    VoidCallback? showAddImagesSheet,
  }) {
    showMoreActions(
      isMerge: true,
      showAddPages: showAddPages,
      showAddImages: showAddImages,
      onAction: (action) {
        switch (action) {
          case "save":
            onTapSaveAction?.call();
            break;

          case "reload":
            reloadTemplate?.call();
            break;

          case "manage_pages":
            showManagePagesSheet?.call();
            break;

          case "add_pages":
            addPages?.call();
            break;

          case "add_images":
            showAddImagesSheet?.call();
            break;
        }
      },
    );
  }

  Future<void> showSaveDialog({
    String? initialValue,
    bool isEditForm = false,
    Future<void> Function(String val, bool isSaveAs)? onTapSuffix
  }) async {
    FocusNode renameDialogFocusNode = FocusNode();

    bool isSaveAs = initialValue != null && isEditForm;

    showJPGeneralDialog(
        child: (controller){
          return JPQuickEditDialog(
            type: JPQuickEditDialogType.inputBox,
            label: 'proposal_name'.tr,
            fillValue: initialValue,
            title: (!isSaveAs ? 'save_proposal'.tr : 'save_as_proposal'.tr).toUpperCase(),
            suffixIcon: showJPConfirmationLoader(show: controller.isLoading),
            disableButton: controller.isLoading,
            errorText: 'please_enter_proposal_name'.tr,
            onCancel: controller.isLoading ? null : Get.back<void>,
            onSuffixTap: (val) async{

              if (val.isEmpty) return;

              controller.toggleIsLoading();
              await onTapSuffix?.call(val, isSaveAs).then((value) {
                controller.toggleIsLoading();
              }).catchError((e) {
                controller.toggleIsLoading();
              });
            },
            focusNode: renameDialogFocusNode,
            suffixTitle: controller.isLoading ? '' : 'save'.tr.toUpperCase(),
            maxLength: 50,
          );
        },
        isDismissible: false
    );

    await Future<void>.delayed(const Duration(milliseconds: 400));

    renameDialogFocusNode.requestFocus();
  }

}
