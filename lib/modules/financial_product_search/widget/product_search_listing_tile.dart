import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/financial_product/financial_product_model.dart';
import 'package:jobprogress/common/services/worksheet/helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/text_size.dart';
import 'package:jp_mobile_flutter_ui/Text/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

import '../../../common/models/job/job_division.dart';
import 'supplier_icon.dart';

class ProductSearchListingTile extends StatelessWidget {

  final FinancialProductModel productModel;
  final String productName;
  final VoidCallback onTapItem;
  final bool showSellingPrice;
  final bool isSellingPriceUnavailable;
  final DivisionModel? jobDivision;

  const ProductSearchListingTile({
    super.key,
    required this.productModel,
    required this.onTapItem, 
    required this.productName,
    this.showSellingPrice = true,
    this.isSellingPriceUnavailable = false,
    this.jobDivision
  });

  String get supplierName => productModel.supplier?.name != null ? ' ( ${productModel.supplier?.name} ) ' : '';
  bool get showUnavailableLabel => productModel.notAvailable || productModel.notAvailableInPriceList;
  /// [showVariants] will help in displaying the variants only if line item has variants and it has beacon supplier
  bool get showVariants => !Helper.isValueNullOrEmpty(productModel.variantsString);

  String get itemCode => Helper.isSRSv2Id(productModel.supplier?.id)
      ? productModel.code ?? ''
      : Helper.isValueNullOrEmpty(productModel.variants?.firstOrNull?.code)
      ? productModel.code ?? ''
      :  productModel.variants?.firstOrNull?.code ?? '';

  bool get hasIntegratedSupplier => Helper.isSRSv1Id(productModel.supplier?.id)
          || Helper.isSRSv2Id(productModel.supplier?.id)
          || Helper.isBeaconSupplierId(productModel.supplier?.id)
          || Helper.isABCSupplierId(productModel.supplier?.id);

  bool get isUnassignedLabel=> jobDivision?.id != null
      && productModel.supplier?.id != null
      && !hasIntegratedSupplier
      && !Helper.isValueNullOrEmpty(productModel.supplier?.divisions)
      && (jobDivision?.enableAllSupplierSearch ?? false)
      && !WorksheetHelpers.isDivisionMatches(productModel.supplier?.divisions, jobDivision?.id);

  bool get isQXOUnitCostZero => !showSellingPrice
      && (productModel.isBeaconProduct ?? false)
      && !showUnavailableLabel
      && (num.tryParse(productModel.unitCost ?? '0.0') ?? 0.0) <= 0.0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapItem,
      child: Container(
        width: double.infinity,
        color: JPAppTheme.themeColors.base,
        padding: const EdgeInsets.only(top: 12,left: 16,bottom: 8, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JPText(
              text: productName,
              textSize: JPTextSize.heading4,
              textAlign: TextAlign.left,
            ),
            if (!Helper.isSRSv2Id(productModel.supplier?.id)
                && !Helper.isValueNullOrEmpty(productModel.description))
              JPText(
                text: productModel.description.toString(),
                textSize: JPTextSize.heading5,
                maxLine: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            const SizedBox(height: 7),
            textWithLabel(
              label: "${'price'.tr}:",
              value: JobFinancialHelper.getCurrencyFormattedValue(
               isPlaceholder: isSellingPriceUnavailable,
               value: showSellingPrice ? productModel.sellingPrice : productModel.unitCost
               ),
            ),
            if (showVariants) ...{
              textWithLabel(
                label: "${'variations'.tr}:",
                value: productModel.variantsString ?? "",
              ),
            } else ...{
              if (!Helper.isValueNullOrEmpty(productModel.styles))
                textWithLabel(
                  label: "${'styles'.tr}:",
                  value: productModel.styles?.join(', ') ?? '',
                ),
              if (!Helper.isValueNullOrEmpty(productModel.sizes))
                textWithLabel(
                  label: "${'sizes'.tr}:",
                  value: productModel.sizes?.join(', ') ?? '',
                ),
              if (!Helper.isValueNullOrEmpty(productModel.colors))
                textWithLabel(
                  label: "${'colors'.tr}:",
                  value: productModel.colors?.join(', ') ?? '',
                ),
            },

            if (itemCode.isNotEmpty)
              textWithLabel(
                label: "${'item_code'.tr}:",
                value: itemCode,
              ),

            if(!Helper.isValueNullOrEmpty(productModel.supplier?.name))
              textWithLabel(
                label: 'supplier'.tr+":",
                value: productModel.supplier!.name!,
                isUnassignedLabel: isUnassignedLabel
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      if(!Helper.isValueNullOrEmpty(productModel.branch))
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: JPText(
                            text: productModel.branch! + supplierName,
                            textSize: JPTextSize.heading5,
                            maxLine: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      if (productModel.productCategory?.name != null)
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                          decoration: BoxDecoration(
                            color: JPAppTheme.themeColors.inverse,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: JPText(
                            text: productModel.productCategory?.name ?? '',
                            textSize: JPTextSize.heading5,
                          ),
                        ),
                      if (showUnavailableLabel)
                        JPText(
                          text: 'unavailable_product_in_branch'.tr,
                          textAlign: TextAlign.left,
                          textSize: JPTextSize.heading5,
                          textColor: JPAppTheme.themeColors.darkGray,
                        ),

                      if(isQXOUnitCostZero)
                        JPText(
                          text: 'price_will_be_cal'.tr,
                          textAlign: TextAlign.left,
                          textSize: JPTextSize.heading5,
                          textColor: JPAppTheme.themeColors.darkGray,
                        )
                    ],
                  ),
                ),
                FinancialProductSupplierIcon(
                  product: productModel..branchLogo,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget textWithLabel({required String label, required String value, int maxLine = 1, bool isUnassignedLabel = false}) {
    return Row(
      children: [
        JPText(
          text: label,
          textSize: JPTextSize.heading4,
          textColor: JPAppTheme.themeColors.secondaryText,
        ),
        const SizedBox(width: 5),
        Flexible(
          child: JPText(
            text: value,
            textSize: JPTextSize.heading4,
            textColor: JPAppTheme.themeColors.tertiary,
            maxLine: maxLine,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        if(isUnassignedLabel) ...{
          Row(
            children: [
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                decoration: BoxDecoration(
                  color: JPAppTheme.themeColors.lightBlue,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: JPText(
                  text: 'unassigned'.tr,
                  textSize: JPTextSize.heading5,
                ),
              ),
            ],
          )
        }
      ],
    );
  }
}
