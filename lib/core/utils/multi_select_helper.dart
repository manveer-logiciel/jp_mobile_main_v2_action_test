import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';

class MultiSelectHelper {
  static void openMultiSelect(
      {required List<JPMultiSelectModel> mainList,
      List<JPMultiSelectModel>? subList,
      List<JPMultiSelectModel>? subSubList,
      required Function(List<JPMultiSelectModel>) callback,
      Widget? doneIcon,
      String? title,
      String? inputHintText,
      String? helperText,
      bool? disableButtons,
      bool? canDisableDoneButton,
      bool? isDismissible,
      bool? isEnableDrag,
      bool? isScrollControlled,
      bool? isGroupsHeader,
      bool? showIncludeInactiveButton,
      int? maxSelection,
      VoidCallback? onMaxSelectionReached
      }) {
    showJPBottomSheet(
        child: (_) => JPMultiSelect(
              mainList: mainList,
              subList: subList,
              maxSelection: maxSelection,
              onMaxSelectionReached: onMaxSelectionReached,
              inputHintText: inputHintText ?? 'search'.tr,
              title: title ?? "select".tr.toUpperCase(),
              helperText: helperText,
              disableButtons: disableButtons ?? false,
              doneIcon: doneIcon,
              canShowSubList: isGroupsHeader,
              showIncludeInactiveButton: showIncludeInactiveButton ?? false,
              canDisableDoneButton: canDisableDoneButton ?? false,
              onDone: (List<JPMultiSelectModel>? selectedList) {
                callback(selectedList!);
              },
            ),
        isDismissible: isDismissible ?? true,
        enableDrag: isEnableDrag ?? true,
        isScrollControlled: isScrollControlled ?? true);
  }
}
