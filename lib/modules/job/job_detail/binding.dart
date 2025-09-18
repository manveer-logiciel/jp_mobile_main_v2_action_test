import 'package:get/get.dart';

import 'controller.dart';

class JobDetailingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobDetailController>(() => JobDetailController());
  }
}