import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import '../../../common/models/sheet_line_item/sheet_line_item_model.dart';
import '../../../core/utils/single_select_helper.dart';
import '../../sheet_line_item_listing/sheet_line_item_tile/index.dart';

class FinancialFormNoChargePriceTileController extends GetxController {

  FinancialFormNoChargePriceTileController({this.noChargeItemsList, required this.pageType});

  final List<SheetLineItemModel>? noChargeItemsList;
  final AddLineItemFormType pageType;

  void viewNoChargeItems() {
    SingleSelectHelper.openCustomTileBottomSheet(
      title: "no_charge_items".tr,
      widgetList: [
        for (int index = 0; index < (noChargeItemsList?.length ?? 0); index += 1)...{
          SheetLineItemTile(
            key: Key('$index'),
            onTap: onTapItem,
            itemModel: noChargeItemsList![index],
            index: index + 1,
            isBottomRadius: false,
            isTopRadius: false,
            isTaxable : false,
            isReOrderAble: false,
            pageType: pageType,
          )
        }
      ]
    );
  }


  void onTapItem(SheetLineItemModel item) {

  }
}