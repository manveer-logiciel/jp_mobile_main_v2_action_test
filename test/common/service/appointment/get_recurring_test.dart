import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/job/recurring_email.dart';
import 'package:jobprogress/common/services/appointment/get_recuring.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  RecurringEmailModel recurringEmail = RecurringEmailModel(
    byDay : ["MO", "TU"],
    occurrence : "until_date",
    startDateTime : "2018-01-18 11:08:57",
    endDateTime : "2018-01-18 11:08:57",
  );

  setUpAll(() {
    DateTimeHelper.setUpTimeZone();
  });

  group("RecurringService@getOccurrence() should return correct data", () {
    test('Should returns an empty string if occurrence is "never_end" and end date is empty', () {
      expect(RecurringService.getOccurrence("never_end", ""), "");
    });

    test('Should returns an empty string if occurrence is "never_end" and end date is not empty', () {
      expect(RecurringService.getOccurrence("never_end", "2018-01-18 11:08:57"), "");
    });

    test('Should returns an empty string if occurrence is "job_end_stage_code" and end date is empty', () {
      expect(RecurringService.getOccurrence("job_end_stage_code", ""), "");
    });

    test('Should returns an empty string if occurrence is "job_end_stage_code" and end date is not empty', () {
      expect(RecurringService.getOccurrence("job_end_stage_code", "2018-01-18 11:08:57"), "");
    });

    test('Should returns the formatted date string if occurrence is "until_date" and end date is not empty', () {
      expect(RecurringService.getOccurrence("until_date", "2018-01-18 11:08:57"), ", until Jan 18, 2018");
    });

    test('Should returns the occurrence followed by "times" if occurrence is not "never_end" or "until_date" and end date is empty', () {
      expect(RecurringService.getOccurrence("3", ""), ", 3 times");
    });

    test('Should returns the occurrence followed by "times" if occurrence is not "never_end" or "until_date" and end date is not empty', () {
      expect(RecurringService.getOccurrence("3", "2018-01-18 11:08:57"), ", 3 times");
    });
  });

  group("RecurringService@getDays() should return correct data", () {
    test('Should returns an empty string if the list of days name is empty', () {
      expect(RecurringService.getDays([]), "");
    });

    test('Should returns the comma-separated list of days name for non-empty', () {
      expect(RecurringService.getDays(["SU", "MO", "TU"]), "Sunday, Monday, Tuesday");
    });
  });

  group("RecurringService@getMonthlyRepeatOption() should return correct data", () {
    group("Should return correct data when data is available", () {
      test('Should returns repeat occurrence monthly on first Sunday when repeat option is 1SU', () {
        expect(RecurringService.getMonthlyRepeatOption(["1SU"]), "first Sunday");
      });

      test('Should returns repeat occurrence monthly on third monday when repeat option is 3MO', () {
        expect(RecurringService.getMonthlyRepeatOption(["3MO"]), "third Monday");
      });

      test('Should returns repeat occurrence monthly on last Wednesday when repeat option is 5WE', () {
        expect(RecurringService.getMonthlyRepeatOption(["5WE"]), "last Wednesday");
      });
    });

    group("Should return correct data when data is not available", () {
      test('Should returns the default monthly repeat option if data is null', () {
        expect(RecurringService.getMonthlyRepeatOption(null), "last ");
      });
      test('Should returns the default monthly repeat option if data is empty', () {
        expect(RecurringService.getMonthlyRepeatOption([]), "last ");
      });
    });
  });

  group("RecurringService@getRecOption() should return correct data", () {
    group('When repeat occurrence is daily', () {
      setUpAll(() => recurringEmail.repeat = "daily");

      group('When repeat interval is equals to 1', () {
        setUpAll(() => recurringEmail.interval = 1);

        test('Should return daily with number of occurrence when occurrence is equals to 1', () {
          recurringEmail.occurrence = "1";
          expect(RecurringService.getRecOption(recurringEmail), "Daily, 1 times");
        });

        test('Should return daily with number of occurrence when occurrence is greater then 1 (eg: 5)', () {
          recurringEmail.occurrence = "5";
          expect(RecurringService.getRecOption(recurringEmail), "Daily, 5 times");
        });

        test('Should return daily when occurrence is never end', () {
          recurringEmail.occurrence = "never_end";
          expect(RecurringService.getRecOption(recurringEmail), "Daily");
        });

        test('Should return daily until date when occurrence is not available and until date is available', () {
          recurringEmail.occurrence = null;
          recurringEmail.untilDate = "2018-01-18 11:08:57";
          expect(RecurringService.getRecOption(recurringEmail), "Daily, until Jan 18, 2018");
        });

        test('Should return daily when both occurrence and until date is not available', () {
          recurringEmail.occurrence = null;
          recurringEmail.untilDate = null;
          expect(RecurringService.getRecOption(recurringEmail), "Daily");
        });
      });

      group('When repeat interval is greater then 1 (eg: 5)', () {
        setUpAll(() => recurringEmail.interval = 5);

        test('Should return every interval for number of occurrence when occurrence is equals to 1', () {
          recurringEmail.occurrence = "1";
          expect(RecurringService.getRecOption(recurringEmail), "Every 5 days, 1 times");
        });

        test('Should return every interval for number of occurrence when occurrence is greater then 1 (eg: 5)', () {
          recurringEmail.occurrence = "5";
          expect(RecurringService.getRecOption(recurringEmail), "Every 5 days, 5 times");
        });

        test('Should return every interval when occurrence is never end', () {
          recurringEmail.occurrence = "never_end";
          expect(RecurringService.getRecOption(recurringEmail), "Every 5 days");
        });

        test('Should return every interval until date when occurrence is not available and until date is available', () {
          recurringEmail.occurrence = null;
          recurringEmail.untilDate = "2018-01-18 11:08:57";
          expect(RecurringService.getRecOption(recurringEmail), "Every 5 days, until Jan 18, 2018");
        });

        test('Should return every interval when both occurrence and until date is not available', () {
          recurringEmail.occurrence = null;
          recurringEmail.untilDate = null;
          expect(RecurringService.getRecOption(recurringEmail), "Every 5 days");
        });
      });
    });

    group('When repeat occurrence is weekly', () {
      setUpAll(() => recurringEmail.repeat = "weekly");

      group('When repeat interval is equals to 1', () {
        setUpAll(() => recurringEmail.interval = 1);
        group('When number of repeat days is more than 6 days', () {
          setUpAll(() => recurringEmail.byDay = ["SU", "MO", "TU", "WE", "TH", "FR", "SA"]);

          test('Should returns weekly on all days with number of occurrence when occurrence is not null', () {
            recurringEmail.occurrence = "5";
            expect(RecurringService.getRecOption(recurringEmail), "Weekly on all days, 5 times");
          });

          test('Should returns weekly on all days when occurrence is never end', () {
            recurringEmail.occurrence = "never_end";
            expect(RecurringService.getRecOption(recurringEmail), "Weekly on all days");
          });

          test('Should returns weekly on all days until date when occurrence is not available and until date is available', () {
            recurringEmail.occurrence = null;
            recurringEmail.untilDate = "2018-01-18 11:08:57";
            expect(RecurringService.getRecOption(recurringEmail), "Weekly on all days, until Jan 18, 2018");
          });

          test('Should returns weekly on all days when both occurrence and until date is not available', () {
            recurringEmail.occurrence = null;
            recurringEmail.untilDate = null;
            expect(RecurringService.getRecOption(recurringEmail), "Weekly on all days");
          });
        });

        group('When appointment.byDay has less than or equal to 6 days', () {
          setUpAll(() => recurringEmail.byDay = ["SU", "MO"]);

          test('Should returns weekly on days with number of occurrence when occurrence is not null', () {
            recurringEmail.occurrence = "5";
            expect(RecurringService.getRecOption(recurringEmail), "Weekly on Sunday, Monday, 5 times");
          });

          test('Should returns weekly on days when occurrence is never end', () {
            recurringEmail.occurrence = "never_end";
            expect(RecurringService.getRecOption(recurringEmail), "Weekly on Sunday, Monday");
          });

          test('Should returns weekly on days until date when occurrence is not available and until date is available', () {
            recurringEmail.occurrence = null;
            recurringEmail.untilDate = "2018-01-18 11:08:57";
            expect(RecurringService.getRecOption(recurringEmail), "Weekly on Sunday, Monday, until Jan 18, 2018");
          });

          test('Should returns weekly on days when both occurrence and until date is not available', () {
            recurringEmail.occurrence = null;
            recurringEmail.untilDate = null;
            expect(RecurringService.getRecOption(recurringEmail), "Weekly on Sunday, Monday");
          });
        });
      });

      group('When repeat is greater then 1 (eg: 5)', () {
        setUpAll(() => recurringEmail.interval = 5);
        group('When number of repeat days is more than 6 days', () {
          setUpAll(() => recurringEmail.byDay = ["SU", "MO", "TU", "WE", "TH", "FR", "SA"]);

          test('Should returns every week on all days with number of occurrence when occurrence is not null', () {
            recurringEmail.occurrence = "5";
            expect(RecurringService.getRecOption(recurringEmail), "Every 5 Weeks on Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, 5 times");
          });

          test('Should returns every week on all days when occurrence is never end', () {
            recurringEmail.occurrence = "never_end";
            expect(RecurringService.getRecOption(recurringEmail), "Every 5 Weeks on Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday");
          });

          test('Should returns every week on all days until date when occurrence is not available and until date is available', () {
            recurringEmail.occurrence = null;
            recurringEmail.untilDate = "2018-01-18 11:08:57";
            expect(RecurringService.getRecOption(recurringEmail), "Every 5 Weeks on Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, until Jan 18, 2018");
          });

          test('Should returns every week on all days when both occurrence and until date is not available', () {
            recurringEmail.occurrence = null;
            recurringEmail.untilDate = null;
            expect(RecurringService.getRecOption(recurringEmail), "Every 5 Weeks on Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday");
          });
        });

        group('When appointment.byDay has less than or equal to 6 days', () {
          setUpAll(() => recurringEmail.byDay = ["SU", "MO"]);

          test('Should returns every week on days with number of occurrence when occurrence is not null', () {
            recurringEmail.occurrence = "5";
            expect(RecurringService.getRecOption(recurringEmail), "Every 5 Weeks on Sunday, Monday, 5 times");
          });

          test('Should returns every week on days when occurrence is never end', () {
            recurringEmail.occurrence = "never_end";
            expect(RecurringService.getRecOption(recurringEmail), "Every 5 Weeks on Sunday, Monday");
          });

          test('Should returns every week on days until date when occurrence is not available and until date is available', () {
            recurringEmail.occurrence = null;
            recurringEmail.untilDate = "2018-01-18 11:08:57";
            expect(RecurringService.getRecOption(recurringEmail), "Every 5 Weeks on Sunday, Monday, until Jan 18, 2018");
          });

          test('Should returns every week on days when both occurrence and until date is not available', () {
            recurringEmail.occurrence = null;
            recurringEmail.untilDate = null;
            expect(RecurringService.getRecOption(recurringEmail), "Every 5 Weeks on Sunday, Monday");
          });
        });
      });
    });

    group('When repeat occurrence is monthly', () {
      setUpAll(() => recurringEmail.repeat = "monthly");
      group('When repeat interval is equals to 1', () {
        setUpAll(() {
          recurringEmail.interval = 1;
          recurringEmail.byDay = ["1MO"];
        });
        test('Should returns monthly on repeat cycle day with number of occurrence when occurrence is not null', () {
          recurringEmail.occurrence = "5";
          expect(RecurringService.getRecOption(recurringEmail), "Monthly on first Monday, 5 times");
        });

        test('Should returns monthly on repeat cycle day with number of occurrence when when occurrence is never end', () {
          recurringEmail.occurrence = "never_end";
          expect(RecurringService.getRecOption(recurringEmail), "Monthly on first Monday");
        });

        test('Should returns monthly on repeat cycle day till its end date when occurrence is not available and until date is available', () {
          recurringEmail.occurrence = null;
          recurringEmail.untilDate = "2018-01-18 11:08:57";
          expect(RecurringService.getRecOption(recurringEmail), "Monthly on first Monday, until Jan 18, 2018");
        });

        test('Should returns monthly on repeat cycle day when both occurrence and until date is not available', () {
          recurringEmail.occurrence = null;
          recurringEmail.untilDate = null;
          expect(RecurringService.getRecOption(recurringEmail), "Monthly on first Monday");
        });
      });

      group('When repeat is greater then 1 (eg: 5)', () {
        setUpAll(() {
          recurringEmail.interval = 5;
          recurringEmail.byDay = ["1MO"];
        });
        test('Should returns every monthly repeat interval with repeat cycle day and number of occurrence when occurrence is not null', () {
          recurringEmail.occurrence = "5";
          expect(RecurringService.getRecOption(recurringEmail), "Every 5 Months on the first Monday, 5 times");
        });

        test('Should returns every monthly repeat interval with repeat cycle day and number of occurrence when when occurrence is never end', () {
          recurringEmail.occurrence = "never_end";
          expect(RecurringService.getRecOption(recurringEmail), "Every 5 Months on the first Monday");
        });

        test('Should returns every monthly repeat interval with repeat cycle day till its end date when occurrence is not available and until date is available', () {
          recurringEmail.occurrence = null;
          recurringEmail.untilDate = "2018-01-18 11:08:57";
          expect(RecurringService.getRecOption(recurringEmail), "Every 5 Months on the first Monday, until Jan 18, 2018");
        });

        test('Should returns every monthly repeat interval with repeat cycle day when both occurrence and until date is not available', () {
          recurringEmail.occurrence = null;
          recurringEmail.untilDate = null;
          expect(RecurringService.getRecOption(recurringEmail), "Every 5 Months on the first Monday");
        });
      });
    });

    group('When appointment.repeat is "yearly"', () {
      setUpAll(() => recurringEmail.repeat = "yearly");
      group('When repeat interval is equals to 1', () {
        setUpAll(() => recurringEmail.interval = 1);
        test('Should returns annual repeat option with number of occurrence when occurrence is not null', () {
          recurringEmail.occurrence = "5";
          expect(RecurringService.getRecOption(recurringEmail), "Annually on January 18, 5 times");
        });

        test('Should returns annual repeat option with number of occurrence when when occurrence is never end', () {
          recurringEmail.occurrence = "never_end";
          expect(RecurringService.getRecOption(recurringEmail), "Annually on January 18");
        });

        test('Should returns annual repeat option till its end date when occurrence is not available and until date is available', () {
          recurringEmail.occurrence = null;
          recurringEmail.untilDate = "2019-01-18 11:08:57";
          expect(RecurringService.getRecOption(recurringEmail), "Annually on January 18, until Jan 18, 2019");
        });

        test('Should returns annual repeat option when both occurrence and until date is not available', () {
          recurringEmail.occurrence = null;
          recurringEmail.untilDate = null;
          expect(RecurringService.getRecOption(recurringEmail), "Annually on January 18");
        });
      });

      group('When repeat is greater then 1 (eg: 5)', () {
        setUpAll(() => recurringEmail.interval = 5);
        test('Should returns every annual repeat option with number of occurrence when occurrence is not null', () {
          recurringEmail.occurrence = "5";
          expect(RecurringService.getRecOption(recurringEmail), "Every 5 Years on January 18, 5 times");
        });

        test('Should returns every annual repeat option with number of occurrence when when occurrence is never end', () {
          recurringEmail.occurrence = "never_end";
          expect(RecurringService.getRecOption(recurringEmail), "Every 5 Years on January 18");
        });

        test('Should returns every annual repeat option till its end date when occurrence is not available and until date is available', () {
          recurringEmail.occurrence = null;
          recurringEmail.untilDate = "2019-01-18 11:08:57";
          expect(RecurringService.getRecOption(recurringEmail), "Every 5 Years on January 18, until Jan 18, 2019");
        });

        test('Should returns every annual repeat option when both occurrence and until date is not available', () {
          recurringEmail.occurrence = null;
          recurringEmail.untilDate = null;
          expect(RecurringService.getRecOption(recurringEmail), "Every 5 Years on January 18");
        });
      });
    });
  });
}