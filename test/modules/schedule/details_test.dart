import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/modules/schedule/details/controller.dart';

void main() {
  final controller = ScheduleDetailController();

  test("Schedule details should be constructed with default values", () {
    expect(controller.schedulesDetails, isNull);
    expect(controller.id, '');
    expect(controller.isDeleting, false);
    expect(controller.scheduleLoading, false);
    expect(controller.showNotification, false);
  });

  test('Schedule details@scheduleDetailParams should return default params', () {
    dynamic scheduleDetailParamValues = [
      '',
      'trades',
      ' work_types',
      'reps',
      'sub_contractors',
      'work_crew_notes',
      'work_orders',
      'material_lists',
      'reminders',
      'created_by',
      'attachments',
      'customer.phones'
    ];

    expect(controller.scheduleDetailParams().values, scheduleDetailParamValues);
  });

  test('ScheduleDetails@markCompleteParam should set values when action is accept', () {
    dynamic scheduleDetailMarkCompleteParamValues = [
      1,
      0,
      'reps',
      'labours',
      'sub_contractors',
      'trades',
      'work_types'
    ];

    expect(controller.markCompleteParam('accept').values,
        scheduleDetailMarkCompleteParamValues);
  });

  test('ScheduleDetails@markCompleteParam should set values when action is decline', () {
    dynamic scheduleDetailMarkCompleteParamValues = [
      0,
      0,
      'reps',
      'labours',
      'sub_contractors',
      'trades',
      'work_types'
    ];
    expect(controller.markCompleteParam('decline').values,
        scheduleDetailMarkCompleteParamValues);
  });

  test('ScheduleDetails@markCompleteParam should set values when action is decline', () {
    dynamic scheduleDetailMarkCompleteParamValues = [
      0,
      0,
      'reps',
      'labours',
      'sub_contractors',
      'trades',
      'work_types'
    ];
    expect(controller.markCompleteParam('decline').values,
        scheduleDetailMarkCompleteParamValues);
  });

  test('ScheduleDetails@actionParam should set values when action is not deleteJobSchedule', () {
    dynamic scheduleDetailDeleteJobScheduleParamValues = [
      1,
    ];

    expect(controller.actionParam('markAction').values,
        scheduleDetailDeleteJobScheduleParamValues);
  });

  test('ScheduleDetails@actionParam should set values when action is deleteJobSchedule', () {
    dynamic scheduleActionsParamValues = [
      0,
    ];
    expect(controller.actionParam('deleteJobSchedule').values,
        scheduleActionsParamValues);
  });
}
