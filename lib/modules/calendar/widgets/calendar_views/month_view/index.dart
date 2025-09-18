import 'package:flutter/material.dart';
import 'package:jobprogress/modules/calendar/controller.dart';
import 'package:jobprogress/modules/calendar/widgets/calendar_header/index.dart';
import 'package:jobprogress/modules/calendar/widgets/calendar_views/month_view/cell.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../calendar_weekday_header.dart';

class CalendarMonthView extends StatelessWidget {
  const CalendarMonthView({
    super.key,
    required this.controller
  });

  final CalendarPageController controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: MonthView<dynamic>(
          key: controller.monthViewKey,
          weekViewKey: controller.monthWeekViewKey,
          cellAspectRatio: 1,
          controller: controller.eventController,
          calendarPadding: EdgeInsets.symmetric(
            horizontal: JPScreen.isMobile ? 6 : 0
          ),
          initialDay: controller.selectedDate,
          borderColor: JPColor.transparent,
          startDay: controller.weekStartFrom,
          headerBuilder: (DateTime dateTime) {
            return CalendarHeader(
                startDate: dateTime,
                controller: controller,
            );
          },
          weekDayBuilder: (int day) {
            return CalenderWeekDayHeaderTile(
              dayIndex: day,
              viewType: CalendarsViewType.month,
            );
          },
          cellBuilder: (DateTime date, List<CalendarEventData<dynamic>> events, bool isToday, bool isInCurrentMonth) {
            return CalendarMonthViewCell(
                isToday: isToday,
                isInCurrentMonth: isInCurrentMonth,
                date: date,
                events: events,
                isLastTapped: controller.selectedDate == date,
                onTapCell: controller.onTapMonthCell,
                isLoading: controller.isLoading,
                isSixWeekMonth: controller.isSixWeekMonth,
                controller: controller,
            );
          },
          onPageChange: controller.onPageChanged,
          initialMonth: controller.requestParams.date,
        ),
      ),
    );
  }


}
