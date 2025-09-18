import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class JobFinanacialJobPriceTileShimmer extends StatelessWidget {
  const JobFinanacialJobPriceTileShimmer({super.key, required this.title, this.value,});
  final String title;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left:16, top: 34, right: 14 , bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: JPAppTheme.themeColors.dimGray.withValues(alpha: 0.3),
            highlightColor: JPAppTheme.themeColors.inverse.withValues(alpha: 0.8),
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: JPAppTheme.themeColors.inverse 
              ),
              child: JPText(
                text: 'total_project_price'.tr,
                textSize: JPTextSize.heading3,
                fontWeight: JPFontWeight.medium,
                textColor: JPAppTheme.themeColors.inverse,
              ),
            ),
          ), 
          const SizedBox(height: 20),
          Row(
            children: [
              JPText(
                text: '\$0.00',
                textColor: JPAppTheme.themeColors.inverse,
                fontWeight: JPFontWeight.bold,
                textSize: JPTextSize.size30,
              ),
            ],
          ),
         
        ],
      ),
    );
  }
}
