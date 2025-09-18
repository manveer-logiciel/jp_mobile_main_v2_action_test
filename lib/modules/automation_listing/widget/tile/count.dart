import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/font_weight.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/text_size.dart';
import 'package:jp_mobile_flutter_ui/Text/index.dart';

class AutomationTileCounts extends StatelessWidget {
  final String label;
  final String count;
  final bool? visible;

  const AutomationTileCounts({super.key, required this.label, required this.count, this.visible});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible ?? true,
      child: Row(
        children: [
          JPText(text: label),
          const SizedBox(width: 4),
          JPText(
            text: count,
            textSize: JPTextSize.heading4,
            fontWeight: JPFontWeight.bold,
          ),
        ],
      ),
    );
  }
}