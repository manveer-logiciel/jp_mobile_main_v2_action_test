import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/services/quick_book.dart';
import 'package:jobprogress/core/constants/assets_files.dart';
import 'package:jobprogress/core/constants/phases_visibility.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../core/utils/helpers.dart';
import '../auth.dart';

class CustomerService {

  static List<JPQuickActionModel> getQuickActionList( bool enableMasking ,CustomerModel customer, { String? actionFrom }) {
    List<JPQuickActionModel> quickActionList = [
      if(customer.phones != null && !enableMasking)
       JPQuickActionModel(id: "call", child: const JPIcon(Icons.call_outlined, size: 18), label: 'call'.tr.capitalize!),
      if(customer.email != null && !enableMasking)
       JPQuickActionModel(id: "email", label: 'email'.tr, child: const JPIcon(Icons.email_outlined, size: 18)),
      if(!AuthService.isPrimeSubUser())
        JPQuickActionModel(id: "add_job", label: 'add_job'.tr, child: const JPIcon(Icons.post_add_outlined, size: 18)),
      JPQuickActionModel(id: "customer_flag", child: const JPIcon(Icons.flag_outlined, size: 18), label: 'customer_flags'.tr.capitalize!),
      if(!Helper.isValueNullOrEmpty(customer.addressString))
       JPQuickActionModel(id: "map", child: const JPIcon(Icons.location_on_outlined, size: 18), label: 'map'.tr.capitalize!),
      JPQuickActionModel(id: "create_appointment", child: const JPIcon(Icons.today_outlined, size: 18), label: 'create_appointment'.tr.capitalize!),
      JPQuickActionModel(id: 'appointment', child: const JPIcon(Icons.today_outlined, size: 18),label: 'appointments'.tr.capitalize!),
      if(PhasesVisibility.canShowSecondPhase)
      if(!AuthService.isPrimeSubUser())
       JPQuickActionModel(id: "edit", child: const JPIcon(Icons.edit_outlined, size: 18), label: 'edit'.tr.capitalize!),
      JPQuickActionModel(id: "view", child: const JPIcon(Icons.remove_red_eye_outlined, size: 18), label: 'view'.tr.capitalize!),
      JPQuickActionModel(id: "call_logs", child: const JPIcon(Icons.call_made_outlined, size: 18), label: 'call_logs'.tr.capitalize!),
      JPQuickActionModel(id: "delete", child: const JPIcon(Icons.delete_outlined, size: 18), label: 'delete'.tr.capitalize!),
      JPQuickActionModel(id: "customer_files", child: const JPIcon(Icons.perm_media_outlined, size: 18), label: 'customer_files'.tr.capitalize!),
      JPQuickActionModel(id: "quick_book_sync_error", child: Image.asset(AssetsFiles.qbWarning), label: 'quick_book_sync_error'.tr.capitalize!),
    ];
  
    if ((!QuickBookService.isQuickBookConnected() && !QuickBookService.isQBDConnected())
      || customer.quickbookSyncStatus != '2'
      || customer.isDisableQboSync) {
        quickActionList.removeAt(quickActionList.length - 1);
      }
    if(AuthService.isPrimeSubUser() || AuthService.isStandardUser()) {
      Helper.removeMultipleKeysFromArray(quickActionList, ["delete"]);
    }

    bool hasPastAppointments = (customer.appointments?.past ?? 0) > 0;
    if (Helper.isValueNullOrEmpty(customer.appointmentDate) && !hasPastAppointments) {
      Helper.removeMultipleKeysFromArray(quickActionList, ["appointment"]);
    }
    return quickActionList;
  }

  //Setting options and opening quick action bottom sheet
  static openQuickActions({
    bool? enableMasking,
    required CustomerModel customer,
    required Function(CustomerModel, String, int) callback,
    required int customerIndex,
    String? actionFrom}) {
    List<JPQuickActionModel> quickActionList = getQuickActionList(enableMasking ?? false, customer, actionFrom: actionFrom);

    showJPBottomSheet(
      child: (_) => JPQuickAction(
        mainList: quickActionList,
        onItemSelect: (value) {
          Get.back();
          callback(customer, value, customerIndex);
        },
      ),
      isScrollControlled: true
    );
  }
}