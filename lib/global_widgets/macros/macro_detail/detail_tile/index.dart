import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import '../../../sheet_line_item_listing/index.dart';
import '../controller.dart';
import 'shimmer.dart';

class MacroDetailList extends StatelessWidget {
  final MacroProductController controller;
  const MacroDetailList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      controller.isLoading
        ?   const SheetLineItemListingShimmer()
        : controller.macroDetail.isNotEmpty
            ? Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SheetLineItemListing(
                    onTapItem:(item) {},
                    items: controller.macroDetail,
                    canShowDeleteSlidable: false,
                    isSavingForm: false,
                    onListItemReorder:(oldIndex, newIndex) {},
                    pageType: AddLineItemFormType.insuranceForm
                  ),
                ),
              )
            : Expanded(
                child: NoDataFound(
                  icon: Icons.production_quantity_limits_rounded,
                  title:'no_product_found'.tr.capitalize,
                ),
              )
      ],
    );
  }
}
