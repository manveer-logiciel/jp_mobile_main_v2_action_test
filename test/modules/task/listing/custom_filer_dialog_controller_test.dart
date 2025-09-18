import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/task_listing/task_listing_filter.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/modules/task/custom_fliter_dialog/controller.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  TaskListingFilterModel filterModel = TaskListingFilterModel();
  TaskListingDialogController? controller;

  UserModel tempUser = UserModel(
      id: 0,
      firstName: 'User 1',
      fullName: 'User 1',
      email: '1@gmail.com');

  JobModel tempJob = JobModel(id: 123, customerId: 123,
      currentStage: WorkFlowStageModel(name: '', color: '', code: ''),
      altId: 'Alt143', name: 'Kabira', number: '123', divisionCode: '786'
  );

  setUpAll(() {
    controller = TaskListingDialogController(filterModel, tempJob.id, (params) {}, [tempUser]);
  });

  group('TaskListingDialogController@updateResetButtonDisable should toggle disability of reset button', () {
    test('Reset button should be disable when no changes are made in filter fields', () {
      expect(controller?.isResetButtonDisable(), true);
    });

    test('Reset button should not be disable when any change is made in filter fields', () {
      controller?.filterKeys.includeLockedTask = true;
      expect(controller?.isResetButtonDisable(), false);
    });
  });
}