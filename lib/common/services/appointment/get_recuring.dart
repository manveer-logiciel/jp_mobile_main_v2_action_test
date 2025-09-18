import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import '../../../core/constants/regex_expression.dart';

class RecurringService {
    static getOccurrence(String occurrence, String endOnDate) {
      if (occurrence == "never_end" || occurrence == "job_end_stage_code") {
        return "";
      }

      if (occurrence == "until_date" && endOnDate.isNotEmpty) {
        return ", until ${DateTimeHelper.formatDate(endOnDate, DateFormatConstants.dateMonthOnlyDateLetterFormat)}";
      }

      if (occurrence != "never_end"  && occurrence != "until_date") {
        return ", $occurrence times";
      }
    }

  static String getDays(List<String> dayCodes) {
    if (dayCodes.isEmpty) {
      return "";
    }
     final days = dayCodes.map((code) => getDayName(code)).toList();
     return days.join(", ");
  }

  static getDayName(String code) {
    String day = '';
    switch (code) {
      case "SU":
        day = "Sunday";
        break;
      case "MO":
        day = "Monday";
        break;
      case "TU":
        day = "Tuesday";
        break;
      case "WE":
        day = "Wednesday";
        break;
      case "TH":
        day = "Thursday";
        break;
      case "FR":
        day = "Friday";
        break;
      case "SA":
        day = "Saturday";
        break;
    }

    return day;
  }

  static String getMonthlyRepeatOption(List<String>? data) {
      final ordinals = ["", "first", "second", "third", "fourth", "last"];

      final numMatches = RegExp(RegexExpression.caseSensitiveCharacters).firstMatch(data?.isNotEmpty ?? false ? data![0] : "");
      var num = numMatches == null ? 5 : int.parse(numMatches.group(0) ?? '5');

      final sNameMatches = RegExp(RegexExpression.caseSensitive).firstMatch(data?.isNotEmpty ?? false ? data![0] : "");
      final sName = sNameMatches?.group(0) ?? '';
      final dayName = getDays([sName]);

      return "${ordinals[num]} $dayName";
    }

  static String getOccurrenceCondition(dynamic appointment){
    return getOccurrence(
              appointment.occurrence!,
              appointment.endDateTime.toString());
  }

  static String getOnCondition(dynamic appointment) {
      return getOccurrence(
                'until_date',
                appointment.untilDate.toString());
  }

  static  getRecOption(dynamic appointment) {
    if (appointment.interval == null || appointment.interval == 1) {
      if (appointment.repeat == "weekly") {
        if (appointment.byDay != null && appointment.byDay!.length > 6) {
            if(appointment.occurrence != null){
              return ("Weekly on all days${getOccurrenceCondition(appointment)}");
            } if(appointment.untilDate != null){
              return ("Weekly on all days${getOnCondition(appointment)}");
            } else {
              return "Weekly on all days" ;
            }
        } else {
            if(appointment.occurrence != null){
              return "Weekly on ${getDays(appointment.byDay)}${getOccurrenceCondition(appointment)}";
            } if(appointment.untilDate != null){
              return "Weekly on ${getDays(appointment.byDay)}${getOnCondition(appointment)}";
            } else {
              return "Weekly on ${getDays(appointment.byDay)}";
            }
        }
      }

      if (appointment.repeat == "daily") {
        if(appointment.occurrence != null){
          return 'Daily${getOccurrenceCondition(appointment)}';
        } if(appointment.untilDate != null){
          return 'Daily${getOnCondition(appointment)}';
        } else {
          return "Daily";
        }
      }

      if (appointment.repeat == "monthly") {
        if (appointment.byDay != null && appointment.byDay!.isNotEmpty) {
          if(appointment.occurrence != null){
            return "Monthly on ${getMonthlyRepeatOption(appointment.byDay)}${getOccurrenceCondition(appointment)}";
          } if(appointment.untilDate != null){
            return "Monthly on ${getMonthlyRepeatOption(appointment.byDay)}${getOnCondition(appointment)}";
          } else {
            return "Monthly on ${getMonthlyRepeatOption(appointment.byDay)}" ;
          }
        }

        if(appointment.occurrence != null){
          return  "Monthly on day ${DateTimeHelper.formatDate(appointment.startDateTime.toString(), DateFormatConstants.date)}${getOccurrenceCondition(appointment)}";
        } if(appointment.untilDate != null){
          return  "Monthly on day ${DateTimeHelper.formatDate(appointment.startDateTime.toString(), DateFormatConstants.date)}${getOnCondition(appointment)}";
        } else {
          return "Monthly on day ${DateTimeHelper.format(appointment.startDateTime, DateFormatConstants.date)}";
        }
      }

      if (appointment.repeat == "yearly") {
        if(appointment.occurrence != null){
          return ("Annually on ${DateTimeHelper.formatDate(appointment.startDateTime.toString(), DateFormatConstants.dateMonthLetterFormat2)}${getOccurrenceCondition(appointment)}");
        } if(appointment.untilDate != null){
          return ("Annually on ${DateTimeHelper.formatDate(appointment.startDateTime.toString(), DateFormatConstants.dateMonthLetterFormat2)}${getOnCondition(appointment)}");
        } else {
          return "Annually on ${DateTimeHelper.formatDate(appointment.startDateTime.toString(), DateFormatConstants.dateMonthLetterFormat2)}";
        }
      }
    }

    if (appointment.interval != null && appointment.interval! > 1) {
      if (appointment.repeat == "weekly") {
        if(appointment.occurrence != null){
          return ( "Every ${appointment.interval} Weeks on ${getDays(appointment.byDay)}${getOccurrenceCondition(appointment)}");
        } if(appointment.untilDate != null){
          return ("Every ${appointment.interval} Weeks on ${getDays(appointment.byDay)}${getOnCondition(appointment)}");
        } else {
          return "Every ${appointment.interval} Weeks on ${getDays(appointment.byDay)}" ;
        }
      }

      if (appointment.repeat == "daily") {
        if(appointment.occurrence != null){
          return ("Every ${appointment.interval} days${getOccurrenceCondition(appointment)}");
        } if(appointment.untilDate != null){
          return "Every ${appointment.interval} days${getOnCondition(appointment)}";
        } else {
          return "Every ${appointment.interval} days";
        }
        
      }

      if (appointment.repeat == "monthly") {
        if (appointment.byDay != null && appointment.byDay!.isNotEmpty) {
          if(appointment.occurrence != null){
            return "Every ${appointment.interval} Months on the ${getMonthlyRepeatOption(appointment.byDay)}${getOccurrenceCondition(appointment)}";
          } if(appointment.untilDate != null){
            return "Every ${appointment.interval} Months on the ${getMonthlyRepeatOption(appointment.byDay)}${getOnCondition(appointment)}";
          } else {
            return "Every ${appointment.interval} Months on the ${getMonthlyRepeatOption(appointment.byDay)}";
          }
        }

        if(appointment.occurrence != null){
          return  "Every ${appointment.interval} Months on day ${DateTimeHelper.formatDate(appointment.startDateTime.toString(), DateFormatConstants.date)}${getOccurrenceCondition(appointment)}";
        } if(appointment.untilDate != null){
          return "Every ${appointment.interval} Months on day ${DateTimeHelper.formatDate(appointment.startDateTime.toString(), DateFormatConstants.date)}${getOnCondition(appointment)}";
        } else {
          return "Every ${appointment.interval} Months on day ${DateTimeHelper.formatDate(appointment.startDateTime.toString(), DateFormatConstants.date)}";
        }
      }

      if (appointment.repeat == "yearly") {
        if(appointment.occurrence != null){
          return "Every ${appointment.interval} Years on ${DateTimeHelper.formatDate(appointment.startDateTime.toString(), DateFormatConstants.dateMonthLetterFormat2)}${getOccurrenceCondition(appointment)}";
        } if(appointment.untilDate != null){
          return "Every ${appointment.interval} Years on ${DateTimeHelper.formatDate(appointment.startDateTime.toString(), DateFormatConstants.dateMonthLetterFormat2)}${getOnCondition(appointment)}";
        } else {
          return "Every ${appointment.interval} Years on ${DateTimeHelper.formatDate(appointment.startDateTime.toString(), DateFormatConstants.dateMonthLetterFormat2)}";
        }
      }
    }
  }
}