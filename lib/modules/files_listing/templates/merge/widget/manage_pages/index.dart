import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/templates/form_proposal/template.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import 'controller.dart';
import 'widget/tile.dart';

class MergeTemplateManagePagesView extends StatelessWidget {

  const MergeTemplateManagePagesView({
    super.key,
    required this.pages,
    required this.onDone,
    this.hideDelete = false,
  });

  /// [pages] - stores list of pages to be displayed
  final List<FormProposalTemplateModel> pages;

  /// [onDone] - is a callback when made pages updated
  final Function(List<FormProposalTemplateModel>) onDone;

  /// [hideDelete] helps in hiding delete button
  final bool hideDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10
      ),
      child: GetBuilder<MergeTemplateManagePagesController>(
        init: MergeTemplateManagePagesController(pages),
        global: false,
        builder: (controller) {
          return Material(
            borderRadius: JPResponsiveDesign.bottomSheetRadius,
            color: JPAppTheme.themeColors.base,
            child: JPSafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ///   title & cancel button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        JPText(
                          text: "manage_pages".tr.toUpperCase(),
                          textSize: JPTextSize.heading3,
                          fontWeight: JPFontWeight.medium,
                        ),
                        JPTextButton(
                          onPressed: () {
                            Get.back();
                          },
                          color: JPAppTheme.themeColors.text,
                          icon: Icons.clear,
                          iconSize: 24,
                        ),
                      ],
                    ),
                  ),

                  Flexible(
                      child: ReorderableListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        onReorder: controller.onReorder,
                        children: List.generate(
                          controller.tempPages.length, (index) {
                            final title = controller.tempPages[index].title ?? "-";
                            return MergeTemplateManagePagesTile(
                              key: ValueKey(index.toString()),
                              index: index,
                              title: title,
                              hideDelete: hideDelete,
                              canShowRemoveIcon: controller.canShowRemoveIcon,
                              onTapRemove: () => controller.removePage(index),
                            );
                          },
                        ),
                      ),
                  ),

                  ///   footer buttons
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: JPResponsiveDesign.popOverButtonFlex,
                            child: JPButton(
                              text: 'cancel'.tr.toUpperCase(),
                              onPressed: Get.back<void>,
                              fontWeight: JPFontWeight.medium,
                              size: JPButtonSize.small,
                              colorType: JPButtonColorType.lightGray,
                              textColor: JPAppTheme.themeColors.tertiary,
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            flex: JPResponsiveDesign.popOverButtonFlex,
                            child: JPButton(
                              text: 'done'.tr.toUpperCase(),
                              onPressed: () {
                                onDone(controller.tempPages);
                              },
                              fontWeight: JPFontWeight.medium,
                              size: JPButtonSize.small,
                              colorType: JPButtonColorType.primary,
                              textColor: JPAppTheme.themeColors.base,
                            ),
                          ),
                        ]),
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
