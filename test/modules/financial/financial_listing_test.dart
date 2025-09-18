import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:jobprogress/common/enums/job_financial_listing.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job_financial/financial_details.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/modules/job_financial/listing/controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = JobFinancialListingModuleController();
   
  JobModel refJob = JobModel(
    customerId: 1,
    id: 123,
    number: 'Num:-254',
    name: 'Mehak-Walia',
    amount: '236',
    financialDetails: FinancialDetailModel(
      jobInvoiceAmount: 152
    )
  );
  List<FinancialListingModel> accountPayable = [
    FinancialListingModel(amount: 12),
    FinancialListingModel(amount: 15),
    FinancialListingModel(amount: 17),
  ];
  List<FinancialListingModel> accountPayable1 = [
    FinancialListingModel(amount: 12, canceled: '123'),
    FinancialListingModel(amount: 15, canceled: '145'),
    FinancialListingModel(amount: 17, canceled: '142'),
  ];
  List<FinancialListingModel> accountPayable3 = [
    FinancialListingModel(amount: 12, canceled: '123'),
    FinancialListingModel(amount: 15),
    FinancialListingModel(amount: 17),
  ];
  List<FinancialListingModel> financeList = [
    FinancialListingModel(totalAmount: '150.00', taxRate: '5.5',taxableAmount: '130'),
    FinancialListingModel(totalAmount: '120', taxRate: '2.5'),
    FinancialListingModel(totalAmount:'15', taxRate: '5.5' ),
  ];
  List<FinancialListingModel> financeList1 = [
    FinancialListingModel(totalAmount: '150'),
    FinancialListingModel(totalAmount: '120'),
    FinancialListingModel(totalAmount:'250'),
  ];
  List<FinancialListingModel> financeList2 = [
    FinancialListingModel(totalAmount: '150',canceled: '145'),
    FinancialListingModel(totalAmount: '120', canceled: '152'),
    FinancialListingModel(totalAmount:'250', canceled: '125'),
  ];

  FinancialListingModel tempPaymentReceived = FinancialListingModel(
    method: 'cash',
    transferFromPayment: null,
  );
  FinancialListingModel transferPayment = FinancialListingModel(
    refJob: refJob,
  );
  FinancialListingModel temp1PaymentReceived = FinancialListingModel(
    method: 'echeque',
    transferFromPayment: transferPayment,
  );

  test("JobFinanceListing should be constructed with default values", () {
    expect(controller.isAddingCancelNote, false);
    expect(controller.isLoading, true);
    expect(controller.cancelNote, '');
    expect(controller.financialList.length, 0); 
  });

  group('JobFinancialListingModuleController@getTitle  different cases when different listing type pass', () {
    test('Should return string payment received when lisitingType is default', () {
      expect(controller.getTitle(), 'payments'.tr);
    });
    test('Should return string payment received when lisitingType is JFListingType.paymentsReceived', () {
      controller.listingType = JFListingType.paymentsReceived;
      expect(controller.getTitle(), 'payments'.tr);
    });
    test('Should return string credits when lisitingType is JFListingType.credits', () {
      controller.listingType = JFListingType.credits;
      expect(controller.getTitle(), 'credits'.tr);
    });
    test("Should return string 'job_price' + ' '+'history' when lisitingType is JFListingType.jobPriceHistory", () {
      controller.listingType = JFListingType.jobPriceHistory;
      expect(controller.getTitle(), ('${'job_price'.tr} ${'history'.tr}'));
    });
    test("Should return string 'change_orders' + ' / ' + 'other_charges' when lisitingType is JFListingType.changeOrders", () {
      controller.listingType = JFListingType.changeOrders;
      expect(controller.getTitle(), 'change_orders'.tr);
    });
    test('Should return string refunds when lisitingType is JFListingType.refunds', () {
      controller.listingType = JFListingType.refunds;
      expect(controller.getTitle(), 'refunds'.tr);
    });
    test('Should return string accounts_payable when lisitingType is JFListingType.accountspayable', () {
      controller.listingType = JFListingType.accountspayable;
      expect(controller.getTitle(), 'accounts_payable'.tr);
    });
    test('Should return string job_invoices when lisitingType is JFListingType.jobInvoices', () {
      controller.listingType = JFListingType.jobInvoicesWithoutThumb;
      expect(controller.getTitle(), 'job_invoices'.tr);
    });
  });
  
  group('JobFinancialListingModuleController@getPaymentReceivedTypeNote function different cases ',() {
    test('Should return String reference number when paymentReceived.method is not equal to echeque', (){    
      expect(controller.getPaymentReceivedTypeNote(paymentsReceived: tempPaymentReceived), 'reference_number');
    });
    test('Should return String check number when paymentReceived.method is equal to echeque', () {    
      expect(controller.getPaymentReceivedTypeNote(paymentsReceived: temp1PaymentReceived), 'check_number');
    });
  });

  group('JobFinancialListingModuleController@getSumOfAmountForAccountPayable function different cases', () {
    test('Should return sum of amount of financialList all element when accountPayable  all element canceled is null', () {
      double amount = controller.getSumOfAmountForAccountPayable(financialList: accountPayable);
      expect(amount, 44);
    });
    test('Should return 0 when accountPayable1  all element canceled property has value', () {
      double amount = controller.getSumOfAmountForAccountPayable(financialList: accountPayable1);
      expect(amount, 0);
    });
    test('Should return sum of amount of that element in which canceled property is null', () {
      double amount = controller.getSumOfAmountForAccountPayable(financialList: accountPayable3);
      expect(amount, 32);
    });
  });

  group('JobFinancialListingModuleController@getSumOfAmount different cases', () {
    test('Should return sum of amount with tax added when taxRate had value in financeList item & canceled also null', () {
      double total = controller.getSumOfAmount(financialList: financeList);
      expect(total, 285.0);
    });
    test('Should return sum of amount without tax added when taxRate is null in financeList1 all item & cancel is also null', () {
      double total = controller.getSumOfAmount(financialList: financeList1);
      expect(total, 520.0);
    });
    test('Should return zero when  financeLisitingModel.canceled has value in financialList  all item', () {
      double total = controller.getSumOfAmount(financialList: financeList2);
      expect(total, 0.0);
    });
  });

  test('JobFinancialListingModuleController@getPendingAmount Should return calculated total when refJob.amount & refJob.financialDetails.jjobInvoiceAmount had value', () {
    double total = controller.getPendingAmount(refJob);
    expect(total, 84.0);
  });
  test('JobFinancialListingModuleController@getTaxableAmount Should return calcuated taxableAmount when financeList[0].taxableAmount & financeList[0]taxRate had value', () {
    double total = controller.getTaxableAmount(financeList[0]);
    expect(total, 7.15);
  });
}
