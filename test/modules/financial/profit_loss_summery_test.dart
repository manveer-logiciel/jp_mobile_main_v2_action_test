import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job_financial/pl_summary_actual.dart';
import 'package:jobprogress/common/models/job_financial/pl_summary_financial_summary.dart';
import 'package:jobprogress/common/models/job_financial/pl_summary_project.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_model.dart';
import 'package:jobprogress/common/repositories/company_settings.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/modules/job_financial/profit_loss_summary/controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Map<String, dynamic> jobJson = {
    "data":{
      "id":18936,
      "meta":{
        "resource_id":"300885",
        "default_photo_dir":"300899",
        "sub_contractor":"304606"
      },
      "current_stage":{
        "name":"Test Stage",
        "color":"cl-skyblue",
        "code":"16154540781364632269",
        "resource_id":199156
      },
      "change_order":{
        "count":9,
        "total_amount":"4853.25",
        "entities":[
          {
            "amount":null,
            "description":null
          }
        ]
      },
      "has_profit_loss_worksheet":14894,
      "financial_details":{
        "total_job_amount":4564,
        "total_change_order_amount":5005.71,
        "total_amount":9569.71,
        "total_received_payemnt":369.9,
        "total_credits":870,
        "total_refunds":21057,
        "pending_payment":8329.81,
        "total_commission":12151612,
        "job_invoice_amount":0,
        "job_invoice_tax_amount":0,
        "sold_out_date":"2022-08-04",
        "can_block_financials":false,
        "unapplied_credits":759,
        "applied_payment":0,
        "total_account_payable_amount":1101,
        "pending_payment_refund_adjusted":29386.81,
        "is_derived_tax":0
      }
    },
    "status":200

  };

  Map<String, dynamic> worksheetJson = {
    "data":{
      "job_id":18936,
      "job_price":"4564",
      "tax_rate":"",
      "worksheet":{
        "id":14894,
        "job_id":18936,
        "name":"Sheet2",
        "title":null,
        "order":2,
        "overhead":"10",
        "profit":"",
        "type":"profit_loss",
        "taxable":0,
        "tax_rate":null,
        "total":"218000",
        "enable_actual_cost":1,
        "selling_price_total":"-1000",
        "file_path":null,
        "file_size":null,
        "note":null,
        "thumb":null,
        "custom_tax_id":null,
        "hide_pricing":0,
        "show_tier_total":0,
        "enable_selling_price":false,
        "material_tax_rate":null,
        "labor_tax_rate":null,
        "commission":null,
        "re_calculate":false,
        "multi_tier":false,
        "margin":0,
        "created_at":"2022-07-19 05:39:09",
        "updated_at":"2022-08-09 11:00:21",
        "material_custom_tax_id":null,
        "labor_custom_tax_id":null,
        "description_only":0,
        "hide_customer_info":0,
        "show_quantity":0,
        "insurance_meta":null,
        "show_unit":0,
        "line_tax":0,
        "line_margin_markup":0,
        "branch_code":null,
        "ship_to_sequence_number":null,
        "update_tax_order":0,
        "srs_old_worksheet":false,
        "show_calculation_summary":0,
        "sync_on_qbd":false,
        "is_qbd_worksheet":false,
        "pages_exist":0,
        "pages_required":0,
        "collapse_all_line_items":false,
        "show_line_total":false,
        "fixed_price":null,
        "enable_job_commission":1,
        "show_style":false,
        "show_size":false,
        "show_color":false,
        "show_supplier":false,
        "show_trade_type":false,
        "show_work_type":false,
        "show_tier_color":true,
        "hide_total":0,
        "details":[
          {
            "type":"item",
            "data":{
              "id":108879,
              "tier1":null,
              "tier2":null,
              "tier3":null,
              "tier1_description":null,
              "tier2_description":null,
              "tier3_description":null,
              "supplier_id":null,
              "order":0,
              "quantity":"10.00",
              "product_name":"test",
              "product_id":null,
              "unit":"test",
              "unit_cost":"25.00",
              "selling_price":null,
              "description":"dfdgdf",
              "worksheet_id":14894,
              "attachment_ids":[
                12391,
                12392,
                12393,
                12394,
                12395,
                12399,
                12400,
                12401
              ],
              "invoice_number":null,
              "cheque_number":null,
              "invoice_date":null,
              "actual_unit_cost":"150.00",
              "actual_quantity":100,
              "product_code":null,
              "branch_code":null,
              "style":null,
              "size":null,
              "color":null,
              "acv":null,
              "rcv":null,
              "tax":null,
              "depreciation":null,
              "work_type_id":null,
              "trade_id":null,
              "formula":null,
              "formula_updated_with_new_slug":null,
              "line_tax":null,
              "line_profit":null,
              "custom_tax_id":null,
              "qb_tax_code_id":null,
              "setting":{
                "tier1_collapse":false,
                "tier2_collapse":false,
                "tier3_collapse":false
              },
              "tier1_measurement_id":null,
              "tier2_measurement_id":null,
              "tier3_measurement_id":null,
              "abc_additional_data":null,
              "live_pricing":null,
              "category":{
                "id":1,
                "name":"MATERIALS",
                "default":1,
                "order":0,
                "slug":"materials",
                "qb_desktop_id":null,
                "qb_desktop_sequence_number":null,
                "financial_account_id":null,
                "active":1,
                "deleted_at":null,
                "deleted_by":null
              },
              "supplier":null,
              "product":null,
              "work_type":null,
              "trade":null
            }
          },
          {
            "type":"item",
            "data":{
              "id":108880,
              "tier1":null,
              "tier2":null,
              "tier3":null,
              "tier1_description":null,
              "tier2_description":null,
              "tier3_description":null,
              "supplier_id":null,
              "order":1,
              "quantity":"10.00",
              "product_name":"bhjghg",
              "product_id":null,
              "unit":"DD",
              "unit_cost":"101.00",
              "selling_price":null,
              "description":"nklj",
              "worksheet_id":14894,
              "attachment_ids":null,
              "invoice_number":null,
              "cheque_number":null,
              "invoice_date":null,
              "actual_unit_cost":"200.00",
              "actual_quantity":1000,
              "product_code":null,
              "branch_code":null,
              "style":null,
              "size":null,
              "color":null,
              "acv":null,
              "rcv":null,
              "tax":null,
              "depreciation":null,
              "work_type_id":null,
              "trade_id":null,
              "formula":null,
              "formula_updated_with_new_slug":null,
              "line_tax":null,
              "line_profit":null,
              "custom_tax_id":null,
              "qb_tax_code_id":null,
              "setting":{
                "tier1_collapse":false,
                "tier2_collapse":false,
                "tier3_collapse":false
              },
              "tier1_measurement_id":null,
              "tier2_measurement_id":null,
              "tier3_measurement_id":null,
              "abc_additional_data":null,
              "live_pricing":null,
              "category":{
                "id":1,
                "name":"MATERIALS",
                "default":1,
                "order":0,
                "slug":"materials",
                "qb_desktop_id":null,
                "qb_desktop_sequence_number":null,
                "financial_account_id":null,
                "active":1,
                "deleted_at":null,
                "deleted_by":null
              },
              "supplier":null,
              "product":null,
              "work_type":null,
              "trade":null
            }
          },
          {
            "type":"item",
            "data":{
              "id":108881,
              "tier1":null,
              "tier2":null,
              "tier3":null,
              "tier1_description":null,
              "tier2_description":null,
              "tier3_description":null,
              "supplier_id":null,
              "order":2,
              "quantity":"100.00",
              "product_name":"ererer",
              "product_id":null,
              "unit":"th",
              "unit_cost":"10.00",
              "selling_price":null,
              "description":"tytyty",
              "worksheet_id":14894,
              "attachment_ids":null,
              "invoice_number":null,
              "cheque_number":null,
              "invoice_date":null,
              "actual_unit_cost":"20.00",
              "actual_quantity":200,
              "product_code":null,
              "branch_code":null,
              "style":null,
              "size":null,
              "color":null,
              "acv":null,
              "rcv":null,
              "tax":null,
              "depreciation":null,
              "work_type_id":null,
              "trade_id":null,
              "formula":null,
              "formula_updated_with_new_slug":null,
              "line_tax":null,
              "line_profit":null,
              "custom_tax_id":null,
              "qb_tax_code_id":null,
              "setting":{
                "tier1_collapse":false,
                "tier2_collapse":false,
                "tier3_collapse":false
              },
              "tier1_measurement_id":null,
              "tier2_measurement_id":null,
              "tier3_measurement_id":null,
              "abc_additional_data":null,
              "live_pricing":null,
              "category":{
                "id":148,
                "name":"NO CHARGE",
                "default":1,
                "order":1,
                "slug":"no_charge",
                "qb_desktop_id":null,
                "qb_desktop_sequence_number":null,
                "financial_account_id":null,
                "active":1,
                "deleted_at":null,
                "deleted_by":null
              },
              "supplier":null,
              "product":null,
              "work_type":null,
              "trade":null
            }
          }
        ]
      }
    },
    "status":200

  };

  Map<String, dynamic> companySettingJson = {
    "data":[
      {
        "id":42,
        "name":"JOB COST OVERHEAD",
        "key":"JOB_COST_OVERHEAD",
        "value":{
          "enable":"1",
          "overhead":"10",
          "pl_sheet_from_financial":"0"
        },
        "user_id":0,
        "company_id":20
      }
    ],
  };

  group('For profit loss summary', () {
    final controller = JobProfitLossSummaryController();
    CompanySettingsService.setCompanySettings(companySettingJson["data"]);
    controller.jobModel = JobModel.fromJson(jobJson['data']);
    controller.worksheetModel = WorksheetModel.fromProfitLossSummaryJson(worksheetJson['data']);
    controller.worksheetId = controller.jobModel!.hasProfitLossWorksheet!;
    CompanySettingRepository.fetchCompanySettings();

    test('initCompanySettings is called to pre load required data from company settings', () {
      controller.initCompanySettings();
      expect(controller.isOverheadEnabled, true);
      expect(controller.isCostBasedEnabled, true);
      expect(controller.overheadPercentage, 10);
    });

    test('getFinancialSummary is called to calculate financial summary of job', () {
      controller.initCompanySettings();
      PlSummaryFinancialSummaryModel financialSummary = controller.getFinancialSummary();
      expect(financialSummary.jobPrice, 4564);
      expect(financialSummary.changeOrderWithoutTax, 5005.71);
      expect(financialSummary.credit, 870);
      expect(financialSummary.refund, 21057);
      expect(financialSummary.subTotal, -12357.29);
      expect(financialSummary.totalJobPrice, 4564);
      expect(financialSummary.subTotalOverhead, 0);
      expect(financialSummary.subTotalOverheadProjected, 0);
      expect(financialSummary.subTotalOverheadActual, 0);
    });

    test('getProjectSummary is called to calculate projected summary of job', () {
      controller.initCompanySettings();
      controller.getFinancialSummary();
      PlSummaryProjectModel projectedSummary = controller.getProjectSummary();
      expect(projectedSummary.noCostItem, 1000.0);
      expect(projectedSummary.costToDoJob, 1260.0);
      expect(projectedSummary.overhead, 126.0);
      expect(projectedSummary.commission, 12151612);
      expect(projectedSummary.totalJobPrice, 12152998.0);
      expect(projectedSummary.profitLoss, -12143428.29);
      expect(projectedSummary.profitLossPer, 126894.42302849302);
    });

    test('getActualSummary is called to calculate actual summary of job', () {
      controller.initCompanySettings();
      controller.getFinancialSummary();
      PlSummaryActualModel actualSummary = controller.getActualSummary();
      expect(actualSummary.noCostItem, 4000.0);
      expect(actualSummary.costToJob, 215000.0);
      expect(actualSummary.refund, 21057);
      expect(actualSummary.credits, 870);
      expect(actualSummary.overhead, 21500.0);
      expect(actualSummary.commision, 12151612);
      expect(actualSummary.profitLoss, -12400469.29);
      expect(actualSummary.profiltLossPerc, 129580.40828823444);
    });

    test('getItemsCost is called to calculate sum of cost based and non cost based items under projected and actual amount', () {
      Map<String, dynamic> itemsCost = controller.getItemsCost();
      expect(itemsCost["ProjectedNoCostItem"], 1000.0);
      expect(itemsCost["ProjectedCostToDoJob"], 1260.0);
      expect(itemsCost["ActualNoCostItem"], 4000.0);
      expect(itemsCost["ActualCostToDoJob"], 215000.0);
    });

    test('getPercent for projected amount is called to calculate percentage of ProfitLossAmount over TotalFinancialJobPrice', () {
      controller.initCompanySettings();
      controller.getFinancialSummary();
      PlSummaryProjectModel projectedSummary = controller.getProjectSummary();
      expect(projectedSummary.profitLoss, -12143428.29);
      expect(((controller.isOverheadEnabled && !controller.isCostBasedEnabled) ? controller.netBasedFinancialJobPrice : controller.costBasedfinancialTotalJobPrice), 9569.71);
      expect(controller.getPercent(projectedSummary.profitLossPer!), 1326.0007150529434);
    });

    test('getPercent for actual amount is called to calculate percentage of ProfitLossAmount over TotalFinancialJobPrice', () {
      controller.initCompanySettings();
      controller.getFinancialSummary();
      PlSummaryActualModel actualSummary = controller.getActualSummary();
      expect(actualSummary.profitLoss, -12400469.29);
      expect(((controller.isOverheadEnabled && !controller.isCostBasedEnabled) ? controller.netBasedFinancialJobPrice : controller.costBasedfinancialTotalJobPrice), 9569.71);
      expect(controller.getPercent(actualSummary.profitLoss!), -129580.40828823444);
    });

    group("P/L Summary should be calculated correctly when overhead is enabled or disabled", () {
      group("When overhead is disabled", () {
        setUp(() {
          companySettingJson["data"][0]["value"]["enable"] = "0";
        });

        group("P/L Summary should be calculated on cost basis, when P/L Sheet is not from financials", () {
          setUp(() {
            CompanySettingsService.setCompanySettings(companySettingJson["data"]);
            controller.initCompanySettings();
          });

          test("Calculations helpers should initialized correctly", () {
            expect(controller.isOverheadEnabled, false);
            expect(controller.isCostBasedEnabled, true);
            expect(controller.isPLSheetFromFinancial, false);
          });

          test('Financial Summary should be calculated correctly', () {
            controller.initCompanySettings();
            PlSummaryFinancialSummaryModel financialSummary = controller.getFinancialSummary();
            expect(financialSummary.jobPrice, 4564);
            expect(financialSummary.changeOrderWithoutTax, 5005.71);
            expect(financialSummary.credit, 870);
            expect(financialSummary.refund, 21057);
            expect(financialSummary.subTotal, -12357.29);
            expect(financialSummary.totalJobPrice, 4564);
            expect(financialSummary.subTotalOverhead, 0);
            expect(financialSummary.subTotalOverheadProjected, 0);
            expect(financialSummary.subTotalOverheadActual, 0);
          });

          test('Projected summary should be calculated correctly', () {
            controller.initCompanySettings();
            controller.getFinancialSummary();
            PlSummaryProjectModel projectedSummary = controller.getProjectSummary();
            expect(projectedSummary.noCostItem, 1000.0);
            expect(projectedSummary.costToDoJob, 1260.0);
            expect(projectedSummary.overhead, 0.0);
            expect(projectedSummary.commission, 12151612);
            expect(projectedSummary.totalJobPrice, 12152872.0);
            expect(projectedSummary.profitLoss, -12143302.29);
            expect(projectedSummary.profitLossPer, 126893.10637417434);
          });

          test("Actual summary should be calculated correctly", () {
            PlSummaryActualModel actualSummary = controller.getActualSummary();
            expect(actualSummary.noCostItem, 4000.0);
            expect(actualSummary.costToJob, 215000.0);
            expect(actualSummary.refund, 21057);
            expect(actualSummary.credits, 870);
            expect(actualSummary.overhead, 0.0);
            expect(actualSummary.commision, 12151612);
            expect(actualSummary.profitLoss, -12378969.29);
            expect(actualSummary.profiltLossPerc, 129355.74108306311);
          });
        });

        group("P/L Summary should be calculated on Net Job Price basis, when P/L Sheet is from financials", () {
          setUp(() {
            companySettingJson["data"][0]["value"]["pl_sheet_from_financial"] = "1";
            CompanySettingsService.setCompanySettings(companySettingJson["data"]);
            controller.initCompanySettings();
          });

          test("Calculations helpers should initialized correctly", () {
            expect(controller.isOverheadEnabled, false);
            expect(controller.isCostBasedEnabled, false);
            expect(controller.isPLSheetFromFinancial, true);
          });

          test('Financial Summary should be calculated correctly', () {
            PlSummaryFinancialSummaryModel financialSummary = controller.getFinancialSummary();
            expect(financialSummary.jobPrice, 4564);
            expect(financialSummary.changeOrderWithoutTax, 4853.25);
            expect(financialSummary.credit, 870);
            expect(financialSummary.refund, 21057);
            expect(financialSummary.subTotal, -12509.75);
            expect(financialSummary.totalJobPrice, 4564);
            expect(financialSummary.subTotalOverhead, -11258.775);
            expect(financialSummary.subTotalOverheadProjected, -12518.775);
            expect(financialSummary.subTotalOverheadActual, -226258.775);
          });

          test('Projected summary should be calculated correctly', () {
            controller.getFinancialSummary();
            PlSummaryProjectModel projectedSummary = controller.getProjectSummary();
            expect(projectedSummary.noCostItem, 1000.0);
            expect(projectedSummary.costToDoJob, 1260.0);
            expect(projectedSummary.overhead, 0.0);
            expect(projectedSummary.commission, 12151612);
            expect(projectedSummary.totalJobPrice, 12152872.0);
            expect(projectedSummary.profitLoss, -12143454.75);
            expect(projectedSummary.profitLossPer, 128949.05359844965);
          });

          test("Actual summary should be calculated correctly", () {
            PlSummaryActualModel actualSummary = controller.getActualSummary();
            expect(actualSummary.noCostItem, 4000.0);
            expect(actualSummary.costToJob, 215000.0);
            expect(actualSummary.refund, 21057);
            expect(actualSummary.credits, 870);
            expect(actualSummary.overhead, 0.0);
            expect(actualSummary.commision, 12151612);
            expect(actualSummary.profitLoss, -12379121.75);
            expect(actualSummary.profiltLossPerc, 131451.5569831957);
          });
        });
      });

      group("When overhead is enabled", () {
        setUp(() {
          companySettingJson["data"][0]["value"]["enable"] = "1";
          companySettingJson["data"][0]["value"]["pl_sheet_from_financial"] = "0";
        });

        group("P/L Summary should be calculated on cost basis, when P/L Sheet is not from financials", () {
          setUp(() {
            CompanySettingsService.setCompanySettings(companySettingJson["data"]);
            controller.initCompanySettings();
          });

          test("Calculations helpers should initialized correctly", () {
            expect(controller.isOverheadEnabled, true);
            expect(controller.isCostBasedEnabled, true);
            expect(controller.isPLSheetFromFinancial, false);
          });

          test('Financial Summary should be calculated correctly', () {
            controller.initCompanySettings();
            PlSummaryFinancialSummaryModel financialSummary = controller.getFinancialSummary();
            expect(financialSummary.jobPrice, 4564);
            expect(financialSummary.changeOrderWithoutTax, 5005.71);
            expect(financialSummary.credit, 870);
            expect(financialSummary.refund, 21057);
            expect(financialSummary.subTotal, -12357.29);
            expect(financialSummary.totalJobPrice, 4564);
            expect(financialSummary.subTotalOverhead, 0);
            expect(financialSummary.subTotalOverheadProjected, 0);
            expect(financialSummary.subTotalOverheadActual, 0);
          });

          test('Projected summary should be calculated correctly', () {
            controller.initCompanySettings();
            controller.getFinancialSummary();
            PlSummaryProjectModel projectedSummary = controller.getProjectSummary();
            expect(projectedSummary.noCostItem, 1000.0);
            expect(projectedSummary.costToDoJob, 1260.0);
            expect(projectedSummary.overhead, 126.0);
            expect(projectedSummary.commission, 12151612);
            expect(projectedSummary.totalJobPrice, 12152998.0);
            expect(projectedSummary.profitLoss, -12143428.29);
            expect(projectedSummary.profitLossPer, 126894.42302849302);
          });

          test("Actual summary should be calculated correctly", () {
            PlSummaryActualModel actualSummary = controller.getActualSummary();
            expect(actualSummary.noCostItem, 4000.0);
            expect(actualSummary.costToJob, 215000.0);
            expect(actualSummary.refund, 21057);
            expect(actualSummary.credits, 870);
            expect(actualSummary.overhead, 21500.0);
            expect(actualSummary.commision, 12151612);
            expect(actualSummary.profitLoss, -12400469.29);
            expect(actualSummary.profiltLossPerc, 129580.40828823444);
          });
        });

        group("P/L Summary should be calculated on Net Job Price basis, when P/L Sheet is from financials", () {
          setUp(() {
            companySettingJson["data"][0]["value"]["pl_sheet_from_financial"] = "1";
            CompanySettingsService.setCompanySettings(companySettingJson["data"]);
            controller.initCompanySettings();
          });

          test("Calculations helpers should initialized correctly", () {
            expect(controller.isOverheadEnabled, true);
            expect(controller.isCostBasedEnabled, false);
            expect(controller.isPLSheetFromFinancial, true);
          });

          test('Financial Summary should be calculated correctly', () {
            controller.initCompanySettings();
            PlSummaryFinancialSummaryModel financialSummary = controller.getFinancialSummary();
            expect(financialSummary.jobPrice, 4564);
            expect(financialSummary.changeOrderWithoutTax, 4853.25);
            expect(financialSummary.credit, 870);
            expect(financialSummary.refund, 21057);
            expect(financialSummary.subTotal, -12509.75);
            expect(financialSummary.totalJobPrice, 4564);
            expect(financialSummary.subTotalOverhead, -11258.775);
            expect(financialSummary.subTotalOverheadProjected, -12518.775);
            expect(financialSummary.subTotalOverheadActual, -226258.775);
          });

          test('Projected summary should be calculated correctly', () {
            controller.initCompanySettings();
            controller.getFinancialSummary();
            PlSummaryProjectModel projectedSummary = controller.getProjectSummary();
            expect(projectedSummary.noCostItem, 1000.0);
            expect(projectedSummary.costToDoJob, 1260.0);
            expect(projectedSummary.overhead, -1250.975);
            expect(projectedSummary.commission, 12151612);
            expect(projectedSummary.totalJobPrice, 12151621.025);
            expect(projectedSummary.profitLoss, -12142203.775);
            expect(projectedSummary.profitLossPer, 128935.7697310786);
          });

          test("Actual summary should be calculated correctly", () {
            PlSummaryActualModel actualSummary = controller.getActualSummary();
            expect(actualSummary.noCostItem, 4000.0);
            expect(actualSummary.costToJob, 215000.0);
            expect(actualSummary.refund, 21057);
            expect(actualSummary.credits, 870);
            expect(actualSummary.overhead, -1250.975);
            expect(actualSummary.commision, 12151612);
            expect(actualSummary.profitLoss, -12377870.775);
            expect(actualSummary.profiltLossPerc, 131438.27311582468);
          });
        });
      });
    });
  });
}