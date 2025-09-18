import 'dart:convert';
import 'dart:io';

import 'package:jiffy/jiffy.dart';
import 'package:jobprogress/common/models/sql/uploader/file_uploader_model.dart';
import 'package:jobprogress/common/providers/sql/db_provider.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/shared_pref.dart';
import 'package:jobprogress/common/services/upload.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/constants/shared_pref_constants.dart';
import 'package:jobprogress/core/utils/file_upload_helpers/upload_file_type_params.dart';
import 'package:sqflite/sqflite.dart';

import '../../../core/constants/date_formats.dart';
import '../../../core/utils/date_time_helpers.dart';
import '../../../core/utils/file_upload_helpers/upload_file_type_helper.dart';
import '../../../core/utils/helpers.dart';

class SqlFileUploaderRepository {

  static const String tableName = 'uploader';
  static const String oldDBTableName = 'pending_uploads';

  /// Bulk insert uploads
  Future<List<Object?>> bulkInsert(List<FileUploaderModel> uploaderList) async {

    final dbClient = await DBProvider().db;
    Batch batch = dbClient!.batch();

    for (var i = 0; i < uploaderList.length; i++) {
      final uploader = {
        ...uploaderList[i].toJson(),
      };

      batch.insert(tableName, uploader);
    }

    return await batch.commit(continueOnError:true);
  }

  /// Clear table data
  Future<int> clearRecords() async {
    final dbClient = await DBProvider().db;
    return await dbClient!.delete(
      tableName,
    );
  }

  /// To remove one record at a time
  Future<int> clearOneRecord(int id) async {
    final dbClient = await DBProvider().db;
    return await dbClient!.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id]
    );
  }

  /// To update file status (uploading, pending, paused)
  Future<int> updateStatus(FileUploaderModel uploadItem) async {
    final dbClient = await DBProvider().db;
    uploadItem.updatedAt = DateTime.now().toString();
    return await dbClient!.update(
        tableName,
        uploadItem.toJson(),
        where: 'id = ?',
        whereArgs: [uploadItem.id]
    );
  }

  /// Getting records from local DB
  Future<List<FileUploaderModel>> getAll() async {

    try {
      final userDetails = AuthService.userDetails;

      if(userDetails == null) return [];

      final dbClient = await DBProvider().db;

      String query =
          "SELECT * FROM $tableName WHERE user_id = ${userDetails.id} "
          "${userDetails.companyId != null ? "AND company_id = ${userDetails.companyId}" : ""}";

      List<FileUploaderModel> pendingUploads = (await dbClient!.rawQuery(query))
          .map((division) => FileUploaderModel.fromJson(division))
          .toList();

      return pendingUploads;

    } catch (e) {
      rethrow;
    }
  }

  Future<void> migrateOldTable() async {
    final oldAppDBPath = await Helper.getOldAppDBPath();
    bool isOldDBExists = await File(oldAppDBPath).exists();
    final pref = SharedPrefService();
    bool isOldRecordMigrated = Helper.isTrue(await pref.read(PrefConstants.isUploadTableMigrated) ?? false);

    if(isOldDBExists && !isOldRecordMigrated) {
      Database db = await openReadOnlyDatabase(oldAppDBPath);
      final pendingUploadTableRows = await db.rawQuery("SELECT * FROM '$oldDBTableName'");

      if(pendingUploadTableRows.isNotEmpty) {
        List<FileUploaderModel> pendingUploads = pendingUploadTableRows
            .map((pendingUpload) {
          var pendingUploadMap = Map.of(pendingUpload);
          pendingUploadMap['id'] = null;
          pendingUploadMap['local_path'] = pendingUploadMap['local_url'];
          pendingUploadMap['error'] = pendingUploadMap['error_message'];
          if(pendingUploadMap['status'] == 'cancel' || pendingUploadMap['status'] == 'error') {
            pendingUploadMap['file_status'] = FileUploadStatus.paused;
          }
          pendingUploadMap['display_path'] = UploadFileTypeHelper.getUploadFileDisplayPathFromOldFileType(pendingUploadMap['type'].toString());
          pendingUploadMap['type'] = UploadFileTypeHelper.getUploadFileTypeFromOldFileType(
              pendingUploadMap['type'].toString());
          pendingUploadMap['params'] = UploadFileTypeParams.getParamsFromOldExtraData(
              pendingUploadMap['type'].toString(), jsonDecode(pendingUploadMap['extra_data'].toString()));
          String createdAtString = pendingUploadMap["created_at"].toString().substring(0, pendingUploadMap["created_at"].toString().indexOf("GMT") - 1);
          Jiffy createdAtDateString = Jiffy.parse(createdAtString, pattern: "EEE MMM dd yyyy HH:mm:ss");

          String updatedAtString = pendingUploadMap["uploaded_at"].toString().substring(0, pendingUploadMap["uploaded_at"].toString().indexOf("GMT") - 1);
          Jiffy updatedAtDateString = Jiffy.parse(updatedAtString, pattern: "EEE MMM dd yyyy HH:mm:ss");
          pendingUploadMap['created_at'] = DateTimeHelper.format(createdAtDateString.dateTime.toString(), DateFormatConstants.dateTimeServerFormat);
          pendingUploadMap['updated_at'] = DateTimeHelper.format(updatedAtDateString.dateTime.toString(), DateFormatConstants.dateTimeServerFormat);
          pendingUploadMap['created_through'] = 'v1';
          return FileUploaderModel.fromJson(pendingUploadMap);
        }).toList();
        await bulkInsert(pendingUploads);
        await pref.save(PrefConstants.isUploadTableMigrated, true);
        UploadService.loadUploadFiles();
      }
    }
  }

  ///   Getting all uploads table record from local db
  Future<List<Map<String, dynamic>>> getAllUploadsTable() async {
    try {
      final dbClient = await DBProvider().db;
      final dbTableRows = await dbClient!.rawQuery("SELECT * FROM '$tableName' WHERE created_through = 'v1'");
      return dbTableRows.toList();
    } catch (e) {
      Helper.recordError(e);
    }
    return [];
  }
}
