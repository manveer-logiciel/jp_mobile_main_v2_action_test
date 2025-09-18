import 'dart:core';

class PlSummaryActualModel {
  num? noCostItem;
  num? costToJob;
  num? refund;
  num? credits;
  num? commision;
  num? totalJobPrice;
  num? overhead;
  num? profitLoss;
  num? profiltLossPerc;
  

  PlSummaryActualModel({
    this.noCostItem,
    this.costToJob,
    this.refund,
    this.credits,
    this.commision,
    this.totalJobPrice,
    this.overhead,
    this.profitLoss,
    this.profiltLossPerc,
  });
}