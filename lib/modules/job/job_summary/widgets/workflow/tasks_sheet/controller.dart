
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/common/repositories/task_listing.dart';
import 'package:jobprogress/core/constants/pagination_constants.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';

class JobOverViewTaskSheetController extends GetxController {

  JobOverViewTaskSheetController(this.job, this.selectedStages, this.onDone);

  final JobModel job; // used to store job data
  final List<String> selectedStages; // stores list of selected stages

  final Future<void> Function()? onDone; // call back to workflow stages

  List<TaskListModel> tasks = []; // stores list of task

  bool isLoading = true; // helps in managing task list loading
  bool isUpdatingStage = false; // helps in managing button loading state

  @override
  void onInit() {
    loadAllTasks();
    super.onInit();
  }

  // loadAllTasks() : fetch all tasks from server
  Future<void> loadAllTasks() async {
    try {

      Map<String, dynamic> params = {
        "include_locked_task" : 1,
        "includes[]": "stage",
        "job_id": job.id,
        "status": "pending",
        "stage_code[]": selectedStages,
        "limit": PaginationConstants.pageLimit250
      };

      final response = await TaskListingRepository().fetchTaskList(params);
      tasks = response['list'];

    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  // markAsCompleted() : marks task as complete or in-complete
  Future<void> markAsCompleted(int index) async {
    try {

      showJPLoader();

      final response = await TaskListingRepository().markTaskAsComplete(tasks[index].id, tasks[index].completed);

      tasks[index].completed = response.completed;

    } catch (e) {
      rethrow;
    } finally {
      Get.back();
      update();
    }
  }

  bool isProceedButtonDisabled() {
    return tasks.any((element) => element.completed == null) || isLoading;
  }

  Future<void> proceed() async {
    toggleIsUpdatingStage();
    await onDone!();
    toggleIsUpdatingStage();
    Get.back();
  }

  void toggleIsUpdatingStage() {
    isUpdatingStage = !isUpdatingStage;
    update();
  }

}