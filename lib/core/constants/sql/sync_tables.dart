
import 'package:jobprogress/common/models/sql/sync_table.dart';
import 'package:jobprogress/common/services/sql.dart';
import 'package:jobprogress/core/constants/firebase/firebase_realtime_keys.dart';
import 'package:jobprogress/core/constants/sql/tables.dart';

class SqlSyncTables {

  static List<SqlSyncTableModel> get list => [
    SqlSyncTableModel(
      tableName: SqlTable.users,
      realTimeKeys: [FirebaseRealtimeKeys.userLastUpdatedTime],
      syncFunction: SqlService.syncUsers,
    ),

    SqlSyncTableModel(
      tableName: SqlTable.divisions,
      realTimeKeys: [FirebaseRealtimeKeys.divisionLastUpdatedTime],
      syncFunction: SqlService.syncDivisions,
    ),

    SqlSyncTableModel(
      tableName: SqlTable.tags,
      realTimeKeys: [FirebaseRealtimeKeys.tagsLastUpdatedTime],
      syncFunction: SqlService.syncTags,
    ),

    SqlSyncTableModel(
      tableName: SqlTable.referralSources,
      realTimeKeys: [FirebaseRealtimeKeys.referralsLastUpdatedTime],
      syncFunction: SqlService.syncReferralSource,
    ),

    SqlSyncTableModel(
      tableName: SqlTable.tradeType,
      realTimeKeys: [FirebaseRealtimeKeys.companyTradesLastUpdatedTime],
      syncFunction: SqlService.syncTradeType,
    ),

    SqlSyncTableModel(
      tableName: SqlTable.company,
      realTimeKeys: [''],
      syncFunction: SqlService.syncCompany,
    ),

    SqlSyncTableModel(
      tableName: SqlTable.country,
      realTimeKeys: [''],
      syncFunction: SqlService.syncCountry,
    ),

    SqlSyncTableModel(
      tableName: SqlTable.state,
      realTimeKeys: [''],
      syncFunction: SqlService.syncState,
    ),

    SqlSyncTableModel(
      tableName: SqlTable.companyStates,
      realTimeKeys: [FirebaseRealtimeKeys.companyStateLastUpdatedTime],
      syncFunction: SqlService.syncCompanyState,
    ),

    SqlSyncTableModel(
      tableName: SqlTable.flags,
      realTimeKeys: [FirebaseRealtimeKeys.customerFlagsUpdatedTime, FirebaseRealtimeKeys.jobFlagsLastUpdatedTime],
      syncFunction: SqlService.syncFlags,
    ),

    SqlSyncTableModel(
      tableName: SqlTable.workFlowStages,
      realTimeKeys: [FirebaseRealtimeKeys.companyWorkflowLastUpdatedTime],
      syncFunction: SqlService.syncWorkflowStages,
    ),
  ];

}