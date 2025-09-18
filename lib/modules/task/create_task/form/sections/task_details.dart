import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/task/create_task_form.dart';
import 'package:jobprogress/global_widgets/chips_input_box/index.dart';
import 'package:jobprogress/modules/task/create_task/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../common/enums/form_field_type.dart';
import '../../../../../common/enums/form_field_visibility.dart';
import '../../../../../core/constants/widget_keys.dart';

class TaskDetailsSection extends StatelessWidget {

  const TaskDetailsSection({
    super.key,
    required this.controller,
  });

  final CreateTaskFormController controller;

  Widget get inputFieldSeparator => SizedBox(
        height: controller.formUiHelper.inputVerticalSeparator,
      );

  CreateTaskFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JPAppTheme.themeColors.base,
      borderRadius:
          BorderRadius.circular(controller.formUiHelper.sectionBorderRadius),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: controller.formUiHelper.horizontalPadding,
          vertical: controller.formUiHelper.verticalPadding,
        ),
        child: Column(
          children: [
            /// task title
            JPInputBox(
              key: const ValueKey(WidgetKeys.taskFormTitle),
              inputBoxController: service.titleController,
              label: 'title'.tr,
              isRequired: true,
              disabled: !service.isFieldEditable(FormFieldType.title),
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              readOnly: !service.isFieldEditable(FormFieldType.title),
              onChanged: controller.onDataChanged,
              validator: (val) => service.validateTitle(val),
            ),

            inputFieldSeparator,

            /// task assign to
            JPChipsInputBox<CreateTaskFormController>(
              key: const ValueKey(WidgetKeys.taskFormAssignTo),
              inputBoxController: service.usersController,
              label: 'assign_to'.tr.capitalize,
              isRequired: true,
              controller: controller,
              selectedItems: service.selectedUser,
              onTap:service.selectAssignTo,
              disabled: !service.isFieldEditable(FormFieldType.assignedTo),
              validator: (val) => service.validateAssignTo(val),
              disableEditing: !service.isFieldEditable(FormFieldType.assignedTo),
              onDataChanged: controller.onDataChanged,
              suffixChild: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: controller.formUiHelper.horizontalPadding),
                child: JPIcon(
                  Icons.person_add_alt,
                  color: JPAppTheme.themeColors.primary,
                ),
              ),
            ),

            /// task job (only in case of add task)
            Visibility(
              visible: service.isFieldEditable(FormFieldVisibility.linkJob),
              child: inputFieldSeparator),

            Visibility(
              visible: service.isFieldEditable(FormFieldVisibility.linkJob),
              child: JPInputBox(
                  key: const ValueKey(WidgetKeys.taskFormJob),
                  inputBoxController: service.jobController,
                  label: 'link_job/project'.tr,
                  type: JPInputBoxType.withLabel,
                  disabled: !service.isFieldEditable(FormFieldType.linkJob),
                  fillColor: JPAppTheme.themeColors.base,
                  readOnly: true,
                  onPressed: service.selectJob,
                  suffixChild: !service.isFieldEditable(FormFieldType.linkJob) ? null
                    : service.jobModel != null
                      ? Padding(
                          padding: EdgeInsets.only(
                              right: controller.formUiHelper.suffixPadding),
                          child: JPTextButton(
                            isExpanded: false,
                            icon: Icons.close,
                            color: JPAppTheme.themeColors.secondary,
                            iconSize: 22,
                            padding: 0,
                            onPressed: service.removeJob,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                          horizontal: controller.formUiHelper.suffixPadding),
                          child: JPText(
                            text: 'select'.tr.toUpperCase(),
                            textSize: JPTextSize.heading5,
                            textColor: JPAppTheme.themeColors.primary,
                          ),
                        ),
                ),
            ),

            inputFieldSeparator,

            /// task due on
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: JPInputBox(
                    key: const ValueKey(WidgetKeys.taskFormDueOn),
                    inputBoxController: service.dueOnController,
                    label: 'due_on'.tr,
                    type: JPInputBoxType.withLabel,
                    fillColor: JPAppTheme.themeColors.base,
                    readOnly: true,
                    onPressed: service.selectDueOnDate,
                    onChanged: controller.onDataChanged,
                    disabled: !service.isFieldEditable(FormFieldType.dueOn),
                    validator: (val) => service.validateDueOn(val),
                    suffixChild: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: controller.formUiHelper.suffixPadding,
                      ),
                      child: JPIcon(
                        Icons.date_range,
                        color: JPAppTheme.themeColors.dimGray,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        JPCheckbox(
                          selected: service.isHighPriorityTask,
                          separatorWidth: 2,
                          padding: const EdgeInsets.all(4),
                          disabled: !service.isFieldEditable(FormFieldType.highPriority),
                          borderColor: JPAppTheme.themeColors.themeGreen,
                          onTap: service.toggleIsHighPriorityTask,
                          text: 'high_priority'.tr,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            inputFieldSeparator,

            /// task notes
            JPInputBox(
              key: const ValueKey(WidgetKeys.taskFormNotes),
              inputBoxController: service.notesController,
              label: 'note'.tr.capitalize,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              readOnly: !service.isFieldEditable(FormFieldType.note),
              disabled: !service.isFieldEditable(FormFieldType.note),
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }
}
