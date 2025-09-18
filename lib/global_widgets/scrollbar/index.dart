
import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

class JPScrollBar extends StatelessWidget {
  const JPScrollBar({
    super.key,
    required this.child,
    required this.scrollController
  });

  final Widget child;

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
        controller: scrollController,
        thickness: 4,
        thumbColor: JPAppTheme.themeColors.dimGray,
        radius: const Radius.circular(2),
        child: child,
    );
  }
}
