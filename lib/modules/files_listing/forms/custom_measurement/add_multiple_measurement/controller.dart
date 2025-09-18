import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement_attribute.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement_data.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/measurement_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/modules/files_listing/forms/custom_measurement/add_multiple_measurement/bottom_sheet/index.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/Icon/index.dart';
import 'package:jp_mobile_flutter_ui/InputBox/controller.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';

class AddMultipleMeasurementController extends GetxController {

MeasurementDataModel  measurement = Get.arguments?[NavigationParams.measurement] ?? MeasurementDataModel();

MeasurementDataModel?  initialMeasurement;

bool isEdit = Get.arguments?[NavigationParams.isEdit] ?? false;

List<MeasurementAttributeModel>? totalMeasurement;

final formKey = GlobalKey<FormState>();

Map<String,JPInputBoxController> controllerList = {};

@override
  void onInit() {
    measurement = MeasurementDataModel.copy(measurement);
    initTable();
    super.onInit();
  }

  void initTable() {
    removeEmptyMeasurement();
    calculateTotal();
    initialMeasurement = MeasurementDataModel.copy(measurement);
    if(measurement.values!.length == 1 || measurement.isDisable){ 
      addNewMeasurement();
    }
  }

  String getAttributeValue(int a, int i) {
    String value = !Helper.isValueNullOrEmpty(measurement.values![a][i].value) ? 
      measurement.values![a][i].value! : 
      i == 0 ? 
      '${a+1}' : 
      '--';

    return value;
  }

  void removeEmptyMeasurement() {
    if(measurement.values!.length > 1) {
      measurement.values!.removeWhere((value) => 
        value.every((attribute) => attribute.value!.isEmpty && 
        (attribute.subAttributes!.every((subAttribute) => subAttribute.value?.isEmpty?? false))));
    }
  }

  String getSubAttributeValue(int a, int i, int j) {
    String value = !Helper.isValueNullOrEmpty(measurement.values![a][i].subAttributes![j].value) ?
      measurement.values![a][i].subAttributes![j].value! :
      '--';
    return value;
  }

  String getSubAttributeTotal(int i, int j) {
    String value = !Helper.isValueNullOrEmpty(totalMeasurement![i].subAttributes![j].value) ? 
      totalMeasurement![i].subAttributes![j].value! : 
      '--';
    
    return value;
  }

  String getAttributeTotal(int i){
    String value = i == 0 ? 
      'total'.tr.capitalize! : 
      !Helper.isValueNullOrEmpty(totalMeasurement![i].value) ?
        totalMeasurement![i].value! :
        '--'; 

    return value; 
  }

   void addNewMeasurement() {
    measurement.values!.add(getEmptyMeasurement());
    initialMeasurement!.values!.add(getEmptyMeasurement());
    update();
  }

  List<MeasurementAttributeModel> getEmptyMeasurement() {
    List<MeasurementAttributeModel> emptyMeasurement = [];
   if(measurement.values != null) {
    for (var element in measurement.values![0]) { emptyMeasurement.add(MeasurementAttributeModel.copy(element)); }
   }
    for (var element in emptyMeasurement) {
      element.value = '';
      if(element.subAttributes?.isNotEmpty ?? false) {
        for (var subElement in element.subAttributes!) {
          subElement.value = '';
        }
      }
    }
    return emptyMeasurement;
  }

  void onAddButtonTap() {
    Get.back(result: [totalMeasurement, measurement.values] );
  }

  Future<bool> onWillPop() async {
    bool isNewDataAdded = isTableDataModified();
    if (isNewDataAdded) {
      showUnsavedChangesConfirmation();
    } else {
      Helper.hideKeyboard();
      Get.back();
    }
    return false;
  }

  Future<bool> onWillPopBottomSheet(MeasurementDataModel measurement) async {
    
    bool isNewDataAdded = isBottomSheetDataModified(measurement);
    
    if (isNewDataAdded) {
      showUnsavedChangesConfirmation();
    } else {
      Helper.hideKeyboard();
      Get.back();
    }
    return false;
  }

  String validateValue(dynamic value) {
   if(Helper.isInvalidValue(value)){
      return 'please_enter_valid_value'.tr;
   } 
   return '';
  }
  
  bool validateForm() {
    return formKey.currentState!.validate();
  }

  bool isTableDataModified() {
    for(int i=0; i< measurement.values!.length; i++) {
      for(int j=0; j<measurement.values![i].length;j++) {
        if(measurement.values?[i][j].subAttributes?.isNotEmpty ?? false) {
          for(int k = 0; k < measurement.values![i][j].subAttributes!.length; k++) {
            if((measurement.values?[i][j].subAttributes![k].value ?? '') != (initialMeasurement!.values?[i][j].subAttributes![k].value ?? '')) { 
              return true;
            }
          }
        } else {
          if((measurement.values![i][j].value ?? '') != (initialMeasurement!.values?[i][j].value ?? '')) { 
            return true;
          }
        }
      }
    }
    return false;
  }

  bool isBottomSheetDataModified(MeasurementDataModel measurement) { 
    for(int i=0; i< measurement.attributes!.length; i++) {
      if(measurement.attributes?[i].subAttributes?.isNotEmpty ?? false){
        for(int j = 0; j < measurement.attributes![i].subAttributes!.length; j++) {
          if((measurement.attributes?[i].subAttributes![j].value ?? '') != (controllerList['${measurement.attributes![i].subAttributes![j].id}']?.text ?? '')) { 
            
            return true;
          }
        }
      } else {
        if((measurement.attributes?[i].value ?? '') != (controllerList['${measurement.attributes![i].id}']?.text ?? '')) { 
          return true;
        }
      }
    }
    return false;
  }

  void saveBottomSheetData(int index) {
    if(validateForm()) {
      assignControllerDataToMeasurement(index);
      calculateTotal();
      update();
      Get.back();
    }
  }

  void assignControllerDataToMeasurement(int index){
    for(var attribute in measurement.values![index]){
      if(attribute.subAttributes?.isNotEmpty ?? false){
        for (var subAttribute in attribute.subAttributes!) {
          subAttribute.value = controllerList['${subAttribute.id}']?.text;
        }
      } else {
        attribute.value = controllerList['${attribute.id}']?.text;
      } 
    }

  }

  void showQuickAction(int index) {
   List<JPQuickActionModel> quickActionList = [
      JPQuickActionModel(
        id: 'edit',
        child: const JPIcon(
          Icons.edit_outlined,
          size: 18,
        ),
        label: 'edit'.tr.capitalize!
      ),
      if(measurement.values!.length > 1)JPQuickActionModel(
        id: 'delete',
        child: const JPIcon(
          Icons.delete_outline,
          size: 18,
        ),
        label: 'delete'.tr.capitalize!
      ),
    ];

     showJPBottomSheet(
      child: (_) => JPQuickAction(
        mainList: quickActionList,
        onItemSelect: (value) async {
          switch (value) {
            case 'edit':
              await navigateToEditMultipleMeasurement(index: index , isQuickAction :true);
              break;
            case 'delete':
              removeMeasurement(index);
               Get.back();
              break;
          }          
        },
      ),
      isScrollControlled: true);
  }

  void removeMeasurement(int index) {
    measurement.values!.removeAt(index);
    calculateTotal();
    update();
  }

  void showUnsavedChangesConfirmation() {
    showJPBottomSheet(
      child: (_) => JPConfirmationDialog(
        title: 'unsaved_changes'.tr,
        subTitle: 'unsaved_changes_desc'.tr,
        icon: Icons.warning_amber_outlined,
        suffixBtnText: 'dont_save'.tr.toUpperCase(),
        prefixBtnText: 'cancel'.tr.toUpperCase(),
        onTapSuffix: () {
          Get.back();
          Get.back();
        },
      ),
    );
  }

  void calculateTotal() {
    
    totalMeasurement = getEmptyMeasurement();

    for (var element in measurement.values!) {
      for(int i = 0; i < element.length; i++) {
        if (element[i].subAttributes?.isNotEmpty ?? false) {
          for (int j = 0; j < element[i].subAttributes!.length; j++) {
            bool valueExists = !Helper.isValueNullOrEmpty(element[i].subAttributes![j].value);
            bool isNameField = MeasurementHelper.isNameField(measurementId: measurement.id, slug: element[i].subAttributes![j].slug);
            if (valueExists && !isNameField) {
              if (totalMeasurement![i].subAttributes![j].value == null || 
                totalMeasurement![i].subAttributes![j].value!.isEmpty
              ) {
                totalMeasurement![i].subAttributes![j].value = '0';
              }
    
              totalMeasurement![i].subAttributes![j].value = 
              (num.parse(totalMeasurement![i].subAttributes![j].value!) +
              num.parse(element[i].subAttributes![j].value!)).toString();
            }
          }
        } else {
          bool valueExists = !Helper.isValueNullOrEmpty(element[i].value);
          bool isNameField = MeasurementHelper.isNameField(measurementId: measurement.id, slug: element[i].slug);
          if ( valueExists && !isNameField) {
            if (totalMeasurement![i].value == null || totalMeasurement![i].value!.isEmpty) {
              totalMeasurement![i].value = '0';
            }
            totalMeasurement![i].value = (num.parse(totalMeasurement![i].value!) + num.parse(element[i].value!)).toString();
          }
        }
      }
    }
  }

  Future<void> navigateToEditMultipleMeasurement({required int index,bool isQuickAction = false}) async {
    initInputBoxController(index);
    await showJPBottomSheet(
      isScrollControlled: true,
      ignoreSafeArea: false,
      enableInsets: true,
      child: (_) => EditMeasurementBottomSheet(
        controller: this,
        index: index,
      )
    );
    if(isQuickAction){
      Get.back();
    }
  }

  void initInputBoxController(int index) {
    controllerList = {};
    for (var element in measurement.values![index]) {
      controllerList.addAll({'${element.id}' : JPInputBoxController(text: element.value)});
      if(element.subAttributes?.isNotEmpty ?? false) {
        for (var subElement in element.subAttributes!) {
          controllerList.addAll({'${subElement.id}' : JPInputBoxController(text: subElement.value)});
        }
      }
    }
  }
} 
