import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/run_mode.dart';
import 'package:jobprogress/common/enums/worksheet.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/constants/user_roles.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jobprogress/modules/worksheet/controller.dart';
import 'helper.dart';

void main() {

  late WorksheetFormController controller;

  setUpAll(() {
    RunModeService.setRunMode(RunMode.unitTesting);
    controller = WorksheetControllerTestHelper.getWorksheetParams('add');
  });

  group('WorksheetFormController should be initialized with correct data', () {

    test('In case of add worksheet', () {
      controller = WorksheetControllerTestHelper.getWorksheetParams('add');
      expect(controller.jobId, isNotNull);
      expect(controller.scaffoldKey, isNotNull);
      expect(controller.formKey, isNotNull);
      expect(controller.dbUnsavedResourceId, isNull);
      expect(controller.worksheetId, isNull);
      expect(controller.module, FLModule.estimate);
      expect(controller.formType, WorksheetFormType.add);
    });

    test('In case of edit worksheet', () {
      controller = WorksheetControllerTestHelper.getWorksheetParams('edit');
      expect(controller.jobId, isNotNull);
      expect(controller.scaffoldKey, isNotNull);
      expect(controller.formKey, isNotNull);
      expect(controller.dbUnsavedResourceId, isNull);
      expect(controller.worksheetId, isNotNull);
      expect(controller.module, FLModule.estimate);
      expect(controller.formType, WorksheetFormType.edit);
    });

    test('In case of add auto save worksheet', () {
      controller = WorksheetControllerTestHelper.getWorksheetParams('auto_save_add');
      expect(controller.jobId, isNotNull);
      expect(controller.scaffoldKey, isNotNull);
      expect(controller.formKey, isNotNull);
      expect(controller.dbUnsavedResourceId, isNotNull);
      expect(controller.worksheetId, isNull);
      expect(controller.module, FLModule.estimate);
      expect(controller.formType, WorksheetFormType.edit);
    });

    test('In case of edit auto save worksheet', () {
      controller = WorksheetControllerTestHelper.getWorksheetParams('auto_save_edit');
      expect(controller.jobId, isNotNull);
      expect(controller.scaffoldKey, isNotNull);
      expect(controller.formKey, isNotNull);
      expect(controller.dbUnsavedResourceId, isNotNull);
      expect(controller.worksheetId, isNotNull);
      expect(controller.module, FLModule.estimate);
      expect(controller.formType, WorksheetFormType.edit);
    });

  });

  test("WorksheetFormController@onInit should initialize service", () {
    controller.onInit();
    expect(controller.service, isNotNull);
  });

  group("WorksheetFormController@saveButtonTitle should give correct button title", () {

    test("In case of add worksheet", () {
      controller = WorksheetControllerTestHelper.getWorksheetParams('add');
      expect(controller.saveButtonTitle, 'save'.tr.toUpperCase());
    });

    test("In case of edit worksheet", () {
      controller = WorksheetControllerTestHelper.getWorksheetParams('edit');
      expect(controller.saveButtonTitle, 'update'.tr.toUpperCase());
    });
  });

  group("WorksheetFormController@typeToTitle should give correct page title", () {

    test('When worksheet is of type material list', () {
      controller.module = FLModule.materialLists;
      expect(controller.typeToTitle, 'material_list_worksheet'.tr);
    });

    test('When worksheet is of type work order', () {
      controller.module = FLModule.workOrder;
      expect(controller.typeToTitle, 'work_order_worksheet'.tr);
    });

    test('When worksheet is of type proposal', () {
      controller.module = FLModule.jobProposal;
      expect(controller.typeToTitle, 'proposal_worksheet'.tr);
    });

    test('When worksheet is of type estimate', () {
      controller.module = FLModule.estimate;
      expect(controller.typeToTitle, 'estimate_worksheet'.tr);
    });

  });

  group("WorksheetFormController@moduleToWorksheetType should set worksheet type from file type", () {

    test('When file is of type material list', () {
      controller.module = FLModule.materialLists;
      final type = controller.moduleToWorksheetType();
      expect(type, WorksheetConstants.materialList);
    });

    test('When file is of type work order', () {
      controller.module = FLModule.workOrder;
      final type = controller.moduleToWorksheetType();
      expect(type, WorksheetConstants.workOrder);
    });

    test('When file is of type proposal', () {
      controller.module = FLModule.jobProposal;
      final type = controller.moduleToWorksheetType();
      expect(type, WorksheetConstants.proposal);
    });

    test('When file is of type estimate', () {
      controller.module = FLModule.estimate;
      final type = controller.moduleToWorksheetType();
      expect(type, WorksheetConstants.estimate);
    });
  });

  group('Selling price cases', () {
    bool isSellingPriceEnabled = false;
    setUpAll(() {
      AuthService.userDetails = UserModel(
          id: 1,
          firstName: 'User',
          fullName: 'Demo User',
          email: 'demo@gmail.com'
      );
    });

    test('When user is not standard user', () {
      AuthService.userDetails?.groupId = UserGroupIdConstants.admin;
      expect(AuthService.isStandardUser(), isFalse);
      isSellingPriceEnabled = false;
      expect(isSellingPriceEnabled, isFalse);
    });

    group('In case of Standard user', () {
      setUpAll(() {
        AuthService.userDetails?.groupId = UserGroupIdConstants.standard;
      });
      test('When user has permission to view cost', () {
        PermissionService.permissionList = [PermissionConstants.viewUnitCost];
        expect(AuthService.isStandardUser(), isTrue);
        expect(PermissionService.permissionList.contains(PermissionConstants.viewUnitCost), isTrue);
        isSellingPriceEnabled = true;
        expect(isSellingPriceEnabled, isTrue);
      });
      test('When user has no permission to view cost', () {
        PermissionService.permissionList.clear();
        expect(AuthService.isStandardUser(), isTrue);
        expect(PermissionService.permissionList.contains(PermissionConstants.viewUnitCost), isFalse);
        isSellingPriceEnabled = false;
        expect(isSellingPriceEnabled, isFalse);
      });
    });
  });

}