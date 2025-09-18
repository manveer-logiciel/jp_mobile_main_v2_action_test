import 'package:get/get.dart';

import 'controller.dart';

class CustomerJobSearchBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerJobSearchController>(() => CustomerJobSearchController());
  }
}
