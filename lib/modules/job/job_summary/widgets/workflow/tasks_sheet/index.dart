import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/task_tile/index.dart';
import 'package:jobprogress/modules/job/job_summary/widgets/workflow/tasks_sheet/shimmer.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';

class JobOverViewTaskSheet extends StatelessWidget {
  const JobOverViewTaskSheet({
    super.key,
    required this.job,
    required this.selectedStages,
    this.onDone
  });

  /// stores job date
  final JobModel job;

  /// Stores list of selectedStages
  final List<String> selectedStages;

  /// call back to last controller
  final Future<void> Function()? onDone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10
      ),
      child: Material(
        color: JPAppTheme.themeColors.base,
        borderRadius: JPResponsiveDesign.bottomSheetRadius,
        child: JPSafeArea(
          child: GetBuilder<JobOverViewTaskSheetController>(
              init: JobOverViewTaskSheetController(job, selectedStages, onDone),
              builder: (controller) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    JPResponsiveBuilder(
                      mobile: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 4,
                              width: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: JPAppTheme.themeColors.dimGray),
                            )
                          ],
                        ),
                      ),
                      tablet: const SizedBox(
                        height: 16,
                      ),
                    ),
                    /// title
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: JPText(
                        text: 'confirmation'.tr.toUpperCase(),
                        textSize: JPTextSize.heading3,
                        fontWeight: JPFontWeight.medium,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    /// subtitle
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: JPText(
                        text: 'to_proceed_please_mark_the_following_pending_tasks_as_complete'.tr,
                        textSize: JPTextSize.heading5,
                        textColor: JPAppTheme.themeColors.tertiary,
                        textAlign: TextAlign.start,
                        height: 1.5,
                      ),
                    ),
                    /// tasks list
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      constraints: BoxConstraints(
                          maxHeight: controller.isLoading
                              ? Get.height * 0.5
                              : Get.height * 0.85),
                      child: controller.isLoading
                          ? const JobOverViewTasksShimmer()
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                JPListView(
                                  shrinkWrap: true,
                                  itemBuilder: (_, index) {
                                    return DailyPlanTasksListTile(
                                      taskItem: controller.tasks[index],
                                      showCheckBox: true,
                                      checkValue:
                                          controller.tasks[index].completed !=
                                              null,
                                      onTapCheckBox: (val) {
                                        controller.markAsCompleted(index);
                                      },
                                    );
                                  },
                                  listCount: controller.tasks.length - 1,
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    /// buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: JPResponsiveDesign.popOverButtonFlex,
                            child: JPButton(
                              size: JPButtonSize.small,
                              colorType: JPButtonColorType.lightGray,
                              text: 'cancel'.tr.toUpperCase(),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            flex: JPResponsiveDesign.popOverButtonFlex,
                            child: JPButton(
                              onPressed: onDone,
                              size: JPButtonSize.small,
                              disabled: controller.isProceedButtonDisabled(),
                              colorType: JPButtonColorType.primary,
                              text: controller.isUpdatingStage ? '' : 'proceed'.tr.toUpperCase(),
                              // iconWidget: showJPConfirmationLoader(
                              //   show: controller.isUpdatingStage
                              // ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
