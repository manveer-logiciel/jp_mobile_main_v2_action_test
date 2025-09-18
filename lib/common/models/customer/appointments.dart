import 'package:jobprogress/common/models/appointment/appointment.dart';

class CustomerAppointments {

  int? today;
  int? past;
  AppointmentModel? todayFirst;
  int? upcoming;
  AppointmentModel? upcomingFirst;

  CustomerAppointments({
    this.today,
    this.todayFirst,
    this.upcoming,
    this.upcomingFirst,
    this.past
  });

  CustomerAppointments.fromJson(Map<String, dynamic> json) {
    today = json['today'];
    if(json['today_first'] != null && json['today_first'] is Map) {
      todayFirst = AppointmentModel.fromJson(json['today_first']);
    }
    upcoming = json['upcoming'];
    past = json['past'];
    if(json['upcoming_first'] != null && json['upcoming_first'] is Map) {
      upcomingFirst = AppointmentModel.fromJson(json['upcoming_first']);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['today'] = today;
    data['past'] = past;
    data['today_first'] = todayFirst;
    data['upcoming'] = upcoming;
    data['upcoming_first'] = upcomingFirst;
    return data;
  }
}