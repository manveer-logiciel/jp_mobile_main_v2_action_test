import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../global_widgets/bottom_sheet/custom_list_bottom_sheet/index.dart';
import 'helpers.dart';

class SingleSelectHelper {
  //This function return label accorting to id
  static String getSelectedSingleSelectValue(
      List<JPSingleSelectModel> list, String? selected) {
    JPSingleSelectModel selectedFilter = list.firstWhereOrNull((element) => element.id == selected) ?? list[0];
    return selectedFilter.label;
  }

  static Future<void> openSingleSelect(
    List<JPSingleSelectModel> list,
    String? selected,
    String title,
    ValueChanged<String> callback, {
    bool isFilterSheet = false,
    String? inputHintText,
    String? prefixButtonText,
    String? suffixButtonText,
    VoidCallback? onTapSuffix,
    VoidCallback? onTapPrefix,
    bool isDismissible = true,
    bool disableSuffixInitially = false,
    Widget? subHeader,
  }) async {
    return await showJPBottomSheet(
      isDismissible: isDismissible,
      child: (controller) => JPSingleSelect(
      mainList: list,
      selectedItemId: selected,
      title: title,
      isFilterSheet: isFilterSheet,
      onItemSelect: (val) {
        callback.call(val);
        if (!Helper.isValueNullOrEmpty(suffixButtonText)) controller.toggleSwitchValue(val.isNotEmpty);
      },
      inputHintText: inputHintText,
      prefixButtonText: prefixButtonText,
      suffixButtonText: suffixButtonText,
      onTapPrefixBtn: onTapPrefix,
      onTapSuffixBtn: onTapSuffix,
      suffixButtonDisabled: disableSuffixInitially ? !controller.switchValue : false,
      subHeader: subHeader,
    ),
      isScrollControlled: true,
    );
  }

  static void openQuickAction({
    required dynamic dataModel,
    required List<JPQuickActionModel> quickActionList,
    required int currentIndex,
    required Function(dynamic, String, int) callback,
  }) {
    showJPBottomSheet(
        child: (_) => JPQuickAction(
          mainList: quickActionList,
          onItemSelect: (selectedValue) {
            Get.back();
            callback(dataModel, selectedValue, currentIndex);
          },
        ),
        isScrollControlled: true);
  }

  static void openCustomTileBottomSheet({
    required List<Widget> widgetList,
    String? title,
    Function({dynamic data, int index})? callback,
  }) {
    showJPBottomSheet(
      isScrollControlled: true,
      ignoreSafeArea: false,
      child: (_) => JPCustomListBottomSheet(
        widgetList: widgetList,
        title: title,
      ),
    );
  }
}
