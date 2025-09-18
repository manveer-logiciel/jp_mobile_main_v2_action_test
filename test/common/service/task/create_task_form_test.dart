import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/form_field_type.dart';
import 'package:jobprogress/common/enums/form_toggles.dart';
import 'package:jobprogress/common/enums/task_form_type.dart';
import 'package:jobprogress/common/enums/tasks.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/common/services/task/create_task_form.dart';
import 'package:jobprogress/core/constants/user_type_list.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';

void main() {

  CreateTaskFormService service = CreateTaskFormService(
      update: () { }, // method used to update ui directly from service so empty function can be used in testing
      validateForm: () { } // method used to validate form using form key with is ui based, so can be passes empty for unit testing
  );

  late CreateTaskFormService serviceWithTask;

  List<JPMultiSelectModel> tempUserList = [
    JPMultiSelectModel(label: 'User 1', id: '1', isSelect: true,
        child: const JPProfileImage(src: "profilePic", initial: "U1",)),
    JPMultiSelectModel(label: 'User 2', id: '2', isSelect: true,
        child: const JPProfileImage(src: "profilePic", initial: "U2",)),
    JPMultiSelectModel(label: 'User 3', id: '3', isSelect: false,
        child: const JPProfileImage(src: "profilePic", initial: "U3",)),
    JPMultiSelectModel(label: 'User 4', id: '4', isSelect: false,
        child: const JPProfileImage(src: "profilePic", initial: "U4",)),
    JPMultiSelectModel(label: 'User 5', id: '5', isSelect: false,
        child: const JPProfileImage(src: "profilePic", initial: "U5",)),
    JPMultiSelectModel(label: 'User 6', id: '6', isSelect: false,
        child: const JPProfileImage(src: "profilePic", initial: "U6",)),
  ];

  JobModel? tempJob = JobModel(id: 1, customerId: 2, name: 'Test Job', number: '123-456');

  final tempTask = TaskListModel(
      id: 1,
      title: 'Test Task',
      job: tempJob,
      sendAsEmail: true,
      sendAsMessage: false,
      isDueDateReminder: true,
      reminderType: 'day',
      dueDate: '2022-05-28',
      reminderFrequency: '2',
      participants: [
        UserLimitedModel(id: 1, firstName: 'User 1', fullName: 'User 1', email: 'user1@gmail.com', groupId: 1),
        UserLimitedModel(id: 2, firstName: 'User 2', fullName: 'User 2', email: 'user2@gmail.com', groupId: 2),
        UserLimitedModel(id: 3, firstName: 'User 3', fullName: 'User 3', email: 'user3@gmail.com', groupId: 3),
      ],
      notifyUsers: [
        UserLimitedModel(id: 1, firstName: 'User 1', fullName: 'User 1', email: 'user1@gmail.com', groupId: 1),
        UserLimitedModel(id: 2, firstName: 'User 2', fullName: 'User 2', email: 'user2@gmail.com', groupId: 2),
      ],
      attachments: [
        AttachmentResourceModel(id: 1),
        AttachmentResourceModel(id: 2),
        AttachmentResourceModel(id: 3),
        AttachmentResourceModel(id: 4),
      ],
  );

  late Map<String, dynamic> tempInitialJson;

  setUpAll(() {
    tempInitialJson = service.taskFormJson();
    serviceWithTask = CreateTaskFormService(
      update: () { }, // method used to update ui directly from service so empty function can be used in testing
      validateForm: () { }, // method used to validate form using form key with is ui based, so can be passes empty for logical testing
      task: tempTask,
    );
  });

  group('In case of create task', () {

    group('CreateTaskFormService should be initialized with correct data', () {

      test('Form fields should be initialized with correct values', () {
        expect(service.titleController.text, "");
        expect(service.usersController.text, "");
        expect(service.jobController.text, "");
        expect(service.dueOnController.text, "");
        expect(service.notesController.text, "");
        expect(service.notifyUsersController.text, "");
        expect(service.reminderFrequencyController.text, "1");
        expect(service.reminderTypeController.text, "");
      });

      test('Form toggles should be initialized with correct values', () {
        expect(service.isHighPriorityTask, false);
        expect(service.emailNotification, false);
        expect(service.messageNotification, false);
        expect(service.isDueDateReminder, false);
        expect(service.isReminderNotificationSelected, false);
      });

      test('Form data helper lists should be filled with correct data', () {
        expect(service.attachments.length, 0);
        expect(service.uploadedAttachments.length, 0);
        expect(service.users.length, 0);
        expect(service.notifyUsers.length, 0);
      });

      test('Form data helpers should be initialized with correct values', () {
        expect(service.jobModel, null);
        expect(service.reminderTypeId, 'day');
        expect(service.groupVal, ReminderNotificationType.recurring);
        expect(service.initialJson, <String, dynamic>{});
        expect(service.reminderTypes.length, 4);
        expect(service.reminderBeforeDueDateTypes.length, 3);
      });

    });

    test('CreateTaskFormService@setFormData() should set-up form values', () {

      service.setFormData();

      final tempReminderType = SingleSelectHelper.getSelectedSingleSelectValue(
        service.selectedReminderList,
        service.reminderTypeId,
      );

      expect(service.initialJson, tempInitialJson);
      expect(service.reminderTypeController.text, tempReminderType);

    });

    test('CreateTaskFormService@taskFormJson() should generate json from form-data', () {

      final tempJson = service.taskFormJson();
      expect(tempInitialJson, tempJson);

    });

    group('CreateTaskFormService@checkIfNewDataAdded() should check if any addition/update is made in form', () {

      String initialTitle = service.titleController.text;

      test('When no changes in form are made', () {
        final val = service.checkIfNewDataAdded();
        expect(val, false);
      });

      test('When changes in form are made', () {
        service.titleController.text = tempTask.title;
        final val = service.checkIfNewDataAdded();
        expect(val, true);
      });

      test('When changes are reverted', () {
        service.titleController.text = initialTitle;
        final val = service.checkIfNewDataAdded();
        expect(val, false);
      });
    });

    group('CreateTaskFormService@validateAndUpdateReminderTime() should validate and update reminder time', () {


      group('When reminder notification is turned off', () {
        test('When reminder time is empty', () {
          service.toggleIsReminderNotificationSelected(false);
          service.reminderFrequencyController.text = "";
          service.validateAndUpdateReminderTime();
          expect(service.reminderFrequencyController.text, '1');
        });
      });

      group('When reminder notification is turned on', () {

        group('When reminder time is not empty', () {

          group('In case hour is selected', () {

            test('Value less then equal 24 should be accepted', () {
              service.reminderFrequencyController.text = "12";
              service.reminderTypeId = service.reminderTypes[0].id;
              service.validateAndUpdateReminderTime();
              expect(service.reminderFrequencyController.text, '12');
            });

            test('Value greater than 24 should not be accepted', () {
              service.reminderFrequencyController.text = "28";
              service.reminderTypeId = service.reminderTypes[0].id;
              service.validateAndUpdateReminderTime();
              expect(service.reminderFrequencyController.text, '24');
            });

          });

          group('In case day is selected', () {

            test('Value less then equal 31 should be accepted', () {
              service.reminderFrequencyController.text = "12";
              service.reminderTypeId = service.reminderTypes[1].id;
              service.validateAndUpdateReminderTime();
              expect(service.reminderFrequencyController.text, '12');
            });

            test('Value greater than 31 should not be accepted', () {
              service.reminderFrequencyController.text = "35";
              service.reminderTypeId = service.reminderTypes[1].id;
              service.validateAndUpdateReminderTime();
              expect(service.reminderFrequencyController.text, '31');
            });

          });

          group('In case week is selected', () {

            test('Value less then equal 52 should be accepted', () {
              service.reminderFrequencyController.text = "12";
              service.reminderTypeId = service.reminderTypes[2].id;
              service.validateAndUpdateReminderTime();
              expect(service.reminderFrequencyController.text, '12');
            });

            test('Value greater than 52 should not be accepted', () {
              service.reminderFrequencyController.text = "350";
              service.reminderTypeId = service.reminderTypes[2].id;
              service.validateAndUpdateReminderTime();
              expect(service.reminderFrequencyController.text, '52');
            });

          });

          group('In case month is selected', () {

            test('Value less then equal 12 should be accepted', () {
              service.reminderFrequencyController.text = "12";
              service.reminderTypeId = service.reminderTypes[3].id;
              service.validateAndUpdateReminderTime();
              expect(service.reminderFrequencyController.text, '12');
            });

            test('Value greater than 12 should not be accepted', () {
              service.reminderFrequencyController.text = "35";
              service.reminderTypeId = service.reminderTypes[3].id;
              service.validateAndUpdateReminderTime();
              expect(service.reminderFrequencyController.text, '12');
            });

          });

        });

        test('When reminder time is empty', () {
          service.toggleIsReminderNotificationSelected(true);
          service.reminderFrequencyController.text = "";
          service.validateAndUpdateReminderTime();
          expect(service.reminderFrequencyController.text, '1');
        });
      });

    });

    group('CreateTaskFormService@toggleReminderNotificationType() should toggle reminder notification type', () {

      test("When recurring reminder notification is selected", () {

        service.toggleReminderNotificationType(ReminderNotificationType.recurring);
        expect(service.isDueDateReminder, false);
        expect(service.reminderTypeId, service.selectedReminderList[0].id);
        expect(service.reminderFrequencyController.text, '1');

      });

      test("When due date reminder notification is selected", () {

        service.toggleReminderNotificationType(ReminderNotificationType.beforeDueDate);
        expect(service.isDueDateReminder, true);
        expect(service.reminderTypeId, service.selectedReminderList[0].id);
        expect(service.reminderFrequencyController.text, '1');

      });

    });

    group('CreateTaskFormService@toggleIsHighPriorityTask() should toggle high priority selection', () {

      test("High priority should be selected", () {
        service.toggleIsHighPriorityTask(false);
        expect(service.isHighPriorityTask, true);
      });

      test("High priority should be un-selected", () {
        service.toggleIsHighPriorityTask(true);
        expect(service.isHighPriorityTask, false);
      });
    });

    group('CreateTaskFormService@toggleEmailNotification() should toggle email notification selection', () {

      test("Email notification should be selected", () {
        service.toggleEmailNotification(false);
        expect(service.emailNotification, true);
      });

      test("Email notification should be un-selected", () {
        service.toggleEmailNotification(true);
        expect(service.emailNotification, false);
      });
    });

    group('CreateTaskFormService@toggleMessageNotification() should toggle message notification selection', () {

      test("Message notification should be selected", () {
        service.toggleMessageNotification(false);
        expect(service.messageNotification, true);
      });

      test("Message notification should be un-selected", () {
        service.toggleMessageNotification(true);
        expect(service.messageNotification, false);
      });
    });

    group('CreateTaskFormService@toggleIsReminderNotificationSelected() should toggle reminder notification selection', () {

      test("Reminder notification should be selected", () {
        service.toggleIsReminderNotificationSelected(true);
        expect(service.isReminderNotificationSelected, true);
      });

      test("Reminder notification should be un-selected", () {
        service.toggleIsReminderNotificationSelected(false);
        expect(service.isReminderNotificationSelected, false);
      });
    });

    test('CreateTaskFormService@removeSelectedUser() should unselect selected user', () {
        service.removeSelectedUser(tempUserList[0]);
        expect(tempUserList[0].isSelect, false);
    });

    test('CreateTaskFormService@removeSelectedNotifyUser() should unselect selected notify user', () {
      service.notifyUsers = tempUserList;
        service.removeSelectedUser(tempUserList[1]);
        expect(service.notifyUsers[1].isSelect, false);
    });

    test('CreateTaskFormService@removeJob() should remove selected job', () {
      service.jobModel = tempJob;
      service.removeJob();
      expect(service.jobModel, null);
      expect(service.jobController.text, "");
    });

    test('CreateTaskFormService@removeAttachedItem() should remove attachment', () {
      service.attachments = tempTask.attachments!;
      service.removeAttachedItem(0);
      expect(service.attachments.length, 3);
    });

    group('CreateTaskFormService@validateTitle() should validate task title', () {

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

    group('CreateTaskFormService@validateAssignTo() should validate task assignee', () {

      test('Validation should fail when task assignee is not selected', () {
        final val = service.validateAssignTo(service.usersController.text);
        expect(val, 'task_must_be_assigned_to_some_one'.tr);
      });

      test('Validation should fail when task assignee field is empty', () {
        service.usersController.text = "";
        final val = service.validateAssignTo(service.usersController.text);
        expect(val, 'task_must_be_assigned_to_some_one'.tr);
      });

      test('Validation should fail when task assignee field is filled & and no-selected assignee', () {
        service.usersController.text = "";
        final val = service.validateAssignTo(service.usersController.text);
        expect(val, 'task_must_be_assigned_to_some_one'.tr);
      });

      test('Validation should pass when task assignee is selected & task assignee field is filled', () {
        service.users = tempUserList;
        service.users.first.isSelect = true;
        final val = service.validateAssignTo(service.usersController.text);
        expect(val, null);
      });

    });

    group('CreateTaskFormService@validateDueOn() should validate due on date', () {

      group('Validation should pass when reminder notification is off', () {

        test('When due on field value is filled', () {
          service.dueOnController.text = "2022-08-05";
          service.toggleIsReminderNotificationSelected(false);
          service.isDueDateReminder = false;
          final val = service.validateDueOn(service.dueOnController.text);
          expect(val, null);
        });

        test('When due on field value is empty', () {
          service.dueOnController.text = "";
          service.toggleIsReminderNotificationSelected(false);
          service.isDueDateReminder = false;
          final val = service.validateDueOn(service.dueOnController.text);
          expect(val, null);
        });

        test('When before due date is selected & due on field value is empty', () {
          service.dueOnController.text = "";
          service.toggleIsReminderNotificationSelected(false);
          service.isDueDateReminder = true;
          final val = service.validateDueOn(service.dueOnController.text);
          expect(val, null);
        });

      });

      group('In case of reminder notification', () {

        test("When recurring is selected validation should not fail", () {
          service.dueOnController.text = "";
          service.toggleIsReminderNotificationSelected(false);
          service.isDueDateReminder = false;
          final val = service.validateDueOn(service.dueOnController.text);
          expect(val, null);
        });

        test("When due date reminder is selected & due date field is not-empty(contains empty string), validation should fail", () {
          service.dueOnController.text = "  ";
          service.toggleIsReminderNotificationSelected(true);
          service.isDueDateReminder = true;
          final val = service.validateDueOn(service.dueOnController.text);
          expect(val, 'due_date_is_required_for_before_due_date_reminder'.tr);
        });

        test("When due date reminder is selected & due date field is not-empty, validation should fail", () {
          service.dueOnController.text = "2022-08-22";
          service.toggleIsReminderNotificationSelected(true);
          service.isDueDateReminder = true;
          final val = service.validateDueOn(service.dueOnController.text);
          expect(val, null);
        });

        test("When due date reminder selected & due date field is empty, validation should fail", () {
          service.dueOnController.text = "";
          service.toggleIsReminderNotificationSelected(true);
          service.isDueDateReminder = true;
          final val = service.validateDueOn(service.dueOnController.text);
          expect(val, 'due_date_is_required_for_before_due_date_reminder'.tr);
        });
      });

    });

    group('CreateTaskFormService@validateReminderFrequency() should validate reminder frequency', () {

      group('When reminder notification is turned off', () {
        test('Validation should pass when reminder frequency field is empty', () {
          service.toggleIsReminderNotificationSelected(false);
          service.reminderFrequencyController.text = "";
          final val = service.validateReminderFrequency(service.reminderFrequencyController.text);
          expect(val, null);
        });

        test('Validation should pass when reminder frequency field is not-empty', () {
          service.reminderFrequencyController.text = "12";
          final val = service.validateReminderFrequency(service.reminderFrequencyController.text);
          expect(val, null);
        });

        test('Validation should fail when reminder frequency field is filled empty spaces', () {
          service.reminderFrequencyController.text = "   ";
          final val = service.validateReminderFrequency(service.reminderFrequencyController.text);
          expect(val, null);
        });
      });

      group('When reminder notification is turned on', () {
        test('Validation should fail when reminder frequency field is empty', () {
          service.reminderFrequencyController.text = "";
          service.toggleIsReminderNotificationSelected(true);
          final val = service.validateReminderFrequency(service.reminderFrequencyController.text);
          expect(val, 'enter_valid_value'.tr);
        });

        test('Validation should pass when reminder frequency field is not-empty', () {
          service.reminderFrequencyController.text = "12";
          service.toggleIsReminderNotificationSelected(true);
          final val = service.validateReminderFrequency(service.reminderFrequencyController.text);
          expect(val, null);
        });

      });

    });

    group('CreateTaskFormService should show reminder filter accordingly to selected reminder type', () {

      test('When recurring reminder notification is selected', () {
        service.isDueDateReminder = false;
        expect(service.selectedReminderList, service.reminderTypes);
      });

      test('When recurring reminder notification is selected', () {
        service.isDueDateReminder = true;
        expect(service.selectedReminderList, service.reminderBeforeDueDateTypes);
      });

    });

    group('CreateTaskFormService@getStageCode() should return stage code', () {
    test('Should returns task stage code if valid', () {
      TaskListModel task = TaskListModel(
        stage: WorkFlowStageModel(code: "T123", name: '', color: ''), 
        id: -1, 
        title: ''
      );
      
      expect(service.getStageCode(task, null), equals("T123"));
    });

    test('Should returns jobModel currentStage code if task stage code is invalid', () {
      TaskListModel task = TaskListModel(
        stage: WorkFlowStageModel(code: "", name: '', color: ''), 
        id: -1, 
        title: ''
      );
      JobModel job = JobModel(
        currentStage: WorkFlowStageModel(code: "J123", name: '', color: ''), 
        id: -1, 
      customerId: -1);
      
      expect(service.getStageCode(task, job), equals("J123"));
    });

    test('Should returns task stageCode if stage and jobModel currentStage codes are invalid', () {
      TaskListModel task = TaskListModel(
        stageCode: 'J123',
        stage: null, 
        id: -1, 
        title: ''
      );
      JobModel job = JobModel(
        currentStage: WorkFlowStageModel(code: "", name: '', color: ''), 
        id: -1, 
        customerId: -1, 
      );
      
      expect(service.getStageCode(task, job), equals("J123"));
    });

    test('Should returns empty string if all potential codes are null or empty', () {
      TaskListModel task = TaskListModel(
        stageCode: '',
        stage: null, 
        id: -1, 
        title: ''
      );
      JobModel job = JobModel(
        currentStage: WorkFlowStageModel(code: "", name: '', color: ''), 
        id: -1, 
        customerId: -1, 
      );
      
      expect(service.getStageCode(task, job), isEmpty);
    });

    test('Should handles null task and jobModel', () {
      expect(service.getStageCode(null, null), isEmpty);
    });
  });

    group('CreateTaskFormService@setUserTypeList should set user type list', () {
      test('Should add  sales rep user Type only when job is multi job', () {
        List<JPMultiSelectModel> users = <JPMultiSelectModel>[];
        JobModel jobModel = JobModel(isMultiJob: true, id: -1, customerId: -1);
        JPMultiSelectModel expectedUser = UserTypeConstants.userTypeList.firstWhere((element) => element.id == '-1');
        
        service.jobModel = jobModel;
        service.setUserTypeList(users);

        expect(users.first, equals(expectedUser));
      });

      test('Should add all user userType when job is not multijob', () {
        List<JPMultiSelectModel> users = <JPMultiSelectModel>[];
        JobModel jobModel = JobModel(isMultiJob: false, id: -1, customerId: -1);
        List<JPMultiSelectModel> expectedUsers = UserTypeConstants.userTypeList;
        
        service.jobModel = jobModel;
        service.setUserTypeList(users);

        expect(users, equals(expectedUsers));
      });

      test('Should not add user type when job is not available', () {
        List<JPMultiSelectModel> users = <JPMultiSelectModel>[];
        
        service.jobModel = null;
        service.setUserTypeList(users);

        expect(users, isEmpty);
      });

    test('Should select user type when selectedUsers is not empty and valid', () {
      List<JPMultiSelectModel> users = <JPMultiSelectModel>[];
      List<String> selectedUsers = ["company_crew"];
      JobModel jobModel = JobModel(isMultiJob: false, id: -1, customerId: -1);
      service.jobModel = jobModel;
      
      service.setUserTypeList(users, selectedUsers: selectedUsers, isTaskTemplate: true);
      var selected = users.where((user) => user.isSelect).toList();
      
      expect(selected.length, equals(1));
      expect(selected.first.id, equals("-3"));
    });

    test('Should not select user type when selectedUsers is not valid', () {
      List<JPMultiSelectModel> users = <JPMultiSelectModel>[];
      List<String> selectedUsers = ["invalid user type"];
      JobModel jobModel = JobModel(isMultiJob: false, id: -1, customerId: -1);
      service.jobModel = jobModel;
      
      service.setUserTypeList(users, selectedUsers: selectedUsers, isTaskTemplate: true);
      var selected = users.where((user) => user.isSelect).toList();
      
      expect(selected, isEmpty);
    });

    test('Should not select user type when selectedUsers is empty and task is not from a template', () {
      List<JPMultiSelectModel> users = <JPMultiSelectModel>[];
      List<String> selectedUsers = [];
      
      service.setUserTypeList(users, selectedUsers: selectedUsers, isTaskTemplate: false);

      expect(users.where((user) => user.isSelect).isEmpty, isTrue);
    });
    });

    group('CreateTaskFormService@isLockStageVisible should manage visibility of ', () {
      test('Lock stage should be hidden when job is not available', () {
        service.jobModel = null;
        expect(service.isLockStageVisible, false);
      });

      test('Lock stage should be hidden when job is available and parentId is not available', () {
        service.jobModel = tempJob;
        expect(service.isLockStageVisible, false);
      });

      test('Lock stage should be hidden when job is available and parentId is available', () {
        service.jobModel = service.jobModel?..parentId = 10;
        expect(service.isLockStageVisible, false);
      });

      test('Lock stage should be hidden when job is available and stages is available', () {
        service.jobModel = service.jobModel?..stages = [WorkFlowStageModel(name: 'JP Stage 1', color: 'cl-blue', code: '0001')];
        expect(service.isLockStageVisible, false);
      });

      test('Lock stage should be hidden when job is available and is multi job', () {
        service.jobModel = service.jobModel?..isMultiJob = false;
        expect(service.isLockStageVisible, false);
      });

      test('Lock stage should be visible when job is available and user has permission to mark task unlock', () {
        List<String> permissionList = ["mark_task_unlock"];
        PermissionService.permissionList = permissionList;
        expect(service.isLockStageVisible, true);
      });

      test('Lock stage should be visible when job is available and current stage of the job is not equal to last stage of the job', () {
        service.jobModel = service.jobModel?..currentStage = WorkFlowStageModel(name: 'JP Stage 2', color: 'cl-blue', code: '0002');
        expect(service.isLockStageVisible, true);
      });

      test('Lock stage should be hidden when job is available and current stage of the job is equal to last stage of the job', () {
        service.jobModel = service.jobModel?..currentStage = WorkFlowStageModel(name: 'JP Stage 1', color: 'cl-blue', code: '0001');
        expect(service.isLockStageVisible, false);
      });
    });

  });

  group('In case of edit/update task', () {

    group('CreateTaskFormService should be initialized with correct data', () {

      test('Form fields should be filled with correct values', () {
        serviceWithTask.setFormData();

        final reminderType = SingleSelectHelper.getSelectedSingleSelectValue(
          serviceWithTask.selectedReminderList,
          serviceWithTask.reminderTypeId,
        );

        expect(serviceWithTask.titleController.text, tempTask.title);
        expect(serviceWithTask.usersController.text, "");
        expect(serviceWithTask.dueOnController.text, DateTimeHelper.convertHyphenIntoSlash(serviceWithTask.task!.dueDate ?? ''));
        expect(serviceWithTask.dueOnDate, DateTime.parse(serviceWithTask.task!.dueDate.toString()));
        expect(serviceWithTask.notesController.text, "");
        expect(serviceWithTask.notifyUsersController.text, "");
        expect(serviceWithTask.reminderFrequencyController.text, "2");
        expect(serviceWithTask.reminderTypeController.text, reminderType);
      });

      test('Form toggles should be filled with correct values', () {
        expect(serviceWithTask.isHighPriorityTask, false);
        expect(serviceWithTask.emailNotification, true);
        expect(serviceWithTask.messageNotification, false);
        expect(serviceWithTask.isDueDateReminder, true);
        expect(serviceWithTask.isReminderNotificationSelected, true);
      });

      test('Form data helper lists should be filled with correct data', () {
        expect(serviceWithTask.attachments.length, 3);
        expect(serviceWithTask.uploadedAttachments.length, 3);
        expect(serviceWithTask.users.length, 0);
        expect(serviceWithTask.notifyUsers.length, 0);
      });

      test('Form data helpers should be initialized with correct values', () {
        expect(serviceWithTask.jobModel, tempJob);
        expect(serviceWithTask.reminderTypeId, 'day');
        expect(serviceWithTask.groupVal, ReminderNotificationType.beforeDueDate);
        expect(serviceWithTask.initialJson, serviceWithTask.taskFormJson());
        expect(serviceWithTask.reminderTypes.length, 4);
        expect(serviceWithTask.reminderBeforeDueDateTypes.length, 3);
      });
    });

    group('Saving form data in an object of TaskListModel', () {

      test("CreateTaskFormService.jsonToTaskListingModel() method, should convert form field's data to an object of TaskListModel", () {
        service.users = tempUserList;
        TaskListModel task = serviceWithTask.jsonToTaskListingModel(
            serviceWithTask.taskFormJson(),
            tempUserList,
            tempUserList);

        expect(task.id, 1);
        expect(task.title, "Test Task");
        expect(task.jobId, 1);
        expect(task.isDueDateReminder, true);
        expect(task.dueDate, "2022-05-28");
        expect(task.isHighPriorityTask, false);
        expect(task.notes, "");
        expect(task.sendAsEmail, true);
        expect(task.sendAsMessage, false);
        expect(task.reminderType, "day");
        expect(task.reminderFrequency, "2");
        expect(task.locked, false);
        expect(task.stageCode, "0001");
      });
    });

  });

  group('Form field edit ability', () {

    test('In case page type is create form, then all fields should be editable', () {
      service = CreateTaskFormService(
        update: () {  },
        validateForm: () { },
        pageType: TaskFormType.createForm,
      );

      expect(service.isFieldEditable(FormFieldType.title), true);
      expect(service.isFieldEditable(FormFieldType.assignedTo), true);
      expect(service.isFieldEditable(FormFieldType.linkJob), true);
      expect(service.isFieldEditable(FormFieldType.dueOn), true);
      expect(service.isFieldEditable(FormFieldType.highPriority), true);
      expect(service.isFieldEditable(FormFieldType.note), true);
      expect(service.isFieldEditable(FormFieldType.notifyUsers), true);
      expect(service.isFieldEditable(FormFieldType.sendCopy), true);
      expect(service.isFieldEditable(FormToggles.remindNotification), true);
      expect(service.isFieldEditable(FormFieldType.reminderDuration), true);
      expect(service.isFieldEditable(FormFieldType.remindMe), true);
      expect(service.isFieldEditable(FormFieldType.attachments), true);
      expect(service.isFieldEditable(FormToggles.stageLock), true);
    });

    test('In case page type is edit form, then only assignedTo, linkJob, and sendCopy fields should not be editable', () {
      service = CreateTaskFormService(
        update: () {  },
        validateForm: () { },
        pageType: TaskFormType.editForm,
      );

      expect(service.isFieldEditable(FormFieldType.title), true);
      expect(service.isFieldEditable(FormFieldType.assignedTo), false);
      expect(service.isFieldEditable(FormFieldType.linkJob), false);
      expect(service.isFieldEditable(FormFieldType.dueOn), true);
      expect(service.isFieldEditable(FormFieldType.highPriority), true);
      expect(service.isFieldEditable(FormFieldType.note), true);
      expect(service.isFieldEditable(FormFieldType.notifyUsers), true);
      expect(service.isFieldEditable(FormFieldType.sendCopy), false);
      expect(service.isFieldEditable(FormToggles.remindNotification), true);
      expect(service.isFieldEditable(FormFieldType.reminderDuration), true);
      expect(service.isFieldEditable(FormFieldType.remindMe), true);
      expect(service.isFieldEditable(FormFieldType.attachments), true);
      expect(service.isFieldEditable(FormToggles.stageLock), true);
    });

    test('In case page type is progress board create form, then only linkJob fields should not be editable', () {
      service = CreateTaskFormService(
        update: () {  },
        validateForm: () { },
        pageType: TaskFormType.progressBoardCreate,
      );

      expect(service.isFieldEditable(FormFieldType.title), true);
      expect(service.isFieldEditable(FormFieldType.assignedTo), true);
      expect(service.isFieldEditable(FormFieldType.linkJob), false);
      expect(service.isFieldEditable(FormFieldType.dueOn), true);
      expect(service.isFieldEditable(FormFieldType.highPriority), true);
      expect(service.isFieldEditable(FormFieldType.note), true);
      expect(service.isFieldEditable(FormFieldType.notifyUsers), true);
      expect(service.isFieldEditable(FormFieldType.sendCopy), true);
      expect(service.isFieldEditable(FormToggles.remindNotification), true);
      expect(service.isFieldEditable(FormFieldType.reminderDuration), true);
      expect(service.isFieldEditable(FormFieldType.remindMe), true);
      expect(service.isFieldEditable(FormFieldType.attachments), true);
      expect(service.isFieldEditable(FormToggles.stageLock), true);
    });

    test('In case page type is progress board edit form, then only assignedTo, linkJob, and sendCopy fields should not be editable', () {
      service = CreateTaskFormService(
        update: () {  },
        validateForm: () { },
        pageType: TaskFormType.progressBoardEdit,
      );

      expect(service.isFieldEditable(FormFieldType.title), true);
      expect(service.isFieldEditable(FormFieldType.assignedTo), false);
      expect(service.isFieldEditable(FormFieldType.linkJob), false);
      expect(service.isFieldEditable(FormFieldType.dueOn), true);
      expect(service.isFieldEditable(FormFieldType.highPriority), true);
      expect(service.isFieldEditable(FormFieldType.note), true);
      expect(service.isFieldEditable(FormFieldType.notifyUsers), true);
      expect(service.isFieldEditable(FormFieldType.sendCopy), false);
      expect(service.isFieldEditable(FormToggles.remindNotification), true);
      expect(service.isFieldEditable(FormFieldType.reminderDuration), true);
      expect(service.isFieldEditable(FormFieldType.remindMe), true);
      expect(service.isFieldEditable(FormFieldType.attachments), true);
      expect(service.isFieldEditable(FormToggles.stageLock), true);
    });

    test('In case page type is edit form, then only title, linkJob, note and attachments fields should not be editable', () {
      service = CreateTaskFormService(
        update: () {  },
        validateForm: () { },
        pageType: TaskFormType.salesAutomation,
      );

      expect(service.isFieldEditable(FormFieldType.title), false);
      expect(service.isFieldEditable(FormFieldType.assignedTo), true);
      expect(service.isFieldEditable(FormFieldType.linkJob), false);
      expect(service.isFieldEditable(FormFieldType.dueOn), true);
      expect(service.isFieldEditable(FormFieldType.highPriority), true);
      expect(service.isFieldEditable(FormFieldType.note), false);
      expect(service.isFieldEditable(FormFieldType.notifyUsers), true);
      expect(service.isFieldEditable(FormFieldType.sendCopy), true);
      expect(service.isFieldEditable(FormToggles.remindNotification), true);
      expect(service.isFieldEditable(FormFieldType.reminderDuration), true);
      expect(service.isFieldEditable(FormFieldType.remindMe), true);
      expect(service.isFieldEditable(FormFieldType.attachments), false);
      expect(service.isFieldEditable(FormToggles.stageLock), true);
    });

  });

  group('CreateTaskFormService attachment type handling - verifies dynamic attachment type usage with fallback to "resource"', () {
    late CreateTaskFormService testService;

    setUp(() {
      testService = CreateTaskFormService(
        update: () {},
        validateForm: () {},
      );
    });

    test('should use attachment type from model when available', () {
      // Arrange
      testService.attachments = [
        AttachmentResourceModel(id: 1, type: 'image'),
        AttachmentResourceModel(id: 2, type: 'document'),
      ];

      // Act
      final json = testService.taskFormJson();

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
      final json = testService.taskFormJson();

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
      final json = testService.taskFormJson();

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