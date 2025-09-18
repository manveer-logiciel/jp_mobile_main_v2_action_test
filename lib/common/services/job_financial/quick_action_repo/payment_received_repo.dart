import 'package:get/get.dart';
import 'package:jobprogress/common/repositories/job_financial.dart';
import 'package:jobprogress/common/services/download.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class JobFinancialPaymentReceivedQuickActionRepo{
  
  static Future<void> cancelPaymentReceived({required int id, required int jobId, required String val}) async { 
    final cancelPaymentReceivedParams = <String, dynamic>{
      'id': id,
      'job_id': jobId,
      'note': val,
    };
    await JobFinancialRepository().cancelPayment(cancelPaymentReceivedParams);
    Helper.showToastMessage('payment_cancelled'.tr);    
  }
  
  static Future<void> printPaymentDepositSlip({required int modelId}) async {    
    String url = '${Urls.paymentSlip}/$modelId'; 
    String fileName = '${FileHelper.getFileName(url.toString())}.pdf';
    await DownloadService.downloadFile(
      url.toString(), fileName,
      action:'print',
    );
  }
  
  static Future<void> viewPaymentDepositFileSlip({required int modalId}) async {    
    String url ='${Urls.paymentSlip}/$modalId'; 
    String fileName = '${FileHelper.getFileName(url.toString())}.pdf';
    await DownloadService.downloadFile(
      url.toString(), fileName,
      action:'open',
    );
  }
}