import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/templates/table/cell.dart';
import 'package:jobprogress/common/models/templates/table/compute/column.dart';
import 'package:jobprogress/common/models/templates/table/data.dart';
import 'package:jobprogress/common/models/templates/table/row.dart';

void main() {
  List<TemplateTableRowModel> head = [
    TemplateTableRowModel(tds: [
      TemplateTableCellModel(),
      TemplateTableCellModel(),
      TemplateTableCellModel(),
    ])
  ];

  TemplateFormTableModel tableModel = TemplateFormTableModel();

  setUpAll(() {
    Get.locale = const Locale('en');
    tableModel.head = head;
  });

  group("TemplateFormTableModel@getEmptyRow should return an empty row on 'Add Row'", () {
    test("Row should be generated with empty cells having same number of columns as per table", () {
      final row = tableModel.getEmptyRow();
      expect(row.tds?.length, head.first.tds?.length);
    });

    test("Row should be generated with empty cells", () {
      final row = tableModel.getEmptyRow();
      expect(row.tds?.length, head.first.tds?.length);
      for (int i = 0; i < (row.tds?.length ?? 0); i++) {
        expect(row.tds?[i].text, "");
      }
    });

    test("Compute Result cell in Row should be filled with 0 amount", () {
      tableModel.computeCols = TemplateTableComputeCol(
        compute: 0
      );
      final row = tableModel.getEmptyRow();
      expect(row.tds?[0].formattedText, "\$0.00");
      expect(row.tds?[1].formattedText, "");
      expect(row.tds?[2].formattedText, "");
    });
  });
}