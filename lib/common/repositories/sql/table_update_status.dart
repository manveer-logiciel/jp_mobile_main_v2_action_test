
import 'package:get/get.dart';
import 'package:jobprogress/common/models/sql/table_update_status.dart';
import 'package:jobprogress/common/providers/sql/db_provider.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/sql.dart';

class SqlTableUpdateStatusRepository {

  Future<bool> isBlankSetUp() async {

    final dbClient = await DBProvider().db;

    int? companyId = AuthService.userDetails?.companyDetails?.id;

    if(companyId == null) return false;

    List<Map<String, dynamic>> count = await dbClient!.rawQuery('''
      SELECT COUNT(*) AS count FROM table_update_status 
      WHERE company_id = $companyId
    ''');

    return count.first['count'] == 0;
  }


  /// [updateStatus] Updates the status of a table in the database.
  /// Params:
  /// [hasNoData] - should be sent true in case data is not coming from server.
  /// It'll add entry to DB but without any last update time so that It can be re-fetched
  /// at next launch. In this case table will be considered as synced.
  /// [hasError] - should be sent true if there is an error while fetching data. In case of error
  /// table will not be considered as synced.
  Future<bool> updateStatus(String tableName, {
      String? dateTime,
      bool hasNoData = false,
      bool hasError = false,
    }) async {
      // Get the database client
      final dbClient = await DBProvider().db;
  
      // Find the sync table with the given table name
      final syncTable = SqlService.syncTablesList.firstWhereOrNull((table) => table.tableName == tableName);
      syncTable?.isSynced = !hasError;
  
      // Set the update time to the provided dateTime or the current time if dateTime is null
      String updateTime = (DateTime.tryParse(dateTime ?? "")?.toString() ?? DateTime.now().toUtc().toString());
  
      // Prepare the data to be inserted or updated in the table_update_status table
      final data = {
        'table_name': tableName,
        'updated_at': (hasNoData || hasError) ? '' : updateTime,
        'company_id': await AuthService.getCompanyId()
      };
  
      // Check if there is already a status entry for the table and company ID
      List<dynamic> tableStatus = await dbClient!.rawQuery('''
        SELECT * FROM table_update_status 
        WHERE table_name = "${data['table_name']}" 
          AND company_id = ${data['company_id']}
      ''');
  
      // Update or insert the status entry in the table_update_status table
      if(tableStatus.isNotEmpty){
        await dbClient.update(
          'table_update_status',
          data,
          where: 'company_id = ? AND table_name = ?',
          whereArgs: [data['company_id'], data['table_name']]);
      } else {
        await dbClient.insert('table_update_status', data);
      }
  
      return true;
    }

  Future<List<TableUpdateStatusModel>> checkStatus() async {
    final dbClient = await DBProvider().db;
    int companyId = await AuthService.getCompanyId();

    List<TableUpdateStatusModel> tableStatus = 
    (await dbClient!.rawQuery('SELECT * FROM table_update_status WHERE company_id = $companyId'))
    .map((status) => TableUpdateStatusModel.fromJson(status))
    .toList();

    return tableStatus;
  }
}