import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/chats.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class GroupListingQuickActions {
  static List<JPQuickActionModel> getQuickActionList(int count) {
    if (count > 0) {
      return [
        JPQuickActionModel(
          label: 'mark_as_read'.tr.capitalize!,
          id: GroupListingMarkAs.read.toString(),
          child: const JPIcon(
            Icons.remove_red_eye_outlined,
            size: 20,
          ),
        ),
      ];
    } else {
      return [
        JPQuickActionModel(
          label: 'mark_as_unread'.tr.capitalize!,
          id: GroupListingMarkAs.unread.toString(),
          child: const JPIcon(
            Icons.visibility_off_outlined,
            size: 20,
          ),
        ),
      ];
    }
  }

  static void openQuickActions(int count, Function(String) onActionSelected) {
    showJPBottomSheet(
      child: (_) => JPQuickAction(
        mainList: getQuickActionList(count),
        onItemSelect: (value) {
          Get.back();
          onActionSelected(value);
        },
      ),
      isScrollControlled: true,
    );
  }
}
