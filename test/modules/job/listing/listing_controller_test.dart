import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/run_mode.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/job_follow_up_status.dart';
import 'package:jobprogress/common/models/job/job_listing_filter.dart';
import 'package:jobprogress/common/models/job/job_production_board.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/modules/job/listing/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  final controller = JobListingController();

  Map<String, dynamic> userJson = {
    "id": 1,
    "first_name": "Anuj",
    "last_name": "Singh QA",
    "full_name": "Anuj Singh QA",
    "full_name_mobile": "Anuj Singh QA",
    "email": "anuj.singh@logicielsolutions.co.in",
    "group_id": null,
    "group": {
      'id': 5,
      'name': "owner"
    },
    "profile_pic":
    "https://www.google.com/url?sa=i&url=http%3A%2F%2Fwww.goodmorningimagesdownload.com%2Fgirlfriend-whatsapp-dp%2F&psig=AOvVaw1AAIEUa8fFSx2tjpnHgR99&ust=1648804135617000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCOiVkJqA8PYCFQAAAAAdAAAAABAD",
    "color": "#1c36ee",
    "company_name": "",
    "total_commission": null,
    "paid_commission": null,
    "unpaid_commission": null,
    "all_divisions_access": true,
    "company_details": {
      "company_name": "AS constructions",
      "id": 1,
      "logo":
      "https://pcdn.jobprog.net/public%2Fuploads%2Fcompany%2Flogos%2F1_1643299505.jpg",
      "subscriber_resource_id": 9
    }
  };

  final job = JobModel(
    id: 1,
    customerId: 1,
    productionBoards: [],
    followUpStatus: JobFollowUpStatus(),
    scheduleCount: 1,
    scheduled: "1",
    projectCount: 2,
  );

  final jobMeta = JobModel(
    id: 1,
    customerId: 1,
    productionBoards: [JobProductionBoardModel()],
    followUpStatus: JobFollowUpStatus(),
    scheduleCount: 3,
    scheduled: "0",
    projectCount: 5,
  );

  group('For job listing ', () {
    setUpAll(() {
      SharedPreferences.setMockInitialValues({"user": jsonEncode(userJson),});
      RunModeService.setRunMode(RunMode.unitTesting);
    });

    test('JobListing fetchJobs used when api request for data', () async {
      AuthService.userDetails = await AuthService.getLoggedInUser();
      controller.fetchJobs();
      expect(controller.filterKeys.page, 1);
      expect(controller.isLoading, true);
      expect(controller.isLoadMore, false);
    });

    test('JobListing refresh used to refresh list without interrupting filters', () async {
      AuthService.userDetails = await AuthService.getLoggedInUser();
      controller.refreshList();
      expect(controller.filterKeys.page, 1);
      expect(controller.isLoading, false);
    });

    test('JobListing refresh used to refresh list from main drawer', () async {
      AuthService.userDetails = await AuthService.getLoggedInUser();
      controller.refreshList(showLoading: true);
      expect(controller.filterKeys.page, 1);
      expect(controller.isLoading, true);
    });

    test('JobListing loadMore used when api request for more data', () async {
      AuthService.userDetails = await AuthService.getLoggedInUser();
      int currentPage = controller.filterKeys.page;
      controller.loadMore();
      expect(controller.filterKeys.page, ++currentPage);
      expect(controller.isLoading, true);
    });

    /////////////////////////////    SORT BY    //////////////////////////////////

    test('sort JobListing according to Last Moved', () async {
      AuthService.userDetails = await AuthService.getLoggedInUser();
      controller.setSortByList();
      controller.applySortFilters("stage_last_modified");
      expect(controller.filterKeys.page, 1);
      expect(controller.filterKeys.sortBy, 'stage_last_modified');
      expect(controller.filterKeys.sortOrder, "desc");
      expect(controller.filterKeys.limit, 20);
      expect(controller.filterKeys.dateRangeType,"job_created_date");
      expect(controller.isLoading, true);
    });

    test('sort JobListing according to Last Modified', () async {
      AuthService.userDetails = await AuthService.getLoggedInUser();
      controller.applySortFilters("updated_at");
      expect(controller.filterKeys.page, 1);
      expect(controller.filterKeys.sortBy, 'updated_at');
      expect(controller.filterKeys.sortOrder, "desc");
      expect(controller.filterKeys.limit, 20);
      expect(controller.filterKeys.dateRangeType,"job_created_date");
      expect(controller.isLoading, true);
    });

    test('sort JobListing according to Last Followup', () async {
      AuthService.userDetails = await AuthService.getLoggedInUser();
      controller.applySortFilters("follow_up");
      expect(controller.filterKeys.page, 1);
      expect(controller.filterKeys.sortBy, 'follow_up');
      expect(controller.filterKeys.sortOrder, "desc");
      expect(controller.filterKeys.limit, 20);
      expect(controller.filterKeys.dateRangeType,"job_created_date");
      expect(controller.isLoading, true);
    });

    test('sort JobListing according to Job Record Since', () async {
      AuthService.userDetails = await AuthService.getLoggedInUser();
      controller.applySortFilters("created_date");
      expect(controller.filterKeys.page, 1);
      expect(controller.filterKeys.sortBy, 'created_date');
      expect(controller.filterKeys.sortOrder, "desc");
      expect(controller.filterKeys.limit, 20);
      expect(controller.filterKeys.dateRangeType,"job_created_date");
      expect(controller.isLoading, true);
    });

    test('sort JobListing according to Job Appointment Date', () async {
      AuthService.userDetails = await AuthService.getLoggedInUser();
      controller.applySortFilters("appointment_recurrings.start_date_time");
      expect(controller.filterKeys.page, 1);
      expect(controller.filterKeys.sortBy, 'appointment_recurrings.start_date_time');
      expect(controller.filterKeys.sortOrder, "desc");
      expect(controller.filterKeys.limit, 20);
      expect(controller.filterKeys.dateRangeType,"job_appointment_date");
      expect(controller.isLoading, true);
    });

    test('sort JobListing according to Job Schedule Date', () async {
      AuthService.userDetails = await AuthService.getLoggedInUser();
      controller.applySortFilters("schedule_recurrings.start_date_time");
      expect(controller.filterKeys.page, 1);
      expect(controller.filterKeys.sortBy, 'schedule_recurrings.start_date_time');
      expect(controller.filterKeys.sortOrder, "desc");
      expect(controller.filterKeys.limit, 20);
      expect(controller.filterKeys.dateRangeType,"job_schedule_date");
      expect(controller.isLoading, true);
    });

    test('sort JobListing according to Contract Signed Date', () async {
      AuthService.userDetails = await AuthService.getLoggedInUser();
      controller.applySortFilters("cs_date");
      expect(controller.filterKeys.page, 1);
      expect(controller.filterKeys.sortBy, 'cs_date');
      expect(controller.filterKeys.sortOrder, "desc");
      expect(controller.filterKeys.limit, 20);
      expect(controller.filterKeys.dateRangeType,"job_created_date");
      expect(controller.isLoading, true);
    });

    test('sort JobListing according to Customer Last Name', () async {
      AuthService.userDetails = await AuthService.getLoggedInUser();
      controller.applySortFilters("customers.last_name");
      expect(controller.filterKeys.page, 1);
      expect(controller.filterKeys.sortBy, 'customers.last_name');
      expect(controller.filterKeys.sortOrder, "desc");
      expect(controller.filterKeys.limit, 20);
      expect(controller.filterKeys.dateRangeType,"job_created_date");
      expect(controller.isLoading, true);
    });

    ///////////////////////    NEAR BY JOB ACCESS    ///////////////////////////

    group("For near by job access", () {
      test('JobListing should include near by job when user has granted access for near by jobs', () async {
        controller.hasNearByJobAccess = true;
        await controller.onResume();
        expect(controller.filterKeys.page, 1);
        expect(controller.filterKeys.lat, isNull);
        expect(controller.filterKeys.long, isNull);
        expect(controller.isLoading, true);
      });

      test('JobListing should not include near by job when user has not granted access for near by jobs', () async {
        controller.hasNearByJobAccess = false;
        await controller.onResume();
        expect(controller.filterKeys.page, 1);
        expect(controller.filterKeys.lat, null);
        expect(controller.filterKeys.long, null);
        expect(controller.location != null, false);
      });
    });

    group('Whether check job/project is lost or not', () {

      group('Job should not be lost', () {
        test('In case of JobModel@jobLostDate is null', () {
          controller.jobList = [
            JobModel(
                id: 1,
                customerId: 12,
                isProject: false,
                jobLostDate: null,
                followUpStatus: null
            )
          ];
          expect(controller.jobList.first.isProject, isFalse);
          expect(controller.jobList.first.jobLostDate, isNull);
        });

        test('In case of JobModel@jobLostDate is not null', () {
          controller.jobList = [
            JobModel(
                id: 1,
                customerId: 12,
                isProject: false,
                jobLostDate: DateTime.now().toString()
            )
          ];
          expect(controller.jobList.first.isProject, isFalse);
          expect(controller.jobList.first.jobLostDate, isNotNull);
        });
      });

      test('Job should be lost', () {
        controller.jobList = [
          JobModel(
              id: 1,
              customerId: 12,
              isProject: false,
              jobLostDate: DateTime.now().toString()
          )
        ];
        expect(controller.jobList.first.isProject, isFalse);
        expect(controller.jobList.first.jobLostDate, isNotNull);
      });

      group('Project should not be lost', () {
        test('In case of JobModel@jobLostDate is null', () {
          controller.jobList = [
            JobModel(
                id: 1,
                customerId: 12,
                isProject: true,
                jobLostDate: null
            )
          ];
          expect(controller.jobList.first.isProject, isTrue);
          expect(controller.jobList.first.jobLostDate, isNull);
        });

        
      });

      test('Project should be lost', () {
        controller.jobList = [
          JobModel(
              id: 1,
              customerId: 12,
              isProject: true,
              jobLostDate: DateTime.now().toString()
          )
        ];
        expect(controller.jobList.first.isProject, isTrue);
        expect(controller.jobList.first.jobLostDate, isNotNull);
      });
    });

    group("Applying filters on jobs list", () {
      JobListingFilterModel params = JobListingFilterModel();
      test('Filter JobListing according to job last moved', () async {
        params.dateRangeType = "job_stage_changed_date";
        controller.applyFilters(params);
        expect(controller.filterKeys.page, 1);
        expect(controller.filterKeys.sortBy, 'stage_last_modified');
        expect(controller.filterKeys.selectedItem, "last_moved".tr);
        expect(controller.filterKeys.sortOrder, "desc");
        expect(controller.filterKeys.limit, 20);
        expect(controller.filterKeys.dateRangeType, "job_stage_changed_date");
        expect(controller.isLoading, true);
      });

      test('Filter JobListing according to job last modified', () async {
        params.dateRangeType = "job_updated_date";
        controller.applyFilters(params);
        expect(controller.filterKeys.page, 1);
        expect(controller.filterKeys.sortBy, 'updated_at');
        expect(controller.filterKeys.selectedItem, "last_Modified".tr);
        expect(controller.filterKeys.sortOrder, "desc");
        expect(controller.filterKeys.limit, 20);
        expect(controller.filterKeys.dateRangeType, "job_updated_date");
        expect(controller.isLoading, true);
      });

      test('Filter JobListing according to job created date', () async {
        params.dateRangeType = "job_created_date";
        controller.applyFilters(params);
        expect(controller.filterKeys.page, 1);
        expect(controller.filterKeys.sortBy, 'created_date');
        expect(controller.filterKeys.selectedItem, "job_record_since".tr);
        expect(controller.filterKeys.sortOrder, "desc");
        expect(controller.filterKeys.limit, 20);
        expect(controller.filterKeys.dateRangeType, "job_created_date");
        expect(controller.isLoading, true);
      });

      test('Filter JobListing according to job appointment date', () async {
        params.dateRangeType = "job_appointment_date";
        controller.applyFilters(params);
        expect(controller.filterKeys.page, 1);
        expect(controller.filterKeys.sortBy, 'appointment_recurrings.start_date_time');
        expect(controller.filterKeys.selectedItem, "job_appointment_date".tr);
        expect(controller.filterKeys.sortOrder, "desc");
        expect(controller.filterKeys.limit, 20);
        expect(controller.filterKeys.dateRangeType, "job_appointment_date");
        expect(controller.isLoading, true);
      });

      test('Filter JobListing according to job schedule date', () async {
        params.dateRangeType = "job_schedule_date";
        controller.applyFilters(params);
        expect(controller.filterKeys.page, 1);
        expect(controller.filterKeys.sortBy, 'schedule_recurrings.start_date_time');
        expect(controller.filterKeys.selectedItem, "job_schedule_date".tr);
        expect(controller.filterKeys.sortOrder, "desc");
        expect(controller.filterKeys.limit, 20);
        expect(controller.filterKeys.dateRangeType, "job_schedule_date");
        expect(controller.isLoading, true);
      });

      test('Filter JobListing according to job awarded date', () async {
        params.dateRangeType = "job_awarded_date";
        controller.applyFilters(params);
        expect(controller.filterKeys.page, 1);
        expect(controller.filterKeys.sortBy, 'created_date');
        expect(controller.filterKeys.selectedItem, "job_record_since".tr);
        expect(controller.filterKeys.sortOrder, "desc");
        expect(controller.filterKeys.limit, 20);
        expect(controller.filterKeys.dateRangeType, "job_awarded_date");
        expect(controller.isLoading, true);
      });

      test('Filter JobListing according to job completion date', () async {
        params.dateRangeType = "job_completion_date";
        controller.applyFilters(params);
        expect(controller.filterKeys.page, 1);
        expect(controller.filterKeys.sortBy, 'created_date');
        expect(controller.filterKeys.selectedItem, "job_record_since".tr);
        expect(controller.filterKeys.sortOrder, "desc");
        expect(controller.filterKeys.limit, 20);
        expect(controller.filterKeys.dateRangeType, "job_completion_date");
        expect(controller.isLoading, true);
      });

      test('Filter JobListing according to job completion date', () async {
        params.dateRangeType = "job_completion_date";
        controller.applyFilters(params);
        expect(controller.filterKeys.page, 1);
        expect(controller.filterKeys.sortBy, 'created_date');
        expect(controller.filterKeys.selectedItem, "job_record_since".tr);
        expect(controller.filterKeys.sortOrder, "desc");
        expect(controller.filterKeys.limit, 20);
        expect(controller.filterKeys.dateRangeType, "job_completion_date");
        expect(controller.isLoading, true);
      });

      test('Filter JobListing according to contract signed date', () async {
        params.dateRangeType = "contract_signed_date";
        controller.applyFilters(params);
        expect(controller.filterKeys.page, 1);
        expect(controller.filterKeys.sortBy, 'cs_date');
        expect(controller.filterKeys.selectedItem, "contract_signed_date".tr);
        expect(controller.filterKeys.sortOrder, "desc");
        expect(controller.filterKeys.limit, 20);
        expect(controller.filterKeys.dateRangeType, "contract_signed_date");
        expect(controller.isLoading, true);
      });
    });

  });

  test("JobListingController@updateJobWithMeta should update job metadata correctly", () {
    controller.updateJobWithMeta(job, jobMeta);
    expect(job.productionBoards, jobMeta.productionBoards);
    expect(job.followUpStatus, jobMeta.followUpStatus);
    expect(job.scheduleCount, jobMeta.scheduleCount);
    expect(job.scheduled, jobMeta.scheduled);
    expect(job.projectCount, jobMeta.projectCount);
  });
}

