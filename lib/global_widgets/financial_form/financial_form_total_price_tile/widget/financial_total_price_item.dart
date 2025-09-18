import 'package:flutter/material.dart';

class FinancialTotalPriceItem extends StatelessWidget {
  const FinancialTotalPriceItem({
    super.key,
    required this.labelWidget,
    required this.valueWidget,
    this.tilePadding,
  });

  final Widget labelWidget;
  final Widget valueWidget;
  final EdgeInsetsGeometry? tilePadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: tilePadding ?? const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.spaceBetween,
              children: [
                labelWidget,
                valueWidget,
              ],
            ),
          ),
        ],
      ),
    );
  }
}