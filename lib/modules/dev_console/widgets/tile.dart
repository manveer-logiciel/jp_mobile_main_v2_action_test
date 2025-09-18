import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/sql/dev_console.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class DevConsoleTile extends StatelessWidget {
  const DevConsoleTile({
    super.key,
    required this.log,
  });

  final DevConsoleModel log;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: JPAppTheme.themeColors.base
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Page & Time details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: JPText(
                  text: (log.page ?? ""),
                  fontWeight: JPFontWeight.medium,
                ),
              ),
              JPText(
                text: log.createdAt ?? "-",
                textAlign: TextAlign.start,
                textColor: JPAppTheme.themeColors.tertiary,
                textSize: JPTextSize.heading5,
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          /// Error Type and App Version
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: JPLabel(
                  text: log.type ?? "",
                  backgroundColor: JPAppTheme.themeColors.red,
                ),
              ),
              JPText(
                text: log.appVersion ?? "",
                textAlign: TextAlign.start,
                textSize: JPTextSize.heading5,
                fontWeight: JPFontWeight.medium,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          /// Error Details
          Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: JPAppTheme.themeColors.lightestGray,
              border: Border(
                left: BorderSide(
                  color: JPAppTheme.themeColors.darkGray,
                  width: 3
                )
              ),
            ),
            padding: const EdgeInsets.all(8),
            child: JPText(
              text: log.description ?? "-",
              textAlign: TextAlign.start,
              textColor: JPAppTheme.themeColors.text,
              textSize: JPTextSize.heading5,
            ),
          ),
          const SizedBox(height: 8),
          Divider(
            height: 1,
            thickness: 1,
            color: JPAppTheme.themeColors.inverse,
          ),
        ],
      ),
    );
  }
}
