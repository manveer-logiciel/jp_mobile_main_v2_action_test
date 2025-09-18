
import 'package:get/get.dart';
import 'package:jobprogress/modules/appointment_details/controller.dart';

class AppointmentDetailsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppointmentDetailsController>(() => AppointmentDetailsController());
  }
}