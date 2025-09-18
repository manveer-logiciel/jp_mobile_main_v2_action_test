import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/extensions/String/index.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/common/services/task/quick_actions.dart';
import 'package:jobprogress/core/constants/assets_files.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/mix_panel/event/view_events.dart';
import 'package:jobprogress/core/constants/work_flow_stage_color.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/attachments_detail/index.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jobprogress/global_widgets/replace_job_id_with_company_setting/job_name_with_company_setting.dart';
import 'package:jobprogress/modules/task/detail/controller.dart';
import 'package:jobprogress/global_widgets/user_list_for_popover/index.dart';
import 'package:jp_mobile_flutter_ui/Label/type.dart';
import 'package:jp_mobile_flutter_ui/PopUpMenu/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class TaskDetail extends StatelessWidget {
  const TaskDetail({
    super.key,
    required this.task,
    this.callback,
    this.isUserHaveEditPermission = true,
    this.isTaskTemplate = false
  });

  final TaskListModel task;
  final Function(TaskListModel, String)? callback;
  final bool isUserHaveEditPermission;
  final bool isTaskTemplate;

  @override
  Widget build(BuildContext context) {
    final TaskDetailController controller = Get.put(TaskDetailController(
        isUserHaveEditPermission: isUserHaveEditPermission,
        isTaskTemplate: isTaskTemplate
        ));
    controller.task = task;

    controller.callback = callback;

    String jobAddress = '';
    int usersLength = 5;
    int notifiyUserLength = 5;
    if ((controller.task.participants?.length ?? 0) < 5) {
      usersLength = controller.task.participants!.length;
    }
    if ((controller.task.notifyUsers?.length ?? 0) < 5) {
      notifiyUserLength = controller.task.notifyUsers?.length ?? 0;
    }

    if (controller.task.job != null) {
      jobAddress = Helper.convertAddress(controller.task.job!.address);
    }

    Widget getHeader() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              JPText(
                text: 'task_details'.tr,
                fontWeight: JPFontWeight.medium,
                textSize: JPTextSize.heading3,
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (controller.task.sendAsMessage && !isTaskTemplate) ...{
                Material(
                  color: JPColor.transparent,
                  child: JPTextButton(
                    icon: Icons.message_outlined,
                    iconSize: 24,
                    onPressed: controller.navigateToMessages,
                  ),
                ),
              },
              const SizedBox(
                width: 8,
              ),
              if (isUserHaveEditPermission && !isTaskTemplate) ...{
                controller.task.completed != null
                    ? Material(
                        shape: const CircleBorder(),
                        clipBehavior: Clip.hardEdge,
                        color: JPAppTheme.themeColors.base,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints:
                              const BoxConstraints(minHeight: 30, minWidth: 30),
                          icon: JPIcon(
                            Icons.check_circle,
                            color: JPAppTheme.themeColors.success,
                          ),
                          onPressed: controller.markAsComplete,
                        ),
                      )
                    : Material(
                        shape: const CircleBorder(),
                        color: JPAppTheme.themeColors.base,
                        clipBehavior: Clip.hardEdge,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints:
                              const BoxConstraints(minHeight: 30, minWidth: 30),
                          icon: const JPIcon(
                            Icons.check_circle_outline_outlined,
                          ),
                          onPressed: controller.markAsComplete,
                        ),
                      ),
                Material(
                  shape: const CircleBorder(),
                  color: JPAppTheme.themeColors.base,
                  clipBehavior: Clip.hardEdge,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minHeight: 30, minWidth: 30),
                    icon: const JPIcon(
                      Icons.more_vert_outlined,
                    ),
                    onPressed: () {
                      TaskService.openQuickActions(
                          task, controller.handleQuickActionUpdate,
                          actionFrom: 'task_detail');
                    },
                  ),
                ),
              },
              Material(
                shape: const CircleBorder(),
                color: JPAppTheme.themeColors.base,
                clipBehavior: Clip.hardEdge,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minHeight: 30, minWidth: 30),
                  icon: const JPIcon(
                    Icons.close,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
            ],
          ),
        ],
      );
    }

    Widget getJobDetails() {
      return controller.task.job != null &&
              controller.task.job!.customer != null
          ? JobNameWithCompanySetting(
              job: controller.task.job!,
              textColor: JPAppTheme.themeColors.darkGray,
              textDecoration: TextDecoration.underline,
              isClickable: true,
            )
          : const SizedBox.shrink();
    }

    Widget getTitle() {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Expanded(
              child: JPText(
                textAlign: TextAlign.left,
                text: controller.task.title,
                textSize: JPTextSize.heading3,
              ),
            ),
          ],
        ),
      );
    }

    Widget getDescription() {
      return controller.task.notes != null && controller.task.notes!.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                JPReadMoreText(
                  TrimEnter(controller.task.notes!).trim(),
                  textAlign: TextAlign.left,
                  textColor: JPAppTheme.themeColors.tertiary,
                  dialogTitle: 'task_description'.tr,
                  dialogSubTitle: controller.task.title,
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            )
          : const SizedBox.shrink();
    }

    Widget getCompletedOrDueDate() {
      return controller.task.completed != null ||
              controller.task.dueDate != null
          ? Column(
              children: [
                Row(
                  children: [
                    JPIcon(
                      Icons.access_time,
                      color: JPAppTheme.themeColors.darkGray,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    if (controller.task.completed != null)
                      JPText(
                        text: '${'completed_on'.tr} ${DateTimeHelper.formatDate(controller.task.completed.toString(), DateFormatConstants.dateOnlyFormat)}',
                      ),
                    if (controller.task.dueDate != null &&
                        controller.task.completed == null)
                      JPText(
                          text: '${'due_on'.tr} ${DateTimeHelper.convertHyphenIntoSlash(controller.task.dueDate.toString())}'),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            )
          : const SizedBox.shrink();
    }

    Widget getJobAddress() {
      return jobAddress.isNotEmpty
          ? Column(
              children: [
                Row(
                  children: [
                    JPIcon(Icons.location_on_outlined,
                        color: JPAppTheme.themeColors.darkGray),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: JPText(
                        textAlign: TextAlign.left,
                        text: jobAddress,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            )
          : const SizedBox.shrink();
    }

    Widget getLabels() {
      return Padding(
        padding:!controller.isTaskTemplate ? const EdgeInsets.only(bottom: 20) : const EdgeInsets.only(bottom: 0),
        child: Row(
          children: [
            if (controller.task.isHighPriorityTask && !controller.isTaskTemplate)
            Row(
              children: [
                JPLabel(
                  text: 'high_priority'.tr,
                  backgroundColor: JPAppTheme.themeColors.red,
                ),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
            Visibility(
              visible: !controller.isTaskTemplate,
              child: JPLabel(
                type: controller.task.completed != null
                    ? JPLabelType.success
                    : JPLabelType.warning,
                text: controller.task.completed != null
                    ? 'completed'.tr
                    : "pending".tr,
                textSize: JPTextSize.heading5,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
      );
    }

    Widget getParticipants() {
      return Visibility(
        visible: !Helper.isValueNullOrEmpty(controller.task.participants) || 
          (!Helper.isValueNullOrEmpty(controller.task.assignToSetting) && controller.isTaskTemplate),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              JPIcon(Icons.group_outlined, color: JPAppTheme.themeColors.darkGray),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Wrap(
                  runSpacing: 5.0,
                  direction: Axis.horizontal,
                  children: [
                    if(!Helper.isValueNullOrEmpty(task.assignToSetting) && isTaskTemplate)
                    for (int i = 0; i < task.assignToSetting!.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: JPChip(
                        text: Helper.getUserType(task.assignToSetting![i]).capitalize! ,
                        textSize: JPTextSize.heading5,
                        child: JPProfileImage(
                          initial: Helper.getUserType(task.assignToSetting![i]).substring(0, 1).toUpperCase(),
                        )
                      ),
                    ),
                    for (int i = 0; i < usersLength; i++)
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: JPChip(
                            text: controller.task.participants![i].fullName,
                            child: JPProfileImage(
                              src: controller.task.participants![i].profilePic,
                              color: controller.task.participants![i].color,
                              initial: controller.task.participants![i].intial,
                            )),
                      ),
                    if (controller.task.participants!.length > 5)
                      Padding(
                          padding:
                              const EdgeInsets.only(left: 8.0, right: 8.0, top: 5),
                          child: Material(
                            child: JPPopUpMenuButton(
                              popUpMenuButtonChild: JPText(
                                text:
                                    '+${controller.task.participants!.length - 5}' +
                                        ' ' 'more'.tr,
                                textSize: JPTextSize.heading4,
                                fontWeight: JPFontWeight.medium,
                                textColor: JPAppTheme.themeColors.primary,
                              ),
                              childPadding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 9, bottom: 9),
                              itemList: controller.task.participants!.sublist(5),
                              popUpMenuChild: (UserLimitedModel val) {
                                return UserListItemForPopMenuItem(user: val);
                              },
                            ),
                          )),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

    Widget getNotifyUsers() {
      return !Helper.isValueNullOrEmpty(task.notifyUsers) || (!Helper.isValueNullOrEmpty(task.notifyUserSetting) && isTaskTemplate)
          ? Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    JPIcon(Icons.add_alert_outlined,
                        color: JPAppTheme.themeColors.darkGray),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Wrap(
                        runSpacing: 5.0,
                        direction: Axis.horizontal,
                        children: [
                          if(!Helper.isValueNullOrEmpty(task.notifyUserSetting) && isTaskTemplate)
                          for (int i = 0; i < task.notifyUserSetting!.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: JPChip(
                              text: Helper.getUserType(task.notifyUserSetting![i]).capitalize!,
                              textSize: JPTextSize.heading5,
                              child: JPProfileImage(
                                initial: Helper.getUserType(task.notifyUserSetting![i]).substring(0, 1).toUpperCase(),
                              )
                            ),
                          ),
                          for (int i = 0; i < notifiyUserLength; i++)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: JPChip(
                                  text: task.notifyUsers![i].fullName,
                                  textSize: JPTextSize.heading5,
                                  child: JPProfileImage(
                                    src: task.notifyUsers![i].profilePic,
                                    color: task.notifyUsers![i].color,
                                    initial: task.notifyUsers![i].intial,
                                  )),
                            ),
                          if (controller.task.notifyUsers!.length > 5)
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0, top: 5),
                                child: Material(
                                  child: JPPopUpMenuButton(
                                    popUpMenuButtonChild: JPText(
                                      text:
                                          '+${controller.task.notifyUsers!.length - 5}' +
                                              ' ' 'more'.tr,
                                      textSize: JPTextSize.heading4,
                                      fontWeight: JPFontWeight.medium,
                                      textColor: JPAppTheme.themeColors.primary,
                                    ),
                                    childPadding: const EdgeInsets.only(
                                        left: 16, right: 16, top: 9, bottom: 9),
                                    itemList:
                                        controller.task.notifyUsers!.sublist(5),
                                    popUpMenuChild: (UserLimitedModel val) {
                                      return UserListItemForPopMenuItem(
                                          user: val);
                                    },
                                  ),
                                )),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            )
          : const SizedBox.shrink();
    }

    Widget getLockedStage() {
      return controller.task.locked
          ? Column(
              children: [
                Row(
                  children: [
                    JPIcon(Icons.lock_outlined,
                        color: JPAppTheme.themeColors.darkGray),
                    const SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: Text.rich(
                      TextSpan(
                        children: [
                          JPTextSpan.getSpan(
                           'locked'.tr,
                          ),
                          const WidgetSpan(
                            child: SizedBox(width: 2),
                          ),
                          JPTextSpan.getSpan(
                            (controller.task.stage?.name.toString() ?? ""),
                            textColor:  WorkFlowStageConstants.colors[controller.task.stage?.color],
                          ),
                          const WidgetSpan(
                            child: SizedBox(width: 2),
                          ),
                          JPTextSpan.getSpan(
                            'stage'.tr + ' ',
                          ),
                        ],
                      ),
                      
                    ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            )
          : const SizedBox.shrink();
    }

    Widget getDueDateReminder() {
      return controller.task.reminderFrequency != null
          ? Column(
              children: [
                Row(
                  children: [
                    JPIcon(
                      Icons.notifications_outlined,
                      color: JPAppTheme.themeColors.darkGray,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    JPText(
                        text: Helper.getReminderValue(
                            controller.task.isDueDateReminder,
                            controller.task.reminderFrequency,
                            controller.task.reminderType)),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            )
          : const SizedBox.shrink();
    }

    Widget getCreatedBy() {
      if (controller.task.createdBy == null) return const SizedBox.shrink();
      return Column(
        children: [
          Row(
            children: [
              JPIcon(
                Icons.person_outlined,
                color: JPAppTheme.themeColors.darkGray,
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: JPText(
                    textAlign: TextAlign.left,
                    maxLine: 2,
                    text:
                        'By ${controller.task.createdBy!.fullName} at ${DateTimeHelper.formatDate(controller.task.createdAt.toString(), DateFormatConstants.dateTimeFormatWithoutSeconds)}'),
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
        ],
      );
    }

    Widget getCompletedBy() {
      if (controller.task.completedBy == null) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
            Row(
              children: [
                JPIcon(
                  Icons.check_circle_outline_outlined,
                  color: JPAppTheme.themeColors.darkGray,
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: JPText(
                      textAlign: TextAlign.left,
                      maxLine: 2,
                      text:'${'completed_by'.tr} ${controller.task.completedBy!.fullName}',
                  )
                ),
              ],
            ),
            
          ],
        ),
      );
    }

    Widget getSendAsCopy() {
      if((controller.task.sendAsEmail || controller.task.sendAsMessage) && isTaskTemplate) {
        return Column(
          children: [
            Row (
              children: [
                SvgPicture.asset(
                  AssetsFiles.sendAsCopy,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    JPAppTheme.themeColors.darkGray,
                    BlendMode.srcIn)
                ),
                const SizedBox(
                  width: 15,
                ),
                if(controller.task.sendAsEmail)
                JPText(
                  textAlign: TextAlign.left,
                  maxLine: 2,
                  text: 'email'.tr  
                ),
                if(controller.task.sendAsMessage)
                Expanded(
                  child: JPText(
                    textAlign: TextAlign.left,
                    text: ' , ' + 'message'.tr.capitalizeFirst!,
                  )
                )
              ],
            ),
            const SizedBox(
              height: 34,
            ),
          ],
        );
      }
      return const SizedBox.shrink();
    }

    return Wrap(
      children: [
        GetBuilder<TaskDetailController>(initState: (_) {
          MixPanelService.trackEvent(event: MixPanelViewEvent.taskDetailView);
        }, builder: (_) {
          return Container(
            width: double.maxFinite,
            padding: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: JPAppTheme.themeColors.base,
              borderRadius: JPResponsiveDesign.bottomSheetRadius,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getHeader(),
                      const SizedBox(
                        height: 5,
                      ),
                      getJobDetails(),
                    ],
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.85,
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 12,
                            ),
                            getLabels(),
                            getTitle(),
                            getDescription(),
                            getCompletedOrDueDate(),
                            getJobAddress(),
                            getParticipants(),
                            getNotifyUsers(),
                            getLockedStage(),
                            getDueDateReminder(),
                            getCreatedBy(),
                            getCompletedBy(),
                            getSendAsCopy(),
                          ],
                        ),
                      ),
                      if (controller.task.attachments != null &&
                          controller.task.attachments!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 23),
                          child: JPAttachmentDetail(
                              attachments: controller.task.attachments!),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
