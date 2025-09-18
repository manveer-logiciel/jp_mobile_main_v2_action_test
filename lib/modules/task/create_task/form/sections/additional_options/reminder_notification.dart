import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/tasks.dart';
import 'package:jobprogress/common/services/task/create_task_form.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/modules/task/create_task/controller.dart';
import 'package:jobprogress/modules/task/create_task/form/sections/additional_options/reminder_info.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../../common/enums/form_field_type.dart';

class ReminderNotificationForm extends StatelessWidget {

  const ReminderNotificationForm({
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
    return Column(
      children: [
        inputFieldSeparator,

        /// recurring, before due date selector
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Wrap(
                runSpacing: 8,
                children: [
                  JPRadioBox(
                    groupValue: service.groupVal,
                    onChanged: (val) => service.isFieldEditable(FormFieldType.reminderDuration)
                        ? service.toggleReminderNotificationType(val) : null,
                    radioData: [
                      JPRadioData(
                          value: ReminderNotificationType.recurring,
                          label: 'recurring'.tr,
                          disabled: !service.isFieldEditable(FormFieldType.reminderDuration)),
                    ],
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  JPRadioBox(
                    groupValue: service.groupVal,
                    onChanged: (val) => service.isFieldEditable(FormFieldType.reminderDuration)
                        ? service.toggleReminderNotificationType(val) : null,
                    radioData: [
                      JPRadioData(
                          value: ReminderNotificationType.beforeDueDate,
                          label: 'before_due_date'.tr.capitalize!.trim(),
                          disabled: !service.isFieldEditable(FormFieldType.reminderDuration)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5,),
            JPTextButton(
              color: JPAppTheme.themeColors.primary,
              isExpanded: false,
              icon: Icons.info_outline,
              iconSize: 22,
              padding: 2,
              isDisabled: controller.isSavingForm,
              onPressed: controller.toggleReminderInfo,
            )
          ],
        ),

        inputFieldSeparator,

        /// reminder info dialog
        if (controller.isReminderInfoVisible) ...{
          ReminderInfo(
            onTapClose: controller.toggleReminderInfo,
          ),
          inputFieldSeparator,
        },

        Row(
          children: [
            JPText(text: 'remind_me'.tr),
          ],
        ),

        inputFieldSeparator,

        /// reminder frequency & reminder type
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: JPInputBox(
                inputBoxController: service.reminderFrequencyController,
                type: JPInputBoxType.withoutLabel,
                fillColor: JPAppTheme.themeColors.base,
                isRequired: service.isReminderNotificationSelected,
                readOnly: !service.isFieldEditable(FormFieldType.remindMe),
                disabled: !service.isFieldEditable(FormFieldType.remindMe),
                onChanged: (val) =>controller.onDataChanged(val, doUpdate: true),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.allow(FormValidator.typeToFrequencyValidator(service.reminderTypeId), replacementString: service.reminderFrequencyController.text),
                ],
                validator: (val) => FormValidator.requiredFieldValidator(val,
                    errorMsg: 'enter_valid_value'.tr),
              ),
            ),

            const SizedBox(
              width: 12,
            ),

            Expanded(
              flex: 5,
              child: JPInputBox(
                inputBoxController: service.reminderTypeController,
                type: JPInputBoxType.withoutLabel,
                fillColor: JPAppTheme.themeColors.base,
                readOnly: true,
                disabled: !service.isFieldEditable(FormFieldType.remindMe),
                onPressed: service.selectReminderType,
                suffixChild: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: controller.formUiHelper.suffixPadding),
                  child: JPIcon(
                    Icons.expand_more,
                    color: JPAppTheme.themeColors.secondaryText,
                  ),
                ),
              ),
            ),

            const Expanded(
              flex: 2,
              child: SizedBox(),
            ),
          ],
        )
      ],
    );
  }
}
