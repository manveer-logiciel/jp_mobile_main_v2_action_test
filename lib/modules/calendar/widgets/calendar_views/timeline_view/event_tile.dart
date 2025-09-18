
import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/appointment/appointment_limited.dart';
import 'package:jobprogress/common/models/schedules/schedules.dart';
import 'package:jobprogress/global_widgets/animated_open_container/index.dart';
import 'package:jobprogress/modules/appointment_details/page.dart';
import 'package:jobprogress/modules/calendar/controller.dart';
import 'package:jobprogress/modules/schedule/details/page.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class TimeLineEventTile extends StatelessWidget {
  const TimeLineEventTile({
    super.key,
    required this.event,
    required this.controller
  });

  final CalendarEventData<dynamic> event;

  final CalendarPageController controller;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(
          left: 10,
          right: 16
      ),
      child: JPOpenContainer(
        closeWidget: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 4
          ),
          child: Row(
            children: [
              Expanded(
                child: JPText(
                  text: event.title,
                  dynamicFontSize: 10,
                  textColor: JPAppTheme.themeColors.base,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLine: 1,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              JPText(
                text: getAppointmentTime() ?? "",
                dynamicFontSize: 10,
                textColor: JPAppTheme.themeColors.base,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                maxLine: 1,
              )
            ],
          ),
        ),
        openWidget: openWidget(),
        closedColor: event.color,
        borderRadius: 10,
      ),
    );
  }

  String? getAppointmentTime() {
    if(event.event is AppointmentLimitedModel) {
      return (event.event as AppointmentLimitedModel).appointmentTimeString;
    } else if (event.event is SchedulesModel) {
      return (event.event as SchedulesModel).scheduleTimeString;
    } else {
      return '';
    }
  }

  Widget openWidget() {
    final calendarEvent = event.event;

    if(calendarEvent is AppointmentLimitedModel) {
      return AppointmentDetailsView(
        appointmentId: calendarEvent.id,
        onAppointmentDelete: controller.fetchEvents,
        onAppointmentUpdate: (_) => controller.fetchEvents(),
      );
    } else {
      return ScheduleDetail(
        scheduleId: calendarEvent.id.toString(),
      );
    }
  }

}
