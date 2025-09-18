
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/template_editor/index.dart';
import 'controller.dart';

class HandwrittenTemplateEditor extends StatelessWidget {
  const HandwrittenTemplateEditor({
    super.key,
    required this.controller
  });

  final HandwrittenTemplateEditorController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HandwrittenTemplateEditorController>(
        init: controller,
        global: false,
        builder: (controller) {
          return IgnorePointer(
            ignoring: true,
            child: FittedBox(
              child: SizedBox(
                height: controller.editorSize.height,
                width: controller.editorSize.width,
                child: JPTemplateEditor(
                  controller: controller,
                  isDisabled: controller.isSavingForm,
                ),
              ),
            ),
          );
        },
    );
  }
}
