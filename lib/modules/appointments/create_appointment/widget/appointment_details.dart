import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/appointment/create_appointment_form.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/global_widgets/chips_input_box/index.dart';
import 'package:jobprogress/modules/appointments/create_appointment/controller.dart';
import 'package:jobprogress/modules/appointments/create_appointment/widget/day_remainder.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../core/constants/widget_keys.dart';


class AppointmentDetailsSection extends StatelessWidget {
  const AppointmentDetailsSection({
    super.key,
    required this.controller,
  });

  final CreateAppointmentFormController controller;

  Widget get inputFieldSeparator => SizedBox(
        height: controller.formUiHelper.inputVerticalSeparator,
      );

  CreateAppointmentFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JPAppTheme.themeColors.base,
      borderRadius: BorderRadius.circular(controller.formUiHelper.sectionBorderRadius),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: controller.formUiHelper.horizontalPadding,
          vertical: controller.formUiHelper.verticalPadding,
        ),
        child: Column(
          children: [
            // customer textEditor
            JPInputBox(
              key: const ValueKey(WidgetKeys.appointmentFormCustomer),
              inputBoxController: service.customerController,
              label: 'customer'.tr,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              disabled: !service.isFieldEditable(),
              readOnly: true,
              onPressed: service.selectCustomer,
              suffixChild:  service.customerModel != null || service.customerController.text != ''
                      ? Padding(
                          padding: EdgeInsets.only(
                            right: controller.formUiHelper.suffixPadding),
                          child: JPTextButton(
                            isExpanded: false,
                            icon: Icons.close,
                            color: JPAppTheme.themeColors.secondary,
                            iconSize: 22,
                            padding: 0,
                            onPressed: service.removeCustomer,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: controller.formUiHelper.suffixPadding),
                          child: JPText(
                            text: 'select'.tr.toUpperCase(),
                            fontWeight: JPFontWeight.medium,
                            textSize: JPTextSize.heading5,
                            textColor: JPAppTheme.themeColors.primary,
                          ),
                        ),
            ),

            inputFieldSeparator,

            // job textEditor
            Visibility(
              visible: service.customerController.text.isNotEmpty,
              child: JPChipsInputBox<CreateAppointmentFormController>(
                inputBoxController: service.jobController,
                label: 'job'.tr.capitalize,
                disabled: !service.isFieldEditable(),
                controller: controller,
                selectedItems: service.selectedJobs,
                onRemove: (user) => service.onRemoveJob(user),
                onTap: service.selectJobOfCustomer,
                suffixChild: Padding(
                  padding: EdgeInsets.symmetric(horizontal: controller.formUiHelper.horizontalPadding),
                  child: JPText(
                          text: 'select'.tr.toUpperCase(),
                          fontWeight: JPFontWeight.medium,
                          textSize: JPTextSize.heading5,
                          textColor: JPAppTheme.themeColors.primary,
                        ),
                ),
              ),
            ),

            Visibility(
              visible: service.customerController.text != '',
              child: inputFieldSeparator),

            // title textEditor
            JPInputBox(
              key: const ValueKey(WidgetKeys.appointmentFormTitle),
              inputBoxController: service.titleController,
              label: 'title'.tr,
              isRequired: true,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              disabled: !service.isFieldEditable(),
              onChanged: (val) => controller.onDataChanged(val),
              validator: (val) => service.validateTitle(val),
            ),

            inputFieldSeparator,

            // appointmentfor textEditor
            JPInputBox(
                key: const ValueKey(WidgetKeys.appointmentFormFor),
                inputBoxController: service.appointmentForController,
                type: JPInputBoxType.withLabel,
                label: 'appointment_for'.tr.capitalize,
                fillColor: JPAppTheme.themeColors.base,
                disabled: !service.isFieldEditable(),
                isRequired: true,
                readOnly: true,
                onPressed: service.selectAppointmentFor,
                validator: (val) => service.validateAppointmentFor(val),
                onChanged: controller.onDataChanged,
                suffixChild: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: controller.formUiHelper.horizontalPadding),
                  child: JPIcon(
                    Icons.keyboard_arrow_down_outlined,
                    color: JPAppTheme.themeColors.secondaryText,
                  ),
                ),
              ),

            // day reminder
            AppointmentFormDayReminderSection(
              controller: controller,
              errorText: service.errorText,
            ),

            inputFieldSeparator,

            // recurring widget
            JPInputBox(
                    inputBoxController: service.recurringController,
                    type: JPInputBoxType.withLabel,
                    label: 'recurring'.tr.capitalize,
                    fillColor: JPAppTheme.themeColors.base,
                    disabled: !service.isFieldEditable(),
                    readOnly: true,
                    onPressed: service.openRecurringDataBottomSheet,
                    suffixChild: Padding(
                      padding: EdgeInsets.symmetric(horizontal: controller.formUiHelper.suffixPadding),
                      child: JPIcon(
                                Icons.expand_more,
                                color: JPAppTheme.themeColors.secondaryText,
                            ),
                        ),
              ),

            inputFieldSeparator,

            // appointment attendees
            if(FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.userManagement]))...{
              JPChipsInputBox<CreateAppointmentFormController>(
                key: const ValueKey(WidgetKeys.appointmentFormAttendees),
                inputBoxController: service.attendeesController,
                label: 'additional_attendees'.tr.capitalize,
                controller: controller,
                selectedItems: service.selectedAttendees,
                disabled: !service.isFieldEditable(),
                onTap: service.selectAttendees,
                suffixChild: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: controller.formUiHelper.horizontalPadding),
                  child: JPIcon(
                    Icons.person_add_alt,
                    color: JPAppTheme.themeColors.primary,
                  ),
                ),
              ),
              inputFieldSeparator,
            },
            // appointment notes
            JPInputBox(
              inputBoxController: service.notesController,
              label: 'notes'.tr.capitalize,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              disabled: !service.isFieldEditable(),
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }
}