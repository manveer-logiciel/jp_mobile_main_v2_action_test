
import '../../../core/utils/helpers.dart';

class SnippetListModel {
  int? id;
  String? title;
  String? description;
  String? parseHtmlDescription;
  String? createdAt;
  String? updatedAt;

  SnippetListModel({this.id, this.title, this.description, this.parseHtmlDescription, this.createdAt, this.updatedAt});

  SnippetListModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    description = json["description"];
    parseHtmlDescription=Helper.parseHtmlToText(description!);
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data["id"] = id;
    data["title"] = title;
    data["description"] = description;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    return data;
  }
}