import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

import '../../../global_widgets/listview/index.dart';

class StageListShimmer extends StatelessWidget {
  const StageListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return JPListView(
        scrollDirection: Axis.horizontal,
        listCount: 10,
        itemBuilder: (_, index) {
          if(index < 10) {
            return Row(
              children: [
                Container(
                  width: 35,
                  height: 30,
                  decoration: BoxDecoration(
                    color: JPAppTheme.themeColors.base,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Shimmer.fromColors(
                    baseColor: JPAppTheme.themeColors.dimGray,
                    highlightColor: JPAppTheme.themeColors.darkGray.withValues(alpha: 0.5),
                    child: const JPLabel(
                      text: " ",
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        }
    );
  }
}
