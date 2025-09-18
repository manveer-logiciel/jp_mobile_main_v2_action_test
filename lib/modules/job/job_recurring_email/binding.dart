import 'package:get/get.dart';
import 'package:jobprogress/modules/job/job_recurring_email/controller.dart';

class JobRecurringEmailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobRecurringEmailController>(() => JobRecurringEmailController());
  }
}