import 'dart:convert';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/common/services/download.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
class JobFinancialAccountsPayableQuickActionRepo{
  
  static Future<void> print({required String? url}) async {    
    if(url != null) {
      String fileName = '${FileHelper.getFileName(url.toString())}.pdf';
      await DownloadService.downloadFile(
      url.toString(), fileName,
      action:'print',
      );
    } else {
      Helper.showToastMessage('something_went_wrong_please_try_again'.tr);
    }
  }
  
  static Future<void> view({String? url}) async {    
    if(url != null) {
    String fileName = '${FileHelper.getFileName(url.toString())}.pdf';
    await DownloadService.downloadFile(
      url.toString(), fileName,
      action:'open',
    );
    } else {
      Helper.showToastMessage('something_went_wrong_please_try_again'.tr);
    }
  }

  static Future<void> delete({required int id}) async {
    try {
      String url = '${Urls.vendor}/$id';
      final response = await dio.delete(url);
      final jsonData = json.decode(response.toString());
      return jsonData;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
    
}
