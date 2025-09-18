import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class DayOfWeek extends StatelessWidget {
  const DayOfWeek({
    super.key, required this.value, required this.onTap, required this.isActive,
  });
  final String value;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color:isActive? JPAppTheme.themeColors.primary : JPAppTheme.themeColors.tertiary,
          shape: BoxShape.circle
        ),
        height: 24,
        width: 24,
        child: Center(
          child: JPText(
            text: value,
            textColor: JPAppTheme.themeColors.base,
          )
        ),
      ),
    );
  }
}
