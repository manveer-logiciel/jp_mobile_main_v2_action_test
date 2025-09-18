
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/drawing_tool/drawing_tool_editor.dart';
import 'package:jobprogress/modules/drawing_tool/controller.dart';
import 'editor_icon.dart';

class DrawingToolEditorText extends StatelessWidget {

  const DrawingToolEditorText({
    super.key,
    required this.controller,
    required this.data
  });

  final DrawingToolController controller;

  final DrawingToolEditorModel data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        if(!controller.isInDrawableSelectionMode)...{
          DrawingToolEditorIcon(
            title: 'add'.tr.capitalize!,
            icon: Icons.add,
            onTap: controller.addText,
            showBlueBackground: true,
          ),
        } else...{
          DrawingToolEditorIcon(
            title: 'edit'.tr.capitalize!,
            icon: Icons.edit_outlined,
            onTap: controller.onTapEditText,
          ),
          DrawingToolEditorIcon(
            title: 'delete'.tr.capitalize!,
            icon: Icons.delete_outline,
            onTap: data.onTapDelete,
          ),
        },

        DrawingToolEditorIcon(
          title: 'color'.tr,
          icon: Icons.color_lens_outlined,
          onTap: data.onTapColor,
        ),

        DrawingToolEditorIcon(
          title: 'size'.tr,
          value: data.strokeValue + 'pt'.tr,
          onTap: data.onTapStroke,
          isActive: data.isStrokeActive,
        ),

        DrawingToolEditorIcon(
          title: 'bold'.tr,
          icon: Icons.format_bold,
          onTap: controller.toggleSelectedTextFontWeight,
          isActive: controller.isTextBold(),
        ),

        DrawingToolEditorIcon(
          title: 'italic'.tr,
          icon: Icons.format_italic,
          onTap: controller.toggleSelectedTextFontStyle,
          isActive: controller.isTextItalic(),
        ),

        DrawingToolEditorIcon(
          title: 'underline'.tr,
          icon: Icons.format_underlined,
          onTap: controller.toggleSelectedTextDecoration,
          isActive: controller.isTextUnderlined(),
        ),

        DrawingToolEditorIcon(
          title: 'left'.tr,
          icon: Icons.format_align_left,
          onTap: () {
            controller.updateSelectedTextAlign(TextAlign.start);
          },
          isActive: controller.selectedTextAlign == TextAlign.start,
        ),

        DrawingToolEditorIcon(
          title: 'center'.tr,
          icon: Icons.format_align_center,
          onTap: () {
            controller.updateSelectedTextAlign(TextAlign.center);
          },
          isActive: controller.selectedTextAlign == TextAlign.center,
        ),

        DrawingToolEditorIcon(
          title: 'right'.tr,
          icon: Icons.format_align_right,
          onTap: () {
            controller.updateSelectedTextAlign(TextAlign.end);
          },
          isActive: controller.selectedTextAlign == TextAlign.end,
        ),

        DrawingToolEditorIcon(
          title: 'justify'.tr,
          icon: Icons.format_align_justify,
          onTap: () {
            controller.updateSelectedTextAlign(TextAlign.justify);
          },
          isActive: controller.selectedTextAlign == TextAlign.justify,
        ),

      ],
    );
  }
}
