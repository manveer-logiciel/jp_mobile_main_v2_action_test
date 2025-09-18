
import 'package:get/get.dart';
import 'controller.dart';

class SnippetsListingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SnippetsListingController>(() => SnippetsListingController());
  }
}