import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/recurring.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/recurring_email.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/core/constants/recurring_constant.dart';
import 'package:jobprogress/core/constants/work_flow_stage_color.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/global_widgets/recurring_bottom_sheet/controller.dart';

void main() {

  List<WorkFlowStageModel> stages = [
    WorkFlowStageModel(name: "Job 1", color: 'cl-red', code: '1234'),
    WorkFlowStageModel(name: "Job 2", color: 'cl-yellow', code: '1425'),
    WorkFlowStageModel(name: "Job 3", color: 'cl-blue', code: '1487')
  ];

  RecurringEmailModel model = RecurringEmailModel();

  JobModel job = JobModel(
      id: 1,
      customerId: 1,
      stages: stages,
      currentStage: WorkFlowStageModel(
          name: 'Job 2',
          color: 'cl-yellow',
          code: '1425'
      )
  );

  final controller = RecurringBottomSheetController(job, model,RecurringType.salesAutomation, null,null,null);
  controller.setDefaultValue();

  test('RecurringBottomSheetController should  be constructed with default values', () {
    expect(controller.showRepeatValidateMessage, false);
    expect(controller.showOccuranceValidateMessage, false);
    expect(controller.occuranceActive, false);
    expect(controller.selectedDurationValue, RecurringConstants.weekly);
    expect(controller.selectedMonthDurationValue, '1');
    expect(controller.selectedStage, job.currentStage!.code);
    expect(controller.selectedStageValue,job.currentStage!.name);
    expect(controller.selectedStageColor, WorkFlowStageConstants.colors['cl-yellow']);
    expect(controller.occuranceActive, false);
    expect(controller.recurringEmailData.byDay, [controller.getCurrentDay()]);
    expect(controller.daysOfWeekList[DateTime.now().weekday-1].isSelect, true);
  });

  group('RecurringBottomSheetController@saveData test cases', () {
    group('Test cases when default value',() {
      controller.saveData();
      test("Should return 'RecurringBottomSheetController@fullCurrentDay' in RecurringEmailModel@startDateTime", () {
        expect(model.startDateTime, controller.fullCurrentDay);
      });
      test('Should return 1 in RecurringEmailModel@interval', () {
        expect(model.interval, 1);
      });
      test('Should return weekly in RecurringEmailModel@repeat', () {
        expect(model.repeat, RecurringConstants.weekly);
      });
      test('Should return job_end_stage_code in RecurringEmailModel@occurence', () {
        expect(model.occurrence, RecurringConstants.jobEndStageCode);
      });
      test('Should return 1425(RecurringBottomSheetController@job.currentStage!.code) in RecurringEmailModel@currentStageCode', () {
        expect(model.currentStageCode, '1425');
      });
      test('Should return 1425(RecurringBottomSheetController@job.currentStage!.code) in RecurringEmailModel@endSatgeCode', () {
        expect(model.endStageCode, '1425');
      });
      test('Should return RecurringBottomSheetController@currentDay value from daysOfWeekList in RecurringEmailModel@byDay list', () {
        expect(model.byDay, [controller.daysOfWeekList.firstWhere((element) => element.id == controller.currentDay).id]);
      });
    });

    group("Test cases when data modified", () {
      test('Should return (RecurringBottomSheetController@fullCurrentDay) in RecurringEmailModel@startDateTime',() {
        expect(model.startDateTime, controller.fullCurrentDay);
      });
      test('Should return 31 in RecurringEmailModel@interval when RecurringBottomSheetController@durationCount.text is 31', () {
        controller.durationCount.text = '31';
        controller.saveData();
        expect(model.interval, 31);
      });
      test('Should return daily in RecurringEmailModel@repeat when RecurringBottomSheetController@duration.text is Days', () {
        controller.selectedDurationValue = RecurringConstants.daily;
        controller.saveData();
        expect(model.repeat, RecurringConstants.daily);
      });
      test('Should return weekly in RecurringEmailModel@repeat when RecurringBottomSheetController@duration.text is Weeks', () {
        controller.selectedDurationValue = RecurringConstants.weekly;
        controller.saveData();
        expect(model.repeat, RecurringConstants.weekly);
      });
      test('Should return monthly in RecurringEmailModel@repeat when RecurringBottomSheetController@duration.text is Months', () {
        controller.selectedDurationValue  = RecurringConstants.monthly;
        controller.saveData();
        expect(model.repeat, RecurringConstants.monthly);
      });
      test('Should return yearly in RecurringEmailModel@repeat when RecurringBottomSheetController@duration.text is Years', () {
        controller.selectedDurationValue  = RecurringConstants.yearly;
        controller.saveData();
        expect(model.repeat, RecurringConstants.yearly);
      });
      test("Should return ['(weekNo.)(currentDay)']in RecurringEmailModel@byDay when monthDuration.text is 'Month of the (currentWeek)(currentDay)'", () {
        controller.monthlyDuration.text = SingleSelectHelper.getSelectedSingleSelectValue(controller.monthDurationList, '1');
        controller.saveData();
        expect(model.byDay, [controller.weekNo.toInt().toString() + controller.daysOfWeekList.firstWhere((element) => element.id == controller.currentDay).id]);
      });
      test('Should return true in RecurringEmailModel@occuranceActive when RecurringBottomSheetController@occuranceActive is true', () {
        controller.occuranceActive = true;
        controller.occuranceCount.text = '15';
        controller.saveData();
        expect(model.occuranceActive, true);
      });
      test('Should return 15 in RecurringEmailModel@occurence when RecurringBottomSheetController@occuranceCount.text is 15', () {
        controller.occuranceCount.text = '15';
        controller.saveData();
        expect(model.occurrence, '15');
      });
      test('Should return job_end_stage_code in  RecurringEmailModel@occurence when RecurringBottomSheetController@occuranceActive is false', () {
        controller.occuranceActive = false;
        controller.saveData();
        expect(model.occurrence, RecurringConstants.jobEndStageCode);
      });
      test('Should return 1425(RecurringBottomSheetController@job.currentStage!.code) in RecurringEmailModel@currentStageCode when occurance is false', () {
        controller.occuranceActive = false;
        controller.saveData();
        expect(model.currentStageCode, '1425');
      });
      test('Should return 1234(RecurringBottomSheetController@selectedStage) in RecurringEmailModel@currentStageCode when occurance is false', () {
        controller.occuranceActive = false;
        controller.selectedStage = '1234';
        controller.saveData();
        expect(model.endStageCode, '1234');
      });
    });
  });

  group('RecurringBottomSheetController@toggleRadioButton different cases when different bool value passed',() {
    test('Should change occuranceText true when true is passed', () {
      controller.toggleRadioButton(true);
      expect(controller.occuranceActive, true);
    });
    test('Should change occuranceText true when true is passed', () {
      controller.toggleRadioButton(false);
      expect(controller.occuranceActive, false);
    });
  });

  group('RecurringBottomSheetController@toggleDayOfWeek different cases',() {
    controller.toggleDayOfWeek(DateTime.now().weekday - 1);
    test('Should change daysOfweekList isActive default false value into true', () {
      expect(controller.daysOfWeekList[DateTime.now().weekday - 1].isSelect, true);
    });
  });

  group('RecurringBottomSheetController@updateDurationType  test cases',() {
    test('Should return daily in selectedDurationValue & days in duration.text when daily passed as parameter', () {
      controller.updateDurationType(RecurringConstants.daily);
      expect(controller.selectedDurationValue, RecurringConstants.daily);
    });
    test('Should return monthly in selectedDurationValue & months in duration.text when monthly passed as parameter', () {
      controller.updateDurationType(RecurringConstants.monthly);
      expect(controller.selectedDurationValue, RecurringConstants.monthly);
    });
    test('Should return yearly in selectedDurationValue & Years in duration.text when yearly passed as parameter', () {
      controller.updateDurationType(RecurringConstants.yearly);
      expect(controller.selectedDurationValue, RecurringConstants.yearly);
    });
    test('Should return weekly in selectedDurationValue & Weeks in duration.text when weekly passed as parameter', () {
      controller.updateDurationType(RecurringConstants.weekly);
      expect(controller.selectedDurationValue, RecurringConstants.weekly);
    });
  });

  group('RecurringBottomSheetController@getMonthDurationListItem test cases', () {
    test("Should return 'Month on the (weekCount)(currentDay)' in monthlyDuration.text & 1 in selectedMonthDurationValue when '1' pass",() {
      controller.updateMonthData('1');
      expect(controller.selectedMonthDurationValue, '1');
    });
    test("Should return 'Month on the (currentDate)' in monthlyDuration.text & 0 in selectedMonthDurationValue when '0' pass",() {
      controller.updateMonthData('0');
      expect(controller.selectedMonthDurationValue, '0');
    });
  });

  group('RecurringBottomSheetController@setStages test cases', () {
    test("Should return selectedStage '1234', selectedStageValue 'Job 1' selectedStageColor 'red' when '1234' pass", () {
      controller.updateStage('1234');
      expect(controller.selectedStage, '1234');
      expect(controller.selectedStageValue,'Job 1');
      expect(controller.selectedStageColor,  WorkFlowStageConstants.colors['cl-red']);
    });
    test("Should return selectedStage '1425' , selectedStageValue 'Job 2' selectedStageColor 'yellow' when '1425' pass as param", () {
      controller.updateStage('1425');
      expect(controller.selectedStage, '1425');
      expect(controller.selectedStageValue,'Job 2');
      expect(controller.selectedStageColor, WorkFlowStageConstants.colors['cl-yellow']);
    });
  });

  group('RecurringBottomSheetController@validateData test cases', () {
    test('Should return showRepeatValidateMessage false & repeatValidateMessage empty when a valid value & repeat pass as param', () {
      controller.validateData('1', RecurringConstants.repeat);
      expect(controller.showRepeatValidateMessage, false);
    });
    test('Should return showRepeatValidateMessage true when a invalid value & repeat pass as param', () {
      controller.validateData('0',RecurringConstants.repeat);
      expect(controller.showRepeatValidateMessage,true);

    });
    test('Should return showOccuranceValidateMessage false when a valid value & occurrence pass as param', () {
      controller.validateData('15', RecurringConstants.occurrence);
      expect(controller.showOccuranceValidateMessage, false);
    });
    test('Should return showOccuranceValidateMessage true when a invalid value & occurrence pass', () {
      controller.validateData('0', RecurringConstants.occurrence);
      expect(controller.showOccuranceValidateMessage, true);
    });
  });
}