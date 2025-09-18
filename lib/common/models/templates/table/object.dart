import 'package:jobprogress/core/constants/regex_expression.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'operation/main_cell.dart';
import 'operation/multi_cell.dart';
import 'operation/multiplication.dart';

class TemplateTableCellObjectModel {

  bool? focus;
  String? text;
  String? dbElement;
  String? operation;
  String? expression;
  int? field;
  int? cell;
  TemplateOperationCellModel? mainCell;
  TemplateMultiplicationModel? multiplication;
  List<TemplateOperationCellModel>? subs;
  List<TemplateOperationCellModel>? additions;
  List<TemplateMultiCellModel>? multiCells;
  List<Map<String, dynamic>>? extraCols;
  Map<String, dynamic>? first;

  TemplateTableCellObjectModel({
    this.text,
    this.focus,
    this.dbElement,
    this.operation,
    this.field,
    this.subs,
    this.additions,
    this.multiplication,
  });

  TemplateTableCellObjectModel.fromJson(Map<String, dynamic>? json) {

    if (json == null) return;

    text = json['text']?.toString();
    dbElement = json['dbElement'];
    operation = json['operation'];
    focus = (operation == 'none')
        || (json['focus'] ?? true)
        || !(text?.contains(JobFinancialHelper.getCurrencySymbol()) ?? true);

    subs = <TemplateOperationCellModel>[];
    json['subs']?.forEach((dynamic sub) {
      subs!.add(TemplateOperationCellModel.fromJson(sub));
    });

    cell = json['cell'];

    if (json['field'] is Map) {
      mainCell = TemplateOperationCellModel.fromJson(json['field']);
    } else {
      field = json['field'];
    }

    additions = <TemplateOperationCellModel>[];
    json['additions']?.forEach((dynamic addition) {
      additions!.add(TemplateOperationCellModel.fromJson(addition));
    });

    multiplication = TemplateMultiplicationModel.fromJson(json['mul']);

    first = json['first'];
    extraCols = <Map<String, dynamic>>[];
    json['extraCols']?.forEach((dynamic extraCol) {
      extraCols?.add(extraCol);
    });

    expression = json['resultText'];
    parseExpression(expression);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['focus'] = focus;
    data['dbElement'] = dbElement;
    data['operation'] = operation;
    data['field'] = field;

    if (first != null) data['first'] = first;
    if (extraCols != null) data['extraCols'] = extraCols;
    if (expression != null) data['resultText'] = expression;

    if (cell != null) data['cell'] = cell;
    if (mainCell != null) data['field'] = mainCell?.toJson();

    if (subs != null) {
      data['subs'] = subs!.map((sub) => sub.toJson()).toList();
    }

    if (additions != null) {
      data['additions'] = additions!.map((addition) => addition.toJson()).toList();
    }

    if (multiplication != null) data['mul'] = multiplication?.toJson();

    return data;
  }

  @override
  String toString() {
    Map<String, dynamic> json = toJson();
    return Helper.encodeToHTMLString(json);
  }

  void parseExpression(String? expression) {

    if (expression == null) return;

    RegExp exp = RegExp(RegexExpression.rowColumnToIndex);
    Iterable<Match> matches = exp.allMatches(expression);
    multiCells = <TemplateMultiCellModel>[];

    for (Match match in matches) {
      int rowIndex = int.parse(match.group(1) ?? "0") - 1;
      int cellIndex = int.parse(match.group(2) ?? "0") - 1;
      String? operation = match.group(3);

      multiCells?.add(
          TemplateMultiCellModel(
              operation: operation,
              row: rowIndex,
              col: cellIndex,
          ),
      );
    }
  }
}
