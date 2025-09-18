import 'package:get/get.dart';
import 'package:jobprogress/common/repositories/job_financial.dart';
import 'package:jobprogress/core/utils/helpers.dart';



class JobFinancalCreditsQuickActionRepo{
 
  static Future<void> cancelCredit({required int id}) async{
    await JobFinancialRepository().cancelCredit(id: id);
    Helper.showToastMessage('job_credit_cancelled'.tr);
  }
 
}
