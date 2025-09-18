
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';

class FileAttachmentQuickActionDialogs {

  static void resetSelectionDialog({bool isOpeningFolder = false, VoidCallback? onTapSuffix}) {
    showJPBottomSheet(
      child: (controller) {
        return JPConfirmationDialog(
          icon: Icons.warning_amber_outlined,
          title: 'confirmation'.tr,
          suffixBtnText: 'confirm'.tr,
          subTitle: isOpeningFolder ? 'files_can_be_only_selected_from_one_folder_at_a_time'.tr : 'are_you_sure_to_reset_all_selections'.tr,
          disableButtons: controller.isLoading,
          suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
          onTapSuffix: onTapSuffix,
        );
      },
    );
  }

}