import 'package:flutter/material.dart';

class SheetLabelValueTile extends StatelessWidget {
  const SheetLabelValueTile({
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