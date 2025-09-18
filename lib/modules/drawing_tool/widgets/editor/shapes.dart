import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/drawing_tool/drawing_tool_editor.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import 'editor_icon.dart';

class DrawingToolShapesEditor extends StatelessWidget {

  const DrawingToolShapesEditor({
    super.key,
    required this.data,
    this.editShapeOnly = false,
    this.selectedShape
  });

  final DrawingToolEditorModel data;

  final bool editShapeOnly;

  final ShapeFactory? selectedShape;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if(data.shapes != null && !editShapeOnly)
          ...data.shapes!.entries.map((e) {
            return DrawingToolEditorIcon(
              showBlueBackground: e.key == selectedShape,
              title: e.value,
              icon: getShapeIcon(e.key),
              onTap: () {
                data.onSelectingShape!(e.key);
              },
            );
          }),

        if(editShapeOnly)
          DrawingToolEditorIcon(
            title: 'delete'.tr.capitalize!,
            icon: Icons.delete_outline,
            onTap: data.onTapDelete,
          ),

        DrawingToolEditorIcon(
          title: 'color'.tr,
          icon: Icons.color_lens_outlined,
          onTap: data.onTapColor,
        ),

        DrawingToolEditorIcon(
          title: 'stroke'.tr,
          value: data.strokeValue + 'pt'.tr,
          onTap: data.onTapStroke,
          isActive: data.isStrokeActive,
        ),

      ],
    );
  }

  static IconData getShapeIcon(ShapeFactory? shapeFactory) {
    if (shapeFactory is LineFactory) return Icons.show_chart;
    if (shapeFactory is ArrowFactory) return Icons.arrow_forward;
    if (shapeFactory is DoubleArrowFactory) return Icons.open_in_full;
    if (shapeFactory is RectangleFactory) return Icons.crop_square;
    if (shapeFactory is OvalFactory) return Icons.radio_button_unchecked;
    return Icons.interests_outlined;
  }

}
