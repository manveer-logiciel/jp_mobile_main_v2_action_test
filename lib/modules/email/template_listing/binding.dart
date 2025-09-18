import 'package:get/get.dart';
import 'controller.dart';

class EmailTemplateListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmailTemplateListingController>(() => EmailTemplateListingController());
  }
}
