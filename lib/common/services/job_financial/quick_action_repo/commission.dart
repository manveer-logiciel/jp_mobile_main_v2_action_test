import 'package:get/get.dart';
import 'package:jobprogress/common/repositories/job_financial.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class JobFinancalCommissionQuickActionRepo{
  static Future<void> cancelCommission({required int id}) async {
    await JobFinancialRepository().cancelCommission(id: id);
    Helper.showToastMessage('${'commission'.tr} ${'cancelled'.tr.toLowerCase()}');
  }
}