import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/model.dart';

import '../../../../common/enums/cj_list_type.dart';
import '../../../../common/enums/event_form_type.dart';
import '../../../../common/models/job/job.dart';
import '../../../../common/models/schedules/filter_model.dart';
import '../../../../common/models/workflow_stage.dart';
import '../../../../common/repositories/schedule.dart';
import '../../../../common/repositories/stage_resources.dart';
import '../../../../core/constants/navigation_parms_constants.dart';
import '../../../../global_widgets/profile_image_widget/index.dart';
import '../../../../routes/pages.dart';

class JobScheduleListingController extends GetxController {

  bool isLoading = true;
  bool isLoadMore = false;
  bool canShowLoadMore = false;

  int? totalScheduleJobs;
  int? totalUnScheduleJobs;

  List<JobModel> jobList = [];
  List<JPSingleSelectModel>? stages;
  JPSingleSelectModel? selectedStage;

  CJListType listType = CJListType.scheduledJobs;

  TextEditingController textController = TextEditingController();

  JobScheduleFilterModel filterKeys = JobScheduleFilterModel();

  @override
  void onInit() async {
    super.onInit();
    await fetchStages();
    await fetchJobCount();
    fetchJobs();
  }

  /////////////////////////////   FETCH JOB   ////////////////////////////

  Future<void> fetchJobs() async {
    try {
      Map<String, dynamic> response = await ScheduleRepository().fetchUnscheduledList(filterKeys.toJson());
      List<JobModel> list = response["list"];
      if (!isLoadMore) {
        jobList = [];
      }
      jobList.addAll(list);

      canShowLoadMore = jobList.length < response["pagination"]["total"];
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      isLoadMore = false;
      update();
    }
  }

  Future<void> fetchJobCount() async {
    try {
      Map<String, dynamic> queryParams = {
        "stage_code" : selectedStage?.id,
        "stages": selectedStage?.id,
      };
      Map<String, dynamic> response = await ScheduleRepository().fetchJobCount(queryParams);
      totalScheduleJobs = response["schedule_jobs"];
      totalUnScheduleJobs = response["un_schedule_jobs"];
    } catch (e) {
      rethrow;
    } finally {
      update();
    }
  }

  Future<void> fetchStages() async {
    List<WorkFlowStageModel?> stageList = await StageResourcesRepository.fetchStages();
    String? jobAwardedStage = await JobRepository.getJobAwardedStage();
    if(stageList.isNotEmpty) {
      stages = [];
      for (var stage in stageList) {
        stages?.add(
          JPSingleSelectModel(
            label: "${stage?.name.toString().capitalizeFirst ?? ''} (${stage?.jobsCount})",
            id: stage?.code ?? '',
            child: JPProfileImage(
              color: stage?.color,
            ),
          ),
        );
      }

      selectedStage = stages?.firstWhereOrNull((element) => element.id == jobAwardedStage) ?? stages?.first;
      filterKeys.stages = selectedStage?.id;
      update();
    }

  }

  //////////////////////////////   REFRESH LIST   //////////////////////////////
  ///showLoading is used to show shimmer if refresh is pressed from main drawer
  Future<void> refreshList({bool? showLoading}) async {
    filterKeys.page = 1;
    ///   show shimmer if showLoading = true
    isLoading = showLoading ?? false;
    update();
    await fetchJobs();
  }

  ////////////////////////////   FETCH NEXT PAGE   /////////////////////////////
  Future<void> loadMore() async {
    filterKeys.page += 1;
    isLoadMore = true;
    await fetchJobs();
  }

  ///////////////////////    NAVIGATE TO DETAIL SCREEN   ///////////////////////

  Future<void> navigateToEditSchedule({int? jobID, int? currentIndex}) async {
    dynamic data = await Get.toNamed(Routes.createEventForm, preventDuplicates: false, arguments: {
      NavigationParams.pageType: EventFormType.createScheduleForm,
      NavigationParams.jobModel: jobList[currentIndex!],
      NavigationParams.schedulesModel: jobList[currentIndex].upcomingSchedules,
    });
    if(data != null) {
      Get.back(result: {'action' : 'created'});
    }
  }

  //////////////////////////////////////////////////////////////////////////////

  Future<void> onSearchTextChanged(String text) async {
    filterKeys.keyword = text;
    filterKeys.page = 1;
    isLoading = true;
    update();
    fetchJobs();
  }

  Future<void> applySortFilters(String value) async {
    Get.back();
    filterKeys.page = 1;
    selectedStage = stages?.firstWhere((element) => element.id == value);
    filterKeys.stages = selectedStage?.id;
    totalScheduleJobs = totalUnScheduleJobs = null;
    isLoading = true;
    update();
    await fetchJobCount();
    fetchJobs();
  }

}