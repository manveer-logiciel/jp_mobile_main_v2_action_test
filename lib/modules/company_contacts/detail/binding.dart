import 'package:get/get.dart';
import 'controller.dart';

class CompanyContactListingViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompanyContactViewController>(
        () => CompanyContactViewController());
  }
}
