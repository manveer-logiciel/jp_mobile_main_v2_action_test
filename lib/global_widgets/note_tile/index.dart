import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import 'controller.dart';

class NoteTile extends StatelessWidget {

  const NoteTile({
    super.key,
    required this.note,
    required this.callback,
    required this.isDisable,
    this.isWithSnippets = false
  });

  final String note;
  final Function(String?) callback;
  final bool isDisable;
  final bool isWithSnippets;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NoteTileController>(
      init: NoteTileController(noteText: note, isWithSnippets: isWithSnippets),
      global: false,
      builder: (controller) {
        return InkWell(
          onTap: isDisable ? null : controller.noteText.isNotEmpty ? () => controller.openJobNote(callback) : null,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(18.0)),
              color: JPAppTheme.themeColors.base,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
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
                      if (controller.noteText.isEmpty) ...{
                        AbsorbPointer(
                          absorbing: isDisable,
                          child: JPTextButton(
                            text: 'tap_here'.tr,
                            color: JPAppTheme.themeColors.primary,
                            textSize: JPTextSize.heading4,
                            padding: 1,
                            onPressed: () => controller.openJobNote(callback),
                          ),
                        ),
                        const SizedBox(width: 3,),
                        JPText(
                          text: 'to_create_a_note'.tr,
                          textSize: JPTextSize.heading4,
                          textColor: JPAppTheme.themeColors.darkGray,
                        )
                      } else ...{
                        Expanded(
                          child: Padding(
                           padding: const EdgeInsets.only(left: 0),
                            child: JPText(
                              text: note,
                              textAlign: TextAlign.left,
                              textColor: JPAppTheme.themeColors.text,
                            ),
                          ))
                        }
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
