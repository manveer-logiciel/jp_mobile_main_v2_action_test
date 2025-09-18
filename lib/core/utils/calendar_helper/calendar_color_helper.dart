import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/schedules/schedules.dart';
import 'package:jobprogress/core/constants/calendars.dart';
import 'package:jobprogress/core/utils/color_helper.dart';

/// CalendarColorHelper can be used to set event colors of calendar

class CalendarColorHelper {

  static Color getScheduleColor(
    SchedulesModel schedule, {
    String? selectedColorScheme,
  }) {

    String? tempColor;

    if (selectedColorScheme != null) {
      tempColor = filterScheduleColorFromScheme(
          schedule,
          selectedColorScheme: selectedColorScheme,
      );

    } else if (schedule.createdBy != null) {
      tempColor = schedule.createdBy?.color ?? CalendarsConstants.defaultAppointmentColor;
    }

    tempColor ??= CalendarsConstants.defaultAppointmentColor;

    return ColorHelper.getHexColor(tempColor);
  }

  static String? filterScheduleColorFromScheme(
    SchedulesModel schedule, {
    String? selectedColorScheme,
  }) {
    String? tempColor;

    switch (selectedColorScheme) {
      case "salesman":
      case 'customer_rep':
        tempColor = schedule.customer?.rep?.color;
        break;

      case 'estimator':
        if (schedule.job?.estimators?.isNotEmpty ?? false) {
          tempColor = schedule.job?.estimators?.first.color;
        } else if (schedule.jobEstimators?.isNotEmpty ?? false) {
          tempColor = schedule.jobEstimators?.first.color;
        }
        break;

      case "workcrew":
      case 'company_crew':
        if (schedule.reps?.isNotEmpty ?? false) {
          tempColor = schedule.reps?.first.color;
        }
        break;

      case "labor_sub":
        if (schedule.subContractors?.isNotEmpty ?? false) {
          tempColor = schedule.subContractors?.first.color;
        }
        break;

      case "trades":
        if (schedule.trades?.isNotEmpty ?? false) {
          tempColor = schedule.trades?.first.color;
        }
        break;

      case "work-type":
        if (schedule.workTypes?.isNotEmpty ?? false) {
          tempColor = schedule.workTypes?.first.color;
        }
        break;

      case "divisions":
        tempColor = schedule.job?.division?.color;
    }

    return tempColor;
  }

  static String getAppointmentColor({
    String? attendeeColor,
    String? userColor
  }) {
    return attendeeColor
        ?? userColor
        ?? CalendarsConstants.defaultAppointmentColor;
  }

}
