import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/appointment/appointment_param.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/constants/user_roles.dart';
import 'package:jobprogress/modules/appointments/listing/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../files_listing/file_listing_test.dart';

void main(){
   final controller = AppointmentListingController();

   setUpAll(() async {
     SharedPreferences.setMockInitialValues({
       "user": jsonEncode(userJson),
     });
     await AuthService.getLoggedInUser();
   });

  test("AppointmentListing should be constructed with default values", (){
    expect(controller.canShowLoadMore, false);
    expect(controller.isLoading, true);
    expect(controller.isLoadMore, false);
    expect(controller.appointmentListOfTotalLength, 0);
    expect(controller.paramKeys.limit, 20);
    expect(controller.paramKeys.page, 1);
    expect(controller.paramKeys.jobAltId, null);
    expect(controller.paramKeys.sortBy, 'start_date_time');    
    expect(controller.paramKeys.sortOrder, 'asc');
    expect(controller.paramKeys.duration, 'upcoming');
    expect(controller.paramKeys.jobNumber, null);
    expect(controller.paramKeys.location, null);
    expect(controller.paramKeys.title, null);
    expect(controller.paramKeys.startDate, null);
    expect(controller.paramKeys.endDate, null);
    expect(controller.paramKeys.date, null);
    expect(controller.paramKeys.createdBy, null);
    expect(controller.paramKeys.assignedTo, null);
    expect(controller.paramKeys.appointmentResultOption, null);
    expect(controller.paramKeys.dateRangeType, ["appointment_duration_date"]);
  });

  test('AppointmentListing should loadmore used when api request for data', () {
    controller.loadMore();
    expect(controller.isLoadMore, true);
    expect(controller.paramKeys.page, 2);
  });

  test('AppointmentListing should refresh when api request for data with showLoading passes true', () {
    bool showLoading = true;
    controller.refreshList(showLoading: showLoading);
    expect(controller.isLoading, showLoading);
    expect(controller.paramKeys.page, 1);
  });
  
  test('AppointmentListing should refresh when api request for data', () {
    controller.refreshList();
    expect(controller.isLoading, false);
    expect(controller.paramKeys.page, 1);
  });
  
  group('AppointmentListingController@sortAppointmentListing() should  sort list', () {
    test('should toggle list from ascending to descending and when sortOrder is ascending', () {
      controller.paramKeys.sortOrder = 'asc';
      controller.sortAppointmentListing();
      expect(controller.paramKeys.sortOrder, 'desc');
    });
    test('should toggle list from descending to ascending and when sortOrder is descending', (){
      controller.paramKeys.sortOrder = 'desc';
      controller.sortAppointmentListing();
      expect(controller.paramKeys.sortOrder, 'asc');
    });
  });

  test('AppointmentListingController@saveAppointmentFilter should update page to 1 & start loading', () {
    controller.saveAppointmentFilter();
    expect(controller.paramKeys.page, 1);
    expect(controller.isLoading, true);
  });

  test("AppointmentListing should be constructed with parameters", (){
    AppointmentListingParamModel params = AppointmentListingParamModel(
      date: 'date',
      duration: 'MTD',
      endDate: '2022-07-01',
      jobAltId: 'jobAltId',
      jobNumber: 'jobNumber',
      dateRangeType: ["appointment_duration_date"], 
      appointmentResultOption: ['4','246'],
      assignedTo: ['85','87'],
      createdBy: 1,
      limit: 20,
      location: 'location',
      page: 1,
      sortBy: 'created_at',
      sortOrder: 'desc',
      startDate: '2022-07-01',
      title:  'title'  
    );

    controller.applyFilters(params);
    
    expect(controller.isLoading, true);
    expect(controller.paramKeys.page, 1);
    expect(controller.paramKeys.title, 'title');
    expect(controller.paramKeys.date, 'date');
    expect(controller.paramKeys.duration, 'MTD');
    expect(controller.paramKeys.endDate, '2022-07-01');
    expect(controller.paramKeys.jobAltId, 'jobAltId');
    expect(controller.paramKeys.jobNumber, 'jobNumber');
    expect(controller.paramKeys.dateRangeType,  ["appointment_duration_date"]);
    expect(controller.paramKeys.appointmentResultOption, ['4','246']);
    expect(controller.paramKeys.assignedTo, ['85','87']);
    expect(controller.paramKeys.createdBy, 1);
    expect(controller.paramKeys.limit, 20);
    expect(controller.paramKeys.page, 1);
    expect(controller.paramKeys.sortBy, 'created_at');
    expect(controller.paramKeys.sortOrder, 'desc');
    expect(controller.paramKeys.startDate, '2022-07-01');
  });

  group("User selection should be enabled on user role basis & permission", () {
    test("Admin user should be able to apply users filter", () {
      AuthService.userDetails?.groupId = UserGroupIdConstants.admin;
      final result = controller.canSelectAllUsers();
      expect(result, isTrue);
    });

    group("Standard user can apply filter conditionally", () {
      test("User can apply filter when not restricted", () {
        AuthService.userDetails?.groupId = UserGroupIdConstants.standard;
        AuthService.isRestricted = false;
        final result = controller.canSelectAllUsers();
        expect(result, isTrue);
      });

      test("User can apply filter when has view calender permission", () {
        AuthService.userDetails?.groupId = UserGroupIdConstants.standard;
        PermissionService.permissionList.addAll([PermissionConstants.viewAllUserCalendar]);
        final result = controller.canSelectAllUsers();
        expect(result, isTrue);
      });

      test("User can not apply filter when restricted and has not sufficient permission", () {
        AuthService.userDetails?.groupId = UserGroupIdConstants.standard;
        PermissionService.permissionList.clear();
        AuthService.isRestricted = true;
        final result = controller.canSelectAllUsers();
        expect(result, isFalse);
      });
    });

    test("Sub Contractor Prime user should not be able to apply users filter", () {
      AuthService.userDetails?.groupId = UserGroupIdConstants.subContractorPrime;

      final result = controller.canSelectAllUsers();
      expect(result, isFalse);
    });

  });
}