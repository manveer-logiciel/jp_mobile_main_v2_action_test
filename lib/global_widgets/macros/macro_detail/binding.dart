import 'package:get/get.dart';
import 'controller.dart';

class MacroProductBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MacroProductController>(() => MacroProductController());
  }
}