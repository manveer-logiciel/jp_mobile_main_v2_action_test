import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:jobprogress/common/extensions/date_time/index.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jp_mobile_flutter_ui/DatePicker/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';
import '../../global_widgets/bottom_sheet/controller.dart';
import 'helpers.dart';


class DateTimeHelper {
  static late Location userTimeZone;
  static const String defaultLocation = 'America/New_York';

  static void setUpTimeZone() {
    tz.initializeTimeZones();

    dynamic timeZone = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.timeZone);

    if (timeZone is bool) {
      timeZone = defaultLocation;
    }

    userTimeZone = tz.getLocation(timeZone.trim());
  }

  // For converting date into diffrent format according to timezone
  // ('2018-01-18 11:08:57', 'dateFormatOnly')
  static String formatDate(String date, String format) {
    final DateTime? givenDate = DateTime.tryParse('$date Z');
    if(givenDate != null) {
      DateTime convertedDate = TZDateTime.from(givenDate, userTimeZone);

      if (format == 'am_time_ago') {
        return Jiffy.parseFromDateTime(convertedDate.toLocal()).fromNow();
      }

      return Jiffy.parseFromDateTime(convertedDate).format(pattern: format);
    } else {
      return '';
    }
  }

  static String format(dynamic date, String format) {
    if (date is String) {
      return Jiffy.parse(date).format(pattern: format);
    } else if (date is DateTime) {
      return Jiffy.parseFromDateTime(date).format(pattern: format);
    } else {
      return "";
    }
  }

  static String getLabelAccordingToDate(String date) {
    tz.initializeTimeZones();

    String timeZone = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.timeZone);
    Location userTimeZone = tz.getLocation(timeZone.trim());

    DateTime convertedDate = TZDateTime.from(DateTime.parse('$date Z'), userTimeZone);
    if (convertedDate.isToday()) return 'today'.tr.toUpperCase();

    if (convertedDate.isYesterday()) return 'yesterday'.tr.toUpperCase();

    return 'older'.tr.toUpperCase();
  }

  // For converting date(20-12-2020) into date (20/12/2020)
  static String convertHyphenIntoSlash(String date) {

    if(!date.contains("-")){
      return date;
    }
    
    final splittedDate = date.split("-");
    String convertedDate =
        '${splittedDate[1]}/${splittedDate[2]}/${splittedDate[0]}';
    return convertedDate;
  }

  static String convertSlashIntoHyphen(String date) {
    if(!date.contains('/')) {
      return date;
    }
    final splittedDate = date.split("/");
    String convertedDate =
        '${splittedDate[2]}-${splittedDate[0]}-${splittedDate[1]}';
    return convertedDate;
  }

  static Future<DateTime?> openDatePicker ({
    String? initialDate,
    String? helpText,
    String? firstDate,
    String? lastDate,
    bool isPreviousDateSelectionAllowed = true
  }) async {
    final initDate = initialDate?.isEmpty ?? true ? null : DateTime.parse(DateTimeHelper.convertSlashIntoHyphen(initialDate!));
    final fDate =  isPreviousDateSelectionAllowed
        ? firstDate == null
          ? null
          : DateTime.parse(DateTimeHelper.convertSlashIntoHyphen(firstDate))
        : firstDate == null
          ? DateTime.now()
          : DateTime.parse(DateTimeHelper.convertSlashIntoHyphen(firstDate));
    final lDate = lastDate != null ? DateTime.parse(DateTimeHelper.convertSlashIntoHyphen(lastDate)): null;
    return await Get.dialog(
        JPDatePicker(
          initialDate: initDate,
          firstDate: fDate,
          lastDate: lDate,
          helpText:  helpText ?? 'start_date'.tr,
        )
    );
  }

  static Future<TimeOfDay?> openTimePicker ({
    String? initialTime,
    String? helpText,
    bool isPreviousDateSelectionAllowed = true
  }) async {
    final initTime = initialTime?.isEmpty ?? true ? null : TimeOfDay.fromDateTime(DateTime.parse(DateTimeHelper.convertSlashIntoHyphen(initialTime!)));
    return await showJPGeneralDialog(
        isDismissible: false,
        child: (JPBottomSheetController controller) {
          return MediaQuery(
            data: MediaQuery.of(Get.context!).copyWith(alwaysUse24HourFormat: false),
            child: JPTimePicker(
              initialTime: initTime,
              helpText: helpText ?? 'start_time'.tr,
            ),
          );
        }
    );
  }

  static bool validateDates({String? start, String? end}) {
    if((start?.isEmpty ?? true) && (end?.isEmpty ?? true)){
      Helper.showToastMessage('provide_start_end_date'.tr);
      return false;
    } else if(start?.isEmpty ?? true){
      Helper.showToastMessage('provide_start_date'.tr);
      return false;
    } else if(end?.isEmpty ?? true){
      Helper.showToastMessage('provide_end_date'.tr);
      return false;
    } else {
      final startDate = DateTime.parse(DateTimeHelper.convertSlashIntoHyphen(start!));
      final endDate = DateTime.parse(DateTimeHelper.convertSlashIntoHyphen(end!));
      if (startDate.compareTo(endDate) == 1) {
        Helper.showToastMessage('end_date_should_not_be_smaller_than_start_date'.tr);
        return false;
      }
    }
    return true;
  }

  static DateTime now() => DateTime.parse(DateTime.now().toUtc().toString().replaceAll('Z', ''));

  /// getDuration() : returns duration in format '00:00' in comparison to current time
  static String getDuration(String dateTime) {

    Duration difference = DateTimeHelper.now().difference(DateTime.parse(dateTime));

    int tempMinutes = difference.inMinutes % 60;

    String minutes = tempMinutes < 10 ? '0$tempMinutes' : '$tempMinutes';
    String hours = difference.inHours < 10 ? '0${difference.inHours}' : '${difference.inHours}';

    return '$hours:$minutes';
  }

  static String getTimeLabel(DateTime date) {
    if(date.isToday()) {
      return 'today'.tr.capitalizeFirst!;
    } else if(date.isYesterday()) {
      return 'yesterday'.tr.capitalizeFirst!;
    } else {
      return DateTimeHelper.format(date, DateFormatConstants.chatPastMessageFormat);
    }
  }

   static bool isPastDate(String date, String format){
    String today = formatDate(DateTime.now().toString(), format);
    DateTime formattedTodayDate = DateTime.parse(today);
    return DateTime.parse(date).isBefore(formattedTodayDate);
  }

  static bool isFutureDate(String date, String format){
    String today = formatDate(DateTime.now().toString(), format);
    DateTime formattedTodayDate = DateTime.parse(today);
    return DateTime.parse(date).isAfter(formattedTodayDate);
  }

  static String dateTimePickerTimeFormatting(String pickedDate, String pickedTime) {
    DateTime temp = DateTime.parse(DateTimeHelper.format(pickedDate, DateFormatConstants.dateTimeServerFormat));
    DateTime temp1 = DateTime.parse(pickedTime);
    return DateTime(temp.year, temp.month, temp.day, temp1.hour, temp1.minute, temp1.second).toString();
  }

  static DateTime? stringToDateTime(String? date) {
    return DateTime.tryParse(date ?? '');
  }

  static DateTime addCurrentDayToHourDetails(String time) {
    final currentTime = now();
    List<int> hourDetails = time.split(":").map((time) => int.parse(time)).toList();
    return DateTime(currentTime.year, currentTime.month, currentTime.day, hourDetails[0], hourDetails[1]);
  }

  /// [unixToDateTime] converts unix timestamp to date time
  static String? unixToDateTime(int? unix) {
    // Check if unix is null, if yes, return null
    if(unix == null) return null;
    // Convert unix to DateTime
    final dateTime = DateTime.fromMillisecondsSinceEpoch(unix * 1000);
    // Return formatted date time
    return TZDateTime.from(dateTime, DateTimeHelper.userTimeZone).toLocal().toString().replaceAll('Z', '');
  }

  /// [isZeroDate] checks if date is zero
  /// [date] : date in string format
  /// Return true if date is zero else false
  static bool isZeroDate(String? date) {
    return DateTime.tryParse(date ?? '')?.year.isNegative ?? false;
  }

  /// Returns a user-friendly last active message based on the given date string.
  /// Examples: "Last Active 5 min ago", "Yesterday", "Today", "few seconds ago"
  static String getLastActiveMessage(String dateString) {
    DateTime? date = DateTime.tryParse(dateString);
    if (date == null) return '';
    final now = DateTimeHelper.now();
    final diff = now.difference(date);
    int hours = diff.inHours % 24;
    int minutes = diff.inMinutes % 60;
    int seconds = diff.inSeconds % 60;

    if (hours > 0) {
      return 'Last active $hours hour${hours == 1 ? '' : 's'} ago';
    } else if (minutes > 0) {
      return 'Last active $minutes min ago';
    } else if (seconds > 0) {
      return 'Last active few seconds ago';
    } else if (hours < 24 && date.isToday()) {
      return 'Last active Today';
    } else if (date.isYesterday()) {
      return 'Last active Yesterday';
    } else {
      return 'Last active ' + Jiffy.parseFromDateTime(date).format(pattern: DateFormatConstants.dateOnlyFormat);
    }
  }
}
