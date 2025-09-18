class ConnectedThirdPartyModel {
  String? quickbookCompanyId;
  late bool onlyOneWaySync;
  late bool quickbookDesktop;
  late bool srs;

  ConnectedThirdPartyModel({
    this.quickbookCompanyId,
    this.onlyOneWaySync = false,
    this.quickbookDesktop = false,
    this.srs = false,
  });

  ConnectedThirdPartyModel.fromJson(Map<String, dynamic> json) {
    quickbookCompanyId = json['quickbook']['quickbook_company_id'];
    onlyOneWaySync = json['quickbook']['only_one_way_sync'];
    quickbookDesktop = json['quickbook_desktop'];
    srs = json['srs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quickbook']['quickbook_company_id'] = quickbookCompanyId;
    data['quickbook']['only_one_way_sync'] = onlyOneWaySync;
    data['quickbook_desktop'] = quickbookDesktop;
    data['srs'] = srs;
    return data;
  }
}