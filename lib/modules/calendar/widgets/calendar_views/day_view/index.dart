import 'package:flutter/material.dart';
import 'package:jobprogress/modules/calendar/controller.dart';
import 'package:jobprogress/modules/calendar/widgets/calendar_views/calendar_weekday_header.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../calendar_header/index.dart';

class CalendarDayView extends StatelessWidget {

  const CalendarDayView({
    super.key,
    required this.controller
  });

  /// controller used to handle callbacks
  final CalendarPageController controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: DayView(
        key: controller.dayViewKey,
        controller: controller.eventController,
        dayTitleBuilder: (DateTime dateTime) {
          return CalendarHeader(
            controller: controller,
            startDate: dateTime,
          );
        },
        weekDayBuilder: (DateTime date) {
          return CalenderWeekDayHeaderTile(
            dateTime: date,
            viewType: CalendarsViewType.day,
            isToday: date.compareWithoutTime(DateTime.now()),
          );
        },
        initialDay: controller.selectedDateUTC,
        onPageChange: controller.onPageChanged,
      ),
    );
  }
}
