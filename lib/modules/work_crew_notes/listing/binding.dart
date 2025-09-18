import 'package:get/get.dart';
import 'package:jobprogress/modules/work_crew_notes/listing/controller.dart';
class WorkCrewNotesListingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WorkCrewNotesListingController>(() => WorkCrewNotesListingController());
  }
}
