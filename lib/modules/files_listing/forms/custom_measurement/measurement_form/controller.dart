import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement_attribute.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement_data.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/repositories/measurements.dart';
import 'package:jobprogress/core/constants/measurement_constant.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/measurement_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/type.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../core/constants/regex_expression.dart';

class MeasurementFormController extends GetxController {
  
  final FormUiHelper formUiHelper = JPAppTheme.formUiHelper; // provides necessary values for paddings, margins and form section spacing
  final formKey = GlobalKey<FormState>();
  
  bool isSavingForm = false;
  bool isLoading = true;
  
  JobModel? job;
  
  String fileName = '';
  
  List<MeasurementDataModel> measurementList = [];
  List<MeasurementDataModel> initialMeasurementList = [];

  MeasurementModel? measurement;

  String? measurementId = Get.arguments?[NavigationParams.measurementId];

  int? jobId = Get.arguments?[NavigationParams.jobId];

  bool isEdit = Get.arguments?[NavigationParams.isEdit] ?? false;

  String viewTitle = Get.arguments?[NavigationParams.title] ?? '';
  
  Map <String,JPInputBoxController> controllerList = {};

  int? hoverJobId = Get.arguments?[NavigationParams.hoverJobId];
   
  @override
  void onInit() {
    initForm();
    super.onInit();
  }

  Future<void> initForm() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    showJPLoader();
    try {
      if(jobId != null){
        job = (await JobRepository.fetchJob(jobId!))['job'];
        await fetchMeasurementAttributeList();
      } else {
        await fetchMeasurementDetail();
      }
      initInputBoxController();
      for(var element in measurementList) {
        initialMeasurementList.add(MeasurementDataModel.copy(element)); 
      }
    } catch(e) {
      rethrow;
    } finally {
      isLoading = false;
      Get.back();
      update();
    }
  }

  void addNameAttribute() {
    for(int i=0; i< measurementList.length; i++) {
      measurementList[i].attributes!.insert(
        0, MeasurementAttributeModel(
          id: int.parse('-${i+1}'),
          name: 'Name',
          value: ''
        ));
    }
  }

  String validateValue(dynamic value) {
    if(Helper.isInvalidValue(value)){
      return 'please_enter_valid_value'.tr;
    } 
    update();
    return '';
  }
  
  void validateFormAndDisableButton(int index) {
    measurementList[index].isAttributeButtonDisable = !validateForm();
    update();
  }

  bool validateForm(){
    return formKey.currentState!.validate();
  } 

  Future<void> fetchMeasurementDetail() async {
    try {    
      final params = <String, dynamic>{
        'includes[0]': 'measurement_details',
        'includes[1]': 'attributes.sub_attributes.unit',
        'includes[2]': 'attributes.unit',
        'includes[3]': 'measurement_details',
      };
      measurement = await MeasurementsRepository.fetchMeasurementDetail(params,measurementId!);
      measurementList = measurement!.measurements!;
      addNameAttribute();
      
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchMeasurementAttributeList() async {
    try {    
      final params = <String, dynamic>{
        'includes[0]': 'attributes.sub_attributes',
        'includes[1]': 'attributes.unit',
        'includes[2]': 'attributes.sub_attributes.unit',
        'job_id' : jobId,
        for(int i = 0; i< job!.trades!.length; i++)
        'trade_id[$i]': job!.trades![i].id
      };

      measurementList = await MeasurementsRepository.fetchMeasurementAttributeList(params);
     
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> measurementFormJson() { 
    final Map<String, dynamic> data = {};
    data['job_id'] = isEdit? measurement!.jobId : jobId;
    data['title'] = isEdit? measurement!.title : fileName;
    List<Map<String, dynamic>> jsonData = [];

    for(int i = 0; i< measurementList.length; i++) {
      for(int j = 0; j < measurementList[i].values!.length; j++) {
        jsonData.add(measurementList[i].toValuesJson(j));
      }
    }
    
    data['values'] = jsonData;
    
    return data;
  }

  Future<dynamic> saveForm() async {
    
    if(!(isDataModified(measurementList: initialMeasurementList))) {
      return Helper.showToastMessage('no_changes_made'.tr);
    }

    saveMeasurementListFormInputBox(measurementList);
    Map<String, dynamic> params = {
      ...measurementFormJson(),
      'includes[0]': 'measurement_details',
      'includes[1]': 'created_by'
    };

    try {
      if(isEdit) {
        isSavingForm = true;
        update();
      }
      bool success = isEdit ?
        await MeasurementsRepository.updateMeasurement(params, measurement!.id!):
        await MeasurementsRepository.saveMeasurement(params);
      if (success) {
        isEdit?
          Helper.showToastMessage('measurement_updated'.tr.capitalizeFirst!):
          Helper.showToastMessage('measurement_saved'.tr.capitalizeFirst!);
       if(!isEdit) Get.back();
      }
      
      Get.back(result: success);   
    } catch(e){
      rethrow;
    } finally{
      isSavingForm = false;
    }
  }

  void navigateToAddMultipleMeasurementScreen(int index) async {
  
    saveMeasurementFromInputBox(measurementList[index]);
      
    final  result =  await Get.toNamed(Routes.addMultipleMeasurement, arguments:
      { 
        NavigationParams.measurement : measurementList[index],
        NavigationParams.isEdit : isEdit 
      },
    );
    if(result != null) {
      List<List<MeasurementAttributeModel>> values = result[1];
      List<MeasurementAttributeModel> attribute = result[0];
      MeasurementDataModel measurement = MeasurementDataModel(
        id: measurementList[index].id,
        name: measurementList[index].name,
        attributes: attribute, 
        values: values
      );
      measurementList[index] = measurement;
      updateInputBoxFromMeasurement(measurementList[index]); 
      int filledTableCount = 0;

      if(measurementList[index].values!.length > 1) {
         for(int i = 0; i< measurementList[index].values!.length; i++) {
          if(measurementList[index].values![i].any((element) => element.value!.isNotEmpty) || 
            measurementList[index].values![i].any((element) => (
              element.subAttributes?.isNotEmpty ?? false) && 
              element.subAttributes!.any((element) => element.value!.isNotEmpty))
          ) { 
              filledTableCount++;
              if(filledTableCount > 1) {
                measurementList[index].isDisable = true;
              }
          } 
        }
      } else {
        measurementList[index].isDisable = false;
      }
     
      update();
    }
  }

  void initInputBoxController() {
    
    controllerList = {};
    
    for (var measurement in measurementList) {
      
      for (var element in measurement.attributes!) {
        if(Helper.isValueNullOrEmpty(element.value) || num.parse(element.value!) == 0){
          element.value = '';
        }
        controllerList.addAll({'${element.id}': JPInputBoxController(text: element.value)});
        
        if(element.subAttributes?.isNotEmpty ?? false) {
          for (var subElement in element.subAttributes!) {
            if(Helper.isValueNullOrEmpty(subElement.value) || num.parse(subElement.value!) == 0){
              subElement.value = '';
            }
            controllerList.addAll({'${subElement.id}' :JPInputBoxController(text: subElement.value)});
          }
        }
      } 
    } 
  }

  Future<bool> onWillPop() async {
    Helper.hideKeyboard();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    bool isNewDataAdded = isDataModified(measurementList: initialMeasurementList);
    if (isNewDataAdded) {
      showUnsavedChangesConfirmation();
    } else {
      Get.back();
    }
    return false;
  }

  bool isDataModified({List<MeasurementDataModel>? measurementList}) {
    if(measurementList != null) {
      for(var measurement  in measurementList) {
        for(var attribute in measurement.attributes!) {
          if((attribute.value ?? '') != (controllerList['${attribute.id}']?.text ?? '')) { 
            return true;
          }

          if(attribute.subAttributes?.isNotEmpty ?? false) {
            for(var subAttribute in attribute.subAttributes!) {
              if((subAttribute.value ?? '') != (controllerList['${subAttribute.id}']?.text ?? '')) { 
                return true;
              }
            }
          }
        }
      }
    }
    

    return false;
  }


  void saveMeasurementFromInputBox(MeasurementDataModel measurement) {
    if(measurement.values == null) { 
      measurement.values = <List<MeasurementAttributeModel>>[];
      measurement.values!.add(measurement.attributes!);
    } 
    if(measurement.values!.length == 1) {
      for(var attribute in measurement.values![0]) {
        if(attribute.name != MeasurementConstant.name){
          attribute.value = controllerList['${attribute.id}']?.text ?? '';
        }
        if(attribute.subAttributes?.isNotEmpty ?? false ) {
          for(var subAttribute in attribute.subAttributes!) {
            subAttribute.value  = controllerList['${subAttribute.id}']?.text ?? '' ;
          }
        } 
      }
    }
  }

  void updateInputBoxFromMeasurement(MeasurementDataModel measurement) {
    for(var attribute in measurement.attributes!) {
      controllerList['${attribute.id}']?.text =  attribute.value ?? '';
      if(attribute.subAttributes?.isNotEmpty ?? false) {
        for(var subAttribute in attribute.subAttributes!) {
          controllerList['${subAttribute.id}']?.text = subAttribute.value ?? '';
        }
      } 
    }
  }

  void saveMeasurementListFormInputBox(List<MeasurementDataModel> measurementList) {
    for (var measurement in measurementList) {
      saveMeasurementFromInputBox(measurement);
    }
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

  Future<void> showSaveDialog() async {
    if(validateForm()) {
      if(controllerList.values.every((element) => element.text.isEmpty || element.text == '.' || num.parse(element.text) <= 0)) {
        Helper.showToastMessage('please_enter_measurement_value'.tr.capitalizeFirst!);
      } else {
        if(!isEdit) {
          FocusNode nameDialogFocusNode = FocusNode();
          showJPGeneralDialog(
            isDismissible: isSavingForm,
            child: (controller){
              return JPQuickEditDialog(
                type: JPQuickEditDialogType.inputBox,
                label: 'measurement_name'.tr.capitalize,
                suffixIcon: showJPConfirmationLoader(show: controller.isLoading),
                errorText: 'please_enter_measurement_name'.tr.capitalizeFirst!,
                disableButton: controller.isLoading,
                onSuffixTap: (val) async {
                  controller.toggleIsLoading();
                  fileName = val;
                  await saveForm();
                  controller.toggleIsLoading();
                },
                focusNode: nameDialogFocusNode,
                suffixTitle: controller.isLoading ? '' : 'save'.tr.toUpperCase(),
                maxLength: 50,
              );
            }
          );
          await Future<void>.delayed(const Duration(milliseconds: 400));
          nameDialogFocusNode.requestFocus();
        } else {
          saveForm();
        }
      } 
    } 
  }

  /// [isHoverWasteFactorSuggestionApplied] check whether waste factor is applied or not
  bool isHoverWasteFactorSuggestionApplied(String? measurementName) =>
      Helper.isTrue(measurement?.isHoverWasteFactor) && isHoverWasteFactorExist(measurementName);

  /// [isHoverWasteFactorExist] check whether waste factor is exist or not
  bool isHoverWasteFactorExist(String? measurementName) => hoverJobId != null && isWasteFactor(measurementName);

  void showApplySuggestedWasteFactorDialog() {
    int attributeId = MeasurementHelper.getWasteFactorAttributeId(measurement)!;
    MeasurementHelper.showApplyingSuggestedWasteFactorDialog(
        hoverJobId!,
        attributeId,
        wasteFactorApplied: (wasteFactor) {
          measurement?.isHoverWasteFactor = true;
          MeasurementHelper.setHoverWasteFactor(wasteFactor, measurement);
          controllerList['$attributeId']?.text = wasteFactor;
          initialMeasurementList.clear();
          initialMeasurementList.addAll(measurement!.measurements!);
          update();
        });
  }

  /// [isSystemMeasurement] check whether eagleView or hover or quickMeasure
  bool isSystemMeasurement() => measurement?.type == MeasurementConstant.eagleView
      || measurement?.type == MeasurementConstant.hover
      || measurement?.type == MeasurementConstant.quickMeasure;

  /// [isWasteFactor] check whether waste factor or not
  bool isWasteFactor(String? measurementName) =>
      isSystemMeasurement() && measurementName?.toLowerCase() == MeasurementConstant.roofing;

  void showEditAttributeValueDialog(MeasurementAttributeModel measurementAttribute) {
    FocusNode updateDialogFocusNode = FocusNode();
    showJPGeneralDialog(
        child: (controller) {
          return JPQuickEditDialog(
            type: JPQuickEditDialogType.inputBox,
            title: 'update_attribute_value'.tr.toUpperCase(),
            label:  measurementAttribute.name,
            suffixIcon: showJPConfirmationLoader(show: controller.isLoading),
            disableButton: controller.isLoading,
            fillValue: measurementAttribute.value?.trim(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(RegexExpression.amount))],
            autofocus: true,
            errorText: 'this_field_is_required'.tr,
            onSuffixTap: (value) async {
              try {
                controller.toggleIsLoading();
                await updateAttributeValue(measurementAttribute, value);
                if(measurement?.type == MeasurementConstant.hover) {
                  measurement?.isHoverWasteFactor = false;
                }
              } catch(e) {
                rethrow;
              } finally {
                controller.toggleIsLoading();
              }
            },
            focusNode: updateDialogFocusNode,
            suffixTitle: controller.isLoading ? '' : 'update'.tr.toUpperCase(),
            maxLength: 50,
          );
        });
  }

  Future<void> updateAttributeValue(MeasurementAttributeModel measurementAttribute, String value) async {
    Map<String, dynamic> params = {
      'attribute_id': measurementAttribute.id,
      'value': value
    };
    final Map<String, dynamic> response = await MeasurementsRepository.updateMeasurementAttributeValue(measurementId, params);
    if(response['message'] != null) {
      Helper.showToastMessage(response['message']);
    }
    if(response['status'] == 200) {
      String finalValue = value;
      if(finalValue == '0') {
        finalValue = '';
      }
      measurementAttribute.value = finalValue;
      controllerList[measurementAttribute.id?.toString()]?.controller.text = finalValue;
      initialMeasurementList.clear();
      initialMeasurementList.addAll(measurement!.measurements!);
      update();
      Get.back();
    }
  }
} 

