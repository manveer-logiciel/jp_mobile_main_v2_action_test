import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/common/services/worksheet/helpers.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/details_listing_tile/widgets/label_value_tile.dart';
import 'package:jobprogress/global_widgets/sheet_line_item_listing/sheet_line_item_tile/widgets/index_number.dart';
import 'package:jobprogress/global_widgets/sheet_line_item_listing/sheet_line_item_tile/widgets/price_quantity.dart';
import 'package:jobprogress/global_widgets/sheet_line_item_listing/sheet_line_item_tile/widgets/title.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../common/models/job/job_division.dart';
import '../../../common/models/sheet_line_item/sheet_line_item_model.dart';
import 'widgets/worksheet_additional_info.dart';

class SheetLineItemTile extends StatelessWidget {

  final SheetLineItemModel itemModel;
  final Function(SheetLineItemModel item) onTap;
  final AddLineItemFormType? pageType;
  final int index;
  final bool isBottomRadius;
  final bool isTopRadius;
  final bool isTaxable;
  final bool isReOrderAble;
  final bool isSupplierEnable;
  final bool isAbcEnable;
  final Color? stripColor;
  final VoidCallback? onTapMoreDetails;
  final bool isBeaconOrder;
  final bool isAbcOrder;
  final DivisionModel? jobDivision;
  final bool showVariationConfirmationValidation;
  final Function(SheetLineItemModel item)? onTapVariationConfirmation;
  final VoidCallback? onTapBeaconMoreDetails;

  const SheetLineItemTile({super.key,
    required this.itemModel,
    required this.onTap,
    required this.index,
    required this.isBottomRadius,
    required this.isTopRadius,
    required this.isTaxable,
    required this.pageType,
    this.isReOrderAble = true,
    this.isSupplierEnable = false,
    this.isAbcEnable = false,
    this.stripColor,
    this.onTapMoreDetails,
    this.isBeaconOrder = false,
    this.isAbcOrder = false,
    this.jobDivision,
    this.showVariationConfirmationValidation = false,
    this.onTapVariationConfirmation,
    this.onTapBeaconMoreDetails
  });

  WorksheetSettingModel? get settings => itemModel.workSheetSettings;

  bool get hidePricing => pageType == AddLineItemFormType.worksheet
      && (!(settings?.showLineTotal ?? false) && (settings?.hidePricing ?? false));

  bool get isMaterialSupplierProduct => Helper.isSRSv1Id(itemModel.supplier?.id)
      || Helper.isSRSv2Id(itemModel.supplier?.id)
      || Helper.isSRSv1Id(itemModel.product?.supplierId)
      || Helper.isSRSv2Id(itemModel.product?.supplierId)
      || itemModel.supplier?.id == Helper.getSupplierId(key: CommonConstants.beaconId)
      || itemModel.product?.supplierId == Helper.getSupplierId(key: CommonConstants.beaconId)
      || itemModel.supplier?.id == Helper.getSupplierId(key: CommonConstants.abcSupplierId)
      || itemModel.product?.supplierId == Helper.getSupplierId(key: CommonConstants.abcSupplierId);

  bool get showUnavailableLabel => isSupplierEnable
      && pageType == AddLineItemFormType.worksheet
      && isMaterialSupplierProduct
      && (itemModel.product!.notAvailable || itemModel.product!.notAvailableInPriceList);

  bool get isItemColorSelected => !isAbcEnable && isSupplierEnable && (!Helper.isValueNullOrEmpty(itemModel.product?.colors)
      && Helper.isValueNullOrEmpty(itemModel.color));

  bool get isMaterialSupplier => itemModel.supplier != null && isMaterialSupplierProduct;

  String get _getTotalPrice => Helper.isValueNullOrEmpty(itemModel.totalPrice) || double.parse(itemModel.totalPrice!) == 0
      ? '--' : JobFinancialHelper.getCurrencyFormattedValue(value: itemModel.totalPrice);

  /// [showVariants] will help in displaying the variants only if line item has variants
  bool get showVariants => !Helper.isValueNullOrEmpty(itemModel.variantsString);

  bool get isBeaconEnable => itemModel.supplier?.id == Helper.getSupplierId(key: CommonConstants.beaconId);

  bool get isSellingPriceUnavailable => isMaterialSupplier && Helper.isTrue(
      itemModel.product?.showSellingPriceNotAvailable(
          pageType,
          Helper.isTrue(settings?.isEstimateOrProposalWorksheet),
          Helper.isTrue(settings?.enableSellingPrice)
      ));

  bool get isBeaconOrABCQuantityZero => (isBeaconEnable || isAbcEnable) && WorksheetHelpers.isBeaconOrABCQuantityZero([itemModel]) && (isBeaconOrder || isAbcOrder);

  bool get isDivisionUnassigned => jobDivision?.id != null
      && itemModel.supplier?.id != null
      && !isMaterialSupplier
      && !(jobDivision?.enableAllSupplierSearch ?? true)
      && !Helper.isValueNullOrEmpty(itemModel.supplier?.divisions)
      && !WorksheetHelpers.isDivisionMatches(itemModel.supplier?.divisions, jobDivision?.id);

  bool get isVariationConfirmationValidationRequired => showVariationConfirmationValidation
      && (Helper.isTrue(itemModel.isConfirmedVariationRequired)
      && !Helper.isTrue(itemModel.isConfirmedVariation));

  bool get isBeaconProduct =>
      itemModel.supplier?.id == Helper.getSupplierId(key: CommonConstants.beaconId) ||
          itemModel.product?.supplierId == Helper.getSupplierId(key: CommonConstants.beaconId);

  bool get isQXOUnitCostZero => !(settings?.enableSellingPrice ?? false)
      && isBeaconEnable
      && isBeaconProduct
      && !showUnavailableLabel
      && (num.tryParse(itemModel.unitCost ?? '0.0') ?? 0.0) <= 0.0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap.call(itemModel),
      child: Container(
        padding: isReOrderAble
            ? const EdgeInsets.fromLTRB(6.67, 20, 16, 15)
            : const EdgeInsets.fromLTRB(20, 0, 20, 15),
        margin:  EdgeInsets.only(top: index >1 ? 1 : 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(isTopRadius ? 18 : 0),
            topLeft:  Radius.circular(isTopRadius ? 18 : 0),
            bottomLeft: Radius.circular(isBottomRadius ? 18 : 0),
            bottomRight: Radius.circular(isBottomRadius ? 18 : 0),
          ),
          color: ((isMaterialSupplier && isItemColorSelected)
              || isBeaconOrABCQuantityZero
              || isDivisionUnassigned
              || isSellingPriceUnavailable
              || showUnavailableLabel
              || isVariationConfirmationValidationRequired
              || isQXOUnitCostZero
          ) ? JPAppTheme.themeColors.dimRed : JPAppTheme.themeColors.base,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (stripColor == null) ...{
                  Visibility(
                    visible: isReOrderAble,
                    child: JPIcon(Icons.drag_indicator_outlined,
                      color: JPAppTheme.themeColors.secondaryText,
                      size: 18,
                    ),
                  ),
                } else ...{
                  Transform.translate(
                    offset: const Offset(-7, 0),
                    child: Container(
                      height: 4,
                      width: 16,
                      margin: const EdgeInsets.symmetric(
                        vertical: 6
                      ),
                      color: stripColor,
                    ),
                  )
                },
                SheetLineItemIndexNumber(index: index),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SheetLineItemTitle(itemModel: itemModel),
                        if (pageType == AddLineItemFormType.worksheet) ...{
                          workSheetAdditionalInfo(),
                        } else ...{
                          additionalInformation(),
                        },
                      ],
                    )
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!hidePricing)
                        JPText(
                        text: _getTotalPrice,
                        textSize: JPTextSize.heading4,
                        textColor: JPAppTheme.themeColors.primary,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 3),
                      SheetLineItemPriceQuantityTile(
                        itemModel: itemModel,
                        pageType: pageType!
                      ),
                      Visibility(
                        visible: isTaxable && (itemModel.isTaxable ?? false),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: JPText(
                            text: "taxable".tr,
                            textSize: JPTextSize.heading5,
                            textColor: JPAppTheme.themeColors.darkGray,
                          ),
                        ),
                      ),
                
                    ]
                )
              ],
            ),

            if (pageType == AddLineItemFormType.worksheet) ...{
              const SizedBox(height: 5,),
              SheetLineItemWorksheetAdditionalInfo(
                itemModel: itemModel,
                jobDivision: jobDivision,
                isMaterialSupplier: isMaterialSupplier,
              ),
            },

            Visibility(
              visible: showUnavailableLabel,
              child: Padding(
                padding: const EdgeInsets.only(left: 35, top: 5),
                child: Row(
                  children: [
                    JPText(
                      text: 'unavailable_product_in_branch'.tr,
                      textAlign: TextAlign.left,
                      textSize: JPTextSize.heading5,
                      textColor: JPColor.red,
                    ),
                    JPTextButton(
                      text: 'more_details'.tr,
                      textSize: JPTextSize.heading5,
                      padding: 3,
                      color: JPAppTheme.themeColors.primary,
                      textDecoration: TextDecoration.underline,
                      onPressed: onTapMoreDetails,
                    ),
                  ],
                ),
              ),
            ),

            Visibility(
              visible: isSellingPriceUnavailable,
              child: Padding(
                padding: const EdgeInsets.only(left: 35, top: 5),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: JPText(
                    text: 'unavailable_selling_price'.tr,
                    textAlign: TextAlign.left,
                    textSize: JPTextSize.heading5,
                    textColor: JPColor.red,
                  ),
                ),
              ),
            ),

            Visibility(
              visible: pageType == AddLineItemFormType.insuranceForm,
              child: Padding(
                padding: const EdgeInsets.only(left: 28),
                child: insuranceInformation(),
              ),
            ),

            Visibility(
              visible: isDivisionUnassigned,
              child: Padding(
                padding: const EdgeInsets.only(left: 35, top: 5),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: JPText(
                    text: 'supplier_is_not_assigned_to_division'.tr,
                    textAlign: TextAlign.left,
                    textSize: JPTextSize.heading5,
                    textColor: JPColor.red,
                  ),
                ),
              ),
            ),

            Visibility(
              visible: isVariationConfirmationValidationRequired,
              child: Padding(
                padding: const EdgeInsets.only(left: 35, top: 5),
                child: Row(
                  children: [
                    JPText(
                      text: 'this_item_requires'.tr,
                      textAlign: TextAlign.left,
                      textSize: JPTextSize.heading5,
                      textColor: JPColor.red,
                    ),
                    JPTextButton(
                      text: 'variation_confirmation'.tr,
                      textSize: JPTextSize.heading5,
                      padding: 3,
                      color: JPAppTheme.themeColors.primary,
                      textDecoration: TextDecoration.underline,
                      onPressed: () => onTapVariationConfirmation?.call(itemModel..currentIndex = index - 1),
                    ),
                  ],
                ),
              ),
            ),

            Visibility(
              visible: isQXOUnitCostZero,
              child: Padding(
                padding: const EdgeInsets.only(left: 35, top: 5),
                child: Row(
                  children: [
                    JPText(
                      text: 'price_will_be_cal'.tr,
                      textAlign: TextAlign.left,
                      textSize: JPTextSize.heading5,
                      textColor: JPColor.red,
                    ),
                    JPTextButton(
                      text: 'more_details'.tr,
                      textSize: JPTextSize.heading5,
                      padding: 3,
                      color: JPAppTheme.themeColors.primary,
                      textDecoration: TextDecoration.underline,
                      onPressed: onTapBeaconMoreDetails,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget insuranceInformation() {
    List<Widget> getColChildren({bool isColumnOne = false}) {
      List<Widget> cols = <Widget>[];

      if(itemModel.tradeType != null) {
        cols.add(LabelValueTile(
          textSize: JPTextSize.heading5,
          label: "${"trade_type".tr}:",
          value: itemModel.tradeType?.label ?? "",
          enablePadding: true,
        ));
      }

      if(!Helper.isValueNullOrEmpty(itemModel.sellingPrice) && Helper.isTrue(itemModel.showSellingPrice)) {
        cols.add(LabelValueTile(
            textSize: JPTextSize.heading5,
            label: 'selling_price'.tr.capitalize!,
            value:!Helper.isValueNullOrEmpty(itemModel.sellingPrice)? JobFinancialHelper.getCurrencyFormattedValue(value: itemModel.sellingPrice): '',
            enablePadding: true
        ));
      } else if(!Helper.isValueNullOrEmpty(itemModel.price)) {
        cols.add(LabelValueTile(
          textSize: JPTextSize.heading5,
          label: 'unit_price'.tr.capitalize!,
          value:!Helper.isValueNullOrEmpty(itemModel.price)? JobFinancialHelper.getCurrencyFormattedValue(value: itemModel.price): '',
          enablePadding: true
        ));  
      }

      if(itemModel.unit != null) {
        cols.add(LabelValueTile(
          textSize: JPTextSize.heading5,
          label: 'unit'.tr.capitalize!,
          value: itemModel.unit,
          enablePadding: true
        ));
      }
      
      if(!Helper.isValueNullOrEmpty(itemModel.qty)) {
        cols.add(LabelValueTile(
          textSize: JPTextSize.heading5,
          label: 'quantity'.tr.capitalize!, 
          value: itemModel.qty,enablePadding: true
        ));
      }
      if(!Helper.isValueNullOrEmpty(itemModel.rcv)) {
        cols.add(LabelValueTile(
          textSize: JPTextSize.heading5,
          label: 'rcv'.tr.capitalize!,
          value: JobFinancialHelper.getCurrencyFormattedValue(value: itemModel.rcv?? '0.0'),
          enablePadding: true
        ));
      }
      if(!Helper.isValueNullOrEmpty(itemModel.tax)){
        cols.add(LabelValueTile(
          textSize: JPTextSize.heading5,
          label: 'tax'.tr.capitalize!, 
          value:  Helper.isValueNullOrEmpty(itemModel.tax) ? '' : 
          JobFinancialHelper.getCurrencyFormattedValue(value: itemModel.tax),
          enablePadding: true
        ));
      }   
      if(!Helper.isValueNullOrEmpty(itemModel.depreciation)) {
        cols.add(LabelValueTile(
          textSize: JPTextSize.heading5,
          label: 'depreciation'.tr,
          value: Helper.isValueNullOrEmpty(itemModel.depreciation) ? '' :
          JobFinancialHelper.getCurrencyFormattedValue(value: itemModel.depreciation),
          enablePadding: true
        ));
      }
      
      bool isLengthEven = (cols.length % 2 == 0);

      double subLength = (cols.length / 2) + (isLengthEven ? 0 : 1);

      List<Widget> subList1 = cols.sublist(0, subLength.toInt());
      List<Widget> subList2 = cols.sublist(subLength.toInt());

      if(isColumnOne) return subList1;
      return subList2;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [    
        Expanded(
          child: Container(
              padding: const EdgeInsets.only(top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: getColChildren(isColumnOne: true)
                )
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ 
                Column(
                  children: getColChildren()              
                ),
              ],
            ) 
          ),
        ),
      ],
    );
  }

  Widget workSheetAdditionalInfo() {
    final categoryName = itemModel.product?.productCategory?.name;

    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 2, 0, 0),
      child: JPText(
        text: categoryName ?? "",
        textSize: JPTextSize.heading6,
        textColor: JPAppTheme.themeColors.tertiary,
      ),
    );
  }

  Widget additionalInformation() => Container(
      padding: const EdgeInsets.only(top: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///   Trade Type
          LabelValueTile(
            visibility: itemModel.tradeType != null && pageType != AddLineItemFormType.insuranceForm ,
            textSize: JPTextSize.heading5,
            label: "${"trade_type".tr}:",
            value: itemModel.tradeType?.label ?? "",
            enablePadding: true,
          ),
          ///   Work Type
          LabelValueTile(
            visibility: itemModel.workType != null,
            textSize: JPTextSize.heading5,
            label: "${"work_type".tr}:",
            value: itemModel.workType?.label ?? "",
            enablePadding: true,
          ),
          ///   Accounting Head
          LabelValueTile(
            visibility: itemModel.accountingHeadModel != null,
            textSize: JPTextSize.heading5,
            label: "${"accounting_head".tr}:",
            value: itemModel.accountingHeadModel?.label ?? "",
            enablePadding: true,
          ),
          ///   variants
          LabelValueTile(
            visibility: showVariants,
            textSize: JPTextSize.heading5,
            label: "${"variants".tr}:",
            value: itemModel.variantsString ?? "",
            enablePadding: true,
          ),
        ]
      )
  );
}
