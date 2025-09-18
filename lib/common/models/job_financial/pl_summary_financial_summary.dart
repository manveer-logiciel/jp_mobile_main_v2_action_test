class PlSummaryFinancialSummaryModel {
num? jobPrice;
num? taxRate;
num? totalJobPrice;
num? taxAmount;
num? totalChangeOrder;
num? changeOrderWithoutTax;
num? subTotal;
num? subTotalOverhead;
num? credit;
num? refund;
num? subTotalOverheadProjected;
num? subTotalOverheadActual;

  PlSummaryFinancialSummaryModel({
    this.jobPrice,
    this.taxRate,
    this.totalJobPrice,
    this.taxAmount,
    this.totalChangeOrder,
    this.subTotal,
    this.changeOrderWithoutTax,
    this.subTotalOverhead,
    this.subTotalOverheadActual,
    this.subTotalOverheadProjected,
    this.credit,
    this.refund,
  });
}