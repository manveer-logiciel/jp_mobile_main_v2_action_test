import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/recurring.dart';
import 'package:jobprogress/common/extensions/color/index.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/recurring_email.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/recurring_constant.dart';
import 'package:jobprogress/core/constants/work_flow_stage_color.dart';
import 'package:jobprogress/core/utils/color_helper.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:intl/intl.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class RecurringBottomSheetController extends GetxController {
  
  RecurringBottomSheetController(
    this.job, 
    this.recurringEmailData,
    this.type, 
    this.defaultDurationValue,
    this.recurringText,
    this.recurringStartDate
  );
  final JobModel? job;
  final RecurringEmailModel recurringEmailData;
  final RecurringType? type;
  final String? defaultDurationValue;
  final String? recurringText;
  final String? recurringStartDate;
  
  TextEditingController occuranceCount = TextEditingController();
  TextEditingController durationCount = TextEditingController();
  TextEditingController duration = TextEditingController();
  TextEditingController monthlyDuration = TextEditingController();
  TextEditingController occuranceOnController = TextEditingController();
  
  bool showRepeatValidateMessage = false;
  bool showOccuranceValidateMessage = false;
  bool occuranceActive = false;
  bool isDataValidate = false;
  bool occuranceNever = true;
  bool occuranceOn = false;
  

  String? selectedStageValue;
  Color? selectedStageColor;
  String currentDay = DateFormat(DateFormatConstants.fullday).format(DateTime.now()).substring(0,2).toUpperCase();
  String fullCurrentDay = DateFormat(DateFormatConstants.fullday).format(DateTime.now());
  String currentfullDate = DateTime.now().toString();
 
  List<JPSingleSelectModel> stages = [];
  List<JPSingleSelectModel> monthDurationList =[];
  
  double currentDate =  double.parse(DateFormat(DateFormatConstants.date).format(DateTime.now()));
  double weekNo = 0 ;
  String weekCount = '';
  
  String selectedDurationValue = '';
  String selectedMonthDurationValue = '';
  String selectedDate = '';
  late String selectedStage;
  
  List<JPMultiSelectModel> daysOfWeekList =[
    JPMultiSelectModel(id: RecurringConstants.sunday, label: 's'.tr.toUpperCase(), isSelect: false),
    JPMultiSelectModel(id: RecurringConstants.monday, label: 'm'.tr.toUpperCase(), isSelect: false),
    JPMultiSelectModel(id: RecurringConstants.tuesday, label: 't'.tr.toUpperCase(), isSelect: false),
    JPMultiSelectModel(id: RecurringConstants.wednesday, label: 'w'.tr.toUpperCase(), isSelect: false),
    JPMultiSelectModel(id: RecurringConstants.thursday, label: 't'.tr.toUpperCase(), isSelect: false),
    JPMultiSelectModel(id: RecurringConstants.friday, label: 'f'.tr.toUpperCase(), isSelect: false),
    JPMultiSelectModel(id: RecurringConstants.saturday, label: 's'.tr.toUpperCase(), isSelect: false),
  ];

  List<JPSingleSelectModel> durationsList = [
    JPSingleSelectModel(label: 'days'.tr, id: RecurringConstants.daily),
    JPSingleSelectModel(label: 'weeks'.tr.capitalize!, id: RecurringConstants.weekly),
    JPSingleSelectModel(label: 'months'.tr.capitalize!, id: RecurringConstants.monthly),
    JPSingleSelectModel(label: 'Years'.tr.capitalize!, id: RecurringConstants.yearly),
  ]; 
 
  void toggleRadioButton(bool val){
    occuranceActive = val;
    occuranceNever = false;
    occuranceOn = false;
    if(!val) showOccuranceValidateMessage = false;
    update();
  }

  void toggleNeverButton(bool val){
    occuranceNever = val;
    occuranceActive = false;
    occuranceOn = false;
    if(val) showOccuranceValidateMessage = false;
    update();
  }

  void toggleOnButton(bool val){
    occuranceOn = val;
    occuranceActive = false;
    occuranceNever = false;
    if(val) showOccuranceValidateMessage = false;
    update();
  }

  toggleDayOfWeek(int index){
    if(daysOfWeekList[index].isSelect) {
       daysOfWeekList[index].isSelect = false;
      if(daysOfWeekList.every((element) => element.isSelect == false)){
        daysOfWeekList.firstWhere((element) => element.id == currentDay).isSelect = true; 
      } 
    } else {
      daysOfWeekList[index].isSelect = true;
    }
    update();
  }

  void openSingleSelectForStages() {
    SingleSelectHelper.openSingleSelect(
      stages,
      selectedStage,
      'select'.tr.capitalize!,
      (value) {
        updateStage(value);
        Get.back();
      },
      isFilterSheet: true
    );
  }

  void openDatePicker() async {
  
    final selectDate = await DateTimeHelper.openDatePicker(
      initialDate: DateTime.now().toString(),
      isPreviousDateSelectionAllowed: false,
    );
    if (selectDate != null) {
      selectedDate = selectDate.toString();
      occuranceOnController.text = DateTimeHelper.convertHyphenIntoSlash(
          selectDate.toString().substring(0, 10));
    }
  }

  void openSingleSelectForMonth() {
    SingleSelectHelper.openSingleSelect(
      monthDurationList,
      selectedMonthDurationValue,
      'select'.tr.capitalize!,
      (value) {
        updateMonthData(value);
        Get.back();
      },
      isFilterSheet: true
    );
  }

  void openSingleSelectForDuration() { 
    SingleSelectHelper.openSingleSelect(
      durationsList,
      selectedDurationValue,
      'select'.tr.capitalize!,
      (value) {
        updateDurationType(value);
        Get.back();
      },
      isFilterSheet: true
    );
  }

  void updateMonthData(String value,) {
    selectedMonthDurationValue = value;
    monthlyDuration.text = SingleSelectHelper.getSelectedSingleSelectValue(monthDurationList, value);
  }

  void updateDurationType(String value) {
    selectedDurationValue = value;
    duration.text = SingleSelectHelper.getSelectedSingleSelectValue(durationsList, value);
    update();
  }

  void updateStage(String value) {
    selectedStage = value;
    selectedStageValue = SingleSelectHelper.getSelectedSingleSelectValue(stages, value);
    selectedStageColor = stages.firstWhere((element) => element.id == value).color;
    update();
  }
  
   void getMonthDurationListItem() {
    String defaultLabel = '${'monthly'.tr.capitalize!} ${'on'.tr}';
    weekNo = ((int.tryParse(DateTimeHelper.formatDate(recurringStartDate?.toString() ?? currentDate.toString(), DateFormatConstants.date)) ?? 0) / 7).ceilToDouble();
    
    if(weekNo == -1){
      weekCount = ''.tr;
    }
    if(weekNo == 5){
      weekCount = 'last'.tr;
    }
    if(weekNo == 4){
      weekCount = 'fourth'.tr;
    }
    if(weekNo == 3){
      weekCount = 'third'.tr;
    }
    if(weekNo == 2){
      weekCount = 'second'.tr;
    }
    if(weekNo == 1){
      weekCount = 'first'.tr;
    }
    /// clears the [monthDurationList]
    monthDurationList.clear();
    monthDurationList.add(
      JPSingleSelectModel(
        label: '$defaultLabel ${'day'.tr.toLowerCase()} ${recurringStartDate != null ? 
            DateTimeHelper.formatDate(recurringStartDate.toString(), DateFormatConstants.date) : currentDate.toInt().toString()}', 
        id: '0')
    );
    
    monthDurationList.add(
      JPSingleSelectModel(
        label: '$defaultLabel $weekCount ${recurringStartDate != null ? 
          DateTimeHelper.formatDate(recurringStartDate.toString(), DateFormatConstants.fullday).capitalize! : fullCurrentDay.capitalize!}', 
        id: '1'
      )
    );
    
    monthlyDuration.text = SingleSelectHelper.getSelectedSingleSelectValue(monthDurationList, '0');
  }

  void validateData(String value , String type){
    if(value.isEmpty || !GetUtils.isNum(value) || int.parse(value) <= 0){
      
      if(type == RecurringConstants.repeat){  
        showRepeatValidateMessage = true;
      } else {
        showOccuranceValidateMessage = true;
      }
      update();
    } else {
      if(type == RecurringConstants.repeat){
        showRepeatValidateMessage = false;
      } else{
        showOccuranceValidateMessage = false; 
      }
      update();
    }
  }

  String getCurrentDay(){
    return daysOfWeekList.firstWhere((element) => element.id == currentDay).id;
  }

  void saveData(){

    validateData(durationCount.text, RecurringConstants.repeat);
    
    if(occuranceActive){
      validateData(occuranceCount.text, RecurringConstants.occurrence);
    }

    if(!showOccuranceValidateMessage && !showRepeatValidateMessage && job != null){
      isDataValidate = true;
      recurringEmailData.startDateTime = fullCurrentDay;
      recurringEmailData.interval = int.tryParse(durationCount.text);
      recurringEmailData.repeat =  selectedDurationValue;
      recurringEmailData.currentStageCode = job?.currentStage!.code;
      recurringEmailData.endStageCode = selectedStage; 
      if(recurringEmailData.repeat == RecurringConstants.monthly){
        recurringEmailData.byMonth = SingleSelectHelper.getSelectedSingleSelectValue(monthDurationList, selectedMonthDurationValue);
        if(selectedMonthDurationValue == '1'){
          recurringEmailData.byDay =[(weekNo.toInt()).toString() + currentDay];   
        } else {
          recurringEmailData.byDay = [];
        }
      }
      
      if(recurringEmailData.repeat == RecurringConstants.weekly){
        List<String> bydays = [];
        for(int i = 0; i < daysOfWeekList.length; i++){
          if(daysOfWeekList[i].isSelect == true){
            bydays.add(daysOfWeekList[i].id);
          }  
       }
       recurringEmailData.byDay = bydays;
      }
      if(occuranceActive){
        recurringEmailData.occuranceActive = true;
        recurringEmailData.occurrence =  occuranceCount.text.isNotEmpty ? occuranceCount.text : null;
      //  recurringEmailData.occurenceon =  '';
      } else if (occuranceOn){
      //  recurringEmailData.occuranceOn = true;
        recurringEmailData.occurrence =  '';
      //  recurringEmailData.occurenceon =  dateController.text;
      } else {
        recurringEmailData.occuranceActive = false;
        recurringEmailData.occurrence = RecurringConstants.jobEndStageCode;
      }
    } 

    if(type == RecurringType.appointment) {

      //[isDataValidate] will validate form on basis of whether [showOccuranceValidateMessage] or [showRepeatValidateMessage] is true.
      isDataValidate = !showOccuranceValidateMessage && !showRepeatValidateMessage;

      recurringEmailData.startDateTime = recurringStartDate ?? fullCurrentDay;
      recurringEmailData.interval = int.tryParse(durationCount.text);
      recurringEmailData.repeat =  selectedDurationValue;
      if(recurringEmailData.repeat == RecurringConstants.monthly){
        recurringEmailData.byMonth = SingleSelectHelper.getSelectedSingleSelectValue(monthDurationList, selectedMonthDurationValue);
        if(selectedMonthDurationValue == '1'){
          recurringEmailData.byDay = [
            '${weekNo.toInt()}${recurringStartDate != null ? DateTimeHelper.formatDate(recurringStartDate.toString(), DateFormatConstants.fullday).substring(0,2).toUpperCase() : currentDay}'
          ];
        } else {
          recurringEmailData.byDay = [];
        }
      }
      
      if(recurringEmailData.repeat == RecurringConstants.weekly){
        List<String> bydays = [];
        for(int i = 0; i < daysOfWeekList.length; i++){
          if(daysOfWeekList[i].isSelect == true){
            bydays.add(daysOfWeekList[i].id);
          }  
       }
       recurringEmailData.byDay = bydays;
      }
      if(occuranceActive){
        recurringEmailData.occuranceActive = true;
        recurringEmailData.occuranceOn = false;
        recurringEmailData.occuranceNever = false;
        recurringEmailData.occurrence = occuranceCount.text.isNotEmpty ? occuranceCount.text : null;
        recurringEmailData.untilDate = null;
      } 
      else if(occuranceOn){
        recurringEmailData.occuranceOn = true;
        recurringEmailData.occuranceActive = false;
        recurringEmailData.occuranceNever = false;
        recurringEmailData.untilDate = selectedDate;
        recurringEmailData.occurrence = null;
      }
      else if(occuranceNever){
        recurringEmailData.occuranceOn = false;
        recurringEmailData.occuranceActive = false;
        recurringEmailData.occurrence = null;
        recurringEmailData.occuranceNever = true;
        recurringEmailData.untilDate = null;
      }
    }
  }

   void setStages() async {
    List<WorkFlowStageModel?> stageList = job!.stages!;
    stages = [];
    for (var stage in stageList) {
      stages.add(
        JPSingleSelectModel(
          label:stage!.name, 
          id: stage.code,
          color: ColorHelper.getHexColor(WorkFlowStageConstants.colors[stage.color]!.toHex())
        )
      );
    }
  }

 void setDefaultValue(){
    getMonthDurationListItem();
    if(type == RecurringType.salesAutomation){setStages();}
    if(recurringEmailData.repeat == null){
      durationCount.text = '1';
      selectedDate = DateTime.now().toString();
      occuranceOnController.text = DateTimeHelper.convertHyphenIntoSlash(
          DateTime.now().toString().substring(0, 10));
      selectedDurationValue =  defaultDurationValue ?? RecurringConstants.weekly;
      duration.text = durationsList.firstWhere((element) => element.id ==  selectedDurationValue).label;
      selectedMonthDurationValue  = '1';
      recurringEmailData.byDay =[];
      daysOfWeekList.firstWhere((element) => element.id == currentDay).isSelect = true;
      monthlyDuration.text = monthDurationList.firstWhere((element) => element.id ==  selectedMonthDurationValue).label;
      if(type == RecurringType.salesAutomation) {
        selectedStage = job!.currentStage!.code;
        selectedStageValue =  job!.currentStage!.name;
        selectedStageColor = ColorHelper.getHexColor(WorkFlowStageConstants.colors[job!.currentStage!.color]!.toHex());
      }
    } else {
      occuranceActive = recurringEmailData.occuranceActive;
      occuranceOn = recurringEmailData.occuranceOn;
      occuranceNever = recurringEmailData.occuranceNever;
      selectedDate = DateTime.now().toString();
      occuranceOnController.text = DateTimeHelper.convertHyphenIntoSlash(
          DateTime.now().toString().substring(0, 10));
      durationCount.text = recurringEmailData.interval.toString();
      selectedDurationValue = recurringEmailData.repeat!;
      duration.text = durationsList.firstWhere((element) => element.id ==  recurringEmailData.repeat).label;
      if (selectedDurationValue == RecurringConstants.monthly) {
        try {
          selectedMonthDurationValue = monthDurationList
              .firstWhere((element) => element.label == recurringText)
              .id;
        } catch (_) {
          selectedMonthDurationValue = '0';
        }
        monthlyDuration.text = recurringText ?? '';
      } else {
        selectedMonthDurationValue  = '1';
        monthlyDuration.text = monthDurationList.firstWhere((element) => element.id ==  selectedMonthDurationValue).label;
      }
      if(type == RecurringType.salesAutomation){
        selectedStage = recurringEmailData.endStageCode!;
        selectedStageValue = stages.firstWhere((element) => element.id == recurringEmailData.endStageCode).label;
        selectedStageColor = stages.firstWhere((element) => element.id == recurringEmailData.endStageCode).color;
      }
      if (selectedDurationValue == RecurringConstants.weekly) {
        try {
          for (int i = 0; i < recurringEmailData.byDay!.length; i++) {
            daysOfWeekList
                .firstWhere((element) => element.id == recurringEmailData.byDay![i])
                .isSelect = true;
          }
        } catch (_) {
          daysOfWeekList.firstWhere((element) => element.id == currentDay).isSelect = true;
        }
      } else {
        daysOfWeekList.firstWhere((element) => element.id == currentDay).isSelect = true;
      }
      
      occuranceCount.text =
      recurringEmailData.occurrence == null ||  recurringEmailData.occurrence == 'job_end_stage_code'  ?
      '' : recurringEmailData.occurrence! ;
    }
  }

  @override
  void onInit() {
    setDefaultValue();
    super.onInit();
  }
}
