import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../common/enums/date_picker_type.dart';
import '../../../../../common/enums/form_toggles.dart';
import '../../../../../common/services/calendars/event_form.dart';
import '../../../../../core/constants/date_formats.dart';
import '../../controller.dart';

class EventFormDayReminderSection extends StatelessWidget {
  const EventFormDayReminderSection({
    super.key,
    required this.controller,
    this.errorText,
  });

  final EventFormController controller;
  final String? errorText;

  EventFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: controller.formUiHelper.suffixPadding, vertical: controller.formUiHelper.suffixPadding),
            decoration: BoxDecoration(
              border: Border.all(
                color: (errorText?.isNotEmpty ?? false) ? JPAppTheme.themeColors.secondary : JPAppTheme.themeColors.dimGray,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    JPText(
                      text: 'all_day'.tr.capitalize!,
                      textSize: JPTextSize.heading4,
                      textColor: JPAppTheme.themeColors.text,
                    ),
                    JPToggle(
                      value: service.isAllDayReminderSelected,
                      disabled: !service.isFieldEditable(FormToggles.remindNotification),
                      onToggle: controller.onReminderChanged,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: controller.formUiHelper.suffixPadding),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 17),
                        child: JPText(
                          text: "${'start'.tr.capitalize!}: ",
                          textSize: JPTextSize.heading4,
                          textColor: JPAppTheme.themeColors.text,
                        ),
                      ),
                      Flexible(
                        child: Wrap(
                          runSpacing: 2,
                          children: [
                            JPButton(
                              onPressed: () => service.openDatePicker(
                                datePickerType: DatePickerType.start,
                                initialDate: service.startDateTime,
                              ),
                              disabled: !service.isFieldEditable(FormToggles.remindNotification),
                              size: JPButtonSize.datePickerButton,
                              colorType: JPButtonColorType.lightGray,
                              text: DateTimeHelper.format(service.startDateTime, DateFormatConstants.chatPastMessageFormat),
                              textSize: JPTextSize.heading4,
                              textColor: JPAppTheme.themeColors.text,
                              iconWidget: JPIcon(
                                Icons.event,
                                color: JPAppTheme.themeColors.darkGray,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Visibility(
                              visible: !service.isAllDayReminderSelected,
                              child: JPButton(
                                onPressed: () => service.openTimePicker(
                                  datePickerType: DatePickerType.start,
                                  initialTime: service.startDateTime,
                                ),
                                disabled: !service.isFieldEditable(FormToggles.remindNotification),
                                size: JPButtonSize.datePickerButton,
                                colorType: JPButtonColorType.lightGray,
                                text: DateTimeHelper.format(service.startDateTime, DateFormatConstants.timeOnlyFormat),
                                textSize: JPTextSize.heading4,
                                textColor: JPAppTheme.themeColors.text,
                                iconWidget: JPIcon(
                                  Icons.schedule_outlined,
                                  color: JPAppTheme.themeColors.darkGray,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: !service.isAllDayReminderSelected,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 23),
                          child: JPText(
                            text: "${'end'.tr.capitalize!}: ",
                            textSize: JPTextSize.heading4,
                            textColor: JPAppTheme.themeColors.text,
                          ),
                        ),
                        Flexible(
                          child: Wrap(
                            runSpacing: 2,
                            children: [
                              JPButton(
                                onPressed: () => service.openDatePicker(
                                  datePickerType: DatePickerType.end,
                                  initialDate: service.endDateTime,
                                  firstDate: service.startDateTime,
                                ),
                                disabled: !service.isFieldEditable(FormToggles.remindNotification),
                                size: JPButtonSize.datePickerButton,
                                colorType: JPButtonColorType.lightGray,
                                text: DateTimeHelper.format(service.endDateTime, DateFormatConstants.chatPastMessageFormat),
                                textSize: JPTextSize.heading4,
                                textColor: JPAppTheme.themeColors.text,
                                iconWidget: JPIcon(
                                  Icons.event,
                                  color: JPAppTheme.themeColors.darkGray,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 5),
                              JPButton(
                                onPressed: () => service.openTimePicker(
                                  datePickerType: DatePickerType.end,
                                  initialTime: service.endDateTime,
                                ),
                                disabled: !service.isFieldEditable(FormToggles.remindNotification),
                                size: JPButtonSize.datePickerButton,
                                colorType: JPButtonColorType.lightGray,
                                text: DateTimeHelper.format(service.endDateTime, DateFormatConstants.timeOnlyFormat),
                                textSize: JPTextSize.heading4,
                                textColor: JPAppTheme.themeColors.text,
                                iconWidget: JPIcon(
                                  Icons.schedule_outlined,
                                  color: JPAppTheme.themeColors.darkGray,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: errorText?.isNotEmpty ?? false,
          child: JPText(
            text: errorText ?? "",
            textSize: JPTextSize.heading5,
            textColor: JPAppTheme.themeColors.secondary,
          ),
        ),
      ],
    );
  }
}
