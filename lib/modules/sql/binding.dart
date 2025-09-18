import 'package:get/get.dart';
import 'package:jobprogress/modules/sql/controller.dart';

class SqlBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SqlController>(() => SqlController());
  }
}
