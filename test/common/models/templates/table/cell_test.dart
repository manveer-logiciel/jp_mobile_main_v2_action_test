
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/templates/table/cell.dart';

void main() {
  group("TemplateTableCellModel should set cell text correctly", () {
    test("When text is invalid/null, cell text should be empty", () {
      final cell =TemplateTableCellModel(
        text: null
      );
      expect(cell.controller.text, "");
    });

    test("When text is empty, cell text should be empty", () {
      final cell =TemplateTableCellModel(
        text: ""
      );
      cell.text = "";
      expect(cell.controller.text, "");
    });

    test("When text is valid, cell text should be same", () {
      final cell =TemplateTableCellModel(
        text: "test"
      );
      expect(cell.controller.text, "test");
    });
  });
}