import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ProductPointsTile extends StatelessWidget {
  const ProductPointsTile({
    super.key,
    required this.index,
    required this.description,
  });

  final int index;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JPText(text: '$index.',
          textSize: JPTextSize.heading5,
          textAlign: TextAlign.start,
        ),
        const SizedBox(width: 3,),
        Flexible(
          child: JPText(text: description,
            textSize: JPTextSize.heading5,
            textAlign: TextAlign.start,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
