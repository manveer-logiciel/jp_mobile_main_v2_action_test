import 'package:jobprogress/common/models/templates/handwritten/page.dart';

class HandwrittenTemplateModel {
  int? id;
  int? parentId;
  int? companyId;
  String? type;
  String? title;
  String? content;
  String? editableContent;
  String? image;
  String? thumb;
  String? option;
  String? createdAt;
  String? updatedAt;
  int? totalPages;
  String? pageType;
  int? insuranceEstimate;
  bool? forAllTrades;
  String? groupId;
  String? groupName;
  int? groupOrder;
  String? archived;
  bool? isDir;
  int? allDivisionsAccess;
  List<HandwrittenTemplatePageModel>? pages;

  HandwrittenTemplateModel({
    this.id,
    this.parentId,
    this.companyId,
    this.type,
    this.title,
    this.content,
    this.editableContent,
    this.image,
    this.thumb,
    this.option,
    this.createdAt,
    this.updatedAt,
    this.totalPages,
    this.pageType,
    this.insuranceEstimate,
    this.forAllTrades,
    this.groupId,
    this.groupName,
    this.groupOrder,
    this.archived,
    this.isDir,
    this.allDivisionsAccess,
    this.pages,
  });

  HandwrittenTemplateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    companyId = json['company_id'];
    type = json['type'];
    title = json['title'];
    content = json['content'];
    editableContent = json['editable_content'];
    image = json['image'];
    thumb = json['thumb'];
    option = json['option'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    totalPages = json['total_pages'];
    pageType = json['page_type'];
    insuranceEstimate = json['insurance_estimate'];
    forAllTrades = json['for_all_trades'];
    groupId = json['group_id'];
    groupName = json['group_name'];
    groupOrder = json['group_order'];
    archived = json['archived'];
    isDir = json['is_dir'];
    allDivisionsAccess = json['all_divisions_access'];
    if (json['pages']?['data'] is List) {
      pages = <HandwrittenTemplatePageModel>[];
      json['pages']?['data'].forEach((dynamic page) {
        pages?.add(HandwrittenTemplatePageModel.fromJson(page));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent_id'] = parentId;
    data['company_id'] = companyId;
    data['type'] = type;
    data['title'] = title;
    data['content'] = content;
    data['editable_content'] = editableContent;
    data['image'] = image;
    data['thumb'] = thumb;
    data['option'] = option;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['total_pages'] = totalPages;
    data['page_type'] = pageType;
    data['insurance_estimate'] = insuranceEstimate;
    data['for_all_trades'] = forAllTrades;
    data['group_id'] = groupId;
    data['group_name'] = groupName;
    data['group_order'] = groupOrder;
    data['archived'] = archived;
    data['is_dir'] = isDir;
    data['all_divisions_access'] = allDivisionsAccess;
    data['pages']?['data'] = pages?.map((page) => page.toJson()).toList();
    return data;
  }
}
