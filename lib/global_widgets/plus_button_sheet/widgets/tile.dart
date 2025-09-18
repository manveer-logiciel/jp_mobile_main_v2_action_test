
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JPPlusButtonSheetTile extends StatelessWidget {
  const JPPlusButtonSheetTile({
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
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 4, right: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: data.child ?? const SizedBox.shrink(),
              ),
              Flexible(
                child: JPText(
                  height: 1,
                  maxLine: 2,
                  text: '${data.label.capitalize!}\n',
                  textSize: JPTextSize.heading5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
