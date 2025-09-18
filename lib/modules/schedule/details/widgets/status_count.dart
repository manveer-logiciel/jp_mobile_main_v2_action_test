import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/modules/schedule/details/controller.dart';
import 'package:jobprogress/modules/schedule/details/widgets/status_icon_with_text.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ScheduleDetailConfirmationCount extends StatelessWidget {
  const ScheduleDetailConfirmationCount({super.key, required this.controller});

  final ScheduleDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 10,
              crossAxisAlignment:  WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceBetween,
              children: [
                Wrap(
                  children: [
                    ScheduleStatusIconWithText(
                        icon: Icons.cancel,
                        text: '${controller.declined} ${'declined'.tr}',
                        color: JPAppTheme.themeColors.secondary),
                    const SizedBox(
                      width: 16,
                    ),
                    ScheduleStatusIconWithText(
                        icon: Icons.check_circle,
                        text: '${controller.confirmed} ${'confirmed'.tr}',
                        color: JPAppTheme.themeColors.success),
                    const SizedBox(
                      width: 16,
                    ),
                    ScheduleStatusIconWithText(
                      icon: Icons.pending,
                      text: '${controller.pending} ${'pending'.tr}',
                      color: JPAppTheme.themeColors.warning
                    ),
                  ],
                ),
                JPButton(
                  iconWidget: JPIcon(
                    Icons.keyboard_arrow_right,
                    color: JPAppTheme.themeColors.primary,
                  ),
                  colorType: JPButtonColorType.lightBlue,
                  onPressed: () {
                    controller.conformationStatus();
                  },
                  size: JPButtonSize.smallIcon,
                  width: 26,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}