import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/templates.dart';
import 'package:jobprogress/common/models/templates/table/cell.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class TemplateTableCellEditor extends StatelessWidget {

  const TemplateTableCellEditor({
      super.key,
      this.cell,
      this.onTapTextAlign,
      this.onTapVerticalAlign,
      this.onTapHide,
      this.hiddenVal
  });

  /// [cell] - holds cell data
  final TemplateTableCellModel? cell;

  /// [onTapTextAlign] - handles click on text align field
  final VoidCallback? onTapTextAlign;

  /// [onTapVerticalAlign] - handles click on text vertical align field
  final VoidCallback? onTapVerticalAlign;

  /// [onTapHide] - handles click on hide column field
  final VoidCallback? onTapHide;

  /// [hiddenVal] - contains id of hidden column
  final String? hiddenVal;

  FormUiHelper get uiHelper => FormUiHelper();

  bool get disableAlignFields => cell == null || cell?.type == TableCellType.head;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ///   text align
            Expanded(
              child: JPInputBox(
                controller: TextEditingController(
                    text: cell?.style?.textAlignString?.capitalizeFirst
                ),
                label: 'text_align'.tr,
                hintText: 'select'.tr,
                type: JPInputBoxType.withLabel,
                readOnly: true,
                disabled: disableAlignFields,
                onPressed: onTapTextAlign,
                fillColor: JPAppTheme.themeColors.base,
                suffixChild: Padding(
                  padding: EdgeInsets.symmetric(horizontal: uiHelper.suffixPadding),
                  child: JPIcon(
                    Icons.keyboard_arrow_down_outlined,
                    color: JPAppTheme.themeColors.text,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            ///   text vertical align
            Expanded(
              child: JPInputBox(
                controller: TextEditingController(
                    text: cell?.style?.verticalAlignString?.capitalizeFirst
                ),
                label: 'vertical_align'.tr,
                hintText: 'select'.tr,
                type: JPInputBoxType.withLabel,
                readOnly: true,
                disabled: disableAlignFields,
                onPressed: onTapVerticalAlign,
                fillColor: JPAppTheme.themeColors.base,
                suffixChild: Padding(
                  padding: EdgeInsets.symmetric(horizontal: uiHelper.suffixPadding),
                  child: JPIcon(
                    Icons.keyboard_arrow_down_outlined,
                    color: JPAppTheme.themeColors.text,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        ///   hide column
        JPInputBox(
          controller: TextEditingController(
              text: hiddenVal
          ),
          label: 'hide_values'.tr,
          type: JPInputBoxType.withLabel,
          fillColor: JPAppTheme.themeColors.base,
          readOnly: true,
          onPressed: onTapHide,
          suffixChild: Padding(
            padding: EdgeInsets.symmetric(horizontal: uiHelper.suffixPadding),
            child: JPIcon(
              Icons.keyboard_arrow_down_outlined,
              color: JPAppTheme.themeColors.text,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
