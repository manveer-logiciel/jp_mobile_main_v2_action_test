import 'package:jobprogress/common/providers/sql/migrations/base/index.dart';
import 'package:sqflite/sqflite.dart';

/// [DbMigrationV4toV5] will be responsible for migrating DB from version 3 to 4
class DbMigrationV4toV5 extends DBMigrationBase {
  @override
  Future<void> onCreate(Batch batch) async {
    return;
  }

  @override
  Future<void> onDowngrade(Batch batch) async {
    return;
  }

  @override
  Future<void> onUpgrade(Database db, Batch batch) async {
    await removeTagsTable(batch);
  }

  Future<void> removeTagsTable(Batch batch) async {
    batch.execute('''DELETE FROM table_update_status WHERE table_name = 'tags' ''');
  }
}