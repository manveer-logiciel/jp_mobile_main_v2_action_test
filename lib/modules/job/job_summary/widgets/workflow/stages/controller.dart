import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/extensions/mix_panel/extension.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/workflow/service_params.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/workflow_stages/index.dart';
import 'package:jobprogress/common/services/workflow_stages/repo.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/mix_panel/titles.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/controller.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/job/job_summary/widgets/workflow/project_status_dialog/index.dart';
import 'package:jobprogress/modules/job/job_summary/widgets/workflow/tasks_sheet/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/DatePicker/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'division_stage_selector_helper.dart';

class JobOverViewWorkFlowStagesController extends GetxController {

  WorkFlowStagesServiceParams workFlowParams; // contains necessary data for managing workflow stages
  Future<void> Function({bool showLoading})? refreshJob; // callback to main controller's refresh function

  bool isSubContractorPrime = AuthService.isPrimeSubUser();

  List<JPMultiSelectModel>? users;

  List<JPSingleSelectModel> stageFilterList = [];

  // When enabled will make this controller only business logic oriented
  bool onlyBloc;

  late JobModel job; // used to store job data

  AutoScrollController scrollController = AutoScrollController(
    axis: Axis.horizontal,
    initialScrollOffset: 0,
  ); // handles list scrolling

  JobOverViewWorkFlowStagesController(
      this.workFlowParams, {
        this.refreshJob,
        this.users,
        this.onlyBloc = false,
      });

  @override
  void onInit() {
    job = workFlowParams.job;
    scrollList(isFirstTime: true);
    super.onInit();
  }

  // scrollList() : scrolls list to selected item
   void scrollList({bool isFirstTime = false}) {
    if (onlyBloc) return;
    Timer(const Duration(milliseconds: 700), () async {
      scrollController.scrollToIndex(
          workFlowParams.scrollIndex,
          preferPosition: AutoScrollPosition.middle,
          duration: Duration(milliseconds: isFirstTime && workFlowParams.scrollIndex < 6 ? 1000 : 1500)
      );
    });
  }

  // showStagesSheet() : display all the stages to select from
  Future<String?> showStagesSheet() async {
    List<JPSingleSelectModel> optionsList = WorkFlowStagesService.getSelectableStagesList(workFlowParams);
    String? selectedStage = workFlowParams.selectedStageCode;

    String title = (workFlowParams.isDivisionWorkflowUpdate ? 'select_new_stage' : 'change_stage').tr.toUpperCase();

    await SingleSelectHelper.openSingleSelect(
      optionsList,
      selectedStage,
        title,
        (value) {
          selectedStage = value;
          if (!workFlowParams.isDivisionWorkflowUpdate) {
            Get.back();
            typeToUpdateStage(newStageCode: value);
          }
        },
        inputHintText: 'search_here'.tr,
      suffixButtonText: workFlowParams.isDivisionWorkflowUpdate ? 'confirm'.tr.toUpperCase() : null,
      prefixButtonText: workFlowParams.isDivisionWorkflowUpdate ? 'cancel'.tr.toUpperCase() : null,
      onTapPrefix: () async {
        selectedStage = null;
        Get.back();
      },
      onTapSuffix: () async {
        Get.back();
      },
      isDismissible: !workFlowParams.isDivisionWorkflowUpdate,
      disableSuffixInitially: Helper.isValueNullOrEmpty(selectedStage) || optionsList.isEmpty,
      subHeader: workFlowParams.isDivisionWorkflowUpdate ? const JobOverviewDivisionStageSelectorHelper() : null
    );

    return selectedStage;
  }

  void typeToUpdateStage({required String newStageCode}) {
    // setting stage indexes
    WorkFlowStagesService.setCurrentNewStageIndex(workFlowParams, newStageCode: newStageCode);

    if(workFlowParams.isProject) {
      updateProjectStage().trackUpdateEvent(MixPanelEventTitle.projectStageUpdate);
    } else {
      updateJobStage().trackUpdateEvent(MixPanelEventTitle.jobStageUpdate);
    }
  }

  Future<void> updateJobStage() async {
    // if selected stage is current stage simply return
    if (workFlowParams.newStageIndex == workFlowParams.currentStageIndex) return;

    // - if newStage is before current stage then no need to check for tasks
    // steps will be : show automation dialog (if needed) -> update stage
    // - else if newStage is after current stage
    // 1.) steps will be : (tasks exist) check for pending tasks -> complete all tasks -> show automation dialog (if needed) -> update stage
    // 2.) steps will be : check for pending tasks -> show automation dialog (if needed) -> update stage
    if (workFlowParams.newStageIndex < workFlowParams.currentStageIndex) {
      // updating stage
      handleStageUpdate();
    } else {
      // checking incomplete tasks
      workFlowParams.incompleteTaskLockCount = await WorkFlowStagesServiceRepo.fetchIncompleteTaskCount(
          workFlowParams: workFlowParams,
      );
      // if pending tasks are there displaying tasks sheet
      if (workFlowParams.incompleteTaskLockCount > 0) {
        showTasksSheet();
      } else {
        // updating stage
        handleStageUpdate();
      }
    }
  }

  /// Handles post-division-change workflow cleanup and automation
  /// This method is specifically for division workflow updates to handle:
  /// - Incomplete task validation
  Future<bool> checkPendingTasks() async {
    // checking incomplete tasks
    workFlowParams.incompleteTaskLockCount = await WorkFlowStagesServiceRepo.fetchIncompleteTaskCount(
      workFlowParams: workFlowParams,
    );
    // if pending tasks are there displaying tasks sheet
    if (workFlowParams.incompleteTaskLockCount > 0) {
      return await showTasksSheet();
    }

    return true;
  }

  Future<void> updateProjectStage() async {
    showProjectStatusDialog();
  }

  // lastStageUpdateStatusConfirmationDialog() : is used to confirm mark as complete and reinstate action
  void lastStageUpdateStatusConfirmationDialog() {
    showJPBottomSheet(
      child: (controller) {
        return JPConfirmationDialog(
          title: 'confirmation'.tr,
          subTitle: workFlowParams.forMarkAsComplete!
              ? 'you_are_about_to_mark_this_workflow_as_complete'.tr
              : 'you_are_about_to_reinstate_this_job_into_this_workflow'.tr,
          suffixBtnText: 'confirm'.tr,
          suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
          disableButtons: controller.isLoading,
          icon: Icons.warning_amber_outlined,
          onTapSuffix: () async {
            controller.toggleIsLoading();
            // updating stage
            await handleStageUpdate().whenComplete(() =>
              controller.toggleIsLoading()
            );
            Get.back();
          },
        );
      },
    );
  }

  // markAsComplete() : will display pending task sheet or confirmation dialog directly
  Future<void> markAsComplete({bool forMarkAsComplete = true}) async {
    // setting for selected indexes
    WorkFlowStagesService.setCurrentNewStageIndex(workFlowParams, isForMarkAsComplete: forMarkAsComplete);
    // getting pending count
    workFlowParams.incompleteTaskLockCount = await WorkFlowStagesServiceRepo.fetchIncompleteTaskCount(
        workFlowParams: workFlowParams,
        useLastStageCode: true,
    );
    if (workFlowParams.incompleteTaskLockCount > 0 && forMarkAsComplete) {
      // if there are pending tasks show sheet
      showTasksSheet();
    } else {
      // else show confirmation dialog directly
      lastStageUpdateStatusConfirmationDialog();
    }
  }

  // handleStageUpdate() : used to handle stage updates
  Future<void> handleStageUpdate() async {
    if (doShowSalesAutomationDialog() && workFlowParams.forMarkAsComplete == null) {
      // if dialog needs to be displayed
      await showSalesAutomationDialog();
    } else if (workFlowParams.forMarkAsComplete != null) {
      // if request is for changing complete status
      await WorkFlowStagesServiceRepo.markAsCompleteApiRequest(workFlowParams: workFlowParams);
    } else {
      // else move stage simply and refresh changes
      await moveToStage(showLoader: true);
    }
    update();
  }

  // showTasksSheet() : displays pending tasks sheet
  Future<bool> showTasksSheet({bool skipStageUpdate = false}) async {
    bool pendingTasksCompleted = false;
    await showJPBottomSheet(
      child: (_) => JobOverViewTaskSheet(
        job: workFlowParams.job,
        selectedStages: WorkFlowStagesService.getSelectedStages(workFlowParams),
        onDone: () async {
          pendingTasksCompleted = true;
          Get.back();
          if (!workFlowParams.isDivisionWorkflowUpdate) {
            if (!skipStageUpdate) await handleStageUpdate();
          }
        },
      ),
      isScrollControlled: true,
    );

    return pendingTasksCompleted;
  }

  /// Shows sales automation confirmation dialog
  /// Returns true if user confirms automation, false if cancelled
  /// This allows calling code to determine whether to proceed with stage updates
  Future<bool> showSalesAutomationDialog() async {
    bool userConfirmedAutomation = false;
    await showJPBottomSheet(child: (controller) {
      controller.switchValue = true;
      return JPConfirmationDialogWithSwitch(
        title: 'confirmation'.tr.toUpperCase(),
        subTitle:
            '${'you_are_about_to_move_this_job_to'.tr} ${WorkFlowStagesService.getStages(workFlowParams)?[workFlowParams.newStageIndex].name} ${'stage_click_yes_to_confirm'.tr}',
        toggleTitle: 'workflow_automation'.tr,
        toggleValue: isSubContractorPrime ? false : controller.switchValue,
        suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
        disableButtons: controller.isLoading,
        isToggleVisible: isSubContractorPrime ? false : true,
        suffixBtnText: controller.isLoading ? '' : 'yes'.tr.toUpperCase(),
        onSuffixTap: (val) {
          // Mark as confirmed when user taps the confirmation button
          userConfirmedAutomation = true;
          onSalesAutomationConfirmation(controller, val);
        },
      );
    });

    return userConfirmedAutomation;
  }

  /// Handles user confirmation for sales automation
  /// For division updates: stores user preference for automation
  /// For regular updates: immediately processes automation based on user choice
  Future<void> onSalesAutomationConfirmation(JPBottomSheetController controller, bool val) async {
    // For division workflow updates, just store the preference
    if (workFlowParams.isDivisionWorkflowUpdate) {
      workFlowParams.showWorkFlowAutomation = val;
      // Close the dialog immediately for division updates since we only need to store the preference
      Get.back();
      return;
    }

    // For regular workflow updates, process immediately
    controller.toggleIsLoading();
    await moveToStage(toggleIsLoading: controller.toggleIsLoading);
    Get.back();
    if (val) {
      navigateToSalesAutomation();
    }
  }

  Future<void> navigateToSalesAutomation() async {
    final stages = WorkFlowStagesService.getStages(workFlowParams);
    bool sendCustomerEmail = stages?[workFlowParams.newStageIndex].sendCustomerEmail ?? false;
    bool createTask = stages?[workFlowParams.newStageIndex].createTasks ?? false;
    if(sendCustomerEmail) {
      await Get.toNamed(Routes.jobSaleAutomationEmailListing,arguments: {
        'stage_code':workFlowParams.selectedStageCode,
        'jobId': job.id,
        'create_task': createTask,
        'send_customer_email': sendCustomerEmail
      });
    }
    if(createTask && !sendCustomerEmail) {
      await Get.toNamed(Routes.jobSaleAutomationTaskListing,arguments: {
        'stage_code':workFlowParams.selectedStageCode,
        'jobId': job.id,
        'send_customer_email': sendCustomerEmail
      });
    }
  }

  // doShowSalesAutomationDialog() : checks whether sales automation dialog needs to be displayed
  // depends on new stage values
  bool doShowSalesAutomationDialog() {
    dynamic val = CompanySettingsService.getCompanySettingByKey('SALE_AUTOMATION');
    bool doShowSalesAutomation = Helper.isTrue(val is Map ? val['enable_for_mobile'] : <String, dynamic>{});
    // Use centralized getStages method to support both regular and division-based workflows
    final stages = WorkFlowStagesService.getStages(workFlowParams);
    bool sendCustomerEmail = stages?[workFlowParams.newStageIndex].sendCustomerEmail ?? false;
    bool createTask = stages?[workFlowParams.newStageIndex].createTasks ?? false;
    return doShowSalesAutomation && (sendCustomerEmail || createTask);
  }

  // changeJobCompletionDate() : updates current job completion date and start end dates of neaby stages
  Future<void> changeJobCompletionDate(int index) async {
    if (job.stages?[index].isCurrentStage ?? false) {

    } else {
      DateTime? firstDate = DateTime.tryParse(DateTimeHelper.convertSlashIntoHyphen(job.stages?[index].startDate ?? ''));
      DateTime? lastDate = DateTime.tryParse(DateTimeHelper.convertSlashIntoHyphen(job.stages?[index].endDate ?? ''));
      DateTime? initialDate = DateTime.tryParse(DateTimeHelper.convertSlashIntoHyphen(job.stages?[index].completedDate ?? ''));

      DateTime? selectedDate = await showJPDialog(
        child: (_) => JPDatePicker(
          firstDate: firstDate,
          initialDate: initialDate,
          lastDate: lastDate,
        ),
      );

      if (selectedDate != null) {
        final tempDate = DateTimeHelper.format(selectedDate, DateFormatConstants.dateTimeServerFormat);
        await WorkFlowStagesServiceRepo.updateJobCompletionDate(workFlowParams, index, tempDate);
        update();
      }
    }
  }

  // moveToStage() : moves to new stage along with refreshing job
  Future<void> moveToStage({bool showLoader = false,VoidCallback? toggleIsLoading}) async {
    try {
      if (showLoader) showJPLoader(msg: 'updating_stage'.tr);
      await WorkFlowStagesServiceRepo.moveToStage(workFlowParams: workFlowParams);
      await refreshPage(showLoader: false);
      scrollList();
    } catch (e) {
      rethrow;
    } finally {
      toggleIsLoading?.call();
      if (showLoader) Get.back();

    }
  }

  Future<void> refreshPage({bool showLoader = false}) async {
    try {
      if (showLoader) showJPLoader(msg: 'refreshing_changes'.tr);
      await refreshJob?.call(showLoading: false);
    } catch (e) {
      rethrow;
    } finally {
      if (showLoader) Get.back();
      scrollList();
    }
  }

  void showProjectStatusDialog() {

    if (Helper.isValueNullOrEmpty(users)) return;

    final newStageId = workFlowParams.projectStages![workFlowParams.newStageIndex].id;

    showJPGeneralDialog(
      child: (_) {
        return JobOverViewProjectStatusDialog(
          users: users!,
          parentId: workFlowParams.job.id,
          stageId: newStageId.toString(),
          onDone: (doRefresh) async {
            Get.back();
            workFlowParams.selectedStageCode = newStageId.toString();
            await refreshPage(showLoader: true);
          },
        );
      },
    );
  }
}
