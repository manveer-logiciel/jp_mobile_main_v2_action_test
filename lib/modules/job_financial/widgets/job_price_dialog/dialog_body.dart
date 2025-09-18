import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/IconButton/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../core/utils/job_financial_helper.dart';
import 'controller.dart';

class JobPriceDialogBody extends StatelessWidget {
  const JobPriceDialogBody({
    super.key,
    required this.controller});

  final JobPriceDialogController controller;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///   Radio Buttons
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 27),
                    child: JPRadioBox(
                      groupValue: controller.taxStatusRadioGroup,
                      onChanged: (val) => controller.updateRadioValue(val),
                      radioData: [
                        JPRadioData(
                          value: true,
                          label: "taxable".tr,
                          disabled: controller.isLoading,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 27, left: 35),
                    child: JPRadioBox(
                      groupValue: controller.taxStatusRadioGroup,
                      onChanged: (val) => controller.updateRadioValue(val),
                      radioData: [
                        JPRadioData(
                          value: false,
                          label: "tax_exempt".tr,
                          disabled: controller.isLoading,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              ///
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///   amount
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: JPInputBox( 
                      isRequired: true,
                      controller: controller.amountController,
                      fillColor: JPColor.white,
                      type: JPInputBoxType.withLabel,
                      label: "${"amount".tr.capitalize} (${JobFinancialHelper.getCurrencySymbol()})",
                      hintText: "0.00",
                      maxLength: 9,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),],
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      readOnly: false,
                      disabled: controller.isLoading,
                      onChanged: (val) => controller.onAmountTextChange(val.trim()),
                      validator: (val) => (val?.isEmpty ?? true) ? "enter_valid_amount".tr : "",
                      onSaved: (val) => controller.jobPriceModel.amount = double.parse(val),
                    ),
                  ),

                  ///   total job price
                  Visibility(
                    visible: controller.taxStatusRadioGroup,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: JPInputBox(
                        controller: controller.totalJobPriceController,
                        fillColor: JPColor.white,
                        type: JPInputBoxType.withLabel,
                        label: "${"total_job_price".tr.capitalize} (${JobFinancialHelper.getCurrencySymbol()})",
                        hintText: "0.00",
                        readOnly: false,
                        maxLength: 9,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),],
                        disabled: controller.isLoading,
                        onChanged: (val) => controller.onTotalPriceTextChange(val.trim()),
                        validator: (val) => (val?.isEmpty ?? true)
                            ? "enter_valid_amount".tr
                            : "",
                        onSaved: (val) => controller.jobPriceModel.total = double.parse(val),
                      ),
                    ),
                  ),
                  ///   Tax amount and percentage
                  Visibility(
                    visible: controller.taxStatusRadioGroup,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              runSpacing: 5,
                              children: [
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top:5),
                                      child: JPText(
                                        text: "${"tax_amount".tr}: ${JobFinancialHelper.getCurrencyFormattedValue(value: controller.jobPriceModel.taxAmount)}",
                                        textColor: JPAppTheme.themeColors.tertiary,
                                        fontWeight: JPFontWeight.medium,
                                      ),
                                    ),
                                    Visibility(
                                      visible: (controller.jobModel?.financialDetails?.isDerivedTax ?? 0) == 1,
                                      child: JPIconButton(
                                        backgroundColor: JPAppTheme.themeColors.base,
                                        icon: Icons.info_outline,
                                        iconSize: 16,
                                        iconColor: JPAppTheme.themeColors.primary,
                                        onTap: controller.isInfoVisible
                                            ? null
                                            : () => controller.updateInfoVisible(),
                                      ),
                                    )
                                  ],
                                ),
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top:5),
                                      child: JPText(
                                        text: "${"tax".tr}: ${JobFinancialHelper.getRoundOff(controller.jobPriceModel.taxRate ?? 0)} %",
                                        textColor: JPAppTheme.themeColors.tertiary,
                                        fontWeight: JPFontWeight.medium,
                                        
                                      ),
                                    ),
                                    Visibility(
                                      visible: controller.jobModel?.jobInvoices?.isEmpty ?? false,
                                      child: JPIconButton(
                                        backgroundColor: JPAppTheme.themeColors.base,
                                        icon: Icons.edit_outlined,
                                        iconSize: 16,
                                        iconColor: JPAppTheme.themeColors.primary,
                                        onTap: () => controller.openBottomSheet(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ///   Information
                  Visibility(
                      visible: controller.isInfoVisible && controller.taxStatusRadioGroup,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.fromLTRB(15, 13, 8, 10),
                        decoration: BoxDecoration(
                            color: JPAppTheme.themeColors.inverse,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: JPText(
                                    text: (controller.jobModel?.jobInvoices?.isEmpty ?? true)
                                        ? "tax_is_derived_reason_could_be_as_following".tr
                                        : "tax_is_derived_and_cannot_changed_reason_could_be_as_following".tr,
                                    fontWeight: JPFontWeight.medium,
                                    textSize: JPTextSize.heading5,
                                    textAlign: TextAlign.start,
                                    textColor: JPAppTheme.themeColors.tertiary,
                                  ),
                                ),
                                JPIconButton(
                                  isDisabled: controller.isLoading,
                                  backgroundColor: JPAppTheme.themeColors.inverse,
                                  icon: Icons.clear,
                                  iconColor: JPAppTheme.themeColors.tertiary,
                                  iconSize: 22,
                                  onTap: () => controller.updateInfoVisible(),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10, right: 10),
                              child: JPBulletList(
                                stringList: controller.getStringList(),
                              ),
                            )
                          ],
                        ),
                      )),
                  ///   Revised tax
                  Visibility(
                    visible: controller.isRevisedTaxCheckboxVisible(),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 27),
                      child: JPCheckbox(
                        onTap: (value) => controller.updateAppliedTax(value),
                        padding: EdgeInsets.zero,
                        text: "${"apply_revised_tax".tr.capitalize} (${JobFinancialHelper.getRoundOff(controller.getTaxRate(controller.jobModel, isRevised: true))} %)".tr,
                        borderColor: JPAppTheme.themeColors.themeGreen,
                        selected: controller.revisedTaxRadioGroup,
                        disabled: controller.isLoading,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
