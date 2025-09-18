import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/platform_permissions.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FileHelper {

  static String localStoragePath = '';
  static String cacheStoragePath = '';
  static String iosTempStoragePath = '';
  static String iosJpFileStoragePath = '';

  //For open device file
  static openLocalFile(String path, {
    String? type
  }) async {
    OpenResult result = await OpenFile.open(path, type: type);
    if (result.type == ResultType.permissionDenied) {
      bool isGranted = await PlatformPermissionService.requestExternalStoragePermission();
      if (isGranted) openLocalFile(path);
    } else if(result.type != ResultType.done) {
      Helper.showToastMessage(result.message.capitalizeFirst!);
    }
  }

  //to check if file exist or not
  static Future<bool> checkFileExist(String filePath) async {
    return File(filePath).exists();
  }

  //For save file in given path
  static Future<File> saveFile(String filePath, List<int> buffer) async {
    File file = File(filePath);
    await file.create(recursive: true);
    var raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(buffer);
    await raf.close();
    return file;
  }

  static Future<File> saveBase64File(Uint8List base64, String fileName) async {
    Directory tempDir = await getTemporaryDirectory();
    String filePath = '${tempDir.path}/$fileName';

    File file = await FileHelper.saveFile(filePath, base64);

    return file;
  }


  //to get file name from file path
  static String getFileName(String filePath) {
    return filePath.replaceAll('%2', '').split('/').last;
  }

  //to get file extension from file path
  static String? getFileExtension(String filePath) {
    String fileName = getFileName(filePath);
    String extensionName = fileName.split('.').last.toLowerCase();
    if(FileUploadSupportedFiles.extensions.contains(extensionName)) {
      return extensionName;
    }
    return null;
  }

  static Future<Uint8List> readFileAsByte(String filePath) async {
    Uri myUri = Uri.parse(filePath);
    File file = File.fromUri(myUri);
    Uint8List bytes = await file.readAsBytes();
    return bytes;
  }

  static Future<String> readFileAsString(String filePath) async {
    Uri myUri = Uri.parse(filePath);
    File file = File.fromUri(myUri);
    String text = await file.readAsString();
    return text;
  }

  // This function will give file size with data unit
  static String getFileSizeWithUnit(int size) {
    double kb = size / 1000;
    double mb = size / 1000000;

    if (kb < 1024) {
      return '${kb.toStringAsFixed(2)} KB';
    } else {
      return '${mb.toStringAsFixed(2)} MB';
    }
  }

  // This function will takes in the file path and
  // decides on the basis on extension whether it is a image file or not
  static bool checkIfImage(String path) {
    String extensionName = path.split('.').last.toLowerCase().trim();
    return extensionName.contains('jpg') || extensionName.contains('png') || extensionName.contains('jpeg') || extensionName.contains('jfif') || extensionName.contains('webp');
  }

  static bool checkIfImagePhotosDocument(String path){
    final splitPath = path.split('.').last.toLowerCase().trim();
    return splitPath.contains('jpg') || splitPath.contains('png') || splitPath.contains('jpeg');
  }

  static Future<String> getTempDirPath() async {
    return '${(await getTemporaryDirectory()).path}/';
  }

  /// filterFilePath() : removes unwanted characters from picked file
  static String filterFilePath(String path) {
    return path.replaceAll('file:///', '').replaceAll('%20', ' ');
  }

  /// saveToTempDirectory() : can be used to save files to temp directory (with in app)
  /// so can accessed later and go through in no-affect with changes to original file
  static Future<List<String>> saveToTempDirectory(List<String?> filePaths, {bool doShowLoader = true}) async {
    List<String> tempFiles = [];

    if(doShowLoader) showJPLoader(msg: '${'preparing_files'.tr}...');

    for (var path in filePaths) {

      if(path != null) {
        try {

          final filePath = filterFilePath(path);
          final newPath = getUniqueFileName(getFileName(path));

          final file = File(filePath);
          await file.copy(newPath);
          await FileHelper.deleteFile(filePath);
          tempFiles.add(newPath);

        } catch (e) {
          continue;
        }
      }
    }

    if(doShowLoader) Get.back();

    return tempFiles;
  }

  static String getUniqueFileName(String fileName) {
    if (!File(localStoragePath + fileName).existsSync()) {
      // File does not exist, no need to add a suffix
      return localStoragePath + fileName;
    }
    // Get the file name and extension
    String baseName = fileName.split('.').first;
    String fileExtension = fileName.split('.').length > 1 ? '.${fileName.split('.').last}' : '';

    // Check for existing files with the same base name
    int suffix = 1;
    String uniqueFileName;

    do {
      uniqueFileName = '$baseName ($suffix)$fileExtension';
      suffix++;
    } while (File(localStoragePath + uniqueFileName).existsSync());

    return localStoragePath + uniqueFileName;
  }

  static Future<void> setLocalStoragePath() async {
    try {
      if(Platform.isIOS) {
        localStoragePath = '${(await getLibraryDirectory()).path}/';
        // Safely replace "Library" directory with "tmp" using path operations
        String parentPath = path.dirname(localStoragePath);
        iosTempStoragePath = path.join(parentPath, 'tmp');
        iosJpFileStoragePath = '${(await getApplicationDocumentsDirectory()).path}/jp_files/';
      } else {
        localStoragePath = '${(await getApplicationDocumentsDirectory()).path}/';
        cacheStoragePath = '${(await getApplicationCacheDirectory()).path}/';
      }
    } catch (e) {
      Helper.recordError(e);
    }
  }

  static Future<void> deleteFile(String path) async {
    try {
      final file = File(path);
      await file.delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static bool checkIfLargeFile(String path) {

    try {
      final fileSizeInBytes = File(path).lengthSync();

      return fileSizeInBytes > Helper.flagBasedUploadSize(fileSize: CommonConstants.maxAllowedFileSize);
    } catch (e) {
      return false;
    }
  }

  static String getClassType(String mimeType) {
    String type = "";

    switch (mimeType) {
      // if Image
      case "image/jpeg":
      case "image/jpg":
        type = "jpg";
        break;
      case "image/png":
        type = "png";
        break;

      // PDF
      case "application/pdf":
        type = "pdf";
        break;

      // Doc
      case "application/msword":
      case "application/vnd.openxmlformats-officedocument.wordprocessingml.document":
      case "application/vnd.openxmlformats-officedocument.wordprocessingml.template":
        type = "doc";
        break;

      // Excel/CSV
      case "application/vnd.ms-excel":
      case "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet":
        type = "xlsx";
        break;
      case "application/csv":
        type = "xlsx";
        break;

      // PPT
      case "application/vnd.ms-powerpoint":
      case "application/vnd.openxmlformats-officedocument.presentationml.presentation":
        type = "ppt";
        break;

      // PPT
      case "text/plain":
      case "text/csv":
        type = "txt";
        break;

      // ZIP
      case "application/zip":
      case "application/rar":
      case "application/x-zip":
      case "application/x-rar":
      case "application/x-zip-compressed":
      case "application/x-rar-compressed":
        type = "zip";
        break;

      case "application/postscript":
      case "vnd.adobe.illustrator":
        type = "ai";
        break;

      case "message/rfc822":
        type = "eml";
        break;

      case "image/vnd.adobe.photoshop":
      case "image/photoshop":
      case "image/x-photoshop":
      case "image/psd":
      case "application/photoshop":
      case "application/psd":
      case "zz-application/zz-winassoc-psd":
        type = "psd";
        break;

      case "application/eps":
      case "application/x-eps":
      case "image/eps":
      case "image/x-eps":
        type = "eps";
        break;

      case "application/x-koan":
      case "application/vnd.koan":
      case "application/vnd.sketchup.skp":
        type = "skp";
        break;

      case "image/vnd.dxf":
      case "image/x-dwg":
      case "application/dxf":
      case "image/vnd.dwg":
        type = "dxf";
        break;

      case "application/octet-stream":
        type = "ac5";
        break;

      default:
        type = "unknown";
        break;
    }

    return type;
  }

  static bool checkIsUnsupportedFile(String fileName, String action) {
    bool isUnsupportedFile = false;
    String message = '';
    switch (action) {
      case 'open':
        isUnsupportedFile = isUnsupportedViewFile(fileName);
        if (isUnsupportedFile) message = 'unsupported_file_for_download_view'.tr;
        break;
      case 'print':
        isUnsupportedFile = isUnsupportedPrintFile(fileName);
        if (isUnsupportedFile) message = 'unsupported_file_for_print'.tr;
        break;
    }
    if (message.isNotEmpty) {
      Helper.showToastMessage(message);
    }
    return isUnsupportedFile;
  }

  static bool isUnsupportedViewFile(String fileName) {
    final unsupportedExtensions = [
      "eml",
      "ai",
      "psd",
      "ve",
      "eps",
      "dxf",
      "skp",
      "ac5",
      "ac6",
      "dwg",
      "esx",
      "sfz",
      "sdr",
    ];
    final fileExtension = getFileExtension(fileName);
    return unsupportedExtensions.contains(fileExtension);
  }

  static bool isUnsupportedPrintFile(String fileName) {
    final unsupportedExtensions = [
      "eml",
      "psd",
      "ve",
      "eps",
      "dxf",
      "skp",
      "ac5",
      "ac6",
      "dwg",
      "esx",
      "sfz",
      "zip",
      "sdr",
    ];
    final fileExtension = getFileExtension(fileName);
    return unsupportedExtensions.contains(fileExtension);
  }

  static int fileInMegaBytes(int fileSize) => (fileSize / (1024 * 1024)).round();
}
