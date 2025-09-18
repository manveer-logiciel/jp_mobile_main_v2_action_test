import 'package:jobprogress/common/models/sql/user/user_division.dart';
import 'package:jobprogress/common/providers/sql/db_provider.dart';
import 'package:sqflite/sqflite.dart';

class SqlUserDivisionsRepository {
  /// bulk insert records
  Future<List<Object?>> bulkInsert(List<UserDivisionModel>? divisions) async {
    final dbClient = await DBProvider().db;
    Batch batch = dbClient!.batch();

    for (var i = 0; i < divisions!.length; i++) {
      batch.insert('user_divisions', divisions[i].toJson());
    }

    return await batch.commit(continueOnError:true);
  }
  /// Clear table data
  Future<int> clearRecords() async {
    final dbClient = await DBProvider().db;
    return await dbClient!.delete('user_divisions');
  }
  /// Getting records from local DB
  Future<List<UserDivisionModel>> get() async {
    final dbClient = await DBProvider().db;

    List<UserDivisionModel> userDivisions =
        (await dbClient!.rawQuery('SELECT * FROM user_divisions'))
            .map((usertag) => UserDivisionModel.fromJson(usertag))
            .toList();

    return userDivisions;
  }
}
