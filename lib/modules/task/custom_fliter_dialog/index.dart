import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/task_listing/task_listing_filter.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';

  class TaskListingDialouge extends StatelessWidget {
    const TaskListingDialouge({
      super.key,
      required this.selectedFilters,
      this.jobId,
      required this.onApply,
      this.userList
    });

    final TaskListingFilterModel selectedFilters;

    final int? jobId;

    final void Function(TaskListingFilterModel params) onApply;

    final List<UserModel>? userList;

    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: JPSafeArea(
          child: GetBuilder<TaskListingDialogController>(
              init: TaskListingDialogController(selectedFilters, jobId, onApply, userList),
              global: false,
              builder: (controller) => AlertDialog(
                    scrollable: true,
                    insetPadding: const EdgeInsets.only(left: 10, right: 10),
                    contentPadding: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    content: Builder(
                      builder: (context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(right: 16, top: 19, bottom: 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20, left: 16),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  JPText(
                                    text: "custom_filters".tr,
                                    textSize: JPTextSize.heading3,
                                    fontWeight: JPFontWeight.medium,
                                  ),
                                  JPTextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    color: JPAppTheme.themeColors.text,
                                    icon: Icons.clear,
                                    iconSize: 24,
                                  )
                                ]),
                              ),
                              if(jobId != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 16, bottom: 15),
                                child: JPInputBox(
                                    key: const Key(WidgetKeys.asigneeKey),
                                    label: "assignee".tr.capitalize!,
                                    type: JPInputBoxType.withLabel,
                                    fillColor: JPAppTheme.themeColors.base,
                                    readOnly: true,
                                    controller: TextEditingController(text: controller.selectedUser != null? controller.selectedUser!.fullName : 'None'),
                                    onPressed: () {
                                      controller.openAssigneeUsersFilter();
                                    },
                                    suffixChild: const Padding(
                                      padding: EdgeInsets.only(right: 9), child: JPIcon(Icons.keyboard_arrow_down)
                                    )
                                  ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: JPInputBox(
                                    key: const Key(WidgetKeys.statusKey),
                                    label: "status".tr,
                                    type: JPInputBoxType.withLabel,
                                    fillColor: JPAppTheme.themeColors.base,
                                    readOnly: true,
                                    controller: TextEditingController(text: SingleSelectHelper.getSelectedSingleSelectValue(controller.statusFilters, controller.filterKeys.status)),
                                    onPressed: () {
                                      controller.openStatusFilter();
                                    },
                                    suffixChild: const Padding(
                                      padding: EdgeInsets.only(right: 9), child: JPIcon(Icons.keyboard_arrow_down)
                                    )
                                  ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 16),
                                child: JPInputBox(
                                    key: const Key(WidgetKeys.dueOnKey),
                                    label: "due_on".tr,
                                    type: JPInputBoxType.withLabel,
                                    fillColor: JPAppTheme.themeColors.base,
                                    readOnly: true,
                                    controller: TextEditingController(text: SingleSelectHelper.getSelectedSingleSelectValue(controller.dueOnFilters, controller.filterKeys.duration)),
                                    onPressed: () {
                                      controller.openDueOnFilter();
                                    },
                                    suffixChild: const Padding(
                                      padding: EdgeInsets.only(right: 9), child: JPIcon(Icons.keyboard_arrow_down)
                                    )
                                  ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2),
                                child: JPCheckbox(
                                  onTap: (value) {
                                    controller.filterKeys.includeLockedTask = !controller.filterKeys.includeLockedTask;
                                    controller.update();
                                  },
                                  text: "locked_with_stage".tr,
                                  borderColor: JPAppTheme.themeColors.themeGreen,
                                  selected: controller.filterKeys.includeLockedTask,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2),
                                child: JPCheckbox(
                                  onTap: (value) {
                                    controller.filterKeys.reminderNotification = !controller.filterKeys.reminderNotification;
                                    controller.update();
                                  },
                                  text: "with_reminder_notification".tr,
                                  borderColor: JPAppTheme.themeColors.themeGreen,
                                  selected: controller.filterKeys.reminderNotification,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2),
                                child: JPCheckbox(
                                  onTap: (value) {
                                    controller.filterKeys.onlyHighPriorityTask = !controller.filterKeys.onlyHighPriorityTask;
                                    controller.update();
                                  },
                                  text: "high_priority".tr,
                                  borderColor: JPAppTheme.themeColors.themeGreen,
                                  selected: controller.filterKeys.onlyHighPriorityTask,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20, left: 16),
                                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Expanded(
                                    flex: JPResponsiveDesign.popOverButtonFlex,
                                    child: JPButton(
                                      key: const Key(WidgetKeys.resetKey),
                                      text: 'reset'.tr,
                                      onPressed: () {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                        controller.setDefaultKeys(selectedFilters);
                                      },
                                      disabled: controller.isResetButtonDisable(),
                                      fontWeight: JPFontWeight.medium,
                                      size: JPButtonSize.small,
                                      colorType: JPButtonColorType.lightGray,
                                      textColor: JPAppTheme.themeColors.tertiary,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    flex: JPResponsiveDesign.popOverButtonFlex,
                                    child: JPButton(
                                      key: const Key(WidgetKeys.applyKey),
                                      onPressed: () {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                        onApply(controller.filterKeys);
                                        Get.back();
                                      },
                                      text: 'apply'.tr,
                                      fontWeight: JPFontWeight.medium,
                                      size: JPButtonSize.small,
                                      colorType: JPButtonColorType.tertiary,
                                      textColor: JPAppTheme.themeColors.base,
                                    ),
                                  )
                                ]),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  )),
        ),
      );
    }
  }
