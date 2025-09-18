import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/font_weight.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/text_size.dart';
import 'package:jp_mobile_flutter_ui/Icon/index.dart';
import 'package:jp_mobile_flutter_ui/InputBox/index.dart';
import 'package:jp_mobile_flutter_ui/InputBox/type.dart';
import 'package:jp_mobile_flutter_ui/Text/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

import '../../../../../core/utils/form/validators.dart';
import '../controller.dart';

class BillDetailBox extends StatelessWidget {
  final BillFormController controller;
  const BillDetailBox({super.key, required this.controller});

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
              JPText( text: 'bill_details'.tr.toUpperCase(),
                fontWeight: JPFontWeight.medium,
                textSize: JPTextSize.heading4,
              ),

              const SizedBox(height: 20,),

              JPInputBox(
                inputBoxController: controller.service.vendorController,
                type: JPInputBoxType.withLabel,
                label: 'vendor'.tr,
                fillColor: JPAppTheme.themeColors.base,
                readOnly: true,
                isRequired: true,
                suffixChild: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10),
                  child: JPIcon(
                    Icons.keyboard_arrow_down_outlined,
                    color: JPAppTheme.themeColors.text,
                  ),
                ),
                onPressed: controller.service.openVendors,
                disabled: controller.isSavingForm,
                validator: controller.service.validateVendorTitle,
              ),
              const SizedBox(height: 20,),
              JPInputBox(
                inputBoxController: controller.service.billNumberController,
                type: JPInputBoxType.withLabel,
                label: 'bill_number'.tr,
                fillColor: JPAppTheme.themeColors.base,
                disabled: controller.isSavingForm,
                maxLength: 20,
              ),
              const SizedBox(height: 20,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: JPInputBox(
                      inputBoxController: controller.service.billDateController,
                      type: JPInputBoxType.withLabel,
                      label: 'bill_date'.tr,
                      fillColor: JPAppTheme.themeColors.base,
                      readOnly: true,
                      isRequired: true,
                      suffixChild: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: JPIcon(
                          Icons.date_range_rounded,
                          color: JPAppTheme.themeColors.secondaryText.withValues(alpha: 0.6),
                        ),
                      ),
                      onPressed: controller.service.onClickBillDateField,
                      disabled: controller.isSavingForm,
                      validator: (val) => FormValidator.requiredFieldValidator(val, errorMsg: 'bill_date_is_required'.tr),
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Expanded(
                    flex: 1,
                    child: JPInputBox(
                      inputBoxController: controller.service.dueDateController,
                      type: JPInputBoxType.withLabel,
                      label: 'due_date'.tr,
                      fillColor: JPAppTheme.themeColors.base,
                      readOnly: true,
                      isRequired: true,
                      suffixChild: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10),
                        child: JPIcon(
                          Icons.date_range_rounded,
                          color: JPAppTheme.themeColors.secondaryText.withValues(alpha: 0.6),
                        ),
                      ),
                      onPressed: controller.service.onClickDueDateField,
                      disabled: controller.isSavingForm,
                      validator: (val) => FormValidator.requiredFieldValidator(val, errorMsg: 'due_date_is_required'.tr),
                    ),
                  ),
                ],),
              const SizedBox(height: 20,),
              JPInputBox(
                inputBoxController: controller.service.addressController,
                type: JPInputBoxType.withLabel,
                label: 'address'.tr,
                fillColor: JPAppTheme.themeColors.base,
                maxLines: 4,
                disabled: controller.isSavingForm,
              )
            ],),
        )
    );
  }
}
