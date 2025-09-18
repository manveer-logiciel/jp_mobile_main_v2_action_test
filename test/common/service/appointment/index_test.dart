import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/appointment_form_type.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/enums/date_picker_type.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/recurring_email.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/services/appointment/create_appointment_form.dart';
import 'package:jobprogress/common/services/appointment/get_recuring.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/core/constants/recurring_constant.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/modules/appointments/create_appointment/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

void main() {

  CreateAppointmentFormService service = CreateAppointmentFormService(
      update: () { }, // method used to update ui directly from service so empty function can be used in testing
      validateForm: () { } // method used to validate form using form key with is ui based, so can be passes empty for unit testing
  );

  late CreateAppointmentFormService serviceWithAppointment;

  List<JPSingleSelectModel> tempAppointmentForList = [
    JPSingleSelectModel(label: 'User 1', id: '1'),
    JPSingleSelectModel(label: 'User 2', id: '2'),
    JPSingleSelectModel(label: 'User 3', id: '3'),
    JPSingleSelectModel(label: 'User 4', id: '4'),
  ];

  JobModel? tempJob = JobModel(id: 1, customerId: 2, name: 'Test Job',
    number: '123-456', tradesString: "Test Trade 1", altId: "ALT123",
    address: AddressModel(id: 0, city: "city"),
  );

  CustomerModel? tempCustomer = CustomerModel(id: 2, firstName: "Test", lastName: "Customer", fullName: 'Test Customer');

  List<JobModel> tempListJob = [
    JobModel(id: 1, customerId: 2, name: 'Test Job', number: '123-456'),
    JobModel(id: 2, customerId: 3, name: 'Test Job', number: '123-459'),
  ];

  final tempAppointment = AppointmentModel(
    id: 1,
    title: 'Test Appointment',
    description: 'Testing',
    job: tempListJob,
    customer: tempCustomer,
    location: 'Gurgaon',
    locationType: 'customer',
    user: UserModel(
        id: 1,
        firstName: 'Test',
        fullName: 'Test',
        email: 'test@test.com',
    ),
    attachments: [
      AttachmentResourceModel(id: 1),
      AttachmentResourceModel(id: 2),
      AttachmentResourceModel(id: 3),
      AttachmentResourceModel(id: 4),
    ],
  );

  late Map<String, dynamic> tempInitialJson;

  setUpAll(() {
    tempInitialJson = service.appointmentFormJson();
    DateTimeHelper.setUpTimeZone();
    serviceWithAppointment = CreateAppointmentFormService(
      pageType: AppointmentFormType.editForm,
      update: () { }, // method used to update ui directly from service so empty function can be used in testing
      validateForm: () { }, // method used to validate form using form key with is ui based, so can be passes empty for logical testing
      appointmentModel: tempAppointment,
    );
  });

  group('In case of create appointment', () {
        CreateAppointmentFormService service = CreateAppointmentFormService(
        update: () {  },
        validateForm: () {  },
        pageType: AppointmentFormType.createForm,
    );

    setUpAll(() {
      tempInitialJson = service.appointmentFormJson();
      service.controller = CreateAppointmentFormController();
    });

    group('CreateAppointmentFormService should be initialized with correct data', () {

      test('Form fields should be initialized with correct values', () {
        expect(service.customerController.text, "");
        expect(service.jobController.text, "");
        expect(service.titleController.text, "");
        expect(service.appointmentForController.text, "");
        expect(service.attendeesController.text, "");
        expect(service.notesController.text, "");
        expect(service.dateTimeController.text, "");
        expect(service.recurringController.text, 'does_not_repeat'.tr.capitalizeFirst.toString());
        expect(service.locationController.text, "");
        expect(service.locationTypeController.text, 'other'.tr.capitalize.toString());
        expect(service.additionalRecipientsController.text, "");
      });

      test('Form toggles should be initialized with correct values', () {
        expect(service.isAllDayReminderSelected, false);
        expect(service.isRecurringSelected, false);
        expect(service.isLoading, true);
        expect(service.isUserNotificationSelected, false);
      });

      test('Form data helper lists should be filled with correct data', () {
        expect(service.appointmentForList.length, 0);
        expect(service.attachments.length, 0);
        expect(service.uploadedAttachments.length, 0);
        expect(service.attendeesUsers.length, 0);
        expect(service.selectedJobList.length, 0);
        expect(service.selectedadditionalRecipients.length, 0);
        expect(service.additionalRecipientsList.length, 0);
        expect(service.notificationReminders.length, 0);
        expect(service.jobModelList.length, 0);
        expect(service.to.length, 0);
        expect(service.initialToValues.length, 0);
      });

      test('Form data helpers should be initialized with correct values', () {
        expect(service.jobModel, null);
        expect(service.customerModel, null);
        expect(service.recurringEmail, null);
        expect(service.selectedAppointmentForId, '');
        expect(service.selectedLocationType, 'other');
        expect(service.selectCurrentadditionalRecipients, '');
        expect(service.selectedRecurringValue, 'does_not_repeat');
        expect(service.initialJson, <String, dynamic>{});
      });

    });

    test('CreateAppointmentFormService@appointmentFormJson() should generate json from form-data', () {

      final tempJson = service.appointmentFormJson();
      expect(tempInitialJson, tempJson);

    });

    group('CreateAppointmentFormService@checkIfNewDataAdded() should check if any addition/update is made in form', () {

      setUp(() {
        service.titleController.text = '';
        service.setFormData();
      });


      test('When no changes in form are made', () {
        final val = service.checkIfNewDataAdded();
        expect(val, false);
      });

      test('When changes in form are made', () {
        service.titleController.text = tempAppointment.title ?? '';
        final val = service.checkIfNewDataAdded();
        expect(val, true);
      });

      test('When changes are reverted', () {
        service.titleController.text = "";
        final val = service.checkIfNewDataAdded();
        expect(val, false);
      });
    });

    group('CreateAppointmentFormService@validateScheduleEventTime() should validate schedule time when AllDayReminder is enabled', () {
      test('Validation should fail when start date time is empty', () {
        service.isAllDayReminderSelected = true;
        service.startDateTime = "";
        final val = service.validateAppointmentTime();
        expect(service.errorText, "please_provide_start_date_and_time".tr);
        expect(val, false);
      });

      test('Validation should pass when start date time is not empty', () {
        service.isAllDayReminderSelected = true;
        service.startDateTime = DateTime.now().toString();
        final val = service.validateAppointmentTime();
        expect(service.errorText, null);
        expect(val, true);
      });
    });

    group('CreateTaskFormService@validateScheduleEventTime() should validate schedule time when AllDayReminder is disabled', () {

      test('Validation should fail when start date time is empty', () {
        service.isAllDayReminderSelected = false;
        service.startDateTime = "";
        final val = service.validateAppointmentTime();
        expect(service.errorText, "please_provide_start_date_and_time".tr);
        expect(val, false);
      });

      test('Validation should fail when end date time is empty', () {
        service.isAllDayReminderSelected = false;
        service.startDateTime = DateTime.now().toString();
        service.endDateTime = "";
        final val = service.validateAppointmentTime();
        expect(service.errorText, "please_provide_end_date_and_time".tr);
        expect(val, false);
      });

      test('Validation should fail when end date time is less then start date time', () {
        service.isAllDayReminderSelected = false;
        service.startDateTime = DateTime.now().toString();
        service.endDateTime = DateTime.now().subtract(const Duration(hours: 2)).toString();
        final val = service.validateAppointmentTime();
        expect(service.errorText, "end_time_must_be_greater_then_start_time".tr);
        expect(val, false);
      });

      test('Validation should fail when start date time is equals to end date time', () {
        service.isAllDayReminderSelected = false;
        service.startDateTime = DateTime.now().toString();
        service.endDateTime = service.startDateTime;
        final val = service.validateAppointmentTime();
        expect(service.errorText, "end_time_must_be_greater_then_start_time".tr);
        expect(val, false);
      });

      test('Validation should fail when OverLapped condition occurred', () {
        service.isAllDayReminderSelected = false;
        service.isRecurringSelected = true;
        service.startDateTime = DateTime.now().toString();
        service.endDateTime = DateTime.now().add(const Duration(hours: 28)).toString();
        service.selectedRecurringType = RecurringConstants.daily;
        final val = service.validateAppointmentTime();
        expect(service.errorText, 'overlapped_schedules_are_not_allowed'.tr);
        expect(val, false);
      });

      test('Validation should pass when all checks are satisfied', () {
        service.isAllDayReminderSelected = false;
        service.isRecurringSelected = true;
        service.startDateTime = DateTime.now().toString();
        service.endDateTime = DateTime.now().add(const Duration(hours: 28)).toString();
        service.selectedRecurringType = RecurringConstants.weekly;
        final val = service.validateAppointmentTime();
        expect(service.errorText, null);
        expect(val, true);
      });
    });

    group('CreateAppointmentFormService@selectedLocationType should be initialised with correct data', () {

      test('Selected location type should be initialized with other when nothing is selected neither customer nor job', () {
        expect(service.selectedLocationType, "other");
      });

      test('Selected location type should be initialized with customer when customer is selected', () {
        service.onCustomerSelected(tempCustomer);
        expect(service.selectedLocationType, "customer");
      });

      test('Selected location type should be initialized with customer when no job is selected', () {
        service.onJobSelected([]);
        expect(service.selectedLocationType, "customer");
      });

      test('Selected location type should be initialized with job when job is selected', () {
        service.onJobSelected([tempJob]);
        expect(service.selectedLocationType, "job");
      });

      test('Selected location type should be initialized with customer when job is de-selected', () {
        service.onRemoveJob(tempJob.id.toString());
        expect(service.selectedLocationType, "customer");
      });

      test('Selected location type should be initialized with other when customer is de-selected', () {
        service.removeCustomer();
        expect(service.selectedLocationType, "other");
      });
    });

    test('CreateAppointmentFormService@removeCustomer() should remove selected customer', () {
      service.jobModel = tempJob;
      service.customerModel = tempCustomer;
      service.jobModelList = tempListJob;
      service.removeCustomer();
      expect(service.jobModel, isNull);
      expect(service.customerModel, isNull);
      expect(service.jobModelList, isEmpty);
      expect(service.selectedJobList, isEmpty);
      expect(service.customerController.text, "");
      expect(service.jobController.text, "");
      expect(service.titleController.text, "");
      expect(service.notesController.text, "");
      expect(service.locationController.text, "");
    });

    test('CreateAppointmentFormService@removeJob() should remove selected job', () {
      service.jobModel = tempJob;
      service.jobModelList = tempListJob;
      service.onRemoveJob('1');
      expect(service.jobModel, null);
      expect(service.jobModelList, isEmpty);
      expect(service.jobController.text, "");
      expect(service.locationController.text, "");
    });

    test('CreateAppointmentFormService@removeAttachedItem() should remove attachment', () {
      service.attachments = tempAppointment.attachments!;
      service.removeAttachedItem(0);
      expect(service.attachments.length, 3);
    });

    group('CreateAppointmentFormService@validateTitle() should validate appointment title', () {

      test('Validation should fail when appointment title is empty', () {
        service.titleController.text = "";
        final val = service.validateTitle(service.titleController.text);
        expect(val, 'title_cant_be_left_blank'.tr);
      });

      test('Validation should fail when appointment title only contains empty spaces', () {
        service.titleController.text = "     ";
        final val = service.validateTitle(service.titleController.text);
        expect(val, 'title_cant_be_left_blank'.tr);
      });

      test('Validation should pass when title contains special characters', () {
        service.titleController.text = "#kpl& - /";
        final val = service.validateTitle(service.titleController.text);
        expect(val, null);
      });

      test('Validation should pass when appointment title is not-empty', () {
        service.titleController.text = "Title";
        final val = service.validateTitle(service.titleController.text);
        expect(val, null);
      });

    });

    group('CreateAppointmentFormService@validateAppointmentFOr() should validate appointment for', () {

      test('Validation should fail when appointment for is not selected', () {
        final val = service.validateAppointmentFor(service.appointmentForController.text);
        expect(val, 'appointment_must_be_assigned_to_some_one'.tr);
      });

      test('Validation should fail when appointment for field is empty', () {
        service.appointmentForController.text = "";
        final val = service.validateAppointmentFor(service.appointmentForController.text);
        expect(val, 'appointment_must_be_assigned_to_some_one'.tr);
      });

      test('Validation should fail when appointment for field is filled & and no-selected appointment for', () {
        service.appointmentForController.text = "";
        final val = service.validateAppointmentFor(service.appointmentForController.text);
        expect(val, 'appointment_must_be_assigned_to_some_one'.tr);
      });

      test('Validation should pass when appointment for is selected & appointment for field is filled', () {
        service.appointmentForList = tempAppointmentForList;
        service.appointmentForController.text = tempAppointment.title ?? '';
        service.selectedAppointmentForId == '';
        final val = service.validateAppointmentFor(service.appointmentForController.text);
        expect(val, null);
      });

    });

    group('CreateAppointmentFormService@validateLocation() should validate location', () {

      test('Validation should fail when location is empty', () {
        service.locationController.text = "";
        final val = service.validateLocation(service.locationController.text);
        expect(val, 'location_cant_be_left_blank'.tr);
      });

      test('Validation should fail when location only contains empty spaces', () {
        service.locationController.text = "     ";
        final val = service.validateLocation(service.locationController.text);
        expect(val, 'location_cant_be_left_blank'.tr);
      });

      test('Validation should pass when location contains special characters', () {
        service.locationController.text = "#kpl& - /";
        final val = service.validateLocation(service.locationController.text);
        expect(val, null);
      });

      test('Validation should pass when location is not-empty', () {
        service.locationController.text = "Location";
        final val = service.validateLocation(service.locationController.text);
        expect(val, null);
      });

    });

    group('CreateAppointmentFormService@setDefaultTitle() should initialized appointment title with correct data', () {
      test('Appointment title should not contain any text when nothing is selected neither customer nor job', () {
        service.setDefaultTitle();
        expect(service.titleController.text, "");
      });

      test('Appointment title should contain customer last name when only customer is selected', () {
        service.onCustomerSelected(tempCustomer);
        service.setDefaultTitle();
        expect(service.titleController.text, tempCustomer.lastName);
      });

      test('Appointment title should contain customer first name when selected customer does not have last name', () {
        service.onCustomerSelected(tempCustomer..lastName = null);
        service.setDefaultTitle();
        expect(service.titleController.text, tempCustomer.firstName);
      });

      test('Appointment title should contain trades when job is selected and customer does not have address', () {
        service.jobModelList = [tempJob];
        service.setDefaultTitle();
        expect(service.titleController.text.contains(tempJob.tradesString), true);
      });

      test('Appointment title should contain altID when job is selected and selected job has city', () {
        service.setDefaultTitle();
        expect(service.titleController.text.contains(tempJob.altId.toString()), true);
      });

      test('Appointment title should remove job trades, altID when job is de-selected', () {
        service.onRemoveJob(tempJob.id.toString());
        service.setDefaultTitle();
        expect(service.titleController.text.contains(tempJob.tradesString), false);
        expect(service.titleController.text.contains(tempJob.altId.toString()), false);
      });

      test('Appointment title should remove customer name when customer is de-selected', () {
        service.removeCustomer();
        service.setDefaultTitle();
        expect(service.titleController.text, "");
      });
    });
  });

  group('CreateAppointmentFormService@modifyEndDateTime', () {

    test('End date should update on changing start date', () {
      service.startDateTime = "2023-10-14 03:30:00.000";
      service.endDateTime = service.modifyEndDateTime(service.endDateTime!, service.startDateTime!, DatePickerType.start);
      expect(service.endDateTime, DateTime.parse(service.startDateTime!).add(const Duration(hours: 1)).toString());
    });

    test('End time should update on changing start time', () {
      service.startDateTime = "2023-10-14 03:40:00.000";
      service.endDateTime = service.modifyEndDateTime(service.endDateTime!, service.startDateTime!, DatePickerType.start);
      expect(service.endDateTime, DateTime.parse(service.startDateTime!).add(const Duration(hours: 1)).toString());
    });

    test('Start date should not update on changing end date', () {
      String? tempStartDate = service.startDateTime;
      service.endDateTime = DateTime.parse(service.endDateTime!).add(const Duration(days: 1)).toString();
      expect(service.startDateTime, tempStartDate);
    });

    test('Start time should not update on changing end time', () {
      String? tempStartDate = service.startDateTime;
      service.endDateTime = DateTime.parse(service.endDateTime!).add(const Duration(hours: 1)).toString();
      expect(service.startDateTime, tempStartDate);
    });

  });

  group('CreateAppointmentFormService@validateAppointmentTime() should validate', () {
    test('Validation should fail when end time is before from start time', () {
      service.endDateTime = "2023-10-14 02:40:00.000";
      service.startDateTime = "2023-10-14 03:40:00.000";
      final val = service.validateAppointmentTime();
      expect(service.errorText, "end_time_must_be_greater_then_start_time".tr);
      expect(val, false);
    });

    test('Validation should pass when end time is after from start time', () {
      service.endDateTime = "2023-10-14 04:40:00.000";
      service.startDateTime = "2023-10-14 03:40:00.000";
      final val = service.validateAppointmentTime();
      expect(service.errorText, null);
      expect(val, true);
    });
  });

  group('In case of edit/update appointment', () {

    group('CreateAppointmentFormService should be initialized with correct data', () {

      test('Form fields should be filled with correct values', () {
        serviceWithAppointment.appointmentForList = [
          JPSingleSelectModel(label: 'Test', id: '1')
        ];
        serviceWithAppointment.setFormData();

        final appointmentFor = SingleSelectHelper.getSelectedSingleSelectValue(
          serviceWithAppointment.appointmentForList,
          serviceWithAppointment.selectedAppointmentForId,
        );

        final recurringList = SingleSelectHelper.getSelectedSingleSelectValue(
          serviceWithAppointment.recurringList,
          serviceWithAppointment.selectedRecurringValue,
        );

        final locationTypeList = SingleSelectHelper.getSelectedSingleSelectValue(
          serviceWithAppointment.locationTypeList,
          serviceWithAppointment.selectedLocationType,
        );

        expect(serviceWithAppointment.titleController.text, tempAppointment.title);
        expect(serviceWithAppointment.appointmentForController.text, appointmentFor);
        expect(serviceWithAppointment.recurringController.text, recurringList);
        expect(serviceWithAppointment.notesController.text, tempAppointment.description);
        expect(serviceWithAppointment.locationController.text, tempAppointment.location);
        expect(serviceWithAppointment.locationTypeController.text, locationTypeList);
      });

      test('Form toggles should be initialized with correct values', () {
        expect(service.isAllDayReminderSelected, false);
        expect(service.isRecurringSelected, false);
        expect(service.isLoading, true);
        expect(service.isUserNotificationSelected, false);
      });

      test('Form data helper lists should be filled with correct data', () {
        expect(service.appointmentForList.length, 0);
        expect(service.attachments.length, 0);
        expect(service.uploadedAttachments.length, 0);
        expect(service.attendeesUsers.length, 0);
        expect(service.selectedJobList.length, 0);
        expect(service.selectedadditionalRecipients.length, 0);
        expect(service.additionalRecipientsList.length, 0);
        expect(service.notificationReminders.length, 0);
        expect(service.jobModelList.length, 0);
        expect(service.to.length, 0);
        expect(service.initialToValues.length, 0);
      });

      test('Form data helpers should be initialized with correct values', () {
        expect(service.jobModel, null);
        expect(service.customerModel, null);
        expect(service.recurringEmail, null);
        expect(service.selectedAppointmentForId, '');
        expect(service.selectedLocationType, 'other');
        expect(service.selectCurrentadditionalRecipients, '');
        expect(service.selectedRecurringValue, 'does_not_repeat');
        expect(service.initialJson, <String, dynamic>{});
      });

      test('Form fields should be filled with correct values when CreateAppointmentFormData@appointmentModel is not available', () {
        serviceWithAppointment.appointmentForList = [
          JPSingleSelectModel(label: 'Test', id: '1')
        ];
        serviceWithAppointment.appointmentModel = null;
        serviceWithAppointment.setFormData();

        final appointmentFor = SingleSelectHelper.getSelectedSingleSelectValue(
          serviceWithAppointment.appointmentForList,
          serviceWithAppointment.selectedAppointmentForId,
        );

        final recurringList = SingleSelectHelper.getSelectedSingleSelectValue(
          serviceWithAppointment.recurringList,
          serviceWithAppointment.selectedRecurringValue,
        );

        final locationTypeList = SingleSelectHelper.getSelectedSingleSelectValue(
          serviceWithAppointment.locationTypeList,
          serviceWithAppointment.selectedLocationType,
        );

        expect(serviceWithAppointment.titleController.text, serviceWithAppointment.appointmentForList.first.label);
        expect(serviceWithAppointment.appointmentForController.text, appointmentFor);
        expect(serviceWithAppointment.recurringController.text, recurringList);
        expect(serviceWithAppointment.notesController.text, tempAppointment.description);
        expect(serviceWithAppointment.locationController.text, tempAppointment.location);
        expect(serviceWithAppointment.locationTypeController.text, locationTypeList);
      });
    });
  });

    group('Form field edit ability', () {

    test('In case page type is create form or edit form, then all fields should be editable', () {
      service = CreateAppointmentFormService(
        update: () {  },
        validateForm: () { },
        pageType: AppointmentFormType.createForm,
      );
      expect(service.isFieldEditable(), true);
    });

  });

  group('CreateAppointmentFormService@getRecurringWeekNo should give us the recurring week number based on the start date and time', () {
    test('Should be display the label for the first Sunday of the week within the month', () {
      // Arrange
      serviceWithAppointment.startDateTime = "2024-05-05 06:00:00.000";
      
      // Act
      final result = serviceWithAppointment.getRecurringWeekNo();
      
      // Assert
      expect(result, equals('Monthly on first Sunday'));
    });

    test('Should be display the label for the second Sunday of the week within the month', () {
      // Arrange
      serviceWithAppointment.startDateTime = "2024-05-12 06:00:00.000";
      
      // Act
      final result = serviceWithAppointment.getRecurringWeekNo();
      
      // Assert
      expect(result, equals('Monthly on second Sunday'));
    });

    test('Should be display the label for the third Sunday of the week within the month', () {
      // Arrange
      serviceWithAppointment.startDateTime = "2024-05-19 06:00:00.000";
      
      // Act
      final result = serviceWithAppointment.getRecurringWeekNo();
      
      // Assert
      expect(result, equals('Monthly on third Sunday'));
    });

    test('Should be display the label for the fourth Sunday of the week within the month', () {
      // Arrange
      serviceWithAppointment.startDateTime = "2024-05-26 06:00:00.000";
      
      // Act
      final result = serviceWithAppointment.getRecurringWeekNo();
      
      // Assert
      expect(result, equals('Monthly on fourth Sunday'));
    });
  });

  group('CreateAppointmentFormService@setReccuringTextField Should sets the text of the recurring text field', () {
    test('Should not update text field when Recurring Email count is less than or equal to 2', () {
      // Arrange
     serviceWithAppointment.recurringList = [
        JPSingleSelectModel(id: 'does_not_repeat', label: 'does_not_repeat'.tr.capitalizeFirst!),
        JPSingleSelectModel(id: 'custom', label: 'custom'.tr.capitalizeFirst!),
      ];

      // Act
      serviceWithAppointment.setReccuringTextField();

      // Assert
      expect(serviceWithAppointment.recurringController.text, 'does_not_repeat'.tr.capitalizeFirst.toString());
      expect(serviceWithAppointment.selectedRecurringValue, 'does_not_repeat');
    });

    test('Should not update text field when Email Recurring repeat is not availble', () {
      // Arrange
      serviceWithAppointment.recurringEmail = RecurringEmailModel(repeat: null);

      if(RecurringService.getRecOption(serviceWithAppointment.recurringEmail) != null) {
        serviceWithAppointment.recurringList.insert(2,JPSingleSelectModel(
          label: RecurringService.getRecOption(serviceWithAppointment.recurringEmail), id: '0'));
        serviceWithAppointment.selectedRecurringValue = serviceWithAppointment.recurringList[2].id;
        serviceWithAppointment.isRecurringSelected = true;
      }
      serviceWithAppointment.startDateTime = "2024-4-29 03:40:00.000";

      // Act
      serviceWithAppointment.setReccuringTextField();

      // Assert
      expect(serviceWithAppointment.recurringList.length, 2);
      expect(serviceWithAppointment.recurringEmail?.repeat, null);
      expect(serviceWithAppointment.recurringController.text, 'does_not_repeat'.tr.capitalizeFirst.toString());
      expect(serviceWithAppointment.selectedRecurringValue, 'does_not_repeat');
    });

    test('Should not update text field when Email Recurring repeat is monthly and byDay is not Available', () {
      // Arrange
      serviceWithAppointment.recurringEmail = RecurringEmailModel(repeat: 'monthly', byDay: null);
      serviceWithAppointment.recurringEmail?.startDateTime = "2024-05-01 06:00:00.000";

      if(RecurringService.getRecOption(serviceWithAppointment.recurringEmail) != null) {
        serviceWithAppointment.recurringList.insert(2,JPSingleSelectModel(
          label: RecurringService.getRecOption(serviceWithAppointment.recurringEmail), id: '0'));
        serviceWithAppointment.selectedRecurringValue = serviceWithAppointment.recurringList[2].id;
        serviceWithAppointment.isRecurringSelected = true;
      }
      
      // Act
      serviceWithAppointment.setReccuringTextField();

      // Assert
      expect(serviceWithAppointment.recurringList.length, 3);
      expect(serviceWithAppointment.recurringEmail?.repeat, 'monthly');
      expect(serviceWithAppointment.recurringController.text, "Monthly on day 1");
      expect(serviceWithAppointment.selectedRecurringValue, '0');
      expect(serviceWithAppointment.isRecurringSelected, true);
    });

    test('Should update text field when Email Recurring repeat is monthly and byDay is Available', () {
      // Arrange
      if(serviceWithAppointment.recurringList.length > 2){serviceWithAppointment.recurringList.removeAt(2);}

      serviceWithAppointment.recurringEmail = RecurringEmailModel(repeat: 'monthly', byDay: ["1WE"]);
      serviceWithAppointment.startDateTime = "2024-05-01 06:00:00.000";

      if(RecurringService.getRecOption(serviceWithAppointment.recurringEmail) != null) {
        serviceWithAppointment.recurringList.insert(2,JPSingleSelectModel(
          label: RecurringService.getRecOption(serviceWithAppointment.recurringEmail), id: '0'));
        serviceWithAppointment.selectedRecurringValue = serviceWithAppointment.recurringList[2].id;
        serviceWithAppointment.isRecurringSelected = true;
      }
      // Act
      serviceWithAppointment.setReccuringTextField();

      // Assert
      expect(serviceWithAppointment.recurringList.length, 3);
      expect(serviceWithAppointment.recurringEmail?.repeat, 'monthly');
      expect(serviceWithAppointment.recurringController.text, "Monthly on first Wednesday");
      expect(serviceWithAppointment.selectedRecurringValue, '0');
      expect(serviceWithAppointment.isRecurringSelected, true);
    });

    test('Should not update text field when Email Recurring repeat is daily', () {
      // Arrange
      if(serviceWithAppointment.recurringList.length > 2){serviceWithAppointment.recurringList.removeAt(2);}

      serviceWithAppointment.recurringEmail = RecurringEmailModel(repeat: 'daily');
      serviceWithAppointment.recurringEmail?.startDateTime = "2024-05-01 06:00:00.000";

      if(RecurringService.getRecOption(serviceWithAppointment.recurringEmail) != null) {
        serviceWithAppointment.recurringList.insert(2,JPSingleSelectModel(
          label: RecurringService.getRecOption(serviceWithAppointment.recurringEmail), id: '0'));
        serviceWithAppointment.selectedRecurringValue = serviceWithAppointment.recurringList[2].id;
        serviceWithAppointment.isRecurringSelected = true;
      }

      // Act
      serviceWithAppointment.setReccuringTextField();

      // Assert
      // Assert
      expect(serviceWithAppointment.recurringList.length, 3);
      expect(serviceWithAppointment.isRecurringSelected, true);
      expect(serviceWithAppointment.selectedRecurringValue, '0');
      expect(serviceWithAppointment.recurringEmail?.repeat, 'daily');
      expect(serviceWithAppointment.recurringController.text, "daily".tr.capitalizeFirst.toString());
      
    });

    test('Should not update text field when Email Recurring repeat is weekly', () {
      // Arrange
      if(serviceWithAppointment.recurringList.length > 2){serviceWithAppointment.recurringList.removeAt(2);}

      serviceWithAppointment.recurringEmail = RecurringEmailModel(repeat: 'weekly', byDay: ["MO","TU"]);
      serviceWithAppointment.recurringEmail?.startDateTime = "2024-05-01 06:00:00.000";

      if(RecurringService.getRecOption(serviceWithAppointment.recurringEmail) != null) {
        serviceWithAppointment.recurringList.insert(2,JPSingleSelectModel(
          label: RecurringService.getRecOption(serviceWithAppointment.recurringEmail), id: '0'));
        serviceWithAppointment.selectedRecurringValue = serviceWithAppointment.recurringList[2].id;
        serviceWithAppointment.isRecurringSelected = true;
      }

      // Act
      serviceWithAppointment.setReccuringTextField();

      // Assert
      expect(serviceWithAppointment.recurringList.length, 3);
      expect(serviceWithAppointment.isRecurringSelected, true);
      expect(serviceWithAppointment.selectedRecurringValue, '0');
      expect(serviceWithAppointment.recurringEmail?.repeat, 'weekly');
      expect(serviceWithAppointment.recurringController.text, "Weekly on Monday, Tuesday");
    });
  });  

  group('CreateAppointmentFormService@removeAppointmentFor should remove Appointment For correctly' , () {
    final customer = CustomerModel(
      rep: UserLimitedModel(
        id: 123, 
        firstName: '', 
        fullName: '', 
        email: '', 
        groupId: 0
      )
    );

    test('Should not do anything if customer rep matches with selected appointment For', () {
      service.selectedAppointmentForId = '456';
      service.appointmentForController.text = 'User 2';

      service.removeAppointmentFor(customer);

      expect(service.selectedAppointmentForId, '456');
      expect(service.appointmentForController.text, 'User 2');
    });
    test('Should clear appointmentFor if customer rep matches with selected appointment For', () {
      
      service.selectedAppointmentForId = '123';
      service.appointmentForController.text = 'User 1';
      service.removeAppointmentFor(customer);

      expect(service.appointmentForController.text, '');
      expect(service.selectedAppointmentForId, '');
    });
  });
  group('CreateAppointmentFormService@setAppointmentFor should set Appointment For correctly', () {
     final customer = CustomerModel(
      rep: UserLimitedModel(
        id: 786, 
        firstName: 'Dikshit', 
        fullName: 'Dikshit Sharma', 
        email: '', 
        groupId: 12
      )
    );     
    

    test('Should not change appointmentForController and selectedAppointmentForId when feature is not allowed', () {
      FeatureFlagService.setFeatureData({FeatureFlagConstant.userManagement: 0});
      
      service.setAppointmentFor(customer);

      expect(service.appointmentForController.text, '');
      
    });
    test('Should set appointmentForController and selectedAppointmentForId when feature is allowed', () {
      FeatureFlagService.setFeatureData({FeatureFlagConstant.userManagement: 1});

      service.setAppointmentFor(customer);
      expect(service.appointmentForController.text, 'Dikshit Sharma');
      expect(service.selectedAppointmentForId, '786');
    });
  });

  test('CreateAppointmentFormService@isLocationTypeOther should return true only when location type is "other"', () {
    service.selectedLocationType = 'other';
    expect(service.isLocationTypeOther, true);

    service.selectedLocationType = 'customer';
    expect(service.isLocationTypeOther, false);

    service.selectedLocationType = 'job';
    expect(service.isLocationTypeOther, false);

    service.selectedLocationType = '';
    expect(service.isLocationTypeOther, false);

    service.selectedLocationType = 'OTHER';
    expect(service.isLocationTypeOther, false);
  });

  group('CreateAppointmentFormService attachment type handling - verifies dynamic attachment type usage with fallback to "resource"', () {
    late CreateAppointmentFormService testService;

    setUp(() {
      testService = CreateAppointmentFormService(
        update: () {},
        validateForm: () {},
        customerModel: tempCustomer,
        appointmentModel: null,
      );
    });

    test('should use attachment type from model when available', () {
      // Arrange
      testService.attachments = [
        AttachmentResourceModel(id: 1, type: 'image'),
        AttachmentResourceModel(id: 2, type: 'document'),
      ];

      // Act
      final json = testService.appointmentFormJson();

      // Assert
      expect(json['attachments'], isA<List<dynamic>>());
      final attachments = json['attachments'] as List<dynamic>;
      expect(attachments.length, 2);
      expect(attachments[0]['type'], 'image');
      expect(attachments[0]['value'], 1);
      expect(attachments[1]['type'], 'document');
      expect(attachments[1]['value'], 2);
    });

    test('should fallback to "resource" when attachment type is null', () {
      // Arrange
      testService.attachments = [
        AttachmentResourceModel(id: 1, type: null),
        AttachmentResourceModel(id: 2), // type defaults to null
      ];

      // Act
      final json = testService.appointmentFormJson();

      // Assert
      expect(json['attachments'], isA<List<dynamic>>());
      final attachments = json['attachments'] as List<dynamic>;
      expect(attachments.length, 2);
      expect(attachments[0]['type'], 'resource');
      expect(attachments[0]['value'], 1);
      expect(attachments[1]['type'], 'resource');
      expect(attachments[1]['value'], 2);
    });

    test('should handle multiple attachments with different types', () {
      // Arrange
      testService.attachments = [
        AttachmentResourceModel(id: 1, type: 'image'),
        AttachmentResourceModel(id: 2, type: null),
        AttachmentResourceModel(id: 3, type: 'video'),
        AttachmentResourceModel(id: 4), // type defaults to null
      ];

      // Act
      final json = testService.appointmentFormJson();

      // Assert
      expect(json['attachments'], isA<List<dynamic>>());
      final attachments = json['attachments'] as List<dynamic>;
      expect(attachments.length, 4);
      expect(attachments[0]['type'], 'image');
      expect(attachments[1]['type'], 'resource');
      expect(attachments[2]['type'], 'video');
      expect(attachments[3]['type'], 'resource');
    });
  });

}