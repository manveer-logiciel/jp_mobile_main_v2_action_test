import 'package:get/get.dart';
import 'controller.dart';

class EmailDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmailDetailController>(() => EmailDetailController());
  }
}
