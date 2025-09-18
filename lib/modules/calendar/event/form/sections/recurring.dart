
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/calendars/event_form.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/global_widgets/expansion_tile/index.dart';
import 'package:jobprogress/modules/calendar/event/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../common/enums/form_field_type.dart';

class EventFormRecurringSection extends StatelessWidget {
  const EventFormRecurringSection({
    super.key,
    required this.controller
  });

  final EventFormController controller;

  EventFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return JPExpansionTile(
      headerBgColor: JPColor.transparent,
      header: JPText(
        text: 'recurring'.tr,
        fontWeight: JPFontWeight.medium,
        textAlign: TextAlign.start,
      ),
      contentPadding: EdgeInsets.zero,
      disableRotation: true,
      trailing: (val) => JPToggle(
        value: service.isRecurringSelected,
        onToggle: controller.onRecurringChanged,
        disabled: !service.isFieldEditable(FormFieldType.recurring),
      ),
      headerPadding: EdgeInsets.zero,
      initialCollapsed: service.isRecurringSelected,
      isExpanded: service.isRecurringSelected,
      children: [

        SizedBox(
          height: controller.formUiHelper.inputVerticalSeparator,
        ),

        JPInputBox(
          readOnly: true,
          label: 'frequency'.tr.capitalizeFirst!,
          type: JPInputBoxType.withLabel,
          isRequired: true,
          onPressed: service.selectRecurringType,
          fillColor: JPAppTheme.themeColors.base,
          suffixChild: Padding(
            padding: const EdgeInsets.all(8.0),
            child: JPIcon(Icons.expand_more, color: JPAppTheme.themeColors.darkGray,),
          ),
          inputBoxController: service.recurringFrequencyController,
          validator: (val) => FormValidator.requiredFieldValidator(val),
          disabled: !service.isFieldEditable(FormFieldType.recurring),
        ),

        SizedBox(
          height: controller.formUiHelper.inputVerticalSeparator,
        ),

        JPInputBox(
          label: 'occurrences'.tr.capitalizeFirst!,
          type: JPInputBoxType.withLabel,
          isRequired: true,
          fillColor: JPAppTheme.themeColors.base,
          inputBoxController: service.recurringOccurrencesController,
          maxLength: 2,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: (val) => FormValidator.validateOccurrence(val),
          disabled: !service.isFieldEditable(FormFieldType.recurring),
          onChanged: controller.onDataChanged,
        ),
      ],
    );
  }
}
