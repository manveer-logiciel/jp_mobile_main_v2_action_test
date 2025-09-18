import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:jobprogress/core/constants/templates/page_type.dart';

class FormProposalTemplateModel {

  int? id;
  int? parentId;
  int? companyId;
  int? templateId;
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
  int? groupId;
  String? groupName;
  int? groupOrder;
  bool? isDir;
  int? allDivisionsAccess;
  int? proposalSerialNumber;
  Map<String, dynamic>? tables;
  String? autoFillRequired;
  int? tempSaveId;
  bool? isVisitRequired;
  bool isProposalPage;
  late bool isSelected;
  late String uniqueId;

  FormProposalTemplateModel({
    this.id,
    this.parentId,
    this.companyId,
    this.templateId,
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
    this.isDir,
    this.allDivisionsAccess,
    this.proposalSerialNumber,
    this.tables,
    this.autoFillRequired,
    this.tempSaveId,
    this.isVisitRequired,
    this.isProposalPage = false,
    this.isSelected = false,
  }) {
    uniqueId = UniqueKey().toString();
  }

  bool get isEmptySellingPriceSheet => id == -2 && content == null;

  bool get isImageTemplate => id == -1 || title == TemplatePageType.image;

  FormProposalTemplateModel.fromJson(Map<String, dynamic> json, {this.isProposalPage = false}) {
    id = json['id'] ?? json['page_id'];
    parentId = json['parent_id'];
    companyId = json['company_id'];
    templateId = json['template_id'];
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
    isDir = json['is_dir'];
    allDivisionsAccess = json['all_divisions_access'];
    proposalSerialNumber = int.tryParse(json['with_proposal_serial_number']?['serial_number']?.toString() ?? "");
    tables = json['pages']?['data']?[0]?['tables']?['date'];
    autoFillRequired = json['auto_fill_required'];
    if (!Helper.isValueNullOrEmpty(autoFillRequired) && !isProposalPage) {
      dynamic decodedAutoFill = jsonDecode("$autoFillRequired");
      if (decodedAutoFill is String) decodedAutoFill = jsonDecode(decodedAutoFill);
      if (decodedAutoFill is Map) {
        isVisitRequired = checkIfVisitRequired(decodedAutoFill);
      }
    }
    uniqueId = UniqueKey().toString();
    isSelected = false;
  }

  bool checkIfVisitRequired(Map<dynamic, dynamic> data) {
    return Helper.isTrue(data['signature']) || Helper.isTrue(data['table']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent_id'] = parentId;
    data['company_id'] = companyId;
    data['template_id'] = templateId;
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
    data['is_dir'] = isDir;
    data['all_divisions_access'] = allDivisionsAccess;
    return data;
  }

  JPSingleSelectModel toSingleSelect() {

    IconData icon = id == -1 ? Icons.image_outlined : Icons.attach_money;

    return JPSingleSelectModel(
      label: title ?? "-",
      id: uniqueId.toString(),
      child: JPIcon(id! > 0 ? Icons.description_outlined : icon),
      suffix: (isVisitRequired ?? false)
          ? JPIcon(Icons.error_outline, color: JPAppTheme.themeColors.darkGray,)
          : null
    );
  }
}
