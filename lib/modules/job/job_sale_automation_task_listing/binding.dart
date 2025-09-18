import 'package:get/get.dart';
import 'package:jobprogress/modules/job/job_sale_automation_task_listing/controller.dart';


class JobSaleAutomationTaskListingBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(JobSaleAutomationTaskLisitingController());
  }
}
