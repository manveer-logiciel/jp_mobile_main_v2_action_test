
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/form_builder/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/files_listing/forms/custom_measurement/measurement_form/controller.dart';
import 'package:jobprogress/modules/files_listing/forms/custom_measurement/measurement_form/form/section/detail.dart';
import 'package:jobprogress/modules/files_listing/forms/custom_measurement/measurement_form/shimmer.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class MeasurementForm extends StatelessWidget {
  const MeasurementForm({
    super.key, 
    required this.controller,
  });
  
  final MeasurementFormController controller;

  Widget get inputFieldSeparator => SizedBox(
    height: controller.formUiHelper.inputVerticalSeparator,
  );

  @override
  Widget build(BuildContext context) {
    return controller.isLoading && controller.viewTitle.isEmpty ? const MeasurementFormShimmer():
    GestureDetector(
      onTap: Helper.hideKeyboard,
      child: Material(
        color: JPColor.transparent,
        child: JPFormBuilder(
          title:'measurement'.tr, 
          form: Form(
            key: controller.formKey,
            child: Column(
              key: const ValueKey(WidgetKeys.tradeTypeKey),
              mainAxisSize: MainAxisSize.min,
              children: [
                for(int i = 0; i < controller.measurementList.length; i++)...{
                MeasurementFormDetailsection(
                    isDisableAddMultiple:  controller.measurementList[i].isAttributeButtonDisable,
                    validateInputBox: controller.validateValue,
                    validateForm:(val)=> controller.validateFormAndDisableButton(i),
                    index: i,
                    isViewOnly: controller.viewTitle.isNotEmpty,
                    isEdit: controller.isEdit,
                    controllerList: controller.controllerList,
                    isSavingForm: controller.isSavingForm, 
                    measurement: controller.measurementList[i],
                    isHoverWasteFactorSuggestionApplied: controller.isHoverWasteFactorSuggestionApplied(controller.measurementList[i].name),
                    isHoverWasteFactorExist: controller.isHoverWasteFactorExist(controller.measurementList[i].name),
                    isWasteFactor: controller.isWasteFactor(controller.measurementList[i].name),
                    onTapSuggestWasteFactor: controller.showApplySuggestedWasteFactorDialog,
                    onTapAttributeEdit: controller.showEditAttributeValueDialog,
                    addMultipleButtonClick:() { 
                      Helper.hideKeyboard();
                      controller.navigateToAddMultipleMeasurementScreen(i);
                    },
                  ),
                  inputFieldSeparator
                 }
              ],
            ),
          ),
          footer: Visibility(
            visible: controller.viewTitle.isEmpty && controller.controllerList.isNotEmpty,
            child: JPButton(
              key: const Key(WidgetKeys.footerSaveButtonKey),
              type: JPButtonType.solid,
              text: controller.isSavingForm ? '' :controller.isEdit ? 'update'.tr.toUpperCase(): 'save'.tr.toUpperCase(),
              size: JPButtonSize.small,
              disabled: controller.isSavingForm,
              suffixIconWidget: showJPConfirmationLoader(
                show: controller.isSavingForm,
              ),
              onPressed: (){
                controller.showSaveDialog();
              },
            ),
          ),
        ),
      )
    );
  }
}

