
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/company_trades/company_trades_model.dart';
import 'package:jobprogress/common/models/forms/job/trades.dart';
import 'package:jobprogress/common/models/job/job_type.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/core/utils/form/db_helper.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobTradeWorkTypeInputsController extends GetxController {

  JobTradeWorkTypeInputsController({
    required this.tradesList,
    required this.workTypesList
  });

  final List<CompanyTradesModel> tradesList; // holds data of selected trades
  final List<JobTypeModel> workTypesList; // holds data of selected work types

  List<JobFormTradeWorkTypeData> tradeWorkTypeList = []; // holds trade/work type fields

  List<JPSingleSelectModel> allTrades = []; // holds data of local DB trades
  List<JPSingleSelectModel> tradesAlreadySelected = []; // holds data of already selected trades

  bool validateFormOnDataChange = false; // flags to deciding realtime validation

  final uiHelper = FormUiHelper(); // helps in implementing ui

  final formKey = GlobalKey<FormState>(); // used to validate form

  @override
  void onInit() {
    // getting local data and setting up fields
    getLocalData().then((value) => setUpFields());
    super.onInit();
  }

  void setUpFields() {
    // in case of add job, empty field will be initialized
    if (tradesList.isEmpty) {
      addTradeWorkTypeField();
    } else {
      // in case of edit form fields with data will be initialized
      for (var trade in tradesList) {
        addTradeWorkTypeField(trade: trade);
      }
    }

    update();
  }

  Future<void> getLocalData() async {
    try {
      allTrades = await FormsDBHelper.getAllTrades();
    } catch (e) {
      rethrow;
    }
  }

  // addTradeWorkTypeField(): adds new trade / work-type fields with or without data
  void addTradeWorkTypeField({CompanyTradesModel? trade}) {
    final tradeData = JobFormTradeWorkTypeData();

    // in case trade data is available, filling data in fields
    if (trade != null) {
      // comparing data rom server with local db data
      final selectedTrade = FormValueSelectorService.getSelectedSingleSelect(allTrades, trade.id.toString());
      // adding to already selected fields, so can't have a second selection
      addToAlreadySelectedTrade(selectedTrade, initialSetup: true);
      // filtering "workTypesList" for accessing work-types only associated with current trade
      final tempWorkTypesList = workTypesList.where((type) => type.tradeId.toString() == selectedTrade.id).toList();

      // setting up initial data
      tradeData.setInitialData(
          selectedTrade,
          workTypes: tempWorkTypesList,
          isScheduled: trade.isScheduled ?? false
      );
    }

    tradeWorkTypeList.add(tradeData);

    // conditional update to avoid lags
    if (trade == null) update();
  }

  // removeTradeWorkTypeField(): removes trade work type field
  void removeTradeWorkTypeField(int index) {
    String selectedId = tradeWorkTypeList[index].selectedTradeId;

    // removing data associated with fields (i.e trades and work-types)
    if (selectedId.isNotEmpty) {
      final selectedTrade = FormValueSelectorService.getSelectedSingleSelect(allTrades, selectedId);
      for (JPMultiSelectModel workType in selectedTrade.additionalData) {
        removeWorkType(workType.id);
      }
      removeFromAlreadySelectedTrade(selectedTrade);
    }

    tradeWorkTypeList.removeAt(index);
    update();
  }

  void addWorkType(JPMultiSelectModel data) {
    workTypesList.add(
      JobTypeModel(
          id: int.tryParse(data.id),
          name: data.label
      ),
    );
  }

  void removeWorkType(String id) {
    workTypesList.removeWhere((type) => type.id.toString() == id);
  }

  void addToAlreadySelectedTrade(JPSingleSelectModel data, {bool initialSetup = false}) {
    tradesAlreadySelected.add(data);
    if (!initialSetup) {
      tradesList.add(CompanyTradesModel.fromSingleSelect(data));
    }
  }

  void removeFromAlreadySelectedTrade(JPSingleSelectModel? data) {
    tradesAlreadySelected.remove(data);
    if (data != null) {
      tradesList.removeWhere((trade) => trade.id.toString() == data.id);
    }
  }

  void selectTrade(JobFormTradeWorkTypeData data) {

    // initializing local data holder
    List<JPSingleSelectModel> tradesList = [];
    JPSingleSelectModel? previousSelectedTrade;

    // filtering options list before displaying
    tradesList.addAll(allTrades);
    for (var selectedTrade in tradesAlreadySelected) {
      // item selected by current dropdown should not be removed
      if (selectedTrade.id == data.selectedTradeId) {
        previousSelectedTrade = selectedTrade;
        continue;
      }
      // removing items selected by other dropdowns
      tradesList.remove(selectedTrade);
    }

    // displaying single select
    FormValueSelectorService.openSingleSelect(
        title: 'select_trade'.tr,
        list: tradesList,
        controller: data.tradeController,
        selectedItemId: data.selectedTradeId,
        onValueSelected: (val) {
          final selectedTrade = FormValueSelectorService.getSelectedSingleSelect(allTrades, val);
          data.setWorkTypesFromTrade(selectedTrade);
          removeFromAlreadySelectedTrade(previousSelectedTrade);
          addToAlreadySelectedTrade(selectedTrade);
          onDataChanged("");
          update();
        },
    );
  }

  void selectWorkType(JobFormTradeWorkTypeData data) {
    FormValueSelectorService.openMultiSelect(
        title: 'select_work_type'.tr,
        list: data.workTypeList,
        controller: data.workTypeController,
        onSelectionDone: () {
          for (var workType in data.workTypeList) {
            if (workType.isSelect) addWorkType(workType);
            if (!workType.isSelect) removeWorkType(workType.id);
          }
          update();
        }
    );
  }

  bool validateForm({bool scrollOnValidate = true}) {
    bool validationFailed = false;
    validateFormOnDataChange = true;
    validationFailed = formKey.currentState?.validate() ?? false;
    if(scrollOnValidate && !validationFailed)  scrollToErrorField();
    return !validationFailed;
  }

  void scrollToErrorField() {
    // validating each fields
    for (var field in tradeWorkTypeList) {
      if(FormValidator.requiredFieldValidator(field.tradeController.text) != null) {
        field.tradeController.scrollAndFocus();
        break;
      }
    }
  }

  Future<void> onDataChanged(String value) async {
    if(validateFormOnDataChange) {
      await Future.delayed(const Duration(milliseconds: 50), () => formKey.currentState?.validate());
    }
  }

  /// [isAnyTradeWithOtherType] is used to show/hide `Other Trade Description` input
  bool isAnyTradeWithOtherType() {
    return tradeWorkTypeList.any((trade) => trade.showOtherField);
  }
}