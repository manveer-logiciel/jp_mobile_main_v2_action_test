import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/modules/calendar/event/form/sections/recurring.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../../common/enums/form_field_type.dart';
import '../../../../../common/services/calendars/event_form.dart';
import '../../../../../global_widgets/chips_input_box/index.dart';
import '../../controller.dart';
import 'day_reminder.dart';
import '../../../../../core/constants/widget_keys.dart';

class EventDetailsSection extends StatelessWidget {
  const EventDetailsSection({
    super.key,
    required this.controller,
  });

  final EventFormController controller;

  Widget get inputFieldSeparator => SizedBox(
    height: controller.formUiHelper.inputVerticalSeparator,
  );

  EventFormService get service => controller.service;

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
            /// event title
            JPInputBox(
              key: const ValueKey(WidgetKeys.eventFormTitle),
              inputBoxController: service.titleController,
              label: 'title'.tr,
              isRequired: true,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              disabled: !service.isFieldEditable(FormFieldType.title),
              readOnly: !service.isFieldEditable(FormFieldType.title),
              onChanged: (val) => controller.onDataChanged(val, formFieldType: FormFieldType.title),
              validator: (val) => service.validateTitle(val),
            ),

            /// company_crew
            Visibility(
              visible: !service.isScheduleForm,
              child: Padding(
                padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
                child: JPChipsInputBox<EventFormController>(
                  key: const ValueKey(WidgetKeys.eventFormCompanyCrew),
                  inputBoxController: service.companyCrewController,
                  label: 'company_crew'.tr.capitalize,
                  isRequired: false,
                  controller: controller,
                  selectedItems: service.selectedCompanyCrew,
                  onTap: service.selectCompanyCrew,
                  disabled: !service.isFieldEditable(FormFieldType.companyCrew),
                  disableEditing: !service.isFieldEditable(FormFieldType.companyCrew),
                  onDataChanged: controller.onDataChanged,
                  suffixChild: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: controller.formUiHelper.horizontalPadding),
                    child: JPIcon(
                      Icons.person_add_alt,
                      color: JPAppTheme.themeColors.primary,
                    ),
                  )
                ),
              ),
            ),

            /// Labor / Sub Contractors
            Visibility(
              visible: !service.isScheduleForm,
              child: Padding(
                padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
                child: JPChipsInputBox<EventFormController>(
                    key: const ValueKey(WidgetKeys.eventFormLabourContractors),
                    inputBoxController: service.labourContractorsController,
                    label: 'labor_sub_contractors'.tr,
                    isRequired: false,
                    controller: controller,
                    selectedItems: service.selectedLaborContractors,
                    onTap: service.selectLabourContractors,
                    disabled: !service.isFieldEditable(FormFieldType.subContractor),
                    disableEditing: !service.isFieldEditable(FormFieldType.subContractor),
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
              ),
            ),

            /// trades
            Visibility(
              visible: service.isScheduleForm,
              child: Padding(
                padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
                child: JPInputBox(
                  key: const ValueKey(WidgetKeys.eventFormTrades),
                  inputBoxController: service.tradesController,
                  label: 'trades'.tr,
                  type: JPInputBoxType.withLabel,
                  disabled: !service.isFieldEditable(FormFieldType.trades),
                  fillColor: JPAppTheme.themeColors.base,
                  readOnly: true,
                  onPressed: service.selectTrade,
                  suffixChild: Padding(
                    padding: EdgeInsets.symmetric(horizontal: controller.formUiHelper.horizontalPadding),
                    child: JPIcon(
                      Icons.expand_more_outlined,
                      color: JPAppTheme.themeColors.tertiary,
                    ),
                  ),
                ),
              ),
            ),

            /// day reminder
            EventFormDayReminderSection(
              controller: controller,
              errorText: service.errorText,
            ),

            SizedBox(
              height: controller.formUiHelper.inputVerticalSeparator,
            ),

            /// Recurring
            EventFormRecurringSection(
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }
}
