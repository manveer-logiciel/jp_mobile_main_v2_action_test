import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/schedules/schedules.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/Icon/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';


class ScheduleService {

  // getQuickActionList() : returns quick actions list
  static List<JPQuickActionModel> getQuickActionList() {
    List<JPQuickActionModel> quickActionList = [
      JPQuickActionModel(
          id: 'edit',
          child: const JPIcon(Icons.edit_outlined, size: 18),
          label: 'edit'.tr),
      JPQuickActionModel(
          id: 'view',
          child: const JPIcon(Icons.visibility_outlined, size: 18),
          label: 'view'.tr),
      JPQuickActionModel(
          id: 'delete',
          child: const JPIcon(Icons.delete_outlined, size: 18),
          label: 'delete'.tr,
      ),
    ];

    return quickActionList;
  }

  //Setting options and opening quick action bottom sheet
  static openQuickActions(SchedulesModel task, Function(SchedulesModel, String) callback, {String? actionFrom}) {

    List<JPQuickActionModel> quickActionList = getQuickActionList();

    showJPBottomSheet(
      child: (_) => JPQuickAction(
        mainList: quickActionList,
        title: 'quick_actions'.tr.toUpperCase(),
        onItemSelect: (value) {
          Get.back();
          handleQuickActions(value, task, callback);
        },
      ),
      isScrollControlled: true,
    );
  }

  //Handling quick action tap
  static void handleQuickActions(String action, SchedulesModel task,
      Function(SchedulesModel, String) callback) async {
    switch (action) {
      case 'edit':
        callback(task, 'edit');
        break;
      case 'view':
        callback(task, 'view');
        break;
      case 'delete':
        showDeleteBottomSheet(task, action, callback);
        break;
      default:
        break;
    }
  }

  // showDeleteBottomSheet() : displays confirmation dialog
  static void showDeleteBottomSheet(SchedulesModel task, String action, Function(SchedulesModel, String) callback, {String? actionFrom}) {
    showJPBottomSheet(
        child: (controller) {
          return JPConfirmationDialog(
            icon: Icons.report_problem_outlined,
            title: "confirmation".tr,
            subTitle: task.type == 'schedule' ? "delete_job_schedule_message".tr : 'delete_event_message'.tr,
            suffixBtnText: controller.isLoading ? null : 'delete'.tr,
            disableButtons: controller.isLoading,
            suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
            onTapPrefix: () {
              Get.back();
            },
            onTapSuffix: () async {
              controller.toggleIsLoading();
              await deleteJobSchedule(task, action, callback);
              controller.toggleIsLoading();
            },
          );
        }
    );
  }

  static Future<void> deleteJobSchedule(SchedulesModel task, String action, Function(SchedulesModel, String) callback) async {
    try {
      await JobRepository.deleteJobSchedule(actionParam('deleteJobSchedule'), task.id.toString());
      callback(task, action);
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  static Map<String, dynamic> actionParam(String type) {
    return <String, dynamic>{
      "only_this": (type == 'deleteJobSchedule') ? 0 : 1,
    };
  }

}
