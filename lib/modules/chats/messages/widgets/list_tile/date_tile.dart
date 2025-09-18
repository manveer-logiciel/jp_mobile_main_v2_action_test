import 'package:flutter/material.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class MessageDateTile extends StatelessWidget {
  const MessageDateTile({
    super.key,
    this.unreadMessageSeparatorText,
    required this.date,
  });

  final DateTime date;

  final String? unreadMessageSeparatorText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: unreadMessageSeparatorText != null
              ? 6
              : 15,
          horizontal: 16,
      ),
      child: unreadMessageSeparatorText != null
          ? Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      endIndent: 10,
                      color: JPAppTheme.themeColors.dimGray,
                      thickness: 1,
                    ),
                  ),
                  JPText(
                    text: unreadMessageSeparatorText ?? "",
                    fontWeight: JPFontWeight.regular,
                    textColor: JPAppTheme.themeColors.tertiary,
                    textSize: JPTextSize.heading5,
                  ),
                  Expanded(
                    child: Divider(
                      indent: 10,
                      color: JPAppTheme.themeColors.dimGray,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
          )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: JPAppTheme.themeColors.lightBlue),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: JPText(
                    text: DateTimeHelper.getTimeLabel(date),
                    fontWeight: JPFontWeight.regular,
                    textColor: JPAppTheme.themeColors.tertiary,
                    textSize: JPTextSize.heading5,
                  ),
                )
              ],
            ),
    );
  }
}
