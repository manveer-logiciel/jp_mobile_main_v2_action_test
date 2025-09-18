import 'package:flutter/material.dart';
import 'package:jobprogress/common/enums/drawing_tool.dart';
import 'package:jp_mobile_flutter_ui/DrawingTool/controllers/factories/shape_factory.dart';

class DrawingToolEditorModel {

  final Map<ShapeFactory, String>? shapes;

  final Function(ShapeFactory? shape)? onSelectingShape;

  final VoidCallback? onTapColor;

  final VoidCallback? onTapStroke;

  final VoidCallback? onTapDelete;

  final String strokeValue;

  final bool isVisible;

  final bool isStrokeActive;

  DrawingToolEditorType type;

  DrawingToolEditorModel({
    this.shapes,
    this.onSelectingShape,
    this.onTapColor,
    this.onTapStroke,
    this.strokeValue = '0',
    this.isVisible = false,
    this.isStrokeActive = false,
    required this.type,
    this.onTapDelete,
  });

}