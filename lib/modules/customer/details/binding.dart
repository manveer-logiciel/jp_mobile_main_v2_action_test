import 'package:get/get.dart';

import 'controller.dart';

class CustomerDetailingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerDetailController>(() => CustomerDetailController());
  }
}
