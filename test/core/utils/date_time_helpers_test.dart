import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';

void main(){
  String dateValue = '2018-01-18 11:08:57';
  String formatDate = 'yyyy-MM-dd';

  CompanySettingsService.setCompanySettings([{
    "id": 10795,
    "key": "TIME_ZONE",
    "name": "Time Zone",
    "value": "Asia/Kolkata"
  }]);

  setUpAll(() {
    DateTimeHelper.setUpTimeZone();
  });

  test("DateTimeHelper should changed given value into date and time", (){
    final convertedDate = DateTimeHelper.formatDate(dateValue, DateFormatConstants.dateTimeFormatWithoutSeconds);
    expect(convertedDate, '01/18/2018 04:38 PM');
  });

  test("DateTimeHelper should changed given value into full date", (){
    final convertedDate = DateTimeHelper.formatDate(dateValue, DateFormatConstants.dateFullFormat);
    expect(convertedDate, 'Thursday January 18th, 2018');
  });

  test("DateTimeHelper should changed given value into date", (){
    final convertedDate = DateTimeHelper.formatDate(dateValue, DateFormatConstants.dateOnlyFormat);
    expect(convertedDate, '01/18/2018');
  });

   test("DateTimeHelper should changed given value into server date format", (){
    final convertedDate = DateTimeHelper.formatDate(dateValue, DateFormatConstants.dateServerFormat);
    expect(convertedDate, '2018-01-18');
  });

   test("DateTimeHelper should changed given value into date and time", (){
    final convertedDate = DateTimeHelper.formatDate(dateValue, DateFormatConstants.dateTimeFormatWithSeconds);
    expect(convertedDate, '01/18/2018 4:38:57 PM');
  });

  test("DateTimeHelper should changed given value into only date", (){
    final convertedDate = DateTimeHelper.formatDate(dateValue, DateFormatConstants.dateOnlyFormat);
    expect(convertedDate, '01/18/2018');
  });

  test("DateTimeHelper should be found time ago", (){
    final dateValue = DateTime.now().add(const Duration(days: -366));
    final convertedDate = DateTimeHelper.formatDate(dateValue.toString(), 'am_time_ago');

    expect(convertedDate, 'a year ago');

    // final dateValue = DateTime.now().add(const Duration(days: 0, hours:0, minutes: -60 * 4));
    // final convertedDate2 = DateTimeHelper.formatDate(dateValue.toString(), 'am_time_ago');
    // expect(convertedDate2, 'in a hours');
  });
  
  test("DateTimeHelper should be converted hyphen into slash", (){
    final convertedDate = DateTimeHelper.convertHyphenIntoSlash('11-12-2022');
    expect(convertedDate, '12/2022/11');
  });

  group("DateTimeHelper should convert date time to duration format '00:00'", (){

    test('When difference is of 5 minutes', () {
      final convertedDate = DateTimeHelper
          .getDuration(DateTimeHelper
          .now().subtract(const Duration(minutes: 5)).toString());
      expect(convertedDate, '00:05');
    });

    test('When difference is of 15 minutes', () {
      final convertedDate = DateTimeHelper
          .getDuration(DateTimeHelper
          .now().subtract(const Duration(minutes: 15)).toString());
      expect(convertedDate, '00:15');
    });

    test('When difference is of 1 hour', () {
      final convertedDate = DateTimeHelper
          .getDuration(DateTimeHelper
          .now().subtract(const Duration(hours: 1)).toString());
      expect(convertedDate, '01:00');
    });

    test('When difference is of 10 hours', () {
      final convertedDate = DateTimeHelper
          .getDuration(DateTimeHelper
          .now().subtract(const Duration(hours: 10)).toString());
      expect(convertedDate, '10:00');
    });

  });

  group('DateTimeHelper@getLabelAccordingToDate should return correct label', () { 
    test('for today date', () {
      final date = DateTimeHelper.now();
      final label = DateTimeHelper.getLabelAccordingToDate(date.toString());

      expect(label, 'TODAY');
    });

    test('for yesterday date', () {
      final date = DateTimeHelper.now().subtract(const Duration(days: 1));
      final label = DateTimeHelper.getLabelAccordingToDate(date.toString());

      expect(label, 'YESTERDAY');
    });

    test('for date before yesterday', () {
      final date = DateTimeHelper.now().subtract(const Duration(days: 2));
      final label = DateTimeHelper.getLabelAccordingToDate(date.toString());

      expect(label, 'OLDER');
    });

  });

  group('DateTimeHelper@isFutureDate should check', () {
    test('When the date is tomorrow\'s date', () {
      // Generate a date string for tomorrow
      String futureDate = DateTimeHelper.formatDate(DateTime.now()
          .add(const Duration(days: 1)).toString(), formatDate);
      // Check if the function identifies it as a future date
      expect(DateTimeHelper.isFutureDate(futureDate, formatDate), isTrue);
    });

    test('When the date is today\'s date', () {
      // Generate a date string for today
      String todayDate = DateTimeHelper.formatDate(DateTime.now().toString(), formatDate);
      // Check if the function identifies it as not a future date
      expect(DateTimeHelper.isFutureDate(todayDate, formatDate), isFalse);
    });

    test('When the date is yesterday\'s date', () {
      // Generate a date string for yesterday
      String pastDate = DateTimeHelper.formatDate(DateTime.now()
          .subtract(const Duration(days: 1)).toString(), formatDate);
      // Check if the function identifies it as not a future date
      expect(DateTimeHelper.isFutureDate(pastDate, formatDate), isFalse);
    });

    test('When the date is future date', () {
      // Generate a date string for tomorrow using a different format
      String futureDate = DateTimeHelper.formatDate(DateTime.now()
          .add(const Duration(days: 2)).toString(), formatDate);
      // Check if the function identifies it as a future date using the specified format
      expect(DateTimeHelper.isFutureDate(futureDate, formatDate), isTrue);
    });
  });

  test("DateTimeHelper@isZeroDate should correctly identify zero dates", () {
    expect(DateTimeHelper.isZeroDate("0000-00-00"), isTrue);
    expect(DateTimeHelper.isZeroDate("0000-01-01"), isFalse);
    expect(DateTimeHelper.isZeroDate("2023-10-10"), isFalse);
    expect(DateTimeHelper.isZeroDate(null), isFalse);
    expect(DateTimeHelper.isZeroDate(""), isFalse);
  });
  
}