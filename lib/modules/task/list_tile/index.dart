import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/work_flow_stage_color.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/modules/task/list_tile/participant_list.dart';
import 'package:jp_mobile_flutter_ui/Label/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';


//Using this widget to render task list tile
class TaskListTile extends StatelessWidget {
  final TaskListModel task;
  const TaskListTile(this.task, {super.key,});

  @override
  Widget build(BuildContext context) {
    String jobAddress = "";
    

    if (task.job != null && task.job?.address != null) {
      jobAddress = Helper.convertAddress(task.job?.address);
    }
    
    return Card(
      elevation: 0,
      shadowColor: JPAppTheme.themeColors.darkGray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide.none,
      ),
      color: JPAppTheme.themeColors.base,
      margin: const EdgeInsets.only(bottom: 10, right: 16, left: 16),
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      JPLabel(
                        type: task.completed != null
                            ? JPLabelType.success
                            : JPLabelType.warning,
                        text: task.completed != null ? "completed".tr : "pending".tr,
                        textSize: JPTextSize.heading5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: JPText(
                          text: DateTimeHelper.formatDate(
                              task.createdAt?.toString() ?? "", 'am_time_ago'),
                          textColor: JPAppTheme.themeColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  if (task.reminderFrequency != null)
                    Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                            color: JPAppTheme.themeColors.inverse,
                            shape: BoxShape.circle),
                        child: JPIcon(
                          Icons.notifications_none,
                          color: JPAppTheme.themeColors.tertiary,
                          size: 16,
                        ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 3.5),
              child: Row(
                children: [
                  Flexible(
                    child: JPText(
                        text: task.title.toString(),
                        fontWeight: JPFontWeight.medium,
                        textDecoration: task.completed != null
                            ? TextDecoration.lineThrough
                            : null,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis),
                  ),
                  if (task.attachments?.isNotEmpty ?? false)
                    Container(margin: const EdgeInsets.only(left: 2), child: const JPIcon(Icons.attachment_outlined))
                ],
              ),
            ),
            if (jobAddress.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 13),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 1.5),
                      child: JPIcon(
                        Icons.location_on_outlined,
                        color: JPAppTheme.themeColors.tertiary,
                        size: 18,
                      ),
                    ),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: JPText(
                          textAlign: TextAlign.start,
                          text: jobAddress,
                          height: 1.5,
                          textColor: JPAppTheme.themeColors.tertiary,
                          textSize: JPTextSize.heading5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (task.completed != null)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    JPIcon(
                      Icons.watch_later_outlined,
                      color: JPAppTheme.themeColors.tertiary,
                      size: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: JPText(
                        text: '${'completed_on'.tr} : ${DateTimeHelper.formatDate(task.completed?.toString() ?? "", DateFormatConstants.dateOnlyFormat)}',
                        textSize: JPTextSize.heading5,
                        textColor: JPAppTheme.themeColors.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
            if (task.dueDate != null && task.completed == null)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    JPIcon(
                      Icons.watch_later_outlined,
                      color: JPAppTheme.themeColors.tertiary,
                      size: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: JPText(
                        text: '${'due_on'.tr} :  ${DateTimeHelper.convertHyphenIntoSlash(task.dueDate?.toString() ?? "")}',
                        textColor: JPAppTheme.themeColors.tertiary,
                        textSize: JPTextSize.heading5,
                      ),
                    ),
                  ],
                ),
              ),
            if (task.isHighPriorityTask)
              Padding(
                padding: const EdgeInsets.only(top: 14.0),
                child: Row(
                  children: [
                    JPIcon(
                      Icons.arrow_upward,
                      color: JPAppTheme.themeColors.red,
                      size: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: JPText(
                        text: "high_priority".tr,
                        textSize: JPTextSize.heading5,
                        textColor: JPAppTheme.themeColors.red,
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      for (var i = 0; i < (task.participants?.length ?? 0); i++)
                        if (i < 3) TaskParticipantList(task.participants![i]),
                      const SizedBox(width: 10),
                      if(task.participants?.length == 1)
                        JPText(
                          text: task.participants?[0].fullName.toString() ?? "",
                          textSize: JPTextSize.heading5,
                          textColor: JPAppTheme.themeColors.tertiary,
                        ),

                      if ((task.participants?.length ?? 0) > 3)
                        JPText(
                          text: '+ ${task.participants?.length ?? 0 - 3} ${'more'.tr}',
                          textSize: JPTextSize.heading5,
                          textColor: JPAppTheme.themeColors.secondaryText,
                        )
                    ],
                  ),
                  if ((task.locked) && (task.stage != null))
                    Row(
                      children: [
                        JPIcon(
                          Icons.lock_outline,
                          size: 14,
                          color:
                          WorkFlowStageConstants.colors[task.stage?.color],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: JPText(
                              text: task.stage?.name.toString() ?? "",
                              textSize: JPTextSize.heading5,
                              textColor: WorkFlowStageConstants
                                  .colors[task.stage?.color]),
                        )
                      ],
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
