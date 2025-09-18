
class RemainderTime {
  String convertRemainderTime(int minutes, String type) {

    int hours = Duration(minutes: minutes).inHours;
    int days = Duration(minutes: minutes).inDays;
    int weeks = Duration(minutes: minutes).inDays~/7;

    int daysWithWeek = weeks != 0 ? days % (weeks * 7) : 0;

    if(minutes < 60) {
      if(minutes == 1) return '1 Minute before';
      return '$minutes Minutes before';
    } else if(hours < 24) {
      if(hours == 1) return '1 Hour before';
      return '$hours Hours before';
    } else if(days < 7) {
      if(days == 1) return '1 Day before';
      return '$days Days before';
    } else {
      String weekDays = daysWithWeek == 1 ? '1 Day' : '$daysWithWeek Days';
      String weeksText = weeks == 1 ? '1 Week' : '$weeks Weeks';
      if(weeks == 1 && daysWithWeek == 0) return '$weeksText before';
      if(weeks >= 1 && daysWithWeek == 0) return '$weeksText before';
      return '$weeksText $weekDays before';
    }
  }

  String getRemainder(int time, String type) {
    if (type == 'email') {
      return '${convertRemainderTime(time, type)}, as $type';
    } else {
      return convertRemainderTime(time, type);
    }
  }

  String getReminderDurationType(int timeInMinutes) {

    int hours = Duration(minutes: timeInMinutes).inHours;
    int days = Duration(minutes: timeInMinutes).inDays;

    if(timeInMinutes < 60) {
      return 'minute';
    } else if(hours < 24) {
      return 'hour';
    } else if(days < 30) {
      return 'day';
    } else {
      return 'week';
    }
  }

  int durationTypeToValue(int timeInMinutes, String type) {

    int hours = Duration(minutes: timeInMinutes).inHours;
    int days = Duration(minutes: timeInMinutes).inDays;
    int weeks = Duration(minutes: timeInMinutes).inDays~/7;

    switch (type) {
      case "minute":
        return timeInMinutes;
      case "hour":
        return hours;
      case "day":
        return days;
      case "week":
        return weeks;
      default:
        return 1;
    }
  }

  int getTypeToMinutes(String val, String type) {

    if(val.isEmpty) val = '1';

    int value = int.parse(val);

    switch (type) {
      case "minute":
        return Duration(minutes: value).inMinutes;
      case "hour":
        return Duration(hours: value).inMinutes;
      case "day":
        return Duration(days: value).inMinutes;
      case "week":
        return Duration(days: value * 7).inMinutes;
      default:
        return 1;
    }
  }

}
