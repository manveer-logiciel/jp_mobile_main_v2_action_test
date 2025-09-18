import 'package:get/get.dart';
import 'controller.dart';

class TaskTemplateListingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskTemplateListingController>(() =>TaskTemplateListingController());
  }
}
