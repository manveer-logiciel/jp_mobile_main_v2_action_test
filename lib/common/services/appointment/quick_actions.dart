import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/repositories/appointment.dart';
import 'package:jobprogress/core/constants/mix_panel/titles.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/Icon/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';

import '../../../core/constants/navigation_parms_constants.dart';
import '../../../routes/pages.dart';
import '../../enums/appointment_form_type.dart';
import '../../models/appointment/appointment.dart';

class AppointmentService {

  // getQuickActionList() : returns quick actions list
  static List<JPQuickActionModel> getQuickActionList(AppointmentModel task, {String? actionFrom}) {
    List<JPQuickActionModel> quickActionList = [
      JPQuickActionModel(
          id: 'edit',
          child: const JPIcon(Icons.edit_outlined, size: 18),
          label: 'edit'.tr,
      ),
      JPQuickActionModel(
          id: 'view',
          child: const JPIcon(Icons.visibility_outlined, size: 18),
          label: 'view'.tr),
      JPQuickActionModel(
          id: 'delete',
          child: const JPIcon(Icons.delete_outlined, size: 18),
          label: 'delete'.tr,
          sublist: task.isRecurring ? getAppointmentRecurringDeleteQuickAction() : null
      ),
    ];

    return quickActionList;
  }

  // getAppointmentRecurringDeleteQuickAction() : returns recurring appointment quick actions
  static List<JPQuickActionModel> getAppointmentRecurringDeleteQuickAction() {
    List<JPQuickActionModel> quickActionList = [
      JPQuickActionModel(id: 'this_appointment', label: 'this_appointment'.tr),
      JPQuickActionModel(id: 'this_and_following_appointments', label: 'this_and_following_appointments'.tr),
      JPQuickActionModel(id: 'all_appointment', label: 'all_appointments'.tr),
    ];

    return quickActionList;
  }

  //Setting options and opening quick action bottom sheet
  static openQuickActions(AppointmentModel task, Function(AppointmentModel, String) callback, {String? actionFrom, bool showRecurringDeleteActions = false}) {

    List<JPQuickActionModel> quickActionList = !showRecurringDeleteActions
        ? getQuickActionList(task, actionFrom: actionFrom)
        : getAppointmentRecurringDeleteQuickAction();

    showJPBottomSheet(
      child: (_) => JPQuickAction(
          mainList: quickActionList,
          title: showRecurringDeleteActions ? 'delete'.tr.toUpperCase() : 'quick_actions'.tr.toUpperCase(),
          onItemSelect: (value) {
            Get.back();
            handleQuickActions(value, task, callback);
          },
        ),
        isScrollControlled: true,
    );
  }

  //Handling quick action tap
  static void handleQuickActions(String action, AppointmentModel task,
      Function(AppointmentModel, String) callback) async {
    switch (action) {
      case 'edit':
        navigateCreateAppointment(callback, task);
        break;
      case 'view':
        callback(task, 'view');
        break;
      case 'delete':
        showDeleteBottomSheet(task, action, callback);
        break;
      default:
        handleAppointmentRecurringDeleteQuickActions(task, action, callback);
        break;
    }
  }

  // showDeleteBottomSheet() : displays confirmation dialog
  static void showDeleteBottomSheet(AppointmentModel task, String action, Function(AppointmentModel, String) callback, {String? actionFrom}) {
    showJPBottomSheet(
      child: (controller) {
        return JPConfirmationDialog(
          icon: Icons.report_problem_outlined,
          title: "confirmation".tr,
          subTitle: "appointment_non_recurring_deleted".tr,
          suffixBtnText: controller.isLoading ? null : 'delete'.tr,
          disableButtons: controller.isLoading,
          suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
          onTapPrefix: () {
            Get.back();
          },
          onTapSuffix: () async {
            controller.toggleIsLoading();
            await deleteAppointment(task, callback).then((value) => controller.toggleIsLoading()
            );
          },
        );
      }
    );
  }

  static Future<void> handleAppointmentRecurringDeleteQuickActions(
      AppointmentModel task,
      String action,
      Function(AppointmentModel, String) callback,
      ) async {
    switch (action) {
      case 'this_appointment':
        deleteAppointment(task, callback, type: 'only_this');
        break;
      case 'this_and_following_appointments':
        deleteAppointment(task, callback, type: 'this_and_following_event');
        break;
      case 'all_appointment':
        deleteAppointment(task, callback, type: 'all');
        break;
      default:
    }
  }

  static Future<void> deleteAppointment(AppointmentModel appointment, Function(AppointmentModel, String) callback, {String? type}) async {
    String id = appointment.id.toString();

    try {
      if (type != null) showJPLoader();

      final deleteParams = <String, dynamic>{
        'impact_type': type,
      };

      if (type != '') {
        await AppointmentRepository().deleteRecurringAppointment(deleteParams, id);
      } else {
        await AppointmentRepository().deleteNonRecurringAppointment(id);
      }
      MixPanelEventTitle.appointmentDelete;
      callback(appointment, 'delete');

      Helper.showToastMessage('appointment_deleted'.tr);
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  static Future<void> navigateCreateAppointment(Function(AppointmentModel, String) callback, AppointmentModel appointment) async {
   final result = await Get.toNamed(Routes.createAppointmentForm, arguments: {
    NavigationParams.appointment: appointment,
    NavigationParams.pageType: AppointmentFormType.editForm,
   });
   if(result != null) {
    callback.call(appointment, 'edit');
   }
  }

}
