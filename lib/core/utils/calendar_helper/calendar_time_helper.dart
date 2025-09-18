
import 'package:get/get.dart';
import 'package:jobprogress/common/extensions/date_time/index.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';

class CalendarTimeHelper {

  static String getTimeString({
    required bool isAllDay,
    required String startDateTime,
    required String endDateTime,
  }) {
    if(isAllDay) {
      return '${'all_day_on'.tr} ${DateTimeHelper.convertHyphenIntoSlash(DateTimeHelper.formatDate(startDateTime, DateFormatConstants.dateServerFormat).substring(0, 10).toString())}';
    }

    final formattedStartDate = DateTime.parse(startDateTime);
    final formattedEndDate = DateTime.parse(endDateTime);

    if(formattedEndDate.difference(formattedStartDate).inDays == 0) {
      return "${DateTimeHelper.formatDate(startDateTime.toString(), DateFormatConstants.timeOnlyFormat)} - ${DateTimeHelper.formatDate(endDateTime.toString(), DateFormatConstants.timeOnlyFormat)}" ;
    } else {
      return "${DateTimeHelper.formatDate(startDateTime.toString(), DateFormatConstants.dateMonthLetterFormat)}"
          " - ${DateTimeHelper.formatDate(endDateTime.toString(), DateFormatConstants.dateMonthLetterFormat)}" ;
    }
  }

  static String dateToDayLabel(DateTime dateTime) {

    if(dateTime.isToday()) {
      return 'today'.tr;
    } else if(dateTime.isTomorrow()) {
      return 'tomorrow'.tr;
    } else if(dateTime.isYesterday()) {
      return 'yesterday'.tr;
    } else {
      return '';
    }

  }

}