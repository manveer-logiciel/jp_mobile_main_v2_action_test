import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/automation/automation.dart';
import 'package:jobprogress/common/models/automation/display_data.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/automation.dart';
import 'package:jobprogress/modules/automation_listing/controller.dart';

void main() {
    late AutomationListingController controller;

    setUpAll(() {
      controller = AutomationListingController();
      Get.put(controller);
    });

    group('AutomationListingController@isParticipantHadLoggedInUser should check if logged-in user is among participants', () {
      setUp(() {
        AuthService.userDetails = UserModel(
          id: 1, 
          firstName: 'Logged', 
          fullName: 'Logged User', 
          email: 'logged@example.com'
        );
      });

      test('Should returns true if logged-in user is among participants', () {
        List<UserLimitedModel> participants = [
          UserLimitedModel(id: 1, firstName: 'John', fullName: 'John Doe', email: 'john@example.com', groupId: 1)
        ];
        expect(controller.isParticipantHadLoggedInUser(participants: participants), isTrue);
      });

      test('Should returns false if logged-in user is not in participants', () {
        List<UserLimitedModel> participants = [
          UserLimitedModel(id: 2, firstName: 'Jane', fullName: 'Jane Doe', email: 'jane@example.com', groupId: 2)
        ];
        expect(controller.isParticipantHadLoggedInUser(participants: participants), isFalse);
      });

      test('Should returns false for an empty participants list', () {
        List<UserLimitedModel> participants = [];
        expect(controller.isParticipantHadLoggedInUser(participants: participants), isFalse);
      });

      test('Should returns false if participants list is null', () {
        expect(controller.isParticipantHadLoggedInUser(participants: null), isFalse);
      });

      test('Should returns true if logged-in user is included among multiple participants', () {
        List<UserLimitedModel> participants = [
          UserLimitedModel(id: 3, firstName: 'Alice', fullName: 'Alice Doe', email: 'alice@example.com', groupId: 1),
          UserLimitedModel(id: 1, firstName: 'John', fullName: 'John Doe', email: 'john@example.com', groupId: 2),
          UserLimitedModel(id: 4, firstName: 'Bob', fullName: 'Bob Smith', email: 'bob@example.com', groupId: 2),
        ];
        expect(controller.isParticipantHadLoggedInUser(participants: participants), isTrue);
      });
    });

    group('AutomationListingController@showActionButtons should check if createTasks or sendCustomerEmail is enabled in toStage', () {
      test('Should display action buttons if  createTasks is enabled in toStage', () {
        controller.automationList = [
          AutomationModel(
            id: 1,
            displayData: DisplayData(
              toStage: WorkFlowStageModel(createTasks: true, name: '', color: '', code: ''),
            ),
          ),
        ];

        expect(controller.showActionButtons(0), isTrue);
      });

      test('Should display action buttons if sendCustomerEmail is enabled in toStage', () {
        controller.automationList = [
          AutomationModel(
            id: 2,
            displayData: DisplayData(
              toStage: WorkFlowStageModel(sendCustomerEmail: true, name: '', color: '', code: ''),
            ),
          ),
        ];

        expect(controller.showActionButtons(0), isTrue);
      });

      test('Should display action buttons if Undo is enabled', () {
        controller.automationList = [
          AutomationModel(id: 3, enableUndo: true),
        ];

        expect(controller.showActionButtons(0), isTrue);
      });

      test('Should display action buttons if showReverted is enabled', () {
        controller.automationList = [
          AutomationModel(id: 4, showReverted: true),
        ];

        expect(controller.showActionButtons(0), isTrue);
      });

      test('Should display action buttons if multiple conditions are true', () {
        controller.automationList = [
          AutomationModel(
            id: 5,
            enableUndo: true,
            displayData: DisplayData(
              toStage: WorkFlowStageModel(createTasks: true, sendCustomerEmail: true, name: '', color: '', code: ''),
            ),
          ),
        ];

        expect(controller.showActionButtons(0), isTrue);
      });

      test('Should not display action buttons if all conditions are false', () {
        controller.automationList = [
          AutomationModel(
            id: 6,
            enableUndo: false,
            showReverted: false,
            displayData: DisplayData(
              toStage: WorkFlowStageModel(createTasks: false, sendCustomerEmail: false, name: '', color: '', code: ''),
            ),
          ),
        ];

        expect(controller.showActionButtons(0), isFalse);
      });

      test('Should not display action buttons if displayData and toStage are null', () {
        controller.automationList = [
          AutomationModel(
            id: 7,
            enableUndo: false,
            showReverted: false,
            displayData: null,
          ),
        ];

        expect(controller.showActionButtons(0), isFalse);
      });

      test('Should display action buttons if only one condition is true while others are null', () {
        controller.automationList = [
          AutomationModel(
            id: 8,
            enableUndo: null,
            showReverted: null,
            displayData: DisplayData(
              toStage: WorkFlowStageModel(createTasks: true, name: '', color: '', code: ''),
            ),
          ),
        ];

        expect(controller.showActionButtons(0), isTrue);
      });

      test('Should display action buttons if toStage is null but enableUndo is true', () {
        controller.automationList = [
          AutomationModel(
            id: 9,
            enableUndo: true,
            showReverted: null,
            displayData: DisplayData(toStage: null),
          ),
        ];

        expect(controller.showActionButtons(0), isTrue);
      });
    });

    group('AutomationListingController@undoButtonEnable should check if undo is enabled and action not reverted', () {
      test('Should display undo button if undo is enabled and action not reverted', () {
        controller.automationList = [
          AutomationModel(enableUndo: true, showReverted: false, id: 4),
        ];

        expect(controller.undoButtonEnable(0), isTrue);
      });

      test('Should not display undo button if undo is disabled and action not reverted', () {
        controller.automationList = [
          AutomationModel(enableUndo: false, showReverted: false, id: 5),
        ];

        expect(controller.undoButtonEnable(0), isFalse);
      });

      test('Should not display undo button if undo is enabled but action reverted', () {
        controller.automationList = [
          AutomationModel(enableUndo: true, showReverted: true, id: 6),
        ];

        expect(controller.undoButtonEnable(0), isFalse);
      });

      test('Should not display undo button if undo is disabled and action reverted', () {
        controller.automationList = [
          AutomationModel(enableUndo: false, showReverted: true, id: 7),
        ];

        expect(controller.undoButtonEnable(0), isFalse);
      });
    });

    group('AutomationListingController@showSkipSendButton should check if skip & send button should be displayed', () {
      test('Should display skip send button if tasks should be created and status is success', () {
        controller.automationList = [
          AutomationModel(
            displayData: DisplayData(
              toStage: WorkFlowStageModel(createTasks: true, name: 'Stage 1', code: 'S1', color: ''),
            ),
            enableUndo: true,
            automationStatus: AutomationConstants.succeeded,
            id: 1,
          ),
        ];

        expect(controller.showSkipSendButton(0), isTrue);
      });

      test('Should display skip send button if email should be sent and status is success', () {
        controller.automationList = [
          AutomationModel(
            displayData: DisplayData(
              toStage: WorkFlowStageModel(createTasks: false, sendCustomerEmail: true, name: 'Stage 1', code: 'S1', color: ''),
            ),
            automationStatus: AutomationConstants.succeeded,
            enableUndo: true,
            id: 2,
          ),
        ];

        expect(controller.showSkipSendButton(0), isTrue);
      });

      test('Should display skip send button if both tasks and email should be created and status is success', () {
        controller.automationList = [
          AutomationModel(
            displayData: DisplayData(
              toStage: WorkFlowStageModel(createTasks: true, sendCustomerEmail: true, name: 'Stage 1', code: 'S1', color: ''),
            ),
            automationStatus: AutomationConstants.succeeded,
            enableUndo: true,
            id: 3,
          ),
        ];

        expect(controller.showSkipSendButton(0), isTrue);
      });

      test('Should not display skip send button if neither tasks nor email should be created and status is success', () {
        controller.automationList = [
          AutomationModel(
            displayData: DisplayData(
              toStage: WorkFlowStageModel(createTasks: false, sendCustomerEmail: false, name: 'Stage 1', code: 'S1', color: ''),
            ),
            automationStatus: AutomationConstants.succeeded,
            id: 4,
          ),
        ];

        expect(controller.showSkipSendButton(0), isFalse);
      });

      test('Should not display skip send button if status is not success', () {
        controller.automationList = [
          AutomationModel(
            displayData: DisplayData(
              toStage: WorkFlowStageModel(createTasks: true, sendCustomerEmail: false, name: 'Stage 1', code: 'S1', color: ''),
            ),
            automationStatus: AutomationConstants.blocked,
            id: 5,
          ),
        ];

        expect(controller.showSkipSendButton(0), isFalse);
      });
    });
 
     group('AutomationListingController@hasTasksOrEmail should check if automation stage has task or email', () {
      test('Should return true if the automation stage has task and status is successful', () {
        controller.automationList = [
          AutomationModel(
            displayData: DisplayData(
              toStage: WorkFlowStageModel(createTasks: true, name: 'Stage 1', code: 'S1', color: ''),
            ),
            automationStatus: AutomationConstants.succeeded,
            enableUndo: true,
            id: 1,
          ),
        ];

        bool result = controller.hasTasksOrEmail(0);

        expect(result, isTrue);
      });

      test('Should return true if the automation stage has an email and status is successful', () {
        controller.automationList = [
          AutomationModel(
            displayData: DisplayData(
              toStage: WorkFlowStageModel(createTasks: false, sendCustomerEmail: true, name: 'Stage 1', code: 'S1', color: ''),
            ),
            automationStatus: AutomationConstants.succeeded,
            enableUndo: true,
            id: 2,
          ),
        ];

        bool result = controller.hasTasksOrEmail(0);

        expect(result, isTrue);
      });

      test('Should return true if both task  and email  are available, and status is successful', () {
        controller.automationList = [
          AutomationModel(
            displayData: DisplayData(
              toStage: WorkFlowStageModel(createTasks: true, sendCustomerEmail: true, name: 'Stage 1', code: 'S1', color: ''),
            ),
            automationStatus: AutomationConstants.succeeded,
            enableUndo: true,
            id: 3,
          ),
        ];

        bool result = controller.hasTasksOrEmail(0);

        expect(result, isTrue);
      });

      test('Should return false if neither task creation nor email sending are available, even if status is successful', () {
        controller.automationList = [
          AutomationModel(
            displayData: DisplayData(
              toStage: WorkFlowStageModel(createTasks: false, sendCustomerEmail: false, name: 'Stage 1', code: 'S1', color: ''),
            ),
            automationStatus: AutomationConstants.succeeded,
            id: 4,
          ),
        ];

        bool result = controller.hasTasksOrEmail(0);

        expect(result, isFalse);
      });

      test('Should return false if the status is not successful, regardless of task or email availability', () {
        controller.automationList = [
          AutomationModel(
            displayData: DisplayData(
              toStage: WorkFlowStageModel(createTasks: true, sendCustomerEmail: true, name: 'Stage 1', code: 'S1', color: ''),
            ),
            automationStatus: AutomationConstants.blocked,
            id: 5,
          ),
        ];

        bool result = controller.hasTasksOrEmail(0);

        expect(result, isFalse);
      });
    });

    group('AutomationListingController@setToStageByCode should set the automation stage to match the corresponding workflow stage', () {
      test('Should update the stage if there is a matching code in the workflow list', () {
        controller.workflowList = [
          WorkFlowStageModel(name: 'Stage 1', code: 'S1', color: ''),
          WorkFlowStageModel(name: 'Stage 2', code: 'S2', color: ''),
        ];

        controller.automationList = [
          AutomationModel(
            displayData: DisplayData(toStage: WorkFlowStageModel(code: 'S1', name: 'Old Stage', color: '')),
            id: 1,
          ),
        ];

        controller.setToStageEmailTaskCount(controller.workflowList, controller.automationList);

        expect(controller.automationList[0].displayData?.toStage?.name, 'Stage 1');
      });

      test('Should not update the stage if there is no matching code in the workflow list', () {
        controller.workflowList = [
          WorkFlowStageModel(name: 'Stage 1', code: 'S1', color: ''),
        ];

        controller.automationList = [
          AutomationModel(
            displayData: DisplayData(toStage: WorkFlowStageModel(code: 'S2', name: 'Old Stage', color: '')),
            id: 1,
          ),
        ];

        controller.setToStageEmailTaskCount(controller.workflowList, controller.automationList);

        expect(controller.automationList[0].displayData?.toStage?.name, 'Old Stage');
      });

      test('Should update all automation stages if there is a matching code in the workflow list', () {
        controller.workflowList = [
          WorkFlowStageModel(name: 'Stage 1', code: 'S1', color: ''),
          WorkFlowStageModel(name: 'Stage 2', code: 'S2', color: ''),
        ];

        controller.automationList = [
          AutomationModel(
            displayData: DisplayData(toStage: WorkFlowStageModel(code: 'S1', name: 'Old Stage', color: '')),
            id: 1,
          ),
          AutomationModel(
            displayData: DisplayData(toStage: WorkFlowStageModel(code: 'S2', name: 'Old Stage 2', color: '')),
            id: 2,
          ),
        ];

        controller.setToStageEmailTaskCount(controller.workflowList, controller.automationList);

        expect(controller.automationList[0].displayData?.toStage?.name, 'Stage 1');
        expect(controller.automationList[1].displayData?.toStage?.name, 'Stage 2');
      });

      test('Should not update any stage if the workflow list is empty', () {
        controller.workflowList = [];

        controller.automationList = [
          AutomationModel(
            displayData: DisplayData(toStage: WorkFlowStageModel(code: 'S1', name: 'Old Stage', color: '')),
            id: 1,
          ),
        ];

        controller.setToStageEmailTaskCount(controller.workflowList, controller.automationList);

        expect(controller.automationList[0].displayData?.toStage?.name, 'Old Stage');
      });

      test('Should not update any stage if the automation list is empty', () {
        controller.workflowList = [
          WorkFlowStageModel(name: 'Stage 1', code: 'S1', color: ''),
        ];

        controller.automationList = [];

        controller.setToStageEmailTaskCount(controller.workflowList, controller.automationList);

        expect(controller.automationList.isEmpty, isTrue);
      });

      test('Should update all automation stages that have a matching code in the workflow list', () {
        controller.workflowList = [
          WorkFlowStageModel(name: 'Stage 1', code: 'S1', color: ''),
        ];

        controller.automationList = [
          AutomationModel(
            displayData: DisplayData(toStage: WorkFlowStageModel(code: 'S1', name: 'Old Stage 1', color: '')),
            id: 1,
          ),
          AutomationModel(
            displayData: DisplayData(toStage: WorkFlowStageModel(code: 'S1', name: 'Old Stage 2', color: '')),
            id: 2,
          ),
        ];

        controller.setToStageEmailTaskCount(controller.workflowList, controller.automationList);

        expect(controller.automationList[0].displayData?.toStage?.name, 'Stage 1');
        expect(controller.automationList[1].displayData?.toStage?.name, 'Stage 1');
      });
    });
}

