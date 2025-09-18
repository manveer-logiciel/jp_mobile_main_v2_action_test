import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/templates/table/cell.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class TemplateFormTableDropDown extends StatelessWidget {
  const TemplateFormTableDropDown({
    super.key,
    required this.cell,
    this.onTap
  });

  /// [cell] - holds the cell data
  final TemplateTableCellModel cell;

  /// [onTap] - handles click on fields
  final VoidCallback? onTap;

  String? get text => (cell.dropdown?.selectedText?.isEmpty ?? true)
          ? "select".tr
          : cell.dropdown?.selectedText;

  @override
  Widget build(BuildContext context) {
    return JPInputBox(
      controller: TextEditingController(
        text: text
      ),
      type: JPInputBoxType.inline,
      fillColor: cell.style?.background ?? JPAppTheme.themeColors.base,
      textColor: cell.style?.color ?? JPAppTheme.themeColors.text,
      readOnly: true,
      textAlign: cell.style?.textAlign,
      textAlignVertical: cell.style?.textAlignVertical,
      onPressed: onTap,
      suffixChild: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: JPIcon(
          Icons.keyboard_arrow_down_outlined,
          color: cell.style?.color ?? JPAppTheme.themeColors.text,
        ),
      ),
    );
  }
}
