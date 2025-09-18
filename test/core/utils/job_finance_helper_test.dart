import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job_financial/financial_details.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';

void main(){
  
  JobModel refJob = JobModel(
    customerId: 1,
    id: 123,
    number: 'Num:-254',
    name: 'Mehak-Walia'
  );
  
  FinancialListingModel tempPaymentReceived = FinancialListingModel(
    method: 'cash',
    transferFromPayment:null, 
  );
  FinancialListingModel transferPayment = FinancialListingModel(
    refJob: refJob,
  );
  FinancialListingModel temp1PaymentReceived = FinancialListingModel(
    method: 'echeque',
    transferFromPayment:transferPayment,
  );
  FinancialListingModel temp2PaymentReceived = FinancialListingModel(
    method: 'cash',
    refTo: 123,
    transferToPayment: transferPayment,
  );
  FinancialListingModel changeOrder = FinancialListingModel(
    invoiceTotalAmount: 123, 
    taxable: true,
    taxRate: '1'
  );
  FinancialListingModel changeOrder1 = FinancialListingModel(
    taxable: false,
    totalAmount: '126',
  );
  FinancialListingModel changeOrder2 = FinancialListingModel(
    taxable: true,
    taxRate: '2.6',
    totalAmount: '126',
  );

  JobModel job = JobModel(
    id: 1,
    customerId: 123,
    amount: '114.50',
    taxRate: '2.25'
  );
  JobModel job2 = JobModel(
    id: 1,
    customerId: 123,
    financialDetails: 
    FinancialDetailModel(
      totalJobAmount: 123
    ),
    amount: '114.50',
    taxRate: '2.25'
  );
  JobModel job3 = JobModel(
    id: 126, 
    customerId: 25,
    taxable: 1,
    amount: '126',
    taxRate: '5.2'
  );
  test('JobFinancialHelper@getCurrencySymbol funtion Should return dollar sign if locale is US',() {
    String currencySymbol = JobFinancialHelper.getCurrencySymbol(locale:const Locale('en', 'US').toString());
    expect(currencySymbol, '\$');
  });
  
  test('JobFinancialHelper@getCurrencySymbol funtion Should return pound sign if locale is GB',() {
    String currencySymbol = JobFinancialHelper.getCurrencySymbol(locale:const Locale('en', 'GB').toString());
    expect(currencySymbol, '£');
  });
  
  test('JobFinancialHelper@getCurrencyFormattedValue function should return \$123.00 if locale is US ', () {
    String currencyFormattedValue = JobFinancialHelper.getCurrencyFormattedValue(value: 123,locale:const Locale('en', 'US').toString() );
    expect(currencyFormattedValue, '\$123.00');
  });
  
  test('JobFinancialHelper@getCurrencyFormattedValue function should return £123.00 if locale is GB ', () {
    String currencyFormattedValue = JobFinancialHelper.getCurrencyFormattedValue(value: 123,locale:const Locale('en', 'GB').toString() );
    expect(currencyFormattedValue, '£123.00');
  });

  test('JobFinancialHelper@getCurrencyFormattedValue should return Currency Symbol -- when Selling Price setting is active and price is null or empty', () {
    final result = JobFinancialHelper.getCurrencyFormattedValue( // Replace YourClassName
        isPlaceholder: true,
        value: null
    );
    expect(result, '${JobFinancialHelper.getCurrencySymbol()} --');
  });
  
  test('JobFinancialHelper@getRemainingAmount function should return 120 when total is 140 and value is 20',() {
    num remainingAmount = JobFinancialHelper.getRemainingAmount(total: 140, value: 20);
    expect(remainingAmount, 120); 
  });

  group('JobFinancialHelper@getPaymentReceivedType function different cases',() {
    test('Should return String get from paymentReceived modal property method when no conditions match', (){
      expect(JobFinancialHelper.getPaymentReceivedType(paymentsReceived: tempPaymentReceived), 'Cash');
    });
    test("Should return String Received from + with JobName when paymentReceived property transfer from payment and refJob.id is not null and refto is null", (){
      expect(JobFinancialHelper.getPaymentReceivedType(paymentsReceived: temp1PaymentReceived), 'Received From:- Num:-254');
    });
    test('Should return String Applied to:- + with JobName when paymentReceived property transfer to payment and refJob.id is not null and refto is also not  null', (){
      expect(JobFinancialHelper.getPaymentReceivedType(paymentsReceived: temp2PaymentReceived), 'Applied to:- Num:-254');
    });
  });

  group('JobFinancialHelper@getEstimatedTax function different cases',() {
    test('Should Return calculated estimateTax when job.amount & job.taxRate is not null ', () {
      double estimateTax = JobFinancialHelper.getEstimatedTax(job);
      expect(estimateTax, 2.57625);
    });
    test('Should Return 0 when jobModel.amount or jobModel.taxRate had null value', () {
      double estimateTax = JobFinancialHelper.getEstimatedTax(refJob);
      expect(estimateTax, 0.0);
    });
  });
  group('JobFinancialHelper@getTaxableTotalAmount different test cases', () {
    test('Should return changeOrder.invoiceTotalAmount when changeOrder.taxrate != 0 changeOrder.taxable is true, changeOrder.invoiceTotalAmount != null', (){
      double taxedTotalAmount = JobFinancialHelper.getTaxableTotalAmount(changeOrder);
      expect(taxedTotalAmount, 123.00);
    });
    test('Should return changeOrder@TotalAmount when changeOrder.taxRate is 0 or changeOrder.taxable is false', () {
      double taxedTotalAmount = JobFinancialHelper.getTaxableTotalAmount(changeOrder1);
      expect(taxedTotalAmount, 126.00);
    });
    test('Should return calculatedValue when changeOrder.taxrate != 0,changeOrder.taxable is true, changeOrder.invoiceTotalAmount == null', () {
      double taxedTotalAmount = JobFinancialHelper.getTaxableTotalAmount(changeOrder2);
      expect(taxedTotalAmount, 129.276);
    });
  });
  group('JobFinanceHelper@getTotalPrice different Test Cases', () {
    test('Should return job2.financialDetails.totalJobAmount when job2@.financialDetails != null && job2@.financialDetails.totalJobAmount != null', () {
      num totalPrice = JobFinancialHelper.getTotalPrice(job2);
      expect(totalPrice, 123);
    });
    test('Should return job.amount when job2@.financialDetails.totalJobAmount is null && taxable is false', () {
      num totalPrice = JobFinancialHelper.getTotalPrice(job);
      expect(totalPrice, 114.50);
    });
    test('Should return calculated totalPrice when job2@.financialDetails.totalJobAmount is null && taxable is true', () {
      num totalPrice = JobFinancialHelper.getTotalPrice(job3);
      expect(totalPrice, 132.552);
    });
  });

  group('JobFinancialHelper@removeDecimalZeroFormat should remove zeros after decimal', () {
    test('Removes decimal zero format correctly', () {
      expect(JobFinancialHelper.removeDecimalZeroFormat(5), equals('5')); // Case with integer input
      expect(JobFinancialHelper.removeDecimalZeroFormat(5.0), equals('5')); // Case with float input, which has zero decimal
      expect(JobFinancialHelper.removeDecimalZeroFormat(5.123), equals('5.123')); // Case with float input, which has non-zero decimal
      expect(JobFinancialHelper.removeDecimalZeroFormat('5.123'), equals('5.123')); // Case with string representation of float
      expect(JobFinancialHelper.removeDecimalZeroFormat('5'), equals('5')); // Case with string representation of integer
    });

    test('Handles invalid inputs correctly', () {
      expect(JobFinancialHelper.removeDecimalZeroFormat(null), equals('0')); // Null input
      expect(JobFinancialHelper.removeDecimalZeroFormat('abc'), equals('0')); // Invalid string input
      expect(JobFinancialHelper.removeDecimalZeroFormat(<String>[]), equals('0')); // Invalid list input
      expect(JobFinancialHelper.removeDecimalZeroFormat(<String, dynamic>{}), equals('0')); // Invalid map input
    });

    test('Handles negative numbers correctly', () {
      expect(JobFinancialHelper.removeDecimalZeroFormat(-5), equals('-5')); // Case with negative integer input
      expect(JobFinancialHelper.removeDecimalZeroFormat(-5.0), equals('-5')); // Case with negative float input, which has zero decimal
      expect(JobFinancialHelper.removeDecimalZeroFormat(-5.123), equals('-5.123')); // Case with negative float input, which has non-zero decimal
    });

    test('Handles edge cases correctly', () {
      expect(JobFinancialHelper.removeDecimalZeroFormat(0), equals('0')); // Case with zero input
      expect(JobFinancialHelper.removeDecimalZeroFormat(0.0), equals('0')); // Case with zero float input
      expect(JobFinancialHelper.removeDecimalZeroFormat(0.123), equals('0.123')); // Case with positive float input, which has non-zero decimal
      expect(JobFinancialHelper.removeDecimalZeroFormat(-0.123), equals('-0.123')); // Case with negative float input, which has non-zero decimal
    });

    test('Handles scientific notation correctly', () {
      expect(JobFinancialHelper.removeDecimalZeroFormat(5e3), equals('5000')); // Case with scientific notation for integer
      expect(JobFinancialHelper.removeDecimalZeroFormat(5.123e3), equals('5123')); // Case with scientific notation for float, which has non-zero decimal
    });

    test('Handles edge cases with large numbers correctly', () {
      expect(JobFinancialHelper.removeDecimalZeroFormat(double.infinity), equals('0')); // Case with positive infinity
      expect(JobFinancialHelper.removeDecimalZeroFormat(double.negativeInfinity), equals('0')); // Case with negative infinity
    });

    test('Handles edge cases with non-numeric strings correctly', () {
      expect(JobFinancialHelper.removeDecimalZeroFormat(''), equals('0')); // Empty string input
      expect(JobFinancialHelper.removeDecimalZeroFormat('Infinity'), equals('0')); // String representation of positive infinity
      expect(JobFinancialHelper.removeDecimalZeroFormat('-Infinity'), equals('0')); // String representation of negative infinity
      expect(JobFinancialHelper.removeDecimalZeroFormat('NaN'), equals('0')); // String representation of NaN (Not a Number)
      expect(JobFinancialHelper.removeDecimalZeroFormat('hello'), equals('0')); // Random string input
    });

    test('Handles extremely small numbers correctly', () {
      expect(JobFinancialHelper.removeDecimalZeroFormat(5e-10), equals('0.0')); // Case with extremely small positive float input
      expect(JobFinancialHelper.removeDecimalZeroFormat(-5e-10), equals('0.0')); // Case with extremely small negative float input
    });
  });
}


