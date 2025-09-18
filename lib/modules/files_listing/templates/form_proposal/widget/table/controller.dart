import 'package:get/get.dart';
import 'package:jobprogress/common/models/templates/table/cell.dart';
import 'package:jobprogress/common/models/templates/table/compute/column.dart';
import 'package:jobprogress/common/models/templates/table/data.dart';
import 'package:jobprogress/common/models/templates/table/row.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/common/services/templates/form_proposal/table/index.dart';
import 'package:jobprogress/core/constants/dropdown_list_constants.dart';
import 'package:jobprogress/core/constants/templates.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jp_mobile_flutter_ui/EditableSingleSelect/index.dart';

class TemplateTableController extends GetxController {

  TemplateTableController(this.table);

  final TemplateFormTableModel table; // holds the table data

  TemplateTableCellModel? selectedCell; // holds data of active table cell

  late FormProposalTemplateTableService service; // helps in binding listeners

  // returns the hidden column name
  String? get hiddenColumnName {
    if (table.hiddenColumn != null) {
      return table.columns[table.hiddenColumn! + 1].label;
    }
    return 'none'.tr;
  }

  @override
  void onInit() {
    service = FormProposalTemplateTableService(table);
    addOperationListeners();
    super.onInit();
  }

  // [selectCell] - updates values of selected cell, so editor values can be
  // displayed accordingly
  void selectCell(TemplateTableCellModel cell) {
    selectedCell = cell;
    update();
  }

  // [isCellDisabled] - returns true if the operation is not none and not empty or null
  bool isCellDisabled(TemplateTableCellModel cell) {
    return !Helper.isValueNullOrEmpty(cell.obj?.operation) && cell.obj?.operation != TemplateConstants.none;
  }

  // [selectAlignment] - opens up single select to select text alignment
  void selectAlignment() {
    FormValueSelectorService.openSingleSelect(
        title: 'select_text_align'.tr,
        list: DropdownListConstants.tableCellTextAlignList,
        selectedItemId: selectedCell?.style?.textAlignString ?? "",
        onValueSelected: (val) {
          selectedCell?.style?.setAlignment(val);
          update();
        },
    );
  }

  // [selectVerticalAlignment] - opens up single select to select text vertical alignment
  void selectVerticalAlignment() {
    FormValueSelectorService.openSingleSelect(
      title: 'select_vertical_align'.tr,
      list: DropdownListConstants.tableCellVerticalAlignList,
      selectedItemId: selectedCell?.style?.verticalAlignString ?? "",
      onValueSelected: (val) {
        selectedCell?.style?.setVerticalAlignment(val);
        update();
      },
    );
  }

  // [selectHideColumn] - opens up single select to select which column to hide
  void selectHideColumn() {
    onTapOutside();
    FormValueSelectorService.openSingleSelect(
      title: 'select_hide_value'.tr,
      list: table.columns,
      selectedItemId: table.hiddenColumn.toString(),
      onValueSelected: (val) {
        table.hiddenColumn = int.tryParse(val);
        update();
      },
    );
  }

  // [getHtml] - combines HTML coming from [head, body, foot] to be returned to
  // previous screen or widget
  String getHtml() {
    return table.getHeadHtml()
        + table.getBodyHtml()
        + table.getFooterHtml();
  }

  // [openEditableSingleSelect] - opens up editable single select for dropdown
  // used inside table cell
  void openEditableSingleSelect(TemplateTableCellModel cell) {
    showJPBottomSheet(
        child: (_) => JPEditableSingleSelect(
            mainList: cell.dropdown?.options ?? [],
            searchHint: "search_here".tr,
            selectedItemId: cell.dropdown?.selectedOptionId,
            onUpdate: (list, selectedOption) {
              if (selectedOption == null) return;
              cell.dropdown?.setDataFromSingleSelect(list, selectedOption);
              update();
            },
        )
    );
  }

  // [addRow] - adds body row in existing table
  void addRow() {
    // adding an empty row at the end
    table.body.add(table.getEmptyRow());
    // removing previous listeners from body and foot
    removeOperationListeners(table.body);
    removeOperationListeners(table.foot);
    // binding new listeners
    addOperationListeners();
    onTapOutside();
  }

  // [removeRow] - removes last row of the table body
  void removeRow() {
    table.body.removeLast();
    // executing all the calculations again so that on removing row
    // calculations show update
    updateCellCalculations(table.body);
    updateCellCalculations(table.foot);
    onTapOutside();
  }

  // [addOperationListeners] - is responsible for adding listener to table cells
  void addOperationListeners() {
    // Setting up listener for compute columns
    if (table.computeCols is TemplateTableComputeCol) {
      addComputeColumnListener();
    }

    // reading all the table foot rows, as they are only responsible to calculations
    for (int rowIndex = 0; rowIndex < (table.foot.length); rowIndex++) {
      // getting current row
      final row = table.foot[rowIndex];
      // Iterating through each cell to bind listeners accordingly
      for(int cellIndex = 0; cellIndex < (row.tds?.length ?? 0); cellIndex++) {
        TemplateTableCellModel td = row.tds![cellIndex];
        String operation = td.obj?.operation ?? "";
        // binding listeners
        service.bindListener(
            td: td,
            rowIndex: rowIndex,
            cellIndex: cellIndex,
            operation: operation
        );
      }
    }
  }

  /// [addComputeColumnListener] is responsible for adding listener of body cells
  /// which participate in compute column calculation
  void addComputeColumnListener() {
    final operation = table.computeCols!.getComputeOperation();
    // reading all the table foot rows, as they are only responsible to calculations
    for (int rowIndex = 0; rowIndex < (table.body.length); rowIndex++) {
      // getting current row
      final row = table.body[rowIndex];
      // Iterating through each cell to bind listeners accordingly
      for(int cellIndex = 0; cellIndex < (row.tds?.length ?? 0); cellIndex++) {
        if (table.computeCols!.checkIfComputeColumn(cellIndex)) {
          TemplateTableCellModel td = row.tds![cellIndex];
          service.bindComputeColumnListener(
            td: td,
            operation: operation,
            rowIndex: rowIndex,
          );
        }
      }
    }
  }

  // [removeOperationListeners] - removes listener from all cells
  void removeOperationListeners(List<TemplateTableRowModel> list) async {
    for (int rowIndex = 0; rowIndex < (list.length); rowIndex++) {

      final row = list[rowIndex];

      for(int cellIndex = 0; cellIndex < (row.tds?.length ?? 0); cellIndex++) {
        TemplateTableCellModel td = row.tds![cellIndex];
        td.removeListeners();
      }
    }
  }

  void updateCellCalculations(List<TemplateTableRowModel> list) {
    for (int rowIndex = 0; rowIndex < (list.length); rowIndex++) {

      final row = list[rowIndex];

      for(int cellIndex = 0; cellIndex < (row.tds?.length ?? 0); cellIndex++) {
        TemplateTableCellModel td = row.tds![cellIndex];
        td.callAllListeners();
      }
    }
  }

  void onTapOutside() {
    selectedCell = null;
    update();
    Helper.hideKeyboard();
  }

}