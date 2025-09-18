import 'package:get/get.dart';
import 'package:jobprogress/common/repositories/job_financial.dart';
import 'package:jobprogress/common/services/download.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class JobFinancalChangeOrderQuickActionRepo{
 
  static Future<void> cancelChangeOrder({required int id}) async {
    await JobFinancialRepository().cancelChangeOrder(id: id);
    Helper.showToastMessage('change_order_cancelled'.tr);
  }
  
  static Future<void> printInvoice({required int invoiceId}) async {    
    String url = '${Urls.invoice}/$invoiceId'; 
    String fileName = '${FileHelper.getFileName(url.toString())}.pdf';
    await DownloadService.downloadFile(
      url.toString(),
      fileName,
      action:'print'
    );
  }
  
  static Future<void> openInvoice({required int invoiceId}) async {    
    String url = '${Urls.invoice}/$invoiceId'; 
    String fileName = '${FileHelper.getFileName(url.toString())}.pdf';
    await DownloadService.downloadFile(
      url.toString(),
      fileName,
      action:'open',
    );
  }
}
