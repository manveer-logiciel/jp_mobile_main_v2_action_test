
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/appointment_form_type.dart';
import 'package:jobprogress/modules/appointments/create_appointment/controller.dart';

void main() {

  CreateAppointmentFormController controller = CreateAppointmentFormController();

  setUpAll(() {
    controller.init();
  });

  group('In case of create appointment', () {

    test('CreateAppointmentFormController should be initialized with correct values', () {
      controller.pageType = AppointmentFormType.createForm;
      expect(controller.isSavingForm, false);
      expect(controller.validateFormOnDataChange, false);
      expect(controller.isAllDayReminderEnabled, false);
      expect(controller.isUserNotificationEnabled, false);
      expect(controller.appointment, isNull);
      expect(controller.isAdditionalDetailsExpanded, true);
      expect(controller.pageType, AppointmentFormType.createForm);
      expect(controller.pageTitle, 'create_appointment'.tr.toUpperCase());
      expect(controller.saveButtonText, 'create'.tr.toUpperCase());
    });

    group('CreateAppointmentFormController@onReminderChanged should toggle All day reminder options expansion', () {

      test('All day reminder options should be expanded', () {
        controller.onReminderChanged(true);
        expect(controller.isAllDayReminderEnabled, true);
      });

      test('All day reminder options should be collapsed', () {
        controller.onReminderChanged(false);
        expect(controller.isAllDayReminderEnabled, false);
      });

    });

    group('CreateAppointmentFormController@onAdditionalOptionsExpansionChanged should toggle additional options expansion', () {

      test('Additional options should be expanded', () {
        controller.onAdditionalOptionsExpansionChanged(true);
        expect(controller.isAdditionalDetailsExpanded, true);
      });

      test('Additional options should be collapsed', () {
        controller.onAdditionalOptionsExpansionChanged(false);
        expect(controller.isAdditionalDetailsExpanded, false);
      });

    });

    group('CreateAppointmentFormController@onUserNotificationChanged should toggle User Notification options expansion', () {

      test('User Notification options should be expanded', () {
        controller.onUserNotificationChanged(true);
        expect(controller.isUserNotificationEnabled, true);
      });

      test('User Notification options should be collapsed', () {
        controller.onUserNotificationChanged(false);
        expect(controller.isUserNotificationEnabled, false);
      });

    });

    group('CreateAppointmentFormController@toggleIsSavingForm should toggle form\'s saving state', () {

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

   group('In case of edit/update appointment', () {

    test('CreateAppointmentFormController should be initialized with correct values', () {
      controller.pageType = AppointmentFormType.editForm;

      expect(controller.isSavingForm, false);
      expect(controller.validateFormOnDataChange, false);
      expect(controller.isAllDayReminderEnabled, false);
      expect(controller.isUserNotificationEnabled, false);
      expect(controller.isAdditionalDetailsExpanded, false);
      expect(controller.appointment, isNull);
      expect(controller.pageType, AppointmentFormType.editForm);
      expect(controller.pageTitle, 'update_appointment'.tr.toUpperCase());
      expect(controller.saveButtonText, 'update'.tr.toUpperCase());
    });

  });

}