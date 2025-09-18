import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/sheet_line_item_listing/sheet_line_item_tile/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../common/models/job/job_division.dart';
import '../../common/models/sheet_line_item/sheet_line_item_model.dart';
import 'controller.dart';

class SheetLineItemListing extends StatelessWidget {

  final List<SheetLineItemModel> items;
  final AddLineItemFormType? pageType;
  final Function(SheetLineItemModel item) onTapItem;
  final Function(int oldIndex, int newIndex) onListItemReorder;
  final Function(int index)? onTapOfDelete;
  final bool isSavingForm;
  final bool showHeaderTitles;
  final bool canShowDeleteSlidable;
  final bool isSupplierEnable;
  final bool isAbcEnable;
  final int count = 0;
  final Color? stripColor;
  final VoidCallback? onTapMoreDetails;
  final bool isBeaconOrder;
  final bool isAbcOrder;
  final DivisionModel? jobDivision;
  final bool showVariationConfirmationValidation;
  final Function(SheetLineItemModel item)? onTapVariationConfirmation;
  final VoidCallback? onTapBeaconMoreDetails;

  const SheetLineItemListing({
    super.key,
    required this.onTapItem,
    required this.items,
    required this.isSavingForm,
    required this.onListItemReorder, 
    required this.pageType,
    this.onTapOfDelete,
    this.showHeaderTitles = true,
    this.stripColor,
    this.canShowDeleteSlidable = true,
    this.isSupplierEnable = false,
    this.isAbcEnable = false,
    this.onTapMoreDetails,
    this.isBeaconOrder = false,
    this.isAbcOrder = false,
    this.jobDivision,
    this.showVariationConfirmationValidation = false,
    this.onTapVariationConfirmation,
    this.onTapBeaconMoreDetails
  });

  @override
  Widget build(BuildContext context) {
    Widget sheetLineItem(int index) {
      return SheetLineItemTile(
        isTaxable: false,
        key: Key('${WidgetKeys.sheetLineItemKey}[$index]'),
        onTap: (item) => onTapItem.call(item..currentIndex = index),
        itemModel: items[index],
        index: index+1,
        isBottomRadius: items.length == 1 || index == items.length - 1,
        isTopRadius: index == 0,
        pageType: pageType,
        stripColor: stripColor,
        isSupplierEnable: isSupplierEnable,
        isAbcEnable: isAbcEnable,
        onTapMoreDetails: onTapMoreDetails,
        isBeaconOrder: isBeaconOrder,
        isAbcOrder: isAbcOrder,
        jobDivision: jobDivision,
        showVariationConfirmationValidation: showVariationConfirmationValidation,
        onTapVariationConfirmation: onTapVariationConfirmation,
        onTapBeaconMoreDetails: onTapBeaconMoreDetails
      );
    }

    return GetBuilder<SheetLineItemListingController>(
      init: SheetLineItemListingController(items: items),
      didUpdateWidget: (GetBuilder oldWidget, GetBuilderState<SheetLineItemListingController> state)
      =>  state.controller?.didUpdateWidget(),
      global: false,
      builder: (controller) {
        return AbsorbPointer(
          absorbing: isSavingForm,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showHeaderTitles) ...{
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        JPText(text: "item".tr,
                          textSize: JPTextSize.heading5,
                          fontWeight: JPFontWeight.bold,
                          textColor: JPAppTheme.themeColors.darkGray,
                        ),
                        JPText(text: "amount".tr,
                          textSize: JPTextSize.heading5,
                          fontWeight: JPFontWeight.bold,
                          textColor: JPAppTheme.themeColors.darkGray,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                },
          
                ReorderableListView(
                  onReorder: onListItemReorder,
                    proxyDecorator: (child,index,animation) => Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(index == 0 ? 18 : 0),
                          topLeft:  Radius.circular(index == 0 ? 18 : 0),
                          bottomLeft: Radius.circular(items.length == 1 || index == items.length - 1 ? 18 : 0),
                          bottomRight: Radius.circular(items.length == 1 || index == items.length - 1 ? 18 : 0),
                        )
                      ),
                      child: child,
                    ),
                    primary: false,
                  shrinkWrap: true,
                    children : [
                      for (int index = 0; index < items.length; index += 1)
                      canShowDeleteSlidable ? Scrollable(
                        key: Key('$index'),
                        viewportBuilder: (BuildContext context, ViewportOffset position) {
                          return Slidable(
                            closeOnScroll: false,
                            endActionPane: ActionPane(
                              extentRatio: 0.3,
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(onPressed: (BuildContext context) { onTapOfDelete != null ? onTapOfDelete!(index) : ' ';},
                                  autoClose: true ,
                                  backgroundColor: JPAppTheme.themeColors.red,
                                  icon: Icons.delete,
                                  label: 'delete'.tr,
                                )
                              ],
                            ),
                            child: sheetLineItem(index),
                          );
                        },  
                      ) : sheetLineItem(index)
                    ],
                )
              ],
            ),
          )
        );
      }
    );
  }
}
