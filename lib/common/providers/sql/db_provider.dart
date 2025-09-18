import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'migrations/v3_to_v4/index.dart';
import 'migrations/v4_to_v5/index.dart';
import 'migrations/v5_to_v6/index.dart';

const String dataBaseName = 'JobProgress.db';

class DBProvider {
  static Database? _db;
  static int dbVersion = 6;

  Future<Database?> get db async {
    _db ??= await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, dataBaseName);
    var db = await openDatabase(path, version: dbVersion, onCreate: onCreate, onUpgrade: onUpgrade, onDowngrade: onDowngrade);
    return db;
  }

  onCreate(Database db, int version) {
    Batch batch = db.batch();

    /// Tables creation
    /// 1. user
    /// 2. tags
    /// 3. divisions
    /// 4. user_tags -> user tags relation table
    /// 5. user_divisions -> user division relation table 
    /// 6. referral_sources
    /// 7. trade_type
    /// 8. trade_type
    /// 9. table_update_status
    /// 10. company
    /// 11. country
    /// 12. state
    /// 13. unsaved_resources
    /// 14. dev_console
    batch.execute('''CREATE TABLE user(
      local_id STRING PRIMARY KEY,
      id INTEGER,
      first_name TEXT,
      last_name TEXT,
      full_name TEXT,
      email TEXT,
      group_id INTEGER,
      group_name TEXT,
      company_id INTEGER,
      profile_pic TEXT,
      active INTEGER,
      company_name TEXT,
      sub_company_name TEXT,
      color TEXT,
      resource_id INTEGER,
      total_commission TEXT,
      paid_commission TEXT,
      unpaid_commission TEXT,
      data_masking INTEGER,
      all_divisions_access INTEGER,
      customer_id INTEGER
      )''');

    batch.execute('''CREATE TABLE tags(
      local_id STRING PRIMARY KEY,
      id INTEGER,
      company_id INTEGER,
      name TEXT,
      type TEXT,
      updated_at TEXT,
      active INTEGER)''');

    batch.execute('''CREATE TABLE divisions(
      local_id STRING PRIMARY KEY,
      id INTEGER,
      company_id INTEGER,
      code TEXT,
      color TEXT,
      email TEXT,
      name TEXT,
      phone TEXT,
      phone_ext TEXT,
      active INTEGER)''');

    batch.execute('''CREATE TABLE user_tags(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      company_id INTEGER,
      user_id INTEGER,
      tag_id INTEGER)''');

    batch.execute('''CREATE TABLE user_divisions(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      division_id INTEGER)''');

    batch.execute('''CREATE TABLE referral_sources(
      local_id STRING PRIMARY KEY,
      id INTEGER,
      company_id INTEGER,
      name TEXT,
      cost TEXT,
      active INTEGER)''');

    batch.execute('''CREATE TABLE trade_type(
      local_id STRING PRIMARY KEY,
      id INTEGER,
      company_id INTEGER,
      name TEXT,
      color TEXT,
      active INTEGER)''');

    batch.execute('''CREATE TABLE work_type(
      local_id STRING PRIMARY KEY,
      id INTEGER,
      company_id INTEGER,
      trade_id INTEGER,
      name TEXT,
      color TEXT,
      active INTEGER)''');
    
    batch.execute('''CREATE TABLE table_update_status(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      company_id INTEGER,
      table_name TEXT,
      updated_at TEXT
    )''');
    
    batch.execute('''CREATE TABLE company(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      company_name TEXT,
      logo TEXT,
      email TEXT,
      phone TEXT,
      additional_phone TEXT,
      additional_email TEXT,
      address TEXT,
      address_line_1 TEXT,
      fax TEXT,
      street TEXT,
      city TEXT,
      zip TEXT,
      state_id INTEGER,
      state_name TEXT,
      state_code TEXT,
      country_id INTEGER,
      country_name TEXT,
      country_code TEXT,
      phone_code TEXT,
      currency_symbol TEXT,
      phone_format TEXT,
      license_number TEXT
    )''');

    batch.execute('''CREATE TABLE country(
      local_id STRING PRIMARY KEY,
      id INTEGER,
      name TEXT,
      code TEXT,
      currency_name TEXT,
      currency_symbol TEXT,
      phone_code TEXT,
      phone_format TEXT,
      company_id INTEGER
    )''');
    
    batch.execute('''CREATE TABLE state(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      code TEXT,
      country_id INTEGER
    )''');

    batch.execute('''CREATE TABLE company_state(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      company_id INTEGER,
      state_id INTEGER
    )''');

    batch.execute('''CREATE TABLE flags(
      local_id STRING PRIMARY KEY,
      id INTEGER,
      title TEXT,
      for TEXT,
      color TEXT,
      reserved INTEGER,
      company_id INTEGER
    )''');

    batch.execute('''CREATE TABLE uploader(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      company_id INTEGER,
      file_status TEXT,
      local_path TEXT,
      display_path TEXT,
      file_name TEXT,
      params TEXT,
      type TEXT,
      created_at TEXT,
      updated_at TEXT,
      created_through TEXT,
      error TEXT
    )''');

    batch.execute('''CREATE TABLE workflow_stages(
      local_id STRING PRIMARY KEY,
      id INTEGER,
      company_id INTEGER,
      code TEXT,
      color TEXT,
      name TEXT,
      create_tasks INTEGER,
      locked INTEGER,
      send_customer_email INTEGER,
      send_push_notification INTEGER,
      send_web_notification INTEGER,
      workflow_id INTEGER,
      wp_unseen_count INTEGER,
      resource_id INTEGER,
      created_at TEXT,
      updated_at TEXT,
      color_type TEXT,
      group_id INTEGER,
      group_name TEXT,
      group_color TEXT
    )''');

    batch.execute('''CREATE TABLE unsaved_resources(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type TEXT,
      customer_id INTEGER,
      company_id INTEGER,
      job_id INTEGER,
      data TEXT,
      created_at TEXT,
      updated_at TEXT,
      created_through TEXT
    )''');

    DbMigrationV3toV4().onCreate(batch);
    
    return batch.commit(continueOnError: true);
  }

  /// [onUpgrade] will be called on updating version number
  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    Batch batch = db.batch();

    if (oldVersion <= 2) {
      String query = "SELECT name FROM sqlite_master WHERE type='table'";
      // query to obtain the names of all tables in database
      List<Map<String, dynamic>> allTables = await db.rawQuery(query, null);
      for (var table in allTables) {
        batch.execute("DROP TABLE IF EXISTS " + table['name']);
      }
      await batch.commit(continueOnError: true);
      onCreate(db, newVersion);
    }

    if (oldVersion >= 3) {
      await DbMigrationV3toV4().onUpgrade(db, batch);
      await DbMigrationV4toV5().onUpgrade(db, batch);
    }

    if (newVersion > 5) {
      await DbMigrationV5toV6().onUpgrade(db, batch);
    }

    await batch.commit(continueOnError: true);
  }

  Future<void> onDowngrade(Database db, int oldVersion, int newVersion) async {
    Batch batch = db.batch();
    if (oldVersion == 6) {
      DbMigrationV5toV6().onDowngrade(batch);
    } else if (oldVersion == 4) {
      DbMigrationV3toV4().onDowngrade(batch);
    }
    await batch.commit(continueOnError: true);
  }

  Future<void> deleteDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, dataBaseName);

    if (await databaseFactory.databaseExists(path)) {
      await databaseFactory.deleteDatabase(path);
      _db = null;
    }
  }
}
