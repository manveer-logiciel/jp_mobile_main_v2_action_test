import 'package:sqflite/sqflite.dart';

/// [DBMigrationBase] is the base class for all migrations
/// It contains the create, upgrade, and downgrade methods
/// NOTE: Any version migrations class should be extended with this class
/// to ensure all migration cases are managed in an organized way
abstract class DBMigrationBase {
  Future<void> onCreate(Batch batch);
  Future<void> onUpgrade(Database db, Batch batch);
  Future<void> onDowngrade(Batch batch);
}