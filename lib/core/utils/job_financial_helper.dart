import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobprogress/common/extensions/String/index.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/common/models/leappay/fee_model.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/core/constants/leap_pay_payment_method.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import '../../common/services/company_settings.dart';
import '../../common/services/quick_book.dart';
import '../constants/company_seetings.dart';

class JobFinancialHelper {
  static String locale = Get.locale.toString();
  static String countryCode = AuthService.userDetails?.companyDetails?.countryCode?.toLowerCase() ?? '';
  
  static String getCurrencySymbol({String? locale}){
    var format = NumberFormat.simpleCurrency(locale: locale);
    return format.currencySymbol;
  }
 
  static String getCurrencyFormattedValue({required dynamic value, String? locale, bool isPlaceholder = false}) {
    if(isPlaceholder) {
      return '${JobFinancialHelper.getCurrencySymbol()} --';
    }

    value = value.toString();
    String tempLocale = Get.locale.toString();
    var format = NumberFormat.currency(locale: locale ?? tempLocale, symbol: getCurrencySymbol(locale: locale ?? tempLocale));
    value = double.tryParse(value) ?? 0.00;
    String finalValue = format.format(value);
    return finalValue;
  }

  static num getRemainingAmount({required num total, required num value}) {
    num result = total - value;
    return result;
  }

  static num getTotalPrice(JobModel? job) {
    if(job == null) {
      return 0;
    }
    if (job.financialDetails != null &&
        job.financialDetails!.totalJobAmount != null) {
      return job.financialDetails!.totalJobAmount!;
    } else {
      if (job.taxable == 1) {
        double estimateTax = getEstimatedTax(job);
        double amount = double.parse(job.amount!);
        double totalPrice = amount + estimateTax;
        return totalPrice;
      } else {
        return double.parse(job.amount ?? "0");
      }
    }
  }

  static String  getTotalUnappliedAmount(List<FinancialListingModel> unappliedCreditList) {
    
    num totalUnappliedAmount = 0 ; 
    
    for(FinancialListingModel unappliedCredit in unappliedCreditList) {
     totalUnappliedAmount = totalUnappliedAmount + num.parse(unappliedCredit.unAppliedAmount!); 
    }
    
    return getCurrencyFormattedValue(value:totalUnappliedAmount) ;
  }

  static double getEstimatedTax(JobModel jobModel) {
    if(jobModel.amount != null && jobModel.taxRate != null) {
      double amount = double.parse(jobModel.amount!);
      double taxRate = double.parse(jobModel.taxRate!);
      double estimatedTax =  (amount * taxRate)/100;
      return  estimatedTax;
    } else {
      return 0.0; 
    }
  }

   static IconData getCurrencyIcon(){
    switch(countryCode){
      case 'uk':
        return Icons.currency_pound_outlined;
      default:
        return Icons.attach_money_outlined;
    }
  }

  static String getPaymentReceivedType({required FinancialListingModel paymentsReceived}) {
    if(
      paymentsReceived.transferToPayment != null &&
      paymentsReceived.transferToPayment!.refJob != null &&
      paymentsReceived.refTo != null) { 
        return 'Applied to:- ${Helper.getJobName(paymentsReceived.transferToPayment!.refJob!)}'; 
    } else if (
      paymentsReceived.transferFromPayment != null &&
      paymentsReceived.transferFromPayment!.refJob != null &&
      paymentsReceived.refTo == null) {
        return'Received From:- ${Helper.getJobName(paymentsReceived.transferFromPayment!.refJob!)}'; 
    } else {
      return getMethodType(paymentsReceived.method!);
    }     
  }

   static String getMethodType(String method){
    String methodString = method;

    switch (method) {
      case "cash":
        methodString = "cash".tr.capitalize!;
        break;
      case "echeque":
        methodString = "check".tr.capitalize!;
        break;
      case "paypal":
        methodString = "paypal".tr.capitalize!;
        break;
      case "cc":
        methodString = "credit_card".tr.capitalize!;
        break;
      case "other":
        methodString = "others".tr.capitalize!;
        break;
      case "qbpay":
        methodString = "quickbooks_pay".tr;
        break;
      default:
        methodString = method;
    }

    return methodString;
  }

  static double getTaxableTotalAmount(FinancialListingModel changeOrder) {
    if(changeOrder.taxable && changeOrder.taxRate != '0'){
      if(changeOrder.invoiceTotalAmount == null) {
        double amount = double.parse(changeOrder.totalAmount!);
        double tax = double.parse(changeOrder.taxRate!);
        return amount + amount * tax / 100;
      } else {
        return changeOrder.invoiceTotalAmount!.toDouble();
      }   
    } else {
      return double.parse(changeOrder.totalAmount ?? "0");
    }
  }

   static String getRoundOff(num value, {int? fractionDigits = 3, bool avoidZero = false}) {
    if (avoidZero && value == 0) return "";
    Decimal parsedValue = Decimal.parse(value.toString());
    if (fractionDigits != null) {
      parsedValue = parsedValue.round(scale: fractionDigits);
    }
    return parsedValue.toString();
  }

  static num getTaxRate(JobModel? jobModel, {bool isRevised = false}) {
    if ((QuickBookService.isQuickBookConnected() || QuickBookService.isQBDConnected())) {
      if(jobModel?.customTax?.taxRate != null) {
        return jobModel!.customTax!.taxRate!;
      } else {
        return 0;
      }
    } else {
      if((jobModel?.taxRate?.isNotEmpty ?? false) && !isRevised) {
        return num.parse(jobModel!.taxRate!.toString());
      } else if (jobModel?.customTax?.taxRate != null) {
        return jobModel!.customTax!.taxRate!;
      } else if (jobModel?.parent?.address?.stateTax != null) {
        return jobModel!.parent!.address!.stateTax!;
      } else if (jobModel?.address?.stateTax != null) {
        return jobModel!.address!.stateTax!;
      } else {
        var companyTaxRate = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.taxRate);
        bool isTaxable = companyTaxRate is bool ? false : companyTaxRate.toString().isNotEmpty;
        if(isTaxable) {
          return num.parse(companyTaxRate.toString());
        } else {
          return 0;
        }
      }
    }
  }

  static num getTaxRateForFinancialForm({JobModel? jobModel, FinancialListingModel? jobInvoices}) {
    if ((QuickBookService.isQuickBookConnected() || QuickBookService.isQBDConnected())) {
      if (!Helper.isValueNullOrEmpty(jobInvoices?.customTax?.taxRate.toString())) {
        return jobInvoices!.customTax!.taxRate!;
      } else {
        return 0;
      }
    } else {
      if(Helper.isTrue(jobModel?.taxable)
        && !Helper.isValueNullOrEmpty(jobModel?.taxRate)
        && !Helper.isTrue(jobModel?.financialDetails?.isDerivedTax)) {
        return num.parse(jobModel!.taxRate!);
      } else if (!Helper.isValueNullOrEmpty(jobInvoices?.customTax?.taxRate.toString())) {
        return jobInvoices!.customTax!.taxRate!;
      } else if (!Helper.isValueNullOrEmpty(jobModel?.parent?.address?.stateTax.toString()) && Helper.isTrue(jobModel?.isProject)) {
        return jobModel!.parent!.address!.stateTax!;
      } else if (!Helper.isValueNullOrEmpty(jobModel?.address?.stateTax.toString())) {
        return jobModel!.address!.stateTax!;
      } else {
        var companyTaxRate = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.taxRate);
        bool isTaxable = companyTaxRate is bool ? false : companyTaxRate.toString().isNotEmpty;
        if(isTaxable) {
          return num.parse(companyTaxRate.toString());
        } else {
          return 0;
        }
      }
    }
  }

  static String initialZeroRemover(String val) {
    final RegExp regexp = RegExp(r'^0+(?=.)');
    return val.replaceAll(regexp, '');
  }

  static String removeDecimalZeroFormat(dynamic val) {
    final tempValue = double.tryParse(val.toString()) ?? 0;
    if(!tempValue.isFinite) {
      return '0';
    }
    if (tempValue.truncateToDouble() == tempValue) {
      return tempValue.truncateToDouble().toString().split(".")[0];
    }
    return tempValue.toString().roundToDecimalPlaces(3);
  }

  static double calculateLeapPayFee(String method, double amount) {
    LeapPayFeeModel feesModel = ConnectedThirdPartyService.getLeapPayCompanyRate();

    if(amount > 0.0) {
      switch(method) {
        case LeapPayPaymentMethod.card:
          return ((amount * feesModel.cardFeePercentage) / 100) + feesModel.cardFeeAdditional;

        case LeapPayPaymentMethod.achOnly:
          double val = (amount * feesModel.bankFeePercentage) / 100;
          return val > feesModel.bankPaymentMaxFee ? feesModel.bankPaymentMaxFee : val;

        default:
          return 0.0;
      }
    }
    return 0.0;
  }

}
