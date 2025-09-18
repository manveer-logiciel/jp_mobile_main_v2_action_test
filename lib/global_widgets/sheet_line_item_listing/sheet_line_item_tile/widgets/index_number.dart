import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class SheetLineItemIndexNumber extends StatelessWidget {
  const SheetLineItemIndexNumber({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 1.5),
      child:JPText(text: "$index.",
        textSize: JPTextSize.heading5,
      ),
    );
  }
}