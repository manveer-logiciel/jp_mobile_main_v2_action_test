import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobprogress/common/services/cookies.dart';
import 'package:jobprogress/common/services/isolate_cache_operations.dart';
import 'package:jobprogress/common/providers/sql/db_provider.dart';
import 'package:jobprogress/common/repositories/sql/file_uploader.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/modules/dev_console/cache_management/constants.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';

class CacheManagementController extends GetxController {
  // Storage sizes
  double sharedPrefsSize = 0.0;
  double cookiesSize = 0.0;
  double cachesSize = 0.0;
  double uploadsSize = 0.0;
  double databaseSize = 0.0;

  int sharedPrefsItemCount = 0;
  int cookiesItemCount = 0;
  int cachesItemCount = 0;
  int uploadsItemCount = 0;

  bool isLoading = true;
  bool isSharedPrefsLoading = true;
  bool isCookiesLoading = true;
  bool isCachesLoading = true;
  bool isUploadsLoading = true;
  bool isDatabaseLoading = true;

  @override
  void onInit() {
    super.onInit();
    calculateAllSizes();
  }

  /// Calculate sizes for all storage types
  Future<void> calculateAllSizes() async {
    isLoading = true;
    update();

    try {
      await Future.wait([
        calculateSharedPrefsSize(),
        calculateCookiesSize(),
        calculateCachesSize(),
        calculateUploadsSize(),
        calculateDatabaseSize(),
      ]);
    } catch (e) {
      Helper.recordError(e);
    } finally {
      isLoading = false;
      update();
    }
  }

  /// Calculate Shared Preferences size
  Future<void> calculateSharedPrefsSize() async {
    isSharedPrefsLoading = true;
    update();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      sharedPrefsItemCount = keys.length;

      // Estimate size based on key-value pairs
      double totalSizeInBytes = 0.0;
      for (String key in keys) {
        final value = prefs.get(key);
        if (value != null) {
          totalSizeInBytes += key.length + value.toString().length;
        }
      }
      sharedPrefsSize = totalSizeInBytes / CacheManagementConstants.bytesPerMB; // Convert to MB
    } catch (e) {
      Helper.recordError(e);
      sharedPrefsSize = 0.0;
      sharedPrefsItemCount = 0;
    } finally {
      isSharedPrefsLoading = false;
      update();
    }
  }

  /// Calculate Cookies size
  Future<void> calculateCookiesSize() async {
    isCookiesLoading = true;
    update();
    
    try {
      final cookies = CookiesService.savedCookies;
      cookiesItemCount = cookies.length;

      double totalSizeInBytes = 0.0;
      cookies.forEach((key, value) {
        totalSizeInBytes += key.length + value.toString().length;
      });
      cookiesSize = totalSizeInBytes / CacheManagementConstants.bytesPerMB; // Convert to MB
    } catch (e) {
      Helper.recordError(e);
      cookiesSize = 0.0;
      cookiesItemCount = 0;
    } finally {
      isCookiesLoading = false;
      update();
    }
  }

  Future<List<Directory>> getCachesDirectories() async {
    if (Platform.isAndroid) {
      return [await getApplicationCacheDirectory()];
    } else if (Platform.isIOS) {
      // Ensure FileHelper.iosTempStoragePath is initialized
      if (FileHelper.iosTempStoragePath.isEmpty) {
        await FileHelper.setLocalStoragePath();
      }
      
      return [
        await getTemporaryDirectory(),
        Directory(FileHelper.iosTempStoragePath),
        await getApplicationDocumentsDirectory(),
      ];
    }
    return [];
  }

  /// Calculate Caches size for both Android and iOS
  Future<void> calculateCachesSize() async {
    isCachesLoading = true;
    update();
    
    try {
      double totalSize = 0.0;
      int totalCount = 0;

      final dirsToCheck = await getCachesDirectories();
      for (final dir in dirsToCheck) {
        if (await dir.exists()) {
          final result = await IsolateCacheOperations.scanDirectory(
            directoryPath: dir.path,
            recursive: true,
          );
          totalSize += (result['totalSizeBytes'] as double) / CacheManagementConstants.bytesPerMB;
          totalCount += result['fileCount'] as int;
        }
      }

      cachesSize = totalSize;
      cachesItemCount = totalCount;
    } catch (e) {
      Helper.recordError(e);
      cachesSize = 0.0;
      cachesItemCount = 0;
    } finally {
      isCachesLoading = false;
      update();
    }
  }

  Future<List<Directory>> getUploadDirectories() async {
    if (Platform.isAndroid) {
      return [await getApplicationDocumentsDirectory()];
    } else if (Platform.isIOS) {
      return [await getLibraryDirectory()];
    }
    return [];
  }

  /// Calculate Uploads size for both Android and iOS
  Future<void> calculateUploadsSize() async {
    isUploadsLoading = true;
    update();
    
    try {
      uploadsSize = 0.0;
      uploadsItemCount = 0;

      final dirsToCheck = await getUploadDirectories();
      for (final dir in dirsToCheck) {
        if (await dir.exists()) {
          final result = await IsolateCacheOperations.scanDirectory(
            directoryPath: dir.path,
            recursive: Platform.isAndroid,
          );
          uploadsSize += (result['totalSizeBytes'] as double) / CacheManagementConstants.bytesPerMB;
          uploadsItemCount += result['fileCount'] as int;
        }
      }
    } catch (e) {
      Helper.recordError(e);
      uploadsSize = 0.0;
      uploadsItemCount = 0;
    } finally {
      isUploadsLoading = false;
      update();
    }
  }

  /// Calculate Database size
  Future<void> calculateDatabaseSize() async {
    isDatabaseLoading = true;
    update();
    
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final dbPath = '${documentsDir.path}/$dataBaseName';
      final dbFile = File(dbPath);

      if (await dbFile.exists()) {
        final size = await dbFile.length();
        databaseSize = size / CacheManagementConstants.bytesPerMB; // Convert to MB
      } else {
        databaseSize = 0.0;
      }
    } catch (e) {
      Helper.recordError(e);
      databaseSize = 0.0;
    } finally {
      isDatabaseLoading = false;
      update();
    }
  }



  /// Clear Shared Preferences
  Future<void> clearSharedPrefsConfirmation() async {
    try {
      await showJPBottomSheet(
        child: (_) => JPConfirmationDialog(
          title: 'clear_shared_preferences'.tr,
          subTitle: 'are_you_sure_clear_shared_preferences'.tr,
          suffixBtnText: 'clear'.tr.toUpperCase(),
          prefixBtnText: 'cancel'.tr.toUpperCase(),
          onTapSuffix: () async {
            Get.back();
            showJPLoader();

            await clearSharedPrefs();

            Get.back();
            Helper.showToastMessage('shared_preferences_cleared'.tr);
            Helper.logOut();
          },
          onTapPrefix: () => Get.back(),
        ),
      );
    } catch (e) {
      Get.back();
      Helper.recordError(e);
      Helper.showToastMessage('error_clearing_shared_preferences'.tr);
    }
  }

  Future<void> clearSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> clearCookies() async {
    CookiesService.clearCookies();
  }

  /// Clear Cookies
  Future<void> clearCookiesConfirmation() async {
    try {
      await showJPBottomSheet(
        child: (_) => JPConfirmationDialog(
          title: 'clear_cookies'.tr,
          subTitle: 'are_you_sure_clear_cookies'.tr,
          suffixBtnText: 'clear'.tr.toUpperCase(),
          prefixBtnText: 'cancel'.tr.toUpperCase(),
          onTapSuffix: () async {
            Get.back();
            showJPLoader();

            await clearCookies();

            Get.back();
            Helper.showToastMessage('cookies_cleared'.tr);
            await calculateCookiesSize();
            update();
          },
          onTapPrefix: () => Get.back(),
        ),
      );
    } catch (e) {
      Get.back();
      Helper.recordError(e);
      Helper.showToastMessage('error_clearing_cookies'.tr);
    }
  }

  /// Clear Caches for both Android and iOS
  Future<void> clearCachesConfirmation() async {
    try {
      await showJPBottomSheet(
        child: (_) => JPConfirmationDialog(
          title: 'clear_caches'.tr,
          icon: Icons.warning_amber_outlined,
          subTitle: 'are_you_sure_clear_caches'.tr,
          suffixBtnText: 'clear'.tr.toUpperCase(),
          prefixBtnText: 'cancel'.tr.toUpperCase(),
          onTapSuffix: () async {
            Get.back();
            showJPLoader();

            await clearCaches();

            Get.back();
            Helper.showToastMessage('caches_cleared'.tr);
            await calculateCachesSize();
            update();
          },
          onTapPrefix: () => Get.back(),
        ),
      );
    } catch (e) {
      Get.back();
      Helper.recordError(e);
      Helper.showToastMessage('error_clearing_caches'.tr);
    }
  }

  Future<void> clearCaches() async {
    final dirsToCheck = await getCachesDirectories();
    for (final dir in dirsToCheck) {
      if (await dir.exists()) {
        await IsolateCacheOperations.clearDirectory(
          directoryPath: dir.path,
          excludeFiles: CacheManagementConstants.excludedFileNames,
        );
      }
    }
  }

  Future<(List<String>, List<String>)> getUploadFiles() async {
    // Get files from uploader table to protect during deletion
    final uploaderRepo = SqlFileUploaderRepository();
    final uploaderFiles = await uploaderRepo.getAll();
    final uploaderPaths = uploaderFiles.map((file) => file.localPath).toSet();

    // Separate files into deletable and protected
    final deletableFiles = <String>[];
    final protectedFiles = <String>[];

    final dirsToCheck = await getUploadDirectories();
    for (final dir in dirsToCheck) {
      if (await dir.exists()) {
        final result = await IsolateCacheOperations.scanDirectory(
          directoryPath: dir.path,
          recursive: Platform.isAndroid,
        );
        final files = List<String>.from(result['files']);
        for (final filePath in files) {
          if (uploaderPaths.contains(filePath)) {
            protectedFiles.add(filePath);
          } else {
            deletableFiles.add(filePath);
          }
        }
      }
    }

    return (deletableFiles, protectedFiles);
  }

  Future<void> clearUploads() async {
    final (deletableFiles, _) = await getUploadFiles();
    if (deletableFiles.isNotEmpty) {
      await IsolateCacheOperations.deleteFiles(filePaths: deletableFiles);
    }
  }

  /// Clear Uploads for both Android and iOS
  Future<void> clearUploadsConfirmation() async {
    try {
      final (deletableFiles, protectedFiles) = await getUploadFiles();

      if (deletableFiles.isEmpty) {
        Helper.showToastMessage('no_files_safe_to_delete'.tr);
        return;
      }

      // Build confirmation message
      String description = '';
      if (deletableFiles.isNotEmpty) {
        final deletableNames = deletableFiles.map((path) => path.split('/').last).toList();
        description += 'files_will_be_deleted'.tr + ':\n' + deletableNames.join('\n');
      }

      if (protectedFiles.isNotEmpty) {
        final protectedNames = protectedFiles.map((path) => path.split('/').last).toList();
        description += '\n\n' + 'files_will_be_protected'.tr + ':\n' + protectedNames.join('\n');
      }

      await showJPBottomSheet(
        child: (_) => JPConfirmationDialog(
          title: 'clear_uploads'.tr,
          icon: Icons.warning_amber_outlined,
          subTitle: description,
          suffixBtnText: 'clear'.tr.toUpperCase(),
          prefixBtnText: 'cancel'.tr.toUpperCase(),
          onTapSuffix: () async {
            Get.back();
            showJPLoader();

            await clearUploads();

            Get.back();
            String message = 'uploads_cleared_with_stats'.trParams({
              'deleted': deletableFiles.length.toString(),
              'protected': protectedFiles.length.toString(),
            });

            Helper.showToastMessage(message);
            await calculateUploadsSize();
            update();
          },
          onTapPrefix: () => Get.back(),
        ),
      );
    } catch (e) {
      Get.back();
      Helper.recordError(e);
      Helper.showToastMessage('error_clearing_uploads'.tr);
    }
  }

  /// Clear Database
  Future<void> clearDatabase() async {
    try {
      await showJPBottomSheet(
        child: (_) => JPConfirmationDialog(
          title: 'clear_database'.tr,
          subTitle: 'are_you_sure_clear_database_tables'.tr,
          suffixBtnText: 'clear'.tr.toUpperCase(),
          prefixBtnText: 'cancel'.tr.toUpperCase(),
          onTapSuffix: () async {
            Get.back();
            showJPLoader();

            // Clear all tables but keep the database structure
            final dbProvider = DBProvider();
            await dbProvider.deleteDatabase();

            Get.back();
            Helper.showToastMessage('database_cleared'.tr);
            await calculateDatabaseSize();
            update();
          },
          onTapPrefix: () => Get.back(),
        ),
      );
    } catch (e) {
      Get.back();
      Helper.recordError(e);
      Helper.showToastMessage('error_clearing_database'.tr);
    }
  }





  /// Format size for display
  String formatSize(double sizeInMB) {
    if (sizeInMB < 0.001) {
      final sizeInBytes = sizeInMB * CacheManagementConstants.bytesPerMB;
      return '${sizeInBytes.toStringAsFixed(0)} B';
    } else if (sizeInMB < 1.0) {
      final sizeInKB = sizeInMB * CacheManagementConstants.bytesPerKB;
      return '${sizeInKB.toStringAsFixed(1)} KB';
    } else if (sizeInMB < 1024.0) {
      return '${sizeInMB.toStringAsFixed(1)} MB';
    } else {
      final sizeInGB = sizeInMB / 1024.0;
      return '${sizeInGB.toStringAsFixed(1)} GB';
    }
  }

  /// Clear cache and uploads automatically (called when cookies are renewed)
  /// This clears temporary data without user confirmation
  /// Only executes when the optimize-ios-storage-usage LaunchDarkly flag is enabled
  static Future<void> clearCacheAndUploadsOnCookieRenewal() async {
    try {
      // Check if the optimize-ios-storage-usage feature flag is enabled
      if (!LDService.hasFeatureEnabled(LDFlagKeyConstants.optimizeAppStorageUsage)) {
        // Flag is disabled, skip automatic clearing
        return;
      }

      // Create a temporary controller instance for clearing operations
      final controller = CacheManagementController();

      // Clear caches silently
      await controller.clearCaches();

      // Clear uploads silently
      await controller.clearUploads();

      // Silent operation - no logging needed for successful automatic clearing
    } catch (e) {
      // Log error but don't show user notification since this is automatic
      Helper.recordError('Error during automatic cache/uploads clearing on cookie renewal: $e');
    }
  }

  /// Manual trigger for cache and uploads clearing (for testing purposes)
  /// This function can be called manually to test the automatic clearing behavior
  static Future<void> triggerManualCacheAndUploadsClearing() async {
    try {
      Helper.showToastMessage('Manually triggering cache and uploads clearing...');
      await CacheManagementController.clearCacheAndUploadsOnCookieRenewal();
      Helper.showToastMessage('Cache and uploads cleared successfully');
    } catch (e) {
      Helper.showToastMessage('Error clearing cache and uploads: $e');
    }
  }

  /// Get total cache size
  double get totalCacheSize => sharedPrefsSize + cookiesSize + cachesSize + uploadsSize + databaseSize;

  /// Get total item count
  int get totalItemCount => sharedPrefsItemCount + cookiesItemCount + cachesItemCount + uploadsItemCount;
}
