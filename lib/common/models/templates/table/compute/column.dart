import 'details.dart';
import 'extra_col.dart';

class TemplateTableComputeCol {
  int? compute;
  TemplateTableComputeDetail? computeDetail;
  List<TemplateTableComputeExtraCol>? extraCols;

  TemplateTableComputeCol({
    this.compute,
    this.computeDetail,
  });

  TemplateTableComputeCol.fromJson(Map<String, dynamic>? json) {
    compute = int.tryParse((json?['compute']).toString());
    computeDetail = json?['computeDetail'] is Map
        ? TemplateTableComputeDetail.fromJson(json!['computeDetail'])
        : null;
  }

  /// Initializes and populates the [extraCols] list with
  /// [TemplateTableComputeExtraCol] objects parsed from the provided JSON array.
  ///
  /// If [extraCols] is null, it is initialized as an empty list.
  /// Then, it iterates through the [json] list, parsing each element
  /// into a [TemplateTableComputeExtraCol] object using the [fromJson] constructor
  /// and adding it to the [extraCols] list.
  void setExtraCols(List<dynamic> json) {
    extraCols ??= [];
    for (var tempExtraCol in json) {
      extraCols?.add(TemplateTableComputeExtraCol.fromJson(tempExtraCol));
    }
  }

  /// [checkIfComputeColumn] Checks if the given column index corresponds to a compute column.
  ///
  /// It verifies if the index matches either of the fields in [computeDetail]
  /// or any of the fields in the [extraCols] list.
  ///
  /// Returns [True] if the column index is a compute column, [False] otherwise
  bool checkIfComputeColumn(int columnIndex) {
    return computeDetail?.fields?.first?.tdIndex == columnIndex ||
        computeDetail?.fields?.second?.tdIndex == columnIndex ||
        (extraCols?.any((col) => col.field == columnIndex) ?? false);
  }

  /// [getComputeOperation] Constructs and returns a list representing the compute operation.
  ///
  /// The list starts with the indices of the two primary fields involved in the computation,
  /// followed by the operation sign.
  ///
  /// If [extraCols] is not null, it iterates through the list, appending the sign and field
  /// of each extra column to the operation list.
  ///
  /// Returns a list representing the complete compute operation. [0, +, 2, -, 4]
  List<dynamic> getComputeOperation() {

    if (computeDetail?.fields?.first?.tdIndex == null) return [];

    final List<dynamic> operation = [
      computeDetail!.fields!.first!.tdIndex!,
      computeDetail!.operation!.sign!,
      computeDetail!.fields!.second!.tdIndex!,
    ];

    if (extraCols != null) {
      for (var extraCol in extraCols!) {
        operation.add(extraCol.sign);
        operation.add(extraCol.field);
      }
    }

    return operation;
  }
}
