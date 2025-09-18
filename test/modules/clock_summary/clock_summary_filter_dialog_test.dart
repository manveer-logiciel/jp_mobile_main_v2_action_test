
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/clock_summary.dart';
import 'package:jobprogress/common/models/clock_summary/clock_summary_request_params.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/user_roles.dart';
import 'package:jobprogress/modules/clock_summary/listing/widgets/filter_dialog/controller.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../files_listing/file_listing_test.dart';

void main() {

  ClockSummaryRequestParams filterKeys = ClockSummaryRequestParams(
    users: [JPMultiSelectModel(label: 'user', id: '0', isSelect: true)],
    divisions: [JPMultiSelectModel(label: 'division', id: '0', isSelect: true)],
    tradeTypes: [JPMultiSelectModel(label: 'tradeType', id: '0', isSelect: true)],
    customerType: [JPMultiSelectModel(label: 'customerType', id: '0', isSelect: true)],
  );

  test('ClockSummaryFilterController should be initialized with following values', (){
    final controller = ClockSummaryFilterController(filterKeys);
    expect(controller.durationsList.length, 5);
    expect(controller.usersController.text, '');
    expect(controller.divisionsController.text, '');
    expect(controller.tradeTypesController.text, '');
    expect(controller.customerTypeController.text, '');
    expect(controller.dateController.text, '');
  });

  test('ClockSummaryFilterController should set filter values', (){
    final controller = ClockSummaryFilterController(filterKeys);

    controller.setFilterValues(filterKeys);
    expect(controller.usersController.text, 'user');
    expect(controller.divisionsController.text, 'division');
    expect(controller.tradeTypesController.text, 'tradeType');
    expect(controller.customerTypeController.text, 'customerType');
    expect(controller.dateController.text, '');
    expect(controller.selectedDuration, "DurationType.mtd");
  });

  test('ClockSummaryFilterController should set duration filter', (){
    final controller = ClockSummaryFilterController(filterKeys);

    controller.setDurationFilter('DurationType.mtd');
    expect(controller.selectedDuration, 'DurationType.mtd');
    expect(controller.tempFilterKeys.durationType, DurationType.mtd);

  });

  group('ClockSummaryFilterController should set input field text from selected filters', (){
    final controller = ClockSummaryFilterController(filterKeys);

    test('When single value is selected', () {
      String val = controller.getInputFieldText(filterKeys.users!);
      expect(val, 'user');
    });

    test('When multiple values are selected', () {
      String val = controller.getInputFieldText(filterKeys.users! + filterKeys.users!);
      expect(val, 'user, user');
    });

  });

  group('ClockSummaryFilterController should disable reset button', (){
    final controller = ClockSummaryFilterController(filterKeys);

    test('When tempkeys are not similar to filter keys', () {
      bool val = controller.isResetButtonDisabled(filterKeys);
      expect(val, false);
    });

    test('When tempkeys are similar to filter keys', () {
      controller.tempFilterKeys = filterKeys;
      bool val = controller.isResetButtonDisabled(filterKeys);
      expect(val, true);
    });

  });

  test('ClockSummaryFilterController should disable job filter', (){

    final controller = ClockSummaryFilterController(filterKeys..jobId = 1);
    expect(controller.isJobDisabled(), true);

  });

  test('ClockSummaryFilterController should disable division filter', (){

    final controller = ClockSummaryFilterController(filterKeys..jobName = 'without_job');
    expect(controller.isDivisionDisabled(), true);

  });

  test('ClockSummaryFilterController should not disable user filter', (){

    final controller = ClockSummaryFilterController(filterKeys..userName = 'user');
    expect(controller.isUsersDisabled(), false);

  });

  test('ClockSummaryFilterController should hide duration filter', (){

    final controller = ClockSummaryFilterController(filterKeys..date = '05/11/2022');
    expect(controller.isDateFieldVisible(), true);

  });

  group("ClockSummaryFilterController should enable user field", () {

    final controller = ClockSummaryFilterController(filterKeys);

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({
        "user": jsonEncode(userJson),
      });
      await AuthService.getLoggedInUser();
    });

    test('ClockSummaryFilterController should not enable user filter when login user is Prime SubUser', () {
      AuthService.userDetails?.groupId = UserGroupIdConstants.subContractorPrime;
      expect(controller.isUsersDisabled(), true);
    });

    test('ClockSummaryFilterController should enable user filter when login user is not Prime SubUser', () {
      AuthService.userDetails?.groupId = UserGroupIdConstants.admin;
      expect(controller.isUsersDisabled(), false);
    });

    test('ClockSummaryFilterController should not enable user filter when login user does not have permission to view clockIn clockOut report', () {
      expect(controller.isUsersDisabled(), false);
    });

    test('ClockSummaryFilterController should enable user filter when login user have permission to view clockIn clockOut report', () {
      PermissionService.permissionList = ["view_clock_in_clock_out_report"];
      expect(controller.isUsersDisabled(), true);
    });
  });

}