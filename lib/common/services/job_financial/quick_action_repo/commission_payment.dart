import 'package:get/get.dart';
import 'package:jobprogress/common/repositories/job_financial.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class JobFinancalCommissionPaymentQuickActionRepo{

  static Future<void> cancelCommissionPayment({required int id}) async {
    final cancelCommissionParams = <String, dynamic>{
      'id': id,
      'include[0]':'[commission]',
    };
    await JobFinancialRepository().cancelCommissionPayment(cancelCommissionParams);
    Helper.showToastMessage('${'commission'.tr.capitalize!} ${'cancelled'.tr.toLowerCase()}');
  }

  static Future<void> delete({required int id}) async {
    await JobFinancialRepository().deleteCommissionPayments(id: id);
    Helper.showToastMessage('${'commission'.tr.capitalize!} ${'deleted'.tr.toLowerCase()}');
  }
}