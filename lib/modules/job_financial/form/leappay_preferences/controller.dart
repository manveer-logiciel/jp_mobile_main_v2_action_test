import 'package:get/get.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/leap_pay_payment_method.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';

class LeapPayPreferencesController extends GetxController {

  bool acceptingLeapPay = true;
  bool isFeePassoverEnabled = false;
  bool isCardEnabled = false;
  bool isAchEnabled = false;

  bool isSaving = false;

  double amount = Get.arguments?[NavigationParams.changeOrderAmount] ?? 0.0;

  LeapPayPreferencesController() {
    setLeapPayPreferences();
  }

  void setLeapPayPreferences({bool? isAcceptingLeapPay, String? defaultPaymentMethod, bool? isFeePassoverEnabledForInvoice}) {
    acceptingLeapPay = isAcceptingLeapPay ?? true;
    dynamic setting = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.defaultLeapPayPaymentMethod);
    dynamic leapPayFeePassOverEnabledSetting = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.leapPayFeePassOverEnabled);
    defaultPaymentMethod ??= setting is bool || setting == null ? LeapPayPaymentMethod.both : setting;

    isCardEnabled = defaultPaymentMethod == LeapPayPaymentMethod.card || defaultPaymentMethod == LeapPayPaymentMethod.both;
    isAchEnabled = defaultPaymentMethod == LeapPayPaymentMethod.achOnly || defaultPaymentMethod == LeapPayPaymentMethod.both;

    if (!acceptingLeapPay) isCardEnabled = isAchEnabled = false;

    isFeePassoverEnabled = isFeePassoverEnabledForInvoice ?? Helper.isTrue(leapPayFeePassOverEnabledSetting);
  }

  void toggleLeapPayMethod(bool val) {
    acceptingLeapPay = val;
    isCardEnabled = isAchEnabled = val;
    update();
  }

  void toggleCard(bool val) {
    isCardEnabled = val;
    if (!val && !isAchEnabled) toggleACH(true);
    update();
  }

  void toggleACH(bool val) {
    isAchEnabled = val;
    if (!val && !isCardEnabled) toggleCard(true);
    update();
  }

  void toggleIsSaving(bool val) {
    isSaving = val;
    update();
  }

  void toggleLeapPayFeePassOver(bool val) {
    isFeePassoverEnabled = val;
    update();
  }

  String getPayMethodSubtitle(String method) {
    return Helper.getPayMethodSubtitle(method);
  }

  double calculateFee(String method, double amount) {
    return JobFinancialHelper.calculateLeapPayFee(method, amount);
  }

  String getEnabledPaymentMethod() {
    // In case LeapPay is not enabled return empty string
    if (!acceptingLeapPay) {
      return '';
    }

    if (isCardEnabled && isAchEnabled) {
      return LeapPayPaymentMethod.both;
    } else if(isCardEnabled) {
      return LeapPayPaymentMethod.card;
    } else if(isAchEnabled) {
      return LeapPayPaymentMethod.achOnly;
    }

    return "";
  }

  void onSavePreferences() {
    Get.back(
      result: this
    );
  }

}