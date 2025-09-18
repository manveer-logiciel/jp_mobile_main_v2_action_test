import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jp_mobile_flutter_ui/Icon/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';


class ContactViewService {

  static void openQuickActions(Function(String) callback) {
    List<JPQuickActionModel> quickActionList = [
      JPQuickActionModel(
        id: 'edit',
        child: const JPIcon(
          Icons.edit_outlined,
          size: 18,
        ),
        label: 'Edit'
      ),
      JPQuickActionModel(
        id: 'delete',
        child: const JPIcon(
          Icons.delete_outline,
          size: 18,
        ),
        label: 'Delete'
      ),
    ];

     showJPBottomSheet(
        child: (_) => JPQuickAction(
          mainList: quickActionList,
          onItemSelect: (value) {
            Get.back();
            handleQuickActions(value, callback);
          },
        ),
        isScrollControlled: true
    );
  }

  static void handleQuickActions(String action, Function(String) callback) {
    switch (action) {
      case 'edit':
        callback('edit');
        break;
      case 'delete':
        callback('delete');
        break;
    }
  }

  //Deleting company contact note
  static void handleDeleteNote(Function(String) callback) {
  }


}
