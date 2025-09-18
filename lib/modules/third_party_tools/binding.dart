import 'package:get/get.dart';
import 'controller.dart';

class ThirdPartyToolsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ThirdPartyToolsController>(() => ThirdPartyToolsController());
  }
}
