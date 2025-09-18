import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/core/utils/file_upload_helpers/upload_file_api_url.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/Thumb/icon_type.dart';

class FileUploaderModel {

  int? id;
  int? userId;
  int? companyId;
  String? fileStatus;
  late String localPath;
  late String displayPath;
  String? fileName;
  late String apiAddress;
  late String type;
  late Map<String, dynamic> params;
  Rx<double>? progress;
  CancelToken? cancelToken;
  late List<String> filePaths;
  JPThumbIconType? thumb;
  String? error;
  String? createdAt;
  String? updatedAt;
  bool isLargeFile;
  String? fileFormParamKey;
  bool? isGoogleSheet;
  String? createdThrough;

  FileUploaderModel({
    this.id,
    this.userId,
    this.companyId,
    this.fileStatus = FileUploadStatus.pending,
    required this.filePaths,
    this.localPath = '',
    required this.displayPath,
    this.fileName,
    this.apiAddress = '',
    required this.params,
    required this.type,
    this.progress,
    this.cancelToken,
    this.thumb,
    this.error,
    this.createdAt,
    this.updatedAt,
    this.isLargeFile = false,
    this.fileFormParamKey,
    this.isGoogleSheet = false,
    this.createdThrough
  }) {
    progress = RxDouble(0.0);
  }

  bool get isUploaded => fileStatus == FileUploadStatus.uploaded && progress?.value == 1;

  factory FileUploaderModel.copy(FileUploaderModel itemData, String path) {

    String fileName = FileHelper.getFileName(path);
    bool isLargeFile = FileHelper.checkIfLargeFile(path);

    itemData.thumb = Helper.getIconTypeAccordingToExtension(path);

    if(isLargeFile) {
      itemData.error = 'large_file_error'.tr + ' ${FileHelper.fileInMegaBytes(Helper.flagBasedUploadSize(fileSize: CommonConstants.maxAllowedFileSize))} ${'mb'.tr}';
    } else {
      itemData.error = null;
    }


    return FileUploaderModel(
        id: itemData.id,
        params: itemData.params,
        userId: itemData.userId,
        companyId: itemData.companyId,
        type: itemData.type.toString(),
        apiAddress: (itemData.isGoogleSheet ?? false) ? UploadFileTypeApiUrl.getGoogleSheetUrl(itemData.type) : UploadFileTypeApiUrl.getUrl(itemData.type),
        displayPath: itemData.displayPath,
        filePaths: [],
        isLargeFile: isLargeFile,
        fileStatus: itemData.fileStatus,
        fileName: fileName,
        localPath: path,
        isGoogleSheet: itemData.isGoogleSheet,
        error: itemData.error,
        progress: RxDouble(0.0),
        cancelToken: itemData.cancelToken ?? CancelToken(),
        thumb: itemData.thumb,
        fileFormParamKey: itemData.type == FileUploadType.xactimate ? 'xactimate' : null,
        createdAt: itemData.createdAt,
        updatedAt: itemData.updatedAt
    );
  }

  FileUploaderModel.fromJson(Map<String, dynamic> data) : isLargeFile = false {
    id = data['id'];
    userId = data['user_id'];
    companyId = data['company_id'];
    fileStatus = data['file_status'];
    localPath = data['local_path'];
    displayPath = data['display_path'] ?? '';
    fileName = data['file_name'];
    type = data['type'].toString();
    apiAddress = UploadFileTypeApiUrl.getUrl(type);
    createdAt = data['created_at'];
    updatedAt = data['updated_at'] ?? data['uploaded_at'];
    if(data['params'] is Map<String, dynamic>) {
      params = data['params'];
    } else {
      params = jsonDecode(data['params']);
    }
    error = data['error'];
    cancelToken = CancelToken();
    if(!FileHelper.checkIfImage(localPath)) {
      thumb = Helper.getIconTypeAccordingToExtension(localPath);
    }
    progress = RxDouble(0.0);
    isLargeFile = FileHelper.checkIfLargeFile(localPath);
    createdThrough = data['created_through'];
  }

  // this function is used while inserting data in to local db
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['company_id'] = companyId;
    data['file_status'] = fileStatus;
    data['local_path'] = localPath;
    data['display_path'] = displayPath;
    data['file_name'] = fileName;
    data['type'] = type.toString();
    data['error'] = error;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['params'] = jsonEncode(params);
    data['created_through'] = createdThrough;
    return data;
  }

}