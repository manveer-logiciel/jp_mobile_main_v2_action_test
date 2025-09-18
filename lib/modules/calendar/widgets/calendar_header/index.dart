import 'package:flutter/material.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/modules/calendar/controller.dart';
import 'package:jobprogress/modules/calendar/widgets/calendar_header/date_selector.dart';
import 'package:jobprogress/modules/calendar/widgets/calendar_header/header_action_button.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'view_selector.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    super.key,
    required this.startDate,
    this.endDate,
    required this.controller,
  });

  /// startDate is the starting date of week, month or selected day date
  final DateTime startDate;

  /// end date is the last day of week or month
  final DateTime? endDate;

  /// controller helps in handling callbacks
  final CalendarPageController controller;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: controller.isLoading ? 0.5 : 1,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 14,
          bottom: 8
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16
          ),
          child: Row(
            children: [
              /// date selector
              Flexible(
                child: CalendarHeaderDateSelector(
                  selectedDate: startDate,
                  onTap: controller.isLoading ? null : controller.selectDate,
                ),
              ),
              /// header actions view, previous, next switcher
              actions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget actions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// view selector
        CalendarHeaderActionButton(
          onTap: controller.showViewSelector,
          child: CalendarViewSelector(
            value: SingleSelectHelper.getSelectedSingleSelectValue(
                controller.viewsList, controller.getDisplayViewType().toString()),
            ),
        ),
        const SizedBox(
          width: 10,
        ),

        /// previous <- day, month, week switcher
        CalendarHeaderActionButton(
          onTap: controller.isLoading ? null : controller.previousPage,
          width: 32,
            child: const JPIcon(
              Icons.chevron_left,
            ),
        ),
        const SizedBox(
          width: 10,
        ),

        /// next -> day, month, week switcher
        CalendarHeaderActionButton(
          onTap: controller.isLoading ? null : controller.nextPage,
          width: 32,
          child: const JPIcon(
            Icons.chevron_right,
          ),
        ),
      ],
    );
  }

}
