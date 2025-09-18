
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/clock_summary.dart';
import 'package:jobprogress/common/enums/page_type.dart';
import 'package:jobprogress/common/models/clock_summary/clock_summary_request_params.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/DatePicker/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ClockSummaryFilterController extends GetxController {

  ClockSummaryFilterController(this.filterKeys);

  ClockSummaryRequestParams filterKeys; // contains applied filters

  ClockSummaryRequestParams tempFilterKeys = ClockSummaryRequestParams(); // used for temporary filter editing
  TextEditingController usersController = TextEditingController();
  TextEditingController divisionsController = TextEditingController();
  TextEditingController tradeTypesController = TextEditingController();
  TextEditingController customerTypeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController jobController = TextEditingController();

  late String selectedDuration;

  List<JPSingleSelectModel> durationsList = [
    JPSingleSelectModel(label: 'WTD'.tr, id: DurationType.wtd.toString()),
    JPSingleSelectModel(label: 'MTD'.tr, id: DurationType.mtd.toString()),
    JPSingleSelectModel(label: 'YTD'.tr, id: DurationType.ytd.toString()),
    JPSingleSelectModel(label: 'last_month'.tr, id: DurationType.lastMonth.toString()),
    JPSingleSelectModel(label: 'custom'.tr, id: DurationType.custom.toString()),
  ];

  @override
  void onInit() {
    setFilterValues(filterKeys);
    super.onInit();
  }

  // setFilterValues() will set dialog filter as per param 'keys' given to it
  void setFilterValues(ClockSummaryRequestParams keys) {

    tempFilterKeys = ClockSummaryRequestParams.copy(keys);

    setDurationFilter(tempFilterKeys.durationType.toString());

    usersController.text = getInputFieldText(tempFilterKeys.users!.where((element) => element.isSelect).toList());
    divisionsController.text = getInputFieldText(tempFilterKeys.divisions!.where((element) => element.isSelect).toList());
    tradeTypesController.text = getInputFieldText(tempFilterKeys.tradeTypes!.where((element) => element.isSelect).toList());
    customerTypeController.text = getInputFieldText(tempFilterKeys.customerType!.where((element) => element.isSelect).toList());
    dateController.text = DateTimeHelper.convertHyphenIntoSlash(tempFilterKeys.date ?? "");
    jobController.text = keys.jobName ?? '';
  }

  // showSelectionSheet() will display multiselect filter sheet
  void showSelectionSheet(ClockSummaryFilterType type) {
    showJPBottomSheet(
      child: (_) => JPMultiSelect(
        mainList: typeToMainList(type)!,
        inputHintText: 'search_here'.tr,
        title: typeToSheetTitle(type),
        subList: (type == ClockSummaryFilterType.user) ? tempFilterKeys.tags : [],
        canShowSubList: tempFilterKeys.tags!.isNotEmpty ? (type == ClockSummaryFilterType.user) : false,
        onDone: (list) {
          typeToAction(list, type);
          Get.back();
        },
      ),
      isScrollControlled: true,
    );
  }

  String typeToSheetTitle(ClockSummaryFilterType type) {
    switch (type) {
      case ClockSummaryFilterType.user:
        return 'select_users'.tr.toUpperCase();

      case ClockSummaryFilterType.division:
        return 'select_divisions'.tr.toUpperCase();

      case ClockSummaryFilterType.tradeType:
        return 'select_trade_type'.tr.toUpperCase();

      case ClockSummaryFilterType.customerType:
        return 'select_customer_type'.tr.toUpperCase();

      default:
        return "";
    }
  }

  List<JPMultiSelectModel>? typeToMainList(ClockSummaryFilterType type) {
    switch (type) {
      case ClockSummaryFilterType.user:
        return tempFilterKeys.users;

      case ClockSummaryFilterType.division:
        return tempFilterKeys.divisions;

      case ClockSummaryFilterType.tradeType:
        return tempFilterKeys.tradeTypes;

      case ClockSummaryFilterType.customerType:
        return tempFilterKeys.customerType;

      default:
        return [];
    }
  }

  void typeToAction(List<JPMultiSelectModel> list, ClockSummaryFilterType type) {

    final selectedValuesList = list.where((element) => element.isSelect).toList(); // filtering selected options

    switch (type) {
      case ClockSummaryFilterType.user:
        tempFilterKeys.users = list;
        usersController.text = getInputFieldText(selectedValuesList);
        break;

      case ClockSummaryFilterType.division:
        tempFilterKeys.divisions = list;
        divisionsController.text = getInputFieldText(selectedValuesList);
        break;

      case ClockSummaryFilterType.tradeType:
        tempFilterKeys.tradeTypes = list;
        tradeTypesController.text = getInputFieldText(selectedValuesList);
        break;

      case ClockSummaryFilterType.duration:
        break;

      case ClockSummaryFilterType.customerType:
        tempFilterKeys.customerType = list;
        customerTypeController.text = getInputFieldText(selectedValuesList);
        break;

      case ClockSummaryFilterType.job:
        break;
    }

    update();
  }

  // getInputFieldText() will return string generated from selected options
  String getInputFieldText(List<JPMultiSelectModel> selectedValuesList) {

    String tempData = "";

    if(selectedValuesList.isEmpty) return tempData;

    for (JPMultiSelectModel data in selectedValuesList) {
      tempData += "${data.label}, ";
    }
    return tempData.replaceRange(tempData.length - 2, tempData.length, "");
  }

  void showDurationSelector() {
    SingleSelectHelper.openSingleSelect(
        durationsList,
        selectedDuration,
        'select_duration'.tr,
            (value) {
          setDurationFilter(value);
          Get.back();
            },
      isFilterSheet: true
    );
  }

  void pickDate() async {

    final initialDate = tempFilterKeys.date == null
        ? null
        : DateTime.parse(DateTimeHelper.convertSlashIntoHyphen(tempFilterKeys.date!));

    DateTime? dateTime = await Get.dialog(
      JPDatePicker(
        initialDate: initialDate,
      )
    );

    if(dateTime != null) {
      tempFilterKeys.date = DateTimeHelper.format(dateTime, DateFormatConstants.dateServerFormat);
      dateController.text = DateTimeHelper.format(dateTime, DateFormatConstants.dateOnlyFormat);
      update();
    }
  }

  void setDurationFilter(String value) {
    selectedDuration = value;
    tempFilterKeys.durationType = getDurationTypeEnum(value);
    update();
  }

  DurationType getDurationTypeEnum(String value) {
    switch (value) {
      case "DurationType.wtd":
        return DurationType.wtd;

      case "DurationType.mtd":
        return DurationType.mtd;

      case "DurationType.ytd":
        return DurationType.ytd;

      case "DurationType.lastMonth":
        return DurationType.lastMonth;

      case "DurationType.custom":
        return DurationType.custom;

      default:
        return DurationType.mtd;
    }
  }

  void pickStartDate() async {
    final firstDate = DateTime.parse(DateTimeHelper.convertSlashIntoHyphen(tempFilterKeys.startDate!));

    DateTime? selectedDate = await Get.dialog(
      JPDatePicker(
        initialDate: firstDate,
        helpText: 'start_date'.tr,
      )
    );

    if(selectedDate != null) {
      tempFilterKeys.startDate = DateTimeHelper.format(selectedDate.toString(), DateFormatConstants.dateServerFormat);
      update();
    }

  }

  void pickEndDate() async {
    final firstDate = DateTime.parse(DateTimeHelper.convertSlashIntoHyphen(tempFilterKeys.endDate!));

    DateTime? selectedDate = await Get.dialog(
      JPDatePicker(
        initialDate: firstDate,
        helpText: 'end_date'.tr,
      )
    );

    if(selectedDate != null) {
      tempFilterKeys.endDate = DateTimeHelper.format(selectedDate.toString(), DateFormatConstants.dateServerFormat);
      update();
    }

  }

  void setDefaultKeys(ClockSummaryRequestParams defaultKeys) {
    setFilterValues(defaultKeys);
  }

  bool isResetButtonDisabled(ClockSummaryRequestParams defaultKeys) {
    return tempFilterKeys == defaultKeys;
  }

  bool isJobDisabled() {
    return filterKeys.jobId != null || filterKeys.jobName == 'without_job'.tr;
  }

  bool isDivisionDisabled() {
    return filterKeys.jobName == 'without_job'.tr;
  }

  bool isUsersDisabled() {
    return AuthService.isPrimeSubUser() || 
      AuthService.isStandardUser() || 
      PermissionService.hasUserPermissions(['view_clock_in_clock_out_report']);
  }

  bool isDateFieldVisible() {
    return filterKeys.date != null;
  }

  bool validateAndApply() {
    final startDate = DateTime.parse(DateTimeHelper.convertSlashIntoHyphen(tempFilterKeys.startDate!));
    final endDate = DateTime.parse(DateTimeHelper.convertSlashIntoHyphen(tempFilterKeys.endDate!));
    if(startDate.compareTo(endDate) == 1) {
      Helper.showToastMessage('end_date_should_not_be_greater_than_start_date'.tr);
      return false;
    }

    return true;
  }

  Future<void> selectJob() async {

    final job = await Get.toNamed(Routes.customerJobSearch, arguments: {
      NavigationParams.pageType : PageType.selectJob,
    }, preventDuplicates: false);

    if(job != null) {
      tempFilterKeys.jobModel = job;
      String? customerName = tempFilterKeys.jobModel?.customer?.fullName;
      jobController.text =  (customerName != null
          ? '$customerName / '
          : '') + Helper.getJobName(job);
      updateJobName(jobController.text);
    }
    update();
  }

  void updateJobName(String val) {
    tempFilterKeys.jobName = val;

    if(val.isEmpty) {
      tempFilterKeys.jobModel = null;
      update();
    }
  }

}