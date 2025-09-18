class ReminderTimeHelpers {
  static String convertReminderTime(int time, String type) {
    if (time < 60) {
      return '$time minutes before';
    } else if (time < 1440) {
      int hour = time ~/ 60;
      if (hour == 1) return '$hour hour before';
      return '$hour hours before';
    } else {
      int week = time ~/ 1440;
      if (week == 1) return '$week week before';
      return '$week weeks before';
    }
  }

  static String getRemainder(int time, String type) {
    if (type == 'email') {
      return '${convertReminderTime(time, type)},as $type';
    } else {
      return convertReminderTime(time, type);
    }
  }
}
