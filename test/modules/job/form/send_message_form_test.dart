import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/core/constants/user_type_list.dart';
import 'package:jobprogress/global_widgets/send_message/controller.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SendMessageFormController? controller;

  JobModel tempJob = JobModel(id: 123, customerId: 123,
    currentStage: WorkFlowStageModel(name: '', color: '', code: ''),
    altId: 'Alt143', name: 'Kabira', number: '123', divisionCode: '786'
  );

  setUpAll(() {
    controller = SendMessageFormController(jobData: tempJob);
  });

  test("SendMessageFormController@removeJob() should remove selected job ", () {
    controller?.removeJob();
    expect(controller?.jobData, isNull);
  });

   group('SendMessageFormController@getParticipantIdsOnUserType should return participant ids based on user type', () {
    test('Should return an empty list when job is not available', () {
      List<String> userTypeIds = [UserTypeConstants.customerRep];

      List<String>? result = controller?.getParticipantIdsOnUserType(null, userTypeIds);

      expect(result, isEmpty);
    });

    test('Should return an empty list when userTypeIds is not available', () {
      JobModel job = JobModel(id: -1, customerId: -1);

      List<String>? result = controller?.getParticipantIdsOnUserType(job, null);

      expect(result, isEmpty);
    });

    test('Should return an empty list when userTypeIds is an empty list', () {
      JobModel job = JobModel(id: -1, customerId: -1);

      List<String>? result = controller?.getParticipantIdsOnUserType(job, []);

      expect(result, isEmpty);
    });

    test('Should return an empty list when job does not contain any participants', () {
      JobModel job = JobModel(id: -1, customerId: -1);
      List<String> userTypeIds = [UserTypeConstants.customerRep];

      List<String>? result = controller?.getParticipantIdsOnUserType(job, userTypeIds);

      expect(result, isEmpty);
    });

    test('Should return an empty list when userTypeIds does not match with any job user type', () {
      JobModel job = JobModel(
        reps: [UserLimitedModel(id: 1, firstName: '', fullName: '', email: '', groupId: -1)], 
        id: -1, 
        customerId: -1,
      );
      List<String> userTypeIds = [UserTypeConstants.companyCrew];

      List<String>? result = controller?.getParticipantIdsOnUserType(job, userTypeIds);

      expect(result, isEmpty);
    });

    test('Should return a list with participant IDs when job contains participants for a single user type', () {
      JobModel job = JobModel(
        reps: [
          UserLimitedModel(id: 1, firstName: '', fullName: '', email: '', groupId: -1),
          UserLimitedModel(id: 2, firstName: '', fullName: '', email: '', groupId: -1)
        ], 
        id: -1, 
        customerId: -1,
      );
      List<String> userTypeIds = [UserTypeConstants.customerRep, UserTypeConstants.companyCrew];
      List<String> expected = ['1', '2'];

      List<String>? result = controller?.getParticipantIdsOnUserType(job, userTypeIds);

      expect(result, expected);
    });

    test('should return a list with participant IDs when job contains multiple valid user types', () {
      JobModel job = JobModel(
        reps: [
          UserLimitedModel(id: 1, firstName: '', fullName: '', email: '', groupId: -1),
        ],
        workCrew: [
          UserLimitedModel(id: 2, firstName: '', fullName: '', email: '', groupId: -1)
        ], 
        id: -1, 
        customerId: -1,
      );
      List<String> userTypeIds = [
        UserTypeConstants.customerRep,
        UserTypeConstants.companyCrew,
      ];
      List<String> expected = ['1', '2'];

      List<String>? result = controller?.getParticipantIdsOnUserType(job, userTypeIds);

      expect(result, expected);
    });

    test('should return an empty list for each user type when job has no participants for any type', () {
      JobModel job = JobModel(id: -1, customerId: -1);
      List<String> userTypeIds = [
        UserTypeConstants.customerRep,
        UserTypeConstants.companyCrew,
        UserTypeConstants.estimator,
        UserTypeConstants.subs,
      ];

      List<String>? result = controller?.getParticipantIdsOnUserType(job, userTypeIds);

      expect(result, isEmpty);
    });

    test('should return a list of all participant IDs for each user type when job has participants for all types', () {
      JobModel job = JobModel(
        reps: [
          UserLimitedModel(id: 1, firstName: '', fullName: '', email: '', groupId: -1),
        ],
        workCrew: [
          UserLimitedModel(id: 2, firstName: '', fullName: '', email: '', groupId: -1)
        ], 
        estimators: [
          UserLimitedModel(id: 3, firstName: '', fullName: '', email: '', groupId: -1)
        ],
        subContractors: [
          UserLimitedModel(id: 4, firstName: '', fullName: '', email: '', groupId: -1),
          UserLimitedModel(id: 5, firstName: '', fullName: '', email: '', groupId: -1)
        ],
        id: -1, 
        customerId: -1,
      );
      final userTypeIds = [
        UserTypeConstants.customerRep,
        UserTypeConstants.companyCrew,
        UserTypeConstants.estimator,
        UserTypeConstants.subs,
      ];
      List<String> expected = ['1', '2', '3', '4', '5'];

      List<String>? result = controller?.getParticipantIdsOnUserType(job, userTypeIds);

      expect(result, expected);
    });   
  });
  group('SendMessageFormController@setUserTypeList should set user type list', () {
      test('Should add  sales rep user Type only when job is multi job', () {
        List<JPMultiSelectModel> users = <JPMultiSelectModel>[];
        JobModel jobModel = JobModel(isMultiJob: true, id: -1, customerId: -1);
        JPMultiSelectModel expectedUser = UserTypeConstants.userTypeList.firstWhere((element) => element.id == '-1');
        
        controller?.jobData = jobModel;
        controller?.setUserTypeList(users);

        expect(users.first, equals(expectedUser));
      });

      test('Should add all user userType when job is not multijob', () {
        List<JPMultiSelectModel> users = <JPMultiSelectModel>[];
        JobModel jobModel = JobModel(isMultiJob: false, id: -1, customerId: -1);
        List<JPMultiSelectModel> expectedUsers = UserTypeConstants.userTypeList;
        
        controller?.jobData = jobModel;
        controller?.setUserTypeList(users);

        expect(users, equals(expectedUsers));
      });

      test('Should not add user type when job is not available', () {
        List<JPMultiSelectModel> users = <JPMultiSelectModel>[];
        
        controller?.jobData = null;
        controller?.setUserTypeList(users);

        expect(users, isEmpty);
      });
    });


}