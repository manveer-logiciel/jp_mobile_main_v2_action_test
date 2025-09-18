import 'package:get/get.dart';
import 'package:jobprogress/modules/job_note/listing/controller.dart';
class JobNoteListingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobNoteListingController>(() => JobNoteListingController());
  }
}
