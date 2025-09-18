import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/date_picker_type.dart';
import 'package:jobprogress/common/models/sql/tag/tag_param.dart';
import 'package:jobprogress/common/repositories/sql/division.dart';
import 'package:jobprogress/common/repositories/sql/flags.dart';
import 'package:jobprogress/common/repositories/sql/tag.dart';
import 'package:jobprogress/common/repositories/sql/trade_type.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/core/constants/dropdown_list_constants.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/tag_modal.dart';
import 'package:jp_mobile_flutter_ui/HierarchicalMultiSelect/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../common/enums/filter_dialog_text_type.dart';
import '../../../../../common/models/job/job_listing_filter.dart';
import '../../../../../common/models/sql/division/division_param.dart';
import '../../../../../common/models/sql/trade_type/trade_type_param.dart';
import '../../../../../common/models/sql/user/user.dart';
import '../../../../../common/models/sql/user/user_param.dart';
import '../../../../../common/repositories/sql/state.dart';
import '../../../../../common/repositories/sql/user.dart';
import '../../../../../core/constants/date_formats.dart';
import '../../../../../core/utils/multi_select_helper.dart';
import '../../../../../core/utils/hierarchical_multi_select_helper.dart';
import '../../../../../global_widgets/bottom_sheet/index.dart';

class JobListingFilterDialogController extends GetxController {

  late JobListingFilterModel filterKeys;
  late JobListingFilterModel defaultFilters;

  late String selectedDateType;
  late String selectedDuration;

  List<JPMultiSelectModel> stageList = [];
  List<JPMultiSelectModel> divisionList = [];
  List<JPMultiSelectModel> userList = [];
  List<JPMultiSelectModel> groupList = [];
  List<JPMultiSelectModel> tradeList = [];
  List<JPMultiSelectModel> stateList = [];
  List<JPMultiSelectModel> flagList = [];
  List<JPHierarchicalSelectorGroupModel> groupedStageList = [];

  TextEditingController stagesTextController = TextEditingController();
  TextEditingController divisionsTextController = TextEditingController();
  TextEditingController usersTextController = TextEditingController();
  TextEditingController tradeTextController = TextEditingController();
  TextEditingController flagsTextController = TextEditingController();
  TextEditingController jobTextController = TextEditingController();
  TextEditingController addressTextController = TextEditingController();
  TextEditingController stateTextController = TextEditingController();
  TextEditingController zipTextController = TextEditingController();
  TextEditingController customerNameTextController = TextEditingController();
  TextEditingController dateTypeTextController = TextEditingController();
  TextEditingController durationTextController = TextEditingController();
  TextEditingController jobIdTextController = TextEditingController();

  bool isResetButtonDisable = true;
  int selectedCheckBox = 0;
  int alreadySelectedCheckBox = 0;

  JPSingleSelectModel? selectJobProject;
  JPSingleSelectModel? selectJobProjectId;

  JobListingFilterDialogController(JobListingFilterModel selectedFilters, this.defaultFilters, List<JPMultiSelectModel> stages, List<JPHierarchicalSelectorGroupModel> groupedStages) {
    stageList = stages;
    groupedStageList = groupedStages;
    setDefaultKeys(selectedFilters);
  }

  void setDefaultKeys(JobListingFilterModel params,) {

    filterKeys = JobListingFilterModel.copy(params);

    for (var element in stageList) {element.isSelect = false;}
    ///   Stages
    if(filterKeys.stages?.isNotEmpty ?? false) {
      stagesTextController.text = "";
      for (var stage in filterKeys.stages!) {
        for (int j = 0; j < stageList.length; j++) {
          if (stageList[j].id == stage) {
            stageList[j].isSelect = true;
            stagesTextController.text = stagesTextController.text + (stagesTextController.text.isEmpty ? "" : ", ") + stageList[j].label;
          }
        }
      }
    }

    ///   Divisions
    DivisionParamModel divisionParams = DivisionParamModel(includes: ['users'], limit: -1);
    SqlDivisionRepository().get(params: divisionParams).then((divisionList) {
      this.divisionList.insert(0, JPMultiSelectModel(id: "0", label: "unassigned".tr, isSelect: false));
      divisionsTextController.text = "";
      if(filterKeys.divisionIds?.isNotEmpty ?? false) {
        for(int i = 0; i < divisionList.data.length; i++) {
          this.divisionList.add(JPMultiSelectModel(
              id: divisionList.data[i].id.toString(), label: divisionList.data[i].name,
              isSelect: false));
        }

        for(int j = 0; j < this.divisionList.length; j++) {
          for (int k = 0; k < filterKeys.divisionIds!.length; k++) {
            if(this.divisionList[j].id == filterKeys.divisionIds![k].toString()) {
              this.divisionList[j].isSelect = true;
              divisionsTextController.text = divisionsTextController.text + (divisionsTextController.text.isEmpty ? "" : ", ") + this.divisionList[j].label;
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

    if(AuthService.isStandardUser() && AuthService.isRestricted ) {
      UserModel? userData = AuthService.getUserDetails();
      usersTextController.text = userData?.fullName ?? "";
    } else {
      SqlUserRepository().get(params: requestParams).then((userData) {
        usersTextController.text = "";
        List<TagLimitedModel> tag = [];
        if (filterKeys.users?.isNotEmpty ?? false) {
          for (int i = 0; i < userData.data.length; i++) {
            if (userData.data[i].tags != null) {
              for (int j = 0; j < userData.data[i].tags!.length; j++) {
                tag.add(TagLimitedModel(id: userData.data[i].tags![j].id,
                    name: userData.data[i].tags![j].name));
              }
            }
            userList.add(JPMultiSelectModel(
              id: userData.data[i].id.toString(),
              label: userData.data[i].fullName,
              tags: tag,
              active: userData.data[i].active,
              isSelect: false,
              child: JPProfileImage(
                src: userData.data[i].profilePic,
                color: userData.data[i].color,
                initial: userData.data[i].intial,
              ),
            ));
            for (int j = 0; j < filterKeys.users!.length; j++) {
              if (userData.data[i].id == filterKeys.users![j]) {
                userList[i].isSelect = true;
                usersTextController.text = usersTextController.text +
                    (usersTextController.text.isEmpty ? "" : ", ") +
                    userData.data[i].fullName;
                break;
              }
            }
            tag = [];
          }
        } else {
          for (var element in userData.data) {
            List<TagLimitedModel> tag = [];
            if (element.tags != null) {
              for (var e in element.tags!) {
                tag.add(TagLimitedModel(id: e.id, name: e.name));
              }
            }
            userList.add(JPMultiSelectModel(
              id: element.id.toString(),
              label: element.fullName,
              active: element.active,
              isSelect: false,
              child: JPProfileImage(
                src: element.profilePic,
                color: element.color,
                initial: element.intial,
              ),
              tags: tag,
            ));
            tag = [];
          }
        }
      });
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

    ///   Flags
    SqlFlagRepository().get(type: "job").then((flags) {
      flagsTextController.text = "";
      if(filterKeys.flags?.isNotEmpty ?? false) {
        for(int i = 0; i < flags.length; i++) {
          flagList.add(JPMultiSelectModel(
              id: flags[i]!.id.toString(), label: flags[i]!.title,
              isSelect: false));
          for (int j = 0; j < filterKeys.flags!.length; j++) {
            if(flags[i]?.id == filterKeys.flags?[j]) {
              flagList[i].isSelect = true;
              flagsTextController.text = flagsTextController.text + (flagsTextController.text.isEmpty ? "" : ", ") + flags[i]!.title;
              break;
            }
          }
        }
      } else {
        for (var element in flags) {
          flagList.add(JPMultiSelectModel(
              id: element!.id.toString(),
              label: element.title,
              isSelect: false));
        }
      }
    });

    ///   Fetch State
    SqlStateRepository().get().then((stateList) {
      stateTextController.text = "";
      if(filterKeys.stateIds?.isNotEmpty ?? false) {
        for(int i = 0; i < stateList.length; i++) {
          this.stateList.add(JPMultiSelectModel(
              id: stateList[i]!.id.toString(), label: stateList[i]!.name,
              isSelect: false));
          for (int j = 0; j < filterKeys.stateIds!.length; j++) {
            if(stateList[i]!.id == filterKeys.stateIds![j]) {
              this.stateList[i].isSelect = true;
              stateTextController.text = stateTextController.text + (stateTextController.text.isEmpty ? "" : ", ") + stateList[i]!.name;
              break;
            }
          }
        }
      } else {
        for (var element in stateList) {
          this.stateList.add(JPMultiSelectModel(
              id: element!.id.toString(), label: element.name, isSelect: false));
        }
      }
    });

    if(filterKeys.isWithArchived ?? false) selectedCheckBox = 1;
    if(filterKeys.isOnlyArchived ?? false) selectedCheckBox = 2;
    if(filterKeys.followUpMarks?.isNotEmpty ?? false) selectedCheckBox = 3;
    if(filterKeys.insuranceJobsOnly) selectedCheckBox = 4;

    selectedDateType = filterKeys.dateRangeType ?? "";
    selectedDuration = filterKeys.duration ?? "";

    if(Helper.isValueNullOrEmpty(filterKeys.jobId) && !Helper.isValueNullOrEmpty(filterKeys.projectId)) {
      jobIdTextController.text = filterKeys.projectId ?? "";
      selectJobProjectId = DropdownListConstants.jobProjectIdList[1];
    } else {
      jobIdTextController.text = filterKeys.jobId ?? "";
    }

    if(Helper.isValueNullOrEmpty(filterKeys.jobId) && !Helper.isValueNullOrEmpty(filterKeys.projectId)) {
      jobTextController.text = filterKeys.projectId ?? "";
      selectJobProject = DropdownListConstants.jobProjectList[1];
    } else {
      jobTextController.text = filterKeys.jobId ?? "";
    }

    if(Helper.isValueNullOrEmpty(filterKeys.jobAltId) && !Helper.isValueNullOrEmpty(filterKeys.projectAltId)) {
      jobIdTextController.text = filterKeys.projectAltId ?? "";
      selectJobProjectId = DropdownListConstants.jobProjectIdList[1];
    } else {
      jobIdTextController.text = filterKeys.jobAltId ?? "";
    }

    addressTextController.text = filterKeys.address ?? "";
    zipTextController.text = filterKeys.zip ?? "";
    customerNameTextController.text = filterKeys.customerName ?? "";
    dateTypeTextController.text = DropdownListConstants().dataRangeTypeList.firstWhereOrNull((element) => element.id == selectedDateType)?.label ?? '';
    durationTextController.text = DropdownListConstants.durationsList.firstWhereOrNull((element) => element.id == selectedDuration)?.label ?? '';
    updateResetButtonDisable();
  }

  void openMultiSelect(FilterDialogTextType type) {
    // Handle stages with hierarchical selector
    if (LDService.hasFeatureEnabled(LDFlagKeyConstants.workflowJobStageGrouping)
        && type == FilterDialogTextType.stages) {
      openStagesHierarchicalSelector();
      return;
    }

    bool showInactiveUser = FeatureFlagService.hasFeatureAllowed([
      FeatureFlagConstant.userManagement]) && 
      type == FilterDialogTextType.users;
    late String title;
    late List<JPMultiSelectModel> mainList;

    switch (type) {
      case FilterDialogTextType.stages:
        title = "select_stages".tr.toUpperCase();
        mainList = stageList;
        break;
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
      case FilterDialogTextType.flags:
        title = "select_flags".tr.toUpperCase();
        mainList = flagList;
        break;
      case FilterDialogTextType.states:
        title = "select_states".tr.toUpperCase();
        mainList = stateList;
        break;
      default:
        break;
    }

    MultiSelectHelper.openMultiSelect(
      title: title,
      mainList: mainList,
      showIncludeInactiveButton: showInactiveUser,
      subList: (type == FilterDialogTextType.users) ? groupList : [],
      isGroupsHeader:(type == FilterDialogTextType.users && !Helper.isValueNullOrEmpty(groupList)),
      
      callback: (List<JPMultiSelectModel> selectedTrades) {
        switch (type) {
          case FilterDialogTextType.stages: 
            updateStages(selectedTrades);
            break;
          case FilterDialogTextType.divisions:
            updateDivisions(selectedTrades);
            break;
          case FilterDialogTextType.users:
            updateUsers(selectedTrades);
            break;
          case FilterDialogTextType.trades:
            updateTrades(selectedTrades);
            break;
          case FilterDialogTextType.flags:
            updateFlags(selectedTrades);
            break;
          case FilterDialogTextType.states:
            updateState(selectedTrades);
            break;
          default:
            break;
        }
        Get.back();
        updateResetButtonDisable();
      });
  }

  void openStagesHierarchicalSelector() async {
    try {
      // Create a copy of groupedStageList with current selections preserved
      List<JPHierarchicalSelectorGroupModel> updatedGroups = _updateGroupsWithSelections(groupedStageList);

      HierarchicalMultiSelectHelper.openHierarchicalMultiSelect(
        selectorModel: JPHierarchicalSelectorModel(groups: updatedGroups),
        title: "select_stages".tr.toUpperCase(),
        onApply: (selectedModel) => handleStagesApply(selectedModel),
        onClear: () => Get.back(),
      );
    } catch (e) {
      // Fallback to sample data if real data fails
      debugPrint("Failed to load workflow stages: $e");
    }
  }

  /// Updates the grouped stage list with current selection state
  List<JPHierarchicalSelectorGroupModel> _updateGroupsWithSelections(List<JPHierarchicalSelectorGroupModel> groups) {
    // Get currently selected stage IDs from filter keys
    List<String> selectedStageIds = (filterKeys.stages ?? []).whereType<String>().toList();

    return groups.map((group) {
      // Update items in each group to reflect current selections
      List<JPHierarchicalSelectorItemModel> updatedItems = group.items.map((item) {
        return item.copyWith(isSelected: selectedStageIds.contains(item.id));
      }).toList();

      return group.copyWith(items: updatedItems);
    }).toList();
  }

  void handleStagesApply(JPHierarchicalSelectorModel selectedModel) {
    // Extract selected item IDs from hierarchical model
    List<String> selectedIds = [];
    Map<String, String> idToLabelMap = {};

    for (JPHierarchicalSelectorGroupModel group in selectedModel.groups) {
      for (JPHierarchicalSelectorItemModel item in group.items) {
        if (item.isSelected) {
          selectedIds.add(item.id);
          idToLabelMap[item.id] = item.label;
        }
      }
    }

    // Update filter keys
    filterKeys.stages = selectedIds;
    
    // Update stages text controller
    stagesTextController.text = selectedIds.map((id) => idToLabelMap[id]).join(", ");

    // Update stageList to maintain consistency with existing filter logic
    for (var stage in stageList) {
      stage.isSelect = selectedIds.contains(stage.id);
    }

    // Update the grouped stage list to preserve selections for next time
    groupedStageList = selectedModel.groups;

    // Update UI - modal closing is handled by the helper
    updateResetButtonDisable();
  }

  void openSingleSelect(FilterDialogTextType type) {
    late String title;
    late List<JPSingleSelectModel> mainList;
    late String selectedValue;

    switch (type) {
      case FilterDialogTextType.dateType:
        title = "select_date_type".tr.toUpperCase();
        mainList = DropdownListConstants().dataRangeTypeList;
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

  void updateStages(List<JPMultiSelectModel> selectedTrades) {
    stagesTextController.text = "";
    filterKeys.stages = [];
    stageList = [];
    stageList = selectedTrades;
    for (var element in selectedTrades) {
      if(element.isSelect) {
        filterKeys.stages!.add(element.id);
        stagesTextController.text = stagesTextController.text + (stagesTextController.text.isEmpty ? "" : ", ") + element.label;
      }
    }
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

  void updateFlags(List<JPMultiSelectModel> selectedTrades) {
    flagsTextController.text = "";
    filterKeys.flags = [];
    flagList = selectedTrades;
    for (var element in selectedTrades) {
      if(element.isSelect){
        filterKeys.flags!.add(int.parse(element.id));
        flagsTextController.text = flagsTextController.text + (flagsTextController.text.isEmpty ? "" : ", ") + element.label;
      }
    }
  }

  void updateState(List<JPMultiSelectModel> selectedTrades) {
    stateTextController.text = "";
    filterKeys.stateIds = [];
    stateList = selectedTrades;
    for (var element in selectedTrades) {
      if(element.isSelect){
        filterKeys.stateIds!.add(int.parse(element.id));
        stateTextController.text = stateTextController.text + (stateTextController.text.isEmpty ? "" : ", ") + element.label;
      }
    }
  }

  void updateDateType(String value) {
    selectedDateType = value;
    filterKeys.dateRangeType = selectedDateType;
    dateTypeTextController.text = DropdownListConstants().dataRangeTypeList.firstWhere((element) => element.id == value).label;
  }

  void selectCheckBox(int index) {
    selectedCheckBox = index;
    filterKeys.isWithArchived = null;
    filterKeys.isOnlyArchived = null;
    filterKeys.followUpMarks = null;
    filterKeys.insuranceJobsOnly = false;

    if(selectedCheckBox == alreadySelectedCheckBox) {
      selectedCheckBox = 0;
    } else {
      switch (index) {
        case 1:
          filterKeys.isWithArchived = true;
          break;
        case 2:
          filterKeys.isOnlyArchived = true;
          break;
        case 3:
          filterKeys.followUpMarks = ["lost_job"];
          break;
        case 4:
          filterKeys.insuranceJobsOnly = true;
          break;
      }
    }
    alreadySelectedCheckBox = selectedCheckBox;
    updateResetButtonDisable();
  }

  void updateDuration(String value) {
    selectedDuration = value;
    filterKeys.duration = value;
    durationTextController.text = DropdownListConstants.durationsList.firstWhere((element) => element.id == value).label;
  }

  void onTextChange({required String value, required FilterDialogTextType type}) {
    switch (type) {
      case FilterDialogTextType.job:
        filterKeys.jobId = value.isEmpty ? null : value;
        break;
      case FilterDialogTextType.jobName:
        filterKeys.jobAltId = value.isEmpty ? null : value;
        break;
      case FilterDialogTextType.address:
        filterKeys.address = value.isEmpty ? null : value;
        break;
      case FilterDialogTextType.zip:
        filterKeys.zip = value.isEmpty ? null : value;
        break;
      case FilterDialogTextType.customerName:
        filterKeys.customerName = value.isEmpty ? null : value;
        break;
      default:
        break;
    }
    updateResetButtonDisable();
  }

  void updateResetButtonDisable() {
    isResetButtonDisable = filterKeys == defaultFilters;
    update();
  }

  void applyFilter(void Function(JobListingFilterModel params) onApply) {
    if(selectJobProject?.id == 'project') {
      filterKeys.jobId = null;
      filterKeys.projectId = jobIdTextController.text.trim().isEmpty ? null : jobIdTextController.text.trim();
    } else {
      filterKeys.projectId = null;
      filterKeys.jobId = jobIdTextController.text.trim().isEmpty ? null : jobIdTextController.text.trim();
    }

    if(selectJobProjectId?.id == 'project_id') {
      filterKeys.jobAltId = null;
      filterKeys.projectAltId = jobTextController.text.trim().isEmpty ? null : jobTextController.text.trim();
    } else {
      filterKeys.projectAltId = null;
      filterKeys.jobAltId = jobTextController.text.trim().isEmpty ? null : jobTextController.text.trim();
    }

    filterKeys.address = addressTextController.text.trim().isEmpty ? null : addressTextController.text.trim();
    filterKeys.zip = zipTextController.text.trim().isEmpty ? null : zipTextController.text.trim();
    filterKeys.customerName = customerNameTextController.text.trim().isEmpty ? null : customerNameTextController.text.trim();

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

  void cleanFilterKeys({JobListingFilterModel? defaultFilters}) {
    stagesTextController.text = '';
    divisionsTextController.text = '';
    usersTextController.text = '';
    tradeTextController.text = '';
    flagsTextController.text = '';
    jobTextController.text = '';
    jobIdTextController.text = '';
    addressTextController.text = '';
    stateTextController.text = '';
    zipTextController.text = '';
    customerNameTextController.text = '';

    dateTypeTextController.text = DropdownListConstants().dataRangeTypeList.firstWhereOrNull((element) => element.id == filterKeys.dateRangeType)?.label ?? '';
    durationTextController.text = DropdownListConstants.durationsList.firstWhereOrNull((element) => element.id == filterKeys.duration)?.label ?? '';

    selectedCheckBox = 0;
    selectedDateType = filterKeys.dateRangeType!;
    selectedDuration = filterKeys.duration!;

    filterKeys.stages = [];
    filterKeys.divisionIds = filterKeys.users = filterKeys.trades = filterKeys.stateIds = [];

    for (var element in stageList) {element.isSelect = false;}
    
    // Clear hierarchical grouped stage selections
    groupedStageList = groupedStageList.map((group) {
      List<JPHierarchicalSelectorItemModel> clearedItems = group.items.map((item) {
        return item.copyWith(isSelected: false);
      }).toList();
      return group.copyWith(items: clearedItems);
    }).toList();
    
    divisionList.clear();
    userList.clear();
    tradeList.clear();
    stateList.clear();

    setDefaultKeys(defaultFilters!);
  }

  void selectJobProjectFilterType() {
    showJPBottomSheet(
        child: (_) => JPSingleSelect(
            selectedItemId: selectJobProject?.id,
            title: "select_name_type".tr.toUpperCase(),
            mainList: DropdownListConstants.jobProjectList,
            onItemSelect: (value) {
              selectJobProject = DropdownListConstants.jobProjectList.firstWhereOrNull((jobProject) => jobProject.id == value);
              updateResetButtonDisable();
              Get.back();
              update();
            }),
        isScrollControlled: true
    );
  }

  void selectJobProjectIdFilterType() {
    showJPBottomSheet(
        child: (_) => JPSingleSelect(
            selectedItemId: selectJobProjectId?.id,
            title: "select_name_type".tr.toUpperCase(),
            mainList: DropdownListConstants.jobProjectIdList,
            onItemSelect: (value) {
              selectJobProjectId = DropdownListConstants.jobProjectIdList.firstWhereOrNull((jobProjectId) => jobProjectId.id == value);
             // filterKeys.jobProjectIdType = value;
              updateResetButtonDisable();
              Get.back();
              update();
            }),
        isScrollControlled: true
    );
  }

  @override
  void onClose() {
    stagesTextController.dispose();
    usersTextController.dispose();
    divisionsTextController.dispose();
    tradeTextController.dispose();
    flagsTextController.dispose();
    jobIdTextController.dispose();
    jobTextController.dispose();
    addressTextController.dispose();
    stateTextController.dispose();
    zipTextController.dispose();
    customerNameTextController.dispose();
    dateTypeTextController.dispose();
    durationTextController.dispose();
    super.onClose();
  }


}