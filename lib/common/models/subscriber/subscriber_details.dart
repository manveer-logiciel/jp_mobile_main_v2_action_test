
import 'package:jobprogress/common/models/subscriber/hover_client.dart';
import 'package:jobprogress/common/models/subscriber/license_detail.dart';
import 'package:jobprogress/common/models/subscriber/subscription.dart';
import 'third_party_connections.dart';

class SubscriberDetailsModel {
  int? id;
  HoverClient? hoverClient;
  List<LicenseDetail>? licenseList; 
  String? smallIcon;
  String? largeIcon;
  int? companyCamId;
  SubscriptionModel? subscription;
  String? companyName;
  ThirdPartyConnectionModel? thirdPartyConnections;

  SubscriberDetailsModel({
    this.id,
    this.hoverClient,
    this.smallIcon,
    this.licenseList,
    this.largeIcon,
    this.companyCamId,
    this.subscription,
    this.thirdPartyConnections,
    this.companyName
  });

  SubscriberDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name']?.toString();
    hoverClient = json["hover_client"] == null ? null : HoverClient.fromJson(json["hover_client"]);
    if (json['license_numbers'] != null) {
      licenseList = <LicenseDetail>[];
      json['license_numbers']['data'].forEach((dynamic v) {
        licenseList!.add(LicenseDetail.fromJson(v));
      });
    }
    smallIcon = json['logos']?['small'];
    largeIcon = json['logos']?['large'];
    companyCamId = json['company_cam']?['id'];
    subscription = json['subscription'] is Map<String, dynamic> ? SubscriptionModel.fromJson(json['subscription']) : null;
    thirdPartyConnections = json['third_party_connections'] is Map<String, dynamic> ? ThirdPartyConnectionModel.fromJson(json['third_party_connections']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if(hoverClient != null) {
      data["hover_client"] = hoverClient?.toJson();
    }
    return data;
  }
}
