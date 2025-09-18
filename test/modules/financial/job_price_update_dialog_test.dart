import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job_financial/job_price_dialog_model.dart';
import 'package:jobprogress/common/models/job_financial/tax_model.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/modules/job_financial/widgets/job_price_dialog/controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Map<String, dynamic> userJson = {
    "data":{
      "id":19749,
      "customer_id":32428,
      "description":"sachin",
      "same_as_customer_address":1,
      "amount":"100000",
      "other_trade_type_description":null,
      "created_by":1,
      "taxable":1,
      "tax_rate":"15",
      "insurance":0,
      "quickbook_id":0,
      "job_amount_approved_by":null,
      "display_order":0,
      "ghost_job":null,
      "quickbook_sync_status":null,
      "qb_desktop_id":"",
      "multi_job":0,
      "address":{
        "id":46650,
        "state_id":0,
        "state":null,
        "country_id":1,
        "country":{
          "id":1,
          "name":"United States",
          "code":"US",
          "currency_name":"Doller",
          "currency_symbol":"\$",
          "phone_code":"+91"
        },
        "zip":null,
        "lat":null,
        "long":null,
        "geocoding_error":1,
        "created_by":1,
        "updated_by":1,
        "state_tax":{
          "tax_rate":"3.25"
        }
      },
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
      "job_invoices":{
        "data":[
          {
            "id":1496,
            "customer_id":3063,
            "job_id":2366,
            "total_amount":209.77,
          },
          {
            "id":1497,
            "customer_id":3063,
            "job_id":2366,
            "total_amount":852.56,
          },
          {
            "id":1498,
            "customer_id":3063,
            "job_id":2366,
            "total_amount":494.2,
          }
        ]
      },
      "meta":{
        "resource_id":"313869",
        "default_photo_dir":"313883",
        "sub_contractor":"313914"
      },
      "current_stage":{
        "name":"Lead",
        "color":"cl-red",
        "code":"926495638",
        "resource_id":11
      }
    },
  };

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

  Map<String, dynamic> quickBookList = {'quickbook': {'quickbook_company_id': 1, 'only_one_way_sync': false}, 'quickbook_pay': {'quickbooks_payments_connected': 0}, 'quickbook_desktop': false, 'quickmeasure': {'quickmeasure_account_id': 'gigi@gaf-uattigerteamroofing.com'}};

  Map<String, dynamic> quickBookListNull = {'quickbook': null, 'quickbook_pay': null, 'quickbook_desktop': false, 'quickmeasure': {'quickmeasure_account_id': 'gigi@gaf-uattigerteamroofing.com'}};

  group('For updating job price', () {
    JobModel jobModel = JobModel.fromJson(userJson['data']);
    final controller = JobPriceDialogController(jobModel: jobModel);

    test('To pre-fill values obtained from previous screen one should call setDefaultKeys method', () {
      controller.setDefaultKeys(JobPriceDialogModel(
        jobId : jobModel.id,
        taxable: jobModel.taxable ?? 0,
        amount: double.parse(jobModel.amount?.toString() ?? ""),
        total: JobFinancialHelper.getTotalPrice(jobModel),
        taxRate: num.tryParse(jobModel.taxRate?.toString() ?? ""),
      ));
      expect(controller.jobPriceModel.amount, 100000.0);
      expect(controller.jobPriceModel.total, 115000);
      expect(controller.jobPriceModel.taxRate, 15);
      expect(controller.jobPriceModel.taxAmount, 15000.0);
      expect(controller.amountController.text, "100000");
      expect(controller.totalJobPriceController.text, "115000");
    });

    test('onAmountTextChange method should be called when amount changes in amount text field', () {
      controller.onAmountTextChange("23434.00");
      expect(controller.jobPriceModel.amount, 23434.0);
      expect(controller.jobPriceModel.total, 26949.10);
      expect(controller.jobPriceModel.taxRate, 15);
      expect(controller.jobPriceModel.taxAmount, 3515.10);
      expect(controller.totalJobPriceController.text, "26949.1");
    });

    test('onTotalPriceTextChange method should be called when amount changes in total jop price text field', () {
      controller.onTotalPriceTextChange("23434.00");
      expect(controller.jobPriceModel.amount, 19918.9);
      expect(controller.jobPriceModel.total, 23434.0);
      expect(controller.jobPriceModel.taxRate, 15);
      expect(controller.jobPriceModel.taxAmount, 3515.10);
      expect(controller.amountController.text, "19918.9");
    });

    test('To get tax rate, that is to be applied on job price. One should use getTaxRate method', () {
      expect(controller.getTaxRate(jobModel), 15);
    });

    test('To obtain revised tax rate, that is to be applied on job price. One should use getTaxRate method along with (isRevised: true) as an argument', () {
      expect(controller.getTaxRate(jobModel, isRevised: true), 3.25);
    });

    //////////////////////    TAX RATE CALCULATION TEST   //////////////////////

    test('JobPriceDialogController@getTaxRate should return 5, when QuickBooks is connected and the job has a custom tax rate', () {
      ConnectedThirdPartyService.setConnectedParty(quickBookList);
      jobModel.customTax = TaxModel(taxRate: 5);
      expect(controller.getTaxRate(jobModel), 5);
    });

    test("JobPriceDialogController@getTaxRate should return 0, when QuickBooks is connected and there is no custom tax rate in the job", () {
      ConnectedThirdPartyService.setConnectedParty(quickBookList);
      jobModel.customTax = null;
      expect(controller.getTaxRate(jobModel), 0);
    });

    test("JobPriceDialogController@getTaxRate should return 15, when QuickBooks is not connected and job has tax rate", () {
      ConnectedThirdPartyService.setConnectedParty(quickBookListNull);
      expect(controller.getTaxRate(jobModel), 15);
    });

    test("JobPriceDialogController@getTaxRate should return 10, when QuickBooks isn't connected and the job doesn't have a tax rate, but its parent job has state taxes", () {
      ConnectedThirdPartyService.setConnectedParty(quickBookListNull);
      jobModel.taxRate = null;
      jobModel.parent = JobModel(id: 0, customerId: 0, address: AddressModel(id: 0, stateTax: 10));
      expect(controller.getTaxRate(jobModel), 10);
      jobModel.parent = null;
    });

    test("JobPriceDialogController@getTaxRate should return 5, when QuickBook isn't connected and job doesn't have tax rate", () {
      ConnectedThirdPartyService.setConnectedParty(quickBookListNull);
      jobModel.taxRate = null;
      expect(controller.getTaxRate(jobModel), 3.25);
    });

    test("JobPriceDialogController@getTaxRate should return 5, when QuickBook isn't connected and job doesn't have tax rate but has state tax", () {
      ConnectedThirdPartyService.setConnectedParty(quickBookListNull);
      jobModel.taxRate = null;
      jobModel.address = AddressModel(id: 0, stateTax: 5);
      expect(controller.getTaxRate(jobModel), 5);
    });

    test("JobPriceDialogController@getTaxRate should return 0, when QuickBook isn't connected and job doesn't tax rate and company also doesn't has some own tax", () {
      ConnectedThirdPartyService.setConnectedParty(quickBookListNull);
      jobModel.taxRate = null;
      jobModel.address?.stateTax = null;
      expect(controller.getTaxRate(jobModel), 0);
    });

    test("JobPriceDialogController@getTaxRate should return 5, when QuickBook isn't connected and job doesn't tax rate but company has some own tax", () {
      ConnectedThirdPartyService.setConnectedParty(quickBookListNull);
      CompanySettingsService.setCompanySettings(companySettingJson["data"]);
      jobModel.taxRate = null;
      jobModel.address?.stateTax = null;
      expect(controller.getTaxRate(jobModel), 5);
    });

    ///////////////////////////////    VALIDATIONS   ///////////////////////////

    test('JobPriceDialogController@getTotalInvoiceAmount should return sum of all invoices in a job', () {
      controller.jobModel = jobModel;
      expect(controller.getTotalInvoiceAmount(), 1556.53);
    });

    test('JobPriceDialogController@compareJobPriceVsInvoicesSum should return true, if JobPrice entered by user is less then sum of all invoices', () {
      controller.jobModel = jobModel;
      controller.jobPriceModel.total = 100;
      expect(controller.compareJobPriceVsInvoicesSum, true);
    });

    test('JobPriceDialogController@compareJobPriceVsInvoicesSum should return false, if JobPrice entered by user is greater then sum of all invoices', () {
      controller.jobModel = jobModel;
      controller.jobPriceModel.total = 2000;
      expect(controller.compareJobPriceVsInvoicesSum, false);
    });

    test('JobPriceDialogController@isTryingToChangeTaxable should return false, if user is not trying to change Taxable', () {
      controller.jobModel = jobModel;
      controller.defaultJobPriceModel.taxable = 1;
      controller.jobPriceModel.taxable = 1;
      expect(controller.isTryingToChangeTaxable, false);
    });

    test('JobPriceDialogController@isTryingToChangeTaxable should return true, if user trying to change Taxable', () {
      controller.jobModel = jobModel;
      controller.defaultJobPriceModel.taxable = 1;
      controller.jobPriceModel.taxable = 0;
      expect(controller.isTryingToChangeTaxable, true);
    });

    ////////////////////////    ROUND-OFF METHOD TEST   ////////////////////////

    test('calculate round off of without decimal value', () {
      expect(JobFinancialHelper.getRoundOff(123456), "123456");
      expect(JobFinancialHelper.getRoundOff(123000), "123000");
      expect(JobFinancialHelper.getRoundOff(123001), "123001");
    });

    test('calculate round off for 1 value after decimal', () {
      expect(JobFinancialHelper.getRoundOff(123.0), "123");
      expect(JobFinancialHelper.getRoundOff(123.4), "123.4");
      expect(JobFinancialHelper.getRoundOff(123.8), "123.8");
    });

    test('calculate round off for 2 values after decimal', () {
      expect(JobFinancialHelper.getRoundOff(123.00), "123");
      expect(JobFinancialHelper.getRoundOff(123.40), "123.4");
      expect(JobFinancialHelper.getRoundOff(123.99), "123.99");
    });

    test('calculate round off for 3 values after decimal', () {
      expect(JobFinancialHelper.getRoundOff(123.000), "123");
      expect(JobFinancialHelper.getRoundOff(123.700), "123.7");
      expect(JobFinancialHelper.getRoundOff(123.750), "123.75");
      expect(JobFinancialHelper.getRoundOff(123.748), "123.748");
      expect(JobFinancialHelper.getRoundOff(123.008), "123.008");
    });

    test('calculate round off for more then 3 values after decimal', () {
      expect(JobFinancialHelper.getRoundOff(123.02016), "123.02");
      expect(JobFinancialHelper.getRoundOff(123.70594), "123.706");
      expect(JobFinancialHelper.getRoundOff(123.3354957), "123.335");
      expect(JobFinancialHelper.getRoundOff(123.999999), "124");
      expect(JobFinancialHelper.getRoundOff(123.15000999), "123.15");
    });

  });
}