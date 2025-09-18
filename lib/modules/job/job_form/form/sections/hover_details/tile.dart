
import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobFormHoverDetailTile extends StatelessWidget {
  const JobFormHoverDetailTile({
    super.key,
    required this.title,
    required this.data
  });

  final String title;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4
      ),
      child: Row(
        children: [
          JPText(
            text: "$title: ",
            textColor: JPAppTheme.themeColors.secondaryText,
            textAlign: TextAlign.start,
          ),

          JPText(
            text: data,
            textColor: JPAppTheme.themeColors.tertiary,
            textAlign: TextAlign.start,
          )
        ],
      ),
    );
  }
}
