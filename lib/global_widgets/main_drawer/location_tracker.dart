import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JPMainDrawerLocationTracker extends StatelessWidget {
  final int time;

  const JPMainDrawerLocationTracker({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      child: Row(
        children: [
          JPIcon(Icons.location_on_outlined,
              color: JPAppTheme.themeColors.tertiary, size: 18),
          const SizedBox(width: 8.75),
          JPText(
            text: 'User Tracking - Last location captured $time min ago',
            textColor: JPAppTheme.themeColors.tertiary,
            textSize: JPTextSize.heading5,
          ),
        ],
      ),
    );
  }
}
