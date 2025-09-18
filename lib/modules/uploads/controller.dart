import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/sql/uploader/file_uploader_model.dart';
import 'package:jobprogress/common/models/sql/uploader/file_uploader_params.dart';
import 'package:jobprogress/common/repositories/sql/file_uploader.dart';
import 'package:jobprogress/common/services/upload.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/core/utils/file_upload_helpers/upload_file_type_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/routes/pages.dart';

class UploadsListingController extends GetxController {

  List<FileUploaderModel> filesList = []; // will store list of files belonging to logged in user
  List<FileUploaderModel> queue = []; // will store (currently uploading and to be uploaded) files

  GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>(); // helps in animating insert and remove list operations

  bool isAllItemsPaused = true; // will be used to manage Pause All and Resume All state
  bool isUpdatingAllFilesStatus = false;

  late GlobalKey<ScaffoldState> scaffoldKey;

  int currentUploadNumber = 1; // uploading count is used to store value of current upload

  @override
  void onInit() {
    loadUploadItemsList(); // loading items from DB
    super.onInit();
  }

  bool get doShowResumePauseBtn => !filesList.every((file) => file.isUploaded || file.isLargeFile);

  void setUpScaffoldKey() {
    scaffoldKey = GlobalKey<ScaffoldState>();
    listKey = GlobalKey<AnimatedListState>();
  }

  // loadUploadItemsList() : will read DB and load all items that are not uploaded yet
  Future<void> loadUploadItemsList() async {

    try {
      // readingDB
      List<FileUploaderModel> uploadItems = await SqlFileUploaderRepository().getAll();
      // if all file status is pending change first item status to uploading
      if(uploadItems.isNotEmpty) {
        final bool isAllFilePending = uploadItems.every((uploadItem) => uploadItem.fileStatus == FileUploadStatus.pending);
        if(isAllFilePending) {
          uploadItems[0].fileStatus = FileUploadStatus.uploading;
          await SqlFileUploaderRepository().updateStatus(uploadItems[0]);
        }
      }
      // setting up filesList and queue items
      for (var item in uploadItems) {

        final uploadItem = item
          ..localPath = item.createdThrough == 'v1' ?
          await UploadFileTypeHelper.getNewFilePathFromOldApp(item.localPath, item.fileName!) :
          FileHelper.localStoragePath + item.fileName!; // setting up new cache dir path

        if (Helper.isValueNullOrEmpty(uploadItem.thumb)) {
          uploadItem.thumb = Helper.getIconTypeAccordingToExtension(item.localPath);
        }

        filesList.add(uploadItem);

        if(uploadItem.fileStatus != FileUploadStatus.paused && !uploadItem.isLargeFile) {
          // in case last status of file was uploading start uploading that file on restarting app
          if(uploadItem.fileStatus == FileUploadStatus.uploading) uploadFile(filesList.length - 1);
          queue.add(uploadItem);
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      update();
    }
  }

  // cancelUpload() : will take in item index cancels item upload
  Future<void> cancelUpload(int index) async {

    stopUploadingApi(index);

    String fileStatusPrevious = filesList[index].fileStatus!;

    // removing item from local DB
    await SqlFileUploaderRepository().clearOneRecord(filesList[index].id!);

    await FileHelper.deleteFile(filesList[index].localPath);

    final position = queue.indexWhere((element) => element.id == filesList[index].id);

    if(position != -1) queue.removeAt(position); // remove item from queue

    if (queue.isEmpty) currentUploadNumber = 1;

    Helper.showToastMessage('upload_removed'.tr);

    filesList.removeAt(index); // removing item display list

    update();

    // in case cancelled item was in uploading state at the removal time, search for next queue item and start uploading if any
    if(fileStatusPrevious == FileUploadStatus.uploading) {
      chkAndStartUploadingNextQueueItem();
    }
  }

  // onTapFile() : will open file in local file viewer
  void onTapFile(int index)async {
    FileHelper.openLocalFile(filesList[index].localPath);
  }

  // onChangeFileStatus() : will take action as per current status of upload item (eg. paused -> resume) and vice versa
  Future<void> onChangeFileStatus(int index) async {

    if(filesList.length - 1 < index) return;

    switch (filesList[index].fileStatus) {
      case FileUploadStatus.pending:
        await pauseUpload(index);
        break;

      case FileUploadStatus.uploading:
        await pauseUpload(index);
        break;

      case FileUploadStatus.paused:
        if(!await Helper.isNetworkConnected()) {
          Helper.showToastMessage('please_check_your_internet_connection'.tr);
        } else {
          await startResumeUpload(index);
        }
        break;
    }

    update();
  }

  // pauseUpload() : will pause uploading/in queue item
  Future<void> pauseUpload(int index) async {

    stopUploadingApi(index, isPaused: true);

    String fileStatusPrevious = filesList[index].fileStatus!;
    FileUploaderModel uploadItem = filesList[index]
      ..fileStatus = FileUploadStatus.paused; // updating file status

    await SqlFileUploaderRepository().updateStatus(uploadItem); // updating status in local DB

    removeFromQueue(index); // removing item from queue

    if(queue.isEmpty) isAllItemsPaused = true;

    update();

    // in case paused item was in uploading state check for new queue and start uploading if any
    if(fileStatusPrevious == FileUploadStatus.uploading) {
      chkAndStartUploadingNextQueueItem();
    }
  }

  // startResumeUpload() : will start/resume item
  // isItemAlreadyInQueue = false : when item is not in queue
  // isItemAlreadyInQueue = true : when item is already in queue
  Future<void> startResumeUpload(int index, {bool isItemAlreadyInQueue = false}) async {

    FileUploaderModel uploadItem = filesList[index]
      ..fileStatus = getStartedResumedItemStatus(isItemAlreadyInQueue: isItemAlreadyInQueue)
      ..error = null; // updating file status and removing error

    await SqlFileUploaderRepository().updateStatus(uploadItem); // updating local DB status

    if(!isItemAlreadyInQueue) {
      addToQueue(index); // if item is not queue add to queue
    } else {
      uploadFile(index); // if item is already in queue check for upload
    }

    update();
  }

  // getStartedResumedItemStatus() : will return stated/resumed item status
  String getStartedResumedItemStatus({bool isItemAlreadyInQueue = false}) {

    if(isItemAlreadyInQueue) {
      return FileUploadStatus.uploading; // if already in queue change status to uploading
    }

    if(!chkIfAnyItemIsUploading()) {
      return FileUploadStatus.uploading; // if any file is not uploading change status to uploading
    } else {
      return  FileUploadStatus.pending; // if any other file is uploading will set status to pending
    }
  }

  // chkAndStartUploadingNextQueueItem() : will check and and start uploading next queue item
  void chkAndStartUploadingNextQueueItem() {

    final isAnyItemUploading = chkIfAnyItemIsUploading();

    // if no item is uploading and queue has pending uploads start uploading
    if(!isAnyItemUploading && queue.isNotEmpty) {
      int position = filesList.indexWhere((element) => element.id == queue.first.id); // getting first queue item
      startResumeUpload(position, isItemAlreadyInQueue: true); // will start upload
    } else {
      isAllItemsPaused = true;
      update();
    }
  }

  // chkIfAnyItemIsUploading() : will iterate through queue and check if any item is uploading
  bool chkIfAnyItemIsUploading() {
    return queue.any((element) => element.fileStatus == FileUploadStatus.uploading);
  }

  // removeFromQueue() : will remove item from queue
  void removeFromQueue(int index) {
    final position = queue.indexWhere((element) => element.id == filesList[index].id);
    if(position == -1) return;
    FileHelper.deleteFile(filesList[index].localPath);
    queue.removeAt(position);
  }

  // addToQueue() : will add items to queue and will start uploading very first queue item
  void addToQueue(int index, {List<FileUploaderModel>? files}) {

    if(files != null) {
      queue.clear();
      queue.addAll(files);
      UploadService.showFloatingIndicator();
      uploadFile(index); // if no items in queue default behaviour to start uploading selected item
    } else {
      if(queue.isEmpty) {
        UploadService.showFloatingIndicator();
        uploadFile(index); // if no items in queue default behaviour to start uploading selected item
        update();
      }
      queue.add(filesList[index]);
    }
  }

  // uploadFile() : will upload file to server
  Future<void> uploadFile(int index) async {

    if(chkIfAnyItemIsUploading() && queue.isEmpty) return; // in case any file is uploading or queue is empty upload will not happen

    // Verifying if item exists at stored local path
    if(!(await FileHelper.checkFileExist(filesList[index].localPath))) {
      await onErrorUpload(filesList[index].id!, 'file_does_not_exist'.tr); // storing error to DB and pausing upload
      return;
    }

    isAllItemsPaused = false;

    //Uploading file to server
    UploadService.upload(
        itemData: filesList[index],
        onProgressUpdate: (double progress) {
          // updating upload progress
          filesList[index].progress?.value = progress;
        },
        onFileUploaded: (int id, dynamic response) async {
          await onFileUploaded(id, response);
        },
        onError: (int id, String error) async {
          await onErrorUpload(id, error);
        }
    );
  }

  // onFileUploaded() : will handle removing item from local DB and from display list also
  Future<void> onFileUploaded(int id, Map<String, dynamic> response) async {

    try {

      final itemCurrentIndex = filesList.indexWhere((element) => element.id == id);
      final uploadedItem = filesList[itemCurrentIndex];

      removeFromQueue(itemCurrentIndex); // will remove item from uploads queue

      filesList[itemCurrentIndex].fileStatus = FileUploadStatus.uploaded;

      if(Get.currentRoute != Routes.uploadsListing) {
        filesList.removeAt(itemCurrentIndex);
      }

      await SqlFileUploaderRepository().clearOneRecord(uploadedItem.id!);

      currentUploadNumber++;
      if(queue.isEmpty) {
        isAllItemsPaused = true;
        currentUploadNumber = 1;
      }
      update();

      UploadService.addUploadedFileToList(uploadedItem, response);

      // checking if queue is not empty start uploading next queue item
      chkAndStartUploadingNextQueueItem();

    } catch (e) {
      onErrorUpload(id, 'upload_failed'.tr); // storing error to local DB if any
      rethrow;
    }
  }

  // chkIfAnyFileForThisJobPendingInQueue() : will check if any having same job and parent id as of uploaded item is in queue
  bool chkIfAnyFileForThisJobPendingInQueue(FileUploaderModel item) {
    final params = FileUploaderParams.fromJson(item.params);
    return queue.any((element) => element.params['job_id'] == params.jobId && element.params['parent_id'] == params.parentId);
  }

  // onErrorUpload() : will handle file errors
  Future<void> onErrorUpload(int id, String error) async {

    final itemCurrentIndex = filesList.indexWhere((element) => element.id == id);

    final uploadedItem = filesList[itemCurrentIndex]
      ..fileStatus = FileUploadStatus.paused
      ..error = error; // pausing item and setting up error

    await SqlFileUploaderRepository().updateStatus(uploadedItem); // updating local DB status

    removeFromQueue(itemCurrentIndex);
    if(queue.isEmpty) isAllItemsPaused = true;
    update();

    // checking if queue is not empty start uploading next queue item
    chkAndStartUploadingNextQueueItem();
  }

  // stopUploadingApi() will cancel upload api request
  void stopUploadingApi(int index, {bool isPaused = false}) {
    filesList[index].cancelToken?.cancel();

    if(isPaused) {
      filesList[index].cancelToken = CancelToken(); // setting up new cancel request token
    }
    filesList[index].progress?.value = 0; // will set progress to zero
  }

  // resumeAll() : will resume all paused uploads
  Future<void> resumeAll() async {
    if(!await Helper.isNetworkConnected()) {
      Helper.showToastMessage('please_check_your_internet_connection'.tr);
      return;
    }

    toggleIsUpdatingAllFilesStatus(true);

    int? startingUploadFrom;
    List<FileUploaderModel> tempFilesList = [];

    for(int i=0; i<filesList.length; i++) {

      if(filesList[i].isUploaded || filesList[i].isLargeFile) {
        continue;
      }

      startingUploadFrom ??= i;

      // setting uploading status for very first uploading item and adding to queue to others
      filesList[i].fileStatus = FileUploadStatus.pending;
      filesList[i].error = null; // removing error if any

      await SqlFileUploaderRepository().updateStatus(filesList[i]); // updating status in local DB

      tempFilesList.add(filesList[i]);
    }

    if(tempFilesList.isEmpty) {
      toggleIsUpdatingAllFilesStatus(false);
      return;
    } else {
      filesList[startingUploadFrom ?? 0].fileStatus = FileUploadStatus.uploading;
      await SqlFileUploaderRepository().updateStatus(filesList[startingUploadFrom ?? 0]); // updating status in local DB
    }
    addToQueue(startingUploadFrom ?? 0, files: tempFilesList); // adding resumed item to queue

    currentUploadNumber = 1;
    isAllItemsPaused = false;
    toggleIsUpdatingAllFilesStatus(false);

  }

  // pauseAll() : will pause all queue items
  Future<void> pauseAll({bool forcePause = false}) async {

    toggleIsUpdatingAllFilesStatus(true);

    for(int i=0; i<filesList.length; i++) {

      if(filesList[i].isUploaded || filesList[i].isLargeFile) continue;

      // when file is uploaded and and waiting for api response, no need to pause that file
      if((filesList[i].progress?.value != 1 || forcePause) && filesList[i].error == null) {
        stopUploadingApi(i, isPaused: true); // cancelling all api requests

        filesList[i].fileStatus = FileUploadStatus.paused;
        filesList[i].error = null;

        await SqlFileUploaderRepository().updateStatus(
            filesList[i]); // updating local DB status
      }
    }

    currentUploadNumber = 1;
    isAllItemsPaused = true;
    queue.clear();

    toggleIsUpdatingAllFilesStatus(false);
  }

  double getUploadingFileProgress() {
    if(queue.isEmpty) return 0;
    return queue.first.progress?.value ?? 0;
  }

  String getProgressCount() {

    bool doNotShowCount = isAllItemsPaused || isUpdatingAllFilesStatus;

    final currentFileNumber = doNotShowCount ? 0 : currentUploadNumber;
    final currentOutOfFilesNumber = doNotShowCount ? 0 : (queue.length + currentFileNumber - 1);

    return doNotShowCount ? "" : "$currentFileNumber/$currentOutOfFilesNumber";
  }

  Future<bool> removeUploadedFiles({bool isInitialLoad = false}) async {

    if(!isInitialLoad) showJPLoader();

    final uploadsToRemove = filesList.where((upload) => upload.isUploaded);

    for (var file in uploadsToRemove) {

      // removing item from local DB
      await SqlFileUploaderRepository().clearOneRecord(file.id!);

      await FileHelper.deleteFile(file.localPath);
    }

    filesList.removeWhere((upload) => upload.isUploaded);

    if(!isInitialLoad) {
      Get.back();
      Get.back();
    }
      return false;
  }

  void toggleIsUpdatingAllFilesStatus(bool val) {
    isUpdatingAllFilesStatus = val;
    update();
  }

}