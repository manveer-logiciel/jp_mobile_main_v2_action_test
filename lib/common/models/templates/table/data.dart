import 'package:get/get.dart';
import 'package:jobprogress/common/enums/templates.dart';
import 'package:jobprogress/common/models/templates/table/style.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'cell.dart';
import 'compute/column.dart';
import 'row.dart';
import 'rules.dart';

class TemplateFormTableModel {

  late List<TemplateTableRowModel> head;
  late List<TemplateTableRowModel> body;
  late List<TemplateTableRowModel> foot;
  TemplateTableDependentCol? dependentCols;
  late List<JPSingleSelectModel> columns;
  int? hiddenColumn;
  Map<int, double>? widths;

  /// [other] used to access additional data coming from table details
  /// eg. Compute Columns, Extra References etc.
  Map<String, dynamic>? other;

  /// [computeCols] hold the data for Compute Column computations coming
  /// directly from table reference
  TemplateTableComputeCol? computeCols;

  TemplateFormTableModel({
    this.head = const [],
    this.body = const [],
    this.foot = const [],
    this.columns = const [],
  });

  TemplateFormTableModel.fromJson(Map<String, dynamic> json) {

    head = [];
    body = [];
    foot = [];
    columns = [];

    dependentCols = TemplateTableDependentCol.fromJson(json['other']?['rule']?['dependentCol']);

    json['head']?.forEach((dynamic data) {
      head.add(TemplateTableRowModel.fromJson(data, type: TableCellType.head));
    });

    json['body']?.forEach((dynamic data) {
      body.add(TemplateTableRowModel.fromJson(data, type: TableCellType.body, dependentCols: dependentCols));
    });

    json['foot']?.forEach((dynamic data) {
      foot.add(TemplateTableRowModel.fromJson(data, type: TableCellType.foot));
    });

    if (head.isNotEmpty) {
      final cells = head.first.tds ?? [];
      for (int i = 0; i < cells.length; i++) {
        columns.add(JPSingleSelectModel(label: cells[i].text ?? "", id: i.toString()));
      }
      columns.insert(0, JPSingleSelectModel(label: "none".tr, id: 'null'));
    }

    if (body.isNotEmpty) {
      hiddenColumn = json['body']?[0]?['options']?['hideColumnText']?[0];
    }

    widths = getColumnWidths();
    other = json['other'] is Map ? json['other'] : null;

    // Variables help in performing conditional checks
    final tempComputeCol = other?['computeCols'];
    final exCols = other?['exCols'];

    // Compute columns should be set only, Compute columns is list and that list has valid datadata
    if (tempComputeCol is List && tempComputeCol.isNotEmpty && tempComputeCol[0] is Map) {
      computeCols = TemplateTableComputeCol.fromJson(json['other']?['computeCols']?[0]);
      // Parsing Extra columns so to perform calculations
      if (exCols is List<dynamic>) {
        computeCols?.setExtraCols(exCols);
      }
    }
  }

  Map<int, double> getColumnWidths() {
    Map<int, double> widths = {};

    final tableCells = head.first.tds ?? [];

    for (int i=0; i<tableCells.length; i++) {
      final width = tableCells[i].width ?? 0;
      widths.putIfAbsent(i, () => width);
    }

    return widths;
  }

  TemplateTableRowModel getEmptyRow() {
    final defaultAmount = JobFinancialHelper.getCurrencyFormattedValue(value: "");
      return TemplateTableRowModel(
        id: "",
        tds: List.generate(
            head.first.tds?.length ?? 0, (index) {
              return TemplateTableCellModel(
                text: computeCols?.compute == index ? defaultAmount : "",
              );
        })
      );
  }

  String getHeadHtml() {

    String ths = "";

    head.first.tds?.forEach((td) {
      final TemplateTableStyleModel? style = td.style;
      if(td.style != null) {
        final equalDistributedWidth = ((Get.width/ (head.first.tds?.length ?? 1)) / Get.width) * 100;
        final tempWidth = Helper.isValueNullOrEmpty(style?.width) || style?.width == 'auto' ? '$equalDistributedWidth%' : style?.width;
        String th = """<th style =
        'width: $tempWidth;
         text-align: ${style?.textAlignString};
         vertical-align: ${style?.verticalAlignString};'>${td.controller.text}</th>""";
        ths = ths + th;
      }
    });

    String html = """<tr> $ths </tr>""";

    return """<thead>$html</thead>""";
  }

  String getBodyHtml() {

    String trString = "";

    for (TemplateTableRowModel tr in body) {

      String tdString = "";
      String depColValue = "";

      bool isYesNoToggleBtwThreeCols = dependentCols?.type == 3
          && dependentCols?.valCol != null
          && dependentCols?.depCol != null;

      bool isYesNoToggleBtwTwoCols = dependentCols?.type == 2
          && dependentCols?.depCol != null;

      // updating row options dep price
      if (isYesNoToggleBtwThreeCols) {
        depColValue = tr.tds?[dependentCols!.valCol!].formattedText ?? "";
        tr.tds?[dependentCols!.depCol!].text = depColValue;
        tr.options?.depPrice = depColValue;
      }

      if (isYesNoToggleBtwTwoCols) {
        depColValue = tr.tds?[dependentCols!.depCol!].formattedText ?? "";
        tr.options?.depPrice = depColValue;
      }

      for (int i = 0 ; i < (tr.tds ?? []).length; i++) {

        TemplateTableCellModel td = tr.tds![i];

        tdString += """
          <td class='cell-with-dropdown' ref-db='${td.refDb ?? ""}' ref-number='${td.isNumber ?? "false"}' style='${td.style.toString()}'>
        """.trim();

        String displayNone = hiddenColumn == i ? "style='display:none;'" : "";

        if (td.dropdown?.isDropdown != null) {
          tdString += """<span class='cell-text'>${td.controller.text}</span>""".trim();
          tdString += """
              <div ref-dd='${td.dropdown.toString()}' class='cell-dd' $displayNone>${td.dropdown?.selectedText ?? "select".tr}</div>
          """.trim();
        } else if (dependentCols?.type == 3 && dependentCols?.depCol == i) {
          tdString += "<span class='cell-text' $displayNone>$depColValue</span>".trim();
        } else {
          tdString += "<span class='cell-text' $displayNone>${td.formattedText}</span>".trim();
        }
        tdString += """</td>""";
      }

      tr.options?.hideColumnText = hiddenColumn;

      String options = tr.options?.toString() ?? "{}";
      trString += """<tr options='$options' class=''>$tdString</tr>""";
    }

    return """<tbody>$trString</tbody>""";
  }

  String getFooterHtml() {
    String trString = "";

    for (TemplateTableRowModel tr in foot) {

      String tdString = "";

      tr.tds?.forEach((td) {
        tdString += """
          <td style='${td.style.toString()}' ref-obj='${td.obj.toString()}' class=''>${td.controller.text}</td>
        """.trim();
        tdString += """</td>""";
      });
      trString += """<tr options='{}' class=''>$tdString</tr>""";
    }

    return """<tfoot>$trString</tfoot>""";
  }

}
