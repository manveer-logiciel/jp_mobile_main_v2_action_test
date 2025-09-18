import 'package:get/get.dart';
import 'package:jobprogress/common/models/sql/uploader/file_uploader_params.dart';
import 'package:jobprogress/common/services/file_picker.dart';
import 'package:jobprogress/common/services/upload.dart';

class UploadFilePopUpController extends GetxController {

  UploadFilePopUpController(this.params);

  final FileUploaderParams params;

  Future<void> pickPhotosAndAddToQueue() async {
    Get.back();

    // getting photos from storage
    List<String> images = await FilePickerService.pickFile(onlyImages: true);

    // if picked files are not empty add them to upload queue
    if(images.isNotEmpty) {
      UploadService.parseParamsAndAddToQueue(images, params);
    }
  }

  Future<void> pickDocsAndAddToQueue() async {
    Get.back();

    // getting files/docs from storage
    List<String> docs = await FilePickerService.pickFile();

    // if picked files are not empty add them to upload queue
    if(docs.isNotEmpty) {
      UploadService.parseParamsAndAddToQueue(docs, params);
    }
  }

  Future<String?> scanDocAndAddToQueue() async {
    Get.back();
   return UploadService.scanDocAndAddToQueue(params);
  }

  Future<void> takePictureAndAddToQueue() async {
    Get.back();
    UploadService.takePictureAndAddToQueue(params);
  }

}
