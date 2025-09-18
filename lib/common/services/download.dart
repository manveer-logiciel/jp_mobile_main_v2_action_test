import 'dart:io';

import 'package:jobprogress/common/repositories/download.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/printing_helper.dart';
import 'package:jobprogress/core/utils/share_file_helper.dart';
import 'package:path_provider/path_provider.dart';

class DownloadService {
  //Checking if file already downloaded then opening downloaded file else downaloding file from server
  // action(open, print, share)
  // onReceiveProgress - Download progress
  static Future<String?> downloadFile(String url, String fileName, {
    String? action = 'open',
    void Function(int, int)? onReceiveProgress,
    String? classType
  }) async {

    bool isExtensionMissing = Helper.isValueNullOrEmpty(FileHelper.getFileExtension(fileName));
    if (isExtensionMissing && classType != null) {
      fileName += '.$classType';
    }

    if (FileHelper.checkIsUnsupportedFile(fileName, action!)) return null;

    Directory tempDir = await getTemporaryDirectory();
    String filePath = '${tempDir.path}/$fileName';
    bool isFileExist = await FileHelper.checkFileExist(filePath);
    if (isFileExist) {
      return perfomActionAfterDownload(action, filePath);
    } else {
      Directory tempDir = await getTemporaryDirectory();
      filePath = '${tempDir.path}/$fileName';
      filePath = await DownloadRepository.downloadFileFromServer(
          url, filePath, onReceiveProgress);
      return perfomActionAfterDownload(action, filePath);
    }
  }

  static String? perfomActionAfterDownload(String action, String filePath) {
    switch (action) {
      case 'open':
        FileHelper.openLocalFile(filePath);
        break;

      case 'print':
        String? ext = FileHelper.getFileExtension(filePath);
        if(ext != 'doc' && ext != 'ai') {
          PrintingHelper.printFile(filePath);
        } else {
          FileHelper.openLocalFile(filePath, type: 'application/pdf');
        }
        break;

      case 'share':
        ShareFileHelper.shareFile(filePath);
        break;

      case 'mms':
      case 'getFilePath':
        return filePath;

      default:
        FileHelper.openLocalFile(filePath);
        break;
    }
    return null;
  }
}
