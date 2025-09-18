import 'package:get/get.dart';
import 'package:jobprogress/modules/uploads/controller.dart';

class UploadsListingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UploadsListingController>(() => UploadsListingController());
  }
}