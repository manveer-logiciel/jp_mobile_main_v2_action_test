import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/sql/tag/tag_param.dart';
import 'package:jobprogress/common/repositories/sql/tag.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/tag_modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../common/enums/filter_dialog_text_type.dart';
import '../../../../common/models/progress_board/progress_board_filter_model.dart';
import '../../../../common/models/sql/division/division_param.dart';
import '../../../../common/models/sql/trade_type/trade_type_param.dart';
import '../../../../common/models/sql/user/user_param.dart';
import '../../../../common/models/workflow_stage.dart';
import '../../../../common/repositories/sql/division.dart';
import '../../../../common/repositories/sql/trade_type.dart';
import '../../../../common/repositories/sql/user.dart';
import '../../../../common/repositories/sql/workflow_stages.dart';
import '../../../../core/constants/dropdown_list_constants.dart';
import '../../../../core/utils/multi_select_helper.dart';
import '../../../../core/utils/single_select_helper.dart';
import '../../../../global_widgets/profile_image_widget/index.dart';

class PBFilterDialogController extends GetxController {

  ProgressBoardFilterModel filterKeys = ProgressBoardFilterModel();
  ProgressBoardFilterModel defaultFilters = ProgressBoardFilterModel();

  List<JPSingleSelectModel> tradeList = [];
  List<JPMultiSelectModel> divisionList = [];
  List<JPMultiSelectModel> userList = [];
  List<JPMultiSelectModel> stageList = [];
  List<JPMultiSelectModel> groupList = [];

  TextEditingController jobIdTextController = TextEditingController();
  TextEditingController jobNameTextController = TextEditingController();
  TextEditingController customerNameTextController = TextEditingController();
  TextEditingController jobAddressTextController = TextEditingController();
  TextEditingController zipTextController = TextEditingController();
  TextEditingController tradeTextController = TextEditingController();
  TextEditingController divisionsTextController = TextEditingController();
  TextEditingController usersTextController = TextEditingController();
  TextEditingController jobStatusTextController = TextEditingController();
  TextEditingController stagesTextController = TextEditingController();

  bool isResetButtonDisable = true;


  PBFilterDialogController(ProgressBoardFilterModel selectedFilters, this.defaultFilters) {
    setDefaultKeys(selectedFilters);
  }

  ////////////////////////   SE DEFAULT VALUES   ///////////////////////

  void setDefaultKeys(ProgressBoardFilterModel params,) {
    filterKeys = ProgressBoardFilterModel.copy(params);

    ///   Trade
    TradeTypeParamModel tradeParams = TradeTypeParamModel(withInactive: true, includes: ['work_type'], withInActiveWorkType: true,);
    SqlTradeTypeRepository().get(params: tradeParams).then((trades) {
      tradeTextController.text = "";
      if(filterKeys.trades?.isNotEmpty ?? false) {
        tradeList = [];
        for(int i = 0; i < trades.data.length; i++) {
          tradeList.add(JPSingleSelectModel(id: trades.data[i].id.toString(), label: trades.data[i].name,));
          for (int j = 0; j < filterKeys.trades!.length; j++) {
            if(trades.data[i].id == filterKeys.trades![j]) {
              filterKeys.tradeId = filterKeys.trades?[j].toString();
              tradeTextController.text = tradeTextController.text + (tradeTextController.text.isEmpty ? "" : ", ") + trades.data[i].name;
              break;
            }
          }
        }
        tradeList.insert(
            0,
            JPSingleSelectModel(
              id: "0",
              label: "none".tr.toUpperCase(),
            ));
      } else {
        for (var element in trades.data) {
          tradeList.add(JPSingleSelectModel(id: element.id.toString(), label: element.name,));
        }
        filterKeys.trades = [];
        tradeList.insert(
            0,
            JPSingleSelectModel(
              id: "0",
              label: "none".tr.toUpperCase(),
            ));
        filterKeys.tradeId = "0";
      }
    });


    ///   Divisions
    DivisionParamModel divisionParams = DivisionParamModel(includes: ['users'], limit: -1);
    SqlDivisionRepository().get(params: divisionParams).then((divisionList) {
      divisionsTextController.text = "";
      if(filterKeys.divisionIds?.isNotEmpty ?? false) {
        for(int i = 0; i < divisionList.data.length; i++) {
          this.divisionList.add(JPMultiSelectModel(
              id: divisionList.data[i].id.toString(), label: divisionList.data[i].name,
              isSelect: false));
          for (int j = 0; j < filterKeys.divisionIds!.length; j++) {
            if(divisionList.data[i].id == filterKeys.divisionIds![j]) {
              this.divisionList[i].isSelect = true;
              filterKeys.divisionIds!.add(filterKeys.divisionIds![j]);
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

    SqlTagsRepository().get(params:tagsParams ).then((tags) {
        for (var element in tags.data) {
          groupList.add(JPMultiSelectModel(
              id: element.id.toString(), label: element.name, isSelect: false,subListLength: element.users?.length, ));
        }
      });

    ///    Fetch  User
    UserParamModel requestParams = UserParamModel(
      withSubContractorPrime: false,
      limit: 0,
      includes: ['tags']
    );

    SqlUserRepository().get(params: requestParams).then((userData) {
      usersTextController.text = "";
      List<TagLimitedModel> tag = [];
      if(filterKeys.usersIds?.isNotEmpty ?? false) {
        for(int i = 0; i < userData.data.length; i++) {
          if(userData.data[i].tags != null){
            for(int j = 0;j < userData.data[i].tags!.length; j++){
              tag.add(TagLimitedModel(id:userData.data[i].tags![j].id ,name: userData.data[i].tags![j].name));
            }
          }
          userList.add(JPMultiSelectModel(
            id: userData.data[i].id.toString(), label: userData.data[i].fullName,tags: tag,
            isSelect: false,child:JPProfileImage(
              src: userData.data[i].profilePic,
              color: userData.data[i].color,
              initial: userData.data[i].intial,
            ),
          ));
          tag=[];
          for (int j = 0; j < filterKeys.usersIds!.length; j++) {
            if(userData.data[i].id == filterKeys.usersIds![j]) {
              userList[i].isSelect = true;
              usersTextController.text = usersTextController.text + (usersTextController.text.isEmpty ? "" : ", ") + userData.data[i].fullName;
              break;
              }}
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

    ///   Job status
    jobStatusTextController.text = DropdownListConstants.jobStatusList.firstWhere(
            (element) => element.id == filterKeys.jobStatus).label;

    ///   Stages
    SqlWorkFlowStagesRepository().get().then((List<WorkFlowStageModel?> stages) {
      stageList = [];
      for (var stage in stages) {
        stageList.add(
          JPMultiSelectModel(
              label: stage?.name.toString().capitalizeFirst ?? '',
              id: stage?.code ?? '',
              child: JPProfileImage(
                color: stage?.color,
                initial: stage?.initial,
              ),
              isSelect: false
          ),
        );

        if(filterKeys.stages?.isNotEmpty ?? false) {
          stagesTextController.text = "";
          for (var stage in filterKeys.stages!) {
            for (int j = 0; j < stageList.length; j++) {
              if (stageList[j].id == stage.toString()) {
                stageList[j].isSelect = true;
                stagesTextController.text = stagesTextController.text + (stagesTextController.text.isEmpty ? "" : ", ") + stageList[j].label;
              }
            }
          }
        }
      }
    });

    jobIdTextController.text = filterKeys.jobId ?? "";
    jobNameTextController.text = filterKeys.jobName ?? "";
    customerNameTextController.text = filterKeys.customerName ?? "";
    jobAddressTextController.text = filterKeys.jobAddress ?? "";
    zipTextController.text = filterKeys.zipCode ?? "";
    updateResetButtonDisable();
  }

  ///////////////////////   MANAGE MULTISELECT DROPDOWN   //////////////////////

  void openMultiSelect(FilterDialogTextType type) {
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
      case FilterDialogTextType.stages:
        title = "select_stages".tr.toUpperCase();
        mainList = stageList;
        break;
      default:
        break;
    }

    MultiSelectHelper.openMultiSelect(
        title: title,
        mainList: mainList,
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
            case FilterDialogTextType.stages:
              updateStages(selectedTrades);
              break;
            default:
              break;
          }
          Get.back();
          updateResetButtonDisable();
        });
  }

  //////////////////////   MANAGE SINGLE SELECT DROPDOWN   /////////////////////

  void openSingleSelect(FilterDialogTextType type) {
    late String title;
    late List<JPSingleSelectModel> mainList;
    late String selectedValue;

    switch (type) {
      case FilterDialogTextType.trades:
        title = "select_trades".tr.toUpperCase();
        mainList = tradeList;
        selectedValue = filterKeys.tradeId ?? "";
        break;
      case FilterDialogTextType.status:
        title = "select_status".tr.toUpperCase();
        mainList = DropdownListConstants.jobStatusList;
        selectedValue = filterKeys.jobStatus ?? "";
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
            case FilterDialogTextType.trades:
              updateTrades(value);
              break;
            case FilterDialogTextType.status:
              updateStatus(value);
              break;
            default:
              break;
          }
          Get.back();
          updateResetButtonDisable();
        },
        isFilterSheet: true);
  }

  void updateTrades(String selectedTrades) {
    tradeTextController.text = "";
    filterKeys.trades = [];

    JPSingleSelectModel? trade = tradeList.firstWhereOrNull((element) => element.id == selectedTrades);

    if(trade != null && trade.id != "0") {
      tradeTextController.text = trade.label;
      filterKeys.trades = [];
      filterKeys.trades!.add(int.parse(selectedTrades));
    } else {
      tradeTextController.text = "";
      filterKeys.trades = [];
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
    filterKeys.usersIds = [];
    userList = selectedTrades;
    for (var element in selectedTrades) {
      if(element.isSelect){
        filterKeys.usersIds!.add(int.parse(element.id));
        usersTextController.text = usersTextController.text + (usersTextController.text.isEmpty ? "" : ", ") + element.label;
      }
    }
  }

  void updateStatus(String selectedStatus) {
    jobStatusTextController.text = "";
    filterKeys.jobStatus = "";

    JPSingleSelectModel? status = DropdownListConstants.jobStatusList.firstWhereOrNull((element) => element.id == selectedStatus);

    if(status != null) {
      jobStatusTextController.text = status.label;
      filterKeys.jobStatus = selectedStatus;
    } else {
      jobStatusTextController.text = DropdownListConstants.jobStatusList.first.label;
      filterKeys.jobStatus = DropdownListConstants.jobStatusList.first.id;
    }
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

  void onTextChange({required String value, required FilterDialogTextType type}) {
    switch (type) {
      case FilterDialogTextType.job:
        filterKeys.jobId = value.isEmpty ? null : value;
        break;
      case FilterDialogTextType.jobName:
        filterKeys.jobName = value.isEmpty ? null : value;
        break;
      case FilterDialogTextType.customerName:
        filterKeys.customerName = value.isEmpty ? null : value;
        break;
      case FilterDialogTextType.address:
        filterKeys.jobAddress = value.isEmpty ? null : value;
        break;
      case FilterDialogTextType.zip:
        filterKeys.zipCode = value.isEmpty ? null : value;
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

  ///////////////////////////   RESET FILTER DIALOG   //////////////////////////

  void cleanFilterKeys({ProgressBoardFilterModel? defaultFilters}) {

    jobIdTextController.text = '';
    jobNameTextController.text = '';
    customerNameTextController.text = '';
    jobAddressTextController.text = '';
    zipTextController.text = '';
    tradeTextController.text = '';
    divisionsTextController.text = '';
    usersTextController.text = '';
    jobStatusTextController.text = '';
    stagesTextController.text = '';

    filterKeys.trades = [];
    filterKeys.divisionIds = [];
    filterKeys.usersIds = [];
    filterKeys.jobStatus = "archive";
    filterKeys.stages = [];

    tradeList.clear();
    divisionList.clear();
    userList.clear();
    stageList.clear();

    setDefaultKeys(defaultFilters!);
  }

  ///////////////////////////////   SET FILTER   ///////////////////////////////

  void applyFilter(void Function(ProgressBoardFilterModel params) onApply) {

    filterKeys.jobId = jobIdTextController.text.trim().isEmpty ? null : jobIdTextController.text.trim();
    filterKeys.jobName = jobNameTextController.text.trim().isEmpty ? null : jobNameTextController.text.trim();
    filterKeys.customerName = customerNameTextController.text.trim().isEmpty ? null : customerNameTextController.text.trim();
    filterKeys.jobAddress = jobAddressTextController.text.trim().isEmpty ? null : jobAddressTextController.text.trim();
    filterKeys.zipCode = zipTextController.text.trim().isEmpty ? null : zipTextController.text.trim();

    onApply(filterKeys);
    Get.back();
  }

  @override
  void dispose() {
    jobIdTextController.dispose();
    jobNameTextController.dispose();
    customerNameTextController.dispose();
    jobAddressTextController.dispose();
    zipTextController.dispose();
    tradeTextController.dispose();
    divisionsTextController.dispose();
    usersTextController.dispose();
    jobStatusTextController.dispose();
    stagesTextController.dispose();
    super.dispose();
  }

}