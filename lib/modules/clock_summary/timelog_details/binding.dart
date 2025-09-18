
import 'package:get/get.dart';
import 'package:jobprogress/modules/clock_summary/timelog_details/controller.dart';

class TimeLogDetailsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TimeLogDetailsController>(() => TimeLogDetailsController());
  }
}