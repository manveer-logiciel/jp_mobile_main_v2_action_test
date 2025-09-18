import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/extensions/mix_panel/extension.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/common/repositories/task_listing.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/mix_panel/titles.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/constants/phases_visibility.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/task/detail/index.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/DatePicker/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../core/constants/navigation_parms_constants.dart';
import '../../../routes/pages.dart';
import '../../enums/page_type.dart';

class TaskService {

  static List<JPQuickActionModel> getQuickActionList(TaskListModel task, { String? actionFrom,bool canShowSecondPhase = true}) {
    bool hasTaskUnlockPermission = PermissionService.hasUserPermissions([PermissionConstants.markTaskUnlock]);
    List<JPQuickActionModel> quickActionList = [
      JPQuickActionModel(id: 'view', child: const JPIcon(Icons.visibility_outlined, size: 20), label: 'View'),
      
      if(task.completed == null) JPQuickActionModel(id: 'mark_as_complete', child: const JPIcon(Icons.done_outlined, size: 20), label: 'Mark As Complete'),
      if(task.completed != null) JPQuickActionModel(id: 'mark_as_uncomplete', child: const JPIcon(Icons.done_outlined, size: 20), label: 'Mark As Uncomplete'),

      if(task.completed == null && canShowSecondPhase) JPQuickActionModel(id: 'edit', child: const JPIcon(Icons.edit_outlined, size: 20), label: 'edit'.tr),
      if(task.locked && hasTaskUnlockPermission) JPQuickActionModel(id: 'unlock_stage_change', child: const JPIcon(Icons.lock_open_rounded, size: 20), label: 'unlock_stage_change'.tr),
      if(task.completed == null && actionFrom != 'daily_plan' && actionFrom != 'task_detail') JPQuickActionModel(
        id: 'add_to_daily_plan',
        child: SvgPicture.asset('assets/svg/daily_plan_Icon.svg', colorFilter: ColorFilter.mode(JPAppTheme.themeColors.text.withValues(alpha: 0.8), BlendMode.srcIn)),
        label: 'Add To Daily Plan'
      ),
      if(Helper.isValueNullOrEmpty(task.completed))JPQuickActionModel(id: 'link_to_job_project', child: const JPIcon(Icons.link_outlined, size: 20), label: 'link_to_job/project'.tr),
      JPQuickActionModel(id: 'delete', child: const JPIcon(Icons.delete_outlined, size: 20), label: 'Delete'),
    ];

    if(actionFrom == 'task_detail') {
      quickActionList.removeWhere((element) => element.id == 'view');
    }

    UserModel? loggedInUser = AuthService.getUserDetails();

    if (!PermissionService.hasUserPermissions([PermissionConstants.manageTasksCreatedByOtherUsers])
      && task.createdBy != null && task.createdBy!.id != loggedInUser!.id) {
      quickActionList.removeWhere((element) => element.id == 'delete');
    }

    return quickActionList;
  }

  //Setting options and opening quick action bottom sheet
  static openQuickActions(TaskListModel task, Function(TaskListModel, String) callback, { String? actionFrom }) {
    List<JPQuickActionModel> quickActionList = getQuickActionList(task, actionFrom: actionFrom, canShowSecondPhase: PhasesVisibility.canShowSecondPhase);

    showJPBottomSheet(
      child: (_) => JPQuickAction(
        mainList: quickActionList,
        onItemSelect: (value) {
          Get.back();
          handleQuickActions(value, task, callback);
        },
      ),
      isScrollControlled: true
    );
  }

  //Handling quick action tap
  static void handleQuickActions(String action, TaskListModel task, Function(TaskListModel, String) callback) async {
    switch (action) {
      case 'view':
        openTaskdetail(
          task: task, 
          callback: callback
        );
        break;
      case 'edit':
        callback(task, 'edit');
        break;

      case 'mark_as_complete':
      case 'mark_as_uncomplete':
        TaskListModel updatedTask = await markAsComplete(task);
        callback(updatedTask, 'mark_as_complete');
        break;
      case 'delete':
        deleteTask(task, callback);
        break;
      case 'unlock_stage_change':
        unlockStageChange(task.id, callback);
        break;
      case 'add_to_daily_plan':
        addTaskToDailyPlan(task, callback);
        break;
      case 'link_to_job_project':
        navigateLinkToJobProject(task,callback);
        break;
      default:
    }
  }

  static void addTaskToDailyPlan(TaskListModel task, Function(TaskListModel, String) callback) async {
    DateTime? dateTime = await Get.dialog(
      JPDatePicker(
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
      ),
    );

    if(dateTime != null) {
      String formattedDate = DateTimeHelper.formatDate(dateTime.toString(), DateFormatConstants.dateServerFormat);

      Map<String, dynamic> params = {
        'task_id': task.id,
        'due_date': formattedDate
      };

      showJPLoader();

      try {
        TaskListModel updatedTask = await TaskListingRepository().changeDueDate(params);
        callback(updatedTask, 'add_to_daily_plan');
        Helper.showToastMessage('task_added_to_daily_plan'.tr);
      } catch (e) {
        rethrow;
      } finally {
        Get.back();
      }
    }
  }

  static void unlockStageChange(int id, Function(TaskListModel, String) callback) async{
    Map<String, dynamic> params = {'locked': false};
    showJPLoader();
    try {
      bool success =  await TaskListingRepository().unlockStageChange(params,id);
      if(success){
        Helper.showToastMessage('task_mark_as_unlocked'.tr);
        callback(TaskListModel(id: id, title: ''),'unlock_stage_change');
      }
    } catch(e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  //Deleting task
  static void deleteTask(TaskListModel task, Function(TaskListModel, String) callback) async{
    showJPBottomSheet(child: ((controller) {
      return JPConfirmationDialog(
        title: "confirmation".tr,
        subTitle: "are_you_sure_you_want_to_delete_task".tr,
        suffixBtnText: 'confirm'.tr,
        icon: Icons.report_problem_outlined,
        disableButtons: controller.isLoading,
        suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
        onTapPrefix: () {
          Get.back();
        },
        onTapSuffix: () async {
          controller.toggleIsLoading();
          await TaskListingRepository().deleteTask(task.id).trackDeleteEvent(MixPanelEventTitle.taskDelete);
          controller.toggleIsLoading();

          Get.back();
          
          callback(task, 'delete');
          Helper.showToastMessage("task_deleted".tr);
        },
      );
    }));
  }

  //Marking task as complete or uncomplete
  static Future<TaskListModel> markAsComplete(TaskListModel task) async {
    showJPLoader();
    try {
      TaskListModel response = await TaskListingRepository().markTaskAsComplete(task.id, task.completed);
      Helper.showToastMessage(response.completed != null ? "task_status_changed_to_completed".tr : 'task_status_changed_to_un_completed'.tr);
      return response;
    } catch (e) {
      rethrow;
    } finally {
      Get.back(); //hiding loader
    }
  }

  //Opening task detail bottom sheet
  static openTaskdetail({int? id, TaskListModel? task, Function(TaskListModel, String)? callback, bool isUserHaveEditPermission = true ,bool isTaskTemplate = false}) async {
    if(task != null){
      showJPBottomSheet(child: (_) => TaskDetail(
          task: task,
          callback: callback,
          isUserHaveEditPermission: isUserHaveEditPermission,
          isTaskTemplate: isTaskTemplate,
      ), isScrollControlled: true);
    } else if (id != null){
      showJPLoader();

      Map<String, dynamic> params = {
        "includes[0]": ["created_by"],
        "includes[1]": ["participants"],
        "includes[2]": ["job"],
        "includes[3]": ["stage"],
        "includes[4]": ["customer"],
        "includes[5]": ["attachments"],
        'id': id
      };

      TaskListModel task = await TaskListingRepository().getTask(params);
      showJPBottomSheet(
          child: (_) => TaskDetail(task: task, callback: callback), isScrollControlled: true
      );
    }
  }

  static void navigateLinkToJobProject(TaskListModel task, Function(TaskListModel, String) callback) async {
    final result = await Get.toNamed(Routes.customerJobSearch, arguments: {
      NavigationParams.pageType : PageType.linkToJob,
      NavigationParams.jobId : task.jobId,
      NavigationParams.taskId : task.id,
    });

    if(result != null) {
      callback.call(task, 'link_to_job_project');
    }
  }
}