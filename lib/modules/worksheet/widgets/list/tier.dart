import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jobprogress/common/models/popover_action.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_worksheet.dart';
import 'package:jobprogress/core/constants/assets_files.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/expansion_tile/index.dart';
import 'package:jobprogress/global_widgets/sheet_line_item_listing/index.dart';
import 'package:jobprogress/modules/worksheet/controller.dart';
import 'package:jp_mobile_flutter_ui/PopUpMenu/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'index.dart';
import 'tier_sub_total/index.dart';

class WorksheetTierItem extends StatelessWidget {

  const WorksheetTierItem({
    super.key,
    this.item,
    this.subTiers,
    this.subItems,
    this.isDisabled = false,
    this.isFirstItem = true,
    this.isLastItem = true,
    this.stripColor,
    this.parentItem,
    required this.service,
    required this.index,
    required this.controller,
  });

  /// [item] helps in rendering very first item of tier's hierarchy
  final SheetLineItemModel? item;

  /// [parentItem] is passed on in sub tiers for performing some actions
  final SheetLineItemModel? parentItem;

  /// [subTiers] a list of sub tiers that helps in deciding whether
  /// parent item has sub tier or not
  final List<SheetLineItemModel>? subTiers;

  /// [subItems] a list of sub tiers that helps in deciding whether
  /// parent item has sub items or not and render accordingly
  final List<SheetLineItemModel>? subItems;

  /// [isDisabled] helps in disabling item clicks
  final bool isDisabled;

  /// [isFirstItem] helps in deciding border radius
  final bool isFirstItem;

  /// [isLastItem] helps in deciding border radius
  final bool isLastItem;

  /// [stripColor] helps in displaying color strip on line items
  final Color? stripColor;

  /// [index] can be useful while performing item re-ordering
  final int index;

  final WorksheetFormController controller;

  final WorksheetFormService service;

  SheetLineItemModel? get currentItem => (subTiers?.isNotEmpty ?? false) ? subTiers!.first : item;

  bool get hasSubTiers => currentItem?.subTiers?.isNotEmpty ?? false;

  BorderRadius get borderRadius => BorderRadius.circular(18);

  bool get showTierTotal => (service.settings?.showTierTotal ?? true) || !(service.settings?.hidePricing ?? false);

  /// [showTierSubtotals] help is displaying subtotals selector on tier level
  /// It will be in effect only when MetroBath feature is enabled and
  /// Tier Subtotals setting is enabled
  bool get showTierSubtotals => service.doShowTierSubTotals();

  bool get showTierColor => service.settings?.showTierColor ?? true;

  bool get showTierWarning => Helper.isTrue(currentItem?.doHighlightTier());

  @override
  Widget build(BuildContext context) {
    if (currentItem?.tier == null) {
      if ((subItems?.isNotEmpty ?? false)) {
        return getLineItems(subItems ?? []);
      } else if (currentItem != null) {
        return getLineItems([currentItem!], isSingleItem: true);
      } else {
        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: 40
          ),
          margin: const EdgeInsets.fromLTRB(0, 4, 4, 4),
          decoration: BoxDecoration(
              color: JPAppTheme.themeColors.base,
              borderRadius: BorderRadius.circular(16)
          ),
          child: Center(
            child: JPText(
              text: 'no_item_added_yet'.tr,
              textColor: JPAppTheme.themeColors.darkGray,
            ),
          ),
        );
      }
    }

    return Material(
      color: JPAppTheme.themeColors.base,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: showTierColor ? BorderSide.none : BorderSide(
          color: JPAppTheme.themeColors.dimGray,
        )
      ),
      child: Stack(
        children: [
          JPExpansionTile(
            headerBgColor: showTierColor ? tierTypeToColor() : JPAppTheme.themeColors.dimGray.withValues(alpha: 0.3),
            borderRadius: 18,
            preserveWidgetOnCollapsed: true,
            initialCollapsed: !(currentItem?.isTierExpanded ?? true),
            isExpanded: (currentItem?.isTierExpanded ?? false),
            header: Row(
              children: [
                if (currentItem?.tierMeasurement != null || currentItem?.tierMeasurementId != null) ...{
                  SvgPicture.asset(AssetsFiles.measurement,
                    colorFilter: ColorFilter.mode(getTextAndIconColor(), BlendMode.srcIn),
                    height: 15,
                    width: 18,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                },

                Expanded(
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      /// Tier of the Tier
                      JPText(
                        text: currentItem?.title ?? "",
                        textColor: getTextAndIconColor(),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),

                       if (showTierSubtotals) ...{
                        /// Tier Sub Totals selector
                        JPPopUpMenuButton(
                          popUpMenuButtonChild: WorksheetTierSubTotals(
                            textColor: getTextAndIconColor(),
                            value: service.selectedTierSubTotal,
                            isSelector: true,
                            tierItem: currentItem,
                            service: service,
                          ),
                          itemList: service.getTierSubTotalsActions(),
                          popUpMenuChild: (PopoverActionModel popoverActionModel) {
                            return WorksheetTierSubTotals(
                              value: popoverActionModel.value,
                              tierItem: currentItem,
                              service: service,
                            );
                          },
                          offset: const Offset(0, 25),
                          onTap: service.onTapTierSubTotal,
                        ),
                      } else if (showTierTotal) ...{
                         /// Default tier total
                         JPText(
                           text: JobFinancialHelper.getCurrencyFormattedValue(
                               value: currentItem!.totalPrice),
                           textColor: getTextAndIconColor(),
                           textAlign: TextAlign.start,
                           fontWeight: JPFontWeight.medium,
                         ),
                       },

                    ],
                  ),
                ),
                const SizedBox(width: 5,),
                JPTextButton(
                  icon: Icons.more_vert,
                  color: getTextAndIconColor(),
                  iconSize: 20,
                  onPressed: () {
                    Helper.hideKeyboard();
                    service.handleTierQuickAction(currentItem!, index);
                  },
                )
              ],
            ),
            headerPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6
            ),
            onExpansionChanged: (val) => service.onTierExpansionChanged(val, currentItem!),
            trailingIconColor: getTextAndIconColor(),
            enableHeaderClick: true,
            contentPadding: const EdgeInsets.only(left: 5),
            footer: (hasSubTiers) ? Padding(
              padding: const EdgeInsets.only(
                left: 6
              ),
              child: getSubTier(),
            ) : null,
            children: [
              if (currentItem?.description?.isNotEmpty ?? false) ...{
                Padding(
                  padding: const EdgeInsets.only(
                      right: 6,
                      left: 2
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: JPAppTheme.themeColors.lightBlue.withValues(alpha: 0.2),
                      ),
                      width: double.maxFinite,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          JPText(
                            text: 'description'.tr,
                            textAlign: TextAlign.start,
                            textColor: JPAppTheme.themeColors.primary,
                            textSize: JPTextSize.heading5,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          JPText(
                            text: currentItem?.description ?? "-",
                            textAlign: TextAlign.start,
                            textSize: JPTextSize.heading6,
                            maxLine: 2,
                            height: 1.3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5,),
              },
              if (!hasSubTiers) getSubTier()
            ],
          ),
          if (!showTierColor)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: borderRadius,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(1, 0, 0, 0),
                    width: 5,
                    color: tierTypeToColor(),
                  ),
                ),
              ),
          ),
        ],
      ),
    );
  }

  Widget getSubTier() {
    bool hasOneTier = (currentItem?.subTiers?.isEmpty ?? true)
        || currentItem?.subTiers?.length == 1;
    if (hasOneTier) {
      return WorksheetTierItem(
        subTiers: currentItem?.subTiers,
        subItems: currentItem?.subItems,
        isFirstItem: isFirstItem,
        isLastItem: isLastItem,
        stripColor: tierTypeToColor(),
        service: service,
        parentItem: currentItem,
        index: index,
        controller: controller,
      );
    } else {
      return Material(
        color: JPAppTheme.themeColors.base,
        borderRadius: borderRadius,
        child: WorksheetItemsList(
          controller: controller,
          lineItems: currentItem?.subTiers ?? [],
          bgColor: subTierTypeToColor(),
          parentIndex: index,
        ),
      );
    }

  }

  Widget getLineItems(List<SheetLineItemModel> items, {bool isSingleItem = false}) {
    return SheetLineItemListing(
      items: items,
      stripColor: stripColor,
      isSavingForm: isDisabled,
      onListItemReorder: (oldIndex, newIndex) => service
          .onListItemReorder(oldIndex, newIndex, items: subItems),
      onTapOfDelete: (subItemIndex) {
        if (isSingleItem) {
          service.removeItem(index);
        } else {
          service.removeItem(subItemIndex,
              items: subItems,
              collectionIndex: index
          );
        }
      },
      pageType: AddLineItemFormType.worksheet,
      showHeaderTitles: false,
      onTapItem: (item) => service.showAddEditSheet(
          tier: parentItem,
          editLineItem: item,
          index: index
      ),
      isSupplierEnable: service.isAnySupplierEnabled,
      onTapMoreDetails: service.openAvailabilityProductNoticeSheet,
      isAbcEnable: service.isAbcEnable,
      showVariationConfirmationValidation: service.showVariationConfirmationValidation,
      onTapVariationConfirmation: (item) => service.showAddEditSheet(
          tier: parentItem,
          editLineItem: item,
          index: index
      ),
      onTapBeaconMoreDetails: service.openPricingAvailabilityNoticeSheet
    );
  }

  Color getTextAndIconColor() {
    if (showTierColor) {
      return JPAppTheme.themeColors.base;
    }
    return JPAppTheme.themeColors.text;
  }

  Color tierTypeToColor() {
    Color tierColor = showTierWarning ? JPAppTheme.themeColors.red : JPAppTheme.themeColors.primary;

    switch (currentItem?.tier) {
      case 1:
        return tierColor.withValues(alpha: 0.9);
      case 2:
        return tierColor.withValues(alpha: 0.7);
      case 3:
        return tierColor.withValues(alpha: 0.4);
      default:
        return JPAppTheme.themeColors.base;
    }
  }

  Color subTierTypeToColor() {
    Color tierColor = showTierWarning ? JPAppTheme.themeColors.red : JPAppTheme.themeColors.primary;

    switch (currentItem?.tier) {
      case 1:
        return tierColor.withValues(alpha: 0.7);
      case 2:
        return tierColor.withValues(alpha: 0.4);
      case 3:
        return tierColor.withValues(alpha: 0.4);
      default:
        return JPAppTheme.themeColors.base;
    }
  }
}
