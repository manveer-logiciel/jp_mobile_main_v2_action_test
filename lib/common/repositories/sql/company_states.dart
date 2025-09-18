import 'package:jobprogress/common/models/sql/state/company_state.dart';
import 'package:jobprogress/common/providers/sql/db_provider.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/sql/tables.dart';
import 'package:sqflite/sqflite.dart';

class SqlCompanyStatesRepository {

  String table = SqlTable.companyStates;

  /// Bulk insert Company States data into company_state table
  Future<List<Object?>> bulkInsert(List<CompanyStateModel> companyState) async {
    final dbClient = await DBProvider().db;
    final companyId = AuthService.userDetails?.companyDetails?.id;
    Batch batch = dbClient!.batch();

    for (var i = 0; i < companyState.length; i++) {
      companyState[i].companyId = companyId;
      batch.insert(table, companyState[i].toJson());
    }

    return await batch.commit(continueOnError: true);
  }

  /// Clear company_state table data
  Future<int> clearRecords() async {
    int companyId = await AuthService.getCompanyId();

    final dbClient = await DBProvider().db;
    return await dbClient!.delete(
      table,
      where: 'company_id = ?',
      whereArgs: [companyId],
    );
  }

  /// Getting company_state records from local DB
  Future<List<CompanyStateModel>> get() async {

    final dbClient = await DBProvider().db;

    List<CompanyStateModel> companyStates =
        (await dbClient!.rawQuery("SELECT * FROM $table"))
            .map((companyState) => CompanyStateModel.fromJson(companyState))
            .toList();

    return companyStates;
  }
}
