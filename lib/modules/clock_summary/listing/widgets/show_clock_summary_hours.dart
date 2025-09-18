import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class ShowClockSummaryHours extends StatelessWidget {

  const ShowClockSummaryHours({super.key, this.title, this.isShimmer = false, this.time = "00:00"});

  // title is used to display title eg Total Hours: 00:30hrs
  // in case title is null value displayed will be 00:30hrs
  final String? title;

  // isShimmer as [true] is used to render loading ui
  // default value is [false]
  final bool isShimmer;

  // time is used to display time in hours eg. 00:30
  // default value is 00:00
  final String? time;

  @override
  Widget build(BuildContext context) {
    if(isShimmer){
      return Shimmer.fromColors(
        baseColor: JPAppTheme.themeColors.dimGray,
        highlightColor: JPAppTheme.themeColors.inverse,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [

              if(title != null)...{
                JPText(
                  text: title ?? "",
                  textSize: JPTextSize.heading4,
                  fontWeight: JPFontWeight.medium,
                ),
                const SizedBox(
                  width: 10,
                ),
              },

              JPText(
                text: isShimmer ? '00:00' : time ?? "00:00",
                textSize: JPTextSize.heading2,
                textColor: JPAppTheme.themeColors.primary,
                fontWeight: JPFontWeight.medium,
              ),

              const SizedBox(
                width: 4,
              ),

              JPText(
                text: 'hrs'.tr,
                textColor: JPAppTheme.themeColors.darkGray,
                textSize: JPTextSize.heading5,
              )

            ],
          ),
      );
    }else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [

          if(title != null)...{
            JPText(
              text: title ?? "",
              textSize: JPTextSize.heading4,
              fontWeight: JPFontWeight.medium,
            ),
            const SizedBox(
              width: 10,
            ),
          },

          JPText(
            text: isShimmer ? '00:00' : time ?? "00:00",
            textSize: JPTextSize.heading2,
            textColor: JPAppTheme.themeColors.primary,
            fontWeight: JPFontWeight.medium,
          ),

          const SizedBox(
            width: 4,
          ),

          JPText(
            text: 'hrs'.tr,
            textColor: JPAppTheme.themeColors.darkGray,
            textSize: JPTextSize.heading5,
          )

        ],
      );
    }
  }
}
