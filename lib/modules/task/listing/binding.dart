import 'package:get/get.dart';
import 'package:jobprogress/modules/task/listing/controller.dart';

class TaskListingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskListingController>(() => TaskListingController());
  }
}
