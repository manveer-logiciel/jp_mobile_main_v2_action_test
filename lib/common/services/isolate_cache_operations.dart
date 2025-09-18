import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:jobprogress/modules/dev_console/cache_management/constants.dart';

class IsolateCacheOperations {
  
  /// Run directory scanning in isolate to avoid UI blocking
  static Future<Map<String, dynamic>> scanDirectory({
    required String directoryPath,
    bool recursive = true,
  }) async {
    final params = {
      'directoryPath': directoryPath,
      'recursive': recursive,
      'supportedExtensions': CacheManagementConstants.supportedFileExtensions,
    };
    
    return await compute(_scanDirectoryIsolate, params);
  }
  
  /// Run file deletion in isolate to avoid UI blocking
  static Future<Map<String, dynamic>> deleteFiles({
    required List<String> filePaths,
  }) async {
    return await compute(_deleteFilesIsolate, filePaths);
  }
  
  /// Run directory clearing in isolate to avoid UI blocking
  static Future<Map<String, dynamic>> clearDirectory({
    required String directoryPath,
    required List<String> excludeFiles,
  }) async {
    final params = {
      'directoryPath': directoryPath,
      'excludeFiles': excludeFiles,
      'supportedExtensions': CacheManagementConstants.supportedFileExtensions,
    };
    
    return await compute(_clearDirectoryIsolate, params);
  }
  
  // Isolate entry points (static functions)
  
  static Future<Map<String, dynamic>> _scanDirectoryIsolate(Map<String, dynamic> params) async {
    final directoryPath = params['directoryPath'] as String;
    final recursive = params['recursive'] as bool;
    final supportedExtensions = List<String>.from(params['supportedExtensions']);
    
    final directory = Directory(directoryPath);
    final supportedFiles = <String>[];
    final unsupportedFiles = <String>[];
    double totalSize = 0.0;
    int totalFiles = 0;
    
    try {
      if (await directory.exists()) {
        await for (final entity in directory.list(recursive: recursive)) {
          if (entity is File) {
            totalFiles++;
            final path = entity.path;
            final fileName = path.split('/').last;
            
            if (!path.contains('.')) {
              unsupportedFiles.add('$fileName (no extension)');
              continue;
            }
            
            final extension = path.split('.').last.toLowerCase();
            if (supportedExtensions.contains(extension)) {
              supportedFiles.add(path);
              try {
                final fileSize = await entity.length();
                totalSize += fileSize;
              } catch (e) {
                // Skip files that can't be accessed
                unsupportedFiles.add('$fileName (access error: $e)');
              }
            } else {
              unsupportedFiles.add('$fileName (.$extension not supported)');
            }
          }
        }
      }
    } catch (e) {
      // Return partial results if error occurs
    }
    
    return {
      'files': supportedFiles,
      'totalSizeBytes': totalSize,
      'fileCount': supportedFiles.length,
      'totalFiles': totalFiles,
      'unsupportedFiles': unsupportedFiles,
      'directoryPath': directoryPath,
      'directoryExists': await directory.exists(),
    };
  }
  
  static Future<Map<String, dynamic>> _deleteFilesIsolate(List<String> filePaths) async {
    int deletedCount = 0;
    int errorCount = 0;
    
    for (final filePath in filePaths) {
      try {
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
          deletedCount++;
        }
      } catch (e) {
        errorCount++;
      }
    }
    
    return {
      'deletedCount': deletedCount,
      'errorCount': errorCount,
    };
  }
  
  static Future<Map<String, dynamic>> _clearDirectoryIsolate(Map<String, dynamic> params) async {
    final directoryPath = params['directoryPath'] as String;
    final excludeFiles = List<String>.from(params['excludeFiles']);
    final supportedExtensions = List<String>.from(params['supportedExtensions']);
    
    final directory = Directory(directoryPath);
    int deletedCount = 0;
    int errorCount = 0;
    
    try {
      if (await directory.exists()) {
        final List<FileSystemEntity> entities = [];
        
        // Collect all entities first
        await for (final entity in directory.list(recursive: true)) {
          entities.add(entity);
        }
        
        // Process entities
        for (final entity in entities) {
          try {
            if (entity is File) {
              final fileName = entity.path.split('/').last;
              final extension = entity.path.contains('.') 
                  ? entity.path.split('.').last.toLowerCase() 
                  : '';
              
              // Only delete if not excluded and has supported extension
              if (!excludeFiles.contains(fileName) &&
                  extension.isNotEmpty &&
                  supportedExtensions.contains(extension)) {
                await entity.delete();
                deletedCount++;
              }
            } else if (entity is Directory) {
              // Try to delete empty directories
              try {
                await entity.delete();
              } catch (e) {
                // Directory not empty or other error - ignore
              }
            }
          } catch (e) {
            errorCount++;
          }
        }
      }
    } catch (e) {
      errorCount++;
    }
    
    return {
      'deletedCount': deletedCount,
      'errorCount': errorCount,
    };
  }
} 