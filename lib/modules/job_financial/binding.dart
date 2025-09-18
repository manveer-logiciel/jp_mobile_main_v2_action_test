import 'package:get/get.dart';
import 'package:jobprogress/modules/job_financial/controller.dart';

class JobFinancialBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobFinancialController>(() => JobFinancialController());
  }
}
