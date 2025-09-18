import 'package:jobprogress/core/utils/helpers.dart';

class HandwrittenTemplatePageModel {
  int? id;
  String? content;
  String? image;
  String? thumb;
  bool? autoFillRequired;
  String? editableContent;

  HandwrittenTemplatePageModel({
    this.id,
    this.content,
    this.image,
    this.thumb,
    this.autoFillRequired,
    this.editableContent,
  });

  HandwrittenTemplatePageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    image = json['image'];
    thumb = json['thumb'];
    autoFillRequired = Helper.isTrue(json['auto_fill_required']);
    editableContent = json['editable_content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['image'] = image;
    data['thumb'] = thumb;
    data['auto_fill_required'] = autoFillRequired;
    data['editable_content'] = editableContent;
    return data;
  }

  HandwrittenTemplatePageModel.fromUnsavedResourceJson(Map<String, dynamic> json) {
    content = json['template_html'];
    editableContent = json['template_cover'];
  }

}
