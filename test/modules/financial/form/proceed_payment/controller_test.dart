import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/payment_form_type.dart';
import 'package:jobprogress/common/enums/run_mode.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/common/models/justifi/bank_account_details.dart';
import 'package:jobprogress/common/models/justifi/card_details.dart';
import 'package:jobprogress/common/models/justifi/sync_status.dart';
import 'package:jobprogress/common/models/justifi/tokenization.dart';
import 'package:jobprogress/common/services/payment/payment_form.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/core/constants/payment_method.dart';
import 'package:jobprogress/modules/job_financial/form/payment_forms/receive_payment_form/review_payment/controller.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';

void main() {

  final controller = ReviewPaymentDetailsController();

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;
    RunModeService.setRunMode(RunMode.unitTesting);
    controller.service = PaymentFormService(
      update: () {},
      validateForm: () {},
      type: PaymentFormType.receivePayment,
    );
  });

  test('ReviewPaymentDetailsController should be initialized with correct values', () {
    expect(controller.isLoading, false);
    expect(controller.syncStatusAfter, equals(5));
    expect(controller.syncStatusTotalInterval, equals(45));
    expect(controller.processPaymentTimer, isNull);
    expect(controller.paymentDetails, isNull);
    expect(controller.cancelToken, isNull);
    expect(controller.paymentToProcessDetails, isEmpty);
  });

  group(
      'ReviewPaymentDetailsController@isFeePassOverEnabledAndNotRecordPayment',
      () {
    test(
        'should return true when isFeePassOverEnabledForInvoice is true and isRecordPaymentForm is false',
        () {
      controller.isFeePassOverEnabledForInvoice = true;
      controller.service?.isRecordPaymentForm = false;
      expect(controller.isFeePassOverEnabledAndNotRecordPayment, isTrue);
    });

    group(' should return false when:', () {
      test(
          'isFeePassOverEnabledForInvoice is true but isRecordPaymentForm is true',
          () {
        controller.isFeePassOverEnabledForInvoice = true;
        controller.service?.isRecordPaymentForm = true;
        expect(controller.isFeePassOverEnabledAndNotRecordPayment, isFalse);
      });

      test(
          'isFeePassOverEnabledForInvoice is false and isRecordPaymentForm is false',
          () {
        controller.isFeePassOverEnabledForInvoice = false;
        controller.service?.isRecordPaymentForm = false;
        expect(controller.isFeePassOverEnabledAndNotRecordPayment, isFalse);
      });

      test(
          'isFeePassOverEnabledForInvoice is false and isRecordPaymentForm is true',
          () {
        controller.isFeePassOverEnabledForInvoice = false;
        controller.service?.isRecordPaymentForm = true;
        expect(controller.isFeePassOverEnabledAndNotRecordPayment, isFalse);
      });
    });
  });

  group("ReviewPaymentDetailsController@getLinkedInvoice should generate linked invoices text", () {
    test('When there is no invoice linked, a hyphen should be shown in place of name', () {
      expect(controller.getLinkedInvoice(), equals('-'));
    });

    test("If there is only one invoice linked, its name should be shown", () {
      controller.service?.apiInvoiceList = [
        FilesListingModel(id: '1', openBalance: '1234', title: 'Invoice # 1452'),
      ];
      controller.service?.filterInvoiceList = [
        JPMultiSelectModel(label: 'Invoice # 1452', id: '1', isSelect: true, additionData: '100'),
      ];
      expect(controller.getLinkedInvoice(), equals('Invoice # 1452'));
    });

    test("If there are multiple invoices linked, their names should be separated by commas", () {
      controller.service?.apiInvoiceList = [
        FilesListingModel(id: '1', openBalance: '1234', title: 'Invoice # 1452'),
        FilesListingModel(id: '2', openBalance: '4567', title: 'Invoice # 1234'),
      ];
      controller.service?.filterInvoiceList = [
        JPMultiSelectModel(label: 'Invoice # 1452', id: '1', isSelect: true, additionData: '100'),
        JPMultiSelectModel(label: 'Invoice # 1234', id: '2', isSelect: true, additionData: '200'),
      ];
      expect(controller.getLinkedInvoice(), equals('Invoice # 1452, Invoice # 1234'));
    });
  });

  group("ReviewPaymentDetailsController@getPaymentDetails should generate payment details", () {
    group("In case Record Payment is selected", () {
      test('Payment Type should be shown', () {
        controller.service?.isRecordPaymentForm = true;
        controller.service?.paymentMethodController.text = PaymentMethodId.cash;
        final params = controller.getPaymentDetails();
        expect(params.containsKey('payment_type'), isTrue);
        expect(params['payment_type'], PaymentMethodId.cash);
      });

      test('Date should be shown', () {
        controller.service?.isRecordPaymentForm = true;
        controller.service?.dateController.text = '2020-01-01';
        final params = controller.getPaymentDetails();
        expect(params.containsKey('date'), isTrue);
        expect(params['date'], '2020-01-01');
      });

      test('Reference Number should be shown', () {
        controller.service?.isRecordPaymentForm = true;
        controller.service?.checkRefernceNumberController.text = '1234';
        final params = controller.getPaymentDetails();
        expect(params.containsKey('reference#'), isTrue);
        expect(params['reference#'], '1234');
      });

      test('Hyphen should be shown in place of reference number, If its empty', () {
        controller.service?.isRecordPaymentForm = true;
        controller.service?.checkRefernceNumberController.text = '';
        final params = controller.getPaymentDetails();
        expect(params.containsKey('reference#'), isTrue);
        expect(params['reference#'], '-');
      });
    });

    group("In case of Process Payment", () {
      group("When Payment is processed via Card", () {
        setUp(() {
          controller.service?.isRecordPaymentForm = false;
          controller.service?.isCardForm = true;
          controller.service?.tokenizationDetails = JustifiTokenizationModel(
            cardDetails: JustifiCardDetails(
              acctLastFour: '1234',
            )
          );
          controller.service?.emailReceiptController.text = 'JbJpj@example.com';
        });

        test('Card Number should be shown', () {
          final params = controller.getPaymentDetails();
          expect(params.containsKey('card_number'), isTrue);
          expect(params['card_number'], '************1234');
        });

        test('Email Receipt should be shown', () {
          final params = controller.getPaymentDetails();
          expect(params.containsKey('email_receipt_to'), isTrue);
          expect(params['email_receipt_to'], 'JbJpj@example.com');
        });
      });

      group("When Payment is processed via Bank", () {
        setUp(() {
          controller.service?.isRecordPaymentForm = false;
          controller.service?.isCardForm = false;
          controller.service?.tokenizationDetails = JustifiTokenizationModel(
            bankAccountDetails: JustifiBankAccountDetails(
              acctLastFour: '1234',
            )
          );
          controller.service?.accountOwnerController.text = 'abc';
          controller.service?.emailReceiptController.text = 'JbJpj@example.com';
        });

        test('Account Number should be shown', () {
          final params = controller.getPaymentDetails();
          expect(params.containsKey('account_number'), isTrue);
          expect(params['account_number'], '************1234');
        });

        test('Account Type should be shown', () {
          final params = controller.getPaymentDetails();
          expect(params.containsKey('account_type'), isTrue);
          expect(params['account_type'], 'checking'.tr);
        });

        test('Account Owner Name should be shown', () {
          final params = controller.getPaymentDetails();
          expect(params.containsKey('account_owner'), isTrue);
          expect(params['account_owner'], 'abc');
        });

        test('Email Receipt should be shown', () {
          final params = controller.getPaymentDetails();
          expect(params.containsKey('email_receipt_to'), isTrue);
          expect(params['email_receipt_to'], 'JbJpj@example.com');
        });

      });
    });
  });

  group("ReviewPaymentDetailsController@paymentStatusToMsg should give correct message as per peayment status", () {
    test('When payment status is pending and user navigates back', () {
      final msg = controller.paymentStatusToMsg(isPending: true);
      expect(msg, 'payment_process_pending_message'.tr);
    });

    test("When payment status is processed successfully", () {
      final msg = controller.paymentStatusToMsg(status: PaymentStatusSyncModel(
        status: 'succeeded'
      ));
      expect(msg, 'payment_successful'.tr);
    });

    test("When payment status is failed without reason, default message should be shown", () {
      final msg = controller.paymentStatusToMsg(status: PaymentStatusSyncModel(
        status: 'failed'
      ));
      expect(msg, 'payment_failed_message'.tr);
    });

    test("When payment status is failed with reason, failed reason should be shown", () {
      final msg = controller.paymentStatusToMsg(status: PaymentStatusSyncModel(
        status: 'failed',
        failedReason: 'failed_reason'
      ));
      expect(msg, 'failed_reason');
    });

    group("ReviewPaymentDetailsController@toggleIsLoading should enable disable review loading", () {
      test("User interaction should be blocked", () {
        controller.toggleIsLoading(true);
        expect(controller.isLoading, isTrue);
      });

      test("User interaction should be enabled", () {
        controller.toggleIsLoading(false);
        expect(controller.isLoading, isFalse);
      });
    });

    group("ReviewPaymentDetailsController@onWillPop should allow user to exit review page conditionally", () {
      test("User should not be allowed to navigate back when payment is processing", () async {
        controller.paymentDetails = FinancialListingModel(id: -1);
        controller.startPaymentProcessing();
        final response = await controller.onWillPop();
        expect(response, isFalse);
      });

      test("User should not be allowed to navigate back when payment status is syncing", () async {
        controller.paymentDetails = FinancialListingModel(id: -1);
        controller.startPaymentProcessing();
        final response = await controller.onWillPop();
        expect(response, isFalse);
        controller.stopProcessingPayment();
      });
    });
  });

  group("ReviewPaymentDetailsController@isSyncingStatus should decide when to show processing loader", () {
    test("Loader should not be shown status is not syncing", () {
      expect(controller.isSyncingStatus, isFalse);
    });

    test("Loader should be shown status is syncing", () {
      controller.paymentDetails = FinancialListingModel(
        id: 1
      );
      controller.startPaymentProcessing();
      expect(controller.isSyncingStatus, isTrue);
      controller.stopProcessingPayment();
    });
  });

  test("ReviewPaymentDetailsController@stopProcessingPayment should stop payment status syncing", () {
    controller.paymentDetails = FinancialListingModel(
      id: 1
    );
    controller.startPaymentProcessing();
    controller.stopProcessingPayment();
    expect(controller.isSyncingStatus, isFalse);
    expect(controller.processPaymentTimer?.isActive, isFalse);
    expect(controller.cancelToken, isNull);
  });
}