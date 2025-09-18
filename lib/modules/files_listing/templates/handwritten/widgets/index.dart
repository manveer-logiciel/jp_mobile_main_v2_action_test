
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../controller.dart';
import 'drawing_editor/index.dart';
import 'page_switcher/index.dart';
import 'template_editor/index.dart';

class HandwrittenTemplateView extends StatelessWidget {
  const HandwrittenTemplateView({
    super.key,
    required this.controller
  });

  final HandwrittenTemplateController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.hasError) {
      return NoDataFound(
        icon: Icons.description_outlined,
        title: 'template_not_found'.tr.capitalize,
        textColor: JPAppTheme.themeColors.base,
        iconColor: JPAppTheme.themeColors.base,
      );
    }

    return Opacity(
      opacity: controller.isSavingForm ? 0.4 : 1,
      child: IndexedStack(
        index: controller.currentPage,
        children: controller.editors.map((editor) {
          return SizedBox(
            child: HandwrittenDrawingEditor(
              controller: editor.drawingController,
              actions: [
                Transform.translate(
                  offset: const Offset(0, 1),
                  child: JPTextButton(
                    icon: Icons.calculate_outlined,
                    color: JPAppTheme.themeColors.inverse,
                    iconSize: 24,
                    onPressed: controller.showCalculator,
                  ),
                ),
                Transform.translate(
                  offset: const Offset(5, 1),
                  child: JPTextButton(
                    icon: Icons.camera_alt_outlined,
                    color: JPAppTheme.themeColors.inverse,
                    iconSize: 24,
                    onPressed: controller.editImage,
                  ),
                ),
                if (controller.doShowPageSwitcher)
                  Transform.translate(
                    offset: const Offset(8, 0),
                    child: HandwrittenTemplatePageSwitcher(
                      controller: controller
                ),
                  ),
              ],
              templateEditor: HandwrittenTemplateEditor(
                controller: editor.pageController,
              ),
            ),
          );
        }).toList(),
      ),
    );

  }
}
