
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/clock_summary/clock_summary_time_log_details.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/services/clock_in_clock_out.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/modules/clock_in_clock_out/controller.dart';

void main() {

  final controller = ClockInClockOutController();
  final job = JobModel(id: 1, customerId: 1);
  final checkInDetails = ClockSummaryTimeLogDetails(
    startDateTime: DateTimeHelper.now().toString()
  );

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
  });

  test("ClockInClockOutController should be initialized with default values", () {
    expect(controller.isSwitchingJob, false);
    expect(controller.updatingCheckInStatus, false);
    expect(controller.updatingCheckOutStatus, false);
    expect(controller.forClockOut, false);
    expect(controller.fileImage, null);
    expect(controller.address, null);
    expect(controller.duration, null);
    expect(controller.position, null);
    expect(controller.selectedJob, null);
    expect(controller.notesController.text, "");
  });

  test('ClockInClockOutController@updateImagePath should update displaying image path to image taken from camera path', () {
    const String path = 'C:/JPTestDir/JPTestFile';
    controller.updateImagePath(path);
    expect(controller.fileImage, path);
  });

  group('ClockInClockOutController@selectOrSwitchJob should update selected job', () {

    test('When user checked-in without job', () {
      controller.selectOrSwitchJob(false, null);
      expect(controller.selectedJob, null);
    });

    test('When user checked-in with job', () {
      controller.selectOrSwitchJob(false, job);
      expect(controller.selectedJob, job);
    });

  });

  test('ClockInClockOutController@updateEntryTime should update number of logged hours', () {
    controller.updateEntryTime();
    expect(controller.entryTime.hour, DateTimeHelper.now().hour);
  });

  group('ClockInClockOutController@toggleUpdatingCheckInStatus should toggle check-in status', () {

    test('When user is not switching job', () {
      controller.toggleUpdatingCheckInStatus();
      expect(controller.updatingCheckInStatus, true);
    });

    test('When user is switching job', () {
      controller.toggleIsSwitchingJob();
      controller.toggleUpdatingCheckInStatus();
      expect(controller.updatingCheckInStatus, true);
    });

  });

  group('ClockInClockOutController@toggleUpdatingCheckOutStatus should toggle check-out status', () {

    test('When user is not switching job', () {
      controller.toggleUpdatingCheckOutStatus();
      expect(controller.updatingCheckOutStatus, false);
    });

    test('When user is switching job', () {
      controller.toggleIsSwitchingJob();
      controller.toggleUpdatingCheckOutStatus();
      expect(controller.updatingCheckOutStatus, true);
    });

  });

  test('ClockInClockOutController@toggleIsSwitchingJob should updates job switching state', () {
    controller.toggleIsSwitchingJob();
    expect(controller.isSwitchingJob, true);

    controller.toggleIsSwitchingJob();
    expect(controller.isSwitchingJob, false);
  });

  test('ClockInClockOutController@resetTimer should reset duration and cancel timer', () {
    controller.resetTimer();
    expect(controller.duration, null);
  });

  test('ClockInClockOutController@initCheckIn should set up local timer and floating clock', () {
    ClockInClockOutService.checkInDetails = checkInDetails;
    controller.initCheckIn();
    expect(controller.notesController.text, "");
    expect(controller.timeLogDetails, checkInDetails);
    expect(controller.forClockOut, true);
  });

  group('ClockInClockOutController@setUpDuration should set duration of job in progress', () {

    test('When user is not checked in', () {
      controller.resetTimer();
      expect(controller.duration, null);
    });

    group('When user is checked In', () {

      test('When user just checked-in', () {
        controller.forClockOut = true;
        controller.setUpDuration();
        expect(controller.duration, DateTimeHelper.getDuration(checkInDetails.startDateTime!));
      });

      test('When difference is of 5 minutes', () {
        checkInDetails.startDateTime = DateTimeHelper
            .now().subtract(const Duration(minutes: 5)).toString();
        controller.setUpDuration();
        expect(controller.duration, '00:05');
      });

      test('When difference is of 15 minutes', () {
        checkInDetails.startDateTime = DateTimeHelper
            .now().subtract(const Duration(minutes: 15)).toString();
        controller.setUpDuration();
        expect(controller.duration, '00:15');
      });

      test('When difference is of 1 hour', () {
        checkInDetails.startDateTime = DateTimeHelper
            .now().subtract(const Duration(hours: 1)).toString();
        controller.setUpDuration();
        expect(controller.duration, '01:00');
      });

      test('When difference is of 10 hours', () {
        checkInDetails.startDateTime = DateTimeHelper
            .now().subtract(const Duration(hours: 10)).toString();
        controller.setUpDuration();
        expect(controller.duration, '10:00');
      });

    });

  });

  group('ClockInClockOutController@disposeCheckIn should vanish all the check-in details and hide floating clock', () {

    test('When user is switching job', () {
      controller.isSwitchingJob = true;
      controller.disposeCheckIn();
      expect(controller.forClockOut, true);
      expect(controller.selectedJob, job);
      expect(controller.notesController.text, '');
    });


    test('When user is not switching job', () {
      controller.isSwitchingJob = false;
      controller.disposeCheckIn();
      expect(controller.forClockOut, false);
      expect(controller.selectedJob, null);
      expect(controller.duration, null);
      expect(controller.notesController.text, '');
    });

  });

  group('ClockInClockOutController@setAutoNote should set default check-in/check-out text', () {

    test('While check out', () {
      controller.setAutoNote(forCheckOut: true);
      expect(controller.notesController.text, 'auto_clocked_out'.tr);
    });

    test('While check in', () {
      controller.setAutoNote(forCheckOut: false);
      expect(controller.notesController.text, 'auto_clocked_in'.tr);
    });
  });

}