
import 'package:get/get.dart';
import 'package:jobprogress/common/extensions/mix_panel/extension.dart';
import 'package:jobprogress/common/models/workflow/service_params.dart';
import 'package:jobprogress/common/repositories/work_flow_stages.dart';
import 'package:jobprogress/common/services/workflow_stages/index.dart';
import 'package:jobprogress/core/constants/mix_panel/titles.dart';
import 'package:jobprogress/core/constants/work_flow_stage_color.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/job/job_summary/widgets/workflow/job_since_date_update_dialog/index.dart';

class WorkFlowStagesServiceRepo {

  static Future<int> fetchIncompleteTaskCount({required WorkFlowStagesServiceParams workFlowParams, bool useLastStageCode = false}) async {
    try {
      showJPLoader(msg: 'checking_pending_tasks'.tr);

      Map<String, dynamic> params = {
        "job_id": workFlowParams.job.id,
        // Use centralized getStages method to ensure consistency across regular and division workflows
        "stage_code[]": useLastStageCode
            ? WorkFlowStagesService.getStages(workFlowParams)?.last.code : WorkFlowStagesService.getSelectedStages(workFlowParams)
      };

      return await WorkflowStagesRepository.fetchIncompleteTaskLockCount(params);
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  static Future<void> updateJobCompletionDate(WorkFlowStagesServiceParams workFlowParams,int index, String date) async {

    if(index == 0) {
      DateTime startDate = DateTime
          .parse(workFlowParams.job.jobWorkFlowHistory![0].startDate?.substring(0, 10) ?? DateTime.now().toString());
      DateTime selectedDate = DateTime.parse(date);

      if(startDate.isAfter(selectedDate)) {
        await showChangeJobDueDateConfirmation(workFlowParams: workFlowParams, date: date);
      } else {
        await updateJobCompletionDateApiCall(workFlowParams, index, date);
      }
    } else {
      await updateJobCompletionDateApiCall(workFlowParams, index, date);
    }
  }

  static Future<void> moveToStage({required WorkFlowStagesServiceParams workFlowParams, bool showLoader = false}) async {
    try {
      Map<String, dynamic> params = {
        'job_id': workFlowParams.job.id,
        'stage': workFlowParams.job.stages![workFlowParams.newStageIndex].code
      };
      await WorkflowStagesRepository.moveToStage(params);
      workFlowParams.selectedStageCode = workFlowParams.job.stages![workFlowParams.newStageIndex].code;
      WorkFlowStagesService.setScrollIndex(workFlowParams);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> markAsCompleteApiRequest({required WorkFlowStagesServiceParams workFlowParams}) async {
    try {
      Map<String, dynamic> params = {
        'job_id': workFlowParams.job.id,
        'date': workFlowParams.forMarkAsComplete! ? DateTime.now().toString() : ''
      };

      await WorkflowStagesRepository.markAsCompleteLastStage(params);

      WorkFlowStagesService.markLastStageAsCompleted(workFlowParams);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> getProjectStages({required WorkFlowStagesServiceParams workFlowParams}) async {
    try {
      if (workFlowParams.job.parentId != null) {
        Map<String, dynamic> params = {
          'limit': 0,
        };
        final projectStagesList = await WorkflowStagesRepository.getProjectStages(params);
        workFlowParams.projectStages = projectStagesList;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> showChangeJobDueDateConfirmation({required WorkFlowStagesServiceParams workFlowParams, required String date}) async {
    await showJPBottomSheet(
        child: (controller) => JobSinceDateConfirmation(
          stageName: workFlowParams.job.stages?.first.name ?? '',
          stageColor: WorkFlowStageConstants.colors[workFlowParams.job.stages?.first.color],
          isLoading: controller.isLoading,
          onConfirm: () async {
            controller.toggleIsLoading();
            await updateJobCompletionDateApiCall(workFlowParams, 0, date, showLoader: false)
                .then((value) {
              workFlowParams.job.jobWorkFlowHistory![0].startDate = date;
            });
            controller.toggleIsLoading();
          },
        ),
        isScrollControlled: true
    );
  }

  static Future<void> updateJobCompletionDateApiCall(WorkFlowStagesServiceParams workFlowParams,int index, String date, {bool showLoader = true}) async {
    try {
      if(showLoader) showJPLoader();

      Map<String, dynamic> params = {
        "job_id": workFlowParams.job.id,
        "stage_code": workFlowParams.job.stages![index].code,
        "completed_date": date
      };

      await WorkflowStagesRepository.changeStageDate(params).trackUpdateEvent(MixPanelEventTitle.jobCompletionDateUpdate);

      WorkFlowStagesService.updateJobStageDates(index, workFlowParams, tempDate: date);
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

}