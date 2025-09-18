import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/Text/index.dart';

class JPOptionsList extends StatelessWidget {
  const JPOptionsList({
    super.key, 
    required this.value, 
    this.icon
  });
  final String value;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 9, top: 10, bottom: 10),
      child: Row(
        children: [
          icon ?? const SizedBox.shrink(),
          if(icon != null)
          const SizedBox(width: 10),
          Expanded(
            child: JPText(
              textAlign: TextAlign.left,
              text: value,
            ),
          ),
        ],
      ),
    );
  }
}