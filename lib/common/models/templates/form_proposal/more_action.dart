import 'dart:ui';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/templates/form_proposal/template.dart';
import 'package:jobprogress/core/constants/pagination_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class FormProposalParamsModel {

  int jobId;
  bool isEditForm;
  String? templateId;
  int? tempTemplateId;
  late List<AttachmentResourceModel> attachments;
  late List<AttachmentResourceModel> uploadedAttachments;
  VoidCallback? onTapSaveAs;

  FormProposalParamsModel({
    required this.jobId,
    required this.isEditForm,
    this.templateId,
    this.onTapSaveAs,
  }) {
      attachments = [];
      uploadedAttachments = [];
  }

  Map<String, dynamic> getTemplateParams(bool isMergeTemplate) {

    if (isMergeTemplate) {
      return {
        "includes[]": "tables",
        "page_id": templateId,
        if (tempTemplateId != null) "id": tempTemplateId,
      };
    }

    return {
      'id': templateId,
      'includes[0]': 'pages',
      'includes[1]': 'pages.tables',
      'includes[2]': 'with_proposal_serial_number',
      'multi_page': '1',
      if (isEditForm) 'includes[3]': 'attachments'
    };
  }

  Map<String, dynamic> getTemporarySaveParams(FormProposalTemplateModel template) {
    return {
      if (template.tempSaveId != null) "temp_id": template.tempSaveId,
      "auto_fill_required": template.autoFillRequired,
      "content": template.content,
      "page_type": template.pageType,
      "title": template.title,
      "tables": template.tables,
      "id": template.id,
      "temp_id": template.tempSaveId,
      "is_visit_required": template.isVisitRequired,
    };
  }

  Map<String, dynamic> getMergeTemplateSaveParams(String selectedPageType, List<FormProposalTemplateModel> pages, {
    int? proposalId,
    int? worksheetId,
    String? name,
    bool forEdit = false,
    bool isForUnsavedDB = false,
    bool isForWorksheet = false,
  }) {

    List<Map<String, dynamic>> templatePages = pages.map((page) {
      final pageToSave = getPageTypeAndId(page, forEdit, isForWorksheet);
      return {
        "type": pageToSave.$1,
        "id": pageToSave.$2,
        if (isForUnsavedDB) ...getTemporarySaveParams(page),
      };
    }).toList();

    return {
      if (worksheetId != null) "worksheet_id": worksheetId,
      if (proposalId != null) "proposal_id": proposalId,
      if (name != null) "title": name,
      "job_id": jobId,
      "page_type": selectedPageType,
      if (!isForWorksheet) "pages": templatePages,
      if (isForWorksheet) "template_pages": templatePages,
      "insurance_estimate": 1,
      "is_mobile": 1,
      "includes[]": "pages"
    };
  }

  /// Returns a tuple of page type and id for the given [page]. If [forEdit] is true,
  /// then the page type is determined by whether the page is a worksheet template page,
  /// a proposal page, or a template page. If [forEdit] is false, then the page type is
  /// determined by whether the page has a temporary save id or not. If the page has a
  /// temporary save id, then the page type is "temp_proposal_page", otherwise it is
  /// "template_page". The id is determined by whether the page has a temporary save id
  /// or not. If the page has a temporary save id, then the id is the temporary save id,
  /// otherwise it is the id of the page.
  (String, int?) getPageTypeAndId(FormProposalTemplateModel page, bool forEdit, bool isForWorksheet) {
    if (forEdit) {
      if (isForWorksheet) {
        return ("worksheet_template_page", page.id);
      } else {
        // Check temp save first, then proposal page status
        if (!Helper.isValueNullOrEmpty(page.tempSaveId)) {
          return ("temp_proposal_page", page.tempSaveId);
        } else if (Helper.isTrue(page.isProposalPage)) {
          return ("proposal_page", page.id);
        } else {
          return ("template_page", page.id);
        }
      }
    } else {
      // Create mode: temp save or regular template
      if (!Helper.isValueNullOrEmpty(page.tempSaveId)) {
        return ("temp_proposal_page", page.tempSaveId);
      } else {
        return ("template_page", page.id);
      }
    }
  }

  Map<String, dynamic> getAttachmentsJson(bool isForUnsavedDB) {

    Map<String, dynamic> data = {};

    if(attachments.isNotEmpty || uploadedAttachments.isNotEmpty) {

      List<AttachmentResourceModel> attachmentsToUpload = [];
      List<AttachmentResourceModel> attachmentsToDelete = [];

      attachmentsToUpload = attachments.where((attachment) => !uploadedAttachments.contains(attachment)).toList();
      attachmentsToDelete = uploadedAttachments.where((attachment) => attachments.isEmpty || !attachments.contains(attachment)).toList();

      if(isForUnsavedDB) {
        data['attachments'] = attachmentsToUpload.map((attachment) => attachment.toJson()).toList();
        data['delete_attachments'] = attachmentsToDelete.map((attachment) => attachment.toJson()).toList();
      } else {
        // Map attachments for API payload
        // Using attachment.type with fallback to "resource" for backward compatibility
        // Some attachments may have null type due to legacy data or when created without explicit type
        // The "resource" type is the default expected by the backend API
        data['attachments'] = attachmentsToUpload.map((attachment) => {
          'type': attachment.type ?? "resource",
          'value': attachment.id,
        }).toList();

        data['delete_attachments[]'] = attachmentsToDelete.map((attachment) => attachment.id).toList();
      }
    }

    return data;
  }

  Map<String, dynamic> getApiParams(FormProposalTemplateModel? template, {
    String? title,
    String? content,
    bool saveAs = false,
    bool isForUnsavedDB = false,
  }) {
    final attachmentsJson = getAttachmentsJson(isForUnsavedDB);

    Map<String, dynamic> data = {
      'job_id': jobId,
      'page_type': template?.pageType,
      'is_mobile': 1,
      'title': title ?? template?.title,
      'pages[0]': {
        'template': content,
        if (!isEditForm) 'tables': template?.tables,
        if(isForUnsavedDB) ...getMoreProposalParams(template)
      },
      ...attachmentsJson
    };

    if (isEditForm && !saveAs) {
      data.putIfAbsent('id', () => templateId);
    }

    if (saveAs) {
      data.putIfAbsent('save_as', () => templateId);
    }

    return data;
  }

  Map<String, dynamic> getMoreProposalParams(FormProposalTemplateModel? template) {
    return {
      "id": template?.id,
      "image": template?.image,
      "thumb": template?.thumb,
      "is_proposal_page": template?.isProposalPage,
    };
  }

  Map<String, dynamic> proposalPagesParams({
    int? proposalId,
    int? worksheetId,
    bool worksheetPagesExist = false
  }) {

    if (worksheetId != null) {
      if (worksheetPagesExist) {
        return {
          "id": worksheetId,
          "limit": PaginationConstants.pageLimit50,
          "worksheet_id": worksheetId,
        };
      } else {
        return {
          'includes[]': 'pages_detail',
          'limit': PaginationConstants.pageLimit50,
        };
      }
    }

    return {
      "id": proposalId,
      "includes[]": "pages",
      "without_content": 1,
    };
  }

  Map<String, dynamic> templateByGroup(List<String?> groups) {
    return {
      "group_ids[]": groups,
      "includes[]": "pages",
      "insurance_estimate": 1,
      "limit": 0,
      "type": "proposal",
      "without_content": 1,
    };
  }
}