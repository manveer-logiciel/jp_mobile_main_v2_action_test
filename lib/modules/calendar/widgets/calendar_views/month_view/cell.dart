import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/appointment/appointment_limited.dart';
import 'package:jobprogress/common/models/schedules/schedules.dart';
import 'package:jobprogress/global_widgets/animated_open_container/index.dart';
import 'package:jobprogress/modules/appointment_details/page.dart';
import 'package:jobprogress/modules/calendar/controller.dart';
import 'package:jobprogress/modules/schedule/details/page.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CalendarMonthViewCell extends StatelessWidget {
  const CalendarMonthViewCell({
    super.key,
    required this.isToday,
    required this.isInCurrentMonth,
    required this.date,
    required this.events,
    required this.onTapCell,
    this.isLastTapped = false,
    this.isLoading = true,
    required this.isSixWeekMonth,
    required this.controller
  });

  final List<CalendarEventData<dynamic>> events;

  final bool isToday;

  final DateTime date;

  final bool isInCurrentMonth;

  final bool isLastTapped;

  final bool isLoading;

  final bool isSixWeekMonth;

  final Function(List<CalendarEventData<dynamic>> events, DateTime date) onTapCell;

  final CalendarPageController controller;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isLoading ? 0.4 : 1,
      child: Material(
        child: InkWell(
          onTap: !isInCurrentMonth || isLoading
              ? null
              : () {
                  onTapCell(events, date);
                },
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: double.maxFinite,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: JPScreen.isMobile
                        ? EdgeInsets.zero
                        : EdgeInsets.only(
                            top: isSixWeekMonth ? 4 : 6,
                            right: isSixWeekMonth ? 4 : 8,
                    ),
                    child: Row(
                      mainAxisAlignment: JPScreen.isMobile
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: isLastTapped && isInCurrentMonth
                                  ? JPAppTheme.themeColors.primary
                                  : isToday
                                      ? JPAppTheme.themeColors.lightBlue
                                      : null),
                          child: Center(
                            child: JPText(
                              text: date.day.toString(),
                              textSize: JPTextSize.heading4,
                              fontWeight: JPFontWeight.medium,
                              textColor: isInCurrentMonth
                                  ? isLastTapped
                                      ? JPAppTheme.themeColors.base
                                      : JPAppTheme.themeColors.text
                                  : JPAppTheme.themeColors.secondaryText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  if (isInCurrentMonth)
                    JPResponsiveBuilder(
                      mobile: mobileEvents,
                      tablet: tabletEvents,
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get mobileEvents => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(events.length > 4 ? 4 : events.length, (index) {
          return Container(
            height: 4,
            width: 4,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: events[index].color, width: 1)),
          );
        }),
      );

  Widget get tabletEvents => Column(
    children: List.generate(
        events.length > 3 ? 3 : events.length, (index) {

          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 4, vertical: isSixWeekMonth ? 1 : 3 ),
            child: JPOpenContainer(
              closeWidget: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(
                    horizontal: 4, vertical: isSixWeekMonth ? 1 : 2),
                child: JPText(
                  text: events[index].title,
                  textSize: JPTextSize.heading6,
                  textColor: JPAppTheme.themeColors.base,
                  maxLine: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
              ),
              openWidget: openWidget(events[index]),
              closedColor: events[index].color,
              borderRadius: 10,
            ),
          );
    }),
  );

  Widget openWidget(CalendarEventData event) {
    final calendarEvent = event.event;

    if(calendarEvent is AppointmentLimitedModel) {
      return AppointmentDetailsView(
        appointmentId: calendarEvent.id,
        onAppointmentDelete: controller.fetchEvents,
        onAppointmentUpdate: (_) => controller.fetchEvents(),
      );
    } else if (calendarEvent is SchedulesModel){
      return ScheduleDetail(
        scheduleId: calendarEvent.id.toString(),
      );
    } else {
      return const SizedBox();
    }
  }

}
