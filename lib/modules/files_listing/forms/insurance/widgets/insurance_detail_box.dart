import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/modules/files_listing/forms/insurance/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class InsuranceDetailsBox extends StatelessWidget {
const InsuranceDetailsBox({
  super.key,
  required this.controller
});

final InsuranceFormController controller;

@override
Widget build(BuildContext context) {
  return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 16),
      width: double.infinity,
      decoration: BoxDecoration(color: JPAppTheme.themeColors.base, borderRadius: BorderRadius.circular(18)),
      child: Form(
        key: controller.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JPText( 
              text: 'insurance_detail'.tr.toUpperCase(),
              fontWeight: JPFontWeight.medium,
              textSize: JPTextSize.heading4,
            ),
              Padding(
                padding: EdgeInsets.only(top: controller.formUiHelper.verticalPadding),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                        child: JPInputBox(
                        inputBoxController: controller.service.titleController,
                        label: 'title'.tr.capitalize,
                        type: JPInputBoxType.withLabel,
                        fillColor: JPAppTheme.themeColors.base,
                        disabled: controller.service.isSavingForm,
                      ),
                    ),
                    const SizedBox(width: 15,),
                    Expanded(
                      flex: 1,
                      child: JPInputBox(
                        inputBoxController: controller.service.divisionController,
                        hintText: 'default'.tr.capitalize,
                        type: JPInputBoxType.withLabel,
                        label: 'division'.tr.capitalize,
                        fillColor: JPAppTheme.themeColors.base,
                        disabled: controller.service.isSavingForm || controller.service.disableDivision,
                        readOnly: true,
                        onPressed: controller.service.selectDivision,
                        suffixChild: Padding(
                          padding: EdgeInsets.symmetric(horizontal: controller.formUiHelper.horizontalPadding),
                          child: const JPIcon(
                            Icons.keyboard_arrow_down_outlined,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Transform.translate(
                  offset: const Offset(-8, 12),
                  child: JPCheckbox(
                    selected: controller.service.isInsuranceInfoUpdated,
                    separatorWidth: 2,
                    padding: const EdgeInsets.all(4),
                    disabled: controller.service.isSavingForm,
                    borderColor: JPAppTheme.themeColors.themeGreen,
                    onTap:controller.service.toggleIsInsuranceInfo,
                    text: "update_insurance_info".tr.capitalize,
                  ),)
              ),
                ],
              ),
            ),
          );
    }
}
