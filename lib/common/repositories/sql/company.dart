import 'package:jobprogress/common/models/sql/company/company.dart';
import 'package:jobprogress/common/providers/sql/db_provider.dart';
import 'package:sqflite/sqflite.dart';

class SqlCompanyRepository {
  /// bulk insert records
  Future<List<Object?>> bulkInsert(List<CompanyModel>? company) async {
    final dbClient = await DBProvider().db;
    Batch batch = dbClient!.batch();

    for (var i = 0; i < company!.length; i++) {
      batch.insert('company', company[i].toJson());
    }

    return await batch.commit(continueOnError:true);
  }

  /// Getting records from local DB
  Future<List<CompanyModel?>> getAll() async {
    final dbClient = await DBProvider().db;

    String query = 'SELECT * FROM company';

    List<CompanyModel> companies = (await dbClient!.rawQuery(query))
      .map((company) => CompanyModel.fromSqlToJson(company))
      .toList();

    if(companies.isNotEmpty) {
      return companies;
    } else {
      return [];
    }
  }

  /// Getting one record from local db
  Future<CompanyModel?> getOne(int id) async {
    final dbClient = await DBProvider().db;

    List<CompanyModel> companies = (await dbClient!.rawQuery('SELECT * FROM company where id = $id'))
      .map((company) => CompanyModel.fromJson(company))
      .toList();
    
    if(companies.isNotEmpty) {
      return companies[0];
    } else {
      return null;
    }
  }

  /// Clear divisions table data
  Future<int> clearRecords() async {
    final dbClient = await DBProvider().db;
    return await dbClient!.delete('company');
  }
}
