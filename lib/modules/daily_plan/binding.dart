import 'package:get/get.dart';
import 'controller.dart';

class DailyTaskBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DailyPlanController>(() => DailyPlanController());
  }
}
