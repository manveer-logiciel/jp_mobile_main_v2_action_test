// ignore_for_file: sdk_version_since

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:jobprogress/common/models/sql/division/division.dart';
import 'package:jobprogress/common/models/sql/division/division_param.dart';
import 'package:jobprogress/common/models/sql/division/division_response.dart';
import 'package:jobprogress/common/models/sql/flag/flag.dart';
import 'package:jobprogress/common/models/sql/referral_source/referral_source.dart';
import 'package:jobprogress/common/models/sql/referral_source/referral_source_param.dart';
import 'package:jobprogress/common/models/sql/referral_source/referral_source_response.dart';
import 'package:jobprogress/common/models/sql/tag/tag_param.dart';
import 'package:jobprogress/common/models/sql/trade_type/trade_type.dart';
import 'package:jobprogress/common/models/sql/trade_type/trade_type_param.dart';
import 'package:jobprogress/common/models/sql/trade_type/trade_type_response.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/sql/user/user_param.dart';
import 'package:jobprogress/common/models/sql/user/user_response.dart';
import 'package:jobprogress/common/models/sql/work_type/work_type.dart';
import 'package:jobprogress/common/repositories/sql/division.dart';
import 'package:jobprogress/common/repositories/sql/flags.dart';
import 'package:jobprogress/common/repositories/sql/referral_sources.dart';
import 'package:jobprogress/common/repositories/sql/tag.dart';
import 'package:jobprogress/common/repositories/sql/trade_type.dart';
import 'package:jobprogress/common/repositories/sql/user.dart';
import 'package:jobprogress/core/constants/user_roles.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/tag_modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../common/enums/unsaved_resource_type.dart';
import '../../../common/models/sql/country/country.dart';
import '../../../common/models/sql/state/state.dart';
import '../../../common/repositories/sql/country.dart';
import '../../../common/repositories/sql/state.dart';
import 'unsaved_resources_helper/unsaved_resources_helper.dart';

/// FormsDBHelper helps to read local db easily
class FormsDBHelper {
  static Future<List<JPMultiSelectModel>> getAllUsers(
      List<String> selectedIds, {
        bool onlySub = false,
        bool isSubTextVisible = true,
        bool withSubContractorPrime = true,
        bool withInactive = false,
        bool useCompanyName = false,
        List<int?>? divisionIds
      }) async {
    List<JPMultiSelectModel> users = []; // initializing list
    divisionIds?.removeWhere((id) => id == null);

    UserParamModel params = UserParamModel(
        includes: ['tags', 'divisions', "company"],
        limit: -1,
        onlySub: onlySub,
        withInactive: withInactive,
        divisionIds: divisionIds?.cast<int>() ?? [],
        withSubContractorPrime: withSubContractorPrime);

    UserResponseModel allUsers = await SqlUserRepository().get(params: params);
    for (UserModel user in allUsers.data) {

      String userName = user.groupId == UserGroupIdConstants.subContractorPrime ? user.fullName
          + (isSubTextVisible ? '(${'sub'.tr})' : '') : user.fullName;

      String label = useCompanyName
          ?(Helper.isValueNullOrEmpty(user.companyName) ? userName : userName + ' (' + user.companyName! + ')')
          : userName;

      List<TagLimitedModel> tag = [];
      if(user.tags != null){
        for(var e in user.tags! ){
          tag.add(TagLimitedModel(id: e.id,name: e.name));
        }
      }

      users.add(JPMultiSelectModel(
        id: user.id.toString(),
        label: label,
        isSelect: selectedIds.any((element) => element == user.id.toString()),
        child: JPProfileImage(
          size: JPAvatarSize.small,
          src: user.profilePic,
          color: user.color,
          initial: user.intial,
        ),
        additionData: user,
        tags: tag,
      ));
      tag=[];
    }

    return users;
  }

  static Future<List<JPSingleSelectModel>> getAllCountries({
    bool labelSameAsCode = false
  }) async {
    List<JPSingleSelectModel> countriesList = []; // initializing list
    ///   Fetch Countries
    List<CountryModel?> allCountries = await SqlCountryRepository().get(); 

    for (CountryModel? country in allCountries) {
      if(country == null) continue;

      final label = labelSameAsCode ? country.code : country.name;

      dynamic tempCountry = JPSingleSelectModel(
        label: label,
        id: country.id.toString(),
      );
      countriesList.add(tempCountry);
    }
    return countriesList;
  }

  static Future<List<JPSingleSelectModel>> getAllStates({
    int? countryId,
    bool labelSameAsCode = false,
    bool applyCompanyFilter = true,
  }) async {

    List<JPSingleSelectModel> statesList = []; // initializing list
    ///   Fetch State
    List<StateModel?> allStates = await SqlStateRepository().get(countryId: countryId, applyCompanyFilter: applyCompanyFilter);
    for (StateModel? state in allStates) {
      if(state == null) continue;

      final label = labelSameAsCode ? state.code : state.name;
      dynamic tempState = JPSingleSelectModel(
          label: label,
          id: state.id.toString(),
          additionalData: state
      );
      statesList.add(tempState);
    }
    return statesList;
  }

  static Future<List<JPSingleSelectModel>> getUsersToSingleSelect(
      List<String> selectedIds, {
        bool onlySub = false,
        bool withSubContractorPrime = false,
        bool includeOtherOption = false,
        List<int?>? divisionIds
      }) async {
    List<JPSingleSelectModel> users = []; // initializing list
    divisionIds?.removeWhere((id) => id == null);

    UserParamModel params = UserParamModel(
        includes: ['tags', 'divisions'],
        limit: 0,
        onlySub: onlySub,
        divisionIds: divisionIds?.cast<int>() ?? [],
        withSubContractorPrime: withSubContractorPrime
    );

    UserResponseModel allUsers = await SqlUserRepository().get(params: params);
    if(includeOtherOption) allUsers.data.insert(0, UserModel.otherOption);
    allUsers.data.insert(0, UserModel.unAssignedUser);
    for (UserModel user in allUsers.data) {
      String userName = user.groupId == UserGroupIdConstants.subContractorPrime ? '${user.fullName} (${'sub'.tr})' : user.fullName;
      users.add(JPSingleSelectModel(
          label: userName,
          id: user.id.toString(),
          child: JPProfileImage(
            size: JPAvatarSize.small,
            src: user.profilePic,
            color: user.color,
            initial: user.intial,
          )));
    }

    return users;
  }

  static Future<List<JPMultiSelectModel>> getAllTags() async {
    List<JPMultiSelectModel> tagsList = []; // initializing list

    TagParamModel tagsParams = TagParamModel(
      includes: ['users'],
    );

    SqlTagsRepository().get(params: tagsParams).then((tags) {
      for (var element in tags.data) {
        tagsList.add(JPMultiSelectModel(
          id: element.id.toString(),
          label: element.name,
          isSelect: false,
          subListLength: element.users?.length,
        ));
      }
    });

    return tagsList;
  }

  static Future<List<JPSingleSelectModel>> getReferrals({
    ReferralSourceParamModel? referralParams,
    bool includeOtherOption = false,
    bool includeCustomerOption = false,
    bool includeNoneOption = false
  }) async {
    List<JPSingleSelectModel> referralsList = []; // initializing list
    ///   Fetch referrals
    ReferralSourceResponseModel referrals = await SqlReferralSourcesRepository().get(params: referralParams);

    if(includeCustomerOption) referrals.data.insert(0, ReferralSourcesModel.customer);
    if(includeOtherOption) referrals.data.insert(0, ReferralSourcesModel.otherOption);
    if(includeNoneOption) referrals.data.insert(0, ReferralSourcesModel.noneOption);

    for (ReferralSourcesModel? referral in referrals.data) {

      if(referral == null) continue;

      dynamic tempState = JPSingleSelectModel(
        label: referral.name,
        id: referral.id.toString(),
      );
      referralsList.add(tempState);
    }
    return referralsList;
  }

  static Future<List<JPMultiSelectModel>> getAllFlags(List<String> selectedIds, {
    bool forJob = false
  }) async {
    List<JPMultiSelectModel> flags = [];

    List<FlagModel?> tempFlags = await SqlFlagRepository().get(
        type: forJob ? 'job' : 'customer'
    );

    if (forJob) {
      tempFlags.insertAll(0, <FlagModel>[
        FlagModel.callRequiredFlag,
        FlagModel.appointmentRequiredFlag,
      ]);
    }

    for (FlagModel? flag in tempFlags) {
      if(flag != null) {
        flags.add(
          JPMultiSelectModel(
              label: flag.title,
              id: flag.id.toString(),
              isSelect: selectedIds.any((element) => element == flag.id.toString()),
              color: Helper.evaluateFlagBackgroundColor(flag),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: JPAvatar(
                  size: JPAvatarSize.small,
                  backgroundColor: Helper.evaluateFlagBackgroundColor(flag),
                  child: JPIcon(Icons.flag, color: JPAppTheme.themeColors.base, size: 12,),
                ),
              )
          ),
        );
      }
    }

    return flags;
  }


  static Future<List<JPSingleSelectModel>> getAllDivisions({
    bool forUser = true,
    bool includeNone = false,
  }) async {

    List<JPSingleSelectModel> divisionsList = []; // initializing list

    DivisionParamModel params = DivisionParamModel(
        includes: [
          if(forUser) 'users',
          if(!forUser) 'job',
        ],
        limit: -1
    );

    DivisionResponseModel divisions = await SqlDivisionRepository().get(params: params);

    if (includeNone) {
      divisions.data.insert(0, DivisionModel.none);
    }

    for (DivisionModel division in divisions.data) {

      divisionsList.add(JPSingleSelectModel(
          label: division.name,
          id: division.id.toString(),
          additionalData: division.code ?? ""
      )
      );
    }

    return divisionsList;
  }

  static Future<List<JPSingleSelectModel>> getAllTrades({
    bool includeNone = false,
  }) async {

    List<JPSingleSelectModel> tradesList = [];

    TradeTypeParamModel params = TradeTypeParamModel(
        withInactive: true,
        includes: ['work_type'],
        withInActiveWorkType: true,
        limit: -1
    );

    TradeTypeResponseModel trades = await SqlTradeTypeRepository().get(params: params);

    if (includeNone) {
      trades.data.insert(0, TradeTypeModel.none);
    }

    for (TradeTypeModel trade in trades.data) {

      List<JPMultiSelectModel> workTypes = [];

      for (WorkTypeModel workType in (trade.workType ?? [])) {
        workTypes.add(JPMultiSelectModel(
          label: workType.name,
          id: workType.id.toString(),
          isSelect: false,
        ),
        );
      }

      tradesList.add(JPSingleSelectModel(
          label: trade.name,
          id: trade.id.toString(),
          additionalData: workTypes
      )
      );
    }

    return tradesList;

  }

  static Future<Map<String, dynamic>?> getUnsavedResources(int? unsavedResourceId) async =>
    await UnsavedResourcesHelper.getUnsavedResource(unsavedResourceId);

  static Future<List<T>> getMultipleTypesOfUnsavedResources<T>({required List<UnsavedResourceType> types, required int jobId}) async {
    List<T> unsavedResourceList = [];
    for (var type in types) {
      unsavedResourceList.addAll((await UnsavedResourcesHelper.getAllUnsavedResources(type: type, jobId: jobId)) as List<T>);
    }
    return unsavedResourceList;
  }


  static Future<Object?> getAllUnsavedResources({required UnsavedResourceType type, required int jobId}) async =>
    await UnsavedResourcesHelper.getAllUnsavedResources(type: type, jobId: jobId);

  static Map<String, dynamic> getUnsavedResourcesJsonData(Map<String, dynamic>? unsavedResourceJson) =>
      json.decode(json.decode(json.encode(unsavedResourceJson))["data"]);

  static Map<String, dynamic> getOldAppUnsavedResourcesJsonData(Map<String, dynamic>? unsavedResourceJson) =>
      UnsavedResourcesHelper.getOldAppUnsavedResourcesDataModel(getUnsavedResourcesJsonData(unsavedResourceJson), unsavedResourceJson);

}
