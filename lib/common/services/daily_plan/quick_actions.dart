import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jp_mobile_flutter_ui/Icon/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';

import '../../../core/constants/navigation_parms_constants.dart';
import '../../../core/constants/permission.dart';
import '../../../global_widgets/bottom_sheet/index.dart';
import '../../../routes/pages.dart';
import '../../enums/event_form_type.dart';
import '../../enums/task_form_type.dart';

class DailyPlanService {

  List<JPQuickActionModel> getQuickActionList() {
    bool isProductionFeatureAllowed = FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.production]);
    List<JPQuickActionModel> quickActionList = [
      JPQuickActionModel(
          id: 'appointment',
          child: const JPIcon(Icons.today_outlined, size: 18),
          label: 'appointment'.tr),
      JPQuickActionModel(
        id: 'task',
        child: const JPIcon(Icons.task_alt_outlined, size: 18),
        label: 'task'.tr.capitalizeFirst!,
      ),
      if(isProductionFeatureAllowed)
        JPQuickActionModel(
          id: 'job_schedule',
          child: const JPIcon(Icons.schedule_outlined, size: 18),
          label: 'job_schedule'.tr,
        ),
      if(isProductionFeatureAllowed)  
        JPQuickActionModel(
          id: 'event',
          child: const JPIcon(Icons.event_note_outlined, size: 18),
          label: 'event'.tr,
        ),
    ];

    if(!PermissionService.hasUserPermissions([PermissionConstants.manageJobSchedule])) {
      Helper.removeMultipleKeysFromArray(quickActionList, ['job_schedule']);
    }

    return quickActionList;
  }

  static List<JPQuickActionModel> getScheduleEventActions() {
    List<JPQuickActionModel> quickActionList = [
      JPQuickActionModel(id: "event",
          child: const JPIcon(Icons.event, size: 18),
          label: 'event'.tr),
      if(PermissionService.hasUserPermissions([PermissionConstants.manageJobSchedule]))
        JPQuickActionModel(id: "job_schedule",
            child: const JPIcon(Icons.schedule_outlined, size: 18),
            label: 'job_schedule'.tr),
    ];

    return quickActionList;
  }

  static openQuickActions(VoidCallback callback) {

    List<JPQuickActionModel> quickActionList = DailyPlanService().getQuickActionList();

    showJPBottomSheet(
      child: (_) => JPQuickAction(
        mainList: quickActionList,
        title: 'create'.tr.toUpperCase(),
        onItemSelect: (value) {
          Get.back();
          handleQuickActions(callback, value);
        },
      ),
      isScrollControlled: true,
    );
  }

  static void handleQuickActions(VoidCallback callback, String action) async {
    switch (action) {
      case 'appointment':
        navigateToCreateAppointmentScreen(callback);
        break;
      case 'task':
        navigateToCreateTaskScreen(callback);
        break;
      case 'job_schedule':
        navigateJobScheduleListingScreen(callback);
        break;
      case 'event':
        navigateToCreateEvent(callback);
        break;
      default:
        break;
    }
  }

  static Future<void> navigateToCreateAppointmentScreen(VoidCallback callback) async {
    final result = await Get.toNamed(Routes.createAppointmentForm);
   if(result != null) {
     callback.call();
   }
  }

  static Future<void> navigateToCreateTaskScreen(VoidCallback callback) async {
    final result = await Get.toNamed(Routes.createTaskForm,
        arguments: {
          NavigationParams.pageType: TaskFormType.createForm
        });
    if(result != null) {
      callback.call();
    }
  }

  static Future<void> navigateToCreateEvent(VoidCallback callback) async {
    final result = await Get.toNamed(Routes.createEventForm,
        preventDuplicates: false,
        arguments: {
          NavigationParams.pageType: EventFormType.createForm
        });
    if(result != null) {
      callback.call();
    }
  }

  static Future<void> navigateJobScheduleListingScreen(VoidCallback callback) async {
    final result = await Get.toNamed(Routes.jobScheduleListing,
        preventDuplicates: false,
        arguments: {
          NavigationParams.pageType: EventFormType.createForm
        });

    if(result != null) {
      callback.call();
    }
  }
}