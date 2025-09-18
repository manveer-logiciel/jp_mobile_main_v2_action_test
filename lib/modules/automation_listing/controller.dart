import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/automation/automation.dart';
import 'package:jobprogress/common/models/automation/filter.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/common/repositories/automation.dart';
import 'package:jobprogress/common/repositories/task_listing.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/count.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/automation.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/pagination_constants.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/controller.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/automation_listing/widget/filter_dialog/index.dart';
import 'package:jobprogress/modules/automation_listing/widget/stage_unlock_dialog/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';

class AutomationListingController extends GetxController {
  List<AutomationModel> automationList = [];
  List<WorkFlowStageModel> workflowList = [];
  
  bool isLoading = true;
  bool isLoadMore = false;
  bool canShowLoadMore = true;
  
  int page = 1;

  AutomationFilterModel filterKeys = AutomationFilterModel();
  AutomationFilterModel defaultFilters = AutomationFilterModel();

  Future<void> fetchAutomation({Map<String, dynamic> ? filterParams}) async {
    Map<String, dynamic> paramKey = {
      "page": page,
    };
    
    if(!Helper.isValueNullOrEmpty(filterParams)) {
      paramKey.addAll(filterParams!);  
    }
    
    try {
      Map<String, dynamic> response = await AutomationRepository().fetchAutomation(paramKey);
      List<AutomationModel> list = response["data"]; 
      
      if (!isLoadMore) {
        automationList = [];
      }
      automationList.addAll(list);
      canShowLoadMore = automationList.length < response["pagination"]["total"];
      setToStageEmailTaskCount(workflowList, automationList);
      
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      isLoadMore = false;
      CountService.automationCount = 0;
      update();
    }
  }

  Future<void> refreshList({bool? showLoading}) async {
    page = 1;
    isLoadMore = false;
    isLoading = true;
    update();
    await fetchAutomation();
  }

  Future<void> fetchWorkflow() async {
    Map<String, dynamic> param = {
      "includes[]": 'meta'
    };
    try {
      workflowList = await AutomationRepository().fetchWorkflow(param);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> skipEmailTaskAutomation(int index) async {
    Map<String, dynamic> params = {
      "email_automation_status" : AutomationConstants.skipped,
      "task_automation_status" : AutomationConstants.skipped
    };
    try {
      await AutomationRepository().updateEmailTaskAutomationStatus(id:automationList[index].id.toString(), params: params);
      automationList[index].taskEmailSkipped = true ;
      Helper.showToastMessage('automation_skipped'.tr);
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
      update();
    }
  }

  void undoConfirmationDialog({required String customerJobName, required String stageName, required String id, required int index}) {
    showJPBottomSheet(child: (controller) {
      return JPConfirmationDialog(
        icon: Icons.report_problem_outlined,
        title: 'confirmation'.tr,
        subTitle: '${'automation_confirmation'.tr} $customerJobName ${'back_to'.tr} $stageName ${'stage'.tr}',
        disableButtons: controller.isLoading,
        suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
        suffixBtnText: controller.isLoading ? null : 'confirm'.tr,
        onTapSuffix: () async { 
            controller.toggleIsLoading();
            await undoAutomation(id, index: index,controller: controller);
          },
        onTapPrefix: () {
          Get.back();
        },
      );
    });
  }

  void unblockAutomationConfirmationDialog({required int index}) {
    showJPBottomSheet(child: (controller) {
      return JPConfirmationDialog(
        icon: Icons.report_problem_outlined,
        title: 'confirmation'.tr,
        subTitle: 'unblock_automation_confirmation'.tr,
        disableButtons: controller.isLoading,
        suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
        suffixBtnText: controller.isLoading ? null : 'confirm'.tr,
        onTapSuffix: () async { 
          controller.toggleIsLoading();
          await getUpdatedAutomation(automationList[index].id.toString(), index,showLoader: false);
        },
        onTapPrefix: () {
          Get.back();
        },
      );
    });
  }

  Future<void> undoAutomation(String id,{required int index, required JPBottomSheetController controller}) async {
    try {
      await AutomationRepository().undoAutomation(id);
      automationList[index].showReverted = true;
      Helper.showToastMessage('automation_reverted'.tr);
      update();
    } catch (e) {
      rethrow;
    } finally {
      controller.toggleIsLoading();
       Get.back();
    }
  }

  void  navigateToAutomationDetails(int index) async {
    WorkFlowStageModel? stage = automationList[index].displayData?.toStage;
    bool sendCustomerEmail = stage?.sendCustomerEmail ?? false;
    bool createTask = stage?.createTasks ?? false;
    if(sendCustomerEmail) {
      automationList[index].taskEmailSkipped = await Get.toNamed(
        Routes.jobSaleAutomationEmailListing,arguments: 
        {
        'stage_code':stage?.code,
        'jobId': automationList[index].job?.id,
        'create_task': createTask,
        'send_customer_email': sendCustomerEmail,
        NavigationParams.automationId : automationList[index].id.toString()
        },
        preventDuplicates: false
      );
    }
    if(createTask && !sendCustomerEmail) {
      automationList[index].taskEmailSkipped = await Get.toNamed(
        Routes.jobSaleAutomationTaskListing,arguments: 
        {
        'stage_code':stage?.code,
        'jobId': automationList[index].job?.id,
        'send_customer_email': sendCustomerEmail,
        NavigationParams.automationId : automationList[index].id
        },
        preventDuplicates: false
      );
    }
    update();
  }

  Future <List<TaskListModel>> getInCompleteTasks({required List<String> stages, required int jobId, required int index}) async {
    try {
      Map<String, dynamic> params = {
        "include_locked_task" : 1,
        "includes[]": "stage",
        "job_id": jobId,
        "status": "pending",
        "stage_code[]": stages,
        "limit": PaginationConstants.noLimit
      };

      final response = await TaskListingRepository().fetchTaskList(params, type: AutomationConstants.automation);
      return response['list'];
    } catch (e) { 
      rethrow;
    } finally {
    }
  }

  void onExpansionChanged(bool val,{required List<String> stages, required int jobId, required int index}) async {
    if(val != automationList[index].isExpanded) {
      if (val) {
        automationList[index].taskList = await getInCompleteTasks(stages:stages , jobId: jobId, index: index);
        update();
      }
      automationList[index].isExpanded = val;
    }
  }

  Future<void> loadMore() async {
    page += 1;
    isLoadMore = true;
    await fetchAutomation();
  }

  Future<void> markAsCompleted({required int taskIndex, required int index}) async {
    try {
      showJPLoader();
      final response = await TaskListingRepository().markTaskAsComplete(automationList[index].taskList![taskIndex].id, automationList[index].taskList![taskIndex].completed);
      automationList[index].taskList![taskIndex].completed = response.completed;
      automationList[index].incompleteTaskLockCount = (automationList[index].incompleteTaskLockCount ?? 0) - 1;
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  Future<void> updateAutomationAfterTaskComplete({required int index, required int taskIndex }) async {
    await markAsCompleted(taskIndex: taskIndex, index: index);
    if(automationList[index].incompleteTaskLockCount == 0) {
      await getUpdatedAutomation(automationList[index].id.toString(), index);
    }
    update();
  }

  void openStageUnlockDialog() {
    showJPGeneralDialog(
      child: (_) => const StageUnlockDialog(),
    );
  }

  Future<void> getUpdatedAutomation(String id, int index, {bool showLoader = true}) async {
    AutomationModel? automation;
    try {
      if(showLoader){
        showJPLoader();
      }
      automation = await AutomationRepository().updateStageProgression(id);
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
      if(automation != null) {
        openStageUnlockDialog();
        automationList[index] = automation;
        setToStageEmailTaskCount(workflowList, automationList);
      }
    }
  }

  bool showTaskCheckBox(int automationIndex, int index) {
    List<UserLimitedModel>? participants = automationList[automationIndex].taskList![index].participants;
    return AuthService.isAdmin() || isParticipantHadLoggedInUser(participants: participants) ||
      PermissionService.hasUserPermissions([PermissionConstants.manageTasksCreatedByOtherUsers]);
  }

  bool isAutomationSucceeded(int index) {
    return automationList[index].automationStatus == AutomationConstants.succeeded;
  }

  bool isAutomationBlocked(int index) {
    return automationList[index].automationStatus == AutomationConstants.blocked;
  }

  bool hadIncompleteTasks(int index) {
    return (automationList[index].incompleteTaskLockCount ?? 0) != 0;
  }

  bool canProceedAutomation(int index) {
    return (!hadIncompleteTasks(index)) && isAutomationBlocked(index);
  }

  bool isParticipantHadLoggedInUser({List<UserLimitedModel>? participants}) {
    int loggedInUserId = AuthService.userDetails!.id;
    return participants?.any((element) => element.id == loggedInUserId) ?? false;  
  }
  
  void setToStageEmailTaskCount(List<WorkFlowStageModel> stages, List<AutomationModel> automationList) {
    for(AutomationModel automationModel in automationList) {
      for(WorkFlowStageModel stage in stages) {
        if(automationModel.displayData?.toStage?.code == stage.code) {
          automationModel.displayData?.toStage = WorkFlowStageModel(
            name: stage.name,
            code: stage.code,
            position: stage.position,
            color: stage.color,
            createTasks: stage.createTasks,
            sendCustomerEmail: stage.sendCustomerEmail,
            emailCount: stage.emailCount,
            taskCount: stage.taskCount,
          );
        }
      }
    }
  }

  bool showActionButtons(int index) {
    final automation = automationList[index];
    final toStage = automation.displayData?.toStage;
    
    return (toStage?.createTasks ?? false) ||
      (toStage?.sendCustomerEmail ?? false) ||
      (automation.enableUndo ?? false) ||
      (automation.showReverted ?? false) ||
      (!hadIncompleteTasks(index) && isAutomationBlocked(index));
  }

  bool showActionButtonDivider(int index) {
    return undoButtonEnable(index) || 
    (automationList[index].showReverted ?? false) ||
      (!hadIncompleteTasks(index) && isAutomationBlocked(index));
  }

  bool undoButtonEnable(int index) {
    return (automationList[index].enableUndo ?? false) && 
      (!(automationList[index].showReverted ?? false));
  }

  bool showSkipSendButton(int index) {
    return ((automationList[index].displayData?.toStage?.createTasks ?? false) || 
      (automationList[index].displayData?.toStage?.sendCustomerEmail ?? false)) &&
      isAutomationSucceeded(index) && !automationList[index].taskEmailSkipped &&
      undoButtonEnable(index);
  }

  bool hasTasksOrEmail(int index) {
    AutomationModel automation = automationList[index];
    WorkFlowStageModel? toStage = automation.displayData?.toStage;

    final hasTasksOrEmail = (toStage?.createTasks ?? false) ||
      (toStage?.sendCustomerEmail ?? false);

    return hasTasksOrEmail && isAutomationSucceeded(index) && !automation.taskEmailSkipped  && undoButtonEnable(index);
  }

  void openFilterDialog() {
    showJPGeneralDialog(
      child: (controller) => AutomationFilterDialogView(
        selectedFilters: filterKeys,
        defaultFilters: defaultFilters,
        onApply: (AutomationFilterModel params) {
          filterKeys = AutomationFilterModel.copy(params);
          updateFilterSettings();
        },
      )
    );
  }

  void showSkippedConfirmation(int index) {
    showJPBottomSheet(
      child: (controller) {
        return JPConfirmationDialog(
          icon: Icons.report_problem_outlined,
          title: "confirmation".tr,
          subTitle: "please_confirm_that_you_want_to_skip_all_automation_tasks_and_emails_for_this_stage".tr,
          suffixBtnText: controller.isLoading ? null : 'confirm'.tr.toUpperCase(),
          disableButtons: controller.isLoading,
          suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
          onTapPrefix: () {
            Get.back();
          },
          onTapSuffix: () async {
            controller.toggleIsLoading();
            await skipEmailTaskAutomation(index);
          },
        );
      }
    );
  }

  void updateFilterSettings() {
    Map<String, dynamic> filterParams = filterKeys.toJson()..removeWhere(
      (dynamic key, dynamic value) => (key == null || value == null));
    page = 1;
    isLoading = true;
    update();
    fetchAutomation(filterParams: filterParams);
  }

  @override
  void onInit() async {
    super.onInit();
    await fetchWorkflow();
    await fetchAutomation();
  }
}
