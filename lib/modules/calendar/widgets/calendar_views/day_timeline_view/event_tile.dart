
import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/appointment/appointment_limited.dart';
import 'package:jobprogress/common/models/schedules/schedules.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CalendarDayViewEventTile extends StatelessWidget {

  const CalendarDayViewEventTile({
    super.key,
    required this.event,
    required this.onTap,
  });

  final CalendarEventData event;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: event.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: BorderSide(
          color: JPAppTheme.themeColors.base,
          width: 1.5
        )
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: JPText(
            text: event.title,
            textAlign: TextAlign.start,
            textColor: JPAppTheme.themeColors.base,
            textSize: JPTextSize.heading5,
          ),
        ),
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
}
