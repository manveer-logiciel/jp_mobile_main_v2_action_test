import 'dart:convert';

import 'package:jobprogress/core/utils/date_time_helpers.dart';

import '../../../../common/enums/unsaved_resource_type.dart';
import '../../../../common/models/sql/user/user.dart';
import '../../../../common/repositories/sql/unsaved_resources.dart';
import '../../../../common/services/auth.dart';
import '../../helpers.dart';
import 'data_model.dart';

class UnsavedResourcesHelper {

  Future<int?> insertOrUpdate(int? unsavedResourceId, Map<String, dynamic> resource) async {
    try {
      UserModel? userDetails = AuthService.userDetails;

      resource.addEntries({
        "customer_id": userDetails?.customerId,
        "company_id": userDetails?.companyId,
      }.entries);

      if (unsavedResourceId != null) {
        return await updateUnsavedResource(id: unsavedResourceId, resource: resource);
      } else {
        return await insertUnsavedResource(resource);
      }
    } catch(e){
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> getUnsavedResource(int? unsavedResourceId) async =>
      await SqlUnsavedResourcesRepository().getOne(id: unsavedResourceId);

  static Future<Object> getAllUnsavedResources({required UnsavedResourceType type, required int jobId}) async {

    UserModel? userDetails = AuthService.userDetails;

    List<Map<String, dynamic>>? resourceList = await SqlUnsavedResourcesRepository().get(
      type: getUnsavedResourcesString(type),
      customerId: userDetails?.customerId,
      companyId: userDetails?.companyId,
      jobId: jobId,
    );

    return UnsavedResourcesDataModel.getListOfDataModel(type, resourceList);

  }

  Future<int?> insertUnsavedResource(Map<String, dynamic> resource) async {
    try {
      String currentDateTime = DateTimeHelper.now().toString();
      resource.addEntries({
        "created_at": currentDateTime,
        "updated_at": currentDateTime,
        "created_through": "v2"}.entries);
      return await SqlUnsavedResourcesRepository().insert(resource);
    } catch(e) {
      rethrow;
    }
  }

  Future<int?> updateUnsavedResource({int? id, Map<String, dynamic>? resource}) async {
    try {
      resource?.addEntries({"updated_at": DateTimeHelper.now().toString()}.entries);
      resource?.addEntries({"created_through": "v2"}.entries);
      await SqlUnsavedResourcesRepository().updateOne(id: id, param: resource);
      return id;
    } catch(e) {
      rethrow;
    }
  }

  static Future<bool> deleteUnsavedResource({required int id}) async {
    try {
      var response = await SqlUnsavedResourcesRepository().deleteOneResource(id: id);
      return Helper.isTrue(response[0]);
    } catch(e) {
      rethrow;
    }
  }

  static String getUnsavedResourcesString(UnsavedResourceType type) {
    switch(type) {
      case UnsavedResourceType.changeOrder: return "changeOrder";
      case UnsavedResourceType.invoice: return "invoice";
      case UnsavedResourceType.mergeTemplate: return "mergeTemplate";
      case UnsavedResourceType.proposalForm: return "proposalForm";
      case UnsavedResourceType.handWrittenTemplate: return "handWrittenTemplate";
      case UnsavedResourceType.estimateWorksheet: return "estimateWorksheet";
      case UnsavedResourceType.proposalWorksheet: return "proposalWorksheet";
      case UnsavedResourceType.materialWorksheet: return "materialWorksheet";
      case UnsavedResourceType.workOrderWorksheet: return "workOrderWorksheet";
    }
  }

  static String getOldAppResourcesTypeString(String type, dynamic data) {
    switch(type) {
      case "CHANGE_ORDER": return "changeOrder";
      case "INVOICE": return "invoice";
      case "proposal":
        return (jsonDecode(data)?['pages'] ?? <dynamic>[]).length > 1 ? "mergeTemplate" : "proposalForm";
      case "ESTIMATE_WORKSHEET": return "estimateWorksheet";
      case "PROPOSAL_WORKSHEET": return "proposalWorksheet";
      case "MATERIAL_WORKSHEET": return "materialWorksheet";
      case "WORKORDER_WORKSHEET": return "workOrderWorksheet";
      default: return "";
    }
  }

  static UnsavedResourceType getUnsavedResourcesType(String type) {
    switch(type) {
      case "changeOrder": return UnsavedResourceType.changeOrder;
      case "invoice": return UnsavedResourceType.invoice;
      case "mergeTemplate": return UnsavedResourceType.mergeTemplate;
      case "proposalForm": return UnsavedResourceType.proposalForm;
      case "handWrittenTemplate": return UnsavedResourceType.handWrittenTemplate;
      case "estimateWorksheet": return UnsavedResourceType.estimateWorksheet;
      case "proposalWorksheet": return UnsavedResourceType.proposalWorksheet;
      case "materialWorksheet": return UnsavedResourceType.materialWorksheet;
      case "workOrderWorksheet": return UnsavedResourceType.workOrderWorksheet;
      default: return UnsavedResourceType.changeOrder;
    }
  }

  static Map<String, dynamic> getOldAppUnsavedResourcesDataModel(Map<String, dynamic> oldAppURData, Map<String, dynamic>? unsavedResourceJson) {
    switch(unsavedResourceJson?["type"]) {
      case "mergeTemplate": return getFormProposalMergeTemplateJson(oldAppURData, unsavedResourceJson?["job_id"]);
      case "proposalForm": return getFormProposalTemplateJson(oldAppURData, unsavedResourceJson?["job_id"]);
      case "estimateWorksheet":
      case "proposalWorksheet":
      case "materialWorksheet":
      case "workOrderWorksheet":
        return getWorksheetJson(oldAppURData, unsavedResourceJson?["job_id"], unsavedResourceJson?["type"]);
      default: return {};
    }
  }

  static Map<String, dynamic> getFormProposalMergeTemplateJson(Map<String, dynamic> oldAppURData, int? jobId) {
    Map<String, dynamic> newAppURData = <String, dynamic>{};
    newAppURData["job_id"] = jobId;
    newAppURData["page_type"] = "template_page";
    newAppURData["insurance_estimate"] = Helper.isTrueReverse(oldAppURData["isInsuranceProposal"]);
    newAppURData["is_mobile"] = 1;
    newAppURData["includes[]"] = "pages";
    newAppURData["template_id"] = oldAppURData["currentPageId"]?.toString();
    newAppURData["template_title"] = oldAppURData["title"];
    newAppURData["isEditForm"] = oldAppURData['proposal_mode'] != 'create';
    newAppURData["proposal_id"] = oldAppURData['proposal_id'];
    newAppURData["pages"] = oldAppURData["pages"]?.map((dynamic oldPage) {
      return {
        "type": oldPage['temp_page_id'] != null ? "temp_proposal_page" : 'temp_page',
        "id": oldPage['id'],
        "temp_id": oldPage['temp_page_id'],
        "auto_fill_required": oldPage['auto_fill_required'],
        "content": oldPage['content'],
        "page_type": oldPage[''],
        "title": oldPage['title'],
        "is_visit_required": Helper.isTrue(oldPage['isVisitRequired'])
      };
    }).toList();
    return newAppURData;
  }

  static Map<String, dynamic> getFormProposalTemplateJson(Map<String, dynamic> oldAppURData, int? jobId) {
    Map<String, dynamic> newAppURData = <String, dynamic>{};
    newAppURData["title"] = oldAppURData["title"];
    newAppURData["template_id"] = oldAppURData["id"];
    newAppURData["template_title"] = oldAppURData["title"];
    newAppURData["page_type"] = oldAppURData["page_type"];
    newAppURData["is_mobile"] = 1;
    newAppURData["job_id"] = jobId;
    newAppURData["isEditForm"] = oldAppURData["proposal_mode"] != "create";
    /// Attachments
    var oldAppAttachmentList = oldAppURData["attached_images"] != null ? oldAppURData["attached_images"] as List : <dynamic>[];
    newAppURData["delete_attachments"] = <dynamic>[];
    newAppURData["attachments"] = <dynamic>[];
    for (var element in oldAppAttachmentList) {
      if (Helper.isTrue(element["isDeleted"])) {
        newAppURData["delete_attachments"].add(element);
      } else {
        newAppURData["attachments"].add(element);
      }
    }
    newAppURData["pages[0]"] = {
      "template": oldAppURData["unsaved_content"],
      "tables": (oldAppURData["tables"] as List<dynamic>).isNotEmpty ? oldAppURData["tables"]?.first : <String, dynamic>{},
      "id": oldAppURData["id"],
      "image": oldAppURData["image"],
      "thumb": oldAppURData["thumb"],
      "is_proposal_page": oldAppURData["type"] == "proposal",
    };
    return newAppURData;
  }

  static Map<String, dynamic> getWorksheetJson(Map<String, dynamic> oldAppURData, int? jobId, String proposalType) {
    Map<String, dynamic> newAppURData = <String, dynamic>{};
    newAppURData['isEditForm'] = oldAppURData["worksheetMode"] != "add";
    newAppURData['is_srs_enable'] = oldAppURData["srs_ship_to_address"] != null;
    newAppURData.addAll(oldAppURData);
    return newAppURData;
  }

}