import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/custom_fields/custom_fields.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/custom_fields/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../global_widgets/custom_material_card/index.dart';

class SRSInvoiceDetailTile extends StatelessWidget {
  const SRSInvoiceDetailTile({
    super.key,
    this.onTapOfAttachment, 
    this.invoiceNumber,
    this.invoiceTotal,
  });
  
  final String? invoiceNumber;
  final String? invoiceTotal;
  final VoidCallback? onTapOfAttachment;
  
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !Helper.isValueNullOrEmpty(invoiceNumber),
      child: CustomMaterialCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: JPText(
                text: "invoice_details".tr.toUpperCase(),
                textAlign: TextAlign.start,
                textSize: JPTextSize.heading5,
                textColor: JPAppTheme.themeColors.darkGray,
                fontWeight: JPFontWeight.medium,
              ),
            ),
            Padding(
               padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  JPText(
                    text: 'invoice_number'.tr,
                    textAlign: TextAlign.start,
                    textSize: JPTextSize.heading5,
                    textColor: JPAppTheme.themeColors.tertiary
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: JPText(
                          text:  invoiceNumber ?? '',
                          textAlign: TextAlign.start,
                          textColor: JPAppTheme.themeColors.text,
                          textSize: JPTextSize.heading4,
                        ),
                      ),
                      const SizedBox(width: 6,),
                      JPTextButton(
                        icon: Icons.attachment_outlined,
                        iconSize: 20,
                        onPressed: onTapOfAttachment,
                        color: JPAppTheme.themeColors.primary,
                      )
                    ],
                  ),
                ],
              ),             
            ),
            CustomFields(
              customFields: [
                CustomFieldsModel(
                  type: 'text',
                  name: 'invoice_total'.tr,
                  value: JobFinancialHelper.getCurrencyFormattedValue(value: invoiceTotal ?? '')
                ),
              ],
            ),
          ],
        )
      ),
    ); 
  }
}
