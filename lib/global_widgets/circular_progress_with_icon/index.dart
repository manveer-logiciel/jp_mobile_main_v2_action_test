import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/Icon/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

class ProgressWithIcon extends StatelessWidget {
  const ProgressWithIcon({super.key, this.onRemoveTap, this.progressValue});

  final VoidCallback? onRemoveTap;

  final double? progressValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          InkWell(
            onTap: onRemoveTap,
            child: JPIcon(Icons.close, color: JPAppTheme.themeColors.secondary, size: 18),
          ),
          CircularProgressIndicator(
            value: progressValue,
            valueColor:
                AlwaysStoppedAnimation<Color>(JPAppTheme.themeColors.primary),
            strokeWidth: 2.0,
          ),
        ],
      ),
    );
  }
}
