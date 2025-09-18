
import 'package:flutter/material.dart';
import 'package:jobprogress/global_widgets/recent_files/list_shimmer.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'details/shimmer.dart';
import 'workflow/shimmer.dart';

class JobOverViewShimmer extends StatelessWidget {
  const JobOverViewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          const JobOverViewWorkFlowShimmer(),
          const SizedBox(
            height: 20,
          ),
          const JobOverViewDetailsShimmer(),
          const SizedBox(
            height: 20,
          ),
          recentFiles(),
          const SizedBox(
            height: 20,
          ),
          recentFiles(),
          const SizedBox(
            height: 20,
          ),
          recentFiles(),
        ],
      ),
    );
  }

  Widget recentFiles() {
    return Material(
      color: JPAppTheme.themeColors.base,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 16
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerBox(height: 6, width: 150),
                  const SizedBox(
                    height: 2,
                  ),
                  shimmerBox(height: 4, width: 80),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const RecentFilesShimmer(),
          ],
        ),
      ),
    );
  }

  Widget shimmerBox({
    required double height,
    required double width,
    double borderRadius = 3
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: JPAppTheme.themeColors.dimGray,
      ),
    );
  }

}
