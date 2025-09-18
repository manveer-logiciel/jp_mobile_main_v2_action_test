import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobDetailButton extends StatelessWidget {
  const JobDetailButton({
    super.key,
    this.padding = EdgeInsets.zero,
    this.text,
    this.onTapDescription,
    this.prefixIcon,
    this.suffixIcon = Icons.chevron_right_outlined,
  });

  final EdgeInsetsGeometry padding;
  final String? text;
  final Function()? onTapDescription;
  final IconData? prefixIcon;
  final IconData? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: JPButton(
        type: JPButtonType.outline,
        text: text,
        textSize: JPTextSize.heading5,
        onPressed: onTapDescription,
        size: JPButtonSize.size24,
        iconWidget: Container(height: 18, width: 18,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: JPAppTheme.themeColors.primary
          ),
          child: Icon(prefixIcon, color: JPAppTheme.themeColors.base, size: 12,)
        ),
        suffixIconWidget: Icon(suffixIcon, size: 16, color: JPAppTheme.themeColors.primary),
      ),
    );
  }
}
