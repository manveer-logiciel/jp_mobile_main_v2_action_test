import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job_financial/financial_data.dart';
import 'package:jobprogress/common/models/job_financial/financial_details.dart';
import 'package:jobprogress/common/models/job_financial/financial_job_price_detail.dart';
import 'package:jobprogress/modules/job_financial/controller.dart';

void main(){
  final controller = JobFinancialController();

  test('JobFinancialController@getCircularProgressBarPercentageValue should return 25% when 0.25 passed ', (){
    String progressBarPercentageValue  = controller.getCircularProgressBarPercentageValue(0.25);
    expect(progressBarPercentageValue, '25%');
  });

  group('JobFinancialController@getTaxAmount different cases', (){
    test('Should return 0 when tax rate is 0',(){
      double getTaxAmount = controller.getTaxAmount(amount: 12, taxRate: 0); 
      expect(getTaxAmount, 0);
    });
    test('Should return 0 when amount is 0',(){
      double getTaxAmount = controller.getTaxAmount(amount: 0, taxRate: 12); 
      expect(getTaxAmount, 0);
    });
    test('Should return  0 when  amount and tax rate both are zero',(){
      double getTaxAmount = controller.getTaxAmount(amount: 0, taxRate: 0); 
      expect(getTaxAmount, 0);
    });
    test('Should return 1.2 when amount is 10 and tax rate is 12',(){
      double getTaxAmount = controller.getTaxAmount(amount: 10, taxRate: 12); 
      expect(getTaxAmount, 1.2);
    });
  });

  group('JobFinancialController@getTotalAmount different cases',(){
    test('Should return 112 when amount is 100 and tax rate is 12',(){
      double getTaxAmount = controller.getTotalAmount(amount: 100, taxRate: 12); 
      expect(getTaxAmount, 112);
    });

    test('Should return 0 when amount is zero',(){
      double getTaxAmount = controller.getTotalAmount(amount: 0, taxRate: 12); 
      expect(getTaxAmount, 0);
    });
    test('Should return amount value when tax rate is zero',(){
      double getTaxAmount = controller.getTotalAmount(amount: 20, taxRate: 0); 
      expect(getTaxAmount, 20);
    });
    
    test('Should return 0 when tax rate is zero and amount is also zero',(){
      double getTaxAmount = controller.getTotalAmount(amount: 20, taxRate: 0); 
      expect(getTaxAmount, 20);
    });    
  });
  test('JobFinancialController@financialdataModel should intialized with 0 values',(){
    FinancialDataModel financialDataModel = FinancialDataModel();
    expect(financialDataModel.paymentReceivedAmount, 0);
    expect(financialDataModel.paymentReceivedProgressbarValue, 0);
    expect(financialDataModel.creditProgressbarValue, 0);
    expect(financialDataModel.estimateTax, 0);
    expect(financialDataModel.jobPrice, 0);
    expect(financialDataModel.amountOwned, 0);
    expect(financialDataModel.updatRequestedestimateTax, 0);
    expect(financialDataModel.updateRequestedJobPrice, 0);
  });
   
   test('JobFinancialController@financialdataModel should return calculated value when JobFinancialController@getAllCalulated call',(){
    FinancialDataModel financialDataModel = controller.getAllCalculatedData(job:jobModel, jobPriceRequestedUpdate:jobPriceRequestDetail);
    expect(financialDataModel.paymentReceivedAmount, 112);
    expect(financialDataModel.paymentReceivedProgressbarValue, 0.4017857142857143);
    expect(financialDataModel.creditProgressbarValue, 0.4);
    expect(financialDataModel.estimateTax, 6.15);
    expect(financialDataModel.jobPrice, 123);
    expect(financialDataModel.amountOwned,145);
    expect(financialDataModel.updatRequestedestimateTax, 72.6);
    expect(financialDataModel.updateRequestedJobPrice, 1524.6);
  });
 
}
JobModel jobModel = JobModel(
  id: 1,
  customerId: 1,
  amount: '123',
  taxRate: '5',
  isMultiJob: false,
  taxable: 1,
  financialDetails: financialDetailsModal
);
JobModel jobModel1 = JobModel(
  id: 1,
  customerId: 1,
  amount: '123',
  taxRate: '5',
  taxable: 1,
);
JobModel jobModel3 = JobModel(
  id: 1,
  customerId: 1,
  amount: '123',
  taxRate: '5',
  taxable: 1,
  financialDetails: financialDetailsModal1
);
FinancialDetailModel financialDetailsModal = FinancialDetailModel(
  totalReceivedPayemnt: 112,
  totalJobAmount: 129,
  totalCredits: 100,
  appliedCredits: 40,
  pendingPayment: 145,
  appliedPayment: 45,
);

FinancialDetailModel financialDetailsModal1 = FinancialDetailModel(
  totalJobAmount: 129,
  totalChangeOrderAmount: 145,
  totalReceivedPayemnt: 198,
  totalCredits: 254,
  totalRefunds: 45,
);
FinancialJobPriceRequestDetail jobPriceRequestDetail = FinancialJobPriceRequestDetail(
  amount: '1452',
  taxRate: 5,
  taxable: 0
); 