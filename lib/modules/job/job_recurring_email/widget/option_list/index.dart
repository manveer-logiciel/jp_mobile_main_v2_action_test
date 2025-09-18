import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/Text/index.dart';

class JobRecurringEmailOptionsList extends StatelessWidget {

  const JobRecurringEmailOptionsList({super.key, required this.value});
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Row(
        children: [
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
