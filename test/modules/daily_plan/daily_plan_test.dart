import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/common/models/schedules/schedules.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/modules/daily_plan/controller.dart';

void main() {
  final controller = DailyPlanController();
  List<AppointmentModel> appointmentList = [];
  List<TaskListModel> taskList = [];
  List<SchedulesModel> schedulesList = [];
  test("DailyPlanController should be initilize with default values", () {
    expect(controller.appointmentList, appointmentList);
    expect(controller.taskList, taskList);
    expect(controller.schedulesList, schedulesList);
    expect(controller.isLoading, true);
    expect(controller.isDeleting, false);
    expect(controller.currentDate, '');
  });

  test('DailyPlanController@appointmentsPlanParams should return correct params values', () {
    Map<String, dynamic> testData = <String, dynamic>{
      'duration': 'today',
      'for': 'current',
      'includes[0]': 'customer',
      'includes[1]': 'jobs',
      'includes[2]': 'attendees',
      'includes[3]': 'created_by',
      'includes[4]': 'reminders',
      'includes[5]': 'attachments',
      'limit': 0,
      'sort_by': 'start_date_time',
      'sort_order': 'asc',
    };
    Map<String, dynamic> test = controller.appointmentsPlanParams();
    expect(test, testData);
  });

  test('DailyPlanController@tasksPlanParams should return correct params values', () {
    Map<String, dynamic> testData = <String, dynamic>{
      'duration': ['today'],
      'includes[0]': ['created_by'],
      'includes[1]': ['job'],
      'includes[2]': ['customer'],
      'includes[3]': ['participants'],
      'includes[4]': ['attachments'],
      'includes[5]': ['stage'],
      'limit': 0,
      'status': ['pending'],
      'type': ['assigned'],
    };
    Map<String, dynamic> test = controller.tasksPlanParams();
    expect(test, testData);
  });

  test('DailyPlanController@schedulesPlanParams should return correct params values', () {
    Map<String, dynamic> testData = <String, dynamic>{
      'date': DateTimeHelper.format(DateTime.now().toString(), DateFormatConstants.dateServerFormat),
      'limit': 0,
      'includes[0]': 'trades',
      'includes[1]': 'attachments_count',
      'includes[2]': 'job.address',
      'job_rep_ids[0]': controller.id,
      'includes[3]': ' work_types',
      'includes[4]': 'reps',
      'includes[5]': 'sub_contractors',
      'includes[6]': 'job_estimators',
    };
    Map<String, dynamic> test = controller.schedulesPlanParams();
    expect(test, testData);
  });

  test('DailyPlanController@getCurrentDate should return date in server format', () {
    String date = DateTimeHelper.format(DateTime.now().toString(), DateFormatConstants.dateServerFormat);
    expect(controller.getCurrentDate(), date);
  });
}
