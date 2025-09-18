import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ProfitLossSummaryViewModel {
  String? priceTitle;
  String? amount;
  bool? isInfoIconVisible;
  String? infoMessage;
  JPTextSize? titleTextSize;
  JPFontWeight? titleFontWeight;
  Color? titleColor;
  JPTextSize? amountTextSize;
  JPFontWeight? amountFontWeight;
  Color? amountColor;
  bool? isPaddingExcluded;

  ProfitLossSummaryViewModel({
    this.priceTitle,
    this.amount,
    this.isInfoIconVisible = false,
    this.infoMessage,
    this.titleTextSize,
    this.titleFontWeight,
    this.titleColor,
    this.amountTextSize,
    this.amountFontWeight,
    this.amountColor,
    this.isPaddingExcluded = false,
  });
}