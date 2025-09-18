
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

/// JPOpenContainer is a wrapper over OpenContainer for common use
/// it basically animates one widget (list tile, any container, floating action button)
/// to new page
class JPOpenContainer extends StatelessWidget {
  const JPOpenContainer({
    super.key,
    required this.closeWidget,
    required this.openWidget,
    this.closedColor,
    this.borderRadius = 0
  });

  /// closeWidget is widget which is displayed before animation
  final Widget closeWidget;

  /// openWidget is widget which is displayed after animation
  final Widget openWidget;

  /// closedColor can be used to give background color to closed container
  final Color? closedColor;

  /// borderRadius used to apply border radius to close widget
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: CommonConstants.transitionDuration),
      closedBuilder: (BuildContext context, VoidCallback action) {
        return InkWell(
            onTap: action,
            child: closeWidget
        );
      },
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      closedElevation: 0,
      openElevation: 0,
      openBuilder: (BuildContext context, void Function({Object? returnValue}) action) {
        return openWidget;
      },
      closedColor: closedColor ?? JPAppTheme.themeColors.base,
    );
  }
}
