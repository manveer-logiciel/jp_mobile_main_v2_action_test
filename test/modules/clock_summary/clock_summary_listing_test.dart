
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/clock_summary.dart';
import 'package:jobprogress/common/models/clock_summary/clock_summary_request_params.dart';
import 'package:jobprogress/common/models/clock_summary/clock_summary_timelog.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/modules/clock_summary/listing/controller.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../files_listing/file_listing_test.dart';

void main() {

  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({
      "user": jsonEncode(userJson),
    });
    AuthService.userDetails = UserModel.fromJson(userJson);
  });

  test("ClockSummaryController should be initialized with following value", () {

    final controller = ClockSummaryController();

    expect(controller.isLoading, true);
    expect(controller.isLoadMore, false);
    expect(controller.isLoadMore, false);
    expect(controller.selectedGroupByFilter, 'job');
    expect(controller.selectedSortByFilter, 'start_date_time');
    expect(controller.sortByFilter.isEmpty, true);
    expect(controller.timeLogs.isEmpty, true);
    expect(controller.timeEntries.isEmpty, true);
    expect(controller.appliedFiltersList.isEmpty, true);
    expect(controller.totalHours, null);
    expect(controller.startDate, null);
    expect(controller.endDate, null);
    expect(controller.listingType, ClockSummaryListingType.groupBy);
  });

  test('requestParams should be initialized with following values', () async {

    final controller = ClockSummaryController();
    controller.requestParams.users = [
      JPMultiSelectModel(label: 'User', id: '0', isSelect: true)
    ];
    final today = DateTime.now();
    final startDate = DateTime(today.year, today.month, 1);
    await controller.initParams();

    expect(controller.requestParams.durationType, DurationType.mtd);
    expect(controller.requestParams.page, 1);
    expect(controller.requestParams.withOutJobEntries, 0);
    expect(controller.requestParams.sortBy, 'job_id');
    expect(controller.requestParams.sortOrder, 'asc');
    expect(controller.requestParams.group, 'job');
    expect(controller.requestParams.startDate, DateTimeHelper.format(startDate, DateFormatConstants.dateServerFormat));
    expect(controller.requestParams.endDate, DateTimeHelper.format(today, DateFormatConstants.dateServerFormat));
    expect(controller.appliedFiltersList.length, 2);
    expect(controller.defaultParams, controller.requestParams);

  });

  group('setDuration function should set startdate and enddate correctly', () {

    final controller = ClockSummaryController();
    final today = DateTime.now();

    test('In case of DurationType.wtd', () {
      controller.requestParams.durationType = DurationType.wtd;
      controller.setDuration();

      final startDate = today.subtract(Duration(days: today.weekday));
      final endDate = today;

      expect(controller.requestParams.startDate, DateTimeHelper.format(startDate, DateFormatConstants.dateServerFormat));
      expect(controller.requestParams.endDate, DateTimeHelper.format(endDate, DateFormatConstants.dateServerFormat));

    });

    test('In case of DurationType.mtd', () {
      controller.requestParams.durationType = DurationType.mtd;
      controller.setDuration();

      final startDate = DateTime(today.year, today.month, 1);
      final endDate = today;

      expect(controller.requestParams.startDate, DateTimeHelper.format(startDate, DateFormatConstants.dateServerFormat));
      expect(controller.requestParams.endDate, DateTimeHelper.format(endDate, DateFormatConstants.dateServerFormat));

    });

    test('In case of DurationType.ytd', () {
      controller.requestParams.durationType = DurationType.ytd;
      controller.setDuration();

      final startDate = DateTime(today.year, 1, 1);
      final endDate = today;

      expect(controller.requestParams.startDate, DateTimeHelper.format(startDate, DateFormatConstants.dateServerFormat));
      expect(controller.requestParams.endDate, DateTimeHelper.format(endDate, DateFormatConstants.dateServerFormat));

    });

    test('In case of Last Month', () {
      controller.requestParams.durationType = DurationType.lastMonth;
      controller.setDuration();

      final startDate = DateTime(today.year, today.month - 1, 1);
      final endDate = today.subtract(Duration(days: today.day));

      expect(controller.requestParams.startDate, DateTimeHelper.format(startDate, DateFormatConstants.dateServerFormat));
      expect(controller.requestParams.endDate, DateTimeHelper.format(endDate, DateFormatConstants.dateServerFormat));

    });

  });

  group('onApplyFilter should filter data with an api request', () {

    final controller = ClockSummaryController();
    final users = [
      JPMultiSelectModel(label: 'user', id: '0', isSelect: true)
    ];
    final division = [
      JPMultiSelectModel(label: 'division', id: '0', isSelect: true)
    ];
    final tradeTypes = [
      JPMultiSelectModel(label: 'tradeType', id: '0', isSelect: true)
    ];

    test('When filter carries default values', () async {
      controller.onApplyFilter(ClockSummaryRequestParams());

      final today = DateTime.now();
      final startDate = DateTime(today.year, today.month, 1);
      await controller.initParams();

      expect(controller.requestParams.durationType, DurationType.mtd);
      expect(controller.requestParams.page, 1);
      expect(controller.requestParams.withOutJobEntries, 0);
      expect(controller.requestParams.sortBy, 'job_id');
      expect(controller.requestParams.sortOrder, 'asc');
      expect(controller.requestParams.group, 'job');
      expect(controller.requestParams.startDate, DateTimeHelper.format(startDate, DateFormatConstants.dateServerFormat));
      expect(controller.requestParams.endDate, DateTimeHelper.format(today, DateFormatConstants.dateServerFormat));
      expect(controller.appliedFiltersList.length, 1);
      expect(controller.defaultParams, controller.requestParams);
      expect(controller.requestParams.page, 1);
      expect(controller.isLoading, true);
    });

    test('When user filter is selected', () async {
      controller.requestParams.users = users;
      await controller.initParams();
      expect(controller.appliedFiltersList.length, 1);
      expect(controller.requestParams.users!.first.label, 'user');
      expect(controller.requestParams.users!.length, 1);
    });

    test('When division filter is selected', () async {
      controller.requestParams.divisions = division;
      await controller.initParams();
      expect(controller.appliedFiltersList.length, 1);
      expect(controller.requestParams.divisions!.first.label, 'division');
      expect(controller.requestParams.divisions!.length, 1);
    });

    test('When trade type filter is selected', () async {
      controller.requestParams.tradeTypes = tradeTypes;
      await controller.initParams();
      expect(controller.appliedFiltersList.length, 1);
      expect(controller.requestParams.tradeTypes!.first.label, 'tradeType');
      expect(controller.requestParams.tradeTypes!.length, 1);
    });

  });

  group('checkAndAddToAppliedFilter() should add data to applied filters list', () {
    final controller = ClockSummaryController();
    final list = [
      JPMultiSelectModel(label: 'user', id: '0', isSelect: true)
    ];
    final list2 = [
      JPMultiSelectModel(label: 'user', id: '0', isSelect: true),
      JPMultiSelectModel(label: 'user', id: '0', isSelect: true),
      JPMultiSelectModel(label: 'user', id: '0', isSelect: true)
    ];

    test('When list has only single value', () {
      controller.checkAndAddToAppliedFilter(list, 'label');
      expect(controller.appliedFiltersList[0], list.first.label);
    });

    test('When list has multiple values', () {
      controller.checkAndAddToAppliedFilter(list2, 'label');
      expect(controller.appliedFiltersList[1], '${list2.length} label');
    });

    test('When list is empty/has data and filter text has value', () {
      controller.checkAndAddToAppliedFilter(list2, 'label', filterText: 'filterText');
      expect(controller.appliedFiltersList[2], 'filterText');
    });

    test('When show in commas is true', () {
      controller.checkAndAddToAppliedFilter(list2, 'label', showInCommas: true);
      expect(controller.appliedFiltersList[3], 'label ( user, user, user )');
    });

  });

  group('ClockSummaryController should filter listing groupBy', () {

    final controller = ClockSummaryController();
    controller.listingType = ClockSummaryListingType.groupBy;

    test('When date is selected', (){
     controller.filterDataGroupBy('date');

     expect(controller.selectedGroupByFilter, 'date');
     expect(controller.requestParams.group, 'date');
     expect(controller.requestParams.sortOrder, 'desc');
     expect(controller.requestParams.page, 1);
     expect(controller.isLoading, true);
    });

    test('When job is selected', (){
     controller.filterDataGroupBy('job');

     expect(controller.selectedGroupByFilter, 'job');
     expect(controller.requestParams.group, 'job');
     expect(controller.requestParams.sortOrder, 'asc');
     expect(controller.requestParams.page, 1);
     expect(controller.isLoading, true);
    });

    test('When user is selected', (){
     controller.filterDataGroupBy('user');

     expect(controller.selectedGroupByFilter, 'user');
     expect(controller.requestParams.group, 'user');
     expect(controller.requestParams.sortOrder, 'asc');
     expect(controller.requestParams.page, 1);
     expect(controller.isLoading, true);
    });

  });

  group('ClockSummaryController should filter listing sortBy', () {

    final controller = ClockSummaryController();
    controller.listingType = ClockSummaryListingType.groupBy;

    test('When start_date_time is selected', (){
     controller.filterDataSortBy('start_date_time');

     expect(controller.selectedSortByFilter, 'start_date_time');
     expect(controller.requestParams.sortBy, 'start_date_time');
     expect(controller.requestParams.sortOrder, 'asc');
     expect(controller.requestParams.page, 1);
     expect(controller.isLoading, true);
    });

    test('When commercial_customers is selected', (){
     controller.filterDataSortBy('commercial_customers');

     expect(controller.selectedSortByFilter, 'commercial_customers');
     expect(controller.requestParams.sortBy, 'commercial_customers');
     expect(controller.requestParams.sortOrder, 'asc');
     expect(controller.requestParams.page, 1);
     expect(controller.isLoading, true);
    });

    test('When bid_customers is selected', (){
     controller.filterDataSortBy('bid_customers');

     expect(controller.selectedSortByFilter, 'bid_customers');
     expect(controller.requestParams.sortBy, 'bid_customers');
     expect(controller.requestParams.sortOrder, 'asc');
     expect(controller.requestParams.page, 1);
     expect(controller.isLoading, true);
    });

  });

  test('ClockSummaryController should refresh listing on api request', () {

    final controller = ClockSummaryController();
    controller.refreshList();

    expect(controller.requestParams.page, 1);
    expect(controller.isLoadMore, false);
  });

  test('ClockSummaryController should load more on api request', () {

    final controller = ClockSummaryController();
    controller.loadMore();

    expect(controller.requestParams.page, 2);
    expect(controller.isLoadMore, true);
  });

  group('ClockSummaryController should update params on moving to sort by listing', () {

    final controller = ClockSummaryController();
    controller.timeLogs = [
      ClockSummaryTimeLog(
          date: '05/01/2022',
        userName: 'user'
      ),
      ClockSummaryTimeLog(
        date: '05/01/2022',
        jobId: 1,
        jobModel: JobModel(
            id: 1,
            customerId: 1,
            customer: CustomerModel(
                id: 2,
                phones: [],
                fullNameMobile: 'user',
            ),
          number: '123',
          altId: '123',
        )
      )
    ];

    controller.requestParams.users = [
      JPMultiSelectModel(label: 'user', id: '0', isSelect: true)
    ];

    test('When selected filter is date', (){
      controller.selectedGroupByFilter = 'date';
      ClockSummaryRequestParams argParams = controller.getArgParams(0);
      expect(argParams.title, '05/01/2022');
      expect(argParams.date, '2022-05-01');
      expect(argParams.sortBy, 'start_date_time');
      expect(argParams.sortOrder, 'desc');
    });

    test('When selected filter is job and job_id is null', (){
      controller.selectedGroupByFilter = 'job';
      ClockSummaryRequestParams argParams = controller.getArgParams(0);
      expect(argParams.title, 'without_job');
      expect(argParams.withOutJobEntries, 1);
      expect(argParams.jobId, null);
      expect(argParams.jobName, 'without_job');
      expect(argParams.sortBy, 'start_date_time');
      expect(argParams.sortOrder, 'desc');
    });

    test('When selected filter is job and job_id is not null', (){
      controller.selectedGroupByFilter = 'job';
      ClockSummaryRequestParams argParams = controller.getArgParams(1);
      expect(argParams.withOutJobEntries, 0);
      expect(argParams.jobId, controller.timeLogs[1].jobId);
      expect(argParams.sortBy, 'start_date_time');
      expect(argParams.sortOrder, 'desc');
    });

    test('When selected filter is user ', (){
      controller.selectedGroupByFilter = 'user';
      controller.defaultParams = controller.requestParams;
      ClockSummaryRequestParams argParams = controller.getArgParams(0);
      expect(argParams.title, controller.timeLogs[0].userName);
      expect(argParams.userName, controller.timeLogs[0].userName);
      expect(argParams.sortBy, 'start_date_time');
      expect(argParams.sortOrder, 'desc');
    });

  });

}

