import 'package:get/get.dart';
import 'package:jobprogress/modules/appointments/listing/controller.dart';

class AppointmentListingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppointmentListingController>(() => AppointmentListingController());
  }
}
