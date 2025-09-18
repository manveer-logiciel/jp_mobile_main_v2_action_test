
import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/templates/table/cell.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';


class TemplateFormTextInput extends StatelessWidget {

  const TemplateFormTextInput({
    super.key,
    required this.cell,
    this.readOnly,
    this.onTap
  });

  /// [cell] - holds the cell data
  final TemplateTableCellModel cell;

  /// [onTap] - handles click on fields
  final VoidCallback? onTap;

  final bool? readOnly;

  @override
  Widget build(BuildContext context) {
    return JPInputBox(
      controller: cell.controller,
      type: JPInputBoxType.inline,
      fillColor: cell.style?.background ?? JPAppTheme.themeColors.base,
      textColor: cell.style?.color ?? JPAppTheme.themeColors.text,
      readOnly: readOnly ?? false,
      textAlign: cell.style?.textAlign,
      maxLines: null,
      textAlignVertical: cell.style?.textAlignVertical,
      onPressed: onTap,
    );
  }
}
