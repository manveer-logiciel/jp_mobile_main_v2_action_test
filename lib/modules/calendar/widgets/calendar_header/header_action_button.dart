import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CalendarHeaderActionButton extends StatelessWidget {
  const CalendarHeaderActionButton({
    super.key,
    required this.child,
    this.onTap,
    this.width
  });

  /// child is a widget to be displayed under [CalendarHeaderActionButton] wrapper
  final Widget child;

  /// handles click on actions
  final VoidCallback? onTap;

  /// width used to specify width of widget
  final double? width;

  @override
  Widget build(BuildContext context) {

    return Material(
      borderRadius: BorderRadius.circular(8),
      color: JPAppTheme.themeColors.inverse,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 32,
          width: width,
          child: Center(child: child),
        ),
      ),
    );
  }
}
