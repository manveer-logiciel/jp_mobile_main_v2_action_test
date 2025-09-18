import 'package:get/get.dart';

import 'controller.dart';

class CustomerListingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerListingController>(() => CustomerListingController());
  }
}
