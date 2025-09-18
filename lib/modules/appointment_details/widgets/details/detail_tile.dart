
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../core/constants/assets_files.dart';

class AppointmentDetailTile extends StatelessWidget {

  const AppointmentDetailTile({
    super.key,
    required this.icon,
    required this.title,
    this.subTitle,
    this.checkForMultiline = false,
    this.isRecurring = false,
    this.location,
    this.isRecurringField = false,
    });

  /// displays icon of details tile for single line text it will be center aligned
  /// and for multiline text it will at top
  final IconData icon;

  /// displays title on details tile
  final String title;

  /// displays subtitle if need to display any
  final Widget? subTitle;

  /// checkForMultiline let widget to check if it is multiline, default value is [false]
  final bool checkForMultiline;

  /// isRecurring is used to display recurring icon
  final bool isRecurring;
  final bool isRecurringField;

  final VoidCallback? location;

  @override
  Widget build(BuildContext context) {

      bool isMultiLineText = false;
      if(checkForMultiline) {
        isMultiLineText = Helper.checkIfMultilineText(
          text: title,
          maxWidth: Get.width - 56,
        );
      }

      return Row(
        crossAxisAlignment: isMultiLineText || subTitle != null ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 3
            ),
            child: JPIcon(
              icon,
              color: JPAppTheme.themeColors.darkGray,
            ),
          ),
          const SizedBox(
            width: 14,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Row(
                      children: [
                         if(title.isNotEmpty) Flexible(
                      child: JPText(
                        text: title,
                        textAlign: TextAlign.start,
                        height: 1.5,
                      ),
                    ),
                    if(isRecurringField)...{
                      const SizedBox(
                        width: 9,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Image.asset(isRecurring
                            ? AssetsFiles.recurringIcon
                            : AssetsFiles.notRecurringIcon,
                          width: 13, height: 14),
                      )
                    },
                      ],
                    )),
                   
                    if(location != null)...{
                       JPTextButton(
                        onPressed: () {
                          location!();
                        },
                        icon: Icons.location_on,
                        iconSize: 24,
                        color: JPAppTheme.themeColors.primary,
                      ),
                    }
                  ],
                ),
                if(subTitle != null)...{
                  const SizedBox(
                    height: 6,
                  ),
                  subTitle!,
                }
              ],
            ),
          ),
        ],
      );
  }
}
