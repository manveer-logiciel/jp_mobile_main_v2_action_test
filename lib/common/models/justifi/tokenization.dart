import 'package:jobprogress/common/models/justifi/card_details.dart';
import 'bank_account_details.dart';

class JustifiTokenizationModel {
  String? paymentToken;
  JustifiCardDetails? cardDetails;
  JustifiBankAccountDetails? bankAccountDetails;

  JustifiTokenizationModel({
    this.paymentToken,
    this.cardDetails,
    this.bankAccountDetails,
  });

  JustifiTokenizationModel.fromJson(Map<String, dynamic> json) {
    paymentToken = json['paymentToken'];
    cardDetails = JustifiCardDetails.fromJson(json['cardDetails'] ?? {});
    bankAccountDetails = JustifiBankAccountDetails.fromJson(json['bankAccountDetails'] ?? {});
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['paymentToken'] = paymentToken;
    if (cardDetails != null) {
      data['cardDetails'] = cardDetails!.toJson();
    }
    return data;
  }
}
