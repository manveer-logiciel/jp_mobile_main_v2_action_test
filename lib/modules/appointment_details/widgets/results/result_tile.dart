
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class AppointmentResultTile extends StatelessWidget {

  const AppointmentResultTile({
    required this.title,
    required this.subTitle,
    super.key});

  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          JPText(
            text: title.capitalize!,
            textSize: JPTextSize.heading5,
            textColor: JPAppTheme.themeColors.tertiary,
          ),
          const SizedBox(
            height: 6,
          ),
          JPText(
            text: subTitle,
            textAlign: TextAlign.start,
          )
        ],
      ),
    );
  }
}
