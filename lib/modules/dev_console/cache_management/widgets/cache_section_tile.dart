import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CacheSectionTile extends StatelessWidget {
  const CacheSectionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.size,
    required this.itemCount,
    this.onClear,
    this.showItemCount = true,
    this.showClearButton = true,
    this.isLoading = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String size;
  final int itemCount;
  final VoidCallback? onClear;
  final bool showItemCount;
  final bool showClearButton;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: JPAppTheme.themeColors.base,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: JPAppTheme.themeColors.dimGray),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: JPAppTheme.themeColors.lightestGray,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: JPAppTheme.themeColors.tertiary,
                size: 20,
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Left alignment
                children: [
                  JPText(
                    text: title,
                    fontWeight: JPFontWeight.medium,
                    textSize: JPTextSize.heading5,
                    textAlign: TextAlign.left, // Explicit left alignment
                  ),
                  const SizedBox(height: 2),
                  JPText(
                    text: subtitle,
                    textSize: JPTextSize.heading6,
                    textColor: JPAppTheme.themeColors.tertiary,
                    textAlign: TextAlign.left, // Explicit left alignment
                  ),
                  const SizedBox(height: 4),
                  // Show loading or size info
                  if (isLoading)
                    SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: JPAppTheme.themeColors.tertiary,
                      ),
                    )
                  else
                    JPText(
                      text: showItemCount ? '$size • $itemCount ${itemCount == 1 ? 'item'.tr : 'items'.tr}' : size,
                      textSize: JPTextSize.heading6,
                      fontWeight: JPFontWeight.medium,
                      textColor: JPAppTheme.themeColors.themeBlue,
                      textAlign: TextAlign.left, // Explicit left alignment
                    ),
                ],
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Clear Button (conditionally shown)
            if (showClearButton && onClear != null)
              JPButton(
                text: 'clear'.tr.toUpperCase(),
                onPressed: onClear!,
                size: JPButtonSize.extraSmall,
                colorType: JPButtonColorType.lightGray,
                textColor: JPAppTheme.themeColors.tertiary,
                textSize: JPTextSize.heading6,
              ),
          ],
        ),
      ),
    );
  }
} 