
import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class ClockInClockOutCardShimmer extends StatelessWidget {
  const ClockInClockOutCardShimmer({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: JPAppTheme.themeColors.dimGray,
        highlightColor: JPAppTheme.themeColors.inverse,
        child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                JPText(
                  text: title,
                  fontWeight: JPFontWeight.medium,
                  textSize: JPTextSize.heading4,
                ),
                const Spacer(),
                Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: JPAppTheme.themeColors.dimGray
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                JPAvatar(
                  height: 72,
                  width: 72,
                  backgroundColor: JPAppTheme.themeColors.dimGray,
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            height: 14,
                            width: 60,
                            color: JPAppTheme.themeColors.dimGray,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            height: 10,
                            width: 80,
                            color: JPAppTheme.themeColors.dimGray,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        height: 8,
                        width : double.maxFinite,
                        color: JPAppTheme.themeColors.dimGray,
                      ),
                      const SizedBox(height: 4,),
                      Container(
                        height: 6,
                        width : 100,
                        color: JPAppTheme.themeColors.dimGray,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            const JPText(
              text: 'Note',
              fontWeight: JPFontWeight.medium,
              textSize: JPTextSize.heading4,
            ),
            const SizedBox(
              height: 6,
            ),
            Column(
              children: List.generate(4, (index) {
                return Column(
                  children: [
                    const SizedBox(height: 5,),
                    Container(
                      height: 7,
                      width : double.maxFinite,
                      color: JPAppTheme.themeColors.dimGray,
                    ),
                  ],
                );
              },
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Container(
              height: 7,
              width : 100,
              color: JPAppTheme.themeColors.dimGray,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      )
    );
  }
}
