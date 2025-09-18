import 'package:jobprogress/common/models/templates/table/cell.dart';
import 'package:jobprogress/common/models/templates/table/data.dart';
import 'package:jobprogress/common/models/templates/table/operation/main_cell.dart';
import 'package:jobprogress/common/models/templates/table/operation/multiplication.dart';
import 'package:jobprogress/common/models/templates/table/row.dart';
import 'package:jobprogress/common/services/templates/form_proposal/table/operations.dart';
import 'package:jobprogress/core/utils/helpers.dart';

/// [FormProposalTableListeners] contains al the listeners that can be bind
/// to table cells
/// - sum listener
/// - subtract listener
/// - % of column listener
/// - % of cell listener
/// - cell addition listener
/// - cell multiplication listener
/// - multiple expression calc. listener
class FormProposalTableListeners {

  FormProposalTableListeners(this.table) {
    operations = FormProposalTableOperations(table);
  }

  TemplateFormTableModel table;

  late FormProposalTableOperations operations;

  /// [sumListener] bind listener on all the fields of column. So, whenever any
  /// value of that column change calculation should be updated
  void sumListener(TemplateTableCellModel td) {

    int? field = td.obj?.field;

    if (field == null) return;

    for (TemplateTableRowModel row in table.body) {

      if (Helper.isValueNullOrEmpty(row.tds)) continue;

      row.tds![field].addListener(() {
        td.controller.text = operations.sum(field);
      });
    }
  }

  /// [subListeners] binds listener on table foot cells as subtract
  /// operation calculations can be performed on table foot cells
  void subListeners(TemplateTableCellModel td) {
    final row = table.foot;
    List<TemplateOperationCellModel> subs = td.obj?.subs ?? [];

    if (subs.isEmpty) return;

    // adding listener on multiple cells
    for (var sub in subs) {
      if (sub.row == null || sub.cell == null) continue;
      row[sub.row!].tds![sub.cell!].addListener(() {
        td.controller.text = operations.subtractRows(subs);
      });
    }
  }

  /// [percentListener] binds listener on table's foot cell as percent column calculation
  /// requires %age value (eg. 2%, 20%) from one of the cell of current row along with
  /// sum of body column
  void percentListener(TemplateTableCellModel td, int rowIndex) {
    final row = table.foot;
    final cell = td.obj?.cell;

    if (cell == null) return;

    row[rowIndex].tds?[cell].addListener(() {
      td.controller.text = operations.percentColumn(td, rowIndex, cell);
    });
  }

  /// [multiPlateCalculationListener] binds listener on table foot cells as
  /// multiple operation calculations can be performed on table foot cells
  void multiPlateCalculationListener(TemplateTableCellModel td) {
    final row = table.foot;
    final multiCells = td.obj?.multiCells;

    if (multiCells == null) return;

    for (var cell in multiCells) {
      final controller = row[cell.row].tds?[cell.col];
      controller?.addListener(() {
        td.controller.text = operations.evaluateMultiPlateCalculation(multiCells);
      });
    }
  }

  /// [cellMultiplicationListener] binds listener on table foot cells as
  /// multiply calculations can be performed on table foot cells
  void cellMultiplicationListener(TemplateTableCellModel td, int index) {
    final row = table.foot;
    TemplateMultiplicationModel? multiplication = td.obj?.multiplication;

    if (multiplication == null || row[index].tds == null) return;

    // binding listeners on both the cells as change in any one should perform
    // re-calculation
    final firstController = row[index].tds![multiplication.first!];
    final secondController = row[index].tds![multiplication.second!];

    firstController.addListener(() {
      td.controller.text = operations.multiplyRow(
          firstController.controller.text,
          secondController.controller.text
      );
    });

    secondController.addListener(() {
      td.controller.text = operations.multiplyRow(
          firstController.controller.text,
          secondController.controller.text
      );
    });
  }

  /// [cellAdditionListeners] binds listener on table foot cells as
  /// cell addition can be performed on table foot cells
  void cellAdditionListeners(TemplateTableCellModel td) {
    final row = table.foot;
    List<TemplateOperationCellModel> additions = td.obj?.additions ?? [];

    if (additions.isEmpty) return;

    // binding listener to multiple cells
    for (var addition in additions) {
      if (addition.row == null || addition.cell == null) continue;
      row[addition.row!].tds![addition.cell!].addListener(() {
        td.controller.text = operations.addRows(additions);
      });
    }
  }

  /// [percentCellListeners] binds listener on table foot cells as
  /// percent cell calculation can be performed on table foot cells
  void percentCellListeners(TemplateTableCellModel td, int currentRowIndex) {
    final row = table.foot;
    TemplateOperationCellModel? mainCell = td.obj?.mainCell;
    int? cellIndex = td.obj?.cell;

    if (mainCell == null || cellIndex == null) return;

    // binding listeners on both the cells as change in any one should perform
    // re-calculation
    final mainCellController = row[mainCell.row!].tds![mainCell.cell!];
    final cellController = row[currentRowIndex].tds![cellIndex];

    mainCellController.addListener(() {
      td.controller.text = operations.percentCell(
        mainCellController.controller.text,
        cellController.controller.text,
      );
    });

    cellController.addListener(() async {
      td.controller.text = operations.percentCell(
          mainCellController.controller.text,
          cellController.controller.text
      );
    });
  }

  /// [computeColumn] Sets up a listener to compute and update the value of a
  /// result cell based on changes in other cells.
  ///
  /// - Parameters:
  ///   - td: The table cell to listen for changes on.
  ///   - operation: The list representing the compute operation.
  ///   - currentRowIndex: The index of the current row.
  void computeColumn(TemplateTableCellModel td, List<dynamic> operation, int currentRowIndex) {
    final resultCol = table.computeCols?.compute;
    if (resultCol == null) return;

    td.addListener(() {
      final resultCell = table.body[currentRowIndex].tds![resultCol];
      resultCell.controller.text = operations.computeColumn(operation, currentRowIndex);
    });
  }
}
