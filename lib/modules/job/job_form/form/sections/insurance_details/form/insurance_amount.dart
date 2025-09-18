import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/job/insurance_form/add_insurance.dart';
import 'package:jobprogress/core/constants/regex_expression.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/insurance_details/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class InsuranceAmountFormSection extends StatelessWidget {
  const InsuranceAmountFormSection({
    super.key,
    required this.controller,
  });

  final InsuranceDetailsFormController controller;

  Widget get inputFieldSeparator => SizedBox(height: controller.formUiHelper.inputVerticalSeparator);

  InsuranceDetailsFormService get service => controller.service;

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
          children: [
            JPInputBox(
              key: const Key(WidgetKeys.contingencyContractSignedDateKey),
              inputBoxController: service.contingencyContractSignedController,
              label: 'contingency_contract_signed_date'.tr,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              readOnly: true,
              onPressed: service.selectContingencyContractSignedDate,
              onChanged: controller.onDataChanged,
            ),
            inputFieldSeparator,
            JPInputBox(
              key: const Key(WidgetKeys.dateOfLossKey),
              inputBoxController: service.dateOfLossController,
              label: 'date_of_loss'.tr,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              readOnly: true,
              onPressed: service.selectDateOfLoss,
              onChanged: controller.onDataChanged,
            ),
            inputFieldSeparator,
            JPInputBox(
              key: const Key(WidgetKeys.claimFiledDateKey),
              inputBoxController: service.claimFiledController,
              label: 'claim_filed_date'.tr,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              readOnly: true,
              onPressed: service.selectClaimFieldDate,
              onChanged: controller.onDataChanged,
            ),
            inputFieldSeparator,
            JPInputBox(
              key: const Key(WidgetKeys.acvKey),
              inputBoxController: service.acvController,
              label: '${'acv'.tr}(${JobFinancialHelper.getCurrencySymbol()})',
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(RegexExpression.amount))],
              onChanged: (value) => service.calculateAmount(),
            ),
            inputFieldSeparator,
            JPInputBox(
              key: const Key(WidgetKeys.deductibleAmountKey),
              inputBoxController: service.deductibleAmountController,
              label: '${'deductible_amount'.tr}(${JobFinancialHelper.getCurrencySymbol()})',
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(RegexExpression.amount))],
              onChanged: (value) => service.calculateAmount(),
            ),
            inputFieldSeparator,
            JPInputBox(
              key: const Key(WidgetKeys.netClaimAmountKey),
              inputBoxController: service.netClaimAmountController,
              label: '${'net_claim_amount'.tr}(${JobFinancialHelper.getCurrencySymbol()})',
              hintText: '${'acv'.tr} - ${'deductible_amount'.tr}',
              readOnly: true,
              disabled: true,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
            ),
            inputFieldSeparator,
            JPInputBox(
              key: const Key(WidgetKeys.depreciationKey),
              inputBoxController: service.depreciationController,
              label: '${'depreciation'.tr}(${JobFinancialHelper.getCurrencySymbol()})',
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(RegexExpression.amount))],
              onChanged: (value) => service.calculateAmount(),
            ),
            inputFieldSeparator,
            JPInputBox(
              key: const Key(WidgetKeys.rcvKey),
              inputBoxController: service.rcvController,
              label: '${'rcv'.tr}(${JobFinancialHelper.getCurrencySymbol()})',
              hintText: '${'acv'.tr} + ${'depreciation'.tr}',
              readOnly: true,
              disabled: true,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
            ),
            inputFieldSeparator,
            JPInputBox(
              key: const Key(WidgetKeys.upgradesKey),
              inputBoxController: service.upgradesController,
              label: '${'upgrades'.tr}(${JobFinancialHelper.getCurrencySymbol()})',
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(RegexExpression.amount))],
              onChanged: (value) => service.calculateAmount(),
            ),
            inputFieldSeparator,
            JPInputBox(
              key: const Key(WidgetKeys.supplementsAmountKey),
              inputBoxController: service.supplementsController,
              label: '${'supplements_amount'.tr}(${JobFinancialHelper.getCurrencySymbol()})',
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(RegexExpression.amount))],
              onChanged: (value) => service.calculateAmount(),
            ),
            inputFieldSeparator,
            JPInputBox(
              key: const Key(WidgetKeys.totalKey),
              inputBoxController: service.totalController,
              label: '${'total'.tr}(${JobFinancialHelper.getCurrencySymbol()})',
              hintText: '${'rcv'.tr} + ${'supplements_amount'.tr} + ${'upgrades'.tr}',
              disabled: true,
              readOnly: true,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
            ),
          ],
        ),
      ),
    );
  }
}
