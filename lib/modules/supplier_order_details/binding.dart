import 'package:get/get.dart';
import 'controller.dart';

class SrsOrderDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupplierOrderDetailController>(() => SupplierOrderDetailController());
  }
}