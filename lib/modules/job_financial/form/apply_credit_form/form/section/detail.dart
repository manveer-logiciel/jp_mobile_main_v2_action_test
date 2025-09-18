import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/credit/apply_credit_form.dart';
import 'package:jobprogress/core/constants/regex_expression.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/modules/job_financial/form/apply_credit_form/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ApplyCreditDetailsection extends StatelessWidget {
  const ApplyCreditDetailsection({
    super.key, required this.controller,
  });

  final ApplyCreditFormController controller;

  ApplyCreditFormService get service => controller.service;
   
  Widget get inputFieldSeparator => SizedBox(
    height: controller.formUiHelper.inputVerticalSeparator,
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JPAppTheme.themeColors.base,
      borderRadius:
        BorderRadius.circular(controller.formUiHelper.sectionBorderRadius), 
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: controller.formUiHelper.horizontalPadding,
          vertical: controller.formUiHelper.verticalPadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              JPText(
                text: 'apply_credit'.tr.toUpperCase(),
                fontWeight: JPFontWeight.medium,
                textColor: JPAppTheme.themeColors.darkGray,
              ),
              inputFieldSeparator,
              Visibility(
                visible: service.showLinkInvoiceField,
                child: JPInputBox(
                  inputBoxController: service.linkInvoiceListController,
                  label: '${'link'.tr.capitalize!} ${'invoice'.tr.capitalize!}',
                  type: JPInputBoxType.withLabel,
                  fillColor: JPAppTheme.themeColors.base,
                  readOnly: true,
                  disabled: controller.service.isSavingForm,
                  onPressed: service.openLinkListBottomsheet,
                  suffixChild: const Padding(
                    padding: EdgeInsets.only(right: 9),
                    child: JPIcon(Icons.keyboard_arrow_down),
                  ),
                ),
              ),
              if(service.showLinkInvoiceField) inputFieldSeparator,
            JPInputBox(
              inputBoxController: service.dateController,
              label: 'due_on'.tr,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              readOnly: true,
              isRequired: true,
              disabled: controller.service.isSavingForm,
              onPressed: service.selectDueOnDate,
              onChanged: (data){},
              suffixChild: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: JPIcon(
                  Icons.date_range,
                  color: JPAppTheme.themeColors.dimGray,
                ),
              ),
            ),
            inputFieldSeparator,
            JPInputBox( 
              inputBoxController: service.creditAmountController,
              fillColor: JPColor.white,
              type: JPInputBoxType.withLabel,
              isRequired: true,
              disabled: controller.service.isSavingForm,
              label: '${'credit'.tr.capitalize!} ${'amount'.tr.capitalizeFirst!}(${JobFinancialHelper.getCurrencySymbol()})',
              hintText: "0.00",
              maxLength: 9,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(RegexExpression.amount)),],
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: controller.onDataChanged,
              onPressed: null,
              validator:(val)=> service.validateCredit(val),
            ),
            inputFieldSeparator,
            JPInputBox(
              inputBoxController: service.noteController,
              label: 'note'.tr.capitalize,
              isRequired: true,
              disabled: controller.service.isSavingForm,
              onChanged: controller.onDataChanged,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              maxLines: 4,
              validator: (val)=> service.validateNote(val),
            ),
          ],
        ),
      ),
    );
  }
}
