import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class FinancialFormTotalPriceTile extends StatelessWidget {

  const FinancialFormTotalPriceTile({
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
      padding: sectionPadding ?? const EdgeInsets.fromLTRB(20, 12, 20, 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: sectionColor ?? JPAppTheme.themeColors.lightBlue.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(18)
      ),
      child: Column(children: labelValueList,),
    );
  }
}
