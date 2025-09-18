import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/appointment/appointment_limited.dart';
import 'package:jobprogress/common/models/schedules/schedules.dart';
import 'package:jobprogress/modules/calendar/controller.dart';
import 'package:jobprogress/modules/calendar/widgets/events/event_tile/appointment.dart';
import 'package:jobprogress/modules/calendar/widgets/events/event_tile/schedule.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CalendarEventsAnimatedList extends StatelessWidget {
  const CalendarEventsAnimatedList({
    super.key,
    required this.controller,
  });

  final CalendarPageController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: controller.listKey,
      initialItemCount: controller.selectedDateEvents.length,
      controller: controller.eventListController,
      shrinkWrap: true,
      itemBuilder: (_, index, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.8),
            end: const Offset(0, 0),
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.ease,
            ),
          ),
          child: index < controller.selectedDateEvents.length
              ? typeToTile(controller.selectedDateEvents[index], index)
              : const SizedBox(),
        );
      },
    );
  }

  Widget typeToTile(CalendarEventData event, int index) {
    if (event.event is AppointmentLimitedModel) {
      return CalendarAppointmentTile(
        appointment: (event.event as AppointmentLimitedModel),
        onAppointmentDelete: controller.fetchEvents,
        onAppointmentUpdate: (appointment) => controller.fetchEvents(),
      );
    } else if (event.event is SchedulesModel) {
      return CalendarScheduleTile(
        schedule: (event.event as SchedulesModel),
        eventColor: event.color,
        onScheduleDelete: controller.fetchEvents,
      );
    } else {
      return const SizedBox();
    }
  }
}
