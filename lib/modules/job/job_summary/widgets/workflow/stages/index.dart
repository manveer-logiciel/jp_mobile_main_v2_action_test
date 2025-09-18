import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/workflow/service_params.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/modules/job/job_summary/widgets/workflow/stages/project_stage_card.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'controller.dart';
import 'job_stage_card.dart';

class JobOverViewWorkflowStages extends StatelessWidget {
  const JobOverViewWorkflowStages({
    super.key,
    required this.params,
    required this.refreshJob,
    required this.users,
  });

  final WorkFlowStagesServiceParams params;

  final Future<void> Function({bool showLoading}) refreshJob;

  final List<JPMultiSelectModel> users;

  @override
  Widget build(BuildContext context) {

    return GetBuilder<JobOverViewWorkFlowStagesController>(
        init: JobOverViewWorkFlowStagesController(
            params,
            refreshJob: refreshJob,
            users: users,
        ),
        global: false,
        didUpdateWidget: (_, state) {
          state.controller?.workFlowParams = params;
          state.controller?.job = params.job;
        },
        builder: (controller) {
          return Opacity(
            opacity: params.isLostJob ? 0.6 : 1,
            child: SizedBox(
              width: Get.width,
              child: Stack(
                children: [
                  /// stage rail
                  Positioned.fill(
                      top: params.isProject ? 78 : 88,
                      child: Column(
                        children: [
                          Divider(
                            height: 2,
                            thickness: 2,
                            color: JPAppTheme.themeColors.dimGray,
                          ),
                        ],
                      )),

                  Column(
                    children: [
                      if (params.isProject) ...{
                        SingleChildScrollView(
                          controller: controller.scrollController,
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: params.disableScroll ? 0 : 12),
                          child: SizedBox(
                            width: params.disableScroll ? Get.width : null,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate((params.projectStages?.length ?? 0), (index) {
                                final stage = params.projectStages![index];

                                final stageWidget = AutoScrollTag(
                                  key: ValueKey(stage.id),
                                  index: index,
                                  controller: controller.scrollController,
                                  child: JobOverViewWorkFlowProjectStageCard(
                                    stage: stage,
                                    isCurrentStage: stage.isCurrentStage ?? false,
                                    isCompleted: stage.isCompleted ?? false,
                                    onTapMove: controller.showStagesSheet,
                                    hideMoveButton: hideMoveProjectStage,
                                    stageWidth: params.stageWidth,
                                  ),
                                );

                                return params.disableScroll ? Expanded(child: stageWidget) : stageWidget;
                              }),
                            ),
                          ),
                        ),
                      } else ...{
                        SingleChildScrollView(
                          controller: controller.scrollController,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: SizedBox(
                            width: params.disableScroll ? Get.width : null,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(params.job.stages?.length ?? 0, (index) {
                                final stage = params.job.stages![index];

                                final stageWidget = AutoScrollTag(
                                  key: ValueKey(stage.code),
                                  index: index,
                                  controller: controller.scrollController,
                                  child: JobOverViewWorkFlowJobStageCard(
                                    stage: stage,
                                    stageDate: stage.completedDate,
                                    isCurrentStage: stage.isCurrentStage ?? false,
                                    doShowMarkAsComplete: stage.doShowMarkAsCompleted ?? false,
                                    doShowReInitiate: stage.doShowReinstate ?? false,
                                    onTapDate: () => params.isLostJob ? null : controller.changeJobCompletionDate(index),
                                    onTapMove: params.isLostJob ? null : controller.showStagesSheet,
                                    onTapMarkAsCompleted: () => params.isLostJob ? null : controller.markAsComplete(forMarkAsComplete: true),
                                    onTapReInstate: () => params.isLostJob ? null : controller.markAsComplete(forMarkAsComplete: false),
                                    hideMoveButton: params.isLostJob,
                                    stageWidth: params.stageWidth,
                                  ),
                                );

                                return params.disableScroll ? Expanded(child: stageWidget) : stageWidget;
                              }),
                            ),
                          ),
                        )
                      }
                    ],
                  ),
                  /// stages
                ],
              ),
            ),
          );
        });
  }

  bool get hideMoveProjectStage => (params.job.isAwarded  ?? false)
      || params.isLostJob
      || params.job.soldOutDate == null
      || AuthService.isPrimeSubUser();

}
