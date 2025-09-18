import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/job/job_type.dart';
import 'package:jobprogress/common/models/sql/division/division.dart';
import 'package:jobprogress/common/models/sql/division/division_param.dart';
import 'package:jobprogress/common/models/sql/division/division_response.dart';
import 'package:jobprogress/common/models/sql/flag/flag.dart';
import 'package:jobprogress/common/models/sql/tag/tag_param.dart';
import 'package:jobprogress/common/models/sql/trade_type/trade_type.dart';
import 'package:jobprogress/common/models/sql/trade_type/trade_type_param.dart';
import 'package:jobprogress/common/models/sql/trade_type/trade_type_response.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/sql/user/user_param.dart';
import 'package:jobprogress/common/models/sql/user/user_response.dart';
import 'package:jobprogress/common/models/sql/work_type/work_type.dart';
import 'package:jobprogress/common/repositories/job_type.dart';
import 'package:jobprogress/common/repositories/sql/division.dart';
import 'package:jobprogress/common/repositories/sql/flags.dart';
import 'package:jobprogress/common/repositories/sql/tag.dart';
import 'package:jobprogress/common/repositories/sql/trade_type.dart';
import 'package:jobprogress/common/repositories/sql/user.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/tag_modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CalendarsDbReader {

  static Future<List<JPMultiSelectModel>> getAllTrades(List<String> selectedIds, {required List<String> selectedWorkTypeIds}) async {
    List<JPMultiSelectModel> tradeTypes = [];

    TradeTypeParamModel params = TradeTypeParamModel(
        withInactive: true,
        includes: ['work_type'],
        withInActiveWorkType: true,
        limit: -1
    );

    TradeTypeResponseModel trades = await SqlTradeTypeRepository().get(params: params);
    for (TradeTypeModel trade in trades.data) {

      List<JPMultiSelectModel> subList = [];

      for(WorkTypeModel workType in trade.workType ?? []) {
        subList.add(
            JPMultiSelectModel(
                label: workType.name,
                id: workType.id.toString(),
                isSelect: selectedWorkTypeIds.any((element) => element == workType.id.toString()),
            )
        );
      }

      tradeTypes.add(
        JPMultiSelectModel(
          label: trade.name,
          id: trade.id.toString(),
          subList: subList,
          isSelect: selectedIds.any((element) => element == trade.id.toString()),
        ),
      );
    }

    return tradeTypes;
  }

      // getAllTags() will load all trades from sql and parse it to multiselect
  static Future<List<JPMultiSelectModel>> getAllTags() async {
    List<JPMultiSelectModel> tagsList = []; // initializing list

    TagParamModel tagsParams = TagParamModel(
      includes: ['users'],
    );

    SqlTagsRepository().get(params:tagsParams ).then((tags) {
        for (var element in tags.data) {
              tagsList.add(JPMultiSelectModel(
              id: element.id.toString(), label: element.name, isSelect: false,subListLength: element.users?.length, ));
        }
      });

    return tagsList;
  }

  static Future<List<JPMultiSelectModel>> getAllUsers(List<String> selectedIds, {
    bool onlySub = false,
    bool withSubContractorPrime = false,
    bool includeUnAssigned = false,
    bool canSelectOtherUsers = true,
    bool useCompanyName = false,
  }) async {

    List<JPMultiSelectModel> users = []; // initializing list

    if(!canSelectOtherUsers) {

      final user = AuthService.userDetails!;

        List<TagLimitedModel> tag = [];
            if(user.tags != null){
              for(var e in user.tags! ){
                tag.add(TagLimitedModel(id: e.id,name: e.name));
              }
            }
          users.add(JPMultiSelectModel(
            id: user.id.toString(),
            label: user.fullName,
            isSelect: true,
            child: JPProfileImage(
              size: JPAvatarSize.small,
              src: user.profilePic,
              color: user.color,
              initial: user.intial,
            ),
            tags: tag,
          ));
          tag=[];

      return users;
    }

    UserParamModel params = UserParamModel(
        includes: ['tags', 'divisions'],
        limit: -1,
        onlySub: onlySub,
        withSubContractorPrime: withSubContractorPrime
    );

    UserResponseModel allUsers = await SqlUserRepository().get(params: params);

    if(includeUnAssigned) {
      allUsers.data.insert(0, UserModel.unAssignedUser);
    }

    for (UserModel user in allUsers.data) {

      String label = useCompanyName
          ?(Helper.isValueNullOrEmpty(user.companyName) ? user.fullName : user.fullName + '(' + user.companyName! + ')')
          : user.fullName;

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
            tags: tag,
          ));
          tag=[];
    }

    return users;
  }

  static Future<List<JPMultiSelectModel>> getAllDivisions(List<String> selectedIds) async {
    List<JPMultiSelectModel> divisions = [];
    DivisionParamModel params = DivisionParamModel(
        includes: ['users'],
        limit: -1
    );

    DivisionResponseModel divisionData = await SqlDivisionRepository().get(params: params);
    for (DivisionModel division in divisionData.data) {
      divisions.add(
        JPMultiSelectModel(
          label: division.name,
          id: division.id.toString(),
          isSelect: selectedIds.any((element) => element == division.id.toString()),
        ),
      );
    }

    return divisions;
  }

  static Future<List<JPMultiSelectModel>> getAllFlags(List<String> selectedIds) async {
    List<JPMultiSelectModel> flags = [];

    List<FlagModel?> tempFlags = await SqlFlagRepository().get(type: 'job');
    for (FlagModel? flag in tempFlags) {
      if(flag != null) {
        flags.add(
          JPMultiSelectModel(
            label: flag.title,
            id: flag.id.toString(),
            isSelect: selectedIds.any((element) => element == flag.id.toString()),
            color: Helper.evaluateFlagBackgroundColor(flag),
            child: JPAvatar(
                size: JPAvatarSize.small,
                backgroundColor: flag.actualColor,
                child: JPIcon(Icons.flag, color: JPAppTheme.themeColors.base, size: 18,),
              )
          ),
        );
      }
    }

    return flags;
  }
  
  static Future<List<JPMultiSelectModel>> getAllCities(List<String> selectedIds) async {
    List<JPMultiSelectModel> cities = [];

    for (var city in selectedIds) {
      cities.add(
          JPMultiSelectModel(
            label: city,
            id: city,
            isSelect: true,
          )
      );
    }

    return cities;
  }

  static Future<List<JPMultiSelectModel>> getCategories(List<String> selectedIds) async {
    List<JPMultiSelectModel> categories = [];

    Map<String, dynamic> params = {};

    final response = await JobTypeRepository.fetchCategories(params);

    List<JobTypeModel> tempCategories = response['list'];
    for (JobTypeModel category in tempCategories) {
        categories.add(
          JPMultiSelectModel(
            label: category.name ?? '',
            id: category.id.toString(),
            isSelect: selectedIds.any((element) => element == category.id.toString()),
          ),
        );
    }

    return categories;
  }

}