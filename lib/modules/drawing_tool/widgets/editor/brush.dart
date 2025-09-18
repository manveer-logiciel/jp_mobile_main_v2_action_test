import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/drawing_tool/drawing_tool_editor.dart';
import 'editor_icon.dart';

class DrawingToolBrushEditor extends StatelessWidget {

  const DrawingToolBrushEditor({
    super.key,
    required this.data,
  });

  final DrawingToolEditorModel data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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

}
