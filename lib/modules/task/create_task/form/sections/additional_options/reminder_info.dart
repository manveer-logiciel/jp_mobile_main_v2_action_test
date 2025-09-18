import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ReminderInfo extends StatelessWidget {
  const ReminderInfo({
    super.key,
    this.onTapClose,
  });

  final VoidCallback? onTapClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JPAppTheme.themeColors.inverse,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 15, left: 15, right: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 2
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    infoContent(
                      title: 'recurring'.tr,
                      description: 'create_task_recurring_info_desc'.tr,
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    infoContent(
                      title: 'before_due_date'.tr.capitalize!.trim(),
                      description: 'create_task_before_due_date_info_desc'.tr,
                    ),
                  ],
                ),
              ),
            ),
            JPTextButton(
              icon: Icons.close,
              iconSize: 22,
              padding: 4,
              onPressed: onTapClose,
            )
          ],
        ),
      ),
    );
  }

  Widget infoContent({
    required String title,
    required String description,
  }) {
    return JPRichText(
      text: TextSpan(children: [
        JPTextSpan.getSpan(title,
            textSize: JPTextSize.heading5,
            fontWeight: JPFontWeight.medium,
            textAlign: TextAlign.start,
            textColor: JPAppTheme.themeColors.tertiary,
            height: 1.5),
        JPTextSpan.getSpan(' - $description',
            textSize: JPTextSize.heading5,
            textAlign: TextAlign.start,
            textColor: JPAppTheme.themeColors.tertiary,
            height: 1.5),
      ]),
    );
  }
}
