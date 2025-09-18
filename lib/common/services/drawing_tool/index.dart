import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/drawing_tool/drawing_tool_quick_action_params.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/repositories/user.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/drawing_tool/drawing_tool_repo.dart';
import 'package:jobprogress/core/constants/drawing_tool.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:jpeg_encode/jpeg_encode.dart';

class DrawingToolService {

  static List<FilesListingModel> fileList = [];

  static List<JPQuickActionModel> saveOptions() {
    List<JPQuickActionModel> quickActionList = [
      JPQuickActionModel(id: 'save', child: const JPIcon(Icons.save_outlined, size: 20), label: 'save'.tr),
      JPQuickActionModel(id: 'save_as', child: const JPIcon(Icons.save_as_outlined, size: 20), label: 'save_as'.tr),
    ];

    return quickActionList;
  }

  static Future<dynamic> optionToAction({required String value, required DrawingToolQuickActionParams actionParams, bool isPreviewImage = false, bool? isSaveAsActionPerformed}) async {
    switch(value) {
      case 'save':
        await renderAndDisplayImage(actionParams, isPreviewImage: isPreviewImage, isSaveAsActionPerformed: isSaveAsActionPerformed);
        break;

      case 'save_as':
        await showRenameDialog(actionParams, isPreviewImage: isPreviewImage, isSaveAsActionPerformed: isSaveAsActionPerformed);
        break;

      case 'save_signature':
        await saveSignature(actionParams);
        break;

      case 'base64_string':
        return await getBase64String(actionParams);

    }
  }

  // renderAndDisplayImage() : will render and save image to memory
  static Future<void> renderAndDisplayImage(DrawingToolQuickActionParams actionParams, {bool isSaveAs = false, bool isPreviewImage = false, bool? isSaveAsActionPerformed}) async {
    try {
      if(!isSaveAs) {
        showJPLoader(
            msg: 'saving_image'.tr
        );
      }

      if (actionParams.backgroundImage == null) return;

      final backgroundImageSize = Size(
          actionParams.backgroundImage!.width.toDouble(),
          actionParams.backgroundImage!.height.toDouble());

      final image = await actionParams.drawingToolController
          .renderImage(backgroundImageSize);

      final base64String = await encodeToBase64(image);

      actionParams.base64String = DrawingToolEditedImageType.imageJpeg + base64String;

      dynamic response = await saveImage(actionParams, isSaveAs);

      Get.back();

      isSaveAs ? saveAsActionHandler(actionParams, response, isPreviewImage, isSaveAsActionPerformed) : saveActionHandler(response, isPreviewImage, isSaveAsActionPerformed);

    } catch (e) {
      Get.back();
      rethrow;
    }

  }

  static void saveAsActionHandler(DrawingToolQuickActionParams actionParams, FilesListingModel response, bool isPreviewImage, bool? isSaveAsActionPerformed) {
    fileList = [];
    if(isPreviewImage) fileList.add(response);
    Helper.showToastMessage('file_copied'.tr);
  }

  static void saveActionHandler(FilesListingModel response, bool isPreviewImage, bool? isSaveAsActionPerformed) {
    Map<String,dynamic> result = {
      'file' : response,
      'save_as' : isSaveAsActionPerformed
    };

    if(!Helper.isValueNullOrEmpty(fileList)) result['files'] = fileList;

    if(isPreviewImage) result['action'] = 'save';
    fileList = [];
    Get.back(
      result: result
    );
  }

  static void showSaveOptions({
    required DrawingToolQuickActionParams actionParams
  }) {
    showJPBottomSheet(
        child: (_) {
          return JPQuickAction(
            mainList: saveOptions(),
            onItemSelect: (val) {
              Get.back();
              optionToAction(
                value: val,
                actionParams: actionParams,
              );
            },
          );
        });
  }

  static Future<void> showRenameDialog(DrawingToolQuickActionParams actionParams, {bool isPreviewImage = false, bool? isSaveAsActionPerformed}) async {

    FocusNode renameDialogFocusNode = FocusNode();

    showJPGeneralDialog(
        child: (controller){
          return JPQuickEditDialog(
            type: JPQuickEditDialogType.inputBox,
            label: 'file_name'.tr,
            suffixIcon: showJPConfirmationLoader(show: controller.isLoading),
            disableButton: controller.isLoading,
            fillValue: actionParams.title?.trim(),
            onSuffixTap: (val) async {
              controller.toggleIsLoading();
              actionParams.title = val;
              await renderAndDisplayImage(actionParams, isSaveAs: true, isPreviewImage: isPreviewImage, isSaveAsActionPerformed: isSaveAsActionPerformed);
              controller.toggleIsLoading();
            },
            focusNode: renameDialogFocusNode,
            suffixTitle: controller.isLoading ? '' : 'save'.tr.toUpperCase(),
            maxLength: 50,
          );
        });

    await Future<void>.delayed(const Duration(milliseconds: 400));

    renameDialogFocusNode.requestFocus();
  }

  static Future<void> saveSignature(DrawingToolQuickActionParams actionParams) async {

    try {

      if (actionParams.aspectRatio == null) return;

      actionParams.base64String = await getBase64String(actionParams) ;

      Map<String, dynamic> params = {
        'user_id' : AuthService.userDetails?.id,
        'signature' : actionParams.base64String
      };

      await UserRepository.addSignature(params);

    } catch (e) {
      rethrow;
    }

  }

  static Future<String> encodeToBase64(ui.Image image) async {
    final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    final jpg = JpegEncoder().compress(data!.buffer.asUint8List(), image.width, image.height, 90);
    return base64Encode(jpg);
  }

  static dynamic saveImage(DrawingToolQuickActionParams actionParams, bool isSaveAs) async {
    switch(actionParams.module) {
      case FLModule.estimate :
        return isSaveAs
            ? await DrawingToolRepo.saveAsEstimate(actionParams)
            : await DrawingToolRepo.saveEstimate(actionParams);
      case FLModule.jobPhotos:
        return isSaveAs
            ? await DrawingToolRepo.saveAsJobPhotos(actionParams)
            : await DrawingToolRepo.saveJobPhotos(actionParams);
      case FLModule.jobProposal:
        return isSaveAs
            ? await DrawingToolRepo.saveAsJobProposal(actionParams)
            : await DrawingToolRepo.saveJobProposal(actionParams);
      case FLModule.templates:
        return isSaveAs
            ? await DrawingToolRepo.saveAsResource(actionParams)
            : await DrawingToolRepo.saveJobImage(actionParams);
      default:
        return null;
    }
  }

  static Future<String?> getBase64String(DrawingToolQuickActionParams actionParams, {
    bool asPng = false
  }) async {

    bool hasDimensions = actionParams.aspectRatio != null || actionParams.height != null;
    if (!hasDimensions) return null;

    final width = actionParams.width ?? Get.width;
    final height = actionParams.height ?? (width * (actionParams.aspectRatio ?? 1));

    Size backgroundImageSize;

    if (actionParams.height != null && actionParams.width != null) {
      backgroundImageSize = Size(width, height);
    } else {
      backgroundImageSize = Size(height, width);
    }

    final image = await actionParams.drawingToolController.renderImage(backgroundImageSize);

    String base64String = "";

    if (asPng) {
      final pngBytes = await image.pngBytes;
      base64String = base64Encode(pngBytes!);
      base64String = DrawingToolEditedImageType.imagePng + base64String;
    } else {
      base64String = await encodeToBase64(image);
      base64String = DrawingToolEditedImageType.imageJpeg + base64String;
    }

    return  base64String;
  }

  static String removeExtrasFromBase64String(String base64String) {
    base64String = base64String.replaceFirst(DrawingToolEditedImageType.imagePng, "");
    base64String = base64String.replaceFirst(DrawingToolEditedImageType.imageJpeg, "");
    return base64String;
  }
}