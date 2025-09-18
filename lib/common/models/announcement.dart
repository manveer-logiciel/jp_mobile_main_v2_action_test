class AnnouncementModel {
  late int id;
  String? title;
  String? description;

  AnnouncementModel({
    required this.id,
    this.title,
    this.description
  });

  AnnouncementModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description =  json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    data['title'] = title;
    return data;
  }
}
