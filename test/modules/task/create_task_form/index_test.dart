
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/task_form_type.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/modules/task/create_task/controller.dart';

void main() {

  CreateTaskFormController controller = CreateTaskFormController();
  TaskListModel tempTask = TaskListModel(
      id: 1,
      title: 'Test Task',

  );

  TaskListModel tempTaskWithReminder = TaskListModel(
    id: 1,
    title: 'Test Task With Reminder',
    reminderFrequency: '2',
    reminderType: 'recurring'
  );

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    controller.init();
  });

  group('In case of create task', () {

    test('CreateTaskFormController should be initialized with correct values', () {
      controller.pageType = TaskFormType.createForm;
      expect(controller.isSavingForm, false);
      expect(controller.validateFormOnDataChange, false);
      expect(controller.isAdditionalDetailsExpanded, false);
      expect(controller.isReminderNotificationExpanded, false);
      expect(controller.isReminderInfoVisible, false);
      expect(controller.task, null);
      expect(controller.pageType, TaskFormType.createForm);
      expect(controller.pageTitle, 'create_task'.tr.toUpperCase());
    });

    group('CreateTaskFormController@onAdditionalOptionsExpansionChanged should toggle additional options expansion', () {

      test('Additional options should be expanded', () {
        controller.onAdditionalOptionsExpansionChanged(true);
        expect(controller.isAdditionalDetailsExpanded, true);
      });

      test('Additional options should be collapsed', () {
        controller.onAdditionalOptionsExpansionChanged(false);
        expect(controller.isAdditionalDetailsExpanded, false);
      });

    });

    group('CreateTaskFormController@onReminderNotificationExpansionChanged should toggle reminder notification expansion', () {

      test('Reminder notification section should be expanded', () {
        controller.onReminderNotificationExpansionChanged(true);
        expect(controller.isReminderNotificationExpanded, true);
      });

      test('Reminder notification section should be collapsed', () {
        controller.onReminderNotificationExpansionChanged(false);
        expect(controller.isReminderNotificationExpanded, false);
      });

    });

    group('CreateTaskFormController@toggleReminderInfo should toggle reminder info visibility', () {

      test('Reminder info should come to visibility', () {
        controller.toggleReminderInfo();
        expect(controller.isReminderInfoVisible, true);
      });

      test('Reminder info should hide', () {
        controller.toggleReminderInfo();
        expect(controller.isReminderInfoVisible, false);
      });

    });

    group('CreateTaskFormController@toggleIsSavingForm should toggle form\'s saving state', () {

      test('Form editing should be disabled', () {
        controller.toggleIsSavingForm();
        expect(controller.isSavingForm, true);
      });

      test('Form editing should be allowed', () {
        controller.toggleIsSavingForm();
        expect(controller.isSavingForm, false);
      });

    });

  });

  group('In case of edit/update task', () {

    test('CreateTaskFormController should be initialized with correct values', () {

      controller.task = tempTask;
      controller.pageType = TaskFormType.editForm;

      expect(controller.isSavingForm, false);
      expect(controller.validateFormOnDataChange, false);
      expect(controller.isAdditionalDetailsExpanded, false);
      expect(controller.isReminderNotificationExpanded, false);
      expect(controller.isReminderInfoVisible, false);
      expect(controller.task, tempTask);
      expect(controller.pageType, TaskFormType.editForm);
      expect(controller.pageTitle, 'update_task'.tr.toUpperCase());
    });

    group('Reminder notification section initial expansion should be correct', () {

      test('Should be initially collapsed when task reminder is not available', () {
        controller.init();
        expect(controller.isReminderNotificationExpanded, false);
      });

      test('Should be initially expanded when task reminder is available', () {
        controller.task = tempTaskWithReminder;
        controller.init();
        expect(controller.isReminderNotificationExpanded, false);
      });

    });

  });

}