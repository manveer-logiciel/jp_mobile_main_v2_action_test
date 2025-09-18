import '../../../../modules/task/create_task/controller.dart';
import '../../../enums/task_form_type.dart';
import '../../job/job.dart';
import '../../task_listing/task_listing.dart';

class CreateTaskFormParam {
  final CreateTaskFormController? controller;
  final TaskListModel? task;
  final JobModel? jobModel;
  final TaskFormType? pageType;
  final Function(dynamic val)? onUpdate;

  CreateTaskFormParam({
    this.controller,
    this.task,
    this.jobModel,
    this.pageType,
    this.onUpdate
  });
}