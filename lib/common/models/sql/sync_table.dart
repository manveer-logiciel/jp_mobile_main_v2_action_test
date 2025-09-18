class SqlSyncTableModel {

  String tableName;
  bool isSynced;
  List<String> realTimeKeys;
  Future<void> Function({String? dateTime}) syncFunction;

  SqlSyncTableModel({
    required this.tableName,
    required this.realTimeKeys,
    required this.syncFunction,
    this.isSynced = false,
  });

}
