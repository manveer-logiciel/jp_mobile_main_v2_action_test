import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../global_widgets/animated_sync_button/index.dart';

class SQLListTile extends StatelessWidget {

  const SQLListTile({
    super.key,
    required this.title,
    this.description,
    this.onSyncTap,
    this.isLoading = false,
  });

  final String? title;
  final String? description;
  final VoidCallback? onSyncTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child:  JPText(
                    text: title!,
                    textSize: JPTextSize.heading4,
                    fontWeight: JPFontWeight.medium,
                    textAlign: TextAlign.start,
                  ),
                ),
                Visibility(
                visible: description?.isNotEmpty ?? false,
                  child: JPText(
                    text: "${"last_synced".tr} ${description ?? ""}",
                    textSize: JPTextSize.heading5,
                    textColor: JPAppTheme.themeColors.tertiary,
                    textAlign: TextAlign.start,
                  ),
                )
              ],
            ),
          ),
          AnimatedSyncButton(
            onPressed: isLoading ? null : onSyncTap,
            isLoading: isLoading,
          )
        ],
      ),
    );
  }
}
