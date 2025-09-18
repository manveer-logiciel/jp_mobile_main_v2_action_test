import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/from_firebase/controller.dart';
import 'package:jobprogress/modules/home/controller.dart';
import 'package:jobprogress/modules/uploads/controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.put(FromFirebaseController());
    Get.put(UploadsListingController());
  }
}
