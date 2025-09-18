import 'package:get/get.dart';

import 'controller.dart';

class JobSummaryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobSummaryController>(() => JobSummaryController());
  }
}