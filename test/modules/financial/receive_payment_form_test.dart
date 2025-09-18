
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/payment_form_type.dart';
import 'package:jobprogress/common/enums/run_mode.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/common/services/payment/payment_form.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/connected_third_party_constants.dart';
import 'package:jobprogress/modules/job_financial/form/payment_forms/receive_payment_form/controller.dart';

void main() {
  RunModeService.setRunMode(RunMode.unitTesting);
  ReceivePaymentFormController controller = ReceivePaymentFormController();
  FinancialListingModel tempFinancialModel = FinancialListingModel();
  setUpAll(() {
    controller.initForm();
    controller.service = PaymentFormService(
      update: (){},
      type: PaymentFormType.receivePayment,
      financialDetails: tempFinancialModel,
      validateForm: (){}
    );
    Get.testMode = true;
  });

  test('ReceivePaymentFormController should be initialized with correct values', () {
    expect(controller.isSavingForm, false);
    expect(controller.validateFormOnDataChange, false);
    expect(controller.isLoading, false);
    expect(controller.jobId, null);
    expect(controller.invoiceId, null);
  });

  group('ReceivePaymentFormController@toggleIsSavingForm should toggle form\'s saving state', () {
    test('Form editing should be disabled', () {
      controller.toggleIsSavingForm();
      expect(controller.isSavingForm, true);
    });

    test('Form editing should be allowed', () {
      controller.toggleIsSavingForm();
      expect(controller.isSavingForm, false);
    });

  });

  group('ReceivePaymentFormController@toggleIsSavingForm should toggle form\'s saving state', () {
    test('Form editing should be disabled', () {
      controller.toggleIsSavingForm();
      expect(controller.isSavingForm, true);
    });

    test('Form editing should be allowed', () {
      controller.toggleIsSavingForm();
      expect(controller.isSavingForm, false);
    });

  });

  group('ReceivePaymentFormController should return correct messages ', () {
    test('When leap pay is connected but not set as default payment processor', () {
      ConnectedThirdPartyService.connectedThirdParty = {
        ConnectedThirdPartyConstants.leapPay: {'status': 'enabled'},
      };
      CompanySettingsService.companySettings = {
        CompanySettingConstants.defaultPaymentOption : {"value": "qbpay",}
      };
      (String, String) message = controller.service.getLeapPayPreferenceStatusMessage();

      expect(message.$1, 'leap_pay_is_not_set_as_default_payment_processor'.tr);
      expect(message.$2, 'reach_out_to_your_admin'.tr);
    });

    // test('When leap pay is connected but leap pay is not enabled for invoice', () {
    //   ConnectedThirdPartyService.connectedThirdParty = {
    //     ConnectedThirdPartyConstants.leapPay: {'status': 'enabled'},
    //   };
    //   CompanySettingsService.companySettings = {
    //     CompanySettingConstants.defaultPaymentOption : {"value": "leappay",}
    //   };
    //   controller.service.financialDetails?.isAcceptingLeapPay = false;
    //   (String, String) message = controller.service.getLeapPayPreferenceStatusMessage();
    //   print(message);
    //   print(ConnectedThirdPartyService.isLeapPayEnabled());
    //   print(controller.service.financialDetails?.isAcceptingLeapPay);
      
    //   expect(message.$1, 'leap_pay_is_not_set_as_default_payment_processor'.tr);
    //   expect(message.$2, 'reach_out_to_your_admin'.tr);
    // });

    test('When leap pay is not enabled', () {
      ConnectedThirdPartyService.connectedThirdParty = {
        ConnectedThirdPartyConstants.leapPay: {'status': 'paused'},
      };
      
      (String, String) message = controller.service.getLeapPayPreferenceStatusMessage();
      expect(message.$1, 'your_leap_pay_is_not_setup'.tr);
      expect(message.$2, 'reach_out_to_your_admin_if_needed'.tr);
    });

  });
}