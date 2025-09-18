import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/cj_list_type.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/job_production_board.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/job/index.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/user_roles.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';

void main(){
  
  setUpAll((){
    AuthService.userDetails = UserModel(
      id: -1, 
      firstName: "Jay", 
      fullName: "Jaideep", 
      email: "Jay@test.com",
    );
  });

  group('Quick actions list when User is Sub contractor prime', (){

    test('Not contains Reinstate job option', (){
      AuthService.userDetails?.groupId = UserGroupIdConstants.subContractorPrime;
      JobModel job = JobModel(id: -1, customerId: 1, jobLostDate: DateTime.now().toString());
      List<JPQuickActionModel> results = JobService.getQuickActionList(job,listType: CJListType.job);

      expect(results.any((element) => element.id == "reinstate_job"), false);
    });

  });

  group('Quick actions list when User is not Sub contractor prime', (){


    test('Contains Reinstate job option', (){

      AuthService.userDetails?.groupId = UserGroupIdConstants.admin;
      JobModel job = JobModel(id: 1, customerId: 2, jobLostDate: DateTime.now().toString());
      List<JPQuickActionModel> results = JobService.getQuickActionList(job,listType: CJListType.job);

      expect(results.any((element) => element.id == "reinstate_job"), true);
    });

  });


  group("'Add to progress board' quick action should be displayed conditionally as per 'Manage Progress board' permission", () {

    setUp(() {
      List<String> permissionList = [
        "manage_progress_board",
      ];

      PermissionService.permissionList = permissionList;
      
    });


    test("When user has 'Manage Progress board' permission, 'Add to progress board' quick action should be displayed when job is not added in progress board", (){
      JobModel job = JobModel(id: 1, customerId: 2, productionBoards: null);
      List<JPQuickActionModel> results = JobService.getQuickActionList(job, listType: CJListType.job);

      expect(results.any((element) => element.id == "add_to_progress"), isTrue);

    });

    test("When user has 'Manage Progress board, 'Add to progress board' quick action should not be displayed when job is already added in progress board", (){
      JobProductionBoardModel board = JobProductionBoardModel(id: 1, name: "Unit test board");
      JobModel job = JobModel(id: 1, customerId: 2, productionBoards: [board]);
      List<JPQuickActionModel> results = JobService.getQuickActionList(job, listType: CJListType.job);

      expect(results.any((element) => element.id == "add_to_progress"), isFalse);

    });

    test("When user don't have 'Manage Progress board, 'Add to progress board' quick action should not be displayed.", (){
      PermissionService.permissionList.clear();
      JobProductionBoardModel board = JobProductionBoardModel(id: 1, name: "Unit test board");
      JobModel job = JobModel(id: 1, customerId: 2, productionBoards: [board]);
      List<JPQuickActionModel> results = JobService.getQuickActionList(job, listType: CJListType.job);

      expect(results.any((element) => element.id == "add_to_progress"), isFalse);

    });
    
  });

  group("'In progress board' quick action should be displayed conditionally as per 'View Progress board' permission", () {

    setUp(() {
      List<String> permissionList = [
        "view_progress_board",
      ];

      PermissionService.permissionList = permissionList;
      
    });


    test("When user has 'View Progress board' permission, 'In progress board' quick action should not be displayed when job is not added in progress board", (){
      JobModel job = JobModel(id: 1, customerId: 2, productionBoards: null);
      List<JPQuickActionModel> results = JobService.getQuickActionList(job, listType: CJListType.job);

      expect(results.any((element) => element.id == "in_progress_boards"), isFalse);

    });

    test("When user has 'View Progress board' permission, 'In progress board' quick action should be displayed when job is not added in progress board", (){
      JobProductionBoardModel board = JobProductionBoardModel(id: 1, name: "Unit test board");
      JobModel job = JobModel(id: 1, customerId: 2, productionBoards: [board]);
      List<JPQuickActionModel> results = JobService.getQuickActionList(job, listType: CJListType.job);

      expect(results.any((element) => element.id == "in_progress_boards"), isTrue);

    });

    test("When user don't have 'View Progress board' permission, 'In progress board' quick action should not be displayed", (){
      PermissionService.permissionList.clear();
      JobModel job = JobModel(id: 1, customerId: 2, productionBoards: null);
      List<JPQuickActionModel> results = JobService.getQuickActionList(job, listType: CJListType.job);

      expect(results.any((element) => element.id == "in_progress_boards"), isFalse);

    });
    
  });

  
}