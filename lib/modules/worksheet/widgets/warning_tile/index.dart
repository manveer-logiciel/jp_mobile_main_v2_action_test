import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class WorksheetWaringTile extends StatelessWidget {
  const WorksheetWaringTile({
    required this.icon,
    required this.label,
    super.key,
  });

  /// [icon] helps in displaying icon
  final IconData icon;

  /// [label] helps in displaying label
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8
      ),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: JPAppTheme.themeColors.red.withValues(alpha: 0.2),
          ),
          width: double.maxFinite,
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              JPIcon(
                icon,
                color: JPAppTheme.themeColors.red,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: JPText(
                  text: label,
                  textAlign: TextAlign.start,
                  textSize: JPTextSize.heading6,
                  maxLine: 2,
                  height: 1.3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
