class FeatureImageModal {
  String? type;
  String? uri;
  String? url;

  FeatureImageModal({this.type, this.uri, this.url});

  FeatureImageModal.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    uri = json['uri'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['uri'] = uri;
    data['url'] = url;
    return data;
  }
}