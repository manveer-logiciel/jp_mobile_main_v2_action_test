
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class NotificationListingSyncBanner extends StatelessWidget {
  const NotificationListingSyncBanner({
    super.key,
    this.onTapSync,
    this.isVisible = false,
  });

  final VoidCallback? onTapSync;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {

    if (!isVisible) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: JPAppTheme.themeColors.lightBlue,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8
          ),
          child: Row(
            children: [
              Expanded(
                child: JPText(
                  text: 'non_synced_notification_title'.tr,
                  textAlign: TextAlign.start,
                ),
              ),
              JPButton(
                size: JPButtonSize.extraSmall,
                text: 'sync'.tr.capitalizeFirst!,
                fontWeight: JPFontWeight.medium,
                onPressed: onTapSync,
              )
            ],
          ),
        ),
      ),
    );

  }
}

