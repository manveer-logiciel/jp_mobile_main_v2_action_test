import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jp_mobile_flutter_ui/HierarchicalMultiSelect/index.dart';

/// Helper class for opening hierarchical multi-select modals throughout the app.
/// Provides a consistent interface for hierarchical data selection with groups and items.
/// Similar to MultiSelectHelper but specifically designed for hierarchical data structures.
class HierarchicalMultiSelectHelper {
  static void openHierarchicalMultiSelect({
    required JPHierarchicalSelectorModel selectorModel,
    required Function(JPHierarchicalSelectorModel) onApply,
    VoidCallback? onClear,
    Function(JPHierarchicalSelectorModel)? onSelectionChanged,
    String? title,
    String? searchHintText,
    String? cancelText,
    String? doneText,
    bool? isDismissible,
    bool? isEnableDrag,
    bool? isScrollControlled,
  }) {
    showJPBottomSheet(
      child: (_) => JPHierarchicalSelector(
        selectorModel: selectorModel,
        title: title ?? "select".tr.toUpperCase(),
        onApply: (selectedModel) {
          onApply(selectedModel);
          Get.back();
        },
        onClear: onClear != null 
            ? () {
                onClear();
                Get.back();
              }
            : null,
        onSelectionChanged: onSelectionChanged,
        searchHintText: searchHintText ?? 'search'.tr,
        cancelText: cancelText ?? 'cancel'.tr.toUpperCase(),
        doneText: doneText ?? 'done'.tr.toUpperCase(),
      ),
      isDismissible: isDismissible ?? true,
      enableDrag: isEnableDrag ?? true,
      isScrollControlled: isScrollControlled ?? true,
    );
  }
}
