import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/job_work_flow_history.dart';
import 'package:jobprogress/common/models/workflow/project_stages.dart';
import 'package:jobprogress/common/models/workflow/service_params.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/common/services/workflow_stages/repo.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/constants/work_flow_stage_color.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/job/job_summary/widgets/workflow/stages/controller.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class WorkFlowStagesService {

  static const String controllerTag = "workflow_stage_service_";

  // setUpWorkFlowStagesParams() : will be used while loading or refreshing a job.
  // it basically helps in handling response we are having from server and set up params for workflow stages
  // or projects along with initial scroll, date filters, lost job case and list height as per response
  static Future<WorkFlowStagesServiceParams> setUpWorkFlowStagesParams(JobModel job) async {

    WorkFlowStagesServiceParams params = WorkFlowStagesServiceParams(job: job);

    params.isProject = job.parentId != null; // check if job or project

    // checking for lost job
    params.isLostJob = !Helper.isValueNullOrEmpty(job.jobLostDate);

    if(params.isProject) {
      await WorkFlowStagesServiceRepo.getProjectStages(workFlowParams: params);
      setUpProjectWorkFlowStages(params);
      setUpProjectStageSelectionList(params);
    } else {
      setUpJobWorkFlowStages(params);
      setUpJobStageSelectionList(params);
    }

    // setting up horizontal stages list height
    params.listHeight = getListHeight(params);
    params.stageWidth = getStageWidth(params);
    params.disableScroll = doDisableScroll(params);

    return params;

  }

  /// FOR JOB WORKFLOW STAGES

  // setUpJobWorkFlowStages() : will help in setting up job workflow stages
  static void setUpJobWorkFlowStages(WorkFlowStagesServiceParams params) {
    setUpJobWorkflowHistory(params);

    final historyLength = params.job.jobWorkFlowHistory?.length ?? 0;

    // in case job workflow history is empty
    if(historyLength == 0) {
      // setting up first stage as selected
      final firstStage = params.job.stages!.first;
      params.job.jobWorkFlowHistory = [];
      params.job.jobWorkFlowHistory?.add(
        JobWorkFlowHistoryModel(
          stage: firstStage.name,
          completedDate: JobWorkFlowHistoryModel.parseDate(params.job.createdDate ?? '')
        )
      );
      // setting up first stage date
      setStageDates(0, job: params.job);
    } else {
      // in case workflow history is not empty, setting up dates for all available stages
      for (int i = 0; i < historyLength; i++) {
        setStageDates(i, job: params.job);
      }
    }

    // setting current stage date
    if(historyLength != params.job.stages!.length) {
      params.job.stages?[historyLength].completedDate = params.job.jobWorkFlowHistory![historyLength > 0 ? historyLength - 1 : 0].completedDate;
      params.job.stages?[historyLength].isCurrentStage = true;
      params.selectedStageCode = params.job.stages![historyLength].code;
    }

    // setting mark as resolve and reinstate
    params.job.stages?.last.doShowMarkAsCompleted = doShowMarkAsCompleted(params.job);
    params.job.stages?.last.doShowReinstate = doShowReInitiate(params.job);

    setScrollIndex(params);
  }

  // setStageDates() : In case of job workflow stages, each stage carrying a date. This function helps in setting
  // stage date and stage date constraints (so date can be only selected from within a range)
  static void setStageDates(int i, {required JobModel job}) {

    final historyLength = job.jobWorkFlowHistory!.length;

    if(i < 0 || i > historyLength - 1) return;

    final history = job.jobWorkFlowHistory![i];
    final previousStageHistory = i <= 0 ? null : job.jobWorkFlowHistory![i - 1];
    final nextStageHistory = i < historyLength - 1 ? job.jobWorkFlowHistory![i + 1] : history;

    job.stages?[i].completedDate = history.completedDate;
    job.stages?[i].startDate = previousStageHistory?.completedDate;
    job.stages?[i].endDate = nextStageHistory.completedDate;
  }

  // setUpJobStageSelectionList() : will set up job workflow stage switch/filter list
  static void setUpJobStageSelectionList(WorkFlowStagesServiceParams params) {
    params.stageSelectionList = [];
    // Use division-specific stages when updating division workflow, otherwise use default stages
    final stages = getStages(params);
    stages?.forEach((stage) {
      params.stageSelectionList?.add(
        JPSingleSelectModel(
          label: stage.name,
          id: stage.code,
          color: WorkFlowStageConstants.colors[stage.color],
          additionalData: stage,
        ),
      );
    });
  }

  // updateJobStageDates() : will help in updating job workflow stage date and date selection constraints for
  // very first near stages
  static void updateJobStageDates(int i, WorkFlowStagesServiceParams params, {String? tempDate}) {

    final date = JobWorkFlowHistoryModel.parseDate(tempDate!);

    final historyLength = params.job.jobWorkFlowHistory!.length;

    int previousIndex = i - 1;
    int nextIndex = i + 1;

    // updating date constraint for previous to selected stage if any
    if(previousIndex >=0 ) {
      params.job.stages![previousIndex].endDate = date;
    }
    // updating date constraint for next to selected stage if any
    if(nextIndex < historyLength - 1) {
      params.job.stages![nextIndex].startDate = date;
    }

    params.job.jobWorkFlowHistory![i].completedDate = date;

    // updating stages and date filters
    setUpJobWorkFlowStages(params);

  }

  // markLastStageAsCompleted() : In case of job workflow helps in marking last stage as complete or re-instate
  static void markLastStageAsCompleted(WorkFlowStagesServiceParams params) {
    if(params.forMarkAsComplete!) {
      params.job.jobWorkflow?.lastStageCompletedDate = DateTime.now().toString();
    } else {
      params.job.jobWorkflow?.lastStageCompletedDate = null;
    }
    setUpJobWorkFlowStages(params);
  }

  static bool doShowMarkAsCompleted(JobModel job) {

    bool isCurrentStageIsLastStage = job.currentStage!.code == job.stages!.last.code;
    bool isLastNotCompleted = job.jobWorkflow?.lastStageCompletedDate == null;

    return isCurrentStageIsLastStage && isLastNotCompleted;
  }

  static bool doShowReInitiate(JobModel job) {

    bool isCurrentStageIsLastStage = job.currentStage!.code == job.stages!.last.code;
    bool isLastNotCompleted = job.jobWorkflow?.lastStageCompletedDate != null;

    return isCurrentStageIsLastStage && isLastNotCompleted;
  }

  // getSelectedStages() : returns stages stage codes from current index to new index
  static List<String> getSelectedStages(WorkFlowStagesServiceParams params) {
    return getStages(params)?.sublist(params.currentStageIndex, params.newStageIndex).map((e) => e.code).toList() ?? [];
  }

  // getListHeight() : helps in making dynamic list height dynamic for job work flow and projects. Moreover in job overflow there can be chances
  // for Mark As Complete/Reinstate to be displayed.
  static double getListHeight(WorkFlowStagesServiceParams params) {
    final isMarkAsCompleteVisible = params.job.stages!.any((element) => element.doShowMarkAsCompleted ?? false);
    final isReinstateVisible = params.job.stages!.any((element) => element.doShowReinstate ?? false);
    if(params.isProject) {
      return params.isLostJob ? 110 : 125;
    } else if(isMarkAsCompleteVisible || isReinstateVisible) {
      return 180;
    } else {
      return 160;
    }
  }

  static bool doDisableScroll(WorkFlowStagesServiceParams params) {

    if (RunModeService.isUnitTestMode) return false;

    if(params.isProject) {
      int projectsCount = (params.projectStages?.length ?? 0);
      double totalProjectsWidth = (projectsCount * (params.stageWidth + 25)) + 24;
                                //(projectsCount * (stageWidth + internal padding) + horizontal padding
      return Get.width > totalProjectsWidth;
    } else {
      int projectsCount = (params.job.stages?.length ?? 0);
      double totalJobsWidth = (projectsCount * (params.stageWidth + 10)) + 32;
      return Get.width > totalJobsWidth;
    }
  }

  /// FOR PROJECT WORKFLOW STAGES

  // setUpProjectWorkFlowStages() : will help in setting up project stages
  static void setUpProjectWorkFlowStages(WorkFlowStagesServiceParams params) {

    ProjectStageModel? currentStage = params.job.parent?.projectStatus?.status;
    List<ProjectStageModel> stages = params.projectStages ?? [];

    if(currentStage == null) {
      params.job.currentStage = null;
      return;
    }

    final index = stages.indexWhere((stage) => stage.id == currentStage.id);

    for(int i=0; i<stages.length; i++) {
      if(i == index) {
        stages[i].isCurrentStage = true;
      } else if(i < index) {
        stages[i].isCompleted = true;
      }
    }

    params.selectedStageCode = currentStage.id.toString();

    setScrollIndex(params);
  }

  // setUpProjectStageSelectionList() : will set up project stage switch/filter list
  static void setUpProjectStageSelectionList(WorkFlowStagesServiceParams params) {
    params.stageSelectionList = [];
    params.projectStages?.forEach((stage) {
      params.stageSelectionList?.add(
        JPSingleSelectModel(
            label: stage.name.toString(),
            id: stage.id.toString(),
            color: JPAppTheme.themeColors.tertiary
        ),
      );
    });
  }


  /// COMMONS

  // setScrollIndex() : is used for both job stages and project stages, it helps in setting up scroll index
  static void setScrollIndex(WorkFlowStagesServiceParams params, {bool firstTime = true}) {
    int selectedItemIndex = 0;
    if(firstTime) {
      if (params.isProject) {
        ProjectStageModel? currentStage = params.job.parent?.projectStatus?.status;
        selectedItemIndex = params.projectStages!.indexWhere((element) => element.id == currentStage?.id);
      } else {
        bool jobStagesExists = !Helper.isValueNullOrEmpty(params.job.stages);
        if (jobStagesExists && (params.job.stages!.first.isCurrentStage ?? false)) {
          selectedItemIndex = 0;
        } else {
          selectedItemIndex = params.job.jobWorkFlowHistory!.length;
        }
      }
    }
    params.scrollIndex = selectedItemIndex;
  }

  // setCurrentNewStageIndex() : helps in setting up current stage and new stage index while switching job or project stage
  // which will helps in generating set of stages falling between to pass in api
  static void setCurrentNewStageIndex(WorkFlowStagesServiceParams params, {String? newStageCode, bool? isForMarkAsComplete}) {
    if(newStageCode == null) {
      params.newStageIndex = params.currentStageIndex = params.job.stages!.length - 1;
    } else if (params.isDivisionWorkflowUpdate) {
      params.currentStageIndex = 0;
      params.newStageIndex = params.stageSelectionList!.indexWhere((element) => element.id == newStageCode);
    } else {
      params.currentStageIndex =
          params.stageSelectionList!.indexWhere((element) =>
          element.id
              == params.selectedStageCode);
      params.newStageIndex =
          params.stageSelectionList!.indexWhere((element) =>
          element.id == newStageCode);
    }
    params.forMarkAsComplete = isForMarkAsComplete;
    params.scrollIndex = params.newStageIndex;
  }

  /// [getStageWidth] helps in setting flexible dynamic width for job stage
  /// Working:
  ///   - All stage names will be evaluated and a stage name having word with
  ///     maximum width will be selected for base width.
  /// In case of job:
  ///   - If [chosen word] having width less than 80 then [defaultWidth] will be used
  ///   - If [chosen word] having width greater than 80 then [chosen words] width will be used
  /// In case of Project:
  ///   - If [chosen word] having width less than 60 then [defaultWidth] will be used
  ///   - If [chosen word] having width greater than 60 then [chosen words] width will be used
  static double getStageWidth(WorkFlowStagesServiceParams params) {
    double stageWidth = 0;
    List<String>? stageNames = [];

    if (params.isProject) {
      stageNames = params.projectStages?.map((stage) => stage.name ?? "").toList();
    } else {
      stageNames = params.job.stages?.map((stage) => stage.name).toList();
    }
    stageWidth = Helper.getMaxWidthFromWords(stageNames ?? [],
      defaultWidth: params.isProject ? 60 : 80,
    );
    return stageWidth;
  }

  /// [getSelectableStagesList] helps in setting up list of selectable stages
  static List<JPSingleSelectModel> getSelectableStagesList(WorkFlowStagesServiceParams params) {
    // Creating a another list of stages to hold editable data
    List<JPSingleSelectModel> tempSelectionList = [];
    // adding all stages to temp list
    tempSelectionList.addAll(params.stageSelectionList!);
    // giving a check whether stages should be excluded conditionally or not
    bool hasToExcludeStages = AuthService.isStandardUser() && !PermissionService.hasUserPermissions([PermissionConstants.manageFullJobWorkFlow]);
    if(hasToExcludeStages) {
      // removing all the stages with of after awarded job stage
      tempSelectionList.removeWhere((select) {
        return (select.additionalData as WorkFlowStageModel).isOrAfterAwardedStage ?? false;
      });
    }
    return tempSelectionList;
  }

  /// Sets up the workflow controller for division-changed scenarios
  /// This method handles the complex process of updating workflow stages when a job's division changes
  ///
  /// Business Logic:
  /// - When a job's division changes, the available workflow stages may also change
  /// - This method fetches the updated job data with the new division's workflow configuration
  /// - It ensures that the workflow stages are properly synchronized with the division change
  ///
  /// [jobId] - The ID of the job whose division is being updated
  /// [divisionId] - The new division ID to apply to the job
  static Future<void> setUpController({required int jobId, required String divisionId}) async {
    // Clean up any existing workflow controller to prevent conflicts
    // This ensures a fresh start for the division-changed workflow
    if (Get.isRegistered<JobOverViewWorkFlowStagesController>(tag: '$controllerTag$jobId')) {
      await Get.delete<JobOverViewWorkFlowStagesController>(tag: '$controllerTag$jobId');
    }
    
    try {
      // Show loading indicator as this process involves API calls and data processing
      showJPLoader(msg: 'loading_workflow'.tr);

      // Fetch job data with updated division context
      // Use 'workflow_by_division' instead of 'workflow' to get division-specific stages
      // The 'division_id' parameter ensures we get workflow stages specific to the new division
      final response = await JobRepository.fetchJob(jobId, params: {'includes[0]': 'workflow_by_division', 'division_id': divisionId});

      // Validate that job data was successfully retrieved
      if (response['job'] == null) {
        throw Exception('Failed to load job data for workflow setup');
      }

      // Create workflow parameters specifically for division-changed scenarios
      // This configures the workflow UI to handle the division update flow
      final params = await WorkFlowStagesService.setUpDivisionChangedWorkflow(response['job'] as JobModel);

      // dismiss loading indicator
      Get.back();

      // Register the new controller with division-specific workflow configuration
      // The 'onlyBloc' flag indicates this is for data management only, not UI rendering
      Get.put<JobOverViewWorkFlowStagesController>(JobOverViewWorkFlowStagesController(params, onlyBloc: true), tag: '$controllerTag$jobId');
    } catch (e) {
      // dismiss loading indicator
      Get.back();
      // Provide user-friendly error feedback when workflow setup fails
      Helper.showToastMessage('failed_to_load_workflow'.tr);
      rethrow;
    }
  }

  /// Displays the stage selection interface for division-changed workflows
  /// This method provides users with a UI to select the appropriate workflow stage
  /// after a job's division has been updated
  ///
  /// Business Logic:
  /// - After division change, users must select which stage the job should be in
  /// - The available stages are filtered based on the new division's workflow configuration
  /// - Stage selection is mandatory to complete the division update process
  ///
  /// [jobId] - The ID of the job for which to show stage selection
  /// Returns the selected stage code, or null if no selection was made
  static Future<String?> showStageSwitcher({int? jobId}) async {
    // Validate job ID to prevent errors in stage selection
    if (jobId == null) {
      return null;
    }

    // Check if workflow controller exists for this job
    // The controller must be set up via setUpController() before calling this method
    if (Get.isRegistered<JobOverViewWorkFlowStagesController>(tag: '$controllerTag$jobId')) {
      final workflowStagesController = Get.find<JobOverViewWorkFlowStagesController>(tag: '$controllerTag$jobId');
      
      // Present stage selection UI to user
      // This shows available stages based on the new division's workflow
      final updatedStageCode = await workflowStagesController.showStagesSheet();

      // Process user's stage selection
      if (!Helper.isValueNullOrEmpty(updatedStageCode)) {
        // Configure stage transition parameters
        // This sets up the current and new stage indices for the workflow update
        setCurrentNewStageIndex(workflowStagesController.workFlowParams, newStageCode: updatedStageCode);

        // Handle any pending tasks that need completion before stage transition
        bool pendingTasksCompleted = await workflowStagesController.checkPendingTasks();
        if (!pendingTasksCompleted) return null;

        // Show automation dialog before finalizing division change
        // This allows user to decide whether to enable automation for new division
        if (workflowStagesController.doShowSalesAutomationDialog()) {
          final doUpdateStage = await workflowStagesController.showSalesAutomationDialog();
          if (!doUpdateStage) return null;
        }

        // Store the selected stage for subsequent workflow updates
        workflowStagesController.workFlowParams.selectedStageCode = updatedStageCode ?? "";
        return updatedStageCode ?? '';
      }
    }

    // Return null if no valid stage selection was made
    return null;
  }

  /// Handles the final workflow stage update after division change and stage selection
  /// This method completes the division update process by applying the selected stage
  /// and triggering any necessary workflow automation
  ///
  /// Business Logic:
  /// - Finalizes the stage transition after user has selected a new stage
  /// - Handles any pending tasks that need completion before stage transition
  /// - Triggers workflow automation rules for the new stage
  /// - Cleans up temporary controllers used during the division update process
  ///
  /// [jobId] - The ID of the job to update
  static Future<void> handleStageUpdate({int? jobId}) async {
    // Validate job ID to prevent errors in stage update
    if (jobId == null) {
      return;
    }

    // Ensure workflow controller exists before attempting stage update
    if (Get.isRegistered<JobOverViewWorkFlowStagesController>(tag: '$controllerTag$jobId')) {
      final workflowStagesController = Get.find<JobOverViewWorkFlowStagesController>(tag: '$controllerTag$jobId');

      if (workflowStagesController.workFlowParams.showWorkFlowAutomation && workflowStagesController.doShowSalesAutomationDialog()) {
        await workflowStagesController.navigateToSalesAutomation();
      }
      
      // Clean up the temporary workflow controller
      // This controller was created specifically for the division update process
      await Get.delete<JobOverViewWorkFlowStagesController>(tag: '$controllerTag$jobId');
    }
  }

  /// Creates workflow parameters specifically for division-changed scenarios
  /// This method configures the workflow service to handle the unique requirements
  /// of updating workflow stages when a job's division changes
  ///
  /// Business Logic:
  /// - Division changes require special handling because available stages may differ
  /// - The workflow UI needs to be configured to show stage selection instead of normal workflow
  /// - Current stage information is preserved to maintain context during the transition
  ///
  /// [job] - The job model with updated division information
  /// Returns configured workflow parameters for division update scenario
  static Future<WorkFlowStagesServiceParams> setUpDivisionChangedWorkflow(JobModel job) async {
    // Create specialized workflow parameters for division updates
    // The isDivisionWorkflowUpdate flag changes the behavior of workflow UI components
    WorkFlowStagesServiceParams params = WorkFlowStagesServiceParams(job: job, isDivisionWorkflowUpdate: true);
    
    // Preserve current stage context during division change
    // This helps maintain workflow continuity and user understanding
    params.selectedStageCode = job.currentStage?.code ?? "";

    // Set up the list of available stages for selection
    // This list will be filtered based on the new division's workflow configuration
    setUpJobStageSelectionList(params);

    return params;
  }

  /// Shows confirmation dialog for division changes that may impact workflow
  /// This method ensures users understand the implications of changing a job's division
  /// on the available workflow stages before proceeding
  ///
  /// Business Logic:
  /// - Division changes can affect which workflow stages are available to a job
  /// - Users must be informed about potential workflow impacts before confirming
  /// - The confirmation is mandatory to prevent accidental workflow disruptions
  /// - Non-dismissible dialog ensures users make a conscious decision
  ///
  /// Returns true if user confirms the division change, false otherwise
  static Future<bool> divisionImpactWorkflowConfirmation() async {
    // Track user's decision about proceeding with division change
    bool doUpdateDivision = false;

    // Show non-dismissible confirmation dialog
    // This ensures users cannot accidentally bypass the warning
    await showJPBottomSheet(
      child: (_) {
        return JPConfirmationDialog(
          icon: Icons.info_outline,
          title: 'confirmation'.tr,
          // Explain the potential impact of division change on workflow
          subTitle: "division_workflow_confirmation_message".tr,
          onTapSuffix: () async {
            // User confirmed they want to proceed with division change
            doUpdateDivision = true;
            Get.back();
          },
        );
      },
      // Prevent accidental dismissal to ensure conscious decision-making
      isDismissible: false,
    );

    // Return user's decision about proceeding with division change
    return doUpdateDivision;
  }

  /// Returns the appropriate workflow stages based on context
  /// For division updates: returns division-specific stages
  /// For regular workflow: returns default job stages
  static List<WorkFlowStageModel>? getStages(WorkFlowStagesServiceParams params) {
    if (params.isDivisionWorkflowUpdate) {
      return params.job.stagesByDivision;
    }
    return params.job.stages;
  }

  /// Sets up job workflow history based on current stage configuration
  /// This method handles workflow history initialization for both regular and division-based workflows
  /// Note: This is conditionally executed based on the divisionBasedMultiWorkflows feature flag
  static void setUpJobWorkflowHistory(WorkFlowStagesServiceParams params) {
    // Skip initialization if division-based multi-workflows feature is enabled
    // as history setup is handled differently in that context
    if (!LDService.hasFeatureEnabled(LDFlagKeyConstants.divisionBasedMultiWorkflows)) {
      return;
    }

    final workflowStages = getStages(params);

    // Ensure we have valid workflow stages before proceeding
    if (Helper.isValueNullOrEmpty(workflowStages)) {
      return;
    }

    if (!Helper.isValueNullOrEmpty(params.job.jobWorkFlowHistory)) {
      // Rebuild workflow history to match current stage configuration
      // This ensures history is consistent with the current workflow stages
      Map<String, JobWorkFlowHistoryModel> existingHistory = Map.fromEntries(params.job.jobWorkFlowHistory!.map((e) => MapEntry(e.stage ?? "", e)));
      params.job.jobWorkFlowHistory = [];

      // Add history entries for stages that exist in both old and new workflows
      getStages(params)?.forEach((stage) {
        if (!Helper.isValueNullOrEmpty(existingHistory[stage.code])) {
          params.job.jobWorkFlowHistory?.add(existingHistory[stage.code]!);
        }
      });
    }
  }
}
