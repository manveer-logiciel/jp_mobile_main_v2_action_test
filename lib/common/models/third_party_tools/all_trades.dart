class ThirdPartyToolsModel {
  int? id;
  String? title;
  String? description;
  String? url;
  String? image;
  String? thumb;
  int? forAllTrades;

  ThirdPartyToolsModel(
      {this.id,
      this.title,
      this.description,
      this.url,
      this.image,
      this.thumb,
      this.forAllTrades});

  ThirdPartyToolsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    image = json['image'];
    thumb = json['thumb'];
    forAllTrades = json['for_all_trades'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['url'] = url;
    data['image'] = image;
    data['thumb'] = thumb;
    data['for_all_trades'] = forAllTrades;
    return data;
  }
}
