import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:jobprogress/common/enums/firebase.dart';
import 'package:jobprogress/common/extensions/mix_panel/extension.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/sql/user/user_param.dart';
import 'package:jobprogress/common/models/sql/user/user_response.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/common/models/task_listing/task_listing_filter.dart';
import 'package:jobprogress/common/providers/firebase/realtime_db.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/repositories/sql/user.dart';
import 'package:jobprogress/common/repositories/task_listing.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/common/services/task/quick_actions.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/mix_panel/event/common_events.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/model.dart';

import '../../../common/enums/task_form_type.dart';

class TaskListingController extends GetxController {
  List<TaskListModel> taskList = [];
  List<UserModel> userList = [];
  bool isLoading = true;
  bool isLoadMore = false;
  bool canShowLoadMore = false;
  bool isDeleting = false;

  int? jobId = Get.arguments == null ? null : Get.arguments['jobId'];
  int? taskId = Get.arguments?[NavigationParams.taskId];

  TaskListingFilterModel filterKeys = TaskListingFilterModel();

  JobModel? job;

  final firebaseStream = RealtimeDBProvider.streamsMap[RealTimeKeyType.taskUpcomingUpdated];

  List<JPSingleSelectModel> filterByList = [
    JPSingleSelectModel(id: 'my_pending_tasks', label: "my_pending_tasks".tr),
    JPSingleSelectModel(id: 'my_todays_tasks', label: "my_todays_tasks".tr),
    JPSingleSelectModel(id: 'my_future_tasks', label: "my_future_tasks".tr),
    JPSingleSelectModel(id: 'my_past_tasks', label: "my_past_tasks".tr),
    JPSingleSelectModel(
        id: 'my_completed_tasks', label: "my_completed_tasks".tr),
    JPSingleSelectModel(
        id: 'tasks_created_by_me', label: "tasks_created_by_me".tr),
    JPSingleSelectModel(id: 'all_tasks', label: "all_tasks".tr),
    JPSingleSelectModel(id: 'custom', label: "custom".tr),
  ];

  String selectedFilterByOptions = Get.arguments?[NavigationParams.taskFilter] ?? 'my_pending_tasks';

  List<JPSingleSelectModel> sortByList = [
    JPSingleSelectModel(id: 'due_date', label: "due_date".tr), 
    JPSingleSelectModel(id: 'created_at', label: "created_at".tr),
  ];

  List<JPSingleSelectModel> sortByAllList = [
    JPSingleSelectModel(id: 'due_date', label: "due_date".tr),
    JPSingleSelectModel(id: 'created_at', label: "created_at".tr),
    JPSingleSelectModel(id: 'completed', label: "completed_date".tr),
  ];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  //Getting queryParameter to send in task listing api
  Map<String, dynamic> getQueryParams() {
    filterKeys.jobId = jobId;
    Map<String, dynamic> queryParams = {
      "includes[0]": ["created_by"],
      "includes[1]": ["user"],
      "includes[2]": ["job"],
      "includes[3]": ["customer"],
      "includes[4]": ["participants"],
      "includes[5]": ["attachments"],
      "includes[6]": ["stage"],
      "includes[7]": ["message"],
      "includes[8]": ["completed_by"],
      ...filterKeys.toJson()
    };

    if (queryParams['duration'] == 'next_week' || queryParams['duration'] == 'last_month' || queryParams['duration'] == 'none') {
      queryParams.remove('duration');
    }

    if(selectedFilterByOptions != 'createdByMe' && filterKeys.jobId != null) {
      queryParams.remove('type');
    }

    queryParams.removeWhere((key, value) => value == null);

    return queryParams;
  }

  //Fetching task listing from api
  Future<void> fetchTask() async {
    try {
      Map<String, dynamic> queryParams = getQueryParams();

      Map<String, dynamic> response = await TaskListingRepository().fetchTaskList(queryParams);
      List<TaskListModel> list = response["list"]; 
      

      if (!isLoadMore) {
        taskList = [];
      }

      taskList.addAll(list);

      canShowLoadMore = taskList.length < response["pagination"]["total"];
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      isLoadMore = false;
      update();
    }
  }

  //Setting task listing params according to selected filters
  void setFilterKeys(TaskListingFilterModel? params) {
    filterKeys = TaskListingFilterModel();

    switch (selectedFilterByOptions) {
      case 'my_pending_tasks':
        filterKeys.sortOrder = 'ASC';
        filterKeys.status = 'pending';
        filterKeys.sortBy = 'due_date';
        break;

      case 'my_todays_tasks':
        filterKeys.sortOrder = 'ASC';
        filterKeys.status = 'all';
        filterKeys.sortBy = 'created_at';
        filterKeys.duration = 'today';
        break;

      case 'my_future_tasks':
        filterKeys.sortOrder = 'ASC';
        filterKeys.status = 'all';
        filterKeys.sortBy = 'due_date';
        filterKeys.dateRangeType = 'task_due_date';
        filterKeys.duration = 'upcoming';
        filterKeys.startDate = Jiffy.now().add(days: 1).format(pattern: DateFormatConstants.dateServerFormat);
        break;

      case 'my_past_tasks':
        filterKeys.sortOrder = 'DESC';
        filterKeys.status = 'all';
        filterKeys.sortBy = 'due_date';
        filterKeys.duration = 'past';
        filterKeys.dateRangeType = 'task_due_date';
        break;

      case 'my_completed_tasks':
        filterKeys.sortOrder = 'DESC';
        filterKeys.status = 'completed';
        filterKeys.sortBy = 'completed';
        break;

      case 'tasks_created_by_me':
        filterKeys.sortOrder = 'DESC';
        filterKeys.status = 'all';
        filterKeys.sortBy = 'created_at';
        filterKeys.type = 'created';
        break;

      case 'all_tasks':
        filterKeys.sortOrder = 'DESC';
        filterKeys.status = 'all';
        filterKeys.sortBy = 'created_at';
        break;

      case 'custom':
        if (params != null) {
          filterKeys.duration = params.duration;
          filterKeys.status = params.status;
          filterKeys.includeLockedTask = params.includeLockedTask;
          filterKeys.onlyHighPriorityTask = params.onlyHighPriorityTask;
          filterKeys.reminderNotification = params.reminderNotification;
          filterKeys.userId = params.userId == -1 ? null : params.userId;

          switch (params.duration) {
            case 'next_week':
              filterKeys.dateRangeType = 'task_due_date';
              DateTime nextWeek = Jiffy.now().add(weeks: 1).dateTime;

              DateTime startDate = nextWeek.subtract(Duration(days: nextWeek.weekday - 1));
              DateTime endDate = nextWeek.add(Duration(days: DateTime.daysPerWeek - nextWeek.weekday));

              filterKeys.startDate = DateTimeHelper.format(startDate, DateFormatConstants.dateServerFormat);
              filterKeys.endDate = DateTimeHelper.format(endDate, DateFormatConstants.dateServerFormat);
              break;
            case 'last_month':
              filterKeys.dateRangeType = 'task_due_date';
              filterKeys.startDate = Jiffy.now().add(months: -1).startOf(Unit.month).format(pattern: DateFormatConstants.dateServerFormat);
              filterKeys.endDate = Jiffy.now().add(months: -1).endOf(Unit.month).format(pattern: DateFormatConstants.dateServerFormat);
              break;
            default:
          }
        }
        break;

      default:
    }
  }

  sortListing() {
    filterKeys.page = 1;
    filterKeys.sortOrder = filterKeys.sortOrder == 'ASC' ? 'DESC' : 'ASC';
    isLoading = true;
    update();
    fetchTask();
    MixPanelService.trackEvent(event: MixPanelCommonEvent.sortFilterSuccess);
  }

  applyFilters(TaskListingFilterModel? params) {
    setFilterKeys(params);
    filterKeys.page = 1;
    isLoading = true;
    update();
    fetchTask().trackFilterEvents();
  }

  applySortFilters() {
    filterKeys.page = 1;
    filterKeys.sortBy = filterKeys.sortBy;
    isLoading = true;
    update();
    fetchTask().trackSortFilterEvents();
  }

  Future<void> loadMore() async {
    filterKeys.page += 1;
    isLoadMore = true;
    await fetchTask();
  }

  ///showLoading is used to show shimmer if refresh is pressed from main drawer
  Future<void> refreshList({bool? showLoading}) async {
    filterKeys.page = 1;

    ///   show shimmer if showLoading = true
    isLoading = showLoading ?? true;
    update();
    await fetchTask();
  }

  void handleQuickActionUpdate(TaskListModel task, String action) {
    int index = taskList.indexWhere((element) => element.id == task.id);

    if (index == -1) {
      return;
    }
    switch (action) {
      case 'mark_as_complete':
        taskList[index].completed = task.completed;
        break;

      case 'edit':
        navigateToCreateTask(task: task);
        break;

      case 'delete':
        taskList.removeAt(index);
        break;
      
      case 'add_to_daily_plan':
        taskList[index].dueDate = task.dueDate;
        break;
      case 'unlock_stage_change':
        taskList[index].locked = false;
        break;
      case 'link_to_job_project':
        update();
        fetchTask();
        break;
      default:
    }

    update();
  }

  Future<void> getUserList() async {
    UserParamModel requestParams = UserParamModel(
      limit: 0,
      withSubContractorPrime: true
    );

    UserResponseModel userResponse = await SqlUserRepository().get(params: requestParams);

    userList = userResponse.data;
    
    userList.insert(0, UserModel(id: -1, firstName: '', fullName: 'None', email: ''));

    update();
  }

  Future<void> getJob() async {
    try {
      final jobsCountParams = <String, dynamic>{
        'id': jobId,
        'includes[0]': ['count:with_ev_reports(true)'],
        'includes[1]': ['job_message_count'],
        'includes[2]': ['upcoming_appointment_count'],
        'includes[3]': ['Job_note_count'],
        'includes[4]': ['job_task_count'],
        'includes[5]': ['upcoming_appointment'],
        'includes[6]': ['workflow'],
        'incomplete_task_lock_count': 1,
        'track_job': 1
      };
    if(jobId != null){
      job = (await JobRepository.fetchJob(jobId!, params: jobsCountParams))['job'];
    }
    
    } catch (e) {
      rethrow;
    } finally {
      update();
    }
  }

  Future<void> navigateToCreateTask({TaskListModel? task}) async{
    final result = await Get.toNamed(Routes.createTaskForm, arguments: {
      NavigationParams.task: task,
      NavigationParams.jobModel: job,
      NavigationParams.pageType: task == null ? TaskFormType.createForm : TaskFormType.editForm,
    });
    if(result != null && result["status"]) {
      refreshList(showLoading: true);
    }
  }

  @override
  void onInit() async{
    super.onInit();
    setFilterKeys(null);
    await Future.wait([
      getJob(),
      fetchTask(),
      getUserList()
    ]);

    firebaseStream?.onData((data) {
      refreshList();
    });
    openTaskDetail();
    
  }

  void openTaskDetail() {
    if(taskId != null) {
      TaskService.openTaskdetail(
        id: taskId,
        callback: handleQuickActionUpdate,
      );
    }
  }

  void updateSortByList(String value) {
    sortByList.clear();
    sortByList.addAll(sortByAllList);

    switch(value) {
      case 'my_pending_tasks':
        sortByList.removeWhere((element) => element.id == 'completed');
        break;
      case 'my_todays_tasks':
        sortByList.removeWhere((element) => element.id == 'due_date');
        break;
    }

    update();
  }
}
