import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/payment_form_type.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/email.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/forms/payment/method.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/common/services/payment/payment_form.dart';
import 'package:jobprogress/core/config/app_env.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/connected_third_party_constants.dart';
import 'package:jobprogress/core/constants/leap_pay_payment_method.dart';
import 'package:jobprogress/core/constants/payment_method.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

void main() {

  CustomerModel customer = CustomerModel(unappliedAmount: 129);
  
  JobModel job = JobModel(id: 123, customerId: 123, customer: customer);

   List<MethodModel>? apiMethodList = [
    MethodModel(id: 1, label: 'Cash', method: 'cash'),
    MethodModel(id: 2, label: 'Credit Card', method: 'cc'),
    MethodModel(id: 3, label: 'Paypal', method: 'pypl'),
    MethodModel(id: 4, label: 'phonepay', method: 'phpy'),
   ];

   List<FilesListingModel> apiInvoiceList = [
    FilesListingModel(id: '1', openBalance: '1234',name: 'Invoice # 1452'),
    FilesListingModel(id: '2', openBalance: '4567',name: 'Invoice # 1234'),
    FilesListingModel(id: '3', openBalance: '8910',name: 'Invoice # 2541'),
    FilesListingModel(id: '4', openBalance: '1435',name: 'Invoice # 1225'),
   ];

   List<JPMultiSelectModel> selectedInvoices = [
     JPMultiSelectModel(label: 'Invoice # 1452', id: '1', isSelect: true, additionData: '100'),
     JPMultiSelectModel(label: 'Invoice # 1234', id: '2', isSelect: true, additionData: '200'),
   ];
  
  PaymentFormService service = PaymentFormService(
    validateForm: (){ }, 
    update: () {}, // method used to validate form using form key with is ui based, so can be passes empty for unit testing
    type: PaymentFormType.receivePayment,
    jobId: 12
  );

  PaymentFormService serviceWithInvoiceId = PaymentFormService(
    invoiceId: 3,
    validateForm: () { }, 
    update: () {  }, // method used to validate form using form key with is ui based, so can be passes empty for unit testing 
    type: PaymentFormType.receivePayment
  );
  
  PaymentFormService applyPaymentService = PaymentFormService(
    validateForm: () { }, 
    type: PaymentFormType.applyPayment, 
    update: () {  } // method used to validate form using form key with is ui based, so can be passes empty for unit testing
  );

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;
    Get.locale = const Locale('en', 'US');
  });

  void addInvoices() {
    selectedInvoices.addAll([
      JPMultiSelectModel(label: 'Invoice # 1452', id: '1', isSelect: true, additionData: '100'),
      JPMultiSelectModel(label: 'Invoice # 1234', id: '2', isSelect: true, additionData: '200'),
    ]);
  }
   
  group('PaymentFormService should be initialized with correct data', () {
    test('Form fields should be initialized with correct values', () {
      expect(service.dateController.text, "");
      expect(service.paymentAmountController.text, "");
      expect(service.paymentMethodController.text, "");
      expect(service.checkRefernceNumberController.text, "");    
    });

    test('Form data helper lists should be filled with correct data', () {
      expect(service.paymentMethodList.length, 0);
      expect(service.filterInvoiceList.length, 0);
      expect(service.invoiceList.length, 0);
      expect(service.invoiceFieldControllerList.length, 0);
      expect(service.invoiceList.length, 0);
    });

    test('Form data helper values should be filled with correct data', () {
      expect(service.pendingInvoiceAmount, 0);
      expect(service.invoicesAmount, 0);
      expect(service.unApplidAmount, 0);
      expect(service.invoiceId, null);
      expect(service.jobId, 12);
      expect(service.job, null);
      expect(service.showLinkInvoiceField, true);
      expect(service.selectedPaymentMethodId, null);
    });
  });

  test('PaymentFormService@setPaymentMethodList should add data in paymentMethodList from apiMethodList', () {
    service.apiMethodList = apiMethodList;
    service.setPaymentMethodList();
    expect(service.paymentMethodList.length, 4);
  });

  test('PaymentFormService@setInvoiceList should add data in invoiceList from apiInvoiceList', () {
    serviceWithInvoiceId.apiInvoiceList = apiInvoiceList;
    serviceWithInvoiceId.setInvoiceList(getLocale:'en_US');
    expect(serviceWithInvoiceId.invoiceList.length, 4 );
  });

  test('PaymentFormService@initDefaultValue should set correct Data in Form when invoice id is null', () {
    service.initDefaultValue(tempDate: '22/11/1998');
    expect(service.paymentMethodController.text, 'Cash');
    expect(service.selectedPaymentMethodId, 'cash');
    expect(service.filterInvoiceList.length, 0);
  });

  test('PaymentFormService@initDefaultValue should set correct Data in Form when invoice Id has value', () {
    serviceWithInvoiceId.apiMethodList = apiMethodList;
    serviceWithInvoiceId.setPaymentMethodList();
    serviceWithInvoiceId.initDefaultValue(tempDate: '22/11/1998');
    
    expect(serviceWithInvoiceId.paymentMethodController.text, 'Cash');
    expect(serviceWithInvoiceId.selectedPaymentMethodId, 'cash');
    expect(serviceWithInvoiceId.filterInvoiceList.length, 1);
  });

  group('PaymentFormService@calculatePendingInvoiceAmount set invoices and pending invoice amount', () {
    group("In case there are no invoices", () {
      setUp(() {
        service.filterInvoiceList.clear();
      });

      test("Invoices amount should be set to 0", () {
        service.calculatePendingInvoiceAmount();
        expect(service.invoicesAmount, 0);
      });

      test("Pending invoice amount should be 0", () {
        service.calculatePendingInvoiceAmount();
        expect(service.pendingInvoiceAmount, 0);
      });
    });

    group("In case of invoices", () {
      setUp(() {
        service.filterInvoiceList.clear();
        service.filterInvoiceList.addAll(selectedInvoices);
      });

      test('Invoices Amount should be the sum of all invoices', () {
        service.calculatePendingInvoiceAmount();
        expect(service.invoicesAmount, 300);
      });

      test('Pending invoice amount should be 0 if whole invoice amount is selected to be paid', () {
        service.isInvoiceAmount = true;
        service.calculatePendingInvoiceAmount();
        expect(service.pendingInvoiceAmount, 0);
      });

      test('Pending invoice amount should be the difference between payment amount and invoices amount', () {
        service.isInvoiceAmount = false;
        service.calculatePendingInvoiceAmount();
        expect(service.pendingInvoiceAmount, -300);
      });

      test('Pending invoice amount should not be greater than 0', () {
        service.isInvoiceAmount = false;
        service.paymentAmountController.text = '5000';
        service.calculatePendingInvoiceAmount();
        expect(service.pendingInvoiceAmount, 0);
      });
    });
  });

  group('PaymentFormService@calculateTotalInBottomSheet different cases when isSelect is true or false', () {
    test('Should return remain credit amount after add isSelect true value from sum of selected invoice when isSelect true',() {
      serviceWithInvoiceId.calculateTotalInBottomSheet(isSelect: true, index: 2);
      expect(serviceWithInvoiceId.pendingInvoiceAmount, -8910.0);
    });
    test('Should return remain credit amount after subtract isSelect false value from sum of selected Invoice when isSelect false',() {
      serviceWithInvoiceId.calculateTotalInBottomSheet(isSelect: false, index: 2);
      expect(serviceWithInvoiceId.pendingInvoiceAmount, -0.0);
    });
  });

  group('PaymentFormService@calculateTotalInBottomSheet different cases when selectAll is true or false', () {
    test('Should return remain credit amount after sum of all invoices when selectAll true',() {
      serviceWithInvoiceId.calculateTotalInBottomSheet(isSelectAll: true, index: 2);
      expect(serviceWithInvoiceId.pendingInvoiceAmount, -16146.0);
    });
    test('Should return  credit amount when selectAll false',() {
      serviceWithInvoiceId.calculateTotalInBottomSheet(isSelectAll: false, index: 2);
      expect(serviceWithInvoiceId.pendingInvoiceAmount, 0);
    });
  });

  test('PaymentFormService@removeInvoice should remove invoice  from  pass index in filterInvoice List', () {
    serviceWithInvoiceId.filterInvoiceList = [JPMultiSelectModel(label: 'Invoice', id: '3', isSelect: true)];
    serviceWithInvoiceId.removeInvoice(0);
    expect(serviceWithInvoiceId.filterInvoiceList.length, 0);
  });
  
  group('PaymentFormService@validateAmount should validate amount', () {
    group("In case of record payment", () {
      setUp(() {
        service.isRecordPaymentForm = true;
      });

      test('Validation should fail when amount is empty', () {
        service.paymentAmountController.text = "";
        final val = service.validateAmount(service.paymentAmountController.text);
        expect(val, 'please_enter_valid_amount'.tr.capitalizeFirst);
      });

      test('Validation should fail when amount is zero', () {
        service.paymentAmountController.text = "0";
        final val = service.validateAmount(service.paymentAmountController.text);
        expect(val, 'please_enter_valid_amount'.tr.capitalizeFirst);
      });

      test('Validation should pass when amount had valid value', () {
        service.paymentAmountController.text = "124";
        final val = service.validateAmount(service.paymentAmountController.text);
        expect(val, null);
      });
    });

    group("In case of process payment", () {
      setUp(() {
        service.isRecordPaymentForm = false;
      });

      group("In case invoices are linked", () {
        setUp(() {
          service.filterInvoiceList.addAll(selectedInvoices);
        });

        test('Validation should fail when amount is greater than invoice amount', () {
          service.invoicesAmount = 50;
          final val = service.validateAmount('60');
          expect(val, 'payment_cant_be_greater_than_invoices_amount'.tr.capitalizeFirst);
        });

        test('Validation should pass when amount is within invoice amount', () {
          service.invoicesAmount = 50;
          final val = service.validateAmount('40');
          expect(val, null);
        });

        tearDown(() {
          service.filterInvoiceList.clear();
        });
      });

      group("In case invoices are not linked", () {
        test('Validation should fail when amount is empty', () {
          service.paymentAmountController.text = "";
          final val = service.validateAmount(service.paymentAmountController.text);
          expect(val, 'please_enter_valid_amount'.tr.capitalizeFirst);
        });

        test('Validation should fail when amount is less than 0.50', () {
          service.paymentAmountController.text = "0.49";
          final val = service.validateAmount(service.paymentAmountController.text);
          expect(val, 'minimum_amount_should_be_50'.tr.capitalizeFirst);
        });

        test('Validation should fail when amount is greater than 999999.99', () {
          service.paymentAmountController.text = "1000000";
          final val = service.validateAmount(service.paymentAmountController.text);
          expect(val, 'maximum_payment_cant_be_greater_than_999999'.tr.capitalizeFirst);
        });

        test('Validation should pass when amount is greater 0.50', () {
          service.paymentAmountController.text = "0.51";
          final val = service.validateAmount(service.paymentAmountController.text);
          expect(val, isNull);
        });

        test('Validation should pass when amount is equal to 999999.99', () {
          service.paymentAmountController.text = "999999.99";
          final val = service.validateAmount(service.paymentAmountController.text);
          expect(val, isNull);
        });

        test('Validation should pass when amount had valid value', () {
          service.paymentAmountController.text = "124";
          final val = service.validateAmount(service.paymentAmountController.text);
          expect(val, null);
        });
      });
    });
  });

  group('PaymentFormService@validateCheckReferenceNumber should validate checkRefernceNumber', () {
    group("Reference number should be optional in case of 'check' payment method", () {
      test('Validation should pass when Reference Number is empty', () {
        service.checkRefernceNumberController.text = "";
        final val = service.validateCheckReferenceNumber(service.checkRefernceNumberController.text);
        expect(val, isNull);
      });

      test('Validation should pass when Reference Number contains empty spaces', () {
        service.checkRefernceNumberController.text = "  ";
        final val = service.validateCheckReferenceNumber(service.checkRefernceNumberController.text);
        expect(val, isNull);
      });

      test('Validation should pass when Reference Number is not empty', () {
        service.checkRefernceNumberController.text = "1234";
        final val = service.validateCheckReferenceNumber(service.checkRefernceNumberController.text);
        expect(val, isNull);
      });
    });

    group('Reference number should be required for `Check` payment method', () {
      setUp(() {
        service.selectedPaymentMethodId = PaymentMethodId.check;
      });

      test('Validation should fail when Reference Number is empty', () {
        service.checkRefernceNumberController.text = "";
        final val = service.validateCheckReferenceNumber(service.checkRefernceNumberController.text);
        expect(val, 'please_enter_reference_number'.tr.capitalizeFirst);
      });

      test('Validation should fail when Reference Number contains empty spaces', () {
        service.checkRefernceNumberController.text = "  ";
        final val = service.validateCheckReferenceNumber(service.checkRefernceNumberController.text);
        expect(val, 'please_enter_reference_number'.tr.capitalizeFirst);
      });

      test('Validation should pass when Reference Number is not empty', () {
        service.checkRefernceNumberController.text = "1234";
        final val = service.validateCheckReferenceNumber(service.checkRefernceNumberController.text);
        expect(val, isNull);
      });
    });
  });

  test('PaymentFormService@initApplyPaymentInputField should create field list correctly', () {
    applyPaymentService.apiInvoiceList = apiInvoiceList;
    applyPaymentService.job = job;
    applyPaymentService.initApplyPaymentInputField();
    expect(applyPaymentService.invoiceFieldControllerList.length, 4);
  });

  group('PaymentFormService@calculateUnappliedAmount data calculation with different textfield value', () { 
    test('Should return unAppliedAmount when text field had no value', () {
      applyPaymentService.calculateUnappliedAmount();
      expect(applyPaymentService.calculatedUnappliedAmount, 129.0);
    });
    test('Should return 9.0 when text field had value 120', () {
      applyPaymentService.invoiceFieldControllerList[0].text = '120';
      applyPaymentService.calculateUnappliedAmount();
      expect(applyPaymentService.calculatedUnappliedAmount, 9.0);
    });
  });

  test('PaymentFormService@setParamInvoiceList should set data  in paramInvoiceList', () {
  applyPaymentService.setParamInvoiceList();
  expect(applyPaymentService.paramInvoiceList.length, 1);
 });

  group('PaymentFormService@validateApplyPaymentFormAmounts should validate amount values', () {
    applyPaymentService.apiInvoiceList = apiInvoiceList;
    test('Validation should fail when value is greater than balance due', () {
      final val = applyPaymentService.validateApplyPaymentFormAmounts('1235',0);
      expect(val, 'amount_should_not_be_greater_than_balance_due'.tr.capitalizeFirst);
    });
    test('Validation should pass when value is less than balance due', () {
      final val = applyPaymentService.validateApplyPaymentFormAmounts('141',0);
      expect(val, null);
    });
  });
  
  group('PaymentFormService@onInvoicesSelected should select invoices and set data accordingly', () {
    test("Invoices should be selected correctly", () {
      service.onInvoicesSelected(selectedInvoices);
      expect(service.filterInvoiceList.length, selectedInvoices.length);
    });

    test("Invoices amount should be calculated correctly", () {
      service.filterInvoiceList.clear();
      service.paymentAmountController.text = '';
      service.onInvoicesSelected(selectedInvoices);
      expect(service.invoicesAmount, 300);
      expect(service.pendingInvoiceAmount, 0);
    });

    test("Payment amount should switch to invoices amount, If custom amount is not filled", () {
      service.paymentAmountController.text = '';
      service.onInvoicesSelected(selectedInvoices);
      expect(service.isInvoiceAmount, isTrue);
      expect(service.getPayableAmount(), service.invoicesAmount.toString());
    });

    test("Payment amount should not switch to invoices amount, If custom amount is filled", () {
      service.paymentAmountController.text = '5000';
      service.onInvoicesSelected(selectedInvoices);
      expect(service.isInvoiceAmount, isFalse);
      expect(service.getPayableAmount(), service.paymentAmountController.text);
    });

    tearDown(() {
      service.filterInvoiceList.clear();
    });
  });

  group("PaymentFormService@removeInvoice should remove selected invoice", () {
    setUp(() {
      service.invoiceList = selectedInvoices = [
        JPMultiSelectModel(label: 'Invoice # 1452', id: '1', isSelect: true, additionData: '100'),
        JPMultiSelectModel(label: 'Invoice # 1234', id: '2', isSelect: true, additionData: '200'),
      ];
    });

    test("Remove functionality should not execute, If no invoices are not available", () {
      service.invoiceList.clear();
      service.removeInvoice(0);
      expect(service.filterInvoiceList.length, 0);
    });

    test("Remove functionality should not execute, If there are no selected invoices", () {
      service.filterInvoiceList.clear();
      service.removeInvoice(0);
      expect(service.filterInvoiceList.length, 0);
    });

    test("Single Invoice should be removed from the selected invoices", () {
      service.onInvoicesSelected([selectedInvoices[0]]);
      service.removeInvoice(0);
      expect(service.filterInvoiceList.length, 0);
    });

    test("Multiple Invoices should be removed from the selected invoices", () {
      service.onInvoicesSelected(selectedInvoices);
      service.removeInvoice(0);
      service.removeInvoice(0);
      expect(service.filterInvoiceList.length, 0);
    });

    test("Invoice Amount should update on removing invoice", () {
      service.onInvoicesSelected(selectedInvoices);
      service.removeInvoice(0);
      expect(service.invoicesAmount, 200);
    });

    test("Invoice Amount should remain selected, If was active previously", () {
      service.isInvoiceAmount = true;
      service.paymentAmountController.text = '';
      service.onInvoicesSelected(selectedInvoices);
      service.removeInvoice(0);
      expect(service.isInvoiceAmount, isTrue);
    });

    test("Amount should switch to custom payment, on removing all invoices", () {
      service.isInvoiceAmount = true;
      service.onInvoicesSelected(selectedInvoices);
      service.removeInvoice(0);
      service.removeInvoice(0);
      expect(service.isInvoiceAmount, isFalse);
    });
  });

  group("PaymentFormService@changePaymentType should switch between record and process payment", () {
    test("Process Payment Form should be displayed on selecting process payment", () {
      service.changePaymentType(false);
      expect(service.isRecordPaymentForm, isFalse);
    });

    test("Record Payment Form should be displayed on selecting record payment", () {
      service.changePaymentType(true);
      expect(service.isRecordPaymentForm, isTrue);
    });

    test("Justifi section should reload on switching to Process Payment Form", () {
      service.changePaymentType(false);
      expect(service.isCardFormLoaded, isFalse);
      expect(service.isBankFormLoaded, isFalse);
      expect(service.justifySectionHeight, 160);
    });
  });

  group("PaymentFormService@changePaymentMethod should switch between Justifi Credit/Debit Card and Bank Form", () {
    test("Credit/Debit Card Form should be displayed on selecting Credit/Debit Card option", () {
      service.changePaymentMethod(true);
      expect(service.isCardForm, isTrue);
    });

    test("Bank Form should be displayed on selecting Bank Details Option", () {
      service.changePaymentMethod(false);
      expect(service.isCardForm, isFalse);
    });

    test("Justifi section should reload on switching between Forms", () {
      service.changePaymentMethod(false);
      expect(service.isCardFormLoaded, isFalse);
      expect(service.isBankFormLoaded, isFalse);
    });
  });

  group("PaymentFormService@setDefaultJustifyForm should set default form based on company settings", () {
    test("Credit/Debit Card Form should be displayed when Both is selected in Payment Method Preference ", () {
      CompanySettingsService.companySettings[CompanySettingConstants.defaultLeapPayPaymentMethod] = {"value" : 'card_and_ach'};
      service.defaultPaymentMethod = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.defaultLeapPayPaymentMethod);
      service.setDefaultPaymentForm();
      expect(service.isCardForm, isTrue);
    });

    test("Credit/Debit Card Form should be displayed when Debit/Credit card only is selected in Payment Method Preference ", () {
      CompanySettingsService.companySettings[CompanySettingConstants.defaultLeapPayPaymentMethod] = {"value" : 'card'};
      service.defaultPaymentMethod = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.defaultLeapPayPaymentMethod);
      service.setDefaultPaymentForm();
      expect(service.isCardForm, isTrue);
    });

    test("Bank Form should be displayed when ACH only is selected in Payment Method Preference ", () {
      CompanySettingsService.companySettings[CompanySettingConstants.defaultLeapPayPaymentMethod] = {"value" : 'ach'};
      service.defaultPaymentMethod = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.defaultLeapPayPaymentMethod);
      service.setDefaultPaymentForm();
      expect(service.isCardForm, isFalse);
    });

    test("Credit/Debit Card Form should be displayed when Payment Method Preference is null", () {
      CompanySettingsService.companySettings[CompanySettingConstants.defaultLeapPayPaymentMethod] = {"value" : null};
      service.defaultPaymentMethod = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.defaultLeapPayPaymentMethod);
      service.setDefaultPaymentForm();
      expect(service.isCardForm, isTrue);
    });

  });

  group("PaymentFormService@changePaymentAmount should switch between invoice and custom amount", () {
    test("Invoice amount should be selected", () {
      service.changePaymentAmount(true);
      expect(service.isInvoiceAmount, isTrue);
    });

    test("Custom amount should be selected", () {
      service.changePaymentAmount(false);
      expect(service.isInvoiceAmount, isFalse);
    });

    test("Invoice amount should be used as payable amount", () {
      addInvoices();
      service.filterInvoiceList = [
        selectedInvoices[0]..isSelect = true,
        selectedInvoices[1]..isSelect = true,
      ];
      service.changePaymentAmount(true);
      service.paymentAmountController.text = '500';
      expect(service.getPayableAmount(), '300.0');
      expect(service.pendingInvoiceAmount, 0);
    });

    test("Custom amount should be used as payable amount", () {
      service.changePaymentAmount(false);
      service.paymentAmountController.text = '500';
      expect(service.getPayableAmount(), '500');
    });
  });

  group("PaymentFormService@changeAccountType should switch between bank account type", () {
    test("'Savings' account should be selected", () {
      service.changeAccountType(true);
      expect(service.isSavingAccount, isTrue);
    });

    test("'Checking' account should be selected", () {
      service.changeAccountType(false);
      expect(service.isSavingAccount, isFalse);
    });
  });

  test("PaymentFormService@onEmailReceiptSelected should set selected email receipt", () {
    service.emailReceiptList.addAll([
      JPSingleSelectModel(label: '1@test.com', id: '1@test.com'),
      JPSingleSelectModel(label: '2@test.com', id: '2@test.com'),
    ]);
    service.onEmailReceiptSelected('1@test.com');
    expect(service.selectedEmailReceipt, '1@test.com');
  });

  group("PaymentFormService@onPaymentMethodLoaded should display payment method and hide loader", () {
    test("Card Form should be displayed", () {
      List<dynamic> arguments = ['card'];
      service.onPaymentMethodLoaded(arguments);
      expect(service.isCardFormLoaded, isTrue);
    });

    test("Bank Form should be displayed", () {
      List<dynamic> arguments = ['bank'];
      service.onPaymentMethodLoaded(arguments);
      expect(service.isBankFormLoaded, isTrue);
    });
  });

  group('PaymentFormService@onHeightUpdate should set justify section height as per available content', () {
    test('Loader height should be set correctly', () {
      service.isCardFormLoaded = service.isBankFormLoaded = false;
      service.onHeightUpdate([100]);
      expect(service.justifySectionHeight, equals(160));
    });

    test('Justify section height should be set correctly with spacer', () {
      service.isCardFormLoaded = true;
      service.onHeightUpdate([200]);
      expect(service.justifySectionHeight, equals(220));
    });

    test("When section height is not available, default height should be used", () {
      service.isCardFormLoaded = true;
      service.onHeightUpdate(['']);
      expect(service.justifySectionHeight, equals(160));
    });
  });

  group("PaymentFormService@tokenizationHandler should handle payment method tokenization", () {
    test("Form should be disabled when tokenization is in progress", () {
      service.tokenizationHandler([true]);
      expect(service.receivePaymentFormController.isSavingForm, isFalse);
    });

    test("Incorrect tokenization details should not set", () {
      service.tokenizationHandler([null]);
      expect(service.tokenizationDetails, isNull);
    });

    test("Tokenization details should be set correctly", () {
      service.tokenizationHandler([{
        'paymentToken': 'abc',
        'cardDetails': {
          'name': 'ABC',
          'acct_last_four': '1234'
        }
      }]);
      expect(service.tokenizationDetails?.paymentToken, equals('abc'));
      expect(service.tokenizationDetails?.cardDetails?.name, equals('ABC'));
      expect(service.tokenizationDetails?.cardDetails?.acctLastFour, equals('1234'));
    });

    test("Form should be enabled when tokenization completed", () {
      service.tokenizationHandler([false]);
      expect(service.receivePaymentFormController.isSavingForm, isFalse);
    });
  });

  group("PaymentFormService@getTokenizationParams should give tokenization params", () {
    test("In case of Card Form Postal Code should in params", () {
      service.changePaymentMethod(true);
      final params = service.getTokenizationParams();
      expect(params['params']?.containsKey('account_owner_name'), isFalse);
      expect(params['params']?.containsKey('account_type'), isFalse);
      expect(params['params']?.containsKey('address_postal_code'), isTrue);
    });

    test("In case of Bank Form Owner Name and Account Type should be in params", () {
      service.changePaymentMethod(false);
      final params = service.getTokenizationParams();
      expect(params['params']?.containsKey('account_owner_name'), isTrue);
      expect(params['params']?.containsKey('account_type'), isTrue);
      expect(params['params']?.containsKey('address_postal_code'), isFalse);
    });

    test("Justfi Client ID should be added correctly", () {
      final params = service.getTokenizationParams();
      expect(params['client_id'], AppEnv.envConfig[CommonConstants.justifiClientId]);
    });

    test('LeapPay Account ID should be added correctly', () {
      final params = service.getTokenizationParams();
      expect(params['account_id'], ConnectedThirdPartyService.getConnectedPartyKey(ConnectedThirdPartyConstants.leapPay));
    });
  });

  group("PaymentFormService@getPayableAmount should give payable amount corretly", () {
    group("In case of Record Payment", () {
      test("In case of Record Payment, payable amount should be custom amount", () {
        service.isRecordPaymentForm = true;
        service.paymentAmountController.text = '100';
        final payableAmount = service.getPayableAmount();
        expect(payableAmount, '100');
      });
    });

    group("In case of Process Payment", () {
      test("In case of Invoice Payment, payable amount should be invoice amount", () {
        service.isRecordPaymentForm = false;
        service.onInvoicesSelected([
          selectedInvoices[1]..isSelect = true,
        ]);
        service.isInvoiceAmount = true;
        service.paymentAmountController.text = '100';
        final payableAmount = service.getPayableAmount();
        expect(payableAmount, '200.0');
      });

      test("In case of Custom Payment, payable amount should be custom amount", () {
        service.isRecordPaymentForm = false;
        service.onInvoicesSelected([
          selectedInvoices[1]..isSelect = true,
        ]);
        service.isInvoiceAmount = false;
        service.paymentAmountController.text = '100';
        final payableAmount = service.getPayableAmount();
        expect(payableAmount, '100');
      });
    });

    group('In case of Fee Pass Over Enabled', () {
      test(
          'should return amount with LeapPay fee for card payment when fee pass over is enabled and not record payment form',
          () {
        service.isRecordPaymentForm = false;
        service.isCardForm = true;
        service.paymentAmountController.text = "100.0";

        final payableAmount =
            service.getPayableAmount(isFeePassOverEnabled: true);

        double expectedAmount = 100.0 +
            JobFinancialHelper.calculateLeapPayFee(
                LeapPayPaymentMethod.card, 100.0);
        expect(payableAmount, expectedAmount.toString());
      });

      test(
          'should return amount with LeapPay fee for ACH payment when fee pass over is enabled and not record payment form',
          () {
        service.isRecordPaymentForm = false;
        service.isCardForm = false;
        service.paymentAmountController.text = "200.0";

        final payableAmount =
            service.getPayableAmount(isFeePassOverEnabled: true);

        double expectedAmount = 200.0 +
            JobFinancialHelper.calculateLeapPayFee(
                LeapPayPaymentMethod.achOnly, 200.0);
        expect(payableAmount, expectedAmount.toString());
      });

      test('should return original amount when fee pass over is disabled', () {
        service.isRecordPaymentForm = false;
        service.paymentAmountController.text = "300.0";

        final payableAmount =
            service.getPayableAmount(isFeePassOverEnabled: false);

        expect(payableAmount, "300.0");
      });

      test(
          'should return original amount when isRecordPaymentForm is true, even if fee pass over is enabled',
          () {
        service.isRecordPaymentForm = true;
        service.paymentAmountController.text = "400.0";

        final payableAmount =
            service.getPayableAmount(isFeePassOverEnabled: true);

        expect(payableAmount, "400.0");
      });
    });
  });

  group("PaymentFormService@setIsRecordPayment should decide receive payment form type", () {
    group("When Payment Form is opened from quick actions", () {
      test("Process Payment form should be displayed", () {
        service.receivePaymentFormType = ReceivePaymentFormType.processPayment;
        service.setIsRecordPayment();
        expect(service.isRecordPaymentForm, isFalse);
      });

      test("Record Payment form should be displayed", () {
        service.receivePaymentFormType = ReceivePaymentFormType.recordPayment;
        service.setIsRecordPayment();
        expect(service.isRecordPaymentForm, isTrue);
      });
    });

    group("When Payment Form is opened for add payment", () {
      test("Process payment form should be displayed by default, If LeapPay is enabled", () {
        service.isLeapPayEnabled = true;
        service.receivePaymentFormType = null;
        service.setIsRecordPayment();
        expect(service.isRecordPaymentForm, isFalse);
      });

      test("Record Payment form should be displayed by default, If LeapPay is disabled", () {
        service.isLeapPayEnabled = false;
        service.setIsRecordPayment();
        expect(service.isRecordPaymentForm, isTrue);
      });
    });
  });

  group("PaymentFormService@setEmailReceiptList should set email receipt options correctly", () {
    setUp(() {
      service.emailReceiptList.clear();
    });

    test('Email receipt should be empty if job is not available', () {
      service.job = null;
      service.setEmailReceiptList();
      expect(service.emailReceiptList, isEmpty);
    });

    test('Email receipt should have options to select job contact person email', () {
      service.job = JobModel(id: 1, customerId: 2, contactPerson: [
        CompanyContactListingModel(emails: [EmailModel(email: '1@test.com')])
      ]);
      service.setEmailReceiptList();
      expect(service.emailReceiptList.length, 1);
    });

    test('Email receipt should have options to select job customer email', () {
      service.job = JobModel(id: 1, customerId: 2, customer: CustomerModel(email: '1@test.com'));
      service.setEmailReceiptList();
      expect(service.emailReceiptList.length, 1);
    });

    test('Email receipt should have options to select job additional customer emails', () {
      service.job = JobModel(id: 1, customerId: 2, customer: CustomerModel(additionalEmails: ['1@test.com']));
      service.setEmailReceiptList();
      expect(service.emailReceiptList.length, 1);
    });

    test('Email receipt should have options to select from customer and contact person emails', () {
      service.job = JobModel(id: 1, customerId: 2, contactPerson: [
        CompanyContactListingModel(emails: [EmailModel(email: '1@test.com')]),
      ], customer: CustomerModel(email: '2@test.com'));
      service.setEmailReceiptList();
      expect(service.emailReceiptList.length, 2);
    });

    test('Repetitive emails should be removed from selection options', () {
      service.job = JobModel(id: 1, customerId: 2, contactPerson: [
        CompanyContactListingModel(emails: [EmailModel(email: '1@test.com'), EmailModel(email: '1@test.com')])
      ]);
      service.setEmailReceiptList();
      expect(service.emailReceiptList.length, 1);
    });
  });
}