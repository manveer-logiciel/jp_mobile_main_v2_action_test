import 'subscription_plan.dart';

class SubscriptionModel {
  int? id;
  int? userLicenses;
  int? subContractorUserLicenses;
  int? activeUserLicenses;
  int? remainingDays;

  SubscriptionPlanModel? plan;

  SubscriptionModel({
    this.id,
    this.userLicenses,
    this.subContractorUserLicenses,
    this.activeUserLicenses,
    this.plan,
    this.remainingDays
  });

  SubscriptionModel.fromJson(Map<String, dynamic> json) {
    userLicenses = json['user_licenses'] is int ? json['user_licenses'] : 0;
    subContractorUserLicenses = json['sub_contractor_user_licenses'] is int ? json['sub_contractor_user_licenses'] : 0;
    activeUserLicenses = json['active_user_licenses'] is int ? json['active_user_licenses'] : 0;
    remainingDays = json['remaining_days'];
    plan = json['plan'] is Map<String, dynamic> ? SubscriptionPlanModel.fromJson(json['plan']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['user_licenses'] = userLicenses;
    data['sub_contractor_user_licenses'] = subContractorUserLicenses;
    data['active_user_licenses'] = activeUserLicenses;
    data['remaining_days'] = remainingDays;
    if (plan != null) {
      data['plan'] = plan!.toJson();
    }
    return data;
  }
}
