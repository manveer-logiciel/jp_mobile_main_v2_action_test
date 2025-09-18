import 'package:jobprogress/common/models/sql/flag/flag.dart';
import 'package:jobprogress/common/providers/sql/db_provider.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:sqflite/sqflite.dart';

class SqlFlagRepository {
  /// bulk insert records
  Future<List<Object?>> bulkInsert(List<FlagModel> flags) async {
    int companyId = await AuthService.getCompanyId();

    final dbClient = await DBProvider().db;
    Batch batch = dbClient!.batch();

    for (var i = 0; i < flags.length; i++) {
      final flag = flags[i]
        ..companyId = companyId;
      batch.insert('flags', flag.toJson());
    }

    return await batch.commit(continueOnError: true);
  }

  /// Getting records from local DB
  Future<List<FlagModel?>> get({String? type}) async {
    int companyId = await AuthService.getCompanyId();

    final dbClient = await DBProvider().db;

    String query = 'SELECT * FROM flags WHERE company_id = $companyId';
    
    if(type != null) {
      query += ' AND for = "$type"';
    }

    List<FlagModel> flags = (await dbClient!.rawQuery(query))
      .map((flag) => FlagModel.fromJson(flag))
      .toList();

    if(flags.isNotEmpty) {
      return flags;
    } else {
      return [];
    }
  }

  /// Clear flags table data
  Future<int> clearRecords() async {

    final companyId = AuthService.userDetails!.companyDetails?.id;

    final dbClient = await DBProvider().db;
    return await dbClient!.delete(
        'flags',
        where: 'company_id = ?',
        whereArgs: [companyId]
    );
  }
}
