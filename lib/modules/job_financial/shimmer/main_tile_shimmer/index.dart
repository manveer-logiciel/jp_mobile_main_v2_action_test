import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/modules/job_financial/shimmer/main_tile_shimmer/component.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class FinancialMainTileShimmer extends StatelessWidget {
  const FinancialMainTileShimmer({
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 22, right: 40, left: 20, bottom: 22),
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      decoration: BoxDecoration(color: JPAppTheme.themeColors.base, borderRadius: BorderRadius.circular(18)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleValueComponentShimmer(title: 'job_price'.tr.capitalize!),
                const SizedBox(height : 15),
                TitleValueComponentShimmer(title: 'estimated_tax'.tr),
              ],
            )
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleValueComponentShimmer(title: 'invoiced_amount'.tr),
                const SizedBox(height : 15),
                TitleValueComponentShimmer(title: 'invoiced_tax'.tr),
              ],
            )
          )
        ],
      )
    );
  }
}
