import 'package:flutter/material.dart';
import 'package:jobprogress/common/enums/templates.dart';
import 'package:jobprogress/common/extensions/scroll/no_scroll_physics.dart';
import 'package:jobprogress/common/models/templates/table/data.dart';
import 'package:jobprogress/modules/files_listing/templates/form_proposal/widget/table/controller.dart';
import 'add_remove_row.dart';
import 'table.dart';

class TemplateFormTableView extends StatelessWidget {
  const TemplateFormTableView({
    super.key,
    required this.table,
    required this.controller,
  });

  /// [table] - holds the table data
  final TemplateFormTableModel table;

  /// [controller] - provide access to controller functions
  final TemplateTableController controller;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: NoScrollPhysics(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ///   head
            TemplateFormTable(
              rows: table.head,
              columnWidths: table.widths ?? {},
              controller: controller,
              type: TableCellType.head,
            ),
            ///   body
            TemplateFormTable(
              rows: table.body,
              columnWidths: table.widths ?? {},
              controller: controller,
              type: TableCellType.body,
            ),
            ///   add remove buttons
            TemplateTableAddRemoveRow(
              controller: controller,
            ),
            ///   footer
            TemplateFormTable(
              rows: table.foot,
              columnWidths: table.widths ?? {},
              controller: controller,
              type: TableCellType.foot,
            ),
          ],
        ),
      ),
    );
  }
}
