import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CustomMaterialCard extends StatelessWidget {

  const CustomMaterialCard({
    super.key,
    required this.child,
    this.borderRadius = 18,
    this.elevation = 0});

  final Widget child;
  final double borderRadius;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      color: JPAppTheme.themeColors.base,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide.none,
      ),
      child: child,
    );
  }
}
