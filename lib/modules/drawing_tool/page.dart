import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/drawing_tool.dart';
import 'package:jobprogress/core/constants/assets_files.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/drawing_tool/widgets/bottom_icon.dart';
import 'package:jobprogress/modules/drawing_tool/widgets/editor/index.dart';
import 'package:jobprogress/modules/drawing_tool/widgets/editor/shapes.dart';
import 'package:jobprogress/modules/drawing_tool/widgets/secondary_header/index.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';

class DrawingTool extends StatelessWidget {
  const DrawingTool({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DrawingToolController>(
      init: DrawingToolController(),
      global: false,
      builder: (controller) {
        return JPWillPopScope(
          onWillPop: controller.onWillPop,
          child: JPScaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: JPColor.dimBlack,
            appBar: JPHeader(
              title: 'drawing_tool'.tr,
              onBackPressed: () => controller.onWillPop(),
              actions: [
                if (controller.drawingToolController.drawables.isNotEmpty ||
                    controller.drawingToolController.canRedo)
                  Center(
                    child: JPTextButton(
                      icon: Icons.restart_alt,
                      onPressed: controller.showResetConfirmation,
                      color: JPAppTheme.themeColors.base,
                      iconSize: 24,
                    ),
                  ),
                const SizedBox(
                  width: 8,
                )
              ],
            ),
            body: JPSafeArea(
              child: controller.isLoading
                  ? const Center(
                      child: FadingCircle(
                        color: JPColor.white,
                      ),
                    )
                  : controller.backgroundImage == null
                      ? NoDataFound(
                          icon: Icons.image,
                          iconColor: JPColor.white,
                          textColor: JPColor.white,
                          title: 'something_went_wrong'.tr.capitalize,
                        )
                      : Column(
                          children: [
                            /// secondary header
                            DrawingToolSecondaryHeader(
                              controller: controller,
                            ),

                            /// canvas
                            Expanded(
                              child: Container(
                                color: JPColor.black,
                                child: Center(
                                  child: JpDrawingTool(
                                    objectWidgetKey: controller.objectWidgetKey,
                                    backgroundAspectRatio:
                                        controller.backgroundImage!.width /
                                            controller.backgroundImage!.height,
                                    isInteractionEnabled:
                                        controller.isInDrawableSelectionMode,
                                    controller:
                                        controller.drawingToolController,
                                    onItemTap: controller.setSelectedItemStyle,
                                    onTextDrawableCreated:
                                        controller.selectAddedTextDrawable,
                                    onDrawableCreated: (drawable) {
                                      controller.updateForFirstDrawable();
                                    },
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
                                        onTap: () =>
                                            controller.selectUnselectTool(
                                                DrawingToolType.pencil),
                                        isActive: controller.selectedToolType ==
                                            DrawingToolType.pencil,
                                      ),
                                      const SizedBox(
                                        width: 25,
                                      ),
                                      // text tool
                                      DrawingToolBottomIcon(
                                        icon: Icons.text_fields_outlined,
                                        onTap: () =>
                                            controller.selectUnselectTool(
                                                DrawingToolType.text),
                                        isActive: controller.selectedToolType ==
                                            DrawingToolType.text,
                                      ),
                                      const SizedBox(
                                        width: 25,
                                      ),
                                      // shapes tool
                                      DrawingToolBottomIcon(
                                          icon: DrawingToolShapesEditor
                                              .getShapeIcon(controller
                                                  .drawingToolController
                                                  .shapeFactory),
                                          onTap: () =>
                                              controller.selectUnselectTool(
                                                  DrawingToolType.shape),
                                          isActive:
                                              controller.selectedToolType ==
                                                      DrawingToolType.shape ||
                                                  controller
                                                          .drawingToolController
                                                          .shapeFactory !=
                                                      null),

                                      const SizedBox(
                                        width: 25,
                                      ),
                                      // eraser tool
                                      DrawingToolBottomIcon(
                                      iconWidget: SvgPicture.asset(AssetsFiles.eraser),
                                      onTap: () => controller.selectUnselectTool(
                                        DrawingToolType.eraser),
                                      isActive:controller.selectedToolType == DrawingToolType.eraser),
                                      const SizedBox(
                                        width: 25,
                                      ),
                                      // user interaction handler
                                      DrawingToolBottomIcon(
                                        icon: Icons.touch_app_outlined,
                                        onTap: () => controller
                                            .toggleDrawableSelectionMode(),
                                        isActive: controller
                                            .isInDrawableSelectionMode,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
            ),
          ),
        );
      },
    );
  }
}
