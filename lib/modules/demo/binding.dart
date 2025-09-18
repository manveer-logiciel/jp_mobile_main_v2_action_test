import 'package:get/get.dart';
import 'package:jobprogress/modules/demo/controller.dart';

class DemoBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DemoController>(() => DemoController());
  }
}
