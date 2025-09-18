

import 'package:get/get.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';

class FilesListingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FilesListingController>(() => FilesListingController());
  }
}