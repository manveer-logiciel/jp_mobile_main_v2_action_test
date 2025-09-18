
import 'package:flutter/material.dart';
import 'package:jobprogress/modules/files_listing/templates/handwritten/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class HandwrittenTemplatePageSwitcher extends StatelessWidget {
  const HandwrittenTemplatePageSwitcher({
    super.key,
    required this.controller
  });

  final HandwrittenTemplateController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        /// prev icon
        JPTextButton(
          icon: Icons.chevron_left,
          color: JPAppTheme.themeColors.inverse,
          iconSize: 24,
          isDisabled: controller.isFirstPage,
          onPressed: () => controller.switchPage(toNext: false),
        ),
        /// page number
        JPText(
          text: '${controller.currentPage + 1} / ${controller.editors.length}',
          textColor: JPAppTheme.themeColors.base,
        ),
        /// next icon
        JPTextButton(
          icon: Icons.chevron_right,
          color: JPAppTheme.themeColors.inverse,
          iconSize: 24,
          isDisabled: controller.isLastPage,
          onPressed: controller.switchPage,
        ),
      ],
    );
  }
}
