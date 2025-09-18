import 'package:get/get.dart';
import 'package:jobprogress/common/models/sql/uploader/file_uploader_model.dart';
import 'package:jobprogress/common/services/upload.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class UploadProgressDialogController<T> extends GetxController {

  UploadProgressDialogController(this.filePaths, this.onAllFilesUploaded, {
    this.uploadType = FileUploadType.attachment
  });

  double progress = 0.0; // helps in displaying progress of currently uploading item

  int fileNumber = 1; // helps in displaying number of uploaded files

  bool isFileUploaded = false; // helps in managing state while waiting for server response

  List<String> filePaths = []; // list of file paths to be uploaded
  List<T> uploadedFiles = []; // stores uploaded files
  List<FileUploaderModel> filesList = []; // stores to be uploaded items

  Function(List<T> files) onAllFilesUploaded; // callback occurs when all files are uploaded

  String? uploadType; // uploadType decides the type of upload dialog is going to perform

  @override
  void onInit() {
    generateUploadItemsList();
    super.onInit();
  }

  // generateUploadItemsList() : Generates to be uploaded items list and start uploading them
  void generateUploadItemsList() {
    // creating common params
    final params = FileUploaderModel(
      filePaths: [],
      displayPath: "",
      params: {},
      type: uploadType ?? FileUploadType.attachment,
    );
    // generating upload items list
    for (int i=0; i<filePaths.length; i++) {
      params.id = 0;
      filesList.add(
        FileUploaderModel.copy(
          params,
          filePaths[i],
        ),
      );
    }

    uploadFiles();

  }

  // uploadFiles() : Uploads files to server one by one
  Future<void> uploadFiles() async {
    for (int i=0; i<filesList.length; i++) {
      await UploadService.upload(
          itemData: filesList[i],
          onProgressUpdate: onProgressUpdate,
          onFileUploaded: onFileUploaded,
          onError: onUploadError,
      );
    }
  }

  void onProgressUpdate(double val) {
    progress = val;
    if(val == 1.0) {
      isFileUploaded = true;
    }
    update();
  }

  // onFileUploaded() : adds uploaded file to uploadedFiles, and also send callback
  // when all files are uploaded
  void onFileUploaded(int id, dynamic response) {
    if(filesList[id].cancelToken?.isCancelled ?? false) {
      return;
    }
    uploadedFiles.add(response);

    if(uploadedFiles.length == filePaths.length) {
      onAllFilesUploaded(uploadedFiles);
      Get.back();
      return;
    }
    updateUploadFileCount();
  }

  // onUploadError() : displays error as a toast message
  void onUploadError(int id, String error) {
    Helper.showToastMessage(error);
    Get.back();
  }

  // updateUploadFileCount() : updates file count after each single file uploads
  void updateUploadFileCount() {
    fileNumber++;
    isFileUploaded = false;
    progress = 0.0;
    update();
  }

  // onCancellingUpload() : cancels currently uploading and to be uploaded items
  void onCancellingUpload() {
    for (var item in filesList) {
      item.cancelToken?.cancel();
    }
    Helper.showToastMessage('upload_cancelled'.tr);
    Get.back();
  }

}