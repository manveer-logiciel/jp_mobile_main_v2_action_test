import 'package:jobprogress/common/models/sql/user/user_tag.dart';
import 'package:jobprogress/common/providers/sql/db_provider.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:sqflite/sqflite.dart';

class SqlUserTagsRepository {
  /// bulk insert records
  Future<List<Object?>> bulkInsert(List<UserTagModel>? tags) async {

    int companyId = AuthService.userDetails!.companyDetails!.id;

    final dbClient = await DBProvider().db;
    Batch batch = dbClient!.batch();

    for (var i = 0; i < tags!.length; i++) {
      tags[i].companyId = companyId;
      batch.insert('user_tags', tags[i].toJson());
    }

    return await batch.commit(continueOnError:false);
  }
  /// Clear table data
  Future<int> clearRecords() async {

    int companyId = AuthService.userDetails!.companyDetails!.id;

    final dbClient = await DBProvider().db;
    return await dbClient!.delete(
        'user_tags',
      where: 'company_id = ?',
      whereArgs: [companyId],
    );
  }
  /// Getting records from local DB
  Future<List<UserTagModel>> get() async {

    int companyId = AuthService.userDetails!.companyDetails!.id;

    final dbClient = await DBProvider().db;

    List<UserTagModel> userTags =
        (await dbClient!.rawQuery('SELECT * FROM user_tags WHERE company_id = $companyId'))
            .map((usertag) => UserTagModel.fromJson(usertag))
            .toList();

    return userTags;
  }
}
