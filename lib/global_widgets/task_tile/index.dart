import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/extensions/String/index.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/core/constants/phases_visibility.dart';
import 'package:jobprogress/core/constants/work_flow_stage_color.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/modules/task/list_tile/participant_list.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class DailyPlanTasksListTile extends StatelessWidget {
  const DailyPlanTasksListTile({
    required this.taskItem,
    this.showCheckBox = false,
    this.showTaskAlertIcon = true,
    this.isATemplate = false,
    this.onTapTask,
    this.checkValue = false,
    this.showBorder = true,
    this.padding,
    this.titleMaxLineLimit,
    this.disabled = false,
    this.onTapCheckBox,
    super.key, });

  final TaskListModel taskItem;

  final bool showCheckBox;

  final bool showTaskAlertIcon;

  final bool checkValue;

  final bool isATemplate;

  final bool showBorder;

  final VoidCallback? onTapTask;

  final Function(bool val)? onTapCheckBox;

  final EdgeInsets? padding;

  final int? titleMaxLineLimit;

  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: PhasesVisibility.canShowSecondPhase ? onTapTask : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showCheckBox) Padding(
            padding: padding ?? const EdgeInsets.only(top: 12, left: 16),
            child: SizedBox(
              height: 30,
              width: 30,
              child: Center(
                child: JPCheckbox(
                  disabled: disabled,
                  borderColor: JPAppTheme.themeColors.themeGreen,
                  selected: checkValue,
                  padding: EdgeInsets.zero,
                  height: 17,
                  width: 17,
                  onTap: onTapCheckBox,
                ),
              ),
            ),
          ) else if(showTaskAlertIcon) Padding(
            padding: const EdgeInsets.only(top: 15, left: 16),
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: JPAppTheme.themeColors.lightBlue.withValues(alpha: 0.8),
              ),
              child: Center(
                child: JPIcon(
                  Icons.task_alt_outlined,
                  size: 16,
                  color: JPAppTheme.themeColors.primary,
                ),
              ),
            ),
          ) else const SizedBox.shrink(),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: (showTaskAlertIcon ? 15 : 12), right: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: JPText(
                                          textAlign: TextAlign.start,
                                          text: taskItem.title,
                                          fontWeight: JPFontWeight.medium,
                                          maxLine: titleMaxLineLimit ?? 1,
                                          overflow: TextOverflow.ellipsis,
                                          textDecoration: taskItem.completed != null ? TextDecoration.lineThrough : null,
                                        ),
                                      ),
                                      if(taskItem.attachments != null && taskItem.attachments!.isNotEmpty)
                                      Container(
                                          height: 15,
                                          width: 24,
                                          margin:
                                              const EdgeInsets.only(left: 6.5),
                                          child: const FittedBox(
                                            fit: BoxFit.cover,
                                            child: JPIcon(
                                              Icons.attachment_outlined,
                                              textDirection: TextDirection.ltr,
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          (taskItem.reminderFrequency != null && showTaskAlertIcon)
                              ? Container(
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: JPAppTheme.themeColors.dimGray),
                                child: JPIcon(
                                  Icons.notifications_outlined,
                                  color: JPAppTheme.themeColors.tertiary,
                                  size: 15,
                                ),
                              )
                              : const SizedBox.shrink(),
                        ],
                      ),
                      taskItem.notes?.isEmpty ?? true
                          ? const SizedBox.shrink()
                          : Column(
                              children: [
                                const SizedBox(height: 5),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: JPText(
                                    text: TrimEnter(taskItem.notes!).trim(),
                                    overflow: TextOverflow.ellipsis,
                                    textSize: JPTextSize.heading5,
                                    textAlign: TextAlign.start,
                                    maxLine: 3,
                                    textColor: JPAppTheme.themeColors.tertiary,
                                  ),
                                ),
                              ],
                            ),
                      taskItem.job != null
                          ? Column(
                              children: [
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    JPText(
                                      text: '${'location'.tr}: ',
                                      textSize: JPTextSize.heading5,
                                      textColor: JPAppTheme.themeColors.darkGray,
                                    ),
                                    Flexible(
                                      child: JPText(
                                        text: Helper.convertAddress(
                                            taskItem.job!.address),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        textSize: JPTextSize.heading5,
                                        textColor:
                                            JPAppTheme.themeColors.tertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          if(taskItem.dueDate?.isNotEmpty ?? false)...{
                            JPText(
                              text: '${'due_on'.tr}:',
                              overflow: TextOverflow.ellipsis,
                              textSize: JPTextSize.heading5,
                              textColor: JPAppTheme.themeColors.darkGray,
                            ),
                            JPText(
                              text: DateTimeHelper.convertHyphenIntoSlash(
                                  taskItem.dueDate.toString()),
                              overflow: TextOverflow.ellipsis,
                              textSize: JPTextSize.heading5,
                              textColor: JPAppTheme.themeColors.tertiary,
                            ),
                            const SizedBox(width: 5),
                          },
                          if(taskItem.dueDate == null && isATemplate)...{
                            JPText(
                              text: '${'due_on'.tr}: ',
                              overflow: TextOverflow.ellipsis,
                              textSize: JPTextSize.heading5,
                              textColor: JPAppTheme.themeColors.darkGray,
                            ),
                            JPText(
                              text: '${'select'.tr} ${'due'.tr.capitalize!} ${'date'.tr.capitalize!}',
                              textSize: JPTextSize.heading5,
                              textColor: JPAppTheme.themeColors.primary,
                            ),
                            const SizedBox(width: 5),
                          },
                          if(taskItem.locked && taskItem.stage != null)
                          Expanded(
                            child: Row(
                              children: [
                                JPText(
                                  text: '|',
                                  overflow: TextOverflow.ellipsis,
                                  textSize: JPTextSize.heading5,
                                  textColor: JPAppTheme.themeColors.tertiary,
                                ),
                                const SizedBox(width: 3),
                                JPIcon(
                                  Icons.lock_outline,
                                  color: WorkFlowStageConstants.colors[taskItem.stage!.color],
                                  size: 14,
                                ),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: JPText(
                                    text: taskItem.stage!.name,
                                    overflow: TextOverflow.ellipsis,
                                    textSize: JPTextSize.heading5,
                                    textColor: WorkFlowStageConstants.colors[taskItem.stage!.color],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if(taskItem.participants!.isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [ 
                                Row(
                                  children: [
                                    for (var i = 0;
                                        i < taskItem.participants!.length;
                                        i++)
                                      if (i < 3)
                                        TaskParticipantList(
                                            taskItem.participants![i]),
                                    const SizedBox(width: 10),
                                    if (taskItem.participants!.length == 1)
                                      JPText(
                                        text: taskItem.participants![0].fullName
                                            .toString(),
                                        textSize: JPTextSize.heading5,
                                        textColor:
                                            JPAppTheme.themeColors.tertiary,
                                      ),
                                    if (taskItem.participants!.length > 3)
                                      JPText(
                                        text: '+ ${taskItem.participants!.length - 3} ${'more'.tr}',
                                        textSize: JPTextSize.heading5,
                                        textColor:
                                            JPAppTheme.themeColors.secondaryText,
                                      )
                                  ],
                                ),
                              ],
                            ),
                            if(taskItem.participants!.isEmpty && isATemplate)
                            JPText(
                              text: 'select_assignee'.tr,
                              textSize: JPTextSize.heading5,
                              textColor: JPAppTheme.themeColors.primary,
                            ),
                            taskItem.isHighPriorityTask? Row(
                              children: [
                                JPIcon(
                                  Icons.arrow_upward,
                                  size: 18,
                                  color: JPAppTheme.themeColors.secondary,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                JPText(
                                  text: 'high_priority'.tr,
                                  textSize: JPTextSize.heading5,
                                  textColor: JPAppTheme.themeColors.secondary,
                                ),
                              ],
                            ): const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if(taskItem.isChecked)...{
                  if(isATemplate && taskItem.isAssigneEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        JPText(
                        textColor: JPAppTheme.themeColors.red,
                        textAlign: TextAlign.left,
                        textSize: JPTextSize.heading5,
                        text: 'please_assign_at_least_one_user'.tr),
                      ],
                    ),
                  ),
                  if(isATemplate && taskItem.isDueOnEmpty && taskItem.isDueDateReminder)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        JPText(
                        textColor: JPAppTheme.themeColors.red,
                        textAlign: TextAlign.left,
                        textSize: JPTextSize.heading5,
                        text: 'please_add_due_date_before_setting_up_reminder'.tr),
                      ],
                    ),
                  )
                },   
                if(showBorder == true)
                Divider(
                  height: 0,
                  thickness: 1,
                  color: JPAppTheme.themeColors.dimGray,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
