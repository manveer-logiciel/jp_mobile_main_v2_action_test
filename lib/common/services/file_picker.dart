
import 'dart:io';

import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobprogress/common/services/platform_permissions.dart';
import 'package:jobprogress/common/services/user_preferences.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class FilePickerService {

  static final ImagePicker picker = ImagePicker();

  /// pickDocuments() : will pick documents from local storage
  // TODO : Disable support for all file excect pdf and images for srs on temporary basis . We will enable it later when backend is resolved this issue
  static Future<List<String>> pickFile({bool onlyImages = false, bool allowMultiple = true,bool onlyXls = false , bool isSrs = false}) async {
    try {
      List<String> paths = [];
      if(await PlatformPermissionService.hasStoragePermissions()) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: allowMultiple,
          type: onlyImages ? FileType.image : FileType.custom,
          allowedExtensions: onlyImages ? null : getAllowedExtensions(onlyXls, isSrs: isSrs),
          allowCompression: true,
        );

        if (result != null) {
          paths = await FileHelper.saveToTempDirectory(result.paths);
        }
      }
      return paths;
    } catch (e) {
      rethrow;
    }
  }

  static List<String> getAllowedExtensions(bool onlyXls, {bool isSrs = false}) {
    if (onlyXls) {
      return ['xls'];
    } else if (isSrs) {
      return SrsSupportedFiles.extensions;
    } else {
      return FileUploadSupportedFiles.extensions;
    }
  }

  /// takePhoto() : will open camera for clicking photo
  static Future<String?> takePhoto() async {
    try {
      if (await PlatformPermissionService.hasCameraPermission()) {
        String path = "";
        String tempImagePath = "";
        String rotatedImagePath = "";
        XFile? image = await picker.pickImage(source: ImageSource.camera);

        if(image == null) return null;
        tempImagePath = image.path;
        // Rotate the image to fix the wrong rotation coming from ImagePicker
        File rotatedImage = await FlutterExifRotation.rotateImage(path: image.path);
        rotatedImagePath = rotatedImage.path;
        image = XFile(rotatedImage.path); // Correct rotation image

        // new file path to save file to cache
        String filePath;
        if(FileHelper.getFileExtension(image.path) == null) {
          filePath = '${FileHelper.localStoragePath}/${DateTime.now().microsecondsSinceEpoch}';
        } else {
          filePath = '${FileHelper.localStoragePath}/${DateTime.now().microsecondsSinceEpoch}.${FileHelper.getFileExtension(image.path)!}';
        }

        // saving file to cache storage
        await image.saveTo(filePath);
        path = filePath;

        //  Check if user preferences for access to save image to gallery then
        //  save image to gallery
        if(UserPreferences.hasSaveToGalleryAccess ?? false) {
          await ImageGallerySaverPlus.saveImage(
            await image.readAsBytes(),
          );
        }
        // File is first copied to temp directory, deleting it
        FileHelper.deleteFile(tempImagePath);
        // File is then FlutterExifRotation saves it in document section, deleting it
        FileHelper.deleteFile(rotatedImagePath);
        return path;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // scanDocument() : will scan document and returns path
  static Future<List<String>> scanDocument() async {

    if (!(await PlatformPermissionService.hasCameraPermission())) return [];

    try {
      dynamic scannedDocuments = await FlutterDocScanner().getScannedDocumentAsImages(page: 1);
      if (scannedDocuments is Map) {
        // Get the Uri list from the result
        dynamic uriList = scannedDocuments['Uri'];
        if (!Helper.isValueNullOrEmpty(uriList) && uriList is String) {
          RegExp regExp = RegExp(r'imageUri=([^}]+)');
          Match? match = regExp.firstMatch(uriList);
          if (match != null) {
            String imageUri = match.group(1)!;
            return await FileHelper.saveToTempDirectory([imageUri]);
          }
        }
      } else if (scannedDocuments is List) {
        final filteredList = scannedDocuments.whereType<String>().toList();
        // Casting to list of string
        return await FileHelper.saveToTempDirectory(filteredList);
      }
      return [];
    } catch (e) {
        rethrow;
    }
  }
}