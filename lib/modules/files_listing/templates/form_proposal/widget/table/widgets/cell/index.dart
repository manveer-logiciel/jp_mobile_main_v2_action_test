import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/templates/table/cell.dart';
import 'package:jobprogress/modules/files_listing/templates/form_proposal/widget/table/controller.dart';
import 'drop_down.dart';
import 'text_input.dart';

/// [TemplateFormCellFields] - decides and renders table cell field
class TemplateFormCellFields extends StatelessWidget {

  const TemplateFormCellFields({
    super.key,
    required this.cell,
    required this.controller,
  });

  /// [cells] - holds the cell data
  final TemplateTableCellModel cell;

  /// [controller] - provides access to controller functions
  final TemplateTableController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        children: [
          TemplateFormTextInput(
            cell: cell,
            readOnly: controller.isCellDisabled(cell),
            onTap: () => controller.selectCell(cell),
          ),

          if (cell.dropdown?.isDropdown ?? false)
            TemplateFormTableDropDown(
              cell: cell,
              onTap: () => controller.openEditableSingleSelect(cell),
            ),
        ],
      ),
    );
  }

}
