import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/event_form_type.dart';
import 'package:jobprogress/modules/calendar/event/controller.dart';

void main() {
  EventFormController controller = EventFormController();

  setUpAll(() {
    controller.init();
  });

  group('In case of create event', () {

    test('EventFormController should be initialized with correct values', () {
      controller.pageType = EventFormType.createForm;
      expect(controller.isSavingForm, false);
      expect(controller.validateFormOnDataChange, false);
      expect(controller.isAllDayReminderEnabled, false);
      expect(controller.isUserNotificationEnabled, false);
      expect(controller.isRecurringEnabled, false);
      expect(controller.schedulesModel != null, true);
      expect(controller.pageType, EventFormType.createForm);
      expect(controller.pageTitle, 'create_event'.tr.toUpperCase());
      expect(controller.saveButtonText, 'create'.tr.toUpperCase());
    });

    group('EventFormController@onReminderChanged should toggle All day reminder options expansion', () {

      test('All day reminder options should be expanded', () {
        controller.onReminderChanged(true);
        expect(controller.isAllDayReminderEnabled, true);
      });

      test('All day reminder options should be collapsed', () {
        controller.onReminderChanged(false);
        expect(controller.isAllDayReminderEnabled, false);
      });

    });

    group('EventFormController@onRecurringChanged should toggle recurring options expansion', () {

      test('Recurring options should be expanded', () {
        controller.onRecurringChanged(true);
        expect(controller.isRecurringEnabled, true);
      });

      test('Recurring options should be collapsed', () {
        controller.onRecurringChanged(false);
        expect(controller.isRecurringEnabled, false);
      });

    });

    group('EventFormController@onUserNotificationChanged should toggle User Notification options expansion', () {

      test('User Notification options should be expanded', () {
        controller.onUserNotificationChanged(true);
        expect(controller.isUserNotificationEnabled, true);
      });

      test('User Notification options should be collapsed', () {
        controller.onUserNotificationChanged(false);
        expect(controller.isUserNotificationEnabled, false);
      });

    });
  });

  group('In case of edit event', () {
    test('EventFormController should be initialized with correct values', () {
      controller.pageType = EventFormType.editForm;
      expect(controller.isSavingForm, false);
      expect(controller.validateFormOnDataChange, false);
      expect(controller.isAllDayReminderEnabled, false);
      expect(controller.isUserNotificationEnabled, false);
      expect(controller.isRecurringEnabled, false);
      expect(controller.schedulesModel != null, true);
      expect(controller.pageType, EventFormType.editForm);
      expect(controller.pageTitle, 'update_event'.tr.toUpperCase());
      expect(controller.saveButtonText, 'update'.tr.toUpperCase());
    });
  });

  group('In case of create schedule', () {
    test('EventFormController should be initialized with correct values', () {
      controller.pageType = EventFormType.createScheduleForm;
      expect(controller.isSavingForm, false);
      expect(controller.validateFormOnDataChange, false);
      expect(controller.isAllDayReminderEnabled, false);
      expect(controller.isUserNotificationEnabled, false);
      expect(controller.isRecurringEnabled, false);
      expect(controller.schedulesModel != null, true);
      expect(controller.pageType, EventFormType.createScheduleForm);
      expect(controller.pageTitle, 'create_schedule'.tr.toUpperCase());
      expect(controller.saveButtonText, 'create'.tr.toUpperCase());
    });
  });

  group('In case of edit schedule', () {
    test('EventFormController should be initialized with correct values', () {
      controller.pageType = EventFormType.editScheduleForm;
      expect(controller.isSavingForm, false);
      expect(controller.validateFormOnDataChange, false);
      expect(controller.isAllDayReminderEnabled, false);
      expect(controller.isUserNotificationEnabled, false);
      expect(controller.isRecurringEnabled, false);
      expect(controller.schedulesModel != null, true);
      expect(controller.pageType, EventFormType.editScheduleForm);
      expect(controller.pageTitle, 'update_schedule'.tr.toUpperCase());
      expect(controller.saveButtonText, 'update'.tr.toUpperCase());
    });
  });

}