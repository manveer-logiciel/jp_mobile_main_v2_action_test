import 'package:jobprogress/common/models/sql/country/country.dart';
import 'package:jobprogress/common/providers/sql/db_provider.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:sqflite/sqflite.dart';

class SqlCountryRepository {
  /// bulk insert records
  Future<List<Object?>> bulkInsert(List<CountryModel> country) async {
    final dbClient = await DBProvider().db;
    Batch batch = dbClient!.batch();
    final companyId = AuthService.userDetails?.companyDetails?.id;

    for (var i = 0; i < country.length; i++) {
      country[i].companyId = companyId;
      batch.insert('country', country[i].toJson());
    }

    return await batch.commit(continueOnError:true);
  }

  /// Getting records from local DB
  Future<List<CountryModel?>> get() async {

    final companyId = AuthService.userDetails!.companyDetails!.id;

    final dbClient = await DBProvider().db;

    String query = 'SELECT * FROM country ';

    query += 'WHERE company_id = $companyId';

    List<CountryModel> countries = (await dbClient!.rawQuery(query))
      .map((country) => CountryModel.fromJson(country))
      .toList();

    if(countries.isNotEmpty) {
      return countries;
    } else {
      return [];
    }
  }

  /// Getting one record from local db
  Future<CountryModel?> getOne(int id) async {
    final dbClient = await DBProvider().db;

    List<CountryModel> countries = (await dbClient!.rawQuery('SELECT * FROM country where id = $id'))
      .map((country) => CountryModel.fromJson(country))
      .toList();

    if(countries.isNotEmpty) {
      return countries[0];
    } else {
      return null;
    }
  }

  /// Clear divisions table data
  Future<int> clearRecords() async {

    final dbClient = await DBProvider().db;
    final companyId = AuthService.userDetails!.companyDetails!.id;

    return await dbClient!.delete('country',
        where: 'company_id = ?',
        whereArgs: [companyId],
    );
  }
}
