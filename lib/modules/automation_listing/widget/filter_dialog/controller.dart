import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/automation/filter.dart';
import 'package:jobprogress/common/models/sql/division/division.dart';
import 'package:jobprogress/common/models/sql/division/division_param.dart';
import 'package:jobprogress/common/repositories/sql/division.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';

import '../../../../common/enums/date_picker_type.dart';
import '../../../../core/constants/date_formats.dart';
import '../../../../core/constants/dropdown_list_constants.dart';
import '../../../../core/utils/date_time_helpers.dart';
import '../../../../core/utils/multi_select_helper.dart';
import '../../../../core/utils/single_select_helper.dart';

class AutomationFilterDialogController extends GetxController {

  late AutomationFilterModel filterKeys;
  late AutomationFilterModel defaultKeys;

  late String selectedDuration;

  bool isResetButtonDisable = true;

  List<JPMultiSelectModel> divisionList = [];

  TextEditingController divisionsTextController = TextEditingController();
  TextEditingController durationTextController = TextEditingController();

  final bool skipDivisionFetch;

  AutomationFilterDialogController(
    AutomationFilterModel selectedFilters,
    this.defaultKeys, {
    this.skipDivisionFetch = false,
  }) {
    setDefaultKeys(selectedFilters);
  }

  void setDefaultKeys(AutomationFilterModel params) {
    filterKeys = AutomationFilterModel.copy(params);

    if (!skipDivisionFetch) {
      ///   Divisions
      DivisionParamModel divisionParams = DivisionParamModel(
        includes: ['users'],
        limit: -1,
      );
      SqlDivisionRepository().get(params: divisionParams).then((divisionList) {
        divisionsTextController.text = "";
        divisionList.data.insert(
            0, DivisionModel(id: 0, name: "unassigned".tr, companyId: 0));
        if (filterKeys.divisionIds?.isNotEmpty ?? false) {
          for (int i = 0; i < divisionList.data.length; i++) {
            this.divisionList.add(JPMultiSelectModel(
                id: divisionList.data[i].id.toString(),
                label: divisionList.data[i].name,
                isSelect: false));
            for (int j = 0; j < filterKeys.divisionIds!.length; j++) {
              if (divisionList.data[i].id == filterKeys.divisionIds![j]) {
                this.divisionList[i].isSelect = true;
                divisionsTextController.text = divisionsTextController.text +
                    (divisionsTextController.text.isEmpty ? "" : ", ") +
                    divisionList.data[i].name;
                break;
              }
            }
          }
        } else {
          for (var element in divisionList.data) {
            this.divisionList.add(
              JPMultiSelectModel(
              id: element.id.toString(),
              label: element.name,
              isSelect: false)
            );
          }
        }
      });
    }

    selectedDuration = filterKeys.duration ?? "";
    durationTextController.text = DropdownListConstants.durationsList
      .firstWhereOrNull((element) => element.id == selectedDuration)?.label ??
      "";
    updateResetButtonDisable();
  }

  void openDivisionSelector() {
    MultiSelectHelper.openMultiSelect(
      title: 'select_divisions'.tr.toUpperCase(),
      mainList: divisionList,
      callback: (List<JPMultiSelectModel> selectedDivisions) {
          updateDivisions(selectedDivisions);
        Get.back();
        updateResetButtonDisable();
      }
    );
  }

  void openDurationSelector() {
    SingleSelectHelper.openSingleSelect(
      DropdownListConstants.durationsList,
      selectedDuration,
      'select_duration'.tr.toUpperCase(),
      (value) {
        updateDuration(value);
        Get.back();
        updateResetButtonDisable();
      },
      isFilterSheet: true
    );
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

  void updateDivisions(List<JPMultiSelectModel> selectedDivisions) {
    divisionsTextController.text = "";
    filterKeys.divisionIds = [];
    divisionList = selectedDivisions;

    for (var element in selectedDivisions) {
      if (element.isSelect) {
        filterKeys.divisionIds!.add(int.parse(element.id));
      }
    }
    
    divisionsTextController.text = selectedDivisions
      .where((element) => element.isSelect)
      .map((element) => element.label)
      .join(", ");
  }

  void updateDuration(String value) {
    selectedDuration = value;
    filterKeys.duration = value;
    durationTextController.text = DropdownListConstants.durationsList.firstWhereOrNull((element) => element.id == value)?.label ?? "";
  }

  void updateResetButtonDisable() {
    isResetButtonDisable = filterKeys.toJson().toString() == defaultKeys.toJson().toString();
    update();
  }

  void cleanFilterKeys({AutomationFilterModel? defaultFilters}) {
    divisionsTextController.text = '';
    durationTextController.text = "";
    selectedDuration = filterKeys.duration ?? "";
    filterKeys.divisionIds = [];
    divisionList.clear();

    setDefaultKeys(defaultFilters!);
  }

  void applyFilter(void Function(AutomationFilterModel params) onApply) {

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
    durationTextController.dispose();
    super.onClose();
  }

  String getStartDate() => Helper.isValueNullOrEmpty(filterKeys.startDate)
      ? "start_date".tr
      : DateTimeHelper.convertHyphenIntoSlash(filterKeys.startDate!);

  String getEndDate() => Helper.isValueNullOrEmpty(filterKeys.endDate)
      ? "end_date".tr
      : DateTimeHelper.convertHyphenIntoSlash(filterKeys.endDate!);
}
