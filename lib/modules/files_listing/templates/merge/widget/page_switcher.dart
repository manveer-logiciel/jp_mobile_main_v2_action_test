import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/modules/files_listing/templates/merge/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class MergeTemplatePageSwitcher extends StatelessWidget {
  const MergeTemplatePageSwitcher({
    super.key,
    required this.controller,
  });

  final FormProposalMergeTemplateController controller;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
          maxWidth: 200
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          JPTextButton(
            icon: Icons.chevron_left,
            iconSize: 24,
            color: JPAppTheme.themeColors.base,
            isDisabled: controller.disablePrevButton,
            onPressed: controller.prevPage,
            padding: 2,
          ),

          Flexible(
            child: InkWell(
              onTap: controller.showSwitchTemplateSingleSelect,
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    JPText(
                      text: '${'page'.tr} #${controller.selectedPageIndex + 1}',
                      textSize: JPTextSize.heading5,
                      textColor: JPAppTheme.themeColors.base,
                      textAlign: TextAlign.start,
                      maxLine: 1,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    JPText(
                      text: controller.selectedTemplateTitle ?? "-",
                      textSize: JPTextSize.heading6,
                      textColor: JPAppTheme.themeColors.base,
                      textAlign: TextAlign.start,
                      fontWeight: JPFontWeight.medium,
                      maxLine: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),

          JPTextButton(
            icon: Icons.chevron_right,
            iconSize: 24,
            color: JPAppTheme.themeColors.base,
            isDisabled: controller.disableNextButton,
            onPressed: controller.nextPage,
            padding: 2,
          )
        ],
      ),
    );
  }
}
