import 'package:get/get.dart';
import 'controller.dart';

class EmailListingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmailListingController>(() => EmailListingController());
  }
}
