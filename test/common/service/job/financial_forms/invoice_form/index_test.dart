import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/invoice_form_type.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/company_trades/company_trades_model.dart';
import 'package:jobprogress/common/models/financial_product/financial_product_model.dart';
import 'package:jobprogress/common/models/forms/invoice_form/index.dart';
import 'package:jobprogress/common/models/forms/worksheet/supplier_form_params.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/job_type.dart';
import 'package:jobprogress/common/models/job_financial/financial_details.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/common/models/job_financial/tax_model.dart';
import 'package:jobprogress/common/models/popover_action.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/models/suppliers/beacon/account.dart';
import 'package:jobprogress/common/models/suppliers/beacon/job.dart';
import 'package:jobprogress/common/models/suppliers/branch.dart';
import 'package:jobprogress/common/models/suppliers/srs/srs_ship_to_address.dart';
import 'package:jobprogress/common/models/suppliers/suppliers.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/common/services/job_financial/forms/invoice_form/invoice_form.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/connected_third_party_constants.dart';
import 'package:jobprogress/core/constants/financial_constants.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/modules/job_financial/form/invoice_form/controller.dart';
import 'package:jobprogress/modules/job_financial/form/leappay_preferences/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

void main() {
  JobModel? tempJob = JobModel.fromJson({
    "id":19749,
    "customer_id":32428,
    "description":"sachin",
    "amount":"100000",
    "taxable":1,
    "tax_rate":"15",
    "insurance":0,
    "quickbook_id":0,
    "quickbook_sync_status":null,
    "qb_desktop_id":"",
    "multi_job":0,
    "address":{
      "id":46650,
      "state_id":0,
      "state":null,
      "state_tax":{
        "tax_rate":"3.25"
      }
    },
    "trades": [{"id": 19, "name": "CARPETS & FLOORING", "pivot": {"job_id": 19749, "trade_id": 19}}],
    "work_types": [{"id": 15, "name": "cerpkj55", "trade_id": 19}],
    "financial_details":{
      "total_job_amount":115000,
      "total_change_order_amount":0,
      "total_amount":115000,
      "total_received_payemnt":0,
      "total_credits":0,
      "total_refunds":0,
      "pending_payment":115000,
      "total_commission":0,
      "job_invoice_amount":0,
      "job_invoice_tax_amount":0,
      "sold_out_date":null,
      "can_block_financials":true,
      "unapplied_credits":0,
      "applied_payment":0,
      "total_account_payable_amount":0,
      "pending_payment_refund_adjusted":115000,
      "is_derived_tax":0
    },
  });

  FinancialListingModel tempFinancialModel = FinancialListingModel.fromChangeOrderJson({
    "id":2364,
    "job_id":5820,
    "total_amount":"38.00",
    "taxable":1,
    "tax_rate":"8.3",
    "invoice_id":9302,
    "order":2,
    "entities":[
      {
        "id":2786,
        "change_order_id":2364,
        "description":"NO CHARGE / No chrge - efwr",
        "amount":"50.00",
        "quantity":"2",
        "product_id":255493,
        "trade_id":62,
        "work_type_id":null,
        "is_chargeable":0,
        "is_taxable":0,
        "trade":{
          "id":62,
          "name":"BATH FIXTURES"
        },
        "work_type":null
      },
      {
        "id":2787,
        "change_order_id":2364,
        "description":"Check Email 1 - 12",
        "amount":"12.00",
        "quantity":"2",
        "product_id":65669,
        "trade_id":1,
        "work_type_id":13,
        "is_chargeable":1,
        "is_taxable":1,
        "trade":{
          "id":1,
          "name":"CARPENTRY - DEV (RDS)"
        },
        "work_type":{
          "id":13,
          "name":"carp1",
          "color":"#79443B",
          "insurance_claim":false
        }
      },
      {
        "id":2788,
        "change_order_id":2364,
        "description":"F",
        "amount":"2.00",
        "quantity":"7",
        "product_id":null,
        "trade_id":31,
        "work_type_id":null,
        "is_chargeable":1,
        "is_taxable":1,
        "trade":{
          "id":31,
          "name":"AUTOMOTIVE"
        },
        "work_type":null
      }
    ],
    "invoice_updated":1,
    "invoice_note":"v",
    "name":"My Invoice",
    "unit_number":"1234",
    "division_id":35,
    "taxable_amount":"38.00",
    "amount_with_tax":null,
    "leap_pay_enabled": 1,
    "payment_method": "card",
    "division":{
      "id":35,
      "company_id":15012,
      "name":"North India",
    }
  });
  
    FinancialListingModel tempModel = FinancialListingModel(
      invoiceId: -1
    );

    List<SheetLineItemModel> tempLineItems = [
      SheetLineItemModel(
        pageType: AddLineItemFormType.invoiceForm,
        price: '10.00',
        title: 'Title - 1',
        qty: '5',
        totalPrice: '50.00',
        productId: '2'
      ),
    ];


  List<JPSingleSelectModel> tempTaxList = [
    JPSingleSelectModel(id: "1", label: "Tax A (4.55%)", additionalData: 4.55),
    JPSingleSelectModel(id: "2", label: "Tax B (30%)", additionalData: 30),
    JPSingleSelectModel(id: "3", label: "Tax C (25%)", additionalData: 25),
    JPSingleSelectModel(id: "4", label: "Tax D (5.6%)", additionalData: 5.6),
    JPSingleSelectModel(id: "5", label: "Tax E (10%)", additionalData: 10),
  ];

  List<JPSingleSelectModel> tempDivisionList = [
    JPSingleSelectModel(id: "10", label: "Division A"),
    JPSingleSelectModel(id: "12", label: "Division B"),
    JPSingleSelectModel(id: "13", label: "Division C"),
    JPSingleSelectModel(id: "14", label: "Division D"),
    JPSingleSelectModel(id: "15", label: "Division E"),
  ];

  Map<String, dynamic> companySettingJson = {
    "data":[
      {
        "id":701,
        "name":"TAX RATE",
        "key":"TAX_RATE",
        "value":"5",
        "user_id":null,
        "company_id":20
      }
    ],
  };

  SheetLineItemModel lineItem = SheetLineItemModel(
    productId: '1',
    title: 'Test',
    price: '100',
    qty: '2',
    totalPrice: '200',
  );

  SheetLineItemModel lineItem2 = SheetLineItemModel(
    productId: '2',
    title: 'Test',
    price: '100',
    qty: '2',
    totalPrice: '200',
  );

  SheetLineItemModel lineItem3 = SheetLineItemModel(
    productId: '3',
    title: 'Test',
    price: '100',
    qty: '2',
    totalPrice: '200',
  );

  SheetLineItemModel lineItem4 = SheetLineItemModel(
    productId: '4',
    title: 'Test',
    price: '100',
    qty: '2',
    totalPrice: '200',
  );

  Map<String, dynamic> quickBookList = {'quickbook': {'quickbook_company_id': 1, 'only_one_way_sync': false}, 'quickbook_pay': {'quickbooks_payments_connected': 0}, 'quickbook_desktop': false, 'quickmeasure': {'quickmeasure_account_id': 'gigi@gaf-uattigerteamroofing.com'}};

  Map<String, dynamic> quickBookListNull = {'quickbook': null, 'quickbook_pay': null, 'quickbook_desktop': false, 'quickmeasure': {'quickmeasure_account_id': 'gigi@gaf-uattigerteamroofing.com'}};
  
  late Map<String, dynamic> tempInitialJson;

  InvoiceFormData data = InvoiceFormData(
      update: () {},
  );

  InvoiceFormService tempService = InvoiceFormService(
    update: () {},
    validateForm: () {},
    jobId: tempJob.id,
  );

  ////////////////////    TAX RATE CALCULATION TEST CASES   ////////////////////

  group('To calculate tax rate', () {

    ////////////////////////    QUICK BOOK TEST CASES   ////////////////////////

    test('JobFinancialHelper@getTaxRateForFinancialForm should return custom tax, when QuickBooks is connected and the invoice has a custom tax rate', () {
      ConnectedThirdPartyService.setConnectedParty(quickBookList);
      tempFinancialModel.customTax = TaxModel(taxRate: 5);
      expect(JobFinancialHelper.getTaxRateForFinancialForm(jobModel: tempJob, jobInvoices: tempFinancialModel), 5);
    });

    test("JobFinancialHelper@getTaxRateForFinancialForm should return no tax, when QuickBooks is connected and there is no custom tax rate in the invoice", () {
      ConnectedThirdPartyService.setConnectedParty(quickBookList);
      tempFinancialModel.customTax = null;
      expect(JobFinancialHelper.getTaxRateForFinancialForm(jobModel: tempJob, jobInvoices: tempFinancialModel), 0);
    });

    ///////////////////////    JOB TAX RATE TEST CASES   ///////////////////////

    test("JobFinancialHelper@getTaxRateForFinancialForm should return state tax, when QuickBooks is not connected and job is not taxable", () {
      ConnectedThirdPartyService.setConnectedParty(quickBookListNull);
      tempJob.taxable = 0;
      expect(JobFinancialHelper.getTaxRateForFinancialForm(jobModel: tempJob, jobInvoices: tempFinancialModel), 3.25);
      tempJob.taxable = 1;
    });

    test("JobFinancialHelper@getTaxRateForFinancialForm should return state tax, when QuickBooks is not connected and job does not have tax rate", () {
      ConnectedThirdPartyService.setConnectedParty(quickBookListNull);
      tempJob.taxRate = null;
      expect(JobFinancialHelper.getTaxRateForFinancialForm(jobModel: tempJob, jobInvoices: tempFinancialModel), 3.25);
      tempJob.taxRate = "15";
    });

    test("JobFinancialHelper@getTaxRateForFinancialForm should return state tax, when QuickBooks is not connected and job has derived tax", () {
      ConnectedThirdPartyService.setConnectedParty(quickBookListNull);
      tempJob.financialDetails?.isDerivedTax = 1;
      expect(JobFinancialHelper.getTaxRateForFinancialForm(jobModel: tempJob, jobInvoices: tempFinancialModel), 3.25);
      tempJob.financialDetails?.isDerivedTax = 0;
    });

    test("JobFinancialHelper@getTaxRateForFinancialForm should return job tax, when QuickBooks is not connected and job is taxable and job has tax rate and job does not have derived tax", () {
      ConnectedThirdPartyService.setConnectedParty(quickBookListNull);
      expect(JobFinancialHelper.getTaxRateForFinancialForm(jobModel: tempJob, jobInvoices: tempFinancialModel), 15);
    });

    //////////////////    INVOICE CUSTOM TAX RATE TEST CASE   //////////////////

    test("JobFinancialHelper@getTaxRateForFinancialForm should return custom tax, when QuickBooks isn't connected and the job doesn't have a tax rate, but invoice has custom tax rate", () {
      ConnectedThirdPartyService.setConnectedParty(quickBookListNull);
      tempJob.taxRate = null;
      tempFinancialModel.customTax = TaxModel(taxRate: 5);
      expect(JobFinancialHelper.getTaxRateForFinancialForm(jobModel: tempJob, jobInvoices: tempFinancialModel), 5);
      tempFinancialModel.customTax = null;
    });

    /////////////////    PARENT JOB STATE TAX RATE TEST CASE   /////////////////

    test("JobFinancialHelper@getTaxRateForFinancialForm should return parent job state tax, when QuickBooks isn't connected and the job doesn't have a tax rate, but its parent job has state taxes", () {
      ConnectedThirdPartyService.setConnectedParty(quickBookListNull);
      tempJob.taxRate = null;
      tempJob.isProject = true;
      tempJob.parent = JobModel(id: 1, customerId: 1, address: AddressModel(id: 0, stateTax: 10));
      expect(JobFinancialHelper.getTaxRateForFinancialForm(jobModel: tempJob, jobInvoices: tempFinancialModel), 10);
      tempJob.isProject = false;
      tempJob.parent = null;
    });

    ////////////////////    JOB STATE TAX RATE TEST CASES   ////////////////////

    test("JobFinancialHelper@getTaxRateForFinancialForm should return state tax, when QuickBook isn't connected and job doesn't have tax rate", () {
      ConnectedThirdPartyService.setConnectedParty(quickBookListNull);
      tempJob.taxRate = null;
      expect(JobFinancialHelper.getTaxRateForFinancialForm(jobModel: tempJob, jobInvoices: tempFinancialModel), 3.25);
    });

    test("JobFinancialHelper@getTaxRateForFinancialForm should return state tax, when QuickBook isn't connected and job doesn't have tax rate but has state tax", () {
      ConnectedThirdPartyService.setConnectedParty(quickBookListNull);
      tempJob.taxRate = null;
      tempJob.address = AddressModel(id: 0, stateTax: 5);
      expect(JobFinancialHelper.getTaxRateForFinancialForm(jobModel: tempJob, jobInvoices: tempFinancialModel), 5);
    });

    /////////////////    COMPANY SETTING TAX RATE TEST CASES   /////////////////

    test("JobFinancialHelper@getTaxRateForFinancialForm should return no tax, when QuickBook isn't connected and job doesn't tax rate and company also doesn't has some own tax", () {
      ConnectedThirdPartyService.setConnectedParty(quickBookListNull);
      tempJob.taxRate = null;
      tempJob.address?.stateTax = null;
      expect(JobFinancialHelper.getTaxRateForFinancialForm(jobModel: tempJob, jobInvoices: tempFinancialModel), 0);
    });

    test("JobFinancialHelper@getTaxRateForFinancialForm should return default company tax, when QuickBook isn't connected and job doesn't tax rate but company has some own tax", () {
      ConnectedThirdPartyService.setConnectedParty(quickBookListNull);
      CompanySettingsService.setCompanySettings(companySettingJson["data"]);
      tempJob.taxRate = null;
      tempJob.address?.stateTax = null;
      expect(JobFinancialHelper.getTaxRateForFinancialForm(jobModel: tempJob, jobInvoices: tempFinancialModel), 5);
      tempJob.taxable = 1;
      tempJob.taxRate = "15";
      tempJob.financialDetails?.isDerivedTax = 0;
    });

  });

  ////////////////////    CREATE CHANGE ORDER TEST CASES    ////////////////////

  group('In case of create change order', () {
    InvoiceFormService service = InvoiceFormService(
      update: () {},
      validateForm: () {},
      jobId: tempJob.id,
      pageType: InvoiceFormType.changeOrderCreateForm,
    );
    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      DateTimeHelper.setUpTimeZone();
      service.jobModel = tempJob;
      service.singleSelectTaxList = tempTaxList;
      service.divisionsList = tempDivisionList;
      service.controller = InvoiceFormController();
      tempInitialJson = service.getFormJson()..["tax_rate"] = JobFinancialHelper.getTaxRateForFinancialForm(jobModel: tempJob, jobInvoices: tempFinancialModel);
      tempInitialJson = tempInitialJson..["taxable"] = service.getIsTaxable() ? 1 : 0;
      service.leapPayPreferencesController = LeapPayPreferencesController();
    });

    group('InvoiceFormService should be initialized with correct data', () {
      test('Form fields should be initialized with correct values', () {
        expect(service.titleController.text, "");
        expect(service.billDateController.text, "");
        expect(service.dueDateController.text, "");
        expect(service.unitController.text, "");
        expect(service.divisionController.text, "");
      });

      test('Form data helpers should be initialized with correct values', () {
        expect(service.jobModel != null, true);
        expect(service.initialJson, <String, dynamic>{});
        expect(service.isTaxable, true);
        expect(service.taxRate, 0);
        expect(service.revisedTaxRate, 0);
        expect(service.totalInvoicePrice, 0);
        expect(service.itemsTotalPrice, 0);
        expect(service.totalTaxAmount, 0);
        expect(service.totalTaxableAmount, 0);
        expect(service.totalTaxableItems, 0);
        expect(service.noChargeItemsTotal, 0);
      });

      test('InvoiceFormService@setFormData() should set-up form values', () {
        service.setFormData();
        service.initialJson = service.getFormJson();
        expect(service.initialJson, tempInitialJson);
      });

      group('InvoiceFormService@checkIfNewDataAdded() should check if any addition/update is made in form', () {
        JPSingleSelectModel? initialSelectedProduct;
        test('When no changes in form are made', () {
          final val = service.checkIfNewDataAdded();
          expect(val, false);
        });

        test('When changes in form are made', () {
          service.selectedDivision = tempDivisionList[0];
          final val = service.checkIfNewDataAdded();
          expect(val, true);
        });

        test('When changes are reverted', () {
          service.selectedDivision = initialSelectedProduct;
          final val = service.checkIfNewDataAdded();
          expect(val, false);
        });
      });

    });

    ///////////////////    TEST CASES FOR TAX APPLICABILITY    /////////////////

    group('InvoiceFormService@getIsTaxable() should calculate is invoice taxable ot not', () {

      //////////    TEST CASES FOR IS INITIALLY TAX IS APPLICABLE    ///////////

      group("JobFinancialHelper@getIsTaxable should check is initially tax is applied or not", () {
        test("JobFinancialHelper@getIsTaxable should return true, when QuickBooks is not connected and the job is taxable and don't have derived tax", () {
          ConnectedThirdPartyService.setConnectedParty(quickBookListNull);
          tempJob.taxable = 1;
          tempJob.financialDetails?.isDerivedTax = 0;
          expect(service.getIsTaxable(), isTrue);
        });

        test("JobFinancialHelper@getIsTaxable should return false, when QuickBooks is not connected and the job is not taxable and don't have derived tax", () {
          ConnectedThirdPartyService.setConnectedParty(quickBookListNull);
          tempJob.taxable = 0;
          tempJob.financialDetails?.isDerivedTax = 0;
          expect(service.getIsTaxable(), false);
        });

        test("JobFinancialHelper@getIsTaxable should return false, when QuickBooks is not connected and the job is not taxable and has derived tax", () {
          ConnectedThirdPartyService.setConnectedParty(quickBookListNull);
          tempJob.taxable = 0;
          tempJob.financialDetails?.isDerivedTax = 1;
          expect(service.getIsTaxable(), false);
        });

        test("JobFinancialHelper@getIsTaxable should return false, when QuickBooks is connected and the job is taxable and don't have derived tax", () {
          ConnectedThirdPartyService.setConnectedParty(quickBookList);
          tempJob.taxable = 1;
          tempJob.financialDetails?.isDerivedTax = 0;
          expect(service.getIsTaxable(), isFalse);
        });
      });

      ////////    TEST CASES FOR MANUALLY UPDATE TAX APPLICABILITY    //////////

      group("InvoiceFormService@onTapMoreActionIcon should toggle tax applicability", () {
        test('Tax should be applied', () {
          service.onTapMoreActionIcon(PopoverActionModel(label: '', value: 'apply_tax'));
          expect(service.isTaxable, true);
        });
        test('Tax should not be applicable', () {
          service.onTapMoreActionIcon(PopoverActionModel(label: '', value: 'remove_tax'));
          expect(service.isTaxable, false);
        });
      });
    });

    ////////////////////    PRICE CALCULATION TEST CASES    ////////////////////

    group('InvoiceFormService@calculateTotalPrice() should calculate total price', () {

      /////////////////////    WHEN TAX NOT APPLICABLE    //////////////////////

      group("When job is non taxable", () {
        test('Should be all zero when there is no item', () {
          service.invoiceItems = [];
          service.onTapMoreActionIcon(PopoverActionModel(label: '', value: 'remove_tax'));
          expect(service.isTaxable, false);
          expect(service.totalInvoicePrice, 0);
          expect(service.itemsTotalPrice, 0);
          expect(service.totalTaxAmount, 0);
          expect(service.totalTaxableAmount, 0);
          expect(service.totalTaxableItems, 0);
          expect(service.noChargeItemsTotal, 0);
        });

        test('Should have some calculated values when there is are some items are added', () {
          service.invoiceItems = tempFinancialModel.lines ?? [];
          for (var element in service.invoiceItems) {
            element.isTaxable = false;
          }
          service.calculateTotalPrice();
          expect(service.isTaxable, false);
          expect(service.totalInvoicePrice, 38);
          expect(service.itemsTotalPrice, 138);
          expect(service.totalTaxAmount, 0);
          expect(service.totalTaxableAmount, 0);
          expect(service.totalTaxableItems, 0);
          expect(service.noChargeItemsTotal, 0);
        });

        test('Should also calculated values when no charge item is present in item list but its total should not be added in total amount', () {
          service.invoiceItems = tempFinancialModel.lines ?? [];
          service.setNoChargeItemList();
          service.calculateTotalPrice();
          expect(service.isTaxable, false);
          expect(service.totalInvoicePrice, 38);
          expect(service.itemsTotalPrice, 138);
          expect(service.totalTaxAmount, 0);
          expect(service.totalTaxableAmount, 0);
          expect(service.totalTaxableItems, 0);
          expect(service.noChargeItemsTotal, 100);
          service.noChargeItemsTotal = 0;
        });
      });

      //////////////////////    WHEN TAX IS APPLICABLE    //////////////////////

      group("When job is taxable", () {
        test('Should be all zero when there is no item', () {
          service.invoiceItems = [];
          service.noChargeItemsList = [];
          service.onTapMoreActionIcon(PopoverActionModel(label: '', value: 'apply_tax'));
          expect(service.isTaxable, true);
          expect(service.taxRate, 15);
          expect(service.totalInvoicePrice, 0);
          expect(service.itemsTotalPrice, 0);
          expect(service.totalTaxAmount, 0);
          expect(service.totalTaxableAmount, 0);
          expect(service.totalTaxableItems, 0);
          expect(service.noChargeItemsTotal, 0);
        });

        test('Should have some calculated values with tax when there is are some items are added', () {
          service.invoiceItems = tempFinancialModel.lines ?? [];
          service.onTapMoreActionIcon(PopoverActionModel(label: '', value: 'apply_tax'));
          expect(service.isTaxable, true);
          expect(service.taxRate, 15);
          expect(service.totalInvoicePrice, 43.7);
          expect(service.itemsTotalPrice, 138);
          expect(service.totalTaxAmount, 5.7);
          expect(service.totalTaxableAmount, 38);
          expect(service.totalTaxableItems, 2);
          expect(service.noChargeItemsTotal, 0);
        });

        test('Should also calculated values with tax when no charge item is present in item list but its total should not be added in total amount', () {
          service.invoiceItems = tempFinancialModel.lines ?? [];
          service.setNoChargeItemList();
          service.onTapMoreActionIcon(PopoverActionModel(label: '', value: 'apply_tax'));
          expect(service.isTaxable, true);
          expect(service.totalInvoicePrice, 43.7);
          expect(service.itemsTotalPrice, 138);
          expect(service.totalTaxAmount, 5.7);
          expect(service.totalTaxableAmount, 38);
          expect(service.totalTaxableItems, 2);
          expect(service.noChargeItemsTotal, 100);
        });
      });
    });

    ////////////////////////    VALIDATION TEST CASES    ///////////////////////

    group('InvoiceFormService@validateFormData() should validate form date', () {

      group('Item list validation', () {
        test('Validation should fail when item list is empty', () {
          service.invoiceItems = [];
          expect(service.validateFormData(), false);
        });

        test('Validation should pass when item list is not empty', () {
          service.invoiceItems = tempFinancialModel.lines ?? [];
          expect(service.validateFormData(), true);
        });
      });

      group('Due date validation', () {
        test('Validation should fail when due date is less the bill date', () {
          service.billDateController.text = DateTime.now().toString();
          DateTime billDate = DateTime.parse(service.billDateController.text);
          service.dueDateController.text = billDate.subtract(const Duration(days: 10)).toString();
          expect(!service.validateDates(), false);
        });

        test('Validation should pass when bill date is less the due date', () {
          service.billDateController.text = DateTime.now().toString();
          DateTime billDate = DateTime.parse(service.billDateController.text);
          service.dueDateController.text = billDate.add(const Duration(days: 10)).toString();
          expect(!service.validateDates(), true);
        });

        test('Validation should pass when bill date is not empty but due date is empty', () {
          service.billDateController.text = DateTime.now().toString();
          service.dueDateController.text = "";
          expect(!service.validateDates(), true);
        });

        test('Validation should pass when bill date is empty and due date is empty', () {
          service.billDateController.text = "";
          expect(!service.validateDates(), true);
        });

        test('Validation should fail when bill date is empty but due date is not empty', () {
          service.billDateController.text = "";
          service.dueDateController.text = DateTime.now().toString();
          expect(!service.validateDates(), false);
        });

        test('Validation should pass when bill date and due date are same', () {
          service.billDateController.text = DateTime.now().toString();
          service.dueDateController.text = DateTime.now().toString();
          expect(!service.validateDates(), true);
        });
      });
    });

  });

  ////////////////////    CREATE INVOICE TEST CASES    ////////////////////
  
  group('In case of create invoice', () {
    InvoiceFormService service = InvoiceFormService(
      update: () {},
      validateForm: () {},
      jobId: tempJob.id,
      orderId: tempFinancialModel.id,
      pageType: InvoiceFormType.invoiceCreateForm,
    );

    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      service.jobModel = tempJob;
      service.singleSelectTaxList = tempTaxList;
      service.divisionsList = tempDivisionList;
      service.controller = InvoiceFormController();
      tempInitialJson = service.getFormJson(canAddDefaultItem: false);
      service.leapPayPreferencesController = LeapPayPreferencesController();
    });

    group('InvoiceFormService@checkIfNewDataAdded() should check if any addition/update is made in form', () {
      JPSingleSelectModel? initialSelectedProduct;
      test('When no changes in form are made', () {
        final val = service.checkIfNewDataAdded();
        expect(val, true);
      });

      test('When changes in form are made', () {
        service.selectedDivision = tempDivisionList[0];
        final val = service.checkIfNewDataAdded();
        expect(val, true);
      });

      test('When changes are reverted', () {
        service.selectedDivision = initialSelectedProduct;
        final val = service.checkIfNewDataAdded();
        expect(val, true);
      });
    });

    group('In case of default job trade/work type for invoices', () {
      group('When default job trade/work type for invoice is enabled', () {
        
        service.jobModel = tempJob;

        test('When InvoiceFormService@jobModel contains only one trade/work type', () {

          CompanySettingsService.companySettings[CompanySettingConstants.defaultJobTradeWorkTypeOnInvoices] = {"id": 5679, "name": "JOBS_INVOICE_TRADE_WORK_TYPE", "key": "DEFAULT_TO_JOBS_TRADE_WORK_TYPE_ON_INVOICES", "value": 1, "user_id": 0, "company_id": 15012};

          service.setFormData();
          expect(service.invoiceItems.first.tradeType?.id, service.jobModel?.trades?.first.id.toString());
          expect(service.invoiceItems.first.workType?.id, service.jobModel?.workTypes?.first?.id.toString());
        });

        test('When InvoiceFormService@jobModel contains multiple trade/work type', () {
          service.jobModel?.trades?.add(CompanyTradesModel(
            id: 12,
            name: "Trade - 1",
          ));
          service.jobModel?.workTypes?.add(JobTypeModel(
            id: 11,
            name: "Work Type - 1",
            tradeId: 12
          ));
          service.invoiceItems = [];
          service.setFormData();
          expect(service.invoiceItems.first.tradeType?.id, null);
          expect(service.invoiceItems.first.workType?.id, null);
        });

        test('When default job trade/work type for invoice is disabled', () {
          CompanySettingsService.companySettings[CompanySettingConstants.defaultJobTradeWorkTypeOnInvoices] = {"id": 5679, "name": "JOBS_INVOICE_TRADE_WORK_TYPE", "key": "DEFAULT_TO_JOBS_TRADE_WORK_TYPE_ON_INVOICES", "value": 0, "user_id": 0, "company_id": 15012};
          service.invoiceItems = [];
          service.jobModel = tempJob;
          service.setFormData();
          expect(service.invoiceItems.first.tradeType?.id, null);
          expect(service.invoiceItems.first.workType?.id, null);
        });
        
      });

    test('Default Selected Leap pay setting should be set', () {
      CompanySettingsService.companySettings = {
        CompanySettingConstants.defaultLeapPayPaymentMethod : {"value": "card_and_ach",}
      };
      service.leapPayPreferencesController.setLeapPayPreferences();
      expect(service.leapPayPreferencesController.acceptingLeapPay, isTrue);
      expect(service.leapPayPreferencesController.isCardEnabled, isTrue);
      expect(service.leapPayPreferencesController.isAchEnabled, isTrue);
      expect(service.leapPayPreferencesController.isFeePassoverEnabled, isFalse);
    });
    
    group('Payment Setting section should be visible', () {
      
      test('When leap pay is enabled', () {
        ConnectedThirdPartyService.connectedThirdParty = {
          ConnectedThirdPartyConstants.leapPay: {'status': 'enabled'},
        };
        CompanySettingsService.companySettings = {
          CompanySettingConstants.defaultPaymentOption : {"value": "leappay",}
        };
        service.financialListingModel = tempModel;
        service.invoiceItems = tempLineItems;
        expect(service.doShowPaymentPreferences, isTrue);
      });

    });

    group('Payment Setting section should not be visible', () {
      
        test('When leap pay is disabled', () {
          ConnectedThirdPartyService.connectedThirdParty.clear();
          service.financialListingModel = tempModel;
          service.invoiceItems = tempLineItems;
          expect(service.doShowPaymentPreferences, isFalse);
        });

      });
    });

  });

  ////////////////////    UPDATE CHANGE ORDER TEST CASES    ////////////////////

  group('In case of update change order', () {
    InvoiceFormService service = InvoiceFormService(
      update: () {},
      validateForm: () {},
      jobId: tempJob.id,
      orderId: tempFinancialModel.id,
      pageType: InvoiceFormType.changeOrderEditForm,
    );

    setUpAll(() {
      service.jobModel = tempJob;
      service.financialListingModel = tempFinancialModel;
      service.singleSelectTaxList = tempTaxList;
      service.divisionsList = tempDivisionList;
      service.controller = InvoiceFormController();
      service.setFormData();
      service.initialJson = service.getFormJson();
      tempInitialJson = service.getFormJson()..["taxable"] = service.getIsTaxable() ? 1 : 0;
    });

    group('InvoiceFormService should be initialized with correct data', () {
      test('Form fields should be initialized with correct values', () {
        expect(service.titleController.text, "My Invoice");
        expect(service.billDateController.text, "");
        expect(service.dueDateController.text, "");
        expect(service.unitController.text, "1234");
        expect(service.divisionController.text, "North India");
      });

      test('Form data helpers should be initialized with correct values', () {
        expect(service.jobModel != null, true);
        expect(service.initialJson, tempInitialJson);
        expect(service.isTaxable, true);
        expect(service.taxRate, 8.3);
        expect(service.revisedTaxRate, 15);
        expect(service.totalInvoicePrice, 0);
        expect(service.itemsTotalPrice, 0);
        expect(service.totalTaxAmount, 0);
        expect(service.totalTaxableAmount, 0);
        expect(service.totalTaxableItems, 0);
        expect(service.noChargeItemsTotal, 0);
      });

      test('InvoiceFormService@setFormData() should set-up form values', () {
        service.setFormData();
        expect(service.initialJson, tempInitialJson);
      });

      test('InvoiceFormService@checkIfNewDataAdded() should calculate initial order price', () {
        service.calculateTotalPrice();
        expect(service.taxRate, 8.3);
        expect(service.revisedTaxRate, 15);
        expect(service.totalInvoicePrice, 41.154);
        expect(service.itemsTotalPrice, 138);
        expect(JobFinancialHelper.getRoundOff(service.totalTaxAmount), "3.154");
        expect(service.totalTaxableAmount, 38);
        expect(service.totalTaxableItems, 2);
        expect(service.noChargeItemsTotal, 100);
      });

      group('InvoiceFormService@checkIfNewDataAdded() should check if any addition/update is made in form', () {
        JPSingleSelectModel? initialSelectedProduct;
        test('When no changes in form are made', () {
          service.initialJson = service.getFormJson();
          initialSelectedProduct = service.selectedDivision;
          final val = service.checkIfNewDataAdded();
          expect(val, false);
        });

        test('When changes in form are made', () {
          service.selectedDivision = tempDivisionList[0];
          final val = service.checkIfNewDataAdded();
          expect(val, true);
        });

        test('When changes are reverted', () {
          service.selectedDivision = initialSelectedProduct;
          final val = service.checkIfNewDataAdded();
          expect(val, false);
        });
      });

    });

    group('InvoiceFormService@isNoChargeItemAvailable() should check item has No charge item or not', () {
      test('In case No charge item is available ', () {
        expect(service.isNoChargeItemAvailable(), isTrue);
      });

      test('In case No charge item is not available ', () {
        service.invoiceItems.removeWhere((element) => element.productCategorySlug == FinancialConstant.noCharge);
        expect(service.isNoChargeItemAvailable(), isFalse);
        service.invoiceItems = tempFinancialModel.lines!;
      });
    });
  });

  group("InvoiceFormService@getSupplierDetails should return supplier details", () {
    test('Returns SRS branch details when SRS is enabled', () {
      data.isSRSEnable = true;
      data.selectedSrsBranch = SupplierBranchModel(
          name: 'BRANCH_NAME',
          branchCode: '300'
      );
      expect(data.getSupplierDetails, contains('SRS branch: BRANCH_NAME (300)'));
    });

    test('Returns Beacon branch details when Beacon is enabled', () {
      data.isSRSEnable = false;
      data.isBeaconEnable = true;
      data.selectedBeaconBranch = SupplierBranchModel(
          name: 'BRANCH_NAME',
          branchCode: '300'
      );
      expect(data.getSupplierDetails, contains('qxo branch: BRANCH_NAME (300)'));
    });

    test('Returns empty string when neither SRS nor Beacon is enabled', () {
      data.isSRSEnable = false;
      data.isBeaconEnable = false;
      expect(data.getSupplierDetails, isEmpty);
    });
  });

  test('InvoiceFormService@resetSupplier should resets all supplier details when called', () {
    tempFinancialModel.srsShipToAddressModel = SrsShipToAddressModel();
    tempFinancialModel.beaconAccountModel = BeaconAccountModel();
    tempFinancialModel.beaconJob = BeaconJobModel();
    tempFinancialModel.supplierBranch = SupplierBranchModel();
    tempService.isSRSEnable = true;
    tempService.isBeaconEnable = true;

    tempService.resetSupplier();

    expect(tempService.selectedSrsShipToAddress, isNull);
    expect(tempService.selectedSrsBranch, isNull);
    expect(tempService.selectedBeaconAccount, isNull);
    expect(tempService.selectedBeaconBranch, isNull);
    expect(tempService.isSRSEnable, isFalse);
    expect(tempService.isBeaconEnable, isFalse);
  });

  group('InvoiceFormService@getActiveSupplierId should give the active supplier ID', () {
    test('Returns SRS supplier ID when SRS is enabled', () {
      tempService.isSRSEnable = true;
      tempService.isBeaconEnable = false;
      String? supplierId = tempService.getActiveSupplierId();
      expect(supplierId, equals(CommonConstants.srsId));
    });

    test('Returns Beacon supplier ID when Beacon is enabled', () {
      tempService.isSRSEnable = false;
      tempService.isBeaconEnable = true;
      String? supplierId = tempService.getActiveSupplierId();
      expect(supplierId, equals(CommonConstants.beaconId));
    });

    test('Returns null when neither SRS nor Beacon is enabled', () {
      tempService.isSRSEnable = false;
      tempService.isBeaconEnable = false;
      String? supplierId = tempService.getActiveSupplierId();
      expect(supplierId, isNull);
    });
  });

  group('InvoiceFormService@getSelectedBranch should give the branch as per active supplier', () {
    setUp(() {
      tempService.selectedSrsBranch = SupplierBranchModel();
      tempService.selectedBeaconBranch = SupplierBranchModel();
    });

    test('Returns selected SRS branch when SRS is enabled', () {
      tempService.isSRSEnable = true;
      SupplierBranchModel? branch = tempService.getSelectedBranch();
      expect(branch, equals(tempService.selectedSrsBranch));
      tempService.isSRSEnable = false;
    });

    test('Returns selected Beacon branch when Beacon is enabled', () {
      tempService.isBeaconEnable = true;
      SupplierBranchModel? branch = tempService.getSelectedBranch();
      expect(branch, equals(tempService.selectedBeaconBranch));
      tempService.isBeaconEnable = false;
    });

    test('Returns null when neither SRS nor Beacon is enabled', () {
      tempService.isSRSEnable = false;
      tempService.isBeaconEnable = false;
      SupplierBranchModel? branch = tempService.getSelectedBranch();
      expect(branch, isNull);
    });
  });

  group('InvoiceFormService@setSupplierDetails should set supplier details as per supplier type', () {
    setUp(() {
      tempFinancialModel.srsShipToAddressModel = SrsShipToAddressModel();
      tempFinancialModel.beaconAccountModel = BeaconAccountModel();
      tempFinancialModel.beaconJob = BeaconJobModel();
      tempFinancialModel.supplierBranch = SupplierBranchModel();
      tempService.financialListingModel = tempFinancialModel;
    });

    test('Does not set any details when neither SRS nor Beacon supplier is activated for worksheet', () {
      tempFinancialModel.supplierType = null;
      tempService.setSupplierDetails();
      expect(tempService.isSRSEnable, isFalse);
      expect(tempService.isBeaconEnable, isFalse);
      expect(tempService.selectedSrsBranch, isNull);
      expect(tempService.selectedSrsShipToAddress, isNull);
      expect(tempService.selectedBeaconBranch, isNull);
      expect(tempService.selectedBeaconAccount, isNull);
    });

    test('Sets SRS details when SRS supplier is activated for worksheet', () {
      tempFinancialModel.supplierType = MaterialSupplierType.srs;
      tempService.setSupplierDetails();
      expect(tempService.isSRSEnable, isTrue);
      expect(tempService.selectedSrsBranch, equals(tempFinancialModel.supplierBranch));
      expect(tempService.selectedSrsShipToAddress, equals(tempFinancialModel.srsShipToAddressModel));
    });

    test('Sets Beacon details when Beacon supplier is activated for worksheet', () {
      tempFinancialModel.supplierType = MaterialSupplierType.beacon;
      tempService.setSupplierDetails();
      expect(tempService.isBeaconEnable, isTrue);
      expect(tempService.selectedBeaconBranch, equals(tempFinancialModel.supplierBranch));
      expect(tempService.selectedBeaconAccount, equals(tempFinancialModel.beaconAccountModel));
    });
  });

  group('InvoiceFormService@setSupplier should set supplier', () {
    test("Supplier type should be SRS when Ship To Address is available", () {
      tempFinancialModel.setSupplier({
        'srs_ship_to_address': SrsShipToAddressModel().toJson(),
      });
      expect(tempFinancialModel.supplierType, MaterialSupplierType.srs);
    });

    test("Supplier type should be Beacon when Account is available", () {
      tempFinancialModel.setSupplier({
        'beacon_account': BeaconAccountModel().toJson(),
      });
      expect(tempFinancialModel.supplierType, MaterialSupplierType.beacon);
    });

    test("Supplier type should be null when neither SRS nor Beacon is available", () {
      tempFinancialModel.setSupplier({});
      expect(tempFinancialModel.supplierType, isNull);
    });
  });

  group("InvoiceFormService@getRemoveSupplierConfirmation should show remove supplier confirmation before removing all supplier products", () {
    group("In case of Change Order Form", () {
      setUp(() {
        tempService.pageType = InvoiceFormType.changeOrderEditForm;
      });

      test("Switching from SRS to Beacon when SRS products are added", () {
        tempService.isSRSEnable = true;
        tempService.invoiceItems = [
          lineItem..supplier = SuppliersModel(
              id: Helper.getSupplierId(key: CommonConstants.srsId)
          )
        ];
        final result = tempService.getRemoveSupplierConfirmation(makeProductCheck: true);
        expect(result, 'deactivate_srs_dialog_with_products_message_change_order'.tr);
        tempService.isSRSEnable = false;
      });

      test("Switching from SRS to Beacon when SRS products are not added", () {
        tempService.isSRSEnable = true;
        tempService.invoiceItems = [
          lineItem..supplier = SuppliersModel(id: null)
        ];
        final result = tempService.getRemoveSupplierConfirmation(makeProductCheck: true);
        expect(result, 'deactivate_srs_dialog_message_change_order'.tr);
        tempService.isSRSEnable = false;
      });

      test("Switching from Beacon to SRS when Beacon products are added", () {
        tempService.isBeaconEnable = true;
        tempService.invoiceItems = [
          lineItem..supplier = SuppliersModel(
              id: Helper.getSupplierId(key: CommonConstants.beaconId)
          )
        ];
        final result = tempService.getRemoveSupplierConfirmation(makeProductCheck: true);
        expect(result, 'deactivate_beacon_dialog_with_products_message_change_order'.tr);
        tempService.isBeaconEnable = false;
      });

      test("Switching from Beacon to SRS when Beacon products are not added", () {
        tempService.isBeaconEnable = true;
        tempService.invoiceItems = [
          lineItem..supplier = SuppliersModel(
              id: Helper.getSupplierId(key: null)
          )
        ];
        final result = tempService.getRemoveSupplierConfirmation(makeProductCheck: true);
        expect(result, 'deactivate_beacon_dialog_message_change_order'.tr);
        tempService.isBeaconEnable = false;
      });
    });

    group("In case of Invoice Form", () {
      setUp(() {
        tempService.pageType = InvoiceFormType.invoiceCreateForm;
      });

      test("Switching from SRS to Beacon when SRS products are added", () {
        tempService.isSRSEnable = true;
        tempService.invoiceItems = [
          lineItem..supplier = SuppliersModel(
              id: Helper.getSupplierId(key: CommonConstants.srsId)
          )
        ];
        final result = tempService.getRemoveSupplierConfirmation(makeProductCheck: true);
        expect(result, 'deactivate_srs_dialog_with_products_message_invoice'.tr);
        tempService.isSRSEnable = false;
      });

      test("Switching from SRS to Beacon when SRS products are not added", () {
        tempService.isSRSEnable = true;
        tempService.invoiceItems = [
          lineItem..supplier = SuppliersModel(id: null)
        ];
        final result = tempService.getRemoveSupplierConfirmation(makeProductCheck: true);
        expect(result, 'deactivate_srs_dialog_message_invoice'.tr);
        tempService.isSRSEnable = false;
      });

      test("Switching from Beacon to SRS when Beacon products are added", () {
        tempService.isBeaconEnable = true;
        tempService.invoiceItems = [
          lineItem..supplier = SuppliersModel(
              id: Helper.getSupplierId(key: CommonConstants.beaconId)
          )
        ];
        final result = tempService.getRemoveSupplierConfirmation(makeProductCheck: true);
        expect(result, 'deactivate_beacon_dialog_with_products_message_invoice'.tr);
        tempService.isBeaconEnable = false;
      });

      test("Switching from Beacon to SRS when Beacon products are not added", () {
        tempService.isBeaconEnable = true;
        tempService.invoiceItems = [
          lineItem..supplier = SuppliersModel(
              id: Helper.getSupplierId(key: null)
          )
        ];
        final result = tempService.getRemoveSupplierConfirmation(makeProductCheck: true);
        expect(result, 'deactivate_beacon_dialog_message_invoice'.tr);
        tempService.isBeaconEnable = false;
      });
    });
  });

  group("InvoiceFormService@setUpSupplier should set up supplier when activated", () {
    group("When SRS supplier is activated", () {
      setUp(() {
        tempService.resetSupplier();
        tempService.setUpSupplier(MaterialSupplierType.srs, MaterialSupplierFormParams(
          type: MaterialSupplierType.srs,
          srsShipToAddress: SrsShipToAddressModel(),
          srsBranch: SupplierBranchModel(),
        ));
      });

      test("SRS should be enabled with SRS details", () {
        expect(tempService.isSRSEnable, isTrue);
        expect(tempService.selectedSrsShipToAddress, isNotNull);
        expect(tempService.selectedSrsBranch, isNotNull);
      });

      test("Beacon details should be removed", () {
        expect(tempService.selectedBeaconAccount, isNull);
        expect(tempService.selectedBeaconBranch, isNull);
      });
    });

    group("When Beacon supplier is activated", () {
      setUp(() {
        tempService.resetSupplier();
        tempService.setUpSupplier(MaterialSupplierType.beacon, MaterialSupplierFormParams(
          type: MaterialSupplierType.beacon,
          beaconAccount: BeaconAccountModel(),
          beaconBranch: SupplierBranchModel(),
          beaconJob: BeaconJobModel(),
        ));
      });

      test("Beacon should be enabled with Beacon details", () {
        expect(tempService.isBeaconEnable, isTrue);
        expect(tempService.selectedBeaconAccount, isNotNull);
        expect(tempService.selectedBeaconBranch, isNotNull);
      });

      test("SRS details should be removed", () {
        expect(tempService.selectedSrsShipToAddress, isNull);
        expect(tempService.selectedSrsBranch, isNull);
      });
    });
  });

  group("InvoiceFormService@removeSupplierProducts should remove supplier products from the selected products", () {
    setUp(() {
      tempService.invoiceItems = [
        lineItem..supplier = null,
        lineItem2..supplier = SuppliersModel(id: Helper.getSupplierId(key: CommonConstants.srsId)),
        lineItem3..supplier = SuppliersModel(id: Helper.getSupplierId(key: CommonConstants.beaconId)),
        lineItem4..supplier = SuppliersModel(id: Helper.getSupplierId(key: CommonConstants.abcSupplierId)),
      ];
    });

    test("When SRS is enabled", () {
      tempService.isSRSEnable = true;
      tempService.isBeaconEnable = false;
      tempService.isAbcEnable = false;
      tempService.removeSupplierProducts();
      expect(tempService.invoiceItems.length, 2);
    });

    test("When Beacon is enabled", () {
      tempService.isSRSEnable = false;
      tempService.isBeaconEnable = true;
      tempService.isAbcEnable = false;
      tempService.removeSupplierProducts();
      expect(tempService.invoiceItems.length, 2);
    });

    test("When ABC is enabled", () {
      tempService.isSRSEnable = false;
      tempService.isBeaconEnable = false;
      tempService.isAbcEnable = true;
      tempService.removeSupplierProducts();
      expect(tempService.invoiceItems.length, 2);
    });
  });

  group('InvoiceFormService@getSelectedSupplier should give the selected material supplier type based on the enabled supplier', () {
    test('Returns MaterialSupplierType.srs when SRS is enabled', () {
      tempService.isSRSEnable = true;
      MaterialSupplierType? supplier = tempService.getSelectedSupplier();
      expect(supplier, equals(MaterialSupplierType.srs));
      tempService.isSRSEnable = false;
    });

    test('Returns MaterialSupplierType.beacon when Beacon is enabled', () {
      tempService.isBeaconEnable = true;
      MaterialSupplierType? supplier = tempService.getSelectedSupplier();
      expect(supplier, equals(MaterialSupplierType.beacon));
      tempService.isBeaconEnable = false;
    });

    test('Returns MaterialSupplierType.abc when ABC is enabled', () {
      tempService.isAbcEnable = true;
      MaterialSupplierType? supplier = tempService.getSelectedSupplier();
      expect(supplier, equals(MaterialSupplierType.abc));
      tempService.isAbcEnable = false;
    });

    test('Returns null when neither SRS nor Beacon and ABC is enabled', () {
      tempService.isSRSEnable = false;
      tempService.isBeaconEnable = false;
      tempService.isAbcEnable = false;
      MaterialSupplierType? supplier = tempService.getSelectedSupplier();
      expect(supplier, isNull);
    });
  });

  group("InvoiceFormService@removeSupplier should remove selected supplier", () {
    group('In case SRS is selected as supplier', () {
      setUp(() {
        tempService.selectedSrsBranch = SupplierBranchModel(name: 'Branch', branchCode: '123');
        tempService.invoiceItems = [
          lineItem..product = FinancialProductModel(notAvailable: true, notAvailableInPriceList: true),
          lineItem..product = FinancialProductModel(notAvailable: false, notAvailableInPriceList: false),
        ];
        tempService.selectedSrsShipToAddress = SrsShipToAddressModel();
        tempService.removeSupplier();
      });

      test("Selected SRS branch should be removed", () {
        expect(tempService.selectedSrsBranch, isNull);
      });

      test("Selected SRS ship to address should be removed", () {
        expect(tempService.selectedSrsShipToAddress, isNull);
      });

      test("SRS toggle should be disabled", () {
        expect(tempService.isSRSEnable, isFalse);
      });

      test("SRS product availability should be removed from line items", () {
        expect(tempService.invoiceItems[0].product?.notAvailable, isFalse);
        expect(tempService.invoiceItems[0].product?.notAvailableInPriceList, isFalse);
      });
    });

    group('In case Beacon is selected as supplier', () {
      setUp(() {
        tempService.invoiceItems = [
          lineItem..product = FinancialProductModel(notAvailable: true, notAvailableInPriceList: true),
          lineItem..product = FinancialProductModel(notAvailable: false, notAvailableInPriceList: false),
        ];
        tempService.selectedBeaconAccount = BeaconAccountModel(name: 'Account');
        tempService.selectedBeaconBranch = SupplierBranchModel(name: 'Branch', branchCode: '123');
        tempService.removeSupplier();
      });

      test("Selected Beacon branch should be removed", () {
        expect(tempService.selectedBeaconBranch, isNull);
      });

      test("Selected Beacon account should be removed", () {
        expect(tempService.selectedBeaconAccount, isNull);
      });

      test("Beacon toggle should be disabled", () {
        expect(tempService.isBeaconEnable, isFalse);
      });
    });

    group('In case ABC selected as supplier', () {
      setUp(() {
        tempService.selectedAbcBranch = SupplierBranchModel(name: 'Branch', branchCode: '123');
        tempService.invoiceItems = [
          lineItem..product = FinancialProductModel(notAvailable: true, notAvailableInPriceList: true),
          lineItem..product = FinancialProductModel(notAvailable: false, notAvailableInPriceList: false),
        ];
        tempService.selectedAbcAccount = SrsShipToAddressModel();
        tempService.removeSupplier();
      });

      test("Selected ABC branch should be removed", () {
        expect(tempService.selectedAbcBranch, isNull);
      });

      test("Selected ABC account should be removed", () {
        expect(tempService.selectedAbcAccount, isNull);
      });

      test("ABC toggle should be disabled", () {
        expect(tempService.isAbcEnable, isFalse);
      });

      test("ABC product availability should be removed from line items", () {
        expect(tempService.invoiceItems[0].product?.notAvailable, isFalse);
        expect(tempService.invoiceItems[0].product?.notAvailableInPriceList, isFalse);
      });
    });
  });

  group('InvoiceFormData@isUpdateJobPrice Should return 1 when the invoice total price is greater than the job invoice amount minus the job amount, otherwise return 0.', () {
    test('Should return 1 when the invoice total price greater than the job invoice amount minus the job amount', () {
      data.totalInvoicePrice = 100;
      data.jobModel = JobModel(amount: "50", financialDetails: FinancialDetailModel(jobInvoiceAmount: 20), id: 1, customerId: 1);
      expect(data.isUpdateJobPrice(), 1);
    });

    test('Should return 1 when the invoice total price equals the job invoice amount minus the job amount', () {
      data.totalInvoicePrice = 70;
      data.jobModel = JobModel(amount: "40", financialDetails: FinancialDetailModel(jobInvoiceAmount: 30), id: 1, customerId: 1);
      expect(data.isUpdateJobPrice(), 1);
    });

    test('Should return 1 if the job invoice amount is unavailable, and the invoice total price is greater than the job amount', () {
      data.totalInvoicePrice = 70;
      data.jobModel = JobModel(amount: "40", financialDetails: FinancialDetailModel(jobInvoiceAmount: null), id: 1, customerId: 1);
      expect(data.isUpdateJobPrice(), 1);
    });

    test('Should return 0 when the invoice total price is less than the job invoice amount minus the job amount', () {
      data.totalInvoicePrice = 50;
      data.jobModel = JobModel(amount: "70", financialDetails: FinancialDetailModel(jobInvoiceAmount: 10), id: 1, customerId: 1);
      expect(data.isUpdateJobPrice(), 0);
    });
  });

  group('InvoiceFormData@setSRSSupplierId Should set srsSupplierId', () {
    setUp(() {
      data.financialListingModel?.suppliers = [SuppliersModel()];
      data.srsSupplierId = null;
    });
    test('In case suppliers list is not empty and supplier has valid SRS id', () {
      data.financialListingModel?.suppliers?.first.id = 3;

      data.setSRSSupplierId();

      expect(data.srsSupplierId, 3);
    });

    test('In case suppliers list is empty', () {
      data.financialListingModel?.suppliers = [];

      data.setSRSSupplierId();

      expect(data.srsSupplierId, 3);
    });

    test('In case SRS supplier id is not a valid SRS id', () {
      data.financialListingModel?.suppliers?.first.id = 2; // Non-SRS id

      data.setSRSSupplierId();

      expect(data.srsSupplierId, 3);
    });

    test('In case SRS supplier id is already set', () {
      data.srsSupplierId = 3;
      data.financialListingModel?.suppliers?.first.id = 3; // Non-SRS id

      data.setSRSSupplierId();

      expect(data.srsSupplierId, 3);
    });

  });
}