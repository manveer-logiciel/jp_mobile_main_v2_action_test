import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/clock_summary.dart';
import 'package:jobprogress/common/models/appointment/appointment_param.dart';
import 'package:jobprogress/common/models/appointment/appointment_result/appointment_result_options.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/duration_type_constant.dart';
import 'package:jobprogress/core/constants/user_roles.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jp_mobile_flutter_ui/DatePicker/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class AppointmentsFilterController extends GetxController {

  final List<UserModel>? userList;
  final List<AppointmentResultOptionsModel>? appointmentResultList;

  AppointmentsFilterController( AppointmentListingParamModel selectedFilters, { this.userList, this.appointmentResultList}) {
    if(userList != null && appointmentResultList != null){
      getAlldata(selectedFilters);
    }
  }

  AppointmentListingParamModel filterKeys = AppointmentListingParamModel();

  TextEditingController titleController = TextEditingController();
  TextEditingController jobAltIdController = TextEditingController();
  TextEditingController jobNumberController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController assignedToController = TextEditingController();
  TextEditingController durationTypeController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController createdByController = TextEditingController();
  TextEditingController appointmentResultController = TextEditingController();

  bool isResetButtonDisable = true;
  bool isExcludeRecurring = false;
  bool isExcludeRecurringSelected = false;
  
  UserModel? selectedCreatedUser;
  String selectedDuration = DurationType.mtd.toString();

  List<JPMultiSelectModel>? selectedUsers;
  List<JPMultiSelectModel>? selectedAppointmentResultList;
  List<JPMultiSelectModel>? selectedDurationTypeList;
  List<int>? count;

  List<JPSingleSelectModel> durationsList = [
    JPSingleSelectModel(label: 'upcoming'.tr, id: DurationType.upcoming.toString()),
    JPSingleSelectModel(label: 'today'.tr, id: DurationType.today.toString()),
    JPSingleSelectModel(label: 'WTD'.tr, id: DurationType.wtd.toString()),
    JPSingleSelectModel(label: 'MTD'.tr, id: DurationType.mtd.toString()),
    JPSingleSelectModel(label: 'YTD'.tr, id: DurationType.ytd.toString()),
    JPSingleSelectModel(label: 'last_month'.tr, id: DurationType.lastMonth.toString()),
    JPSingleSelectModel(label: 'since_inception'.tr, id: DurationType.sinceInception.toString()),
    JPSingleSelectModel(label: 'custom'.tr, id: DurationType.custom.toString()),
  ];


  void getAlldata(AppointmentListingParamModel selectedFilters) async {
    setDefaultKeys(selectedFilters);
  }

  void setDefaultKeys(AppointmentListingParamModel params) {
    filterKeys =  params;
    selectedUsers = [];
    selectedAppointmentResultList = [];
    selectedDurationTypeList = [];
  
    if(filterKeys.assignedTo != null) {
      for (String e in filterKeys.assignedTo!) {
        UserModel? user = userList?.firstWhereOrNull((element) => element.id.toString() == e);
        if(user != null) {
          selectedUsers!.add(JPMultiSelectModel(id: user.id.toString(),
              isSelect: true,
              label: user.fullName,
              child: JPProfileImage(src: user.profilePic,
                  color: user.color,
                  initial: user.intial)));
        }
      }
    }

    if(filterKeys.appointmentResultOption != null) {
      for (String e in filterKeys.appointmentResultOption!) {
        AppointmentResultOptionsModel result = appointmentResultList!.firstWhere((element) => element.id.toString() == e);
        if(selectedAppointmentResultList != null){
          selectedAppointmentResultList!.add(JPMultiSelectModel(id: result.id.toString(), isSelect: true, label: result.name!));
        }
      }
    }

     if(filterKeys.dateRangeType != null) {
      for (String e in filterKeys.dateRangeType!) {
        String key = DurationTypeConstants.durationTypes.keys.firstWhere((element) => element.toString() == e);
        if(selectedDurationTypeList != null){
          selectedDurationTypeList!.add(JPMultiSelectModel(id: key.toString(), isSelect: true, label: DurationTypeConstants.durationTypes[key].toString()));
        }
      }
    }

    if(filterKeys.createdBy != null) {     
        selectedCreatedUser = userList!.firstWhere((element) => element.id == filterKeys.createdBy);      
    }

    titleController.text = filterKeys.title ?? '';
    jobAltIdController.text = filterKeys.jobAltId ?? '';
    jobNumberController.text = filterKeys.jobNumber ?? '';
    locationController.text = filterKeys.location ?? '';
    assignedToController.text = selectedUsers != null ? selectedUsers!.map((element) => element.label).join(', ') : '';
    createdByController.text = getNoneValue();
    appointmentResultController.text = selectedAppointmentResultList != null ?  selectedAppointmentResultList!.map((element) => element.label).join(', ') : '';
    durationTypeController.text = selectedDurationTypeList != null ?  selectedDurationTypeList!.map((element) => element.label).join(', ') : '';
    selectedDuration = getDurationType(filterKeys.duration);
    isExcludeRecurringSelected = filterKeys.excludeRecurring;
    updateResetButtonDisable();
  }

  String getDurationType(String value) {
    switch (value) {
      case "WTD":
        return DurationType.wtd.toString();

      case "MTD":
        return DurationType.mtd.toString();

      case "YTD":
        return DurationType.ytd.toString();

      case "last_month":
        return DurationType.lastMonth.toString();

      case "DUR":
        return DurationType.custom.toString();

      case "since_inception":
        return DurationType.sinceInception.toString();
      
      case "upcoming":
        return DurationType.upcoming.toString();

      case "today":
        return DurationType.today.toString();

      default:
        return DurationType.upcoming.toString();
    }
  }


  void applyFilter() {
    filterKeys.title = titleController.text.trim().isEmpty ? null : titleController.text.trim();
    filterKeys.jobAltId = jobAltIdController.text.trim().isEmpty ? null : jobAltIdController.text.trim();
    filterKeys.jobNumber = jobNumberController.text.trim().isEmpty ? null : jobNumberController.text.trim();
    filterKeys.location = locationController.text.trim().isEmpty ? null : locationController.text.trim();
    filterKeys.createdBy =  selectedCreatedUser?.id;
    filterKeys.assignedTo = selectedUsers?.map((element) => element.id).toList();
    filterKeys.appointmentResultOption = selectedAppointmentResultList?.map((element) => element.id).toList();
    filterKeys.dateRangeType = selectedDurationTypeList?.map((element) => element.id).toList();
    filterKeys.duration = getDurationTypeEnum(selectedDuration);
    filterKeys.excludeRecurring = isExcludeRecurring;
    Get.back(); 
  }

  void toggleIsExcludeRecurringSelected(bool val) => isExcludeRecurringSelected = val; // toggle to update is all day or not

  // onExcludeRecurringChanged(): toggles to exclude recurring
  void onExcludeRecurringChanged(bool val) {
    isExcludeRecurring = val;
    toggleIsExcludeRecurringSelected(val);
    updateResetButtonDisable();
    update();
  }

  void filterByAssigneeTO() {
    List<JPMultiSelectModel> listForMultiSelect = [];
    for (UserModel user in userList!) {
      int index = -1;

      if(selectedUsers != null) index =  selectedUsers!.indexWhere((element) => element.id == user.id.toString());
      listForMultiSelect.add(
        JPMultiSelectModel(
          id: user.id.toString(),
          label:user.groupId == UserGroupIdConstants.subContractorPrime ? '${user.fullName} (${'sub'.tr})' : user.fullName,
          child:JPProfileImage(src: user.profilePic, color: user.color, initial: user.intial),
          isSelect: index != -1
        )
      );
    }
    showJPBottomSheet(
      isScrollControlled: true,
      child: ((controller) {
      return JPMultiSelect(
          mainList: listForMultiSelect,
          inputHintText: 'search_user'.tr,
          title: 'select_users'.tr,
          canDisableDoneButton: false,
          doneIcon: showJPConfirmationLoader(show: controller.isLoading),
          disableButtons: controller.isLoading,
          onDone: (value) {
            selectedUsers = value.where((e) => e.isSelect).toList();
            if (selectedUsers?.isEmpty ?? true) {
              selectedUsers = [
                JPMultiSelectModel(
                    id: AuthService.userDetails!.id.toString(),
                    label: AuthService.userDetails!.fullName,
                    isSelect: true,
                )
              ];
            }
            assignedToController.text = getInputFieldText(selectedUsers!);
            update();
            Get.back();
            updateResetButtonDisable();
          },
        );
    }));
  }

  void filterByAppointmentresult() {
    List<JPMultiSelectModel> listForMultiSelectResult = [];
    for (AppointmentResultOptionsModel result in appointmentResultList!) {
      int index = -1;

      if(selectedAppointmentResultList != null) index =  selectedAppointmentResultList!.indexWhere((element) => element.id == result.id.toString());
      listForMultiSelectResult.add(
        JPMultiSelectModel(
          id: result.id.toString(),
          label: result.name!,
          isSelect: index != -1
        )
      );
    }
    showJPBottomSheet(
      isScrollControlled: true,
      child: ((controller) {
      return JPMultiSelect(
          mainList: listForMultiSelectResult,
          inputHintText: 'search'.tr,
          title: 'select_appointment_result'.tr,
          canDisableDoneButton: false,
          doneIcon: showJPConfirmationLoader(show: controller.isLoading),
          disableButtons: controller.isLoading,
          onDone: (value) {
            selectedAppointmentResultList = value.where((e) => e.isSelect).toList();
            appointmentResultController.text = getInputFieldText(selectedAppointmentResultList!);
            update();
            Get.back();
            updateResetButtonDisable();
          },
        );
    }));
  }

void filterByDurationType() {
    List<JPMultiSelectModel> listForDurationTypeList = [];

    for (String key in DurationTypeConstants.durationTypes.keys) {
      int index = -1;

      if(selectedDurationTypeList != null) index =  selectedDurationTypeList!.indexWhere((element) => element.id == key.toString());
      listForDurationTypeList.add(
        JPMultiSelectModel(
          id: key,
          label: DurationTypeConstants.durationTypes[key].toString(),
          isSelect: index != -1
        )
      );
    }
    showJPBottomSheet(
      isScrollControlled: true,
      child: ((controller) {
      return JPMultiSelect(
          mainList: listForDurationTypeList,
          inputHintText: 'search_date_to_filter_by'.tr.capitalize,
          title: 'select_date_to_filter_by'.tr.capitalize!,
          canDisableDoneButton: false,
          doneIcon: showJPConfirmationLoader(show: controller.isLoading),
          disableButtons: controller.isLoading,
          onDone: (value) {
           selectedDurationTypeList = value.where((e) => e.isSelect).toList();
           durationTypeController.text = getInputFieldText(selectedDurationTypeList!);
           update();
           Get.back();
          updateResetButtonDisable();
          },
        );
    }));
  }

  String getNoneValue(){
   return createdByController.text = selectedCreatedUser != null ? selectedCreatedUser!.fullName : 'none'.tr;
  }

  void filterByCreatedBy() {  
    List<JPSingleSelectModel> createByList = userList!.map((user) => JPSingleSelectModel(
          id: user.id.toString(),
          label: user.fullName,
          child: JPProfileImage(src: user.profilePic,color: user.color,initial: user.intial,)
        )).toList();

    createByList.insert(
        0,
        JPSingleSelectModel(
            id: '-1',
            label: 'none'.tr,
            child: Image.asset('assets/images/profile-placeholder.png')));

    showJPBottomSheet(
      isScrollControlled: true,
      child: ((controller) {
      return JPSingleSelect(
        selectedItemId: selectedCreatedUser?.id.toString(),
        inputHintText: 'search_user'.tr,
        title: "select_created_by".tr.toUpperCase(),
        mainList: createByList,
        onItemSelect: (value) {
          selectedCreatedUser = userList!.firstWhereOrNull((user) => user.id == int.parse(value));
          getNoneValue();
          count = [];
          count!.add(selectedCreatedUser?.id ?? 0);
          update();
          Get.back();
          updateResetButtonDisable();
        });
      })
    );
  }

  void showDurationSelector() {
    SingleSelectHelper.openSingleSelect(
        durationsList,
        selectedDuration,
        'select_date_filter'.tr,
            (value) {
          setDurationFilter(value);
          Get.back();
            },
      isFilterSheet: true
    );
  }

  void setDurationFilter(String value) {
    selectedDuration = value;
    filterKeys.duration = getDurationTypeEnum(value).toString();
    setDuration();
    update();
  }

  String getDurationTypeEnum(String value) {
    switch (value) {
      case "DurationType.wtd":
        return 'WTD';

      case "DurationType.mtd":
        return 'MTD';

      case "DurationType.ytd":
        return 'YTD';

      case "DurationType.lastMonth":
        return 'last_month';

      case "DurationType.sinceInception":
        return 'since_inception';

      case "DurationType.custom":
        return 'DUR';
      case "DurationType.upcoming":
        return 'upcoming';
      
      case "DurationType.today":
        return 'today';

      default:
        return 'MTD';
    }
  }

  void pickStartDate() async {
    final firstDate = DateTime.parse(DateTimeHelper.convertSlashIntoHyphen(filterKeys.startDate!));

    DateTime? selectedDate = await Get.dialog(
      JPDatePicker(
        initialDate: firstDate,
        helpText: 'start_date'.tr,
      )
    );

    if(selectedDate != null) {
      filterKeys.startDate = DateTimeHelper.format(selectedDate.toString(), (DateFormatConstants.dateServerFormat));
      update();
    }

  }

  void pickEndDate() async {
    final firstDate = DateTime.parse(DateTimeHelper.convertSlashIntoHyphen(filterKeys.endDate!));

    DateTime? selectedDate = await Get.dialog(
      JPDatePicker(
        initialDate: firstDate,
        helpText: 'end_date'.tr,
      )
    );

    if(selectedDate != null) {
      filterKeys.endDate = DateTimeHelper.format(selectedDate.toString(), DateFormatConstants.dateServerFormat);
      update();
    }

  }
  
void setDuration() {

    late DateTime tempStartDate;
    late DateTime tempEndDate;
    DateTime today = DateTime.now();

    switch (filterKeys.duration) {
      case 'WTD':
        tempStartDate = today.subtract(Duration(days: today.weekday));
        tempEndDate = today;
        break;

      case 'MTD':
        tempStartDate = DateTime(today.year, today.month, 1);
        tempEndDate = today;
        break;

      case 'YTD':
        tempStartDate = DateTime(today.year, 1, 1);
        tempEndDate = today;
        break;

      case 'last_month':
        tempStartDate = DateTime(today.year, today.month - 1, 1);
        tempEndDate = today.subtract(Duration(days: today.day));
        break;

      case 'custom':
        tempStartDate = DateTime.parse(DateTimeHelper.convertSlashIntoHyphen(filterKeys.startDate!));
        tempEndDate = DateTime.parse(DateTimeHelper.convertSlashIntoHyphen(filterKeys.endDate!));
        break;

      default:
        tempStartDate = DateTime(today.year, today.month, 1);
        tempEndDate = today;
    }

    filterKeys.startDate = DateTimeHelper.format(tempStartDate, DateFormatConstants.dateServerFormat);
    filterKeys.endDate = DateTimeHelper.format(tempEndDate, DateFormatConstants.dateServerFormat);
  }

  void updateResetButtonDisable() {
    isResetButtonDisable = (
      titleController.text.isEmpty &&
      jobAltIdController.text.isEmpty &&
      jobNumberController.text.isEmpty && 
      locationController.text.isEmpty &&
      (assignedToController.text.isEmpty || !filterKeys.canSelectOtherUser!) &&
      createdByController.text == 'none'.tr &&
      appointmentResultController.text.isEmpty &&
      durationTypeController.text == DurationTypeConstants.durationTypes['appointment_duration_date'].toString() &&
      isExcludeRecurringSelected == false &&
      selectedDuration == 'DurationType.upcoming'
    );
    update();
  }

  void resetFilterKeys() {
    titleController.text = '';
    jobAltIdController.text = '';
    jobNumberController.text = '';
    locationController.text = '';
    createdByController.text = 'none'.tr;
    appointmentResultController.text = '';  
    durationTypeController.text = DurationTypeConstants.durationTypes['appointment_duration_date'].toString();
    selectedDuration =  getDurationType('upcoming');
    filterKeys.assignedTo = [AuthService.userDetails?.id.toString() ?? ""];
    selectedUsers = [
      JPMultiSelectModel(
        label: AuthService.userDetails?.fullName ?? '',
        id: AuthService.userDetails?.id.toString() ?? '',
        isSelect: true,
      ),
    ];
    selectedAppointmentResultList = [];
    selectedDurationTypeList = [];
    String key = DurationTypeConstants.durationTypes.keys.firstWhere((element) => element.toString() == 'appointment_duration_date');
    selectedDurationTypeList!.add(JPMultiSelectModel(id: key.toString(), isSelect: true, label: DurationTypeConstants.durationTypes[key].toString()));
    selectedCreatedUser = null;
    isExcludeRecurringSelected = false;
    isResetButtonDisable = true;
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

}