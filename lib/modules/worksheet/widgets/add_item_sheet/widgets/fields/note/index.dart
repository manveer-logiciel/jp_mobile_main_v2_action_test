import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/IconButton/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../../../common/services/files_listing/forms/worksheet_form/add_item.dart';
import '../../../controller.dart';
import 'controller.dart';

class WorksheetAddItemAddNoteField extends StatelessWidget {

  const WorksheetAddItemAddNoteField({
    super.key,
    required this.controller
  });

  final WorksheetAddItemController controller;

  WorksheetAddItemService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorksheetAddItemAddNoteFieldController>(
      init: WorksheetAddItemAddNoteFieldController(noteText: service.noteController.text),
      global: false,
      builder: (noteController) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(18.0)),
            color: JPAppTheme.themeColors.base,
          ),
          child: Padding(
            padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                JPText(
                  text: 'note'.tr.toUpperCase(),
                  textSize: JPTextSize.heading4,
                  fontWeight: JPFontWeight.medium,
                  textColor: JPAppTheme.themeColors.darkGray,
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    if (noteController.noteText.isEmpty) ...{
                      JPTextButton(
                        text: 'tap_here'.tr,
                        color: JPAppTheme.themeColors.primary,
                        textSize: JPTextSize.heading4,
                        padding: 1,
                        onPressed: () => noteController.openNote(service.onNoteChange),
                      ),
                      const SizedBox(width: 3,),
                      JPText(
                        text: 'to_create_a_note'.tr,
                        textSize: JPTextSize.heading4,
                        textColor: JPAppTheme.themeColors.darkGray,
                      )
                    } else ...{
                      Flexible(
                        child: JPText(
                          text: service.noteController.text,
                          textAlign: TextAlign.left,
                          textColor: JPAppTheme.themeColors.text,
                        )
                      ),
                      const SizedBox(width: 10,),
                      JPIconButton(icon: Icons.edit_outlined,
                        onTap: () => noteController.openNote(service.onNoteChange),
                      )
                      }
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
