// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/sql/company/company.dart';
import 'package:jobprogress/common/models/sql/country/country.dart';
import 'package:jobprogress/common/models/sql/division/division.dart';
import 'package:jobprogress/common/models/sql/division/division_param.dart';
import 'package:jobprogress/common/models/sql/division/division_response.dart';
import 'package:jobprogress/common/models/sql/flag/flag.dart';
import 'package:jobprogress/common/models/sql/referral_source/referral_source.dart';
import 'package:jobprogress/common/models/sql/referral_source/referral_source_param.dart';
import 'package:jobprogress/common/models/sql/referral_source/referral_source_response.dart';
import 'package:jobprogress/common/models/sql/state/state.dart';
import 'package:jobprogress/common/models/sql/table_update_status.dart';
import 'package:jobprogress/common/models/sql/tag/tag.dart';
import 'package:jobprogress/common/models/sql/tag/tag_param.dart';
import 'package:jobprogress/common/models/sql/tag/tag_response.dart';
import 'package:jobprogress/common/models/sql/trade_type/trade_type.dart';
import 'package:jobprogress/common/models/sql/trade_type/trade_type_param.dart';
import 'package:jobprogress/common/models/sql/trade_type/trade_type_response.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/sql/user/user_division.dart';
import 'package:jobprogress/common/models/sql/user/user_param.dart';
import 'package:jobprogress/common/models/sql/user/user_response.dart';
import 'package:jobprogress/common/models/sql/user/user_tag.dart';
import 'package:jobprogress/common/models/sql/work_type/work_type.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/common/providers/sql/db_provider.dart';
import 'package:jobprogress/common/repositories/company.dart';
import 'package:jobprogress/common/repositories/country.dart';
import 'package:jobprogress/common/repositories/division.dart';
import 'package:jobprogress/common/repositories/flags.dart';
import 'package:jobprogress/common/repositories/referral.dart';
import 'package:jobprogress/common/repositories/sql/company.dart';
import 'package:jobprogress/common/repositories/sql/country.dart';
import 'package:jobprogress/common/repositories/sql/division.dart';
import 'package:jobprogress/common/repositories/sql/file_uploader.dart';
import 'package:jobprogress/common/repositories/sql/flags.dart';
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
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';

import '../../common/enums/local_db_get_actions.dart';
import '../../common/enums/local_db_sync_actions.dart';
import '../../common/repositories/sql/unsaved_resources.dart';

class SqlController extends GetxController {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String userUpdatedAt = '';
  String tagUpdatedAt = '';
  String divisionUpdatedAt = '';
  String referralUpdatedAt = '';
  String tradeUpdatedAt = '';
  String companyUpdatedAt = '';
  String countryUpdatedAt = '';
  String stateUpdatedAt = '';
  String flagUpdatedAt = '';
  String workflowStagesUpdatedAt = '';
  String fileUploadsUpdatedAt = '';

  List<dynamic> isLoading = [];

  @override
  void onInit() async{
    checkLastSyncStatus();
    super.onInit();
  }

  /////////////////////////   API SYNC  ACTIONS   //////////////////////////////

  Future<void> syncUser({required SyncActions isLoading}) async {
    try {
      handleLoader(isLoading);
      List<UserModel> users = await UserRepository().getAll();
      users.addAll(await SubContractorRepository().getAll());
      if (users.isNotEmpty) {
        await SqlUserRepository().clearRecords();
        await SqlUserRepository().bulkInsert(users);
        await SqlTableUpdateStatusRepository().updateStatus('user');
        checkLastSyncStatus();
      }
    } catch (e) {
      rethrow;
    } finally {
      handleLoader(isLoading);
    }
  }

  Future<void> syncDivision({required SyncActions isLoading}) async {
    try {
      handleLoader(isLoading);
      List<DivisionModel> divisions = await DivisionRepository().getAll();
      if (divisions.isNotEmpty) {
        await SqlDivisionRepository().clearRecords();
        await SqlDivisionRepository().bulkInsert(divisions);
        await SqlTableUpdateStatusRepository().updateStatus('divisions');
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
          await SqlTableUpdateStatusRepository().updateStatus('user_divisions');
        }
        checkLastSyncStatus();
      }
    } catch (e) {
      rethrow;
    } finally {
      handleLoader(isLoading);
    }
  }

  Future<void> syncTag({required SyncActions isLoading}) async {
    try {
      handleLoader(isLoading);
      List<TagModel> tags = await TagRepository().getAll();
      if (tags.isNotEmpty) {
        await SqlTagsRepository().clearRecords();
        await SqlTagsRepository().bulkInsert(tags);
        await SqlTableUpdateStatusRepository().updateStatus('tags');
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
        checkLastSyncStatus();
      }
    } catch (e) {
      rethrow;
    } finally {
      handleLoader(isLoading);
    }
  }

  Future<void> syncReferralSource({required SyncActions isLoading}) async {
    try {
      handleLoader(isLoading);
      List<ReferralSourcesModel> referrals = await ReferralRepository().getAll();
      if (referrals.isNotEmpty) {
        await SqlReferralSourcesRepository().clearRecords();
        await SqlReferralSourcesRepository().bulkInsert(referrals);
        await SqlTableUpdateStatusRepository().updateStatus('referral_sources');
        checkLastSyncStatus();
      }
    } catch (e) {
      rethrow;
    } finally {
      handleLoader(isLoading);
    }
  }

  Future<void> syncTradeType({required SyncActions isLoading}) async {
    try {
      handleLoader(isLoading);
      List<TradeTypeModel> trades = await TradeRepository().getAll();
      if (trades.isNotEmpty) {
        await SqlTradeTypeRepository().clearRecords();
        await SqlTradeTypeRepository().bulkInsert(trades);
        await SqlTableUpdateStatusRepository().updateStatus('trade_type');
        List<WorkTypeModel> workTypeList = [];
        for (var element in trades) {
          if (element.workType != null && element.workType!.isNotEmpty) {
            workTypeList.addAll(element.workType!.toList());
          }
        }
        if (workTypeList.isNotEmpty) {
          await SqlWorkTypeRepository().clearRecords();
          await SqlWorkTypeRepository().bulkInsert(workTypeList);
          await SqlTableUpdateStatusRepository().updateStatus('work_type');
        }
        checkLastSyncStatus();
      }
    } catch (e) {
      rethrow;
    } finally {
      handleLoader(isLoading);
    }
  }

  Future<void> syncCompany({required SyncActions isLoading}) async {
    try {
      handleLoader(isLoading);
      List<CompanyModel> companies = await CompanyRepository().getCompanyList();
      if (companies.isNotEmpty) {
        await SqlCompanyRepository().clearRecords();
        await SqlCompanyRepository().bulkInsert(companies);
        await SqlTableUpdateStatusRepository().updateStatus('company');
        checkLastSyncStatus();
      }
    } catch (e) {
      rethrow;
    } finally {
      handleLoader(isLoading);
    }
  }

  Future<void> syncCountry({required SyncActions isLoading}) async {
    try {
      handleLoader(isLoading);
      List<CountryModel> countries = await CountryRepository().getCountryList();
      if (countries.isNotEmpty) {
        await SqlCountryRepository().clearRecords();
        await SqlCountryRepository().bulkInsert(countries);
        await SqlTableUpdateStatusRepository().updateStatus('country');
        checkLastSyncStatus();
      }
    } catch (e) {
      rethrow;
    } finally {
      handleLoader(isLoading);
    }
  }

  Future<void> syncState({required SyncActions isLoading}) async {
    try {
      handleLoader(isLoading);
      List<StateModel> states = await StateRepository().getStateList();
      if (states.isNotEmpty) {
        await SqlStateRepository().clearRecords();
        await SqlStateRepository().bulkInsert(states);
        await SqlTableUpdateStatusRepository().updateStatus('state');
        checkLastSyncStatus();
      }
    } catch (e) {
      rethrow;
    } finally {
      handleLoader(isLoading);
    }
  }

  Future<void> syncFlags({required SyncActions isLoading}) async {
    try {
      Map<String, dynamic> params = {
        'includes[0]': 'color',
        'limit': 0
      };
      handleLoader(isLoading);
      List<FlagModel> flags = await FlagsRepository().getFlagList(params);
      if (flags.isNotEmpty) {
        await SqlFlagRepository().clearRecords();
        await SqlFlagRepository().bulkInsert(flags);
        await SqlTableUpdateStatusRepository().updateStatus('flags');
        checkLastSyncStatus();
      }
    } catch (e) {
      rethrow;
    } finally {
      handleLoader(isLoading);
    }
  }

  Future<void> syncWorkflowStages({required SyncActions isLoading}) async {
    try {
      handleLoader(isLoading);
      List<WorkFlowStageModel> stages = await StageResourcesRepository
          .fetchStages();
      if (stages.isNotEmpty) {
        await SqlWorkFlowStagesRepository().clearRecords();
        await SqlWorkFlowStagesRepository().bulkInsert(stages);
        await SqlTableUpdateStatusRepository().updateStatus('workflow_stages');
        checkLastSyncStatus();
      }
    } catch (e) {
      rethrow;
    } finally {
      handleLoader(isLoading);
    }
  }

  Future<void> syncAll() async {
    syncUser(isLoading: SyncActions.syncUser);
    syncDivision(isLoading: SyncActions.syncDivision);
    syncTag(isLoading: SyncActions.syncTag);
    syncReferralSource(isLoading: SyncActions.syncReferralSource);
    syncTradeType(isLoading: SyncActions.syncTradeType);
    syncCompany(isLoading: SyncActions.syncCompany);
    syncCountry(isLoading: SyncActions.syncCountry);
    syncState(isLoading: SyncActions.syncState);
    syncFlags(isLoading: SyncActions.syncFlags);
    syncWorkflowStages(isLoading: SyncActions.syncWorkflowStages);
  }

  /////////////////////////   SQLite READ  ACTIONS   ///////////////////////////

  void getUsersWithTagsDivision({required LocalDBOtherActions isLoading}) async {
    try {
      UserParamModel requestParams = UserParamModel(
          withSubContractorPrime: true,
          limit: 0,
          includes: ['divisions']
      );
      handleLoader(isLoading);
      UserResponseModel userData = await SqlUserRepository().get(
          params: requestParams);

      if (userData.data.isNotEmpty) {
        for (var i = 0; i < userData.data.length; i++) {
          print(userData.data[i].toJson());
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      handleLoader(isLoading);
    }
  }

  void getDivisionsWithUsers({required LocalDBOtherActions isLoading}) async {
    try {
      DivisionParamModel requestParams = DivisionParamModel(
        includes: ['users'],
      );
      handleLoader(isLoading);
      DivisionResponseModel divisionData = await SqlDivisionRepository().get(
          params: requestParams);
      if (divisionData.data.isNotEmpty) {
        for (var i = 0; i < divisionData.data.length; i++) {
          print(divisionData.data[i].toJson());
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      handleLoader(isLoading);
    }
  }

  void getTagsWithUsers({required LocalDBOtherActions isLoading}) async {
    try {
      TagParamModel requestParams = TagParamModel(
        includes: ['users'],
      );
      handleLoader(isLoading);
      TagResponseModel tagsData = await SqlTagsRepository().get(
          params: requestParams);

      if (tagsData.data.isNotEmpty) {
        for (var i = 0; i < tagsData.data.length; i++) {
          print(tagsData.data[i].toJson());
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      handleLoader(isLoading);
    }
  }

  void getReferrals({required LocalDBOtherActions isLoading}) async {
    try {
      handleLoader(isLoading);
      ReferralSourceParamModel requestParams = ReferralSourceParamModel(
        withInactive: true,
      );

      ReferralSourceResponseModel referrals = await SqlReferralSourcesRepository()
          .get(params: requestParams);

      for (var i = 0; i < referrals.data.length; i++) {
        print(referrals.data[i].toJson());
      }
    } catch (e) {
      rethrow;
    } finally {
      handleLoader(isLoading);
    }
  }

  void getTrades({required LocalDBOtherActions isLoading}) async {
    try {
      TradeTypeParamModel requestParams = TradeTypeParamModel(
          withInactive: true,
          includes: ['work_type'],
          withInActiveWorkType: true
      );
      handleLoader(isLoading);
      TradeTypeResponseModel trades = await SqlTradeTypeRepository().get(
          params: requestParams);
      for (var i = 0; i < trades.data.length; i++) {
        print(trades.data[i].toJson());
      }
    } catch (e) {
      rethrow;
    } finally {
      handleLoader(isLoading);
    }
  }

  void getCompanies({required LocalDBOtherActions isLoading}) async {
    try {
      handleLoader(isLoading);
      print(await SqlCompanyRepository().getAll());
    } catch (e) {
      rethrow;
    } finally {
      handleLoader(isLoading);
    }
  }

  void getCountries({required LocalDBOtherActions isLoading}) async {
    try {
      handleLoader(isLoading);
      print(await SqlCountryRepository().get());
    } catch (e) {
      rethrow;
    } finally {
      handleLoader(isLoading);
    }
  }

  void getStates({required LocalDBOtherActions isLoading}) async {
    try {
      handleLoader(isLoading);
      print(await SqlStateRepository().get());
    } catch (e) {
      rethrow;
    } finally {
      handleLoader(isLoading);
    }
  }

  void getFlags({required LocalDBOtherActions isLoading}) async {
    try {
      handleLoader(isLoading);
      print(await SqlFlagRepository().get());
    } catch (e) {
      rethrow;
    } finally {
      handleLoader(isLoading);
    }
  }

  void getWorkflowStages({required LocalDBOtherActions isLoading}) async {
    try {
      handleLoader(isLoading);
      print(await SqlWorkFlowStagesRepository().get());
    } catch (e) {
      rethrow;
    } finally {
      handleLoader(isLoading);
    }
  }

  void get1UserRecord({required LocalDBOtherActions isLoading}) async {
    try {
      handleLoader(isLoading);
      print((await SqlUserRepository().getOne(330)).toJson());
    } catch (e) {
      rethrow;
    } finally {
      handleLoader(isLoading);
    }
  }

  void deleteDB({required LocalDBOtherActions isLoading}) async {
    try {
      handleLoader(isLoading);
      await DBProvider().deleteDatabase();
      clearLastSyncStatus();
    } catch (e) {
      rethrow;
    } finally {
      handleLoader(isLoading);
    }
  }

  void migrateOldDB({required LocalDBOtherActions isLoading}) async {
    try {
      handleLoader(isLoading);
      await SqlUnsavedResourcesRepository().migrateOldDB();
      await SqlFileUploaderRepository().migrateOldTable();
      clearLastSyncStatus();
    } catch (e) {
      rethrow;
    } finally {
      handleLoader(isLoading);
    }
  }

  //////////////////////////////////////////////////////////////////////////////

  void checkLastSyncStatus() async {
    List<TableUpdateStatusModel> updateStatus = await SqlTableUpdateStatusRepository().checkStatus();

    for (var item in updateStatus) {
      String formattedDate = DateTimeHelper.format(item.updatedAt, DateFormatConstants.dateTimeFormatWithoutSeconds);

      switch (item.tableName) {
        case 'user':
          userUpdatedAt = formattedDate;
          break;
        case 'tags':
          tagUpdatedAt = formattedDate;
          break;
        case 'divisions':
          divisionUpdatedAt = formattedDate;
          break;
        case 'referral_sources':
          referralUpdatedAt = formattedDate;
          break;
        case 'trade_type':
          tradeUpdatedAt = formattedDate;
          break;
        case 'company':
          companyUpdatedAt = formattedDate;
          break;
        case 'country':
          countryUpdatedAt = formattedDate;
          break;
        case 'state':
          stateUpdatedAt = formattedDate;
          break;
        case 'flags':
          flagUpdatedAt = formattedDate;
          break;
        case 'workflow_stages':
          workflowStagesUpdatedAt = formattedDate;
          break;
        case SqlFileUploaderRepository.tableName:
          fileUploadsUpdatedAt = formattedDate;
        default:
      }
    }
    update();
  }

  void clearLastSyncStatus() {
    userUpdatedAt = tagUpdatedAt = divisionUpdatedAt = referralUpdatedAt =
        tradeUpdatedAt = companyUpdatedAt = countryUpdatedAt = stateUpdatedAt =
        flagUpdatedAt = workflowStagesUpdatedAt = "";
    update();
  }

  void handleLoader(dynamic syncActions) {
    if(isLoading.contains(syncActions)){
      isLoading.remove(syncActions);
    } else {
      isLoading.add(syncActions);
    }
    update();
  }

}