
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/drawing_tool.dart';
import 'package:jobprogress/modules/drawing_tool/widgets/bottom_icon.dart';
import 'package:jobprogress/modules/drawing_tool/widgets/editor/index.dart';
import 'package:jobprogress/modules/drawing_tool/widgets/editor/shapes.dart';
import 'package:jobprogress/modules/drawing_tool/widgets/secondary_header/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';

class HandwrittenDrawingEditor extends StatelessWidget {
  const HandwrittenDrawingEditor({
    super.key,
    required this.controller,
    required this.templateEditor,
    required this.actions
  });

  final HandwrittenDrawingController controller;
  final Widget templateEditor;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {

    return GetBuilder<HandwrittenDrawingController>(
        init: controller,
        global: false,
        builder: (controller) {
          return Column(
            children: [
              /// secondary header
              DrawingToolSecondaryHeader(
                controller: controller,
                actions: actions,
              ),

              /// canvas
              Expanded(
                child: Container(
                  color: JPColor.black,
                  child: Center(
                    child: JpDrawingTool(
                      backgroundAspectRatio: controller.aspectRatio,
                      objectWidgetKey: controller.objectWidgetKey,
                      isInteractionEnabled: controller.isInDrawableSelectionMode,
                      controller: controller.drawingToolController,
                      onItemTap: controller.setSelectedItemStyle,
                      onTextDrawableCreated: controller.selectAddedTextDrawable,
                      onDrawableCreated: (drawable) {
                        controller.updateForFirstDrawable();
                      },
                      backgroundWidget: templateEditor,
                    ),
                  ),
                ),
              ),

              /// editor
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // editor
                  SizedBox(
                    height: 80,
                    child: DrawingToolEditor(
                      controller: controller,
                    ),
                  ),

                  const Divider(
                    height: 1.5,
                    thickness: 1.5,
                    color: JPColor.black,
                  ),

                  // tools
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // brush tool
                        DrawingToolBottomIcon(
                          icon: Icons.draw_outlined,
                          onTap: () => controller.selectUnselectTool(DrawingToolType.pencil),
                          isActive: controller.selectedToolType == DrawingToolType.pencil,
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        // text tool
                        DrawingToolBottomIcon(
                          icon: Icons.text_fields_outlined,
                          onTap: () => controller.selectUnselectTool(DrawingToolType.text),
                          isActive: controller.selectedToolType == DrawingToolType.text,
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        // shapes tool
                        DrawingToolBottomIcon(
                            icon: DrawingToolShapesEditor.getShapeIcon(controller.drawingToolController.shapeFactory),
                            onTap: () => controller.selectUnselectTool(DrawingToolType.shape),
                            isActive: controller.selectedToolType == DrawingToolType.shape
                                || controller.drawingToolController.shapeFactory != null),

                        const SizedBox(
                          width: 25,
                        ),
                        // eraser tool
                        DrawingToolBottomIcon(
                            icon: Icons.crop_portrait,
                            onTap: () => controller.selectUnselectTool(DrawingToolType.eraser),
                            isActive: controller.selectedToolType == DrawingToolType.eraser),

                        const SizedBox(
                          width: 25,
                        ),
                        // user interaction handler
                        DrawingToolBottomIcon(
                          icon: Icons.touch_app_outlined,
                          onTap: () => controller.toggleDrawableSelectionMode(),
                          isActive: controller.isInDrawableSelectionMode,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          );
        },
    );
  }
}