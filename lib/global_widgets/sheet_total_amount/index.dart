import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class SheetTotalAmountSection extends StatelessWidget {
  const SheetTotalAmountSection({
    super.key, 
    required this.labelValueList, 
    this.sectionPadding, this.sectionColor, 
  });

 final List<Widget> labelValueList;
 final EdgeInsetsGeometry? sectionPadding;
 final Color? sectionColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: sectionPadding ?? const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: sectionColor ?? JPAppTheme.themeColors.lightBlue.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(18)
      ),
      child: Column(
        children: labelValueList,
      ),
    );
  }
}