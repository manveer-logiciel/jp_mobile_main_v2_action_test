
import 'package:flutter/material.dart';
import 'package:jobprogress/modules/calendar/controller.dart';
import 'package:jobprogress/modules/calendar/widgets/calendar_header/index.dart';
import 'package:jobprogress/modules/calendar/widgets/calendar_views/calendar_weekday_header.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../month_view/cell.dart';

class CalendarMonthWeekView extends StatelessWidget {

  const CalendarMonthWeekView({
    super.key,
    required this.controller,
  });

  /// controller used to handle callbacks
  final CalendarPageController controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: MonthWeekView<dynamic>(
          key: controller.monthWeekViewKey,
          cellBuilder: (DateTime date, List<CalendarEventData<dynamic>> events, bool isToday, bool isInCurrentMonth) {
            return CalendarMonthViewCell(
              isToday: isToday,
              isInCurrentMonth: isInCurrentMonth,
              date: date,
              events: events,
              isLastTapped: controller.selectedDate.compareWithoutTime(date),
              onTapCell: controller.onTapMonthCell,
              isLoading: controller.isLoading,
              isSixWeekMonth: controller.isSixWeekMonth,
              controller: controller,
            );
          },
          controller: controller.eventController,
          weekDayBuilder: (DateTime date) {
            return CalenderWeekDayHeaderTile(
              dateTime: date,
              viewType: CalendarsViewType.monthWeek,
            );
          },
          weekPageHeaderBuilder: (DateTime startDate, DateTime endDate) {
            return CalendarHeader(
              startDate: controller.selectedDate,
              endDate: endDate,
              controller: controller,
            );
          },
          initialDay: controller.selectedDate,
          onPageChange: controller.onPageChanged,
          startDay: controller.weekStartFrom,
        ),
      ),
    );
  }

}
