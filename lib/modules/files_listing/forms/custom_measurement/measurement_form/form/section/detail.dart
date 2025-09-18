import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement_attribute.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement_data.dart';
import 'package:jobprogress/core/constants/measurement_constant.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/modules/files_listing/forms/custom_measurement/measurement_form/form/section/sub_attribute_view.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../../../../core/utils/helpers.dart';
import 'attribute_view.dart';

class MeasurementFormDetailsection extends StatelessWidget {
  const   MeasurementFormDetailsection({
    super.key, 
    required this.measurement, 
    required this.isSavingForm, 
    this.addMultipleButtonClick,
    this.isBottomSheet = false,  
    this.controllerList,
    required this.isEdit, 
    this.isViewOnly = false, 
    required this.index, 
    this.validateInputBox,
    this.validateForm,  
    this.isDisableAddMultiple = false,
    this.isHoverWasteFactorSuggestionApplied = false,
    this.isHoverWasteFactorExist = false,
    this.isWasteFactor = false,
    this.onTapSuggestWasteFactor,
    this.onTapAttributeEdit
  });

  
  final MeasurementDataModel measurement ;
  final bool isSavingForm;
  final bool isBottomSheet;
  final bool isDisableAddMultiple;
  final int index;
  final VoidCallback? addMultipleButtonClick;
  final String? Function(dynamic)? validateInputBox;
  final Function(String)? validateForm;
  final bool isEdit;
  final bool isViewOnly;
  final Map<String,JPInputBoxController>? controllerList;
  final bool isHoverWasteFactorSuggestionApplied;
  final bool isHoverWasteFactorExist;
  final bool isWasteFactor;
  final VoidCallback? onTapSuggestWasteFactor;
  final Function(MeasurementAttributeModel)? onTapAttributeEdit;

  Widget get inputFieldSeparator => SizedBox(
    height: JPAppTheme.formUiHelper.inputVerticalSeparator,
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JPAppTheme.themeColors.base,
      borderRadius: BorderRadius.circular(JPAppTheme.formUiHelper.sectionBorderRadius), 
      child: Padding(
        padding: EdgeInsets.only(
          left: JPAppTheme.formUiHelper.horizontalPadding,
          right: JPAppTheme.formUiHelper.horizontalPadding,
          bottom: !isBottomSheet ? JPAppTheme.formUiHelper.verticalPadding: 0.0,
          top: !isBottomSheet ? JPAppTheme.formUiHelper.verticalPadding : 5.0
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(!isBottomSheet)
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 3,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const SizedBox(width: double.infinity),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    JPText(
                      text: measurement.name ?? '',
                      fontWeight: JPFontWeight.medium,
                      textColor: JPAppTheme.themeColors.darkGray,
                    ),
                    const SizedBox(width: 5),
                    Visibility(
                      visible: measurement.isDisable,
                      child: JPChip(
                        backgroundColor: JPAppTheme.themeColors.darkGray,
                        textColor: JPAppTheme.themeColors.base,
                        text: 'cumulative'.tr.capitalize!,
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: !isViewOnly,
                  child: JPTextButton(
                    isDisabled: isDisableAddMultiple, 
                    key:  ValueKey('${WidgetKeys.tradeTypeKey}[$index]'),
                    textSize: JPTextSize.heading5,
                    color: JPAppTheme.themeColors.primary,
                    fontWeight: JPFontWeight.medium,
                    text: measurement.isDisable ? 'edit'.tr.capitalize : '+ ${'add_multiple'.tr.capitalize!}',
                    onPressed: addMultipleButtonClick,
                  ),
                ),
              ],
            ),
           Padding(
            padding: !isBottomSheet ? 
            EdgeInsets.only(top: JPAppTheme.formUiHelper.inputVerticalSeparator) :
            EdgeInsets.zero,
              child: Wrap(
                spacing:  20,
                children: measurementFormView(),
              )
            )
          ],
        ),
      ),
    );
  }

  List<Widget> measurementFormView() {
    List<Widget> measurementItemList = [];
      for(int j = 0; j < measurement.attributes!.length; j++) {
       if(measurement.attributes![j].subAttributes?.isEmpty ?? true) {
        if(measurement.attributes![j].name != MeasurementConstant.name || isBottomSheet) {
          bool thirdPartyAttributeEditable = Helper.isTrue(measurement.attributes![j].thirdPartyAttributeEditable);
          measurementItemList.add(
            MeasurementFormAttributeView(
              validateForm: validateForm,
              validateInputBox: validateInputBox,
              controllerList: controllerList,
              isBottomSheet: isBottomSheet,
              measurement: measurement, 
              isSavingForm: isSavingForm, 
              isEdit: isEdit, 
              isViewOnly: isViewOnly, 
              index: j,
              isHoverWasteFactorSuggestionApplied: isHoverWasteFactorSuggestionApplied && thirdPartyAttributeEditable,
              isHoverWasteFactorExist: isHoverWasteFactorExist && thirdPartyAttributeEditable,
              isSystemEdit: (isWasteFactor && thirdPartyAttributeEditable) || (isWasteFactor && measurement.attributes![j].locked == false),
              onTapSuggestWasteFactor: onTapSuggestWasteFactor,
              onTapAttributeEdit: onTapAttributeEdit
            )
          );
        }   
       } else {
        measurementItemList.add(
          MeasurementFormSubAttributeView(
            valuesAttribute: measurement.values?[0][j] ?? MeasurementAttributeModel(),
            isBottomSheet: isBottomSheet,
            validateForm: validateForm,
            validateInputBox: validateInputBox,
            isSavingForm: isSavingForm,
            subAttributes: measurement.attributes![j].subAttributes,
            attributeName: measurement.attributes![j].name!,
            controllerList: controllerList, 
            isDisable:isSavingForm || measurement.isDisable && !isBottomSheet, 
            isEdit: isEdit,
            isViewOnly: isViewOnly,
          )  
        );
       }
     }
     return measurementItemList;
  }
}
