import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/calendars.dart';
import 'package:jobprogress/common/enums/quick_action_type.dart';
import 'package:jobprogress/common/extensions/mix_panel/extension.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/common/models/schedules/schedules.dart';
import 'package:jobprogress/common/repositories/schedule.dart';
import 'package:jobprogress/common/repositories/sql/workflow_stages.dart';
import 'package:jobprogress/common/services/job/index.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/common/services/progress_board/add_to_progress_board.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/HierarchicalMultiSelect/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../common/enums/cj_list_type.dart';
import '../../../common/enums/job.dart';
import '../../../common/enums/job_quick_action_callback_type.dart';
import '../../../common/enums/parent_form_type.dart';
import '../../../common/models/customer/customer.dart';
import '../../../common/models/home/filter_model.dart';
import '../../../common/models/job/job.dart';
import '../../../common/models/job/job_listing_filter.dart';
import '../../../common/models/workflow_stage.dart';
import '../../../common/repositories/appointment.dart';
import '../../../common/repositories/job.dart';
import '../../../common/repositories/work_flow_stages.dart';
import '../../../common/services/job/quick_action_helper.dart';
import '../../../common/services/location/loaction_service.dart';
import '../../../common/services/run_mode/index.dart';
import '../../../common/services/user_preferences.dart';
import '../../../common/services/workflow_stages/workflow_service.dart';
import '../../../core/constants/date_formats.dart';
import '../../../core/constants/pagination_constants.dart';
import '../../../global_widgets/loader/index.dart';
import '../../../global_widgets/profile_image_widget/index.dart';
import '../../../routes/pages.dart';

class JobListingController extends GetxController with GetTickerProviderStateMixin {

  late GlobalKey<ScaffoldState> scaffoldKey;
  int scaffoldKeyId = 0;
  JobListingFilterModel filterKeys = JobListingFilterModel();
  JobListingFilterModel defaultFilters = JobListingFilterModel();
  HomeFilterModel homeFilters = HomeFilterModel();

  bool isLoading = true;
  bool isLoadMore = false;
  bool canShowLoadMore = false;
  bool hasNearByJobAccess = UserPreferences.hasNearByAccess ?? false;

  CJListType? listType = CJListType.job;
  CustomerModel? selectedCustomer;
  JobModel? jobModel;
  Position? location;

  int? customerId = Get.arguments != null && Get.arguments['customerID'] != null ? Get.arguments['customerID'] : null;
  String? selectJob = Get.arguments?['selectJob'] != null ? 'job' : '';
  int metaDataCount = 0;
  int? jobId;

  List<JobModel> jobList = [];
  List<JPMultiSelectModel> filterByMultiList = [];
  List<JPMultiSelectModel> stages = [];
  List<JPHierarchicalSelectorGroupModel> groupedStages = [];
  List<JPMultiSelectModel> progressBoardsList = [];

  List<JPSingleSelectModel> sortByList = [];

  WorkFlowService? workFlowService;

  StreamSubscription<List<WorkFlowStageModel>>? stagesListener;

  JobListingController() {
    scaffoldKey = GlobalKey<ScaffoldState>();
  }

  @override
  void onInit() {
    super.onInit();
    listType = Get.arguments[NavigationParams.pageType] ?? CJListType.job;
    setSortByList();

    if(listType == CJListType.projectJobs) {
      jobId = Get.arguments[NavigationParams.jobId];
      jobModel = Get.arguments[NavigationParams.jobModel];
      fetchProjectJobs();
    } else {
      filterKeys.selectedItem = sortByList.firstWhereOrNull((element) => element.id == filterKeys.sortBy)?.label;
      initData();
    }
    workFlowService = WorkFlowService.get();
    workFlowStagesListener();
  }

  Future<void> initData() async {
    filterKeys.stages = [];

    await fetchCurrentLocation();

    if (Get.arguments?[NavigationParams.stageId] != null) filterKeys.stages = [Get.arguments[NavigationParams.stageId]];

    if (Get.arguments?[NavigationParams.filterParams] != null) {
      homeFilters = Get.arguments[NavigationParams.filterParams];
      filterKeys.divisionIds = [];
      filterKeys.users = [];
      filterKeys.trades = [];
      filterKeys.divisionIds = homeFilters.divisionIds;
      filterKeys.users = homeFilters.users;
      filterKeys.trades = homeFilters.trades;
      filterKeys.dateRangeType = homeFilters.dateRangeType;
      filterKeys.duration = homeFilters.duration;
      filterKeys.startDate = homeFilters.startDate;
      filterKeys.endDate = homeFilters.endDate;
      filterKeys.insuranceJobsOnly = homeFilters.insuranceJobsOnly;
    }

    setStages();

    defaultFilters = JobListingFilterModel.copy(filterKeys);
    defaultFilters.selectedItem = sortByList.firstWhereOrNull((element) => element.id == defaultFilters.sortBy)?.label;

    if(listType == CJListType.nearByJobs) {
      applySortFilters("distance_0_25");
    } else {
      fetchJobs();
    }
  }

  void setStages() async {
    List<WorkFlowStageModel?> stageList = await SqlWorkFlowStagesRepository().get();
    stages = [];

    for (var stage in stageList) {
      stages.add(
        JPMultiSelectModel(
            label: stage?.name.toString().capitalizeFirst ?? '',
            id: stage?.code ?? '',
            child: JPProfileImage(
              color: stage?.color,
              initial: stage?.initial,
            ),
            isSelect: false
        ),
      );
    }

    Map<String, List<WorkFlowStageModel>> groupStageList = await SqlWorkFlowStagesRepository().getGroupedStages();
    groupedStages = [];

    groupStageList.forEach((groupName, stages) {
      List<JPHierarchicalSelectorItemModel> items = stages.map((stage) {
        final stageColor = stage.colorType == CommonConstants.group
            ? stage.group?.color ?? stage.color
            : stage.color;
        return JPHierarchicalSelectorItemModel(
          id: stage.code,
          label: stage.name.toString(),
          count: 0,
          isSelected: false,
          additionalData: stage,
            child: JPProfileImage(
              color: stageColor,
              initial: stage.initial,
            )
        );
      }).toList();

      groupedStages.add(JPHierarchicalSelectorGroupModel(
        id: groupName.toLowerCase().replaceAll(' ', '_'),
        label: groupName,
        items: items,
        isExpanded: true, // Default to expanded
      ));
    });
  }

  Map<String, dynamic> getQueryParams() {
    Map<String, dynamic> queryParams = {
      "includes[0]" : "customer",
      "includes[1]" : "address",
      "includes[2]" : "reps",
      "includes[3]" : "customer.rep",
      "includes[4]" : "appointments",
      "includes[5]" : "follow_up_status",
      "includes[6]" : "flags",
      "includes[7]" : "sub_contractors",
      "includes[8]" : "division",
      "includes[9]" : "production_boards",
      "includes[10]" : "contacts.phones",
      "includes[11]" : "flags.color",
      "includes[12]": "workflow",
      "includes[13]": "follow_up_notes",
      "includes[14]":  "work_type",
      "includes[15]": "contact",
      "includes[16]": "schedule",
      "includes[17]": "insurance_details",
      if(LDService.hasFeatureEnabled(LDFlagKeyConstants.jobCanvaser))
      "includes[18]": "canvasser",

      ...filterKeys.toJson()..removeWhere((dynamic key, dynamic value) =>
      (key == null || key.contains("division_ids") || key.contains("stages")
          || key.contains("users") || key.contains("trades") || key.contains("state_id"))
          || key.contains("follow_up_marks") || value == null),
    };

    for(int i = 0; i < (filterKeys.stages?.length ?? 0) ; i++) {
      queryParams.addEntries({"stages[$i]" : filterKeys.stages![i]}.entries);
    }
    for(int i = 0; i < (filterKeys.divisionIds?.length ?? 0) ; i++) {
      queryParams.addEntries({"division_ids[$i]" : filterKeys.divisionIds![i]}.entries);
    }
    for (int i = 0; i < (filterKeys.users?.length ?? 0); i++) {
      queryParams.addEntries({"users[$i]": filterKeys.users![i]}.entries);
    }
    for(int i = 0; i < (filterKeys.trades?.length ?? 0) ; i++) {
      queryParams.addEntries({"trades[$i]" : filterKeys.trades![i]}.entries);
    }
    for(int i = 0; i < (filterKeys.stateIds?.length ?? 0) ; i++) {
      queryParams.addEntries({"state_id[$i]" : filterKeys.stateIds![i]}.entries);
    }
    for(int i = 0; i < (filterKeys.followUpMarks?.length ?? 0) ; i++) {
      queryParams.addEntries({"follow_up_marks[$i]" : filterKeys.followUpMarks![i]}.entries);
    }
    if(filterKeys.duration != "custom") {
      queryParams.removeWhere((key, value) => key == "start_date");
      queryParams.removeWhere((key, value) => key == "end_date");
    }

    if(customerId != null) {
      queryParams['customer_id'] = customerId;
    }

    return queryParams;
  }

  void setSortByList() {
    if(listType == CJListType.nearByJobs) {
      sortByList = [
        JPSingleSelectModel(id: 'distance_0_25', label: "1_4_mile".tr),
        JPSingleSelectModel(id: 'distance_0_5', label: "1_2_mile".tr),
        JPSingleSelectModel(id: 'distance_1', label: "1_mile".tr),
        JPSingleSelectModel(id: 'distance_5', label: "5_mile".tr),
        JPSingleSelectModel(id: 'distance_10', label: "10_mile".tr)
      ];
    } else {
      sortByList = [
        JPSingleSelectModel(id: 'stage_last_modified', label: "last_moved".tr),
        JPSingleSelectModel(id: 'updated_at', label: "last_Modified".tr),
        JPSingleSelectModel(id: 'follow_up', label: "last_followup".tr),
        JPSingleSelectModel(id: 'created_date', label: "job_record_since".tr),
        JPSingleSelectModel(id: 'appointment_recurrings.start_date_time', label: "job_appointment_date".tr),
        JPSingleSelectModel(id: 'schedule_recurrings.start_date_time', label: "job_schedule_date".tr),
        JPSingleSelectModel(id: 'cs_date', label: "contract_signed_date".tr),
        JPSingleSelectModel(id: 'customers.last_name', label: "customer_last_name".tr),
        if (LDService.hasFeatureEnabled(LDFlagKeyConstants.workflowJobStageGrouping))
          JPSingleSelectModel(id: 'job_stage', label: "job_stage".tr),
      ];
    }
    update();
  }

  ///////////////////////    NAVIGATE TO DETAIL SCREEN   ///////////////////////

  void navigateToDetailScreen({int? jobID, int? currentIndex}){
    if(selectJob == 'job'){
      Get.back(result: jobList[currentIndex ?? 0]);
    } else {
      Get.toNamed(Routes.jobSummary, arguments: {NavigationParams.jobId: jobID, NavigationParams.customerId: jobList[currentIndex!].customerId},preventDuplicates: false);

    }
  }

  void openDescDialog({JobModel? job, int? index}) {
    JobService.openDescDialog(job: job, updateScreen: (){
      jobList[index!] = job!;
      update();
    });
  }
  //////////////////////////   FETCH CURRENT LOCATION   ////////////////////////

  Future<void> fetchCurrentLocation() async {
    try {
      bool canRequestLocation = hasNearByJobAccess && listType == CJListType.nearByJobs;
      if (canRequestLocation) {
        await LocationService.checkAndReRequestPermission().then((canAccessLocation) async {
          if (canAccessLocation) {
            location = await LocationService.getCoordinates();
            filterKeys.lat = location?.latitude;
            filterKeys.long = location?.longitude;
          }
        });
      }
    } catch (e) {
       return;
    }
  }

  /////////////////////////////   FETCH JOB   ////////////////////////////

  Future<void> fetchJobs() async {
    try {
      Map<String, dynamic> queryParams = getQueryParams();
      Map<String, dynamic> response = await JobRepository.fetchJobList(params: queryParams);
      List<JobModel> list = response["list"];
      if (!isLoadMore) {
        jobList = [];
        metaDataCount = 0;
      }
      jobList.addAll(list);

      canShowLoadMore = jobList.length < response["pagination"]["total"];

      if(jobList.isNotEmpty) {
        if(Get.arguments != null && Get.arguments['customerID'] != null) {
          selectedCustomer = jobList[0].customer;
        }
      }
      fetchMeta();
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      isLoadMore = false;
      update();
    }
  }

  /////////////////////////////   FETCH PROJECT JOBS   ////////////////////////////

  Future<void> fetchProjectJobs() async {
    Map<String, dynamic> projectJobParams = {
      "includes[0]" : "projects",
      "includes[1]" : "projects.sub_contractors",
      "includes[2]" : "projects.work_types",
      "includes[3]" : "projects.labours",
      "includes[4]" : "projects.estimators",
      "includes[5]" : "projects.reps",
      "includes[6]" : "projects.follow_up",
      "includes[7]" : "projects.follow_up_status",
      "includes[8]" : "production_boards",
      "includes[9]" : "flags.color",
      "include_lost_jobs": "1",
      "limit" : 0,
      "parent_id" : jobId,
      "projects_only" : 1,
      "sort_by" : "display_order",
      "sort_order" : "asc",
    };

    try {
      Map<String, dynamic> response = await JobRepository.fetchJobList(params: projectJobParams);
      List<JobModel> list = response["list"];
      jobList = [];
      jobList.addAll(list);
      metaDataCount = jobList.length;
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      isLoadMore = false;
      update();
    }
  }

  /////////////////////////////   FETCH NEAR BY JOBS   ////////////////////////////

  Future<void> fetchNearByJobs() async {
    if(filterKeys.lat == null || filterKeys.long == null) filterKeys.distance = 0;
    if(filterKeys.distance == 0) {
      Helper.showToastMessage("provide_location_permissions".tr);
    }
    Map<String, dynamic> projectJobParams = {
      "includes[0]": "customer",
      "includes[1]": "address",
      "includes[2]": "reps",
      "includes[3]": "customer.rep",
      "includes[4]": "flags",
      "includes[5]": "sub_contractors",
      "includes[6]": "division",
      "includes[7]": "flags.color",
      "distance": filterKeys.distance,
      "is_optimized": 1,
      if(filterKeys.lat != null) "lat": filterKeys.lat,
      if(filterKeys.long != null) "long": filterKeys.long,
      "limit": PaginationConstants.pageLimit,
      "page": filterKeys.page,
      "sort_by": filterKeys.lat != null || filterKeys.long != null ? "distance" : "created_at",
      "sort_order": filterKeys.lat != null || filterKeys.long != null ? 'asc' : 'desc'
    };

    try {
      Map<String, dynamic> response = await JobRepository.fetchJobList(params: projectJobParams);
      List<JobModel> list = response["list"];
      if (!isLoadMore) {
        jobList = [];
        metaDataCount = 0;
      }
      jobList.addAll(list);
      canShowLoadMore = jobList.length < response["pagination"]["total"];
      fetchMeta();
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      isLoadMore = false;
      update();
    }
  }

  /////////////////////////////   FETCH META   ////////////////////////////

  /// [fetchMeta] is used to fetch meta data of jobs
  /// Params:
  ///  [index] - If available, loads the meta data of the job at that index
  ///  [index  null] - If not available, loads the meta data of all the jobs
  Future<void> fetchMeta({int? index}) async {
    try {
      Map<String, dynamic> queryParams = {
        "type[0]": "projects_count",
        "type[1]": "schedule_details",
        "type[2]": "appointment_details",
        "type[3]": "production_boards",
        "type[4]": "follow_up_status",
      };

      if (index != null) {
        queryParams.addEntries({"job_ids[0]": jobList[index].id}.entries);
        Map<String, dynamic> response = await JobRepository.fetchMetaList(queryParams);
        if (!Helper.isValueNullOrEmpty(response["list"])) {
          updateJobWithMeta(jobList[index], response["list"][0]);
        }
      } else {
        for (int i = metaDataCount; i < (jobList.length); i++) {
          queryParams.addEntries({"job_ids[$i]": jobList[i].id}.entries);
        }
        Map<String, dynamic> response = await JobRepository.fetchMetaList(queryParams);
        List<JobModel> list = response["list"];
        for (int i = metaDataCount; i < jobList.length; i++) {
          for (int j = 0; j < list.length; j++) {
            if (jobList[i].id == list[j].id) {
              updateJobWithMeta(jobList[i], list[j]);
            }
          }
        }
        metaDataCount = jobList.length;
      }
      update();
    } catch (e) {
      rethrow;
    }
  }

  /// [updateJobWithMeta] is used to update meta data of jobs
  /// Params:
  ///    [job] - is the already loaded Job
  ///    [jobMeta] - contains the additional data about the Job
  void updateJobWithMeta(JobModel job, JobModel jobMeta) {
    job.productionBoards = jobMeta.productionBoards;
    job.followUpStatus = jobMeta.followUpStatus;
    job.scheduleCount = jobMeta.scheduleCount;
    job.scheduled = jobMeta.scheduled;
    job.projectCount = jobMeta.projectCount;
    job.appointmentDate = jobMeta.appointmentDate;
  }

  //////////////////////////////   REFRESH LIST   //////////////////////////////
  ///showLoading is used to show shimmer if refresh is pressed from main drawer
  Future<void> refreshList({bool? showLoading}) async {

    if(!hasNearByJobAccess) {
      filterKeys.lat = null;
      filterKeys.long = null;
      location = null;
    } else if(location == null) {
      await fetchCurrentLocation();
    }

    filterKeys.page = 1;
    ///   show shimmer if showLoading = true
    isLoading = showLoading ?? false;
    update();
    if (listType == CJListType.projectJobs) {
      await fetchProjectJobs();
    } else {
      fetchJobs();
    }
  }

  ////////////////////////////   FETCH NEXT PAGE   /////////////////////////////

  Future<void> loadMore() async {
    filterKeys.page += 1;
    isLoadMore = true;
    if(listType == CJListType.nearByJobs) {
      await fetchNearByJobs();
    } else {
      await fetchJobs();
    }
  }

  ///////////////////////////////   SORT LIST   ////////////////////////////////

  void applySortFilters(dynamic value) {
    filterKeys.page = 1;
    filterKeys.selectedItem = sortByList.firstWhere((element) => element.id == value).label;
    filterKeys.sortOrder = getSortOrder(value);
    filterKeys.sortBy = value;

    switch(value) {
      case "appointment_recurrings.start_date_time":
        filterKeys.dateRangeType = "job_appointment_date";
        break;
      case "schedule_recurrings.start_date_time":
        filterKeys.dateRangeType = "job_schedule_date";
        break;
      case "distance_0_25":
        filterKeys.distance = 0.25;
        break;
      case "distance_0_5":
        filterKeys.distance = 0.5;
        break;
      case "distance_1":
        filterKeys.distance = 1;
        break;
      case "distance_5":
        filterKeys.distance = 5;
        break;
      case "distance_10":
        filterKeys.distance = 10;
        break;
      default:
        filterKeys.dateRangeType = "job_created_date";
        break;
    }

    if(filterKeys.distance != null) {
      filterKeys.lat = location?.latitude;
      filterKeys.long = location?.longitude;
      filterKeys.sortOrder = "asc";
      filterKeys.sortBy = "distance";
    }

    isLoading = true;
    update();
    if(listType == CJListType.nearByJobs) {
      fetchNearByJobs().trackSortFilterEvents();
    } else {
      listType = CJListType.job;
      fetchJobs().trackSortFilterEvents();
    }

  }

  String getSortOrder(dynamic value) {
    if (value == "job_stage") return "asc";
    return "desc";
  }

  /////////////////////////////   FILTER LIST   ////////////////////////////////

  void applyFilters(JobListingFilterModel params) {
    filterKeys = params;
    filterKeys.page = 1;
    isLoading = true;
    listType = CJListType.job;
    filterKeys.sortOrder = "desc";
    switch(filterKeys.dateRangeType) {
      case "job_stage_changed_date":
      case "job_invoiced_date":
        filterKeys.selectedItem = sortByList.firstWhere((element) => element.id == "stage_last_modified").label;
        filterKeys.sortBy = "stage_last_modified";
        break;
      case "job_updated_date":
        filterKeys.selectedItem = sortByList.firstWhere((element) => element.id == "updated_at").label;
        filterKeys.sortBy = "updated_at";
        break;
      case "job_created_date":
      case "job_awarded_date":
      case "job_completion_date":
        filterKeys.selectedItem = sortByList.firstWhere((element) => element.id == "created_date").label;
        filterKeys.sortBy = "created_date";
        break;
      case "job_appointment_date":
        filterKeys.selectedItem = sortByList.firstWhere((element) => element.id == "appointment_recurrings.start_date_time").label;
        filterKeys.sortBy = "appointment_recurrings.start_date_time";
        break;
      case "contract_signed_date":
        filterKeys.selectedItem = sortByList.firstWhere((element) => element.id == "cs_date").label;
        filterKeys.sortBy = "cs_date";
        break;
      case "job_schedule_date":
        filterKeys.selectedItem = sortByList.firstWhere((element) => element.id == "schedule_recurrings.start_date_time").label;
        filterKeys.sortBy = "schedule_recurrings.start_date_time";
        break;
    }
    update();
    fetchJobs().trackFilterEvents();
  }

  /////////////////////////    QUICK ACTION HANDLER    /////////////////////////

  void openQuickActions({JobModel? job, int? index}) {
    JobQuickActionHelper().openQuickActions(
        job: job!,
        index: index!,
        quickActionCallback: jobQuickActionCallback,
        deleteCallback: deleteCallback,
        listType: listType,
        quickActionType: QuickActionType.jobListing
    );
  }

  void jobQuickActionCallback({JobModel? job, int? currentIndex, JobQuickActionCallbackType? callbackType}) {
    switch(callbackType) {
      case JobQuickActionCallbackType.navigateToDetailScreenCallback:
      case JobQuickActionCallbackType.flagCallback:
      case JobQuickActionCallbackType.addToProgressBoard:
        jobList[currentIndex!] = job!;
        break;
      case JobQuickActionCallbackType.markAsLostJobCallback:
        if(!(filterKeys.followUpMarks?.contains("lost_job") ?? false) && jobList[currentIndex!].listType != CJListType.projectJobs) {
          jobList.removeAt(currentIndex);
        } else {
          jobList[currentIndex!].jobLostDate = DateTime.now().toString();
        }
        break;
      case JobQuickActionCallbackType.reinstateJob:
        if((filterKeys.followUpMarks?.contains("lost_job") ?? false)) {
          jobList.removeAt(currentIndex!);
        } else {
          jobList[currentIndex!].jobLostDate = null;
        }
        break;
      case JobQuickActionCallbackType.archive:
        if(!(filterKeys.isWithArchived ?? false)){
          jobList.removeAt(currentIndex!);
        } else {
          jobList[currentIndex!].archived = DateTimeHelper.formatDate(DateTime.now().toString(), DateFormatConstants.dateTimeFormatWithoutSeconds);
        }
        break;
      case JobQuickActionCallbackType.unarchive:
        if(!(filterKeys.isWithArchived ?? false)){
          jobList.removeAt(currentIndex!);
        } else {
          jobList[currentIndex!].archived = null;
        }
        break;
      case JobQuickActionCallbackType.appointment:
        fetchAppointment(job?.customerId, job?.id);
        break;
      case JobQuickActionCallbackType.customer:
      case JobQuickActionCallbackType.createAnAppointment:
      case JobQuickActionCallbackType.scheduleJob:
        refreshList(showLoading: true);
        break;
      case JobQuickActionCallbackType.markAsAwarded:
        awardedStageConfirmation(job?.id, Helper.isTrue(job?.isAwarded), () {
          refreshList(showLoading: true);
        });
        break;
      default:
        update();
        break;
    }
    update();
  }

  ////////    DELETE CUSTOMER   ///////

  void deleteCallback(dynamic model,dynamic action) {
    jobList.removeAt(jobList.indexWhere((element) => element.id == model.id));
    Get.back();
    update();
  }

  //////////////////////////////////////////////////////////////////////////////

  bool isMetaDataLoading(int index) => metaDataCount <= index;

  void onProjectCountPressed({int? index}) {
    Get.toNamed(Routes.jobListing, preventDuplicates: false, arguments: {
      NavigationParams.jobId: jobList[index!].id,
      NavigationParams.pageType: CJListType.projectJobs,
      NavigationParams.jobModel: jobList[index],
    });
  }

  Future<void> navigateToAddProjectScreen() async {
    final result = await Get.toNamed(Routes.projectForm, arguments: {
      NavigationParams.jobModel: jobModel,
      NavigationParams.type: JobFormType.add,
      NavigationParams.parentFormType: ParentFormType.individual
    });

    if(result != null) {
      refreshList(showLoading: true);
    }
  }

  Future<void> fetchAppointment(int? customerId, int? jobId) async {
    try {
      showJPLoader();
      Map<String, dynamic> params = {
        'customer_id': customerId,
        'includes[0]': 'customer',
        'includes[1]': 'jobs',
        'includes[2]': 'attendees',
        'includes[3]': 'created_by',
        'includes[4]': 'reminders',
        'includes[5]': 'result_option',
        'includes[6]': 'attachments',
        'job_ids': jobId,
      };
      List<AppointmentModel> appointmentModels = await AppointmentRepository().fetchAppointmentByCustomerId(params);
      Get.back();
      if(appointmentModels.length > 1) {
        Get.toNamed(Routes.calendar,arguments: {
          NavigationParams.jobId: jobId
        });
      } else {
        Get.toNamed(Routes.appointmentDetails, arguments: {
          NavigationParams.appointment: appointmentModels.first
        });
      }
    } catch(e) {
      Get.back();
      rethrow;
    }
  }

  void awardedStageConfirmation(int? jobId, bool isAwarded, VoidCallback callback) {
    showJPBottomSheet(
      child: (controller) {
        return JPConfirmationDialog(
          icon: Icons.warning_amber_outlined,
          title: 'confirmation'.tr,
          subTitle: !isAwarded
              ? 'you_are_about_to_change_the_status_of_this_project_to_not_awarded'.tr
              : 'you_are_about_to_change_the_status_of_this_project_to_awarded'.tr,
          suffixBtnIcon: showJPConfirmationLoader(
              show: controller.isLoading
          ),
          disableButtons: controller.isLoading,
          onTapSuffix: () async {
            controller.toggleIsLoading();
            await awardUnAwardProject(jobId, isAwarded ? 1 : 0, callback);
            controller.toggleIsLoading();
          },
        );
      },
    );
  }

  Future<void> awardUnAwardProject(int? jobId, int newAwardedStage, VoidCallback callback) async {
    try {
      Map<String, dynamic> params = {
        'awarded' : newAwardedStage,
        'id' : jobId
      };
      final bool success = await WorkflowStagesRepository.makeProjectAwarded(params);

      if(success) {
        Helper.showToastMessage(newAwardedStage == 1 ? 'mark_as_awarded'.tr : 'mark_as_not_awarded'.tr);
      }
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
      update();
      callback.call();
    }
  }

  String getTitleText() {
    if(selectedCustomer != null) {
      return selectedCustomer!.fullName!;
    } else {
      if(listType == CJListType.nearByJobs) {
        return 'nearby'.tr;
      } else {
        return 'job_listing'.tr;
      }
    }
  }

  void workFlowStagesListener() {
    stagesListener = workFlowService?.listen((stages) {
      if(stages.isNotEmpty) {
        refreshList(showLoading: true);
      }
    });
  }

  Future<bool> onWillPopup() async {
    stagesListener?.cancel();
    Get.back();
    return false;
  }

  Future<void> onResume() async {
    if(RunModeService.isUnitTestMode) {
      await refreshList(showLoading: true);
    } else {
      bool oldNearByJobAccessState = hasNearByJobAccess;
      hasNearByJobAccess = UserPreferences.hasNearByAccess ?? false;
      if(oldNearByJobAccessState != hasNearByJobAccess) {
        if(!oldNearByJobAccessState) {
          refreshList(showLoading: true);
        }
      }
    }
    update();
  }

  /// Navigates to the job schedule screen for a specific job.
  ///
  /// If the job has more than one schedule, it navigates to the calendar screen.
  /// If the job has only one schedule, it fetches the schedule details and navigates
  /// to the schedule detail screen. Depending on the response from the schedule
  /// detail screen, it updates the job's metadata or marks the job as unscheduled.
  ///
  /// Params:
  /// - [index]: The index of the job in the [jobList].
  Future<void> openJobSchedule(int index) async {
    // Get the job at the specified index.
    final job = jobList[index];

    // Check if the job has more than one schedule.
    if (job.scheduleCount! > 1) {
      // Navigate to the calendar screen with the job's ID.
      Get.toNamed(Routes.calendar,
          arguments: {
            'type': CalendarType.production,
            'job_id': job.id,
          },
          preventDuplicates: false
      );
    } else {
      // Fetch the schedule details for the job.
      final schedule = await fetchSchedule(index);
      // Navigate to the schedule detail screen with the schedule ID.
      final response = await Get.toNamed(Routes.scheduleDetail, arguments: {'id': schedule!.id});
      // If the schedule was updated, fetch the metadata for the job.
      if (response is Map && response['action'] == 'update') {
        fetchMeta(index: index);
        // If the schedule was deleted, mark the job as unscheduled.
      } else if (response is Map && response['action'] == 'delete') {
        job.scheduled = null;
        update();
      }
    }
  }

  Future<SchedulesModel?> fetchSchedule(int index) async {
    Map<String, dynamic> params = {
      'job_id': jobList[index].id
    };
    try {
      showJPLoader(msg: 'fetching_schedule'.tr);
      return (await ScheduleRepository().fetchScheduleList(params))["list"]?[0];
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  /// [openProgressBoard] - Navigates to the progress board screen for a specific job.
  ///
  /// If the job has exactly one production board, it navigates directly to the
  /// progress board screen. If the job has more than one production board, it
  /// opens a helper to handle the selection of the appropriate progress board.
  ///
  /// Params:
  /// - [index]: The index of the job in the [jobList].
  Future<void> openProgressBoard(int index) async {
    // Get the job at the specified index.
    final job = jobList[index];

    // Check if the job has exactly one production board.
    if (job.productionBoards?.length == 1) {
      // Navigate to the progress board screen with the job's production board ID and job number.
      await Get.toNamed(Routes.progressBoard, preventDuplicates: false, arguments: {
        NavigationParams.id: job.productionBoards?[0].id,
        NavigationParams.jobNumber: job.number.toString()
      });

      // Fetch the meta data for the job at the specified index.
      fetchMeta(index: index);
    } else {
      // Open the helper to handle the selection of the appropriate progress board.
      AddToProgressBoardHelper.inProgressBoard(
        jobModel: job,
        index: 0,
        onCallback: ({JobModel? job, int? currentIndex, JobQuickActionCallbackType? callbackType}) {
          // Fetch the meta data for the job at the specified index.
          fetchMeta(index: index);
        },
      );
    }
  }
}