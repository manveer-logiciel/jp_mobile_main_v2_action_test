
import 'package:jobprogress/common/extensions/String/index.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_detail_model.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_model.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';

class TemplateFormHtmlConstants {

  static String imageTemplateHeader = """
  <div class="dropzone-container"><div class="section insurance-html-images template-section"><h2 class="images-page-heading">Attached Images</h2><div class="import-image"></div></div></div>
  """;

  static String crossIcon = """
       <div class="pull-right image-actions image-actions-mobile">
        <a href="javascript:void(0);">
          <i class="fa fa-fw fa-trash image-actions-trash-icon"></i>
        </a>
      </div>
  """;

  static String imageContainer(String height, String title, String url) => """
      <div style="height: $height; overflow: hidden; text-align: center;">
        <div class="image-heading">$title</div>
        <img style="max-height: 100%; max-width: 100%; width: auto;" src="$url"/>
      </div>
  """;

  static String imageNote = """
    <textarea class="text-area-abc-form" placeholder="Enter your note here..." maxlength="280" style="width: 100%; height: 117px; overflow: hidden; font-size: 14px; line-height: 17px; padding: 0px; margin-top: 10px; margin-bottom: 5px; border: 0;"></textarea>
  """;

  static String? getSellingPriceSheet(JobModel? job, WorksheetModel? workSheet) {
    String table = "";
    List<WorksheetDetailModel?> workSheetData = workSheet?.details ?? [];

    // if job is available
    if (job != null) {
      String title = job.number ?? "";

      // trades
      if (job.trades?.isNotEmpty ?? false) {
        List<String?> trades = job.trades!.map((trade) => trade.name).toList();
        title += " - ${trades.join("/")}";
      }

      table += '<table style="width:100%;" border="1"><tr><th colspan="8">' + title + "</th></tr></table>";
    }

    table += '''<table border="1">'
            <thead>
            <tr> 
            <th width="5%" >S.No</th>
            <th width="10%" >Type</th>
            <th width="15%" >Name</th>
            <th width="20%" >Description</th>
            <th width="8%" >Qty</th>
            <th width="10%" >UOM</th>
            <th width="8%" >Price/Qty</th>
            <th width="8%" >Price</th>
            </tr>
            </thead>''';

    if (workSheetData.isEmpty) {
      table += '<tr><td colspan="8" align="center" > No Record Found </td></tr>';
    }

    double totalAmount = 0;
    double totalNoChargeAmount = 0;
    if (workSheetData.isNotEmpty) {
      for (int i = 0; i < workSheetData.length; i++) {
        final item = workSheetData[i];
        table += "<tr>";
        table += "<td>${i + 1}</td>";
        table += "<td>${item?.category?.name ?? ""}</td>";
        table += "<td>${item?.productName ?? ""}</td>";
        table += "<td>${item?.description ?? ""}</td>";
        table += "<td>${item?.quantity ?? ""}</td>";
        table += "<td>${item?.unit ?? ""}</td>";
        table += "<td>${item?.unitCost ?? ""}</td>";
        final total = "${(item?.unitCost ?? "0")} * ${(item?.quantity ?? "0")}".evaluate();
        table += "<td>${total.toStringAsFixed(2)}</td>";
        table += "</tr>";

        totalAmount += total;

        if (item?.category?.slug == "no_charge") {
          totalNoChargeAmount += total;
        }
      }
    }

    table += '<tr class="finance-table-footer"><td colspan="7" style="text-align: right"> Sub Total: </td><td>' +
            JobFinancialHelper.getCurrencyFormattedValue(value: totalAmount) +
            "</td></tr>";

    table += '<tr class="finance-table-footer"><td colspan="7" style="text-align: right"> No Charge Amount: </td><td>-' +
            JobFinancialHelper.getCurrencyFormattedValue(
                value: totalNoChargeAmount) +
            "</td></tr>";

    table += '<tr class="finance-table-footer"><td colspan="7" style="text-align: right"> Total: </td><td>' +
            JobFinancialHelper.getCurrencyFormattedValue(
                value: totalAmount - totalNoChargeAmount) +
            "</td></tr>";
    table += "</table>";

    if (job!.isMultiJob) {
      table = "";
    }

    String content = '<div class="dropzone-container"><div class="section insurance-html-images template-section"><h2 class="images-page-heading">Pricing</h2><div class="insurance-financial">' +
        table + "</div></div></div>";

    return content;
  }

}