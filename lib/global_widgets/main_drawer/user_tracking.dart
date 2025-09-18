import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/background_location/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class UserTrackingDrawerLabel extends StatelessWidget {
  const UserTrackingDrawerLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return JPBackgroundLocationListener(
      child: (controller) {
        if (controller.doShowUserLiveTacking) {
          return Column(
            children: [
              Divider(
                height: 0.5,
                thickness: 0.5,
                color: JPAppTheme.themeColors.secondaryText,
              ),
              Material(
                color: JPAppTheme.themeColors.inverse,
                child:  SizedBox(
                  width: double.maxFinite,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        JPIcon(
                          Icons.location_on_outlined,
                          size: 15,
                          color: JPAppTheme.themeColors.tertiary,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: JPText(
                              text: '${"user_tracking".tr} - ${controller.timeAgo()}',
                              textSize: JPTextSize.heading6,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLine: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
