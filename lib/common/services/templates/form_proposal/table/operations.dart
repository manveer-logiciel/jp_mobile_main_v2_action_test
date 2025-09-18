import 'package:jobprogress/common/extensions/String/index.dart';
import 'package:jobprogress/common/models/templates/table/cell.dart';
import 'package:jobprogress/common/models/templates/table/data.dart';
import 'package:jobprogress/common/models/templates/table/operation/main_cell.dart';
import 'package:jobprogress/common/models/templates/table/operation/multi_cell.dart';
import 'package:jobprogress/common/models/templates/table/row.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';

/// [FormProposalTableOperations] contains all the calculations
/// for table cells
/// - sum
/// - subtract
/// - % of column
/// - % of cell
/// - cell addition
/// - cell multiplication
/// - multiple expression calc.
class FormProposalTableOperations {

  FormProposalTableOperations(this.table);

  TemplateFormTableModel table;

  /// [sum] - performs addition on all the values of table body column
  /// How it works ?
  /// Ans: It exclude all the cells who don't have numeric accurate values
  /// Eg. [2, test, 4, 1] = 7
  /// [index] - here is the index of the column to calculate sum of
  String sum(int index) {
    double sum = 0;
    for (TemplateTableRowModel row in table.body) {
      final td = row.tds![index];
      sum += double.tryParse(td.getCellData().digitsOnly()) ?? 0;
    }
    return formattedResult(sum);
  }

  /// [subtractRows] - performs subtracting on given values, It can have more than 2
  /// values to perform subtraction on
  /// How it works ?
  /// Ans: It operates on array of [TemplateOperationCellModel] which contains row &
  /// cell index to be included in calculation.
  /// Eg. [10 - 3 - 2 - 2] = 3
  /// This function holds first value and keeps on subtracting rest of the value to get result
  String subtractRows(List<TemplateOperationCellModel> subs) {
    final row = table.foot;
    double result = 0.00;

    for (int i = 0; i < subs.length; i++) {
      final sub = subs[i];
      final value = row[sub.row!].tds![sub.cell!].getCellData();
      final formattedVal = double.tryParse(value.digitsOnly()) ?? 0;

      if (i == 0) {
        result += formattedVal;
      } else {
        result -= formattedVal;
      }
    }

    return formattedResult(result);
  }

  /// [percentColumn] - calculates percentage of column, It totally depends on table foot cells
  /// as well as on table body column to calculate result
  /// How it works ?
  /// Step1: It finds sum of all the cells falling in column index coming from [td.obj.field]
  /// Step2: One of cell of in which calculation is placed contains the percent value which
  /// can be accessed with [rowIndex] and [cellIndex]
  /// Result: (sum of column values) * (values at [rowIndex]-[cellIndex]) / 100
  String percentColumn(TemplateTableCellModel td, int rowIndex, int cellIndex) {
    final field = td.obj?.field;
    final rows = table.foot;

    double sum = 0;
    double percentage = 0;
    double result = 0;

    if (field == null) return "";

    for (TemplateTableRowModel row in table.body) {
      final td = row.tds![field];
      sum += double.tryParse(td.getCellData().digitsOnly()) ?? 0;
    }

    String percentageVal = rows[rowIndex].tds?[cellIndex].getCellData().digitsOnly() ?? "";
    percentage = double.tryParse(percentageVal) ?? 0;
    result = (sum * percentage) / 100;

    return formattedResult(result);
  }

  /// [evaluateMultiPlateCalculation] - performs multiple calculations that includes (+, -, x, /)
  /// How it works ?
  /// Step 1: It prepares a expression string from data coming from [TemplateMultiCellModel]
  /// Step 2: The resulted string "5 + 4 - 5 / 2 x 8" is then evaluated to find result
  String evaluateMultiPlateCalculation(List<TemplateMultiCellModel> multiCells) {
    final row = table.foot;
    double result = 0.00;
    String expressionWithData = "";

    for (int i = 0; i < multiCells.length; i++) {
      final cell = multiCells[i];
      final value = row[cell.row].tds![cell.col].getCellData();
      final formattedValue = double.tryParse(value.digitsOnly()) ?? 0;
      expressionWithData += "$formattedValue${cell.operation ?? ""}";
    }

    result = expressionWithData.evaluate();
    return formattedResult(result);
  }

  /// [multiplyRow] - performs simple multiplication on two values
  String multiplyRow(String firstVal, String secondVal) {
    double formattedFirstVal = double.tryParse(firstVal.digitsOnly()) ?? 0.00;
    double formattedSecondVal = double.tryParse(secondVal.digitsOnly()) ?? 0.00;

    final result = (formattedFirstVal * formattedSecondVal);

    return formattedResult(result);
  }

  /// [addRows] - performs cell additional operation. It works with table foot cells
  /// How it work ?
  /// Step 1: Iterates over values coming from [TemplateOperationCellModel]
  /// Step 2: Add each value to get result
  /// Result: 1 + 2 + 3 + 4 = 10
  String addRows(List<TemplateOperationCellModel> additions) {
    final row = table.foot;
    double result = 0.00;

    for (int i = 0; i < additions.length; i++) {
      final addition = additions[i];
      final value = row[addition.row!].tds![addition.cell!].getCellData();
      final formattedVal = double.tryParse(value.digitsOnly()) ?? 0;
      result += formattedVal;
    }

    return formattedResult(result);
  }

  /// [percentCell] - simply find percentage from two values
  String percentCell(String mainCellVal, String cellVal) {
    double formattedMainCellVal = double.tryParse(mainCellVal.digitsOnly()) ?? 0.00;
    double formattedCellVal = double.tryParse(cellVal.digitsOnly()) ?? 0.00;

    final result = (formattedMainCellVal * formattedCellVal) / 100;

    return formattedResult(result);
  }

  /// [computeColumn] Computes and returns the result of a compute operation for a given row.
  ///
  /// It iterates through the [operation] ([0, +, 2, *, 1]) list, extracting values from table cells
  /// based on integer indices and appending them to a string [resultToEvaluate].
  /// Operators (represented as strings) are also appended to the string.
  ///
  /// The resulting string is then evaluated using the [evaluate] method.
  /// If the result is finite,it is formatted using [formattedResult] and returned.
  /// Otherwise, "0" (formatted) is returned.
  ///
  /// - Parameters:
  ///   - operation: The list representing the compute operation.
  ///   - row: The index of the row to compute the result for.
  /// - Returns: The computed and formatted result as a string.
  String computeColumn(List<dynamic> operation, int row) {
    String resultToEvaluate = "";

    for (var val in operation) {
      if (val is int) {
        final cellDigits = table.body[row].tds![val].getCellData().digitsOnly();
        resultToEvaluate += cellDigits.isEmpty ? "0" : cellDigits;
      } else if (val is String) {
        resultToEvaluate += val;
      }
    }

    final result = resultToEvaluate.evaluate();
    return formattedResult(result.isFinite ? result : 0);
  }

  String formattedResult(double value) {
    return JobFinancialHelper.getCurrencyFormattedValue(value: value);
  }

}
