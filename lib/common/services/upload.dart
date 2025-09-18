
import 'dart:async';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_upload.dart';
import 'package:jobprogress/common/models/sql/uploader/file_uploader_model.dart';
import 'package:jobprogress/common/models/sql/uploader/file_uploader_params.dart';
import 'package:jobprogress/common/repositories/sql/file_uploader.dart';
import 'package:jobprogress/common/repositories/upload.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/file_picker.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/utils/file_upload_helpers/upload_file_display_path.dart';
import 'package:jobprogress/core/utils/file_upload_helpers/upload_file_type_params.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/recent_files/controller.dart';
import 'package:jobprogress/global_widgets/upload_file_options_bottomsheet/index.dart';
import 'package:jobprogress/global_widgets/upload_indicator/controller.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';
import 'package:jobprogress/modules/uploads/controller.dart';

class UploadService {

  /// will initialize UploadsListingController()
  static init() {
      Get.put(UploadsListingController());
  }

  /// addToQueue() will add all items to queue
  static Future<void> addToQueue({required FileUploaderModel itemData}) async {

    try {

      showJPLoader(msg: 'adding_to_queue'.tr);

      List<FileUploaderModel> allItems = [];

      // finding controller instance
      final controller = Get.find<UploadsListingController>();

      // reading user credentials
      final userId = AuthService.userDetails?.id;
      itemData.userId = userId;

      final companyId = AuthService.userDetails?.companyId;
      itemData.companyId = companyId;

      for(int i=0; i<itemData.filePaths.length; i++) {

        final path = itemData.filePaths[i];
        
        allItems.add(
            FileUploaderModel.copy(itemData, path)
        );
      }

      // adding all file items to local DB
      final response = await SqlFileUploaderRepository().bulkInsert(allItems);

      // setting up display list and queue and starting upload if necessary
      for (int i=0; i<response.length; i++) {
        if (allItems[i].isLargeFile) {
          allItems[i].id = int.parse(response[i].toString());
          controller.filesList.add(allItems[i]);
        } else {
          if (controller.queue.isEmpty) {
            allItems[i].fileStatus = FileUploadStatus.uploading;
          }
          allItems[i].id = int.parse(response[i].toString());
          controller.filesList.add(allItems[i]);
          controller.addToQueue(controller.filesList.length - 1);
        }
      }

      Helper.showToastMessage(
          itemData.filePaths.length == 1
              ? 'file_added_to_queue'.tr
              : '${itemData.filePaths.length} ${'files_added_to_queue'.tr}'
      );

    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  /// upload() : is an intermediate between repository and controller
  static Future<void> upload({
    required FileUploaderModel itemData,
    required Function(double progress) onProgressUpdate,
    required Function(int id, dynamic response) onFileUploaded,
    required Function(int id, String error) onError,
  }) async {

    try {

      await UploadRepository.uploadFileToServer(
          uploadItem: itemData,
          onProgressUpdate: onProgressUpdate,
          onFileUploaded: onFileUploaded,
          onError: onError
      );

    } catch (e) {
      rethrow;
    }
  }

  /// pauseAllUploads() : will pause all uploads (can be used during logout, company switch etc)
  static Future<void> pauseAllUploads() async {

    if(!Get.isRegistered<UploadsListingController>()) return;

    final controller = Get.find<UploadsListingController>();
    await controller.pauseAll();
  }

  /// addUploadedFileToList() : will helps in refreshing list if currently active
  static void addUploadedFileToList(FileUploaderModel item, Map<String, dynamic> response) {

    // getting upload controller instance
    final controller = Get.find<UploadsListingController>();

    // if any item related to same job and module is in queue then then list will not refresh
    if(controller.chkIfAnyFileForThisJobPendingInQueue(item)) return;

    final params = FileUploaderParams.fromJson(item.params);

    // setting up controller tag to find currently active listing
    final String controllerTag = item.type + (params.jobId ?? "").toString();

    // if recent files is active or in job overview screen is active
    if(Get.isRegistered<RecentFilesController>(tag: controllerTag)) {
      final recentFileController = Get.find<RecentFilesController>(tag: controllerTag);
      recentFileController.onRefresh(
          showLoading: recentFileController.resourceList.isNotEmpty,
      );
    }

    // if listing is active or in view only then refresh will take place
    if(Get.isRegistered<FilesListingController>(tag: controllerTag)) {

      final controller = Get.find<FilesListingController>(tag: controllerTag);
      
      int? parentId = controller.getParentId(controller.folderPath.length - 1);

      // if user is currently in folder where he uploaded files only then refresh will take place
      if(params.parentId == parentId && !controller.isInSelectionMode) {
        controller.onRefresh(showLoading: true);
        controller.update();
      }

    }
  }

  /// takePictureAndAddToQueue() : will take picture from camera and add it to queue
  static Future<void> takePictureAndAddToQueue(FileUploaderParams params) async {

    String? path = await FilePickerService.takePhoto();

    if(path == null) return; // if image is not taken no need to proceed further
    await parseParamsAndAddToQueue([path], params);
    // Additional delay for closing the iOS view presenter
    // iOS view presenter closes with an animation and that asynchronous handling is missing from [image_picker] plugin
    // and opening the camera when previous presenter view is not properly closed [UIImagePickerController]
    // tries to access the closed presenter view and fails to open camera
    await Future<dynamic>.delayed(const Duration(milliseconds: 500));
    await takePictureAndAddToQueue(params);
  }

  static Future<String?> scanDocAndAddToQueue(FileUploaderParams params) async {

    final scannedDoc = await FilePickerService.scanDocument();

    if(scannedDoc.isNotEmpty) {
      parseParamsAndAddToQueue(scannedDoc, params);
    }
    return null;
  }

  static Future<void> parseParamsAndAddToQueue(List<String> paths, FileUploaderParams params,{bool isGoogleSheet = false,Map<String,dynamic>? additionalParams}) async {

    final fileCreatedAt = DateTime.now().toString();

    // adding file to queue
    await addToQueue(
      itemData: FileUploaderModel(
          filePaths: paths,
          displayPath: UploadFileTypeDisplayPath.path(params),
          params: isGoogleSheet ? UploadFileTypeParams.getGoogleSheetParams(params,additionalParams!) : UploadFileTypeParams.getParams(params),
          type: params.type,
          isGoogleSheet: isGoogleSheet,
          createdAt: fileCreatedAt,
          updatedAt: fileCreatedAt
      ),
    );
  }

  static void uploadFrom({required UploadFileFrom from, required FileUploaderParams params}) {
    
    switch (from) {
      case UploadFileFrom.popup:
        showJPBottomSheet(
          child: (_) {
            return UploadFilePopUp(
              params: params,
            );
          },
        );
        break;

      case UploadFileFrom.scanner:
        UploadService.scanDocAndAddToQueue(params);
        break;
    }
  }

  static void showFloatingIndicator() {

    if(!Get.isRegistered<UploadIndicatorController>()) return;
    final controller = Get.find<UploadIndicatorController>();
    controller.unHideIndicator();

  }

  static Future<void> handleOrientationChange() async {
    if(!Get.isRegistered<UploadIndicatorController>()) return;
    final controller = Get.find<UploadIndicatorController>();
    // additional duration for ui to get rendered before updating upload-indicator position
    await Future<void>.delayed(const Duration(milliseconds: 100));
    controller.onPanEnd();
  }

  static void loadUploadFiles() {
    if(!Get.isRegistered<UploadsListingController>()) return;

    final controller = Get.find<UploadsListingController>();
     if(controller.filesList.isEmpty) {
       controller.loadUploadItemsList();
     }
  }
}