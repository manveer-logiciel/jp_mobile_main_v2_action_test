import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/templates/table/data.dart';
import 'package:jobprogress/common/models/templates/table/operation/main_cell.dart';
import 'package:jobprogress/common/models/templates/table/operation/multi_cell.dart';
import 'package:jobprogress/common/services/templates/form_proposal/table/operations.dart';
import 'mocked_operation_table.dart';

/// Tables used for testing
///
///   |--------------------|--------------------|-------------------|
///   |    Heading 1       |      Heading 2     |      Heading 3    |  <--- HEAD
///   |--------------------|--------------------|-------------------|
///   |     $10            |       12           |       14          |
///   |      21            |       kkk          |       12          |  <--- BODY
///   |      33            |       22           |       44          |
///   |--------------------|--------------------|-------------------|
///   |     $64.00         |      $34.00        |       $70.00      |
///   |     $30.00         |        2           |       $1.28       |
///   |     $67.92         |        3           |       $1.92       |  <--- FOOT
///   |     $81.00         |        6           |       $72.00      |
///   |       abc          |                    |                   |
///   |--------------------|--------------------|-------------------|

void main() {

  final table = TemplateFormTableModel.fromJson(MockedOperationTable.tableData);

  FormProposalTableOperations operations = FormProposalTableOperations(table);

  setUpAll(() {
    Get.locale = const Locale('en_US');
  });

  group("FormProposalTableOperations@sum should perform addition on table body column", () {
    test("When all values of columns are valid numbers", () {
      final result = operations.sum(2);
      expect(result, operations.formattedResult(70));
    });

    test("When values have special symbols", () {
      final result = operations.sum(0);
      expect(result, operations.formattedResult(64));
    });

    test("When some values are non numeric", () {
      final result = operations.sum(1);
      expect(result, operations.formattedResult(34));
    });
  });

  group("FormProposalTableOperations@subtractRows should perform subtracting on given values", () {
    test("When two numeric values are subtracted", () {
      final result = operations.subtractRows([
        TemplateOperationCellModel(row: 3, cell: 1),
        TemplateOperationCellModel(row: 2, cell: 1)
      ]);
      expect(result, operations.formattedResult(3));
    });

    test("When two values with special characters are subtracted", () {
      final result = operations.subtractRows([
        TemplateOperationCellModel(row: 0, cell: 2),
        TemplateOperationCellModel(row: 0, cell: 0)
      ]);
      expect(result, operations.formattedResult(6));
    });

    test("When number value is subtracted from non numeric value", () {
      final result = operations.subtractRows([
        TemplateOperationCellModel(row: 0, cell: 2),
        TemplateOperationCellModel(row: 4, cell: 0)
      ]);
      expect(result, operations.formattedResult(70));
    });

    test("When more than two values are subtracted", () {
      final result = operations.subtractRows([
        TemplateOperationCellModel(row: 0, cell: 2),
        TemplateOperationCellModel(row: 4, cell: 0),
        TemplateOperationCellModel(row: 1, cell: 0)
      ]);
      expect(result, operations.formattedResult(40));
    });
  });

  group("FormProposalTableOperations@percentColumn should calculate percentage of column", () {
    test("When all values are valid numerics", () {
      final result = operations.percentColumn(table.foot[0].tds![2], 1, 2);
      expect(result, operations.formattedResult(0.90));
    });

    test("When values have special characters", () {
      final result = operations.percentColumn(table.foot[0].tds![0], 1, 2);
      expect(result, operations.formattedResult(0.82));
    });

    test("When values have non numeric values", () {
      final result = operations.percentColumn(table.foot[0].tds![1], 1, 2);
      expect(result, operations.formattedResult(0.44));
    });
  });

  group("FormProposalTableOperations@evaluateMultiPlateCalculation should perform multiple calculations that includes (+, -, x, /)", () {
    test("When all values are valid numerics", () {
      final result = operations.evaluateMultiPlateCalculation([
        TemplateMultiCellModel(row: 1, col: 1, operation: "+"),
        TemplateMultiCellModel(row: 2, col: 1, operation: "-"),
        TemplateMultiCellModel(row: 3, col: 1, operation: "*"),
        TemplateMultiCellModel(row: 1, col: 1, operation: ""),
      ]);
      expect(result, operations.formattedResult(-7));
    });

    test("When values have special characters", () {
      final result = operations.evaluateMultiPlateCalculation([
        TemplateMultiCellModel(row: 0, col: 1, operation: "+"),
        TemplateMultiCellModel(row: 2, col: 1, operation: "-"),
        TemplateMultiCellModel(row: 3, col: 1, operation: "*"),
        TemplateMultiCellModel(row: 1, col: 1, operation: ""),
      ]);
      expect(result, operations.formattedResult(25));
    });

    test("When values have non-numeric values", () {
      final result = operations.evaluateMultiPlateCalculation([
        TemplateMultiCellModel(row: 0, col: 1, operation: "+"),
        TemplateMultiCellModel(row: 4, col: 0, operation: "-"),
        TemplateMultiCellModel(row: 3, col: 1, operation: "*"),
        TemplateMultiCellModel(row: 1, col: 1, operation: ""),
      ]);
      expect(result, operations.formattedResult(22));
    });
  });

  group("FormProposalTableOperations@multiplyRow should multiply two values of table", () {
    test("When all values are valid numerics", () {
      final result = operations.multiplyRow('5', "5");
      expect(result, operations.formattedResult(25));
    });

    test("When values have special characters", () {
      final result = operations.multiplyRow('5', "av5");
      expect(result, operations.formattedResult(25));
    });

    test("When values have non-numeric values", () {
      final result = operations.multiplyRow('abc', "av5");
      expect(result, operations.formattedResult(0));
    });
  });

  group('FormProposalTableOperations@addRows should perform cell additional operation', () {
    test("When all values are valid numerics", () {
      final result = operations.addRows([
        TemplateOperationCellModel(row: 1, cell: 1),
        TemplateOperationCellModel(row: 2, cell: 1),
      ]);
      expect(result, operations.formattedResult(5));
    });

    test("When values have special characters", () {
      final result = operations.addRows([
        TemplateOperationCellModel(row: 0, cell: 1),
        TemplateOperationCellModel(row: 2, cell: 1),
      ]);
      expect(result, operations.formattedResult(37));
    });

    test("When values have non-numeric values", () {
      final result = operations.addRows([
        TemplateOperationCellModel(row: 0, cell: 1),
        TemplateOperationCellModel(row: 2, cell: 1),
        TemplateOperationCellModel(row: 4, cell: 0),
      ]);
      expect(result, operations.formattedResult(37));
    });
  });

  group('FormProposalTableOperations@percentCell should find percentage from two values', () {
    test("When all values are valid numerics", () {
      final result = operations.percentCell('5', '3');
      expect(result, operations.formattedResult(0.15));
    });

    test("When values have special characters", () {
      final result = operations.percentCell('\$5', '3');
      expect(result, operations.formattedResult(0.15));
    });

    test("When values have non-numeric values", () {
      final result = operations.percentCell('\$5', 'abc');
      expect(result, operations.formattedResult(0));
    });
  });

  group("FormProposalTableOperations@computeColumn should evaluate a compute operation", () {
    test('Sum operation should be handled', () {
      final operation = [0, '+', 2];
      final result = operations.computeColumn(operation, 0);
      expect(result, operations.formattedResult(24.0));
    });

    test('Subtract operation should be handled', () {
      final operation = [1, '-', 2];
      final result = operations.computeColumn(operation, 1);
      expect(result, operations.formattedResult(-12));
    });

    test('Multiply operation should be handled', () {
      final operation = [0, '*', 1];
      final result = operations.computeColumn(operation, 0);
      expect(result, operations.formattedResult(120.0));
    });

    test('Divide operation should be handled', () {
      final operation = [2, '/', 2];
      final result = operations.computeColumn(operation, 1);
      expect(result, operations.formattedResult(1));
    });

    test('Multiple operation should be handled', () {
      final operation = [0, '*', 2, '+', 1];
      final result = operations.computeColumn(operation, 0);
      expect(result, operations.formattedResult(152.0));
    });
  });

}