
import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CalendarViewSelector extends StatelessWidget {

  const CalendarViewSelector({
    super.key,
    required this.value
  });

  /// value is the selected view name
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 8,
        ),
        JPText(
          text: value,
        ),
        const SizedBox(
          width: 2,
        ),
        const JPIcon(
          Icons.arrow_drop_down,
          size: 22,
        ),
        const SizedBox(
          width: 2,
        ),
      ],
    );
  }
}
