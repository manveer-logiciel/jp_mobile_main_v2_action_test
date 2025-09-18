import 'package:get/get.dart';
import 'package:jobprogress/modules/notification_listing/controller.dart';

class NotificationListingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationListingController>(() => NotificationListingController());
  }
}
