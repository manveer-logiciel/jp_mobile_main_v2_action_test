import 'package:get/get.dart';
import 'controller.dart';

class EmailComposeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmailComposeController>(() => EmailComposeController());
  }
}
