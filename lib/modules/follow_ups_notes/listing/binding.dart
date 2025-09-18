import 'package:get/get.dart';
import 'package:jobprogress/modules/follow_ups_notes/listing/controller.dart';

class FollowUpsNotesListingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FollowUpsNotesListingController>(() => FollowUpsNotesListingController());
  }
}
