import 'package:flutter/material.dart';
import 'package:jobprogress/common/enums/templates.dart';
import 'package:jobprogress/common/models/templates/table/cell.dart';
import 'package:jobprogress/common/models/templates/table/row.dart';
import 'package:jp_mobile_flutter_ui/Table/cell.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../controller.dart';
import 'cell/index.dart';

class TemplateFormTable extends StatelessWidget {

  const TemplateFormTable({
    super.key,
    required this.rows,
    required this.columnWidths,
    required this.controller,
    this.type = TableCellType.body,
  });

  /// [rows] - contains lists of rows to be displayed
  final List<TemplateTableRowModel> rows;

  /// [columnWidths] - holds width of columns
  final Map<int, double> columnWidths;

  /// [controller] - provides access to controller function
  final TemplateTableController controller;

  /// [types] - helps in rendering table borders
  final TableCellType type;

  @override
  Widget build(BuildContext context) {

    return JPTable<TemplateTableCellModel>(
      rows: rows,
      decoration: getDecoration(),
      getCells: (index) => rows[index].tds ?? [],
      cell: (row, column, cellData) {
        return JPTableCell(
          background: cellData.style?.background ?? JPAppTheme.themeColors.base,
          textAlignVertical: cellData.style?.textAlignVertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: TemplateFormCellFields(
              cell: cellData,
              controller: controller,
            ),
          ),
        );
      },
      columnWidths: columnWidths,
    );
  }

  BoxDecoration? getDecoration() {
    switch (type) {
      case TableCellType.head:
        return const BoxDecoration(
            border: Border(
          left: BorderSide(width: 0.5),
          top: BorderSide(width: 0.5),
          right: BorderSide(width: 0.5),
        ));

      case TableCellType.body:
        return const BoxDecoration(
            border: Border(
          left: BorderSide(width: 0.5),
          bottom: BorderSide(width: 0.5),
          right: BorderSide(width: 0.5),
        ));

      default:
        return null;
    }
  }
}
