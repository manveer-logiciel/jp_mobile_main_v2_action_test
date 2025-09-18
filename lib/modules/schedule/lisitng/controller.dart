import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/models/schedules/filter_model.dart';
import 'package:jobprogress/common/models/schedules/schedules.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/repositories/schedule.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/dropdown_list_constants.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/routes/pages.dart';

class SchedulesListingController extends GetxController {

  bool isLoading = true; // helps in manging loading state
  bool isLoadingMore = false; // helps in checking whether more data is beaing loaded
  bool canShowMore = false; // helps in checking whether load more can be performed
  bool canShowConfirmationStatus = false; // helps in deciding whether to display confirmation status

  List<SchedulesModel> schedules = []; // stores the schedules

  JobModel? job; // stores data loaded job

  int? jobId = Get.arguments?[NavigationParams.jobId]; // used for loading job
  String? resourceId = Get.arguments?[NavigationParams.resourceId]; // used for loading schedules
  String? resourceName = Get.arguments?[NavigationParams.title]; // used for display purpose

  JobScheduleFilterModel listingParams = JobScheduleFilterModel(); // helps in generating params

  String get secondaryHeaderTitle => "${'work_order'.tr.toUpperCase()} - ${resourceName ?? ""}";

  @override
  void onInit() {
    checkIfCanShowConfirmation();
    fetchData();
    super.onInit();
  }

  /// [checkIfCanShowConfirmation] whether confirmation can be viewed to user or not
  Future<void> checkIfCanShowConfirmation() async {
    final setting = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.showScheduleConfirmationStatus);
    canShowConfirmationStatus = Helper.isTrue(setting);
  }

  /// [fetchJob] make a request to server to fetch job
  Future<void> fetchJob() async {
    try {
      if (jobId == null) return;

      Map<String, dynamic> params = {
        'id': jobId,
        'includes[]': 'flags.color'
      };

      final response = await JobRepository.fetchJob(jobId!, params: params);
      job = response['job'];
    } catch (e) {
      rethrow;
    }
  }

  /// [fetchSchedules] make a request to server to fetch schedules
  Future<void> fetchSchedules() async {
    try {
      if (job == null) return;
      final params = listingParams.toListingJson();
      final response = await ScheduleRepository().fetchScheduleList(params);

      List<SchedulesModel> list = response['list'];
      PaginationModel pagination = response['pagination'];

      if (!isLoadingMore) {
        schedules = [];
      }

      schedules.addAll(list);
      canShowMore = schedules.length < pagination.total!;
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      isLoadingMore = false;
      update();
    }
  }

  /// [fetchData] helps in initially loading data and setting it up
  Future<void> fetchData() async {
    try {
      initParams();
      await fetchJob();
      await fetchSchedules();
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      isLoadingMore = false;
      update();
    }
  }

  /// [initParams] used to set up default param values
  void initParams() {
    listingParams.jobId = jobId;
    listingParams.workOrderIds = resourceId;
  }

  Future<void> loadMore() async {
    listingParams.page += 1;
    isLoadingMore = true;
    await fetchData();
  }

  Future<void> refreshList({bool? showLoading}) async {
    listingParams.page = 1;
    isLoading = showLoading ?? false;
    update();
    await fetchData();
  }

  void cancelOnGoingRequest() {
    cancelToken?.cancel();
  }

  /// [onTapSchedule] handles tap on schedule tile
  Future<void> onTapSchedule(int index) async {
    final response = await Get.toNamed(Routes.scheduleDetail, arguments: {
      'id': schedules[index].id,
    });

    if (response is SchedulesModel) {
      schedules[index] = response;
    } else if (response != null) {
      schedules.clear();
      isLoading = true;
      fetchSchedules();
    }
    update();
  }

  /// [onTapConfirmation] handles tap on confirmation status
  /// [index] - is the index on current item
  /// [accept] - [true]: while accepting the confirmation
  ///            [false]: while declining the confirmation
  void onTapConfirmation(int index, {bool accept = true}) {
    // in case of recurring options sheet will be shown to select from
    if (schedules[index].isRecurring) {
      showUpdateForSheet(index, accept);
    } else {
      // otherwise status will be updated for current schedule
      updateConfirmation(index, accept: accept, onlyThis: true);
    }
  }

  /// [showUpdateForSheet] displays the the sheet to select schedule update type
  void showUpdateForSheet(int index, bool accept) {
    SingleSelectHelper.openSingleSelect(
      DropdownListConstants.updateScheduleTypeList,
      "",
      "update_for".tr,
       (value) {
        Get.back();
        final onlyThis = value == 'this';
        updateConfirmation(index, accept: accept, onlyThis: onlyThis);
      },
    );
  }

  /// [updateConfirmation] makes an api call to server to update schedule confirmation
  Future<void> updateConfirmation(int index, {
    required bool accept,
    required bool onlyThis,
  }) async {
    bool doReFetchSchedules = false;
    try {
      // displaying loader
      showJPLoader();
      Map<String, dynamic> params = {
        "only_this": onlyThis ? 1 : 0,
      };
      // getting necessary details
      final scheduleId = schedules[index].id.toString();
      final key = accept ? 'mark_as_accept' : '';
      // making api call to update confirmation
      doReFetchSchedules = await JobRepository.markAction(params, scheduleId, key);
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
      // re-fetch schedules if all request was successful
      if (doReFetchSchedules) reFetchSchedules();
    }
  }

  /// [reFetchSchedules] clears the previous schedule data and re-load them
  void reFetchSchedules() {
    schedules.clear();
    isLoading = true;
    update();
    // reloading schedules
    fetchSchedules();
  }

  @override
  void dispose() {
    cancelOnGoingRequest();
    super.dispose();
  }

  Future<bool> onWillPop() async {
    cancelOnGoingRequest();
    Get.back(result: schedules);
    return true;
  }
}