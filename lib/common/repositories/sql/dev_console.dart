import 'package:jobprogress/common/models/sql/dev_console.dart';
import 'package:jobprogress/common/providers/sql/db_provider.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/pagination_constants.dart';
import 'package:sqflite/sqflite.dart';

class SqlDevConsoleRepository {
  static String tableName = "dev_console";
  /// [hasMinDBRequired] will ensure sql operations only if DB version is
  /// greater than or equal to 4
  static bool hasMinDBRequired = DBProvider.dbVersion >= 4;

  /// [insertLog] will add one log at a time in to list of console errors
  static Future<Object?> insertLog(DevConsoleModel devLog) async {
    if (!hasMinDBRequired) return null;
    final dbClient = await DBProvider().db;
    Batch batch = dbClient!.batch();
    batch.insert(tableName, devLog.toJson());
    return await batch.commit(continueOnError: true);
  }

  /// [getLogs] will return list of console errors in descending order
  /// [page] can be used for pagination
  static Future<List<DevConsoleModel>> getLogs([int page = 1]) async {
    if (!hasMinDBRequired) return [];

    int? companyId = AuthService.userDetails?.companyDetails?.id;
    int? userId = AuthService.userDetails?.id;

    final dbClient = await DBProvider().db;
    List<Map<String, dynamic>> result = await dbClient!.rawQuery(
      '''SELECT * FROM $tableName 
         WHERE company_id = $companyId 
         AND user_id = $userId
         AND created_at >= datetime('now' , '-7 days')
         ORDER BY created_at DESC
         LIMIT ${PaginationConstants.pageLimit} OFFSET ${(page - 1) * PaginationConstants.pageLimit}
      ''',
    );

    return result.map((e) => DevConsoleModel.fromJson(e)).toList();
  }

  /// [clearOldLogs] will delete all logs older than 7 days
  static Future<int> clearOldLogs() async {
    if (!hasMinDBRequired) return -1;
    final dbClient = await DBProvider().db;
    return await dbClient!.delete(
      tableName,
      where: "created_at < datetime('now' , '-7 days')",
    );
  }
}