import 'package:get/get.dart';
import 'package:jobprogress/modules/job/job_sale_automation_email_listing/controller.dart';

class JobSaleAutomationEmailLisitngBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobSaleAutomationEmailLisitingController>(() => JobSaleAutomationEmailLisitingController());
  }
}
