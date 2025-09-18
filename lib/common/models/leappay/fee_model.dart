import 'package:jobprogress/core/constants/leappay_preferences.dart';

class LeapPayFeeModel {
  late double cardFeePercentage;
  late double cardFeeAdditional;
  late double bankFeePercentage;
  late double bankPaymentMaxFee;

  LeapPayFeeModel({
    this.cardFeePercentage = LeapPayFeeConstants.cardFeePercentage,
    this.cardFeeAdditional = LeapPayFeeConstants.cardFeeAdditional / 100,
    this.bankFeePercentage = LeapPayFeeConstants.bankFeePercentage,
    this.bankPaymentMaxFee = LeapPayFeeConstants.bankPaymentMaxFee / 100
  });

  LeapPayFeeModel.fromJson(Map<String, dynamic> json) {
    cardFeePercentage = double.tryParse(json['card_rate'].toString()) ?? LeapPayFeeConstants.cardFeePercentage;
    cardFeeAdditional = (double.tryParse(json['card_fixed_price'].toString()) ?? LeapPayFeeConstants.cardFeeAdditional) / 100;
    bankFeePercentage = double.tryParse(json['ach_rate'].toString()) ?? LeapPayFeeConstants.bankFeePercentage;
    bankPaymentMaxFee = (double.tryParse(json['ach_max_fee'].toString()) ?? LeapPayFeeConstants.bankPaymentMaxFee) / 100;
  }
}