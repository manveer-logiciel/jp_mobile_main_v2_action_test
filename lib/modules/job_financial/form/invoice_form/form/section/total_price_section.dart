import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/IconButton/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../../common/services/job_financial/forms/invoice_form/invoice_form.dart';
import '../../../../../../core/utils/job_financial_helper.dart';
import '../../../../../../global_widgets/financial_form/financial_form_total_price_tile/index.dart';
import '../../../../../../global_widgets/financial_form/financial_form_total_price_tile/widget/financial_total_price_item.dart';

class InvoiceFormTotalPriceSection extends StatelessWidget {
  const InvoiceFormTotalPriceSection({
    super.key,
    required this.service,
  });

  final InvoiceFormService service;

  @override
  Widget build(BuildContext context) {
    return FinancialFormTotalPriceTile(
      labelValueList: [
        ///   List Total
        FinancialTotalPriceItem(
          labelWidget: JPText(
            text: 'list_total'.tr,
            textColor: JPAppTheme.themeColors.tertiary,
          ),
          valueWidget: JPText(
            text: JobFinancialHelper.getCurrencyFormattedValue(value: service.itemsTotalPrice),
            textColor: JPAppTheme.themeColors.text,
          ),
        ),
        ///   Taxable Amount
        Visibility(
          visible: service.getTotalTaxableAmount != 0,
          child: FinancialTotalPriceItem(
            tilePadding: const EdgeInsets.only(top: 7),
            labelWidget: JPText(
              text: "taxable_amount".tr,
              textColor: JPAppTheme.themeColors.tertiary,
            ),
            valueWidget: JPText(
              text: JobFinancialHelper.getCurrencyFormattedValue(value: service.getTotalTaxableAmount),
              textColor: JPAppTheme.themeColors.text,
            ),
          ),
        ),
        ///   Tax rate
        FinancialTotalPriceItem(
          tilePadding: const EdgeInsets.only(top: 1.5),
          labelWidget: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              JPText(
                text: "${"tax".tr}: ${JobFinancialHelper.getRoundOff(service.taxRate)} %",
                textColor: JPAppTheme.themeColors.tertiary,
              ),
              JPIconButton(
                backgroundColor: JPAppTheme.themeColors.lightBlue.withValues(alpha: 0.4),
                icon: Icons.edit_outlined,
                iconSize: 16,
                iconColor: JPAppTheme.themeColors.primary,
                onTap: service.controller.isSavingForm ? null : service.selectTaxRate,
              ),
            ],
          ),
          valueWidget: JPText(
            text: JobFinancialHelper.getCurrencyFormattedValue(value: service.totalTaxAmount),
            textColor: JPAppTheme.themeColors.text,
          ),
        ),
        ///   Total
        FinancialTotalPriceItem(
          tilePadding: const EdgeInsets.only(top: 2),
          labelWidget: JPText(
            text: "total_price".tr,
            textColor: JPAppTheme.themeColors.text,
            textSize: JPTextSize.heading3,
          ),
          valueWidget: JPText(
            text: JobFinancialHelper.getCurrencyFormattedValue(value: service.totalInvoicePrice),
            textColor: JPAppTheme.themeColors.text,
            textSize: JPTextSize.heading2,
            fontWeight: JPFontWeight.medium,
            textAlign: TextAlign.left,
          ),
        ),

        ///   Apply Revised Tax
        Visibility(
          visible: service.getIsRevisedTaxable,
          child: Align(
              alignment: Alignment.centerLeft,
              child: Transform.translate(
                  offset: const Offset(-10, 4),
                  child: JPCheckbox(
                    selected: service.isRevisedTaxable,
                    separatorWidth: 2,
                    padding: const EdgeInsets.all(4),
                    disabled: !service.isFieldEditable(null),
                    borderColor: JPAppTheme.themeColors.themeGreen,
                    onTap: service.toggleIsRevisedTaxable,
                    text: "${"apply_revised_tax".tr.capitalize} (${JobFinancialHelper.getRoundOff(service.revisedTaxRate)}%)",
                  )
              )
          ),
        ),
      ],
    );
  }
}
