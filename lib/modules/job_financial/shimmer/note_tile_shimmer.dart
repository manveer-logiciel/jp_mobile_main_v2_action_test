import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class JobFinancialNoteTileShimmer extends StatelessWidget {
  const JobFinancialNoteTileShimmer({super.key, required this.topMargin});
  final double topMargin;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      transform: Matrix4.translationValues(0.0, topMargin, 0.0),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: JPAppTheme.themeColors.base, borderRadius: BorderRadius.circular(18)),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0,bottom: 8.0),
            child: JPText(text: 'note'.tr.toUpperCase(),fontWeight: JPFontWeight.medium,),
          ),
          Shimmer.fromColors(
            baseColor: JPAppTheme.themeColors.dimGray,
            highlightColor: JPAppTheme.themeColors.inverse,
            child: Container(
              decoration: BoxDecoration(
                borderRadius:BorderRadius.circular(5),
                color: JPAppTheme.themeColors.inverse,
              ),
              child :const JPText(text: '1201211221121', fontWeight: JPFontWeight.medium)
            )
          ),
        ],
      ) 
    );
  }
}
