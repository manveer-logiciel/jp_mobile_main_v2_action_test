import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jobprogress/common/enums/drawing_tool.dart';
import 'package:jobprogress/common/models/drawing_tool/drawing_tool_editor.dart';
import 'package:jobprogress/modules/drawing_tool/controller.dart';
import 'package:jobprogress/modules/drawing_tool/widgets/editor/brush.dart';
import 'package:jobprogress/modules/drawing_tool/widgets/editor/shapes.dart';
import 'package:jobprogress/modules/drawing_tool/widgets/editor/text.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class DrawingToolEditorOptions extends StatefulWidget {

  const DrawingToolEditorOptions({
    super.key,
    required this.data,
    required this.controller
  });

  final DrawingToolEditorModel data;

  final DrawingToolController controller;

  @override
  State<DrawingToolEditorOptions> createState() => _DrawingToolEditorOptionsState();
}

class _DrawingToolEditorOptionsState extends State<DrawingToolEditorOptions> {

  late ScrollController scrollController;
  double maxScrollExtent = 0.0;
  ValueNotifier<bool> isExpandable = ValueNotifier(true);

  @override
  void initState() {
    initializeScrollController();
    super.initState();
  }

  void initializeScrollController() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      isExpandable.value = scrollController.offset >= scrollController.position.maxScrollExtent - 30;
    });
  }

  @override
  void didUpdateWidget(DrawingToolEditorOptions oldWidget) {

    Timer(const Duration(microseconds: 10), () {
      isExpandable.value = scrollController.offset >= scrollController.position.maxScrollExtent - 30;
    });

    if(oldWidget.data.type != widget.data.type) {
      scrollController.jumpTo(0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.controller.isEditorVisible,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 5
                    ),
                    child: typeToEditor(),
                  ),
                ),
                ValueListenableBuilder(
                    valueListenable: isExpandable,
                    builder: (_, bool isExpandable, child) {
                      return !isExpandable ? child! : const SizedBox();
                    },
                  child: JPTextButton(
                    icon: Icons.chevron_right,
                    color: JPColor.white,
                    padding: 8,
                    iconSize: 20,
                    onPressed: showHiddenItems,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget typeToEditor() {
    switch(widget.data.type) {
      case DrawingToolEditorType.addShape:
        return DrawingToolShapesEditor(data: widget.data, selectedShape: widget.controller.drawingToolController.shapeFactory);

      case DrawingToolEditorType.addBrush:
        return DrawingToolBrushEditor(data: widget.data);

      case DrawingToolEditorType.editText:
        return DrawingToolEditorText(
            controller: widget.controller,
            data: widget.data,
        );
      case DrawingToolEditorType.editShape:
        return DrawingToolShapesEditor(data: widget.data, editShapeOnly: true,);

    }
  }

  void showHiddenItems() {
    maxScrollExtent = scrollController.position.maxScrollExtent;
    scrollController.animateTo(
        maxScrollExtent - 30,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
    );
  }
}
