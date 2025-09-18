import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JPDivider extends StatelessWidget {
  const JPDivider({
    super.key,
    this.isVisible = true
  });

  final bool isVisible;
  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: isVisible,
        child: Divider(height: 1, color: JPAppTheme.themeColors.dimGray,)
    );
  }
}
