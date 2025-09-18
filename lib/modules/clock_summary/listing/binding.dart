
import 'package:get/get.dart';
import 'package:jobprogress/modules/clock_summary/listing/controller.dart';

class ClockSummaryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClockSummaryController>(() => ClockSummaryController());
  }
}