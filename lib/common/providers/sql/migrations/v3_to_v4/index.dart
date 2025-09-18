import 'package:jobprogress/common/providers/sql/migrations/base/index.dart';
import 'package:sqflite/sqflite.dart';

/// [DbMigrationV3toV4] will be responsible for migrating DB from version 3 to 4
class DbMigrationV3toV4 extends DBMigrationBase {
  @override
  Future<void> onCreate(Batch batch) async {
    await createDevConsoleTable(batch);
  }

  @override
  Future<void> onDowngrade(Batch batch) async {
    await dropDevConsoleTable(batch);
  }

  @override
  Future<void> onUpgrade(Database db, Batch batch) async {
    await createDevConsoleTable(batch);
  }

  Future<void> createDevConsoleTable(Batch batch) async {
    batch.execute('''CREATE TABLE dev_console(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type TEXT,
      description TEXT,
      page TEXT,
      app_version TEXT,
      company_id INTEGER,
      user_id INTEGER,
      created_at TEXT,
      updated_at TEXT
    )''');
  }

  Future<void> dropDevConsoleTable(Batch batch) async {
    batch.execute('''DROP TABLE dev_console''');
  }
}