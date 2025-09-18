import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/drawing_tool.dart';
import 'package:jobprogress/common/models/drawing_tool/drawing_tool_editor.dart';
import 'package:jobprogress/modules/drawing_tool/widgets/editor/editor_options.dart';
import 'package:jobprogress/modules/drawing_tool/widgets/editor/slider_editor.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/Constants/responsive_design.dart';
import '../../controller.dart';

class DrawingToolEditor extends StatelessWidget {

  const DrawingToolEditor({
    super.key,
    required this.controller
  });

  final DrawingToolController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        DrawingToolEditorOptions(
          data: DrawingToolEditorModel(
            type: controller.editorType,
            shapes: controller.shapes,
            onSelectingShape: controller.selectShape,
            onTapColor: controller.showColorPicker,
            strokeValue: controller.getStrokeWidth().toInt().toString(),
            onTapStroke: controller.toggleStrokeSelection,
            onTapDelete: controller.removeSelectedDrawable,
          ),
          controller: controller,
        ),

        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: JPResponsiveDesign.maxPopOverWidth,
          ),
          child: DrawingToolEditorSlider(
            value: controller.getStrokeWidth(),
            title: controller.isSelectedDrawableIsText || controller.selectedToolType == DrawingToolType.text
                ? 'font_size'.tr
                : 'stroke'.tr,
            displayValue: '${controller.getStrokeWidth().round()}',
            displayUnit: 'pt',
            onChanged: controller.setDrawableStrokeWidth,
            divisions: 19,
            minValue: 1,
            maxValue: 20,
            isVisible: controller.isStrokeActive,
            onTapBack: controller.toggleStrokeSelection,
            isBackButtonVisible: controller.selectedToolType != DrawingToolType.eraser && !controller.isEditorVisible,
          ),
        ),


      ],
    );
  }

}
