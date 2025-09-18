import 'package:jobprogress/core/utils/helpers.dart';

class FinancialDetailModel {
  num? totalJobAmount;
  num? totalChangeOrderAmount;
  num? totalAmount;
  num? totalReceivedPayemnt;
  num? totalCredits;
  num? totalRefunds;
  num? pendingPayment;
  num? totalCommission;
  num? jobInvoiceAmount;
  num? jobInvoiceTaxAmount;
  String? soldOutDate;
  bool? canBlockFinancial;
  num? unappliedCredits;
  num?appliedCredits;
  num? unappliedPayment;
  num? appliedPayment;
  num? totalAccountPayableAmount;
  num? pendingPaymentRefundAdjusted;
  num? isDerivedTax;

  FinancialDetailModel({
    this.totalJobAmount,
    this.appliedCredits,
    this.unappliedPayment,
    this.totalChangeOrderAmount,
    this.totalAmount,
    this.canBlockFinancial,
    this.totalReceivedPayemnt,
    this.totalCredits,
    this.totalRefunds,
    this.pendingPayment,
    this.totalCommission,
    this.jobInvoiceAmount,
    this.jobInvoiceTaxAmount,
    this.soldOutDate,
    this.unappliedCredits,
    this.appliedPayment,
    this.totalAccountPayableAmount,
    this.pendingPaymentRefundAdjusted,
    this.isDerivedTax
  });

  FinancialDetailModel.fromJson(Map<String, dynamic> json) {
    totalJobAmount= json['total_job_amount'] ;
    totalChangeOrderAmount = json['total_change_order_amount'];
    totalAmount = json['total_amount'];
    totalReceivedPayemnt = json['total_received_payemnt'];
    totalCredits = json['total_credits'];
    totalRefunds = json['total_refunds'];
    pendingPayment = json['pending_payment'];
    totalCommission = json['total_commission'];
    jobInvoiceAmount = json['job_invoice_amount'];
    jobInvoiceTaxAmount = json['job_invoice_tax_amount'];
    soldOutDate = json['sold_out_date'];
    canBlockFinancial = Helper.isTrue(json['can_block_financials']);
    unappliedCredits = json['unapplied_credits'];
    appliedPayment = json['applied_payment'];
    totalAccountPayableAmount = json['total_account_payable_amount'];
    pendingPaymentRefundAdjusted = json['pending_payment_refund_adjusted'];
    isDerivedTax = json['is_derived_tax'];
    if(unappliedCredits!=null && totalCredits!=null ){
      appliedCredits = (totalCredits! - unappliedCredits!);
    }
    if(appliedPayment!=null && totalReceivedPayemnt!=null){
    unappliedPayment = (totalReceivedPayemnt!-appliedPayment!);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['total_job_amount'] = totalJobAmount;
    data['total_change_order_amount'] = totalChangeOrderAmount;
    data['total_amount'] = totalAmount;
    data['total_received_payemnt'] = totalReceivedPayemnt;
    data['total_credits'] = totalCredits;
    data['total_refunds'] = totalRefunds;
    data['pending_payment'] = pendingPayment;
    data['total_commission'] = totalCommission;
    data['job_invoice_amount'] = jobInvoiceAmount;
    data['job_invoice_tax_amount'] = jobInvoiceTaxAmount;
    data['sold_out_date'] = soldOutDate;
    data['can_block_financials'] = canBlockFinancial;
    data['unapplied_credits'] = unappliedCredits;
    data['applied_payment'] = appliedPayment;
    data['total_account_payable_amount'] = totalAccountPayableAmount;
    data['pending_payment_refund_adjusted'] = pendingPaymentRefundAdjusted;
    data['is_derived_tax'] = isDerivedTax;
    return data;
  }
}
