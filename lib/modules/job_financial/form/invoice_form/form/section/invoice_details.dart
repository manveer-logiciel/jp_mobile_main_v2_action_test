import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../../../common/enums/form_field_type.dart';
import '../../controller.dart';

class InvoiceDetailsBox extends StatelessWidget {
const InvoiceDetailsBox({
  super.key,
  required this.controller
});

final InvoiceFormController controller;

@override
Widget build(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    width: double.infinity,
    decoration: BoxDecoration(color: JPAppTheme.themeColors.base, borderRadius: BorderRadius.circular(18)),
    child: Form(
      key: controller.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          JPText(
            text: controller.formTitle,
            fontWeight: JPFontWeight.medium,
            textSize: JPTextSize.heading4,
          ),
          ///   Invoice Title
          Padding(
            padding: EdgeInsets.only(top: controller.formUiHelper.verticalPadding),
            child: JPInputBox(
              inputBoxController: controller.service.titleController,
              label: 'invoice_title'.tr,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              maxLength: 50,
              disabled: !controller.service.isFieldEditable(FormFieldType.title),
              onChanged: controller.onDataChanged,
            ),
          ),
          ///   Bill Date
          Visibility(
            visible: controller.service.invoiceItems.isNotEmpty,
            child: Padding(
              padding: EdgeInsets.only(top: controller.formUiHelper.verticalPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: JPInputBox(
                      inputBoxController: controller.service.billDateController,
                      label: 'bill_date'.tr,
                      type: JPInputBoxType.withLabel,
                      fillColor: JPAppTheme.themeColors.base,
                      readOnly: true,
                      suffixChild: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: JPIcon(
                          Icons.date_range,
                          color: JPAppTheme.themeColors.dimGray,
                        ),
                      ),
                      onPressed: controller.service.onClickBillDateField,
                      disabled: !controller.service.isFieldEditable(FormFieldType.dueOn),
                    ),),
                  const SizedBox(width: 15),
                  ///   Due Date
                  Expanded(
                    flex: 1,
                    child: JPInputBox(
                      inputBoxController: controller.service.dueDateController,
                      label: 'due_date'.tr,
                      readOnly: true,
                      suffixChild: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: JPIcon(
                          Icons.date_range,
                          color: JPAppTheme.themeColors.dimGray,
                        ),
                      ),
                      type: JPInputBoxType.withLabel,
                      fillColor: JPAppTheme.themeColors.base,
                      onPressed: controller.service.onClickDueDateField,
                      disabled: !controller.service.isFieldEditable(FormFieldType.dueOn),
                      validator: controller.validateDate,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ///   unit & division
          Padding(
            padding: EdgeInsets.only(top: controller.formUiHelper.verticalPadding),
            child: Row(
              children: [
                ///   Unit
                Expanded(
                  flex: 1,
                  child: JPInputBox(
                    inputBoxController: controller.service.unitController,
                    label: "${'unit'.tr} #",
                    type: JPInputBoxType.withLabel,
                    fillColor: JPAppTheme.themeColors.base,
                    disabled: !controller.service.isFieldEditable(FormFieldType.unit),
                    readOnly: false,
                    maxLength: 6,
                    onChanged: controller.onDataChanged,
                  ),),
                const SizedBox(width: 15,),
                ///   Division
                Expanded(
                  flex: 1,
                  child: JPInputBox(
                    inputBoxController: controller.service.divisionController,
                    hintText: 'default'.tr,
                    type: JPInputBoxType.withLabel,
                    label: 'division'.tr,
                    fillColor: JPAppTheme.themeColors.base,
                    disabled: !controller.service.isFieldEditable(FormFieldType.division),
                    readOnly: true,
                    onPressed: controller.service.selectDivision,
                    suffixChild: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: JPIcon(
                        Icons.keyboard_arrow_down_outlined,
                        color: JPAppTheme.themeColors.text,
                      ),
                    ),),),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          /// Srs Branch
          Visibility(
            visible: !Helper.isValueNullOrEmpty(controller.service.getSupplierDetails),
            child: InkWell(
              onTap: controller.service.openSupplierSelector,
              child: Row(
                children: [
                  Flexible(
                    child: JPText(
                      text: controller.service.getSupplierDetails,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const JPIcon(Icons.edit_outlined, size: 18),
                ],
              ),
            ),
          ),
          ///   Customer Signature
          Visibility(
            visible: controller.isWithSignature,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Transform.translate(
                offset: const Offset(-8, 8),
                child: JPCheckbox(
                  selected: controller.service.isWithSignature,
                  separatorWidth: 2,
                  padding: const EdgeInsets.all(4),
                  disabled: !controller.service.isFieldEditable(FormFieldType.signature),
                  borderColor: JPAppTheme.themeColors.themeGreen,
                  onTap: controller.service.toggleIsWithSignature,
                  text: "customer_signature".tr,
                )
              )
            ),
          ),
        ],
      ),
    ),
  );
  }
}
