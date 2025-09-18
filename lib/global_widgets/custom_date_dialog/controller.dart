import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/files_listing/instant_photo_gallery_filter.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jp_mobile_flutter_ui/DatePicker/index.dart';

class CustomDateController extends GetxController {

  CustomDateController(this.filterKey);

  final InstantPhotoGalleryFilterModel filterKey;
  
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  
  bool isValidate = false;
  final formKey = GlobalKey<FormState>();

  String? selectedStartDate;
  String? selectedEndDate;

  @override
  void onInit() {
    setFilterKey();
    super.onInit();
  }

  void pickStartDate() async {
    DateTime firstDate = DateTime.now();
    DateTime? dateTime = await Get.dialog(
      JPDatePicker(
        initialDate: selectedStartDate == null ? firstDate : DateTime.parse(selectedStartDate!),
        lastDate: selectedEndDate == null ? null : DateTime.parse(selectedEndDate!),
      ),
    );
    if(dateTime != null) {
    String dateOnly = dateTime.toString().substring(0,10);
    String formattedDate = DateTimeHelper.convertHyphenIntoSlash(dateOnly);
    startDateController.text = formattedDate;
    selectedStartDate = dateOnly;
    update();   
    }
    if(isValidate) {
     validateForm();
    } 
  }
  
  void pickEndDate() async {
    DateTime firstDate  = selectedStartDate == null ? DateTime.now(): DateTime.parse(selectedStartDate!);
    DateTime? dateTime = await Get.dialog(
      JPDatePicker(
        initialDate: selectedEndDate == null ? firstDate : DateTime.parse(selectedEndDate!),
        firstDate: selectedStartDate == null ? null : DateTime.parse(selectedStartDate!)
      ),
    );
    if(dateTime != null) {
    String dateOnly = dateTime.toString().substring(0,10);
    String formattedDate = DateTimeHelper.convertHyphenIntoSlash(dateOnly);
    endDateController.text = formattedDate;
    selectedEndDate = dateOnly;
    }

    if(isValidate) {
      validateForm();
    } 
  }

  bool validateForm() {
    return formKey.currentState!.validate();
  }

  String validateStartDate(String value) {
     if (value.isEmpty) {
      return "please_provide_start_date".tr;
    } 
    return '';
  }

  String validateEndDate(String value) {
    if (value.isEmpty) {
      return "please_provide_end_date".tr;
    } 
    return '';
  }

  void setFilterKey(){
    if(filterKey.startDate != null){
      startDateController.text =  DateTimeHelper.convertHyphenIntoSlash(filterKey.startDate.toString());
      selectedStartDate = filterKey.startDate; 
      update(); 
    }
    if(filterKey.endDate != null){
      endDateController.text =  DateTimeHelper.convertHyphenIntoSlash(filterKey.endDate.toString());
      selectedEndDate = filterKey.endDate; 
      update(); 
    }
  }

  void reset () {
    selectedStartDate = null;
    selectedEndDate = null;
    endDateController.clear();
    startDateController.clear();
    update();
  }

  void saveData(){
   filterKey.startDate = selectedStartDate;
   filterKey.endDate = selectedEndDate;
   update();
  }
  
  bool isResetButtonDisable() {
    return (selectedStartDate == null && selectedEndDate == null);
  }

  }