
import 'package:get/get.dart';
import 'controller.dart';

class MacroListingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MacroListingController>(() => MacroListingController());
  }
}