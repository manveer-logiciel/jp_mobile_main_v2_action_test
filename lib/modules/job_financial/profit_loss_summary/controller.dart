import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job_financial/pl_summary_actual.dart';
import 'package:jobprogress/common/models/job_financial/pl_summary_financial_summary.dart';
import 'package:jobprogress/common/models/job_financial/pl_summary_project.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/core/constants/financial_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../common/models/job/job.dart';
import '../../../common/models/job/profit_loss_summary_view_model.dart';
import '../../../common/models/worksheet/worksheet_model.dart';
import '../../../common/repositories/job_financial.dart';
import '../../../common/services/company_settings.dart';
import '../../../core/constants/company_seetings.dart';
import '../../../core/constants/navigation_parms_constants.dart';
import '../../../core/utils/job_financial_helper.dart';


class JobProfitLossSummaryController extends GetxController {

  WorksheetModel? worksheetModel;
  JobModel? jobModel;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = true;
  late bool isOverheadEnabled;
  late bool isCostBasedEnabled;

  late num overheadPercentage;
  late num taxRate;
  late int worksheetId;
  num costBasedfinancialTotalJobPrice = 0;
  num netBasedFinancialJobPrice = 0;
  num subTotal = 0;

  List<ProfitLossSummaryViewModel> financialsSummary = [];
  List<ProfitLossSummaryViewModel> projectSummary = [];
  List<ProfitLossSummaryViewModel> actualSummary = [];

  bool get isPLSheetFromFinancial => !isCostBasedEnabled;

  @override
  void onInit() {
    super.onInit();
    worksheetId = Get.arguments[NavigationParams.worksheetId];
    jobModel = Get.arguments[NavigationParams.jobModel];
    initCompanySettings();
    fetchWorksheetDetails();
  }

  /////////////////////////////   INIT  SETTING   //////////////////////////////

  void initCompanySettings() {
    dynamic companySettingJobCostOverhead = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.jobCostOverhead);
    isOverheadEnabled = Helper.isTrue(companySettingJobCostOverhead is Map ? companySettingJobCostOverhead["enable"] : companySettingJobCostOverhead);
    isCostBasedEnabled = (companySettingJobCostOverhead["pl_sheet_from_financial"] == null || companySettingJobCostOverhead["pl_sheet_from_financial"] == "0");
    overheadPercentage = int.tryParse(companySettingJobCostOverhead["overhead"].toString()) ?? 0;
  }

  ////////////////////////////   FETCH WORKSHEET   /////////////////////////////

  void fetchWorksheetDetails() {
    Map<String, dynamic> params = {
      "id": worksheetId.toString()
    };
    JobFinancialRepository.fetchProfitLossSummary(params).then((value) {
      worksheetModel = value;
      overheadPercentage = num.tryParse(worksheetModel?.worksheet?.overhead ?? '') ?? 0;
      update();
      createFinancialsSummary();
      createProjectSummary();
      if((worksheetModel?.worksheet?.enableActualCost ?? 0) == 1) {
        createActualSummary();
      }
    });
  }

  //////////////////////////   FINANCIAL SUMMARY   /////////////////////////////

  PlSummaryFinancialSummaryModel getFinancialSummary () {
    var itemsCost = getItemsCost();

    num jobPrice = num.parse(worksheetModel?.jobPrice ?? "0");
    num changeOrder = 0;
    num credit = (jobModel?.financialDetails?.totalCredits ?? 0);
    num refund = (jobModel?.financialDetails?.totalRefunds ?? 0);
    num overheadAmount = 0;
    num projectedCostToDoJob = itemsCost["ProjectedCostToDoJob"];
    num actualCostToDoJob = itemsCost["ActualCostToDoJob"];
    num subTotalOverhead = 0;
    num subTotalOverheadProjected = 0;
    num subTotalOverheadActual = 0;
    num totalJobPrice = (jobModel?.financialDetails?.totalJobAmount ?? 0);
    num taxAmount = 0;

    changeOrder = (isPLSheetFromFinancial)
        ? (num.tryParse((jobModel?.changeOrder?.totalAmount ?? 0).toString()) ?? 0)
        : (jobModel?.financialDetails?.totalChangeOrderAmount ?? 0);

    taxRate = num.tryParse(jobModel?.taxRate ?? "0") ?? 0;

    subTotal = jobPrice + changeOrder - credit - refund;
    
    if(taxRate != 0) {
      taxAmount = jobPrice * taxRate / 100;
    }
    if(isPLSheetFromFinancial) {
      netBasedFinancialJobPrice = jobPrice + (num.tryParse((jobModel?.changeOrder?.totalAmount ?? "0").toString()) ?? 0);
      overheadAmount = (subTotal * overheadPercentage) / 100;
      subTotalOverhead = subTotal - overheadAmount;
      subTotalOverheadProjected = subTotal - overheadAmount - projectedCostToDoJob;

      if((worksheetModel?.worksheet?.enableActualCost ?? 0) == 1) {
        subTotalOverheadActual = subTotal - overheadAmount - actualCostToDoJob;
      }
    } else {
      costBasedfinancialTotalJobPrice = totalJobPrice + jobModel!.financialDetails!.totalChangeOrderAmount!;
    }

    PlSummaryFinancialSummaryModel financialSummary = PlSummaryFinancialSummaryModel(
      jobPrice : jobPrice,
      taxAmount : taxAmount,
      changeOrderWithoutTax : changeOrder,
      credit : credit,
      refund : refund,
      subTotal : subTotal,
      totalJobPrice : totalJobPrice,
      subTotalOverhead: subTotalOverhead,
      subTotalOverheadProjected : subTotalOverheadProjected,
      subTotalOverheadActual : subTotalOverheadActual,  
      );
    return financialSummary;
  }

  void createFinancialsSummary() {
    PlSummaryFinancialSummaryModel financialSummary = getFinancialSummary();

    financialsSummary.add(ProfitLossSummaryViewModel(
      priceTitle: "job_price".tr.capitalize,
      amount: JobFinancialHelper.getCurrencyFormattedValue(value: financialSummary.jobPrice)));

    if(financialSummary.taxAmount != 0 && isCostBasedEnabled) {
      financialsSummary.add(ProfitLossSummaryViewModel(
        priceTitle: "${"tax".tr} (${JobFinancialHelper.getRoundOff(taxRate, fractionDigits: 2)}%)",
        amount: JobFinancialHelper.getCurrencyFormattedValue(value: financialSummary.taxAmount)));
    }
    if(financialSummary.changeOrderWithoutTax != 0) {
      financialsSummary.add(ProfitLossSummaryViewModel(
        priceTitle: "change_order".tr.capitalize,
        amount: JobFinancialHelper.getCurrencyFormattedValue(value: financialSummary.changeOrderWithoutTax)));
    }

    if(isPLSheetFromFinancial) {
      financialsSummary.add(ProfitLossSummaryViewModel(
        priceTitle: "credit".tr,
        amount: JobFinancialHelper.getCurrencyFormattedValue(value: financialSummary.credit)));

      financialsSummary.add(ProfitLossSummaryViewModel(
        priceTitle: "refund".tr,
        amount: JobFinancialHelper.getCurrencyFormattedValue(value: financialSummary.refund)));

      financialsSummary.add(ProfitLossSummaryViewModel(
        priceTitle: "sub_total".tr,
        amount: JobFinancialHelper.getCurrencyFormattedValue(value: financialSummary.subTotal),
        isInfoIconVisible: true,
        infoMessage: "${"job_price".tr.capitalize} + ${"change_order".tr} - ${"credit".tr} - ${"refund".tr}",
      ));

      financialsSummary.add(ProfitLossSummaryViewModel(
        priceTitle: "${"sub_total".tr} - ${"overhead".tr}",
        amount: JobFinancialHelper.getCurrencyFormattedValue(value: financialSummary.subTotalOverhead),
        isInfoIconVisible: true,
        infoMessage: "${"sub_total".tr} - ${"overhead".tr}",
      ));

      financialsSummary.add(ProfitLossSummaryViewModel(
        priceTitle: "${"sub_total".tr} - ${"overhead".tr} - ${"job_price".tr.capitalize} (${"project".tr})",
        amount: JobFinancialHelper.getCurrencyFormattedValue(value: financialSummary.subTotalOverheadProjected),
        isInfoIconVisible: true,
        infoMessage: "${"sub_total".tr} - ${"overhead".tr} - ${"job_price".tr.capitalize} (${"project".tr})",
      ));

      if((worksheetModel?.worksheet?.enableActualCost ?? 0) == 1) {
        financialsSummary.add(ProfitLossSummaryViewModel(
          priceTitle: "${"sub_total".tr} - ${"overhead".tr} - ${"job_price".tr.capitalize} (${"actual".tr})",
          amount: JobFinancialHelper.getCurrencyFormattedValue(value: financialSummary.subTotalOverheadActual),
          isInfoIconVisible: true,
          infoMessage: "${"sub_total".tr} - ${"overhead".tr} - ${"job_price".tr.capitalize} (${"actual".tr})",
        ));
      }
    } else {
      financialsSummary.add(ProfitLossSummaryViewModel(
        priceTitle: "total_job_price".tr,
        amount: JobFinancialHelper.getCurrencyFormattedValue(value: financialSummary.totalJobPrice),
        titleFontWeight: JPFontWeight.medium,
        amountFontWeight: JPFontWeight.bold,
        amountTextSize: JPTextSize.heading3,
        amountColor: JPAppTheme.themeColors.text,
      ));
    }
    update();
  }

  //////////////////////////   PROJECTED SUMMARY   /////////////////////////////

  PlSummaryProjectModel getProjectSummary () {
    var itemsCost = getItemsCost();
    num projectedNoCostItem = itemsCost["ProjectedNoCostItem"];
    num projectedCostToDoJob = itemsCost["ProjectedCostToDoJob"];
    num overheadAmount = 0;
    num commission = jobModel?.financialDetails?.totalCommission ?? 0;
    num totalJobPrice = 0;
    num profitLossAmount = 0;
    num profitLossPercentage = 0;


    overheadAmount = ((isOverheadEnabled
        ? isCostBasedEnabled ? projectedCostToDoJob : subTotal
        : 0) * overheadPercentage) / 100;

    totalJobPrice = totalJobPrice + projectedCostToDoJob + overheadAmount;
    if(worksheetModel!.worksheet!.enableJobCommission!){
      totalJobPrice += commission;
    }

    profitLossAmount =  ((isPLSheetFromFinancial) ? netBasedFinancialJobPrice : costBasedfinancialTotalJobPrice) - totalJobPrice;
    profitLossPercentage = getPercent(profitLossAmount.abs());

    PlSummaryProjectModel projectedSummary = PlSummaryProjectModel(
      noCostItem : projectedNoCostItem,
      costToDoJob : projectedCostToDoJob,
      overhead : overheadAmount,
      commission : commission,
      totalJobPrice : totalJobPrice,
      profitLoss : profitLossAmount,
      profitLossPer : profitLossPercentage,
    );
    return projectedSummary;
  }

  void createProjectSummary() {
    PlSummaryProjectModel projectedSummary = getProjectSummary();

    if(projectedSummary.noCostItem != 0) {
      projectSummary.add(ProfitLossSummaryViewModel(
        priceTitle: "no_charge_amount".tr,
        amount: JobFinancialHelper.getCurrencyFormattedValue(value: -(projectedSummary.noCostItem!))));
    }

    projectSummary.add(ProfitLossSummaryViewModel(
      priceTitle: "cost_to_do_job".tr,
      amount: JobFinancialHelper.getCurrencyFormattedValue(value: projectedSummary.costToDoJob)));

    if(isOverheadEnabled) {
      projectSummary.add(ProfitLossSummaryViewModel(
        priceTitle: "${"overhead".tr} ($overheadPercentage%)",
        amount: JobFinancialHelper.getCurrencyFormattedValue(value: projectedSummary.overhead),
        isInfoIconVisible: true,
        infoMessage: (isPLSheetFromFinancial)
            ? "net_based_job_price_overhead_info".tr
            : "cost_based_job_price_overhead_info".tr
      ));
    }

    if(worksheetModel!.worksheet!.enableJobCommission!){
       projectSummary.add(ProfitLossSummaryViewModel(
      priceTitle: "commission".tr,
      amount: JobFinancialHelper.getCurrencyFormattedValue(value: projectedSummary.commission)));
    }
   
    projectSummary.add(ProfitLossSummaryViewModel(
      priceTitle: "total_job_cost".tr,
      amount: JobFinancialHelper.getCurrencyFormattedValue(value: projectedSummary.totalJobPrice),
      titleFontWeight: JPFontWeight.medium,
      amountFontWeight: JPFontWeight.bold,
      amountTextSize: JPTextSize.heading3,
    ));

    projectSummary.add(ProfitLossSummaryViewModel(
      priceTitle: "${"profit".tr} / ${"loss".tr}".tr,
      amount: JobFinancialHelper.getCurrencyFormattedValue(value: projectedSummary.profitLoss),
      amountFontWeight: JPFontWeight.bold,
      amountTextSize: JPTextSize.heading3,
      amountColor: (projectedSummary.profitLoss!) < 0
        ? JPAppTheme.themeColors.red
        : JPAppTheme.themeColors.success,
      isInfoIconVisible: true,
      infoMessage: isPLSheetFromFinancial
        ? "net_based_project_profit_loss_info".tr
        : "cost_based_profit_loss_info".tr,
      isPaddingExcluded: true,
    ));

    projectSummary.add(ProfitLossSummaryViewModel(
      priceTitle: "",
      amount: "(${JobFinancialHelper.getRoundOff(projectedSummary.profitLossPer!, fractionDigits: 2)}%)",
      amountTextSize: JPTextSize.heading5,
      amountColor: JPAppTheme.themeColors.darkGray,
    ));

    update();
  }

  ////////////////////////////   ACTUAL SUMMARY   //////////////////////////////

  PlSummaryActualModel getActualSummary () {
    var itemsCost = getItemsCost();
    num actualNoCostItem = itemsCost["ActualNoCostItem"];
    num actualCostToDoJob = itemsCost["ActualCostToDoJob"];
    num refund = (jobModel?.financialDetails?.totalRefunds ?? 0);
    num credit = (jobModel?.financialDetails?.totalCredits ?? 0);
    num overheadAmount = 0;
    num commission = jobModel?.financialDetails?.totalCommission ?? 0;
    num totalJobPrice = 0;
    num profitLossAmount = 0;
    num profitLossPercentage = 0;

    overheadAmount = ((isOverheadEnabled ? isCostBasedEnabled ? actualCostToDoJob : subTotal : 0) * overheadPercentage) / 100;

    totalJobPrice = actualCostToDoJob + refund + credit + overheadAmount;
    
    if(worksheetModel!.worksheet!.enableJobCommission!){
      totalJobPrice += commission;
    }

    profitLossAmount = ((isPLSheetFromFinancial) ? netBasedFinancialJobPrice : costBasedfinancialTotalJobPrice) - totalJobPrice;

    profitLossPercentage = getPercent(profitLossAmount.abs());

   PlSummaryActualModel actualSummary = PlSummaryActualModel(
      noCostItem : actualNoCostItem,
      costToJob : actualCostToDoJob,
      refund : refund,
      credits : credit,
      overhead : overheadAmount,
      commision : commission,
      totalJobPrice : totalJobPrice,
      profitLoss : profitLossAmount,
      profiltLossPerc : profitLossPercentage,
   );
    return actualSummary;
  }

  void createActualSummary() {
    PlSummaryActualModel summary = getActualSummary();

    if(summary.noCostItem != 0) {
      actualSummary.add(ProfitLossSummaryViewModel(
        priceTitle: "no_charge_amount".tr,
        amount: JobFinancialHelper.getCurrencyFormattedValue(value: -(summary.noCostItem!))));
    }

    actualSummary.add(ProfitLossSummaryViewModel(
      priceTitle: "cost_to_do_job".tr,
      amount: JobFinancialHelper.getCurrencyFormattedValue(value: summary.costToJob)));


    actualSummary.add(ProfitLossSummaryViewModel(
      priceTitle: "refund".tr,
      amount: JobFinancialHelper.getCurrencyFormattedValue(value: summary.refund)));

    actualSummary.add(ProfitLossSummaryViewModel(
      priceTitle: "credit".tr,
      amount: JobFinancialHelper.getCurrencyFormattedValue(value: summary.credits)));

    if(isOverheadEnabled) { 
      actualSummary.add(ProfitLossSummaryViewModel(
        priceTitle: "${"overhead".tr} ($overheadPercentage%)",
        amount: JobFinancialHelper.getCurrencyFormattedValue(value: summary.overhead),
        isInfoIconVisible: true,
        infoMessage: isPLSheetFromFinancial
          ? "net_based_job_price_overhead_info".tr
          : "cost_based_job_price_overhead_info".tr
      ));
    }

    if(worksheetModel!.worksheet!.enableJobCommission!){
      actualSummary.add(ProfitLossSummaryViewModel(
      priceTitle: "commission".tr,
      amount: JobFinancialHelper.getCurrencyFormattedValue(value: summary.commision)));
    }

    actualSummary.add(ProfitLossSummaryViewModel(
      priceTitle: "total_job_cost".tr,
      amount: JobFinancialHelper.getCurrencyFormattedValue(value: summary.totalJobPrice),
      titleFontWeight: JPFontWeight.medium,
      amountFontWeight: JPFontWeight.bold,
      amountTextSize: JPTextSize.heading3,
    ));

    actualSummary.add(ProfitLossSummaryViewModel(
      priceTitle: "${"profit".tr} / ${"loss".tr}".tr,
      amount: JobFinancialHelper.getCurrencyFormattedValue(value: summary.profitLoss),
      amountFontWeight: JPFontWeight.bold,
      amountTextSize: JPTextSize.heading3,
      amountColor: summary.profitLoss! < 0
        ? JPAppTheme.themeColors.red
        : JPAppTheme.themeColors.success,
      isInfoIconVisible: true,
      infoMessage: isPLSheetFromFinancial
        ? "net_based_actual_profit_loss_info".tr
        : "cost_based_profit_loss_info".tr,
      isPaddingExcluded: true,
    ));

    actualSummary.add(ProfitLossSummaryViewModel(
      priceTitle: "",
      amount: "(${JobFinancialHelper.getRoundOff(summary.profiltLossPerc!, fractionDigits: 2)}%)",
      amountTextSize: JPTextSize.heading5,
      amountColor: JPAppTheme.themeColors.darkGray,
    ));
    update();
  }

  /////////////////////////   CALCULATE ITEMS COST   ///////////////////////////

  Map<String, dynamic> getItemsCost() {
    Map<String, dynamic> amount = {};
    num projectedCostToDoJob = 0;
    num projectedNoCostItem = 0;
    num actualCostToDoJob = 0;
    num actualNoCostItem = 0;

    
    worksheetModel?.worksheet?.lineItems?.forEach((SheetLineItemModel element) {
      if((element.category?.slug ?? "") ==  FinancialConstant.noCharge) {
        projectedNoCostItem = projectedNoCostItem + ((num.tryParse(element.qty ?? '0') ?? 0) * (num.tryParse(element.price ?? '0') ?? 0));
        actualNoCostItem = actualNoCostItem + ((element.actualQuantity ?? 0) * (num.tryParse(element.actualUnitCost ?? '0') ?? 0));
      } else {
        projectedCostToDoJob = projectedCostToDoJob + ((num.tryParse(element.qty ?? '0') ?? 0) * (num.tryParse(element.price ?? '0') ?? 0));
        actualCostToDoJob = actualCostToDoJob + ((element.actualQuantity ?? 0) * (num.tryParse(element.actualUnitCost ?? "0") ?? 0));
      }
    });

    amount["ProjectedCostToDoJob"] = projectedCostToDoJob;
    amount["ProjectedNoCostItem"] = projectedNoCostItem;
    amount["ActualCostToDoJob"] = actualCostToDoJob;
    amount["ActualNoCostItem"] = actualNoCostItem;

    return amount;
  }

  /////////////////////////   CALCULATE PERCENTAGE   ///////////////////////////

  num getPercent(num profitLossAmount) {
    num percentage = (profitLossAmount / ((isPLSheetFromFinancial) ? netBasedFinancialJobPrice : costBasedfinancialTotalJobPrice)) * 100;
    return percentage.isInfinite || percentage.isNaN ? 0 : percentage;
  }

  //////////////////////////////////////////////////////////////////////////////

  void refreshPage() {
    worksheetModel = null;
    isLoading = true;
    financialsSummary.clear();
    projectSummary.clear();
    actualSummary.clear();
    update();
    fetchWorksheetDetails();
  }
}