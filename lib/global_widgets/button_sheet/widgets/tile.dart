
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JPButtonSheetTile extends StatelessWidget {
  const JPButtonSheetTile({
    super.key,
    required this.data,
    this.onTap
  });

  final JPQuickActionModel data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JPAppTheme.themeColors.dimGray.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: SizedBox(
                  height: 22,
                  width: 22,
                  child: data.child ?? const SizedBox()),
            ),
            Flexible(
              child: JPText(
                text: data.label.capitalize!,
                textSize: JPTextSize.heading5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
