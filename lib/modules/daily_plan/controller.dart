import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/event_form_type.dart';
import 'package:jobprogress/common/enums/task_form_type.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/common/repositories/appointment.dart';
import 'package:jobprogress/common/repositories/schedule.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/routes/pages.dart';
import '../../common/models/appointment/appointment.dart';
import '../../common/models/schedules/schedules.dart';
import '../../common/repositories/task_listing.dart';
import '../../common/services/daily_plan/quick_actions.dart';
import '../../core/constants/date_formats.dart';

class DailyPlanController extends GetxController {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<AppointmentModel> appointmentList = [];
  List<TaskListModel> taskList = [];
  List<SchedulesModel> schedulesList = [];
  String currentDate = '';
  bool isLoading = true;
  bool isDeleting = false;
  int id = 0;

  bool get showPlaceHolder => appointmentList.isEmpty 
  && taskList.isEmpty
  && (schedulesList.isEmpty || !FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.production]));

  Map<String, dynamic> appointmentsPlanParams() {
    return <String, dynamic>{
      'duration': 'today',
      'for': 'current',
      'includes[0]': 'customer',
      'includes[1]': 'jobs',
      'includes[2]': 'attendees',
      'includes[3]': 'created_by',
      'includes[4]': 'reminders',
      'includes[5]': 'attachments',
      'limit': 0,
      'sort_by': 'start_date_time',
      'sort_order': 'asc',
    };
  }

  Map<String, dynamic> tasksPlanParams() {
    return <String, dynamic>{
      'duration': ['today'],
      'includes[0]': ['created_by'],
      'includes[1]': ['job'],
      'includes[2]': ['customer'],
      'includes[3]': ['participants'],
      'includes[4]': ['attachments'],
      'includes[5]': ['stage'],
      'limit': 0,
      'status': ['pending'],
      'type': ['assigned'],
    };
  }

  Map<String, dynamic> schedulesPlanParams() {
    if (AuthService.userDetails != null) {
      id = AuthService.userDetails!.id;
    }
    return <String, dynamic>{
      'date': getCurrentDate(),
      'limit': 0,
      'includes[0]': 'trades',
      'includes[1]': 'attachments_count',
      'includes[2]': 'job.address',
      'job_rep_ids[0]': id,
      'includes[3]': ' work_types',
      'includes[4]': 'reps',
      'includes[5]': 'sub_contractors',
      'includes[6]': 'job_estimators',
    };
  }

  Future<void> getAll() async {
    try {
      List<Map<String, dynamic>> response = (await Future.wait([
        AppointmentRepository().fetchAppointmentsList(appointmentsPlanParams()),
        TaskListingRepository()
            .fetchTaskList(tasksPlanParams(), type: 'dailyplan'),
        ScheduleRepository().fetchScheduleList(schedulesPlanParams()),
      ]));

      setAppointmentList(response[0]);
      setTasksList(response[1]);
      setSchedulesList(response[2]);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> refreshList({bool? showLoading}) async {
    isLoading = showLoading ?? false;
    update();
    await getAll();
  }

  setAppointmentList(Map<String, dynamic> response) {
    List<AppointmentModel> list = response["list"];
    appointmentList.clear();
    appointmentList.addAll(list);
  }

  setTasksList(Map<String, dynamic> response) {
    List<TaskListModel> list = response["list"];
    taskList.clear();
    taskList.addAll(list);
  }

  setSchedulesList(Map<String, dynamic> response) {
    List<SchedulesModel> list = response["list"];
    schedulesList.clear();
    schedulesList.addAll(list);
  }

  String getCurrentDate() {
    return DateTimeHelper.format(DateTime.now().toString(), DateFormatConstants.dateServerFormat);
  }

  void handleTaskQuickActionUpdate(TaskListModel task, String action) {
    int index = taskList.indexWhere((element) => element.id == task.id);
    switch (action) {      
      case 'edit':
        navigateToCreateTask(task : task);
        break;

      case 'mark_as_complete':
      case 'delete':
        int index = taskList.indexWhere((element) => element.id == task.id);
        taskList.removeAt(index);
        break;
      
      case 'unlock_stage_change':
        taskList[index].locked = false;
        break;
      
      default:
    }

    update();
  }

  Future<void> navigateToCreateTask({TaskListModel? task}) async{
    final result = await Get.toNamed(Routes.createTaskForm, arguments: {
      NavigationParams.task: task,
      NavigationParams.pageType: task == null ? TaskFormType.createForm : TaskFormType.editForm,
    });

    if(result != null && result["status"]) {
      refreshList(showLoading: true);
    }
  }

  void handleAppointmentQuickActionUpdate(AppointmentModel task, String action,
      {String? actionFrom}) {
    int index = appointmentList.indexWhere((element) => element.id == task.id);
    switch (action) {
      case 'delete':
        appointmentList.removeAt(index);
        break;
      case 'view':
        navigateToAppointmentDetails(index);
        break;
      case 'edit':
        refreshList(showLoading: true);
        break;
      default:
    }

    update();
  }

  void handleScheduleQuickActionUpdate(SchedulesModel schedule, String action) {
    int index =
        schedulesList.indexWhere((element) => element.id == schedule.id);
    switch (action) {
      case 'edit':
        navigateToCreateScheduleEvent(schedule);
        break;
      case 'view':
        navigateToScheduleDetails(index);
        break;

      case 'delete':
        schedulesList.removeAt(index);
        break;
      default:
        refreshList(showLoading: true);
    }

    update();
  }

  Future<void> navigateToAppointmentDetails(int i) async {
    final response = await Get.toNamed(
      Routes.appointmentDetails,
      arguments: {'appointment_id': appointmentList[i].id},
    );

    if (response != null && response['action'] != null) {
      handleAppointmentQuickActionUpdate(
          appointmentList[i], response['action']);
    } else if (response?['appointment'] != null) {
      Timer(const Duration(milliseconds: 300), () {
        appointmentList[i] = response['appointment'];
        update();
      });
    } else if(response != null && response["status"]){
      refreshList(showLoading: true);
    } else {
      Timer(const Duration(milliseconds: 300), () {
        update();
      });
    }
  }

  Future<void> navigateToScheduleDetails(int i) async {
    final response = await Get.toNamed(Routes.scheduleDetail,
        arguments: {'id': schedulesList[i].id});

    if (response is Map && response['action'] != null) {
      handleScheduleQuickActionUpdate(schedulesList[i], response['action']);
    } else {
      Timer(const Duration(milliseconds: 300), () {
        update();
      });
    }
  }

  @override
  void onInit() {
    super.onInit();
    getAll();
  }

  Future<void> navigateToCreateScheduleEvent(SchedulesModel schedule) async {
    dynamic data = await Get.toNamed(Routes.createEventForm, preventDuplicates: false, arguments: {
      NavigationParams.pageType: schedule.job != null && schedule.id != null
          ? EventFormType.editScheduleForm : EventFormType.editForm,
      NavigationParams.jobModel: schedule.job,
      NavigationParams.schedulesModel: schedule,
    });

    if(data != null) {
      refreshList(showLoading: true);
    }
  }

  void openQuickActions() {
    DailyPlanService.openQuickActions(() {
      refreshList(showLoading: true);
    });
  }
}
