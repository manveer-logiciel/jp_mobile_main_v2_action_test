import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/common/repositories/automation.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/repositories/task_listing.dart';
import 'package:jobprogress/core/constants/automation.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/recurring_constant.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../common/enums/task_form_type.dart';
import '../../../common/models/forms/create_task/create_task_form_param.dart';
import '../../../global_widgets/bottom_sheet/index.dart';
import '../../task/create_task/form/index.dart';

class JobSaleAutomationTaskLisitingController extends GetxController {
 
  int? jobId = Get.arguments == null ? null : Get.arguments['jobId']; 
  
  String? stageCode = Get.arguments == null ? null : Get.arguments['stage_code'];
  
  bool sendCustomerEmail = Get.arguments == null ? false : Get.arguments['send_customer_email'] ?? false;

  String automationId = Get.arguments?[NavigationParams.automationId].toString() ?? ''; 
  
  JobModel? job;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  bool isLoading = true;
  bool isDataValid = false;
  bool buttonLoading = false;
  bool hideSendButton = false;
  bool taskSentOrSkipped = false;


  List<TaskListModel> taskList = [];

  AutoScrollController scrollController = AutoScrollController(
    axis: Axis.vertical,
    initialScrollOffset: 0,
  ); 
   
   Future<void> getJobSummaryData() async {
    try {
      final jobSummaryParams = <String, dynamic> {
        'include[0]': 'sub_contractors',
        'include[1]': 'contact',
        'include[2]': 'customer.contacts',
        'include[3]': 'customer.referred_by',
        'id': jobId,
        'track_job': 1,
      };
      job = (await JobRepository.fetchJob(jobId!, params: jobSummaryParams))['job'];
    } catch (e) {
      rethrow;
    } 
  }

  Future<void> getTasksTemplateList() async {
    try {
      final params = <String, dynamic> {
        'includes[0]': 'participants',
        'includes[1]': 'notify_user',
        'includes[2]': 'stage',
        'job_id': jobId,
        'limit': 0,
        'stage_code': stageCode
      };
      Map<String, dynamic> response = await TaskListingRepository().fetchRecurringTaskList(params);
      List<TaskListModel> list = response['list'];
      taskList = list;
    } catch (e) {
      rethrow;
    } 
  }

  void updateSendButtonVisibility() {
    hideSendButton = taskList.every((task) => task.send == true) ? true : false;
    update();
  }

  void navigateToNextScreen() {
    if(sendCustomerEmail) {
      Get.back(result: taskSentOrSkipped);
    }
    Get.back(result: taskSentOrSkipped);
  }

  Future<bool> automationStatusUpdate(String id, {required String emailStatus}) async {
    if(Helper.isValueNullOrEmpty(id)) {
      return false;
    }
    try{
      final params = <String, dynamic> {
        'email_automation_status': emailStatus,
        'task_automation_status': emailStatus,
      };
      return  AutomationRepository().updateEmailTaskAutomationStatus(id:id, params: params);
    } catch(e) {
      rethrow;
    }
  }

  void toggleCheckBox({required int index, required List<TaskListModel> taskList}) {
    taskList[index].isChecked = !taskList[index].isChecked;
    if(taskList.every((element) => element.isChecked == false)){
      hideSendButton = true;
    } else {
      hideSendButton = false;
    }
    update();
  }

  void scrollList(int index) {
    Timer(const Duration(milliseconds: 700), () async {
      scrollController.scrollToIndex(
        index,
        preferPosition: AutoScrollPosition.begin,
        duration: const Duration(milliseconds: 1000)
      );
    });
  }

  void validateData(List<TaskListModel> taskList) {
    bool dataValid = true;

    for (int i = 0; i < taskList.length; i++) {
      final task = taskList[i];

      if (task.isChecked) {
        task.isAssigneEmpty = Helper.isValueNullOrEmpty(task.participants);
        task.isDueOnEmpty = task.isDueDateReminder && Helper.isValueNullOrEmpty(task.dueDate);

        if (task.isAssigneEmpty || task.isDueOnEmpty) {
          dataValid = false;
          if (taskList.length > 4) {
            scrollList(i);
          }
        }
      } else {
        task.isAssigneEmpty = false;
        task.isDueOnEmpty = false;
      }
      update();
    }
    isDataValid = dataValid;
  }

  void validateSingleTask(TaskListModel task) {
    bool dataValid = true;

    if (task.isChecked) {
    task.isAssigneEmpty = Helper.isValueNullOrEmpty(task.participants);
    task.isDueOnEmpty = task.isDueDateReminder && Helper.isValueNullOrEmpty(task.dueDate);

    if (task.isAssigneEmpty || task.isDueOnEmpty) {
      dataValid = false;
    }
    } else {
      task.isAssigneEmpty = false;
      task.isDueOnEmpty = false;
    }
    update();

    isDataValid = dataValid;
  }

  void addUsers(List<String> customerType , List<UserLimitedModel> user, JobModel job) {
    for(String customer in customerType) {
      if(customer == RecurringConstants.customerUnderscoreRep) {
        if(job.customer!.rep != null) {
            user.add(job.customer!.rep!);
        }
      }
      if(customer == RecurringConstants.companyUnderScoreCrew) {
        for(UserLimitedModel reps in job.reps!) {
          user.add(reps);  
        }
      }
      if(customer == RecurringConstants.subs) {
        for(UserLimitedModel subContractors in job.subContractors!) {
          user.add(subContractors);
        }
      }
      if(customer == RecurringConstants.estimators) {
        for(UserLimitedModel estimators in job.estimators!) {
          user.add(estimators);
        }
      }
    } 
  }

   void refreshPage() {
    isLoading = true;
    update();
    getAllData();
  }

  void addSettingUserandFiltering() {
    for(TaskListModel task in taskList) {
      addUsers(task.assignToSetting!, task.participants!,job!);
      addUsers(task.notifyUserSetting!, task.notifyUsers!,job!);
      task.participants = Helper.filterDuplicatesByKey(task.participants ?? [], (participant) => participant.id);
      task.notifyUsers = Helper.filterDuplicatesByKey(task.notifyUsers ?? [], (notifyUser) => notifyUser.id);
    }
  }

  void sendData() async {
    validateData(taskList);
    if(isDataValid) {
      buttonLoading = true;
      final taskListingModelParams = <String, dynamic> {
        "job_id": jobId,
        "tasks":[
          for(int i = 0; i < taskList.length; i++)
          if(taskList[i].isChecked)
            taskList[i].toTemplateJson()
        ]
      };
      try {
        await TaskListingRepository().sendTaskListingModelData(taskListingModelParams);
        await Future<void>.delayed(const Duration(milliseconds: 200));
        taskSentOrSkipped = await automationStatusUpdate(automationId, emailStatus: AutomationConstants.sent);
        navigateToNextScreen();
      } catch(e) {
        rethrow;
      } finally {
        buttonLoading = false;
        update();
      } 
    }     
  }

  void skipTask() async {
    taskSentOrSkipped = await automationStatusUpdate(automationId, emailStatus: AutomationConstants.skipped);
    navigateToNextScreen();
  }
    
  Future<void> getAllData() async {
    try{
      await Future.wait([
        getJobSummaryData(),
        getTasksTemplateList(),
      ]);
      addSettingUserandFiltering();
      setInitialParticipants();
      updateSendButtonVisibility();
    } catch(e) {
      rethrow;
    } finally {
      
      isLoading = false;
      update();
    } 
  }

  void setInitialParticipants() {
    for (TaskListModel task in taskList) {
      task.initialParticipants = [];
      for (UserLimitedModel participant in task.participants!) {
        task.initialParticipants!.add(UserLimitedModel.copy(participant));
      }
    }
  }
  
  @override
  void onInit() async {
   await getAllData();
    super.onInit();   
  }

  Future<void> navigateToEditTask({int? index}) async {
    List<UserLimitedModel> prevTaskAssigne = taskList[index!].participants!;
    
    showJPBottomSheet(
      isScrollControlled: true,
      ignoreSafeArea: false,
      enableInsets: true,
      child: (_) => CreateTaskForm(
        createTaskFormParam: CreateTaskFormParam(
          task: taskList[index],
          jobModel: job,
          pageType: TaskFormType.salesAutomation,
          onUpdate: (val) {
            updateTaskParticipants(index, val, prevTaskAssigne);
            validateSingleTask(taskList[index]);
            taskList[index] = val;
            update();
            Get.back();
          },
        ),
      ),
    );
  }

  void updateTaskParticipants(int index, TaskListModel val, List<UserLimitedModel> prevTaskAssigned) { 
    List<UserLimitedModel> updatedTaskAssigned = val.participants!;    
    if (prevTaskAssigned.toString() != updatedTaskAssigned.toString()) {
      taskList[index].send = false;
      taskList[index].isChecked = true;
      hideSendButton = false;
    }
    if(taskList[index].initialParticipants.toString() == updatedTaskAssigned.toString() && !Helper.isValueNullOrEmpty(taskList[index].tasks)) {
      taskList[index].send = true;
      taskList[index].isChecked = false;
      updateSendButtonVisibility();
    }
  }
}
