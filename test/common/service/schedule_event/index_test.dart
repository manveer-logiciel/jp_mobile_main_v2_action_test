import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/date_picker_type.dart';
import 'package:jobprogress/common/enums/event_form_type.dart';
import 'package:jobprogress/common/enums/form_field_type.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/company_trades/company_trades_model.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/schedules/schedules.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/services/calendars/event_form.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/recurring_constant.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jobprogress/modules/calendar/event/controller.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';

void main() {

  List<JPMultiSelectModel> tempCrewList = [
    JPMultiSelectModel(label: 'User 1', id: '1', isSelect: true, child: const JPProfileImage(src: "profilePic", initial: "U1",)),
    JPMultiSelectModel(label: 'User 2', id: '2', isSelect: true, child: const JPProfileImage(src: "profilePic", initial: "U2",)),
    JPMultiSelectModel(label: 'User 3', id: '3', isSelect: false, child: const JPProfileImage(src: "profilePic", initial: "U3",)),
    JPMultiSelectModel(label: 'User 4', id: '4', isSelect: false, child: const JPProfileImage(src: "profilePic", initial: "U4",)),
    JPMultiSelectModel(label: 'User 5', id: '5', isSelect: false, child: const JPProfileImage(src: "profilePic", initial: "U5",)),
    JPMultiSelectModel(label: 'User 6', id: '6', isSelect: false, child: const JPProfileImage(src: "profilePic", initial: "U6",)),
  ];

  List<JPMultiSelectModel> tempSubContractorList = [
    JPMultiSelectModel(label: 'Company 1', id: '1', isSelect: true, child: const JPProfileImage(src: "profilePic", initial: "C1",)),
    JPMultiSelectModel(label: 'Company 2', id: '2', isSelect: true, child: const JPProfileImage(src: "profilePic", initial: "C2",)),
    JPMultiSelectModel(label: 'Company 3', id: '3', isSelect: false, child: const JPProfileImage(src: "profilePic", initial: "C3",)),
    JPMultiSelectModel(label: 'Company 4', id: '4', isSelect: false, child: const JPProfileImage(src: "profilePic", initial: "C4",)),
  ];

  List<JPMultiSelectModel> tempTradeList = [
    JPMultiSelectModel(label: 'Trade 1', id: '1', isSelect: true, child: const JPProfileImage(src: "profilePic", initial: "T1",)),
    JPMultiSelectModel(label: 'Trade 2', id: '2', isSelect: false, child: const JPProfileImage(src: "profilePic", initial: "T2",)),
  ];

  JobModel? tempJob = JobModel(
    id: 1,
    customerId: 2,
    name: 'Test Job',
    number: '123-456',
    altId: "112",
    trades: [CompanyTradesModel.fromJson({"id":36, "name":"HOME SERVICES", "pivot":{"job_id":21801, "trade_id":36}})],
    reps: [
      UserLimitedModel.fromJson({"id":1234, "full_name":"Manveer Singh", "color":"#FE6F5E", "company_name":""}),
      UserLimitedModel.fromJson({"id":1235, "full_name":"Ranveer Kohli", "color":"red", "company_name":""}),
      UserLimitedModel.fromJson({"id":1237, "full_name":"Kavya Sharma", "color":"gray", "company_name":""}),
      UserLimitedModel.fromJson({"id":1408, "full_name":"Adrian Smitham", "color":"#702963", "company_name":""}),
      UserLimitedModel.fromJson({"id":1329, "full_name":"Ajay Sharma", "color":"#9966CC", "company_name":""}),
    ],
    subContractors: [
      UserLimitedModel.fromJson({"id":1239, "full_name":"Ajay Rathi", "company_name":"Ajay and Sons", "color":"magenta"}),
      UserLimitedModel.fromJson({"id":1241, "full_name":"Dikshit Kaushik", "company_name":"Dikshit mentions", "color":"#79443B"}),
    ],
    customer: CustomerModel.fromJson({"id":1408, "full_name":"Adrian Smitham", "full_name_mobile":"Adrian Smitham", "color":"#702963", "company_name":""}),
  );

  final tempSchedules = SchedulesModel(
    id: 1,
    title: 'Test Task',
    job: tempJob,
    reps: [
      UserLimitedModel.fromJson({"id":1234, "full_name":"Manveer Singh", "color":"#FE6F5E", "company_name":""}),
      UserLimitedModel.fromJson({"id":1408, "full_name":"Adrian Smitham", "color":"#702963", "company_name":""}),
      UserLimitedModel.fromJson({"id":1329, "full_name":"Ajay Sharma", "color":"#9966CC", "company_name":""}),
    ],
    subContractors: [
      UserLimitedModel.fromJson({"id":1241, "full_name":"Dikshit Kaushik", "company_name":"Dikshit mentions", "color":"#79443B"}),
    ],
    trades: [CompanyTradesModel.fromJson({"id":36, "name":"HOME SERVICES", "pivot":{"job_id":21801, "trade_id":36}})],
    workOrder: [
      AttachmentResourceModel(id: 1, name: "Work Order 1", type: "workorder"),
      AttachmentResourceModel(id: 2, name: "Work Order 2", type: "workorder"),
      AttachmentResourceModel(id: 3, name: "Work Order 3", type: "workorder"),
    ],
    materialList: [
      AttachmentResourceModel(id: 1, name: "Material 1", type: "material"),
      AttachmentResourceModel(id: 2, name: "Material 2", type: "material"),
      AttachmentResourceModel(id: 3, name: "Material 3", type: "material"),
    ],
    attachments: [
      AttachmentResourceModel(id: 1, name: "Attachment 1", type: "resource"),
      AttachmentResourceModel(id: 2, name: "Attachment 2", type: "resource"),
      AttachmentResourceModel(id: 3, name: "Attachment 3", type: "resource"),
      AttachmentResourceModel(id: 4, name: "Attachment 4", type: "resource"),
    ],
  );

  late Map<String, dynamic> tempInitialJson;

  group('In case of create event', () {

    EventFormService service = EventFormService(
        update: () {  },
        validateForm: () {  },
        jobModel: tempJob,
        pageType: EventFormType.createScheduleForm,
    );

    setUpAll(() {
      DateTimeHelper.setUpTimeZone();
      tempInitialJson = service.eventFormJson();
      service.isTitleEditedOnce = false;
      service.controller = EventFormController();
    });

    group('EventFormService should be initialized with correct data', () {
      test('Form fields should be initialized with correct values', () {
        expect(service.titleController.text, "");
        expect(service.tradesController.text, "");
        expect(service.companyCrewController.text, "");
        expect(service.labourContractorsController.text, "");
        expect(service.recurringFrequencyController.text, "Daily");
        expect(service.recurringOccurrencesController.text, "2");
      });

      test('Form toggles should be initialized with correct values', () {
        expect(service.isAllDayReminderSelected, false);
        expect(service.isUserNotificationSelected, false);
        expect(service.defaultRecurringSelected, false);
        expect(service.isRecurringSelected, false);
        expect(service.isTitleEditedOnce, false);
        expect(service.isOnlyThis, false);
      });

      test('Form data helper lists should be filled with correct data', () {
        expect(service.attachments.length, 0);
        expect(service.uploadedAttachments.length, 0);
        expect(service.notificationReminders.length, 0);
        expect(service.crewUsers.length, 0);
        expect(service.contractorsUsers.length, 0);
        expect(service.trades.length, 0);
      });

      test('Form data helpers should be initialized with correct values', () {
        expect(service.jobModel != null, true);
        expect(service.startDateTime?.isNotEmpty, true);
        expect(service.endDateTime?.isNotEmpty, true);
        expect(service.initialJson, <String, dynamic>{});
        expect(service.notificationReminders.length, 0);
        expect(service.attachments.length, 0);
        expect(service.uploadedAttachments.length, 0);
      });
    });

    test('EventFormService@setFormData() should set-up form values', () {
      service.setFormData();
      tempInitialJson = service.eventFormJson();
      expect(service.initialJson, tempInitialJson);
    });

    group('EventFormService@checkIfNewDataAdded() should check if any addition/update is made in form', () {
      String initialTitle = service.titleController.text;
      test('When no changes in form are made', () {
        service.initialJson = service.eventFormJson();
        initialTitle = service.titleController.text;
        final val = service.checkIfNewDataAdded();
        expect(val, false);
      });

      test('When changes in form are made', () {
        service.titleController.text = tempSchedules.title!;
        final val = service.checkIfNewDataAdded();
        expect(val, true);
      });

      test('When changes are reverted', () {
        service.titleController.text = initialTitle;
        final val = service.checkIfNewDataAdded();
        expect(val, false);
        service.titleController.text = "";
      });
    });

    group("EventFormService@setScheduleTitle should set-up title text values when title field has not been updated manually", () {
      service.isTitleEditedOnce = false;
      service.jobModel = tempJob;

      test('Title text fields should be not being initialized with any value', () {
        expect(service.titleController.text, "");
      });

      test('Title text fields should be initialized with data available in job', () {
        service.setScheduleTitle();
        expect(service.titleController.text, "Adrian Smitham / job # 112");
      });

      test('Title text fields should be initialized with name of selected company crew', () {
        service.crewUsers = tempCrewList;
        service.setScheduleTitle();
        expect(service.titleController.text, "User 1, User 2 / Adrian Smitham / job # 112");
      });


    group('EventFormService@checkIfSpecificFieldChanged should check if any specific field is changed', () {
      test('When no changes in form are made', () {
        service.initialJson = service.eventFormJson();
        expect(service.checkIfSpecificFieldChanged(), false);
      });

      test('When changes single field is changed', () {
        service.initialJson = service.eventFormJson();
        service.contractorsUsers = tempSubContractorList;
        expect(service.checkIfSpecificFieldChanged(), true);
      });

    test('When multiple fields changed', () {
      service.initialJson = service.eventFormJson();
      service.startDateTime = "2099-06-02";
      service.endDateTime = "2099-06-03";
      service.contractorsUsers = tempSubContractorList;
      
      expect(service.checkIfSpecificFieldChanged(), true);
    });

    test('When  unrelated fields changed', () {
      service.initialJson = service.eventFormJson();
      service.titleController.text = "2099-06-02";
      expect(service.checkIfSpecificFieldChanged(), false);
    });
  });

  
      test('Title text fields should be initialized with company name of selected labour/sub contractors', () {
        service.crewUsers = [];
        service.contractorsUsers = tempSubContractorList;
        service.setScheduleTitle();
        expect(service.titleController.text, "Company 1, Company 2 / Adrian Smitham / job # 112");
      });

      test('Title text fields should be initialized with selected trades', () {
        service.contractorsUsers = [];
        service.trades = tempTradeList;
        service.setScheduleTitle();
        expect(service.titleController.text, "Adrian Smitham / Trade 1 / job # 112");
      });

      test('Title text fields should be initialized with selected labour/sub contractors, company crew and trades', () {
        service.contractorsUsers = tempSubContractorList;
        service.crewUsers = tempCrewList;
        service.trades = tempTradeList;
        service.setScheduleTitle();
        expect(service.titleController.text, "Company 1, Company 2 / User 1, User 2 / Adrian Smitham / Trade 1 / job # 112");
      });

    });

    group("EventFormService@setScheduleTitle should set-up title text values when title field has been updated once manually", () {
      test('Title text fields should be initialized with updated text even labour/sub contractors or company crew or trades are not selected', () {
        service.titleController.text = "Title text has been updated manually";
        service.isTitleEditedOnce = true;
        service.jobModel = tempJob;
        service.contractorsUsers = [];
        service.crewUsers = [];
        service.trades = [];
        service.setScheduleTitle();
        expect(service.titleController.text, "Title text has been updated manually");
      });

      test('Title text fields should be initialized with updated text even labour/sub contractors or company crew or trades are selected', () {
        service.titleController.text = "Title text has been updated manually";
        service.isTitleEditedOnce = true;
        service.jobModel = tempJob;
        service.contractorsUsers = tempSubContractorList;
        service.crewUsers = tempCrewList;
        service.trades = tempTradeList;
        service.setScheduleTitle();
        expect(service.titleController.text, "Title text has been updated manually");
      });
    });

    group('EventFormService@toggleIsRecurringSelected() should toggle reminder notification type', () {
      test("When recurring reminder notification is not selected", () {
        service.toggleIsRecurringSelected(false);
        expect(service.isRecurringSelected, false);
      });

      test("When recurring reminder notification is selected", () {
        service.toggleIsRecurringSelected(true);
        expect(service.isRecurringSelected, true);
      });
    });

    test('EventFormService@removeAttachedItem() should remove attachment', () {
      service.attachments = tempSchedules.attachments!;
      service.removeAttachedItem(0);
      expect(service.attachments.length, 3);
    });

    group('EventFormService@isFieldEditable() should validate if the required form field is editable or not', () {

      test('Validation should pass when the form field is title', () {
        expect(service.isFieldEditable(FormFieldType.title), true);
      });

      test('Title form field edit-ability should fail when the date form is saving data', () {
        service.controller.toggleIsSavingForm();
        expect(service.isFieldEditable(FormFieldType.title), false);
      });

      test('Validation should pass when the form field is trade', () {
        service.controller.toggleIsSavingForm();
        expect(service.isFieldEditable(FormFieldType.trades), true);
      });

      test('Trade form field edit-ability should fail when the date form is saving data', () {
        service.controller.toggleIsSavingForm();
        expect(service.isFieldEditable(FormFieldType.trades), false);
      });

      test('Validation should pass when the form field is company crew', () {
        service.controller.toggleIsSavingForm();
        expect(service.isFieldEditable(FormFieldType.companyCrew), true);
      });

      test('Company crew form field edit-ability should fail when the date form is saving data', () {
        service.controller.toggleIsSavingForm();
        expect(service.isFieldEditable(FormFieldType.companyCrew), false);
      });

      test('Validation should pass when the form field is labour/sub contractor', () {
        service.controller.toggleIsSavingForm();
        expect(service.isFieldEditable(FormFieldType.subContractor), true);
      });

      test('labour/sub contractor form field edit-ability should fail when the date form is saving data', () {
        service.controller.toggleIsSavingForm();
        expect(service.isFieldEditable(FormFieldType.subContractor), false);
      });

    });

    ///   Validations

    group('EventFormService@validateTitle() should validate task title', () {

      test('Validation should fail when task title is empty', () {
        service.titleController.text = "";
        final val = service.validateTitle(service.titleController.text);
        expect(val, 'title_cant_be_left_blank'.tr);
      });

      test('Validation should fail when task title only contains empty spaces', () {
        service.titleController.text = "     ";
        final val = service.validateTitle(service.titleController.text);
        expect(val, 'title_cant_be_left_blank'.tr);
      });

      test('Validation should pass when title contains special characters', () {
        service.titleController.text = "#kpl& - /";
        final val = service.validateTitle(service.titleController.text);
        expect(val, null);
      });

      test('Validation should pass when task title is not-empty', () {
        service.titleController.text = "Title";
        final val = service.validateTitle(service.titleController.text);
        expect(val, null);
      });

    });

    group('EventFormService@modifyEndDateTime', () {

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

    group('EventFormService@validateScheduleEventTime() should validate', () {
      test('Validation should fail when end time is before from start time', () {
        service.endDateTime = "2023-10-14 02:40:00.000";
        service.startDateTime = "2023-10-14 03:40:00.000";
        final val = service.validateScheduleEventTime();
        expect(service.errorText, "end_time_must_be_greater_then_start_time".tr);
        expect(val, false);
      });

      test('Validation should pass when end time is after from start time', () {
        service.endDateTime = "2023-10-14 04:40:00.000";
        service.startDateTime = "2023-10-14 03:40:00.000";
        final val = service.validateScheduleEventTime();
        expect(service.errorText, null);
        expect(val, true);
      });
    });

    group('EventFormService@validateScheduleEventTime() should validate schedule time when AllDayReminder is enabled', () {
      test('Validation should fail when start date time is empty', () {
        service.isAllDayReminderSelected = true;
        service.startDateTime = "";
        final val = service.validateScheduleEventTime();
        expect(service.errorText, "please_provide_start_date_and_time".tr);
        expect(val, false);
      });

      test('Validation should pass when start date time is not empty', () {
        service.isAllDayReminderSelected = true;
        service.startDateTime = DateTime.now().toString();
        final val = service.validateScheduleEventTime();
        expect(service.errorText, null);
        expect(val, true);
      });
    });
    group('EventFormService@validateScheduleEventTime() should validate schedule time when AllDayReminder is disabled', () {

      test('Validation should fail when start date time is empty', () {
        service.isAllDayReminderSelected = false;
        service.startDateTime = "";
        final val = service.validateScheduleEventTime();
        expect(service.errorText, "please_provide_start_date_and_time".tr);
        expect(val, false);
      });

      test('Validation should fail when end date time is empty', () {
        service.isAllDayReminderSelected = false;
        service.startDateTime = DateTime.now().toString();
        service.endDateTime = "";
        final val = service.validateScheduleEventTime();
        expect(service.errorText, "please_provide_end_date_and_time".tr);
        expect(val, false);
      });

      test('Validation should fail when end date time is less then start date time', () {
        service.isAllDayReminderSelected = false;
        service.startDateTime = DateTime.now().toString();
        service.endDateTime = DateTime.now().subtract(const Duration(hours: 2)).toString();
        final val = service.validateScheduleEventTime();
        expect(service.errorText, "end_time_must_be_greater_then_start_time".tr);
        expect(val, false);
      });

      test('Validation should fail when start date time is equals to end date time', () {
        service.isAllDayReminderSelected = false;
        service.startDateTime = DateTime.now().toString();
        service.endDateTime = service.startDateTime;
        final val = service.validateScheduleEventTime();
        expect(service.errorText, "end_time_must_be_greater_then_start_time".tr);
        expect(val, false);
      });

      test('Validation should fail when OverLapped condition occurred', () {
        service.isAllDayReminderSelected = false;
        service.isRecurringSelected = true;
        service.startDateTime = DateTime.now().toString();
        service.endDateTime = DateTime.now().add(const Duration(hours: 28)).toString();
        service.selectedRecurringType = RecurringConstants.daily;
        final val = service.validateScheduleEventTime();
        expect(service.errorText, 'overlapped_schedules_are_not_allowed'.tr);
        expect(val, false);
      });

      test('Validation should pass when all checks are satisfied', () {
        service.isAllDayReminderSelected = false;
        service.isRecurringSelected = true;
        service.startDateTime = DateTime.now().toString();
        service.endDateTime = DateTime.now().add(const Duration(hours: 28)).toString();
        service.selectedRecurringType = RecurringConstants.weekly;
        final val = service.validateScheduleEventTime();
        expect(service.errorText, null);
        expect(val, true);
      });
      group('showChangesConfirmation should show dialog ', () {

        test('should show dialog when all checks are satisfied', () {
          service.pageType = EventFormType.editScheduleForm;
          service.eventFormJson()['date'] = 0;
          CompanySettingsService.setCompanySettings([{
            "key": CompanySettingConstants.showScheduleEditConfirmation,
            "value": "1"
          }]);
          
          bool result = service.showChangesConfirmation(false);

          expect(result, isTrue);
        });

        test('should not show dialog when saveSpecificField is true', () {
          service.pageType = EventFormType.editScheduleForm;
          service.eventFormJson()['date'] = 0;
          CompanySettingsService.setCompanySettings([{
            "key": CompanySettingConstants.showScheduleEditConfirmation,
            "value": "1"
          }]);
          
          bool result = service.showChangesConfirmation(true);

          expect(result, isFalse);
        });

        test('should not show dialog when showScheduleEditConfirmation is false from settings', () {
          service.pageType = EventFormType.editScheduleForm;
            service.eventFormJson()['date'] = 0;
            CompanySettingsService.setCompanySettings([{
              "key": CompanySettingConstants.showScheduleEditConfirmation,
              "value": "0"
            }]);
            
            bool result = service.showChangesConfirmation(true);

            expect(result, false);
        });

        test('should not show dialog when saveSpecificField is not changed', () {
          service.pageType = EventFormType.editScheduleForm;
          service.initialJson = service.eventFormJson();
          CompanySettingsService.setCompanySettings([{
            "key": CompanySettingConstants.showScheduleEditConfirmation,
            "value": "1"
          }]);
          
          bool result = service.showChangesConfirmation(true);

          expect(result, false);
        });

        test('should not show dialog when page type is different', () {
          service.pageType = EventFormType.createForm;
          service.eventFormJson()['date'] = 0;
          CompanySettingsService.setCompanySettings([{
            "key": CompanySettingConstants.showScheduleEditConfirmation,
            "value": "1"
          }]);
          
          bool result = service.showChangesConfirmation(true);

          expect(result, false);
        });
      });
    });
  });
}
