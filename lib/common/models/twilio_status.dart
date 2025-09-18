class TwilioStatusModel {
  int? brandId;
  String? brandStatus;
  String? brandCampaignStatus;
  String? brandSid;
  String? accountSid;

  TwilioStatusModel({
    this.brandId,
    this.brandStatus,
    this.brandCampaignStatus,
    this.brandSid,
    this.accountSid,
  });

  TwilioStatusModel.fromJson(Map<String, dynamic> json) {
    brandId = json['brand_id'];
    brandStatus = json['brand_status'];
    brandCampaignStatus = json['brand_campaign_status'];
    brandSid = json['brand_sid'];
    accountSid = json['account_sid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['brand_id'] = brandId;
    data['brand_status'] = brandStatus;
    data['brand_sid'] = brandSid;
    data['account_sid'] = accountSid;
    return data;
  }
}
