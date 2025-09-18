import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class TitleValueComponentShimmer extends StatelessWidget {
  const TitleValueComponentShimmer({super.key, required this.title,});
 final String title;
 
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: JPAppTheme.themeColors.dimGray,
          highlightColor: JPAppTheme.themeColors.inverse,   
          child: Container(
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: JPAppTheme.themeColors.inverse 
            ),
            child: JPText(text: title,textColor: JPAppTheme.themeColors.inverse,)
          ),
        ),
        const SizedBox(height: 5,),
        JPText(
          text: '\$0.00',
          textSize: JPTextSize.heading1,
          textAlign: TextAlign.left,
          fontWeight: JPFontWeight.bold,
          textColor: JPAppTheme.themeColors.inverse,
        ),
      ],
    );
  }
}