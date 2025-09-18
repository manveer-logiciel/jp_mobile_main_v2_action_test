import 'package:flutter/material.dart';
import 'package:jobprogress/modules/drawing_tool/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class DrawingToolSecondaryHeader extends StatelessWidget {
  const DrawingToolSecondaryHeader({
    super.key,
    required this.controller,
    this.actions = const [],
  });

  final DrawingToolController controller;

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Material(
            color: JPColor.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 16
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  JPTextButton(
                    icon: Icons.undo_outlined,
                    color: JPAppTheme.themeColors.inverse,
                    onPressed: controller.undo,
                    iconSize: 24,
                    isDisabled: !controller.drawingToolController.canUndo,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  JPTextButton(
                    isDisabled: !controller.drawingToolController.canRedo,
                    icon: Icons.redo_outlined,
                    color: JPAppTheme.themeColors.inverse,
                    onPressed: controller.redo,
                    iconSize: 24,
                  ),
                  const Spacer(),
                  if (actions.isNotEmpty) ...{
                    ...actions
                  } else ...{
                    JPTextButton(
                      icon: Icons.rotate_right,
                      color: JPAppTheme.themeColors.inverse,
                      onPressed: controller.rotateCanvas,
                      iconSize: 24,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    JPTextButton(
                      icon: Icons.save_outlined,
                      color: JPAppTheme.themeColors.base,
                      iconSize: 24,
                      onPressed: () {
                        controller.showSaveOptions('save', isPreviewImage: controller.isPreviewImage);
                      },
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    JPTextButton(
                      icon: Icons.save_as_outlined,
                      color: JPAppTheme.themeColors.base,
                      iconSize: 24,
                      onPressed: () {
                        controller.showSaveOptions('save_as', isPreviewImage: controller.isPreviewImage);
                      },
                    ),
                  }
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
