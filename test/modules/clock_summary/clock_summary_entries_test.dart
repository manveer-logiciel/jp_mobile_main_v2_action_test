import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/clock_summary/clock_summary_entry.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';

void main() {
  CompanySettingsService.setCompanySettings([{
    "id": 10795,
    "key": "TIME_ZONE",
    "name": "Time Zone",
    "value": "Asia/Kolkata"
  }]);

  setUpAll(() {
    DateTimeHelper.setUpTimeZone();
  });

  group('ClockSummaryEntry@getDate should return correct date ', () {

    test('Should return date if start and end dates are same', () {
      final entry = ClockSummaryEntry(
        startDateTime: "2018-01-18 11:08:57",
        endDateTime: "2018-01-18 11:09:57",
      );

      expect(entry.getDate(), "01/18/2018");
    });

    test('Should return date range if start and end dates differ', () {
      final entry = ClockSummaryEntry(
        startDateTime: "2018-01-18 11:08:57",
        endDateTime: "2018-01-19 11:09:57",
      );

      expect(entry.getDate(), "01/18/2018 - 01/19/2018");
    });

   
  });
   test('ClockSummaryEntry@getTime should return correct time format', () {
      final entry = ClockSummaryEntry(
        startDateTime: "2018-01-18 11:08:57",
        endDateTime: "2018-01-19 11:09:57",
      );

      expect(entry.getTime(), "(04:38 PM - 04:39 PM)");
    });
}
