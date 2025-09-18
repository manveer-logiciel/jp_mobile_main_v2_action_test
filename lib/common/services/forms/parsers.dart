
import 'package:jobprogress/core/constants/user_type_list.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';

import '../../../global_widgets/profile_image_widget/index.dart';
import '../../models/sql/user/user_limited.dart';

class FormValueParser {

  static List<int>? multiSelectToSelectedIds(List<JPMultiSelectModel> list) {

    if(list.isEmpty) {
      return null;
    }

    final selectedValues = list.where((element) => element.isSelect);

    return selectedValues.map((value) => int.tryParse(value.id) ?? 0).where((id) => id >= 0).toList();
  }

  static List<String>? multiSelectToUserTypeIds(List<JPMultiSelectModel> list) {
    if(Helper.isValueNullOrEmpty(list)) {
      return null;
    }
    final selectedValues = list.where((element) => element.isSelect);

    List<String>? userIds = selectedValues.map((e) => e.id).toList();
    List<int>? userTypeIds = 
      userIds.where(
        (userId) => int.tryParse(userId) != null && int.parse(userId) < 0
      ).map((str) => int.parse(str)).toList();
    
    return userTypeIds.map((userTypeId) {
      switch (userTypeId) {
        case -1:
          return UserTypeConstants.customerRep;
        case -2:
          return UserTypeConstants.estimator;
        case -3:
          return UserTypeConstants.companyCrew;
        case -4:
          return UserTypeConstants.subs;
        default:
          return '';
      }
    }).toList();
  }

  static List<String>? multiSelectToSelectedLabels(List<JPMultiSelectModel> list) {

    if(list.isEmpty) {
      return null;
    }

    final selectedValues = list.where((element) => element.isSelect);

    return selectedValues.map((e) => e.label).toList();

  }

  static List<UserLimitedModel> jpMultiSelectToUserModel(List<JPMultiSelectModel> multiSelectList) {
    List<UserLimitedModel> userList = [];
    for (var element in multiSelectList) {
      if(element.isSelect) {
        var profile = element.child as JPProfileImage;
        userList.add(UserLimitedModel(
            id: int.parse(element.id),
            firstName: '',
            fullName: element.label,
            email: '',
            groupId: -1,
            profilePic: profile.src,
            color: profile.color,
            intial: profile.initial
        ));
      }
    }
    return userList;
  }

}