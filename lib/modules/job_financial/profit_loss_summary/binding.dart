import 'package:get/get.dart';

import 'controller.dart';

class JobProfitLossSummaryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobProfitLossSummaryController>(() => JobProfitLossSummaryController());
  }
}