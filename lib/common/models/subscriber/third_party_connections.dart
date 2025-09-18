import 'package:jobprogress/core/utils/helpers.dart';

class ThirdPartyConnectionModel {
  bool? eagleview;
  bool? googleSheet;
  bool? quickbook;
  bool? hover;
  bool? skymeasure;
  bool? companyCam;
  bool? facebook;
  bool? twitter;
  bool? linkedin;
  bool? quickbookDesktop;
  bool? abcSupplier;
  bool? srsSupplier;
  bool? quickbookPay;
  bool? quickmeasure;
  bool? dropbox;
  bool? projectMapIt;
  bool? homeAdvisor;
  bool? greensky;
  bool? beacon;

  ThirdPartyConnectionModel({
    this.eagleview,
    this.googleSheet,
    this.quickbook,
    this.hover,
    this.skymeasure,
    this.companyCam,
    this.facebook,
    this.twitter,
    this.linkedin,
    this.quickbookDesktop,
    this.abcSupplier,
    this.srsSupplier,
    this.quickbookPay,
    this.quickmeasure,
    this.dropbox,
    this.projectMapIt,
    this.homeAdvisor,
    this.greensky,
    this.beacon,
  });

  ThirdPartyConnectionModel.fromJson(Map<String, dynamic> json) {
    eagleview = Helper.isTrue(json['eagleview']);
    googleSheet = Helper.isTrue(json['google_sheet']);
    quickbook = Helper.isTrue(json['quickbook']);
    hover = Helper.isTrue(json['hover']);
    skymeasure = Helper.isTrue(json['skymeasure']);
    companyCam = Helper.isTrue(json['company_cam']);
    facebook = Helper.isTrue(json['facebook']);
    twitter = Helper.isTrue(json['twitter']);
    linkedin = Helper.isTrue(json['linkedin']);
    quickbookDesktop = Helper.isTrue(json['quickbook_desktop']);
    abcSupplier = Helper.isTrue(json['abc_supplier']);
    srsSupplier = Helper.isTrue(json['srs_supplier']);
    quickbookPay = Helper.isTrue(json['quickbook_pay']);
    quickmeasure = Helper.isTrue(json['quickmeasure']);
    dropbox = Helper.isTrue(json['dropbox']);
    projectMapIt = Helper.isTrue(json['project_map_it']);
    homeAdvisor = Helper.isTrue(json['home_advisor']);
    greensky = Helper.isTrue(json['greensky']);
    beacon = Helper.isTrue(json['beacon']);
  }
}
