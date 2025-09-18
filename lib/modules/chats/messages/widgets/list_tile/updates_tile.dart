
import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class MessageUpdatesTile extends StatelessWidget {
  const MessageUpdatesTile({
    super.key,
    this.actionBy,
    this.actionOn,
    this.action
  });

  final String? actionBy;

  final String? action;

  final String? actionOn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 44
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          JPText(
            text: actionBy ?? "",
            textSize: JPTextSize.heading5,
            fontWeight: JPFontWeight.medium,
            textColor: JPAppTheme.themeColors.tertiary,
          ),
          const SizedBox(
            width: 4,
          ),
          JPText(
            text: '$action',
            textSize: JPTextSize.heading5,
            textColor: JPAppTheme.themeColors.tertiary,
          ),
          const SizedBox(
            width: 4,
          ),
          JPText(
            text: actionOn ?? "",
            textSize: JPTextSize.heading5,
            fontWeight: JPFontWeight.medium,
            textColor: JPAppTheme.themeColors.tertiary,
          ),
        ],
      ),
    );
  }
}
