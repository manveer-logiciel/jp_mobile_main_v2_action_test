import 'dart:io';

import 'package:get/get.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/utils/file_helper.dart';

class UploadFileTypeHelper {

  static String getUploadFileTypeFromOldFileType(String type) {
    switch(type) {
      case 'company-resources':
        return FileUploadType.companyFiles;
      case 'measurement':
        return FileUploadType.measurements;
      case 'estimate':
        return FileUploadType.estimations;
      case 'job-resources':
        return FileUploadType.photosAndDocs;
      case 'material':
        return FileUploadType.materialList;
      case 'proposal':
        return FileUploadType.formProposals;
      case 'workorder':
        return FileUploadType.workOrder;
      case 'instant-photo':
        return FileUploadType.instantPhoto;
      default:
        return type;
    }
  }

  static String getUploadFileDisplayPathFromOldFileType(String type) {
    switch(type) {
      case 'company-resources':
        return 'company_files'.tr;
      case 'measurement':
        return 'measurements'.tr;
      case 'estimate':
        return 'estimatings'.tr;
      case 'job-resources':
        return 'photos_documents'.tr;
      case 'material':
        return 'materials'.tr;
      case 'proposal':
        return 'forms_proposals'.tr;
      case 'workorder':
        return 'work_orders'.tr;
      case 'instant-photo':
        return 'instant_photo'.tr;
      default:
        return type;
    }
  }

  static Future<String> getNewFilePathFromOldApp(String filePath, String tempFileName) async {
    if(Platform.isAndroid) {
      return FileHelper.cacheStoragePath + tempFileName;
    } else {
      String fileName = filePath.substring(filePath.lastIndexOf('/') + 1);
      final jpFilesFilePath = FileHelper.iosJpFileStoragePath + fileName;
      final isFileExistsInJpFiles = await File(jpFilesFilePath).exists();
      if (isFileExistsInJpFiles) {
        return jpFilesFilePath;
      } else {
        final tmpFilePath = FileHelper.iosTempStoragePath + tempFileName;
        return tmpFilePath;
      }
    }
  }
}