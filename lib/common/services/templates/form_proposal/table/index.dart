import 'package:jobprogress/common/models/templates/table/cell.dart';
import 'package:jobprogress/common/models/templates/table/data.dart';
import 'package:jobprogress/common/services/templates/form_proposal/table/listeners.dart';

class FormProposalTemplateTableService {

  FormProposalTemplateTableService(this.table) {
    listeners = FormProposalTableListeners(table);
  }

  late TemplateFormTableModel table; // holds table data

  late FormProposalTableListeners listeners; // contains all the listeners
  
  /// [bindListener] is responsible for binding listeners to table cells
  void bindListener({
    required TemplateTableCellModel td,
    required int rowIndex,
    required int cellIndex,
    String? operation,
  }) {
    switch (operation) {
      case "sum":
        listeners.sumListener(td);
        break;

      case "sub":
        listeners.subListeners(td);
        break;

      case 'percent':
        listeners.percentListener(td, rowIndex);
        break;

      case "percent_cell":
        listeners.percentCellListeners(td, rowIndex);
        break;

      case 'cell_addition':
        listeners.cellAdditionListeners(td);
        break;

      case 'cell_mul':
        listeners.cellMultiplicationListener(td, rowIndex);
        break;

      case 'multi_cal':
        listeners.multiPlateCalculationListener(td);
        break;
    }
  }

  /// [bindComputeColumnListener] is responsible for adding listener to table cells
  /// for computing column
  void bindComputeColumnListener({
    required TemplateTableCellModel td,
    required int rowIndex,
    required List<dynamic> operation,
  }) {
    listeners.computeColumn(td, operation, rowIndex);
  }
}
