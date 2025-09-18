import 'package:get/get.dart';
import 'package:jobprogress/common/repositories/job_financial.dart';
import 'package:jobprogress/common/services/download.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class JobFinancialRefundsQuickActionRepo{
  
  static Future<void> cancelRefund({required int id ,required int jobId,required String val}) async { 
    final cancelPaymentReceivedParams = <String, dynamic>{
      'id': id,
      'cancel_note': val,
    };
    await JobFinancialRepository().cancelRefund(cancelPaymentReceivedParams, id);
    
    Helper.showToastMessage('refund_cancelled'.tr);    
  }
  
  static Future<void> printRefund({required String url}) async  {     
    String fileName = '${FileHelper.getFileName(url.toString())}.pdf';
    await DownloadService.downloadFile(
      url.toString(), fileName,
      action:'print',
    );
  }
  
  static Future<void> viewRefund({required String url}) async {     
    String fileName = '${FileHelper.getFileName(url.toString())}.pdf';
    await DownloadService.downloadFile(
      url.toString(), fileName,
      action:'open',
    );
  }
}