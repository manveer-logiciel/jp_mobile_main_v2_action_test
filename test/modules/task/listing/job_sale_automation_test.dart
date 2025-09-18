import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/modules/job/job_sale_automation_task_listing/controller.dart';


void main(){
  final controller = JobSaleAutomationTaskLisitingController();

  List<UserLimitedModel> participants = [
    UserLimitedModel(
      id: 1, 
      firstName: 'Dikshit', 
      fullName: 'Dikshit Sharma', 
      email: 'dikshit.d.k.20022gmail.com', 
      groupId: 1
    )
  ];
  UserLimitedModel rep = UserLimitedModel(
    id: 1, 
    firstName: 'Rahul', 
    fullName: 'Rahul Sharma', 
    email: 'rahul.r.s@gmail.com', 
    groupId: 123
  ); 
  List<UserLimitedModel> reps = [
    UserLimitedModel(
      id: 3, 
      firstName: 'Shivani', 
      fullName: 'Shivani Sharma', 
      email: 'shivani.s.s@gmail.com', 
      groupId: 123
    )
  ];

  JobModel job =JobModel(
    id: 1, 
    customerId: 2,
    reps: reps,
    estimators: reps,
    subContractors: reps,
    customer: CustomerModel(
      rep: rep   
    )
  );

  List<TaskListModel> inheritedTaskList = [
    TaskListModel(
      id: 1, 
      title: '',
      participants: reps
    )
  ];
  
  List<TaskListModel> taskList = [
    TaskListModel(
      id: 1, 
      title: '',
      isDueDateReminder: true,
      participants: [],
      notifyUsers: [],
      initialParticipants: [],
      assignToSetting: ['customer_rep','company_crew','subs','estimators'],
      tasks: inheritedTaskList,
      notifyUserSetting: ['subs'],
    ),
    TaskListModel(
      id: 2, 
      title: '',
      participants: [],
      initialParticipants: [],
      isDueDateReminder: false
    )
  ];
  List<TaskListModel> taskList2 = [
    TaskListModel(
      id: 1, 
      title: '',
      dueDate: '22-11-2022',
      participants:participants, 
    ),
    TaskListModel(
      id: 2,
      title: '',
      dueDate: '23-11-2022',
      participants: participants
    )
  ]; 

  test('JobSaleAutomationTaskLisitingController should  be constructed with default values', () {
    expect(controller.hideSendButton, false);
    expect(controller.isDataValid, false);
    expect(controller.isLoading, true);
  });

  group('JobSaleAutomationTaskLisitingController@toggleCheckBox different test cases', (){
    test('When isChecked property of task list is true then changed isChecked into false',(){
       controller.toggleCheckBox(index: 0, taskList: taskList);
      expect(taskList[0].isChecked, false);
    });
    test('When isChecked property of task list is false then changed isChecked into true', (){
      controller.toggleCheckBox(index: 0, taskList: taskList);
      expect(taskList[0].isChecked, true);
    });
  });

  group('JobSaleAutomationTaskLisitingController@validateData different test cases', (){
    test('When all isChecked  property false should not validate data & change property isDataValid into true',(){
      taskList[0].isChecked = false;
      taskList[1].isChecked = false;
      controller.validateData(taskList);
      expect(taskList[0].isAssigneEmpty, false);
      expect(taskList[1].isAssigneEmpty, false);
      expect(taskList[0].isDueOnEmpty, false);
      expect(taskList[1].isDueOnEmpty, false);
      expect(controller.isDataValid, true);
    });
    test('When isChecked true,participants & due date is empty, isDueDateReminder true should return isAssignEmpty & isDue Emptytrue',(){
      taskList[0].isChecked = true;
      controller.validateData(taskList);
      expect(taskList[0].isAssigneEmpty, true);
      expect(taskList[0].isDueOnEmpty, true);
    });
    test('when isChecked true , participants & due date is empty, isDueDateReminder false then return isDueDateEmpty false', (){
      taskList[1].isChecked = true;
      controller.validateData(taskList);
      expect(taskList[1].isAssigneEmpty, true);
      expect(taskList[1].isDueOnEmpty, false);
    });
    test('when isChecked true && participants and due date had data should return isDataValid true & isAssignEmpty & isDueDateEmpty false',(){
      controller.validateData(taskList2);
      expect(taskList2[0].isAssigneEmpty, false);
      expect(taskList2[1].isAssigneEmpty, false);
      expect(taskList2[0].isDueOnEmpty, false);
      expect(taskList2[1].isDueOnEmpty, false);
      expect(controller.isDataValid, true);
    });
  });
  group('JobSaleAutomationTaskLisitingController@addUsers ', (){
    test('Should add participants from job when assignToSetting had different type of customer data', (){
      controller.addUsers(
        taskList[0].assignToSetting!,
        taskList[0].participants!,
        job
      );
      expect(taskList[0].participants!.length, 4);
    });
    test('should add notifyUser from job when notifyUserSetting had different type of customer data ', (){
      controller.addUsers(
        taskList[0].notifyUserSetting!,
        taskList[0].notifyUsers!,
        job
      );
      expect(taskList[0].notifyUsers!.length, 1);
    });
  });
  group('JobSaleAutomationTaskLisitingController@setInitialParticipants', () {
    test('Should populate initialParticipants with deep copies of participants', () {
      // Set up the task list with participants
      controller.taskList = taskList;

      // Call the method
      controller.setInitialParticipants();

      // Check that initialParticipants are correctly set with deep copies
      expect(controller.taskList[0].initialParticipants, isNotNull);
      expect(controller.taskList[0].initialParticipants!.length, 4);
      expect(controller.taskList[0].initialParticipants![0].id, equals(controller.taskList[0].participants![0].id));
      expect(controller.taskList[0].initialParticipants![0].fullName, equals(controller.taskList[0].participants![0].fullName));
      expect(controller.taskList[0].initialParticipants![1].id, equals(controller.taskList[0].participants![1].id));
      expect(controller.taskList[0].initialParticipants![1].fullName, equals(controller.taskList[0].participants![1].fullName));
    });
  });
  group('JobSaleAutomationTaskLisitingController@updateSendButtonVisibility', () {
    test('Should hide the send button if all tasks have send set to true', () {
      controller.taskList = [
        TaskListModel(id: 1, title: 'Task 1', send: true),
        TaskListModel(id: 2, title: 'Task 2', send: true),
      ];

      controller.updateSendButtonVisibility();

      expect(controller.hideSendButton, true);
    });

    test('Should not hide the send button if any task has send set to false', () {
      controller.taskList = [
        TaskListModel(id: 1, title: 'Task 1', send: true),
        TaskListModel(id: 2, title: 'Task 2', send: false),
      ];

      controller.updateSendButtonVisibility();

      expect(controller.hideSendButton, false);
    });

    test('Should not hide the send button if all tasks have send set to false', () {
      controller.taskList = [
        TaskListModel(id: 1, title: 'Task 1', send: false),
        TaskListModel(id: 2, title: 'Task 2', send: false),
      ];

      controller.updateSendButtonVisibility();

      expect(controller.hideSendButton, false);
    });
  });

  group('JobSaleAutomationTaskLisitingController@updateTaskParticipants', () {

    setUpAll(() {
      // Initialize controller and taskList before each test
      controller.taskList = [
       
        TaskListModel(
          id: 2,
          title: 'Task 2',
          participants: [
            UserLimitedModel(id: 2, firstName: 'Jane', fullName: 'Jane Smith', email: 'jane.smith@example.com', groupId: 2),
          ],
          initialParticipants: [
            UserLimitedModel(id: 2, firstName: 'Jane', fullName: 'Jane Smith', email: 'jane.smith@example.com', groupId: 2),
          ],
          send: false,
          isChecked: false,
          tasks: [
            TaskListModel(
              id: 1, 
              title: '',
            )
          ]
        ),
         TaskListModel(
          id: 1,
          title: 'Task 1',
          participants: [
            UserLimitedModel(id: 1, firstName: 'John', fullName: 'John Doe', email: 'john.doe@example.com', groupId: 1),
          ],
          initialParticipants: [
            UserLimitedModel(id: 1, firstName: 'John', fullName: 'John Doe', email: 'john.doe@example.com', groupId: 1),
          ],
          send: true,
          isChecked: false,
        ),
      ];
    });

    test('Should update task properties and send button visibility when participants are updated', () {
      // Set up initial conditions
      List<UserLimitedModel> prevTaskAssigned = [
        UserLimitedModel(id: 1, firstName: 'John', fullName: 'John Doe', email: 'john.doe@example.com', groupId: 1),
      ];
      List<UserLimitedModel> updatedTaskAssigned = [
        UserLimitedModel(id: 1, firstName: 'John', fullName: 'John Doe', email: 'john.doe@example.com', groupId: 1),
        UserLimitedModel(id: 2, firstName: 'Jane', fullName: 'Jane Smith', email: 'jane.smith@example.com', groupId: 2),
      ];
      // Call the method
      controller.updateTaskParticipants(0, controller.taskList[0], prevTaskAssigned);

      // Check updated values
      expect(controller.taskList[0].send, true);
      expect(controller.taskList[0].isChecked, false);
      expect(controller.hideSendButton, true);

      // Call again with updated participants to revert changes
      controller.updateTaskParticipants(0, controller.taskList[0], updatedTaskAssigned);

      // Check revert values
      expect(controller.taskList[0].send, true);
      expect(controller.taskList[0].isChecked, false);
      expect(controller.hideSendButton, true);
    });

    test('Should update task properties without changing send button visibility if initial participants match updated participants', () {
      // Set up initial conditions
      List<UserLimitedModel> prevTaskAssigned = [
        UserLimitedModel(id: 1, firstName: 'John', fullName: 'John Doe', email: 'john.doe@example.com', groupId: 1),
      ];
      List<UserLimitedModel> updatedTaskAssigned = [
        UserLimitedModel(id: 1, firstName: 'John', fullName: 'John Doe', email: 'john.doe@example.com', groupId: 1),
      ];

      // Set initial participants to match updated participants
      controller.taskList[0].initialParticipants = updatedTaskAssigned;

      // Call the method
      controller.updateTaskParticipants(0, controller.taskList[0], prevTaskAssigned);

      // Check updated values
      expect(controller.taskList[0].send, true);
      expect(controller.taskList[0].isChecked, false);
      expect(controller.hideSendButton, true);
    });

    test('Should not update task properties if previous and updated participants are the same', () {
      // Set up initial conditions
      List<UserLimitedModel> prevTaskAssigned = [
        UserLimitedModel(id: 1, firstName: 'John', fullName: 'John Doe', email: 'john.doe@example.com', groupId: 1),
      ];

      // Set initial participants and updated participants to be the same
      controller.taskList[0].participants = prevTaskAssigned;
      controller.taskList[0].initialParticipants = prevTaskAssigned;

      // Call the method
      controller.updateTaskParticipants(0, controller.taskList[0], prevTaskAssigned);

      // Check values remain unchanged
      expect(controller.taskList[0].send, true);
      expect(controller.taskList[0].isChecked, false);
      expect(controller.hideSendButton, true);
    });
  });
}