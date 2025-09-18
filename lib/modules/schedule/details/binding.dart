import 'package:get/get.dart';
import 'controller.dart';

class ScheduleDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScheduleDetailController>(() => ScheduleDetailController());
  }
}
