class FinancialDataModel {
  num paymentReceivedAmount;
  double paymentReceivedProgressbarValue;
  double creditProgressbarValue;
  double estimateTax;
  num totalPrice;
  num jobPrice;
  num updateRequestedJobPrice;
  num updatRequestedestimateTax;
  num amountOwned;

 
 
  FinancialDataModel({
    this.paymentReceivedAmount = 0,
    this.paymentReceivedProgressbarValue = 0,
    this.creditProgressbarValue = 0,
    this.estimateTax = 0,
    this.updateRequestedJobPrice = 0,
    this.updatRequestedestimateTax = 0,
    this.totalPrice = 0,
    this.jobPrice = 0,
    this.amountOwned = 0,
  });

}