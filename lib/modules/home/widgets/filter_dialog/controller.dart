import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/sql/tag/tag_param.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/repositories/sql/tag.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/tag_modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../common/enums/date_picker_type.dart';
import '../../../../common/enums/filter_dialog_text_type.dart';
import '../../../../common/models/home/filter_model.dart';
import '../../../../common/models/sql/division/division.dart';
import '../../../../common/models/sql/division/division_param.dart';
import '../../../../common/models/sql/trade_type/trade_type_param.dart';
import '../../../../common/models/sql/user/user_param.dart';
import '../../../../common/repositories/sql/division.dart';
import '../../../../common/repositories/sql/trade_type.dart';
import '../../../../common/repositories/sql/user.dart';
import '../../../../common/services/auth.dart';
import '../../../../common/services/permission.dart';
import '../../../../core/constants/date_formats.dart';
import '../../../../core/constants/dropdown_list_constants.dart';
import '../../../../core/constants/permission.dart';
import '../../../../core/utils/date_time_helpers.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/multi_select_helper.dart';
import '../../../../core/utils/single_select_helper.dart';
import '../../../../global_widgets/profile_image_widget/index.dart';

class HomeFilterDialogController extends GetxController {

  late HomeFilterModel filterKeys;
  late HomeFilterModel defaultFilters;

  late String selectedDateType;
  late String selectedDuration;

  bool isCheckBoxSelected = false;
  bool isResetButtonDisable = true;

  List<JPMultiSelectModel> divisionList = [];
  List<JPMultiSelectModel> userList = [];
  List<JPMultiSelectModel> groupList = [];
  List<JPMultiSelectModel> tradeList = [];

  TextEditingController divisionsTextController = TextEditingController();
  TextEditingController usersTextController = TextEditingController();
  TextEditingController tradeTextController = TextEditingController();
  TextEditingController dateTypeTextController = TextEditingController();
  TextEditingController durationTextController = TextEditingController();

  HomeFilterDialogController(HomeFilterModel selectedFilters, this.defaultFilters) {
    setDefaultKeys(selectedFilters);
  }

  void setDefaultKeys(HomeFilterModel params) {

    filterKeys = HomeFilterModel.copy(params);

    ///   Divisions
    DivisionParamModel divisionParams = DivisionParamModel(includes: ['users'], limit: -1);
    SqlDivisionRepository().get(params: divisionParams).then((divisionList) {
      divisionsTextController.text = "";
      divisionList.data.insert(0, DivisionModel(id: 0, name: "unassigned".tr, companyId: 0));
      if(filterKeys.divisionIds?.isNotEmpty ?? false) {
        for(int i = 0; i < divisionList.data.length; i++) {
          this.divisionList.add(JPMultiSelectModel(
              id: divisionList.data[i].id.toString(), label: divisionList.data[i].name,
              isSelect: false));
          for (int j = 0; j < filterKeys.divisionIds!.length; j++) {
            if(divisionList.data[i].id == filterKeys.divisionIds![j]) {
              this.divisionList[i].isSelect = true;
              divisionsTextController.text = divisionsTextController.text + (divisionsTextController.text.isEmpty ? "" : ", ") + divisionList.data[i].name;
              break;
            }
          }
        }
      } else {
        for (var element in divisionList.data) {
          this.divisionList.add(JPMultiSelectModel(
              id: element.id.toString(), label: element.name, isSelect: false));
        }
      }
    });

    /// Fetch Tags
    TagParamModel tagsParams = TagParamModel(
      includes: ['users'],
    );

    SqlTagsRepository().get(params:tagsParams).then((tags) {
        List<JPMultiSelectModel> tempGroupList = [];
        for (var element in tags.data) {
          tempGroupList.add(JPMultiSelectModel(
            id: element.id.toString(), label: element.name, isSelect: false));
        }
        groupList = tempGroupList;
    });

    ///    Fetch  User
    UserParamModel requestParams = UserParamModel(
      withSubContractorPrime: false,
      limit: 0,
      includes: ['tags'],
      withInactive: true
    );

    UserModel? userModel = AuthService.getUserDetails();

    if((AuthService.isStandardUser() && AuthService.isRestricted) || (userModel?.isRestricted ?? false)) {
      usersTextController.text = AuthService.getUserDetails()!.fullName;
    } else {
          SqlUserRepository().get(params: requestParams).then((userData) {
      usersTextController.text = "";
      List<TagLimitedModel> tag = [];
      if(filterKeys.users?.isNotEmpty ?? false) {
        for(int i = 0; i < userData.data.length; i++) {
          if(userData.data[i].tags != null){
            for(int j = 0;j < userData.data[i].tags!.length; j++){
              tag.add(TagLimitedModel(id:userData.data[i].tags![j].id ,name: userData.data[i].tags![j].name));
            }
          }
          userList.add(JPMultiSelectModel(
            id: userData.data[i].id.toString(), 
            label: userData.data[i].fullName,
            tags: tag,
            active: userData.data[i].active,
            isSelect: false,child:JPProfileImage(
              src: userData.data[i].profilePic,
              color: userData.data[i].color,
              initial: userData.data[i].intial,
            ),
          ));

          for (int j = 0; j < filterKeys.users!.length; j++) {
            if(userData.data[i].id == filterKeys.users![j]) {
              userList[i].isSelect = true;
              usersTextController.text = usersTextController.text + (usersTextController.text.isEmpty ? "" : ", ") + userData.data[i].fullName;
              break;
            }
          }
          tag=[];
        }
      } else {
        for (var element in userData.data) {
            List<TagLimitedModel> tag = [];
            if(element.tags != null){
              for(var e in element.tags! ){
                tag.add(TagLimitedModel(id: e.id,name: e.name));
              }
            }
          userList.add(JPMultiSelectModel(
            id: element.id.toString(),
            label: element.fullName,
            isSelect: false,
            active: element.active,
            child: JPProfileImage(
              src: element.profilePic,
              color: element.color,
              initial: element.intial,
            ),
            tags: tag,
          ));
          tag=[];
      }
    }});
    }

    ///   Trade
    TradeTypeParamModel tradeParams = TradeTypeParamModel(withInactive: true, includes: ['work_type'], withInActiveWorkType: true, limit: -1);
    SqlTradeTypeRepository().get(params: tradeParams).then((trades) {
      tradeTextController.text = "";
      if(filterKeys.trades?.isNotEmpty ?? false) {
        for(int i = 0; i < trades.data.length; i++) {
          tradeList.add(JPMultiSelectModel(
              id: trades.data[i].id.toString(), label: trades.data[i].name,
              isSelect: false));
          for (int j = 0; j < filterKeys.trades!.length; j++) {
            if(trades.data[i].id == filterKeys.trades![j]) {
              tradeList[i].isSelect = true;
              tradeTextController.text = tradeTextController.text + (tradeTextController.text.isEmpty ? "" : ", ") + trades.data[i].name;
              break;
            }
          }
        }
      } else {
        for (var element in trades.data) {
          tradeList.add(JPMultiSelectModel(
              id: element.id.toString(), label: element.name, isSelect: false));
        }
      }
    });

    selectedDateType = filterKeys.dateRangeType ?? "";
    selectedDuration = filterKeys.duration ?? "";
    dateTypeTextController.text = DropdownListConstants().homeFilterDataRangeTypeList.firstWhereOrNull((element) => element.id == selectedDateType)?.label ?? "";
    durationTextController.text = DropdownListConstants.durationsList.firstWhereOrNull((element) => element.id == selectedDuration)?.label ?? "";
    isCheckBoxSelected = filterKeys.insuranceJobsOnly;

    updateResetButtonDisable();
  }

  void openMultiSelect(FilterDialogTextType type) {
    bool showInactiveUser = FeatureFlagService.hasFeatureAllowed([
      FeatureFlagConstant.userManagement]) && 
      type == FilterDialogTextType.users;
    late String title;
    late List<JPMultiSelectModel> mainList;

    switch (type) {
      case FilterDialogTextType.divisions:
        title = "select_divisions".tr.toUpperCase();
        mainList = divisionList;
        break;
      case FilterDialogTextType.users:
        title = "select_users".tr.toUpperCase();
        mainList = userList;
        break;
      case FilterDialogTextType.trades:
        title = "select_trades".tr.toUpperCase();
        mainList = tradeList;
        break;
      default:
        break;
    }

    MultiSelectHelper.openMultiSelect(
        title: title,
        mainList: mainList,
        showIncludeInactiveButton: showInactiveUser,
        subList: (type == FilterDialogTextType.users) ? groupList : [],
        isGroupsHeader: groupList.isNotEmpty ? (type == FilterDialogTextType.users) : false,
        callback: (List<JPMultiSelectModel> selectedTrades) {
          switch (type) {
            case FilterDialogTextType.divisions:
              updateDivisions(selectedTrades);
              break;
            case FilterDialogTextType.users:
              updateUsers(selectedTrades);
              break;
            case FilterDialogTextType.trades:
              updateTrades(selectedTrades);
              break;
            default:
              break;
          }
          Get.back();
          updateResetButtonDisable();
        });
  }

  void openSingleSelect(FilterDialogTextType type) {
    late String title;
    late List<JPSingleSelectModel> mainList;
    late String selectedValue;

    switch (type) {
      case FilterDialogTextType.dateType:
        title = "select_date_type".tr.toUpperCase();
        mainList = DropdownListConstants().homeFilterDataRangeTypeList;

        if(AuthService.isPrimeSubUser()
            || PermissionService.hasUserPermissions([PermissionConstants.manageFinancial, PermissionConstants.viewFinancial], isAllRequired: true)
        )  {
          Helper.removeMultipleKeysFromArray(mainList, ['job_invoiced_date']);
        }

        selectedValue = selectedDateType;
        break;
      case FilterDialogTextType.duration:
        title = 'select_duration'.tr.toUpperCase();
        mainList = DropdownListConstants.durationsList;
        selectedValue = selectedDuration;
        break;
      default:
        break;
    }

    SingleSelectHelper.openSingleSelect(
      mainList,
      selectedValue,
      title,
      (value) {
        switch (type) {
          case FilterDialogTextType.dateType:
            updateDateType(value);
            break;
          case FilterDialogTextType.duration:
            updateDuration(value);
            break;
          default:
            break;
        }
        Get.back();
        updateResetButtonDisable();
      },
      isFilterSheet: true);
  }

  void openDatePicker ({String? initialDate, required DatePickerType datePickerType}) {
    DateTimeHelper.openDatePicker(
        initialDate: initialDate,
        helpText: datePickerType == DatePickerType.start ? "start_date".tr : "end_date".tr).then((dateTime) {
      if(dateTime != null) {
        switch (datePickerType) {
          case DatePickerType.start:
            filterKeys.startDate = DateTimeHelper.format(dateTime.toString(), DateFormatConstants.dateServerFormat);
            break;
          case DatePickerType.end:
            filterKeys.endDate = DateTimeHelper.format(dateTime.toString(), DateFormatConstants.dateServerFormat);
            break;
        }
        update();
      }
    });
  }

  void updateDivisions(List<JPMultiSelectModel> selectedTrades) {
    divisionsTextController.text = "";
    filterKeys.divisionIds = [];
    divisionList = selectedTrades;
    for (var element in selectedTrades) {
      if(element.isSelect){
        filterKeys.divisionIds!.add(int.parse(element.id));
        divisionsTextController.text = divisionsTextController.text + (divisionsTextController.text.isEmpty ? "" : ", ") + element.label;
      }
    }
  }

  void updateUsers(List<JPMultiSelectModel> selectedTrades) {
    usersTextController.text = "";
    filterKeys.users = [];
    userList = selectedTrades;
    for (var element in selectedTrades) {
      if(element.isSelect){
        filterKeys.users!.add(int.parse(element.id));
        usersTextController.text = usersTextController.text + (usersTextController.text.isEmpty ? "" : ", ") + element.label;
      }
    }
  }

  void updateTrades(List<JPMultiSelectModel> selectedTrades) {
    tradeTextController.text = "";
    filterKeys.trades = [];
    tradeList = selectedTrades;
    for (var element in selectedTrades) {
      if(element.isSelect){
        filterKeys.trades!.add(int.parse(element.id));
        tradeTextController.text = tradeTextController.text + (tradeTextController.text.isEmpty ? "" : ", ") + element.label;
      }
    }
  }

  void updateDateType(String value) {
    selectedDateType = value;
    filterKeys.dateRangeType = selectedDateType;
    dateTypeTextController.text = DropdownListConstants().homeFilterDataRangeTypeList.firstWhere((element) => element.id == value).label;
  }

  void updateDuration(String value) {
    selectedDuration = value;
    filterKeys.duration = value;
    durationTextController.text = DropdownListConstants.durationsList.firstWhere((element) => element.id == value).label;
  }

  void selectCheckBox() {
    isCheckBoxSelected = !isCheckBoxSelected;
    filterKeys.insuranceJobsOnly = isCheckBoxSelected;
    updateResetButtonDisable();
  }

  void updateResetButtonDisable() {
    isResetButtonDisable = filterKeys == defaultFilters;
    update();
  }

  void cleanFilterKeys({HomeFilterModel? defaultFilters}) {
    divisionsTextController.text = '';
    usersTextController.text = '';
    tradeTextController.text = '';

    dateTypeTextController.text = DropdownListConstants().homeFilterDataRangeTypeList.firstWhereOrNull((element) => element.id == filterKeys.dateRangeType)?.label ?? "";
    durationTextController.text = DropdownListConstants.durationsList.firstWhereOrNull((element) => element.id == filterKeys.duration)?.label ?? "";

    isCheckBoxSelected = filterKeys.insuranceJobsOnly;
    selectedDateType = filterKeys.dateRangeType ?? "";
    selectedDuration = filterKeys.duration ?? "";

    filterKeys.divisionIds = filterKeys.users = filterKeys.trades = [];

    divisionList.clear();
    userList.clear();
    tradeList.clear();

    setDefaultKeys(defaultFilters!);
  }

  applyFilter(void Function(HomeFilterModel params) onApply) {

    if(filterKeys.duration == "custom") {
      if (DateTimeHelper.validateDates(start: filterKeys.startDate, end: filterKeys.endDate)) {
        onApply(filterKeys);
        Get.back();
      }
    } else {
      filterKeys.startDate = filterKeys.endDate = null;
      onApply(filterKeys);
      Get.back();
    }
  }

  @override
  void onClose() {
    divisionsTextController.dispose();
    usersTextController.dispose();
    tradeTextController.dispose();
    dateTypeTextController.dispose();
    durationTextController.dispose();
    super.onClose();
  }

  String getStartDate() => filterKeys.startDate?.isEmpty ?? true
      ? "start_date".tr
      : DateTimeHelper.convertHyphenIntoSlash(filterKeys.startDate!);

  String getEndDate() => filterKeys.endDate?.isEmpty ?? true
      ? "end_date".tr
      : DateTimeHelper.convertHyphenIntoSlash(filterKeys.endDate!);
}
