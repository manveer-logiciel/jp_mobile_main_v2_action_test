
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/calendars.dart';
import 'package:jobprogress/common/enums/network_multiselect.dart';
import 'package:jobprogress/common/models/calendars/calendar_filters.dart';
import 'package:jobprogress/common/models/calendars/calendars_request_params.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/network_multiselect/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';

class StaffCalendarFilterDialogController extends GetxController {

  StaffCalendarFilterDialogController(this.params, this.isProductionCalendar);

  final CalendarsRequestParams params; // params contain applied filters

  final bool isProductionCalendar;

  late CalendarsRequestParams tempFilterKeys; // used to store updated filters

  // setting up controllers
  TextEditingController customerNameToController = TextEditingController();
  TextEditingController workTypesController = TextEditingController();
  TextEditingController assignedToController = TextEditingController();
  TextEditingController divisionsController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController companyCrewController = TextEditingController();
  TextEditingController labourSubController = TextEditingController();
  TextEditingController tradeTypeController = TextEditingController();
  TextEditingController jobFlagController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  List<JPMultiSelectModel> workTypes = [];

  @override
  void onInit() {
    setFilterValues(params);
    super.onInit();
  }

  // setFilterValues() : will set up text controllers to display selected values
  void setFilterValues(CalendarsRequestParams keys) {

    tempFilterKeys = CalendarsRequestParams.copy(keys);
    tempFilterKeys.filter = CalendarFilterModel.copy(keys.filter!);

    assignedToController.text = getInputFieldText(tempFilterKeys.users?.where((element) => element.isSelect).toList());
    divisionsController.text = getInputFieldText(tempFilterKeys.divisions?.where((element) => element.isSelect).toList());
    categoryController.text = getInputFieldText(tempFilterKeys.category?.where((element) => element.isSelect).toList());
    companyCrewController.text = getInputFieldText(tempFilterKeys.companyCrew?.where((element) => element.isSelect).toList());
    labourSubController.text = getInputFieldText(tempFilterKeys.labourSub?.where((element) => element.isSelect).toList());
    tradeTypeController.text = getInputFieldText(tempFilterKeys.tradeTypes?.where((element) => element.isSelect).toList());
    jobFlagController.text = getInputFieldText(tempFilterKeys.jobFlag?.where((element) => element.isSelect).toList());
    cityController.text = getInputFieldText(tempFilterKeys.city?.where((element) => element.isSelect).toList());

    if(isProductionCalendar) {
      customerNameToController.text = tempFilterKeys.customerName ?? "";
      workTypes = tempFilterKeys.workTypes ?? [];
      setWorkTypeList(
          tempFilterKeys.tradeTypes?.where((element) => element.isSelect)
              .toList());
    }
  }

  // getInputFieldText converts selected values to comma separated string
  String getInputFieldText(List<JPMultiSelectModel>? selectedValuesList) {

    if(selectedValuesList == null || selectedValuesList.isEmpty) return "";

    return selectedValuesList.map((e) => e.label.toString()).join(', ');

  }

  // showSelectionSheet() : displays filter sheet to select from
  void showSelectionSheet(CalendarFilterType type) {
    showJPBottomSheet(
      child: (_) => JPMultiSelect(
        mainList: typeToMainList(type) ?? [],
        inputHintText: 'search_here'.tr,
        title: typeToSheetTitle(type),
        subList: (type == CalendarFilterType.assignedTo || type == CalendarFilterType.companyCrew) ? tempFilterKeys.tags : [],
        canShowSubList: tempFilterKeys.tags!.isNotEmpty ? (type == CalendarFilterType.assignedTo || type == CalendarFilterType.companyCrew) : false,
        onDone: (list) {
          typeToAction(list, type);
          Get.back();
        },
      ),
      isScrollControlled: true,
      ignoreSafeArea: true,
      enableDrag: true,
    );
  }

  // typeToMainList() :  helps in filtering selection list
  List<JPMultiSelectModel>? typeToMainList(CalendarFilterType type) {
    switch (type) {

      case CalendarFilterType.assignedTo:
        return tempFilterKeys.users;

      case CalendarFilterType.divisions:
        return tempFilterKeys.divisions;

      case CalendarFilterType.category:
        return tempFilterKeys.category;

      case CalendarFilterType.companyCrew:
        return tempFilterKeys.companyCrew;

      case CalendarFilterType.subContractor:
        return tempFilterKeys.labourSub;

      case CalendarFilterType.tradeType:
        return tempFilterKeys.tradeTypes;

      case CalendarFilterType.jobFlag:
        return tempFilterKeys.jobFlag;

      case CalendarFilterType.city:
        return tempFilterKeys.city;

      case CalendarFilterType.workType:
        return tempFilterKeys.workTypes;

    }
  }

  String typeToSheetTitle(CalendarFilterType type) {
    switch (type) {
      case CalendarFilterType.assignedTo:
        return "select_users".tr;

      case CalendarFilterType.divisions:
        return 'select_divisions'.tr;

      case CalendarFilterType.category:
        return 'select_categories'.tr;

      case CalendarFilterType.companyCrew:
        return 'select_company_crews'.tr;

      case CalendarFilterType.subContractor:
        return 'select_sub_contractors'.tr;

      case CalendarFilterType.tradeType:
        return 'select_trade_types'.tr;

      case CalendarFilterType.jobFlag:
        return 'select_job_flags'.tr;

      case CalendarFilterType.city:
        return 'select_cities'.tr;

      case CalendarFilterType.workType:
        return 'select_work_types'.tr;

    }
  }

  // typeToAction() : update selected filters on the basis of opened filter type
  void typeToAction(List<JPMultiSelectModel> list, CalendarFilterType type) {

    final selectedValuesList = list.where((element) => element.isSelect).toList(); // filtering selected options

    switch (type) {
      case CalendarFilterType.assignedTo:

        if(selectedValuesList.isEmpty) {
          final loggedInUser = list.firstWhere((element) => element.id == AuthService.userDetails!.id.toString());
          loggedInUser.isSelect = true;
          selectedValuesList.add(loggedInUser);
        }

        tempFilterKeys.users = list;
        assignedToController.text = getInputFieldText(selectedValuesList);
        tempFilterKeys.filter?.users = setSettingFilterList<String>(selectedValuesList);
        break;

      case CalendarFilterType.divisions:
        tempFilterKeys.divisions = list;
        divisionsController.text = getInputFieldText(selectedValuesList);
        tempFilterKeys.filter?.divisionIds = setSettingFilterList<String>(selectedValuesList);
        break;

      case CalendarFilterType.category:
        tempFilterKeys.category = list;
        categoryController.text = getInputFieldText(selectedValuesList);
        tempFilterKeys.filter?.categoryIds = setSettingFilterList<String>(selectedValuesList);
        break;

      case CalendarFilterType.companyCrew:
        tempFilterKeys.companyCrew = list;
        companyCrewController.text =  getInputFieldText(selectedValuesList);
        tempFilterKeys.filter?.jobRepIds = setSettingFilterList<String>(selectedValuesList);
        break;

      case CalendarFilterType.subContractor:
        tempFilterKeys.labourSub = list;
        labourSubController.text = getInputFieldText(selectedValuesList);
        tempFilterKeys.filter?.subIds = setSettingFilterList<String>(selectedValuesList);
        break;

      case CalendarFilterType.tradeType:
        tempFilterKeys.tradeTypes = list;
        tradeTypeController.text = getInputFieldText(selectedValuesList);
        tempFilterKeys.filter?.trades = setSettingFilterList<String>(selectedValuesList);
        setWorkTypeList(selectedValuesList);
        break;

      case CalendarFilterType.jobFlag:
        tempFilterKeys.jobFlag = list;
        jobFlagController.text = getInputFieldText(selectedValuesList);
        tempFilterKeys.filter?.jobFlagIds = setSettingFilterList<String>(selectedValuesList);
        break;

      case CalendarFilterType.workType:
        tempFilterKeys.workTypes = list;
        workTypesController.text = getInputFieldText(selectedValuesList);
        tempFilterKeys.filter?.workTypeIds = setSettingFilterList<String>(selectedValuesList);
        workTypes = list;
        break;

      default:
          break;

    }

    update();
  }

  // setSettingFilterList() : returns list to be passed in setting api for storing settings
  List<T> setSettingFilterList<T>(List<JPMultiSelectModel> list) {
    List<T> tempList = [];
    for (var element in list) {
      if(T == int) {
        tempList.add(int.parse(element.id.toString()) as T);
      } else if (T == String) {
        tempList.add(element.id.toString() as T);
      }
    }
    return tempList;
  }

  // setDefaultKeys() : will reset filters
  void setDefaultKeys(CalendarsRequestParams defaultKeys) {
    setFilterValues(defaultKeys);
    update();
  }

  bool isResetButtonDisabled(CalendarsRequestParams defaultKeys) {
    return defaultKeys == tempFilterKeys;
  }

  void showNetworkMultiSelect() {
    showJPBottomSheet(
        child: (_) {
          return JPNetworkMultiSelect(
            title: 'select_cities'.tr,
            inputHintText: 'search_here'.tr,
            selectedItems: tempFilterKeys.city ?? [],
            onDone: (selectedCities) {
              tempFilterKeys.city = selectedCities;
              cityController.text = getInputFieldText(selectedCities);
              tempFilterKeys.filter?.cities = setSettingFilterList<String>(selectedCities);
            },
            type: JPNetworkMultiSelectType.cities,
          );
        },
      isScrollControlled: true
    );
  }

  void toggleScheduleVisibility(bool val){
    tempFilterKeys.filter!.isScheduleHidden  = val;
    update();
  }

  void setWorkTypeList(List<JPMultiSelectModel>? list) {

    if(!isProductionCalendar) return;

    List<JPMultiSelectModel> tempWorkTypeList = [];
    for (var data in list ?? []) {
      for(JPMultiSelectModel subData in data.subList ?? []) {
        subData.isSelect = workTypes.any((element) => element.id == subData.id && element.isSelect);
        tempWorkTypeList.add(subData);
      }
    }

    tempFilterKeys.workTypes = workTypes = tempWorkTypeList;

    var selectedList = tempWorkTypeList.where((element) => element.isSelect).toList();

    workTypesController.text = getInputFieldText(selectedList);
    tempFilterKeys.filter?.workTypeIds = setSettingFilterList<String>(selectedList);
  }

}