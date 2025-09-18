import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/color.dart';
import 'package:jp_mobile_flutter_ui/Text/index.dart';

class JPMainDrawerCategoryTitle extends StatelessWidget {
  final String title;

  const JPMainDrawerCategoryTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: JPText(
        text: title,
        textAlign: TextAlign.left,
        textColor: JPColor.darkGray,
      ),
    );
  }
}
