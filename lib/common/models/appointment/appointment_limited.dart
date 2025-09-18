import 'package:get/get.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/utils/calendar_helper/calendar_color_helper.dart';
import 'package:jobprogress/core/utils/calendar_helper/calendar_time_helper.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';

class AppointmentLimitedModel {
  int? id;
  String? title;
  String? description;
  String? startDateTime;
  String? endDateTime;
  late bool isRecurring;
  late bool isAllDay;
  bool? isCompleted;
  String? appointmentHexColor;
  String? appointmentTimeString;
  String? attendeeColor;
  UserLimitedModel? user;
  late bool hasAttachments;

  AppointmentLimitedModel({
    this.id,
    this.title,
    this.description,
    this.startDateTime,
    this.endDateTime,
    this.isRecurring = false,
    this.isAllDay = false,
    this.isCompleted,
    this.appointmentHexColor,
    this.appointmentTimeString,
    this.user,
    this.attendeeColor,
    this.hasAttachments = false
  });

  AppointmentLimitedModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    startDateTime = json['start_date_time'];
    endDateTime = json['end_date_time'];
    isRecurring = json['is_recurring'] ?? false;
    isAllDay = json['full_day'] == 1 ? true : false;
    isCompleted = json['is_completed'];

    if(json['attendees']?['data'] != null) {
      int loggedInUserId = AuthService.userDetails!.id;

      json['attendees']['data'].forEach((dynamic attendee) {
        if(attendee['id'] == loggedInUserId) {
          attendeeColor = attendee['color'];
        }
      });
    }
    user = json['user'] != null ? UserLimitedModel.fromJson(json['user']) : null;
    hasAttachments = (int.tryParse((json['attachments_count']?['count']).toString()) ?? 0) > 0;

    appointmentHexColor = CalendarColorHelper.getAppointmentColor(
      attendeeColor: attendeeColor,
      userColor: user?.color
    );
    appointmentTimeString = CalendarTimeHelper.getTimeString(
        isAllDay: isAllDay,
        startDateTime: startDateTime!,
        endDateTime: endDateTime!,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['start_date_time'] = startDateTime;
    data['end_date_time'] = endDateTime;
    data['is_recurring'] = isRecurring;
    data['interval'] = interval;
    data['is_completed'] = isCompleted;
    data['full_day'] = isAllDay ? 1 : 0;
    return data;
  }

}
