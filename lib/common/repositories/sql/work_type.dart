import 'package:jobprogress/common/models/sql/work_type/work_type.dart';
import 'package:jobprogress/common/providers/sql/db_provider.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:sqflite/sqflite.dart';

class SqlWorkTypeRepository {
  /// bulk insert records
  Future<List<Object?>> bulkInsert(List<WorkTypeModel>? workTypes) async {
    int companyId = await AuthService.getCompanyId();
    final dbClient = await DBProvider().db;
    Batch batch = dbClient!.batch();

    for (var i = 0; i < workTypes!.length; i++) {
      final workType = workTypes[i]
        ..companyId = companyId;

      batch.insert('work_type', workType.toJson());
    }

    return await batch.commit(continueOnError:true);
  }

  /// Clear table data
  Future<int> clearRecords() async {
    int companyId = await AuthService.getCompanyId();
    
    final dbClient = await DBProvider().db;
    return await dbClient!.delete(
      'work_type',
      where: 'company_id = ?',
      whereArgs: [companyId],
    );
  }

}
