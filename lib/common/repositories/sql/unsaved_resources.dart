import 'dart:io';

import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/form/unsaved_resources_helper/unsaved_resources_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:jobprogress/core/utils/helpers.dart';

import '../../../core/constants/shared_pref_constants.dart';
import '../../../core/utils/date_time_helpers.dart';
import '../../providers/sql/db_provider.dart';
import '../../services/auth.dart';
import '../../services/shared_pref.dart';

class SqlUnsavedResourcesRepository {
  ///   insert records
  Future<int?> insert(Map<String, dynamic> resources) async {
    final dbClient = await DBProvider().db;
    Batch batch = dbClient!.batch();
    final lastAddedId = await getLastAddedId(dbClient: dbClient) ?? 0;
    resources.update("id", (value) => lastAddedId + 1, ifAbsent: () => lastAddedId + 1);
    batch.insert('unsaved_resources', resources);
    await batch.commit(continueOnError: true);
    return getLastAddedId(dbClient: dbClient);
  }

  ///   Getting one record from local db
  Future<int?> getLastAddedId({Database? dbClient}) async {
    final newDbClient = dbClient ?? await DBProvider().db;
    List<Map<String, dynamic>>? resources = (await newDbClient!.rawQuery("SELECT seq FROM SQLITE_SEQUENCE WHERE name = 'unsaved_resources'")).toList();
    if(resources.isNotEmpty) {
      return resources[0]["seq"];
    } else {
      return null;
    }
  }

  ///   Getting one record from local db
  Future<Map<String, dynamic>?> getOne({int? id}) async {
    final dbClient = await DBProvider().db;
    List<Map<String, dynamic>>? resources = (await dbClient!.rawQuery("SELECT * FROM unsaved_resources WHERE id = $id")).toList();
    return (resources.isNotEmpty) ? resources[0] : null;
  }

  ///   Getting all old DB record from local db
  Future<List<Map<String, dynamic>>?> getAllOldUR() async {
    final dbClient = await DBProvider().db;
    return (await dbClient!.rawQuery("SELECT * FROM unsaved_resources WHERE created_through = 'v1'")).toList();
  }

  ///   Getting all record from local db
  Future<List<Map<String, dynamic>>?> get({required String type, int? customerId, int? companyId, int? jobId}) async {
    final dbClient = await DBProvider().db;
    return (await dbClient!.rawQuery("SELECT * FROM unsaved_resources WHERE "
        "type = '$type' "
        "${customerId != null ? "AND customer_id = $customerId " : ""}"
        "${companyId != null ? "AND (company_id = $companyId " : ""} OR company_id IS NULL)"
        "${jobId != null ? "AND job_id = $jobId" : ""} ORDER BY id DESC"
    )).toList();
  }

  ///   update one record from local db
  Future<List<Object?>> updateOne({int? id, Map<String, dynamic>? param}) async {
    final dbClient = await DBProvider().db;
    Batch batch = dbClient!.batch();
    batch.update('unsaved_resources', param ?? {}, where: "id = ?", whereArgs: [id]);
    return await batch.commit(continueOnError: true);
  }

  ///   update one record from local db
  Future<List<Object?>> deleteOneResource({int? id}) async {
    final dbClient = await DBProvider().db;
    Batch batch = dbClient!.batch();
    batch.delete('unsaved_resources', where: "id == $id");
    return await batch.commit(continueOnError: true);
  }

  ///   update one record from local db
  Future<List<Object?>> deleteAllOldUnsavedResource() async {
    final dbClient = await DBProvider().db;
    Batch batch = dbClient!.batch();
    batch.delete('unsaved_resources', where: "created_through = ?", whereArgs: ['v1']);
    return await batch.commit(continueOnError: true);
  }

  /// Clear unsaved_resources table data
  Future<int> clearRecords() async {
    int companyId = AuthService.userDetails!.companyDetails!.id;
    final dbClient = await DBProvider().db;
    return await dbClient!.delete(
        'unsaved_resources',
        where: "id = ?",
        whereArgs: [companyId]
    );
  }

  /// Clear unsaved_resources table data
  Future<void> migrateOldDB() async {
    Directory? appLibraryDirectory;
    String oldAppDBPath;
    if(Platform.isAndroid) {
      appLibraryDirectory = await getApplicationDocumentsDirectory();
      oldAppDBPath = "${appLibraryDirectory.path.replaceFirst("/app_flutter", "")}/databases/jobprogress.db";
    } else {
      appLibraryDirectory = await getLibraryDirectory();
      oldAppDBPath = "${appLibraryDirectory.path}/LocalDatabase/jobprogress.db";
    }

    bool isOldDBExists = await File(oldAppDBPath).exists();
    List<Map<String, dynamic>>? oldMigratedRecords = await getAllOldUR();
    bool isOldRecordMigrated = oldMigratedRecords?.isEmpty ?? true;
    bool isURMigrated = Helper.isTrue((await SharedPrefService().read(PrefConstants.isURMigrated)) ?? false);
    if(isOldDBExists && isOldRecordMigrated && !isURMigrated) {
      Database db = await openReadOnlyDatabase(oldAppDBPath);
      final result = await db.rawQuery("SELECT * FROM 'unsaved_resources'");
      try {
        for(var element in result) {
          final oldAppData = Map.of(element);
          String formattedDateString = element["created_at"].toString().substring(0, element["created_at"].toString().indexOf("GMT") - 1);
          Jiffy jiffy = Jiffy.parse(formattedDateString, pattern: "EEE MMM dd yyyy HH:mm:ss");

          oldAppData.update("type", (value) => UnsavedResourcesHelper.getOldAppResourcesTypeString(element["type"].toString(), element['data']));
          oldAppData.update("created_at", (value) => DateTimeHelper.format(jiffy.dateTime.toString(), DateFormatConstants.dateTimeServerFormat));
          oldAppData.update("updated_at", (value) => DateTimeHelper.now().toString());
          oldAppData.addEntries({"created_through": "v1"}.entries);

          int? response = await insert(oldAppData);
          if(response == null) {
            deleteAllOldUnsavedResource();
            throw Exception('something_went_wrong'.tr);
          }
        }
        await SharedPrefService().save(PrefConstants.isURMigrated, true);
      } catch (e) {
        rethrow;
      }
    }
  }
}