import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/Label/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class FormShimmer extends StatelessWidget {
  const FormShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: JPAppTheme.themeColors.dimGray,
        highlightColor: JPAppTheme.themeColors.inverse,
        child: renderShimmer(context));
  }

  Widget renderShimmer(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.zero,
            margin: const EdgeInsets.only(top: 10),
            width: 100,
            height: 7,
            child:  const JPLabel(
              text: " ",
              type: JPLabelType.lightGray,
            ),
          ),
          shimmerInputBox(),
          shimmerInputBox(),
          shimmerInputBox(),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: JPResponsiveDesign.popOverButtonFlex,
                  child: const JPButton(
                    text: ' ',
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  flex: JPResponsiveDesign.popOverButtonFlex,
                  child: const JPButton(
                    type: JPButtonType.solid,
                    colorType: JPButtonColorType.primary,
                    text: ' ',
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget shimmerInputBox() => Container(
    height: 50,
    width: double.maxFinite,
    margin: const EdgeInsets.only(top: 20),
    decoration: BoxDecoration(
        border: Border.all(color: JPAppTheme.themeColors.inverse),
        borderRadius: BorderRadius.circular(10)
    ),
  );

}
