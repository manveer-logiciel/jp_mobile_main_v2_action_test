import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';

class FormDialogHelper {
 static void showUnsavedChangesConfirmation() {
  Helper.hideKeyboard();
  showJPBottomSheet(
      child: (_) => JPConfirmationDialog(
        title: 'unsaved_changes'.tr,
        subTitle: 'unsaved_changes_desc'.tr,
        icon: Icons.warning_amber_outlined,
        suffixBtnText: 'dont_save'.tr.toUpperCase(),
        prefixBtnText: 'cancel'.tr.toUpperCase(),
        onTapSuffix: () {
          Get.back();
          Get.back(result: true);
        },
      ),
  );
  }

}
