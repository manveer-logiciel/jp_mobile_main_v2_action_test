import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/sql/company/company.dart';
import 'package:jobprogress/common/models/sql/country/country.dart';
import 'package:jobprogress/common/models/sql/division/division.dart';
import 'package:jobprogress/common/models/sql/flag/flag.dart';
import 'package:jobprogress/common/models/sql/referral_source/referral_source.dart';
import 'package:jobprogress/common/models/sql/state/company_state.dart';
import 'package:jobprogress/common/models/sql/state/state.dart';
import 'package:jobprogress/common/models/sql/sync_table.dart';
import 'package:jobprogress/common/models/sql/table_update_status.dart';
import 'package:jobprogress/common/models/sql/tag/tag.dart';
import 'package:jobprogress/common/models/sql/trade_type/trade_type.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/sql/user/user_division.dart';
import 'package:jobprogress/common/models/sql/user/user_tag.dart';
import 'package:jobprogress/common/models/sql/work_type/work_type.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/common/repositories/company.dart';
import 'package:jobprogress/common/repositories/country.dart';
import 'package:jobprogress/common/repositories/division.dart';
import 'package:jobprogress/common/repositories/flags.dart';
import 'package:jobprogress/common/repositories/referral.dart';
import 'package:jobprogress/common/repositories/sql/company.dart';
import 'package:jobprogress/common/repositories/sql/company_states.dart';
import 'package:jobprogress/common/repositories/sql/country.dart';
import 'package:jobprogress/common/repositories/sql/division.dart';
import 'package:jobprogress/common/repositories/sql/file_uploader.dart';
import 'package:jobprogress/common/repositories/sql/flags.dart';
import 'package:jobprogress/common/repositories/sql/last_entity_update.dart';
import 'package:jobprogress/common/repositories/sql/referral_sources.dart';
import 'package:jobprogress/common/repositories/sql/state.dart';
import 'package:jobprogress/common/repositories/sql/table_update_status.dart';
import 'package:jobprogress/common/repositories/sql/tag.dart';
import 'package:jobprogress/common/repositories/sql/trade_type.dart';
import 'package:jobprogress/common/repositories/sql/user.dart';
import 'package:jobprogress/common/repositories/sql/user_division.dart';
import 'package:jobprogress/common/repositories/sql/user_tag.dart';
import 'package:jobprogress/common/repositories/sql/work_type.dart';
import 'package:jobprogress/common/repositories/sql/workflow_stages.dart';
import 'package:jobprogress/common/repositories/stage_resources.dart';
import 'package:jobprogress/common/repositories/state.dart';
import 'package:jobprogress/common/repositories/sub_contractor.dart';
import 'package:jobprogress/common/repositories/tag.dart';
import 'package:jobprogress/common/repositories/trade.dart';
import 'package:jobprogress/common/repositories/user.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/sql/sync_tables.dart';
import 'package:jobprogress/core/constants/sql/tables.dart';

import '../repositories/sql/unsaved_resources.dart';

class SqlService {

  static SqlTableUpdateStatusRepository tableStatus = SqlTableUpdateStatusRepository();

  static bool get companyExists => chkIfCompanyExists();

  static List<SqlSyncTableModel> syncTablesList = SqlSyncTables.list;

  /// [syncLocalDb] ensures initial set-up and updates local DB accordingly
  static Future<void> syncLocalDb() async {

    if(!companyExists) return;

    final isBlankSetup = (await tableStatus.isBlankSetUp()) || Get.testMode;

    if(isBlankSetup) await blankSetUp();

    await checkIfAllTablesSynced();

  }

  /// [migrateOldDB] ensures initial set-up and updates local DB from old app to new app
  static Future<void> migrateOldDB() async {
    try {
      /// Migrate Auto-Saved Files
      await SqlUnsavedResourcesRepository().migrateOldDB();
      /// Migrate Pending-Upload Files
      /// Migrate Files upload
      await SqlFileUploaderRepository().migrateOldTable();
    } catch (e) {
      rethrow;
    }
  }

  /// [checkIfAllTablesSynced] iterates through all tables and confirms whether they
  /// contains updated data
  static Future<void> checkIfAllTablesSynced() async {

    if(!companyExists) return; // returning in case company not available

    try {

      // fetching last updated entities from server to compare them with local
      final lastUpdatedEntities = await SqlLastEntityUpdate.fetchLastUpdatedEntities();

      // fetching last updated entities from local DB
      List<TableUpdateStatusModel> allTableSyncStatus = await tableStatus.checkStatus();

      List<SqlSyncTableModel> tablesToReFetch = [];
      tablesToReFetch.addAll(syncTablesList);

      for (var status in allTableSyncStatus) {

        // getting sync table details eg. realtime-key, sync function
        // from currently active element of iteration
        final syncTable = syncTablesList.firstWhereOrNull((table) => table.tableName == status.tableName);

        // returning if sync details not found
        if(syncTable == null || status.updatedAt.isEmpty) continue;

        // parsing server timings
        List<dynamic> serverUpdatedTime = syncTable.realTimeKeys.map((key) => lastUpdatedEntities[key]).toList();

        bool doReFetch = checkIfNeedsReFetch(
            serverUpdatedTime,
            status.updatedAt,
        );

        // removing table from sync list. If it is already synced
        if(!doReFetch) {
          syncTable.isSynced = true;
          tablesToReFetch.remove(syncTable);
        }
      }

      debugPrint("RE FETCHING : ${tablesToReFetch.map((e) => e.tableName).toList()}");

      final tablesToSync = tablesToReFetch.map((e) => e.syncFunction.call(dateTime: DateTime.now().toUtc().toString())).toList();

      await Future.wait(tablesToSync);

    } catch (e) {
      rethrow;
    }
  }

  /// [checkIfNeedsReFetch] helps in deciding whether if table is synced with
  /// server data on initial run
  static bool checkIfNeedsReFetch(List<dynamic> serverTimes, String localTime) {

    // No need to re-fetch if server time does not exists
    serverTimes.removeWhere((time) => time == null);
    if(serverTimes.isEmpty) return false;

    final localUpdatedTime = DateTime.parse(localTime);

    return serverTimes.any((serverTime) {
      // requires re-fetch if local sync time is smaller than server sync time
      return localUpdatedTime.isBefore(DateTime.parse(serverTime+' z').toUtc());
    });
  }

  /// [blankSetUp] executes blank DB setup
  static Future<void> blankSetUp() async {

    final tablesToSync = syncTablesList.map((e) => e.syncFunction.call()).toList();

    await Future.wait(tablesToSync);

  }

  /// [syncUsers] can be used to individually sync users
  static Future<void> syncUsers({String? dateTime}) async {

    if(!companyExists) return;

    try {
      debugPrint("SQL: syncing user");
      // adding users into local db
      List<UserModel> users = await UserRepository().getAll();
      users.addAll(await SubContractorRepository().getAll());

      if (users.isNotEmpty) {
        await SqlUserRepository().clearRecords();
        await SqlUserRepository().bulkInsert(users);
        await SqlTableUpdateStatusRepository().updateStatus(SqlTable.users, dateTime: dateTime);
        if(dateTime != null)  await syncDivisions();
        if(dateTime != null)  await syncTags();
      } else {
        await SqlUserRepository().clearRecords();
        await SqlTableUpdateStatusRepository().updateStatus(SqlTable.users, hasError: true);
      }
    } catch (e) {
      await SqlTableUpdateStatusRepository().updateStatus(SqlTable.users, hasError: true);
      debugPrint("SQL: failed to sync users");
    }
  }

  /// [syncDivisions] can be used to individually sync divisions
  static Future<void> syncDivisions({String? dateTime}) async {

    if(!companyExists) return;

    try {
      debugPrint("SQL: syncing divisions");

      List<DivisionModel> divisions = await DivisionRepository().getAll();

      if (divisions.isNotEmpty) {
        AuthService.updateDivisions(divisions);
        await SqlDivisionRepository().clearRecords();
        await SqlDivisionRepository().bulkInsert(divisions);
        await SqlTableUpdateStatusRepository().updateStatus(SqlTable.divisions, dateTime: dateTime);
        List<UserDivisionModel> userDivisionsList = [];
        for (DivisionModel element in divisions) {
          if (element.userDivisions != null &&
              element.userDivisions!.isNotEmpty) {
            userDivisionsList.addAll(element.userDivisions!.toList());
          }
        }
        if (userDivisionsList.isNotEmpty) {
          await SqlUserDivisionsRepository().clearRecords();
          await SqlUserDivisionsRepository().bulkInsert(userDivisionsList);
          await SqlTableUpdateStatusRepository().updateStatus(SqlTable.userDivisions, dateTime: dateTime);
        }
      } else {
        await SqlDivisionRepository().clearRecords();
        await SqlUserDivisionsRepository().clearRecords();
        await SqlTableUpdateStatusRepository().updateStatus(SqlTable.divisions, hasNoData: true);
        await SqlTableUpdateStatusRepository().updateStatus(SqlTable.userDivisions, hasNoData: true);
      }
    } catch (e) {
      await SqlTableUpdateStatusRepository().updateStatus(SqlTable.divisions, hasError: true);
      await SqlTableUpdateStatusRepository().updateStatus(SqlTable.userDivisions, hasError: true);
      debugPrint("SQL: failed to sync divisions");
    }
  }

  /// [syncTags] can be used to individually sync tags
  static Future<void> syncTags({String? dateTime}) async {

    if(!companyExists) return;

    try {
      debugPrint("SQL: syncing tags");
      // adding tags into local db
      List<TagModel> tags = await TagRepository().getAll();
      if (tags.isNotEmpty) {
        await SqlTagsRepository().clearRecords();
        await SqlTagsRepository().bulkInsert(tags);
        await SqlTableUpdateStatusRepository().updateStatus(SqlTable.tags, dateTime: dateTime);
        List<UserTagModel> userTagsList = [];
        for (TagModel element in tags) {
          if (element.userTags != null && element.userTags!.isNotEmpty) {
            userTagsList.addAll(element.userTags!.toList());
          }
        }
        if (userTagsList.isNotEmpty) {
          await SqlUserTagsRepository().clearRecords();
          await SqlUserTagsRepository().bulkInsert(userTagsList);
          await SqlTableUpdateStatusRepository().updateStatus('user_tags');
        }
      } else {
        await SqlTagsRepository().clearRecords();
        await SqlUserTagsRepository().clearRecords();
        await SqlTableUpdateStatusRepository().updateStatus(SqlTable.tags, hasNoData: true);
        await SqlTableUpdateStatusRepository().updateStatus(SqlTable.userTags, hasNoData: true);
      }
    } catch (e) {
      await SqlTableUpdateStatusRepository().updateStatus(SqlTable.tags, hasError: true);
      await SqlTableUpdateStatusRepository().updateStatus(SqlTable.userTags, hasError: true);
      debugPrint("SQL: failed to sync tags");
    }
  }

  /// [syncReferralSource] can be used to individually sync referral source
  static Future<void> syncReferralSource({String? dateTime}) async {

    if(!companyExists || AuthService.isPrimeSubUser()) return;

    try {
      debugPrint("SQL: syncing referral source");

      List<ReferralSourcesModel> referrals = await ReferralRepository().getAll();
      if (referrals.isNotEmpty) {
        await SqlReferralSourcesRepository().clearRecords();
        await SqlReferralSourcesRepository().bulkInsert(referrals);
        await SqlTableUpdateStatusRepository().updateStatus(SqlTable.referralSources, dateTime: dateTime);
      } else {
        await SqlReferralSourcesRepository().clearRecords();
        await SqlTableUpdateStatusRepository().updateStatus(SqlTable.referralSources, hasNoData: true);
      }
    } catch (e) {
      await SqlTableUpdateStatusRepository().updateStatus(SqlTable.referralSources, hasError: true);
      debugPrint("SQL: failed to sync referral source");
    }
  }

  /// [syncTradeType] can be used to individually sync trade type
  static Future<void> syncTradeType({String? dateTime}) async {

    if(!companyExists) return;

    try {
      debugPrint("SQL: syncing trade type");

      List<TradeTypeModel> trades = await TradeRepository().getAll();

      if (trades.isNotEmpty) {
        await SqlTradeTypeRepository().clearRecords();
        await SqlTradeTypeRepository().bulkInsert(trades);
        await SqlTableUpdateStatusRepository().updateStatus(SqlTable.tradeType, dateTime: dateTime);
        List<WorkTypeModel> workTypeList = [];
        for (var element in trades) {
          if (element.workType != null && element.workType!.isNotEmpty) {
            workTypeList.addAll(element.workType!.toList());
          }
        }
        if (workTypeList.isNotEmpty) {
          await SqlWorkTypeRepository().clearRecords();
          await SqlWorkTypeRepository().bulkInsert(workTypeList);
          await SqlTableUpdateStatusRepository().updateStatus(SqlTable.workType);
        }
      } else {
        await SqlTradeTypeRepository().clearRecords();
        await SqlWorkTypeRepository().clearRecords();
        await SqlTableUpdateStatusRepository().updateStatus(SqlTable.tradeType, hasNoData: true);
        await SqlTableUpdateStatusRepository().updateStatus(SqlTable.workType, hasNoData: true);
      }
    } catch (e) {
      await SqlTableUpdateStatusRepository().updateStatus(SqlTable.tradeType, hasError: true);
      await SqlTableUpdateStatusRepository().updateStatus(SqlTable.workType, hasError: true);
      debugPrint("SQL: failed to sync trades types");
    }
  }

  /// [syncCompany] can be used to individually sync company
  static Future<void> syncCompany({String? dateTime}) async {

    if(!companyExists) return;

    try {
      debugPrint("SQL: syncing company");

      List<CompanyModel> companies = await CompanyRepository().getCompanyList();
      if (companies.isNotEmpty) {
        await SqlCompanyRepository().clearRecords();
        await SqlCompanyRepository().bulkInsert(companies);
        await SqlTableUpdateStatusRepository().updateStatus(SqlTable.company, dateTime: dateTime);
      }
    } catch (e) {
      await SqlTableUpdateStatusRepository().updateStatus(SqlTable.company, hasError: true);
      debugPrint("SQL: failed to sync company");
    }
  }

  /// [syncCountry] can be used to individually sync country
  static Future<void> syncCountry({String? dateTime}) async {

    if(!companyExists) return;

    try {
      debugPrint("SQL: syncing country");

      List<CountryModel> countries = await CountryRepository().getCountryList();
      if (countries.isNotEmpty) {
        await SqlCountryRepository().clearRecords();
        await SqlCountryRepository().bulkInsert(countries);
        await SqlTableUpdateStatusRepository().updateStatus(SqlTable.country, dateTime: dateTime);
      }
    } catch (e) {
      await SqlTableUpdateStatusRepository().updateStatus(SqlTable.country, hasError: true);
      debugPrint("SQL: failed to sync country");
    }
  }

  /// [syncState] can be used to individually sync state
  static Future<void> syncState({String? dateTime}) async {

    if(!companyExists) return;

    try {
      debugPrint("SQL: syncing state");

      List<StateModel> states = await StateRepository().getStateList();
      if (states.isNotEmpty) {
        await SqlStateRepository().clearRecords();
        await SqlStateRepository().bulkInsert(states);
        await SqlTableUpdateStatusRepository().updateStatus(SqlTable.state, dateTime: dateTime);
      }
    } catch (e) {
      await SqlTableUpdateStatusRepository().updateStatus(SqlTable.state, hasError: true);
      debugPrint("SQL: failed to sync states");
    }
  }

  /// [syncCompanyState] can be used to individually sync company state
  static Future<void> syncCompanyState({String? dateTime}) async {

    if(!companyExists) return;

    try {
      debugPrint("SQL: syncing company_state");

      List<CompanyStateModel> states = await StateRepository().getCompanyStateList();
      if (states.isNotEmpty) {
        await SqlCompanyStatesRepository().clearRecords();
        await SqlCompanyStatesRepository().bulkInsert(states);
        await SqlTableUpdateStatusRepository().updateStatus(SqlTable.companyStates, dateTime: dateTime);
      } else {
        await SqlCompanyStatesRepository().clearRecords();
        await SqlTableUpdateStatusRepository().updateStatus(SqlTable.companyStates, hasNoData: true);
      }
    } catch (e) {
      await SqlTableUpdateStatusRepository().updateStatus(SqlTable.companyStates, hasError: true);
      debugPrint("SQL: failed to sync company_state");
    }
  }

  /// [syncFlags] can be used to individually sync flags
  static Future<void> syncFlags({String? dateTime}) async {

    if(!companyExists) return;

    try {
      debugPrint("SQL: syncing flags");

      Map<String, dynamic> params = {
        'includes[0]': 'color',
        'limit': 0
      };
      List<FlagModel> flags = await FlagsRepository().getFlagList(params);

      if (flags.isNotEmpty) {
        await SqlFlagRepository().clearRecords();
        await SqlFlagRepository().bulkInsert(flags);
        await SqlTableUpdateStatusRepository().updateStatus(SqlTable.flags, dateTime: dateTime);
      } else {
        await SqlFlagRepository().clearRecords();
        await SqlTableUpdateStatusRepository().updateStatus(SqlTable.flags, hasNoData: true);
      }
    } catch (e) {
      await SqlTableUpdateStatusRepository().updateStatus(SqlTable.flags, hasError: true);
      debugPrint("SQL: failed to sync flags");
    }
  }

  /// [syncWorkflowStages] can be used to individually sync workFlowStages
  static Future<void> syncWorkflowStages({String? dateTime}) async {

    if(!companyExists) return;

    try {
      debugPrint("SQL: syncing workflow stages");

      List<WorkFlowStageModel> stages = await StageResourcesRepository
          .fetchStages();
      if (stages.isNotEmpty) {
        await SqlWorkFlowStagesRepository().clearRecords();
        await SqlWorkFlowStagesRepository().bulkInsert(stages);
        await SqlTableUpdateStatusRepository().updateStatus(SqlTable.workFlowStages, dateTime: dateTime);
      }
    } catch (e) {
      await SqlTableUpdateStatusRepository().updateStatus(SqlTable.workFlowStages, hasError: true);
      debugPrint("SQL: failed to sync workflow stages");
    }
  }

  static bool chkIfCompanyExists() {
    return AuthService.userDetails?.companyDetails?.id != null;
  }

  /// [fetchUnSyncedTables] - Fetches and syncs unsynchronized tables.
  ///
  /// This function retrieves a list of unsynchronized tables using the [getUnSyncedTables] function.
  /// It then iterates over each table and calls its sync function using the [syncFunction] method.
  static Future<void> fetchUnSyncedTables() async {
      final unSyncedTables = getUnSyncedTables();
      await Future.wait(unSyncedTables.map((table) => table.syncFunction.call()).toList());
  }

  /// [getUnSyncedTables] function filters the [syncTablesList] and returns only the tables
  /// that have the [isSynced] property set to `false`.
  static List<SqlSyncTableModel> getUnSyncedTables() {
    return syncTablesList.where((table) => !table.isSynced).toList();
  }

}