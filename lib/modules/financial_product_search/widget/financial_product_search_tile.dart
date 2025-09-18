import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/modules/financial_product_search/widget/product_search_listing_tile.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

import '../../../global_widgets/listview/index.dart';
import '../../../global_widgets/no_data_found/index.dart';
import '../controller.dart';
import '../shimmer/product_search_list_tile_shimmer.dart';

class FinancialProductSearchTile extends StatelessWidget {
  final FinancialProductController controller;
  const FinancialProductSearchTile({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if(controller.isLoading) {
      return const Expanded(child: ProductSearchListTileShimmer());
    } else if(controller.financialProducts.isEmpty) {
      if(controller.searchTextController.text.isEmpty) {
        return Expanded(
          child: Container(
            color: JPAppTheme.themeColors.base,
          ),
        );
      } else {
        return Expanded(child: NoDataFound(title: 'no_item_found'.tr.capitalize,
          icon: Icons.production_quantity_limits_rounded,
        ));
      }
    } else {
      return JPListView(
        onLoadMore: controller.canShowLoadMore ? controller.loadMore : null,
        listCount: controller.financialProducts.length -1,
        itemBuilder: (context, index) {
          if (index < controller.financialProducts.length) {
            if(controller.financialProducts[index].branchLogo == null) {
              controller.financialProducts[index].branchLogo = controller.filterKeys.supplierBranch?.logo;
            }
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                ProductSearchListingTile(
                  key: ValueKey(index.toString()),
                  productName: controller.financialProducts[index].name ?? '',
                  productModel: controller.financialProducts[index],
                  showSellingPrice: controller.filterKeys.isSellingPriceEnabled ?? true,
                  isSellingPriceUnavailable: controller.showSellingPriceUnavailable(index),
                  jobDivision: controller.filterKeys.jobDivision,
                  onTapItem: () => controller.onTapItem(index: index),
                ),
                const SizedBox(height: 1,)
              ],
            );
          } else if (controller.canShowLoadMore) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16,),
              child: Center(
                  child: FadingCircle(
                      color: JPAppTheme.themeColors.primary,
                      size: 25)),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      );
    }
  }
}
