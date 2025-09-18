
class WorksheetAmounts {

  num subTotal;
  num listTotal;
  num materialTax;
  num laborTax;
  num taxAll;
  num lineItemTax;
  num overhead;
  num creaditCardFee;
  num profitMarkup;
  num profitMargin;
  num lineItemProfit;
  num commission;
  num noChargeAmount;
  num fixedPrice;
  num profitLossAmount;
  num discount;
  num processingFee;

  WorksheetAmounts({
    this.subTotal = 0,
    this.listTotal = 0,
    this.materialTax = 0,
    this.laborTax = 0,
    this.taxAll = 0,
    this.lineItemTax = 0,
    this.overhead = 0,
    this.creaditCardFee = 0,
    this.profitMarkup = 0,
    this.profitMargin = 0,
    this.lineItemProfit = 0,
    this.commission = 0,
    this.noChargeAmount = 0,
    this.fixedPrice = 0,
    this.profitLossAmount = 0,
    this.discount = 0,
    this.processingFee = 0,
  });

  num get displayTotal => subTotal + noChargeAmount;

}