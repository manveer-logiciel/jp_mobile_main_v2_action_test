import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class AutomationListingTileShimmer extends StatelessWidget {
  const AutomationListingTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: JPAppTheme.themeColors.base,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shimmer for header (name and ID)
            Shimmer.fromColors(
              baseColor: JPAppTheme.themeColors.dimGray,
              highlightColor: JPAppTheme.themeColors.inverse,
              child: Container(
                width: 200,
                height: 16,
                color: JPAppTheme.themeColors.dimGray,
                margin: const EdgeInsets.only(bottom: 8),
              ),
            ),
            // Shimmer for the 'Moved to' section
            Row(
              children: [
                Shimmer.fromColors(
                  baseColor: JPAppTheme.themeColors.dimGray,
                  highlightColor: JPAppTheme.themeColors.inverse,
                  child: Container(
                    width: 60,
                    height: 12,
                    color: JPAppTheme.themeColors.dimGray,
                  ),
                ),
                const SizedBox(width: 4),
                Shimmer.fromColors(
                  baseColor: JPAppTheme.themeColors.dimGray,
                  highlightColor: JPAppTheme.themeColors.inverse,
                  child: Container(
                    width: 80,
                    height: 12,
                    color: JPAppTheme.themeColors.dimGray,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Shimmer for 'Triggered by' text
            Shimmer.fromColors(
              baseColor: JPAppTheme.themeColors.dimGray,
              highlightColor: JPAppTheme.themeColors.inverse,
              child: Container(
                width: 150,
                height: 12,
                color: JPAppTheme.themeColors.dimGray,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(thickness: 1),
            const SizedBox(height: 16),
            // Shimmer for automation counts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: JPAppTheme.themeColors.dimGray,
                      highlightColor: JPAppTheme.themeColors.inverse,
                      child: Container(
                        width: 130,
                        height: 12,
                        color: JPAppTheme.themeColors.dimGray,
                        margin: const EdgeInsets.only(bottom: 8),
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: JPAppTheme.themeColors.dimGray,
                      highlightColor: JPAppTheme.themeColors.inverse,
                      child: Container(
                        width: 130,
                        height: 12,
                        color: JPAppTheme.themeColors.dimGray,
                      ),
                    ),
                  ],
                ),
                const JPTextButton(
                  text: 'View',
                  icon: Icons.chevron_right,
                  textSize: JPTextSize.heading4,
                  onPressed: null, // Disabled button for shimmer
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(thickness: 1),
            const SizedBox(height: 8),
            // Shimmer for action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                JPButton(
                  size: JPButtonSize.extraSmall,
                  text: 'undo'.tr.toUpperCase(),
                  colorType: JPButtonColorType.lightGray,
                  disabled: true,
                ),
                const SizedBox(width: 8),
                JPButton(
                  size: JPButtonSize.extraSmall,
                  text: 'skip_all'.tr.toUpperCase(),
                  colorType: JPButtonColorType.tertiary,
                  disabled: true,
                ),
                const SizedBox(width: 8),
                JPButton(
                  size: JPButtonSize.extraSmall,
                  text: 'send_all'.tr.toUpperCase(),
                  colorType: JPButtonColorType.primary,
                  disabled: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
