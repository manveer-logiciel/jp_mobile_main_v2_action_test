import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jobprogress/common/models/email/template_list.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/proposals/proposals_share_email.dart';
import 'package:jobprogress/common/models/templates/form_proposal/template.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class JobProposalRepository {

  static Future<Map<String, dynamic>> fetchFiles(
      Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.proposals, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<FilesListingModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": jsonData?["meta"]?["pagination"]
      };

      //Converting api data to model
      jsonData["data"].forEach((dynamic estimate) =>
      {dataToReturn['list'].add(FilesListingModel.fromJobProposalJson(estimate))});

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> fileRename(Map<String, dynamic> params) async {
    try {
      final response =
      await dio.put('${Urls.proposalsRename}/${params['id']}', queryParameters: params);
      final jsonData = json.decode(response.toString());


      // Converting api data to model
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> folderRename(Map<String, dynamic> params) async {
    try {
      final response =
      await dio.put(Urls.proposalFolderRename(params['id']), queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> showHideOnCustomerWebPage(Map<String, dynamic> params) async {
    try {
      final response =
      await dio.put(Urls.proposalsShareOnHop(int.parse(params['id'])), queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<FilesListingModel> rotateImage(
    String id, Map<String, dynamic> params) async {
    try {
      final response =
      await dio.post(Urls.proposalRotateImage(id), queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return FilesListingModel.fromEstimatesJson(jsonData["data"]);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> moveFiles(
      Map<String, dynamic> params) async {
    try {
      final response =
      await dio.put(Urls.proposalsMoveFiles, queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData["status"] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> removeFile(String id) async {
    try {
      final response = await dio.delete(Urls.getProposalsFile(id));
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData["status"] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> removeDirectory(String id) async {
    try {
      final response =
      await dio.delete(Urls.deleteProposalFolder(id));
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData["status"] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> unMarkAsFavourite(int id) async {
    try {
      final response =
      await dio.delete(Urls.unMarkFavouriteEntities(id));
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData["status"] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<FilesListingModel> createDirectory(
      Map<String, dynamic> params) async {
    try {
      final response =
      await dio.post(Urls.proposalsFolder, queryParameters: params);
      final jsonData = json.decode(response.toString());

      jsonData["data"]['is_dir'] = 1;
      // Converting api data to model
      return FilesListingModel.fromJobProposalJson(jsonData["data"]);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<String> getShareUrl(String id) async {
    try {
      final response =
      await dio.get(Urls.proposalShareEmail(id));
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return ProposalShareEmail.fromJson(jsonData['data']).shareUrl!;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> makeACopy(Map<String, dynamic> params) async {
    try {
      final response =
      await dio.post(Urls.proposalsCopy, queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> updateStatus(Map<String, dynamic> params) async {
    try {
      final response =
      await dio.put(Urls.proposalsStatus(int.parse(params['id'])), queryParameters: params);

      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> updateProposalNote(Map<String, dynamic> params) async {
    try {

      final response =
      await dio.put(Urls.proposalsUpdateNote(int.parse(params['id'].toString())), queryParameters: params);

      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<FilesListingModel> getProposalTemplate(Map<String, dynamic> params, {
    bool isMergeTemplate = false,
    bool isTemporaryTemplate = false,
  }) async {
    try {

      String url = isMergeTemplate
          ? isTemporaryTemplate ? "${Urls.proposalTempPage}/${params['id']}" : Urls.proposalsPage(params['page_id'])
          : "${Urls.proposals}/${params['id']}";

      final response = await dio.get(url, queryParameters: params);

      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return FilesListingModel.fromJobProposalJson(jsonData["data"]);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }


  static Future<FilesListingModel> getWorksheetTemplate(Map<String, dynamic> params, {
    bool companyTemplates = false,
  }) async {
    try {

      final url = companyTemplates
          ? Urls.companyWorksheetTemplates
          : Urls.worksheetTemplatePages(params['id'].toString());

      final response = await dio.get(url, queryParameters: params);

      final jsonData = json.decode(response.toString());

      List<FormProposalTemplateModel> templates = [];

      jsonData['data'].forEach((dynamic template) {
        if (companyTemplates) {
          template['pages_detail']?['data'].forEach((dynamic pageData) {
            final page = FormProposalTemplateModel.fromJson(pageData);
            page.title = template['title'];
            page.pageType = template['page_type'];
            templates.add(page);
          });
        } else {
          templates.add(FormProposalTemplateModel.fromJson(template));
        }
      });

      // Converting api data to model
      return FilesListingModel(
        pageType: templates.isNotEmpty ? templates.first.pageType : null,
        proposalTemplatePages: templates
      );
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  /////////////////   DRAWING TOOL SAVE AND SAVE AS ACTIONS   //////////////////

  static Future<FilesListingModel> saveEditedImage(Map<String, dynamic> params) async {
    try {
      final formData = FormData.fromMap(params);
      final response = await dio.post(Urls.proposalsEditImage(params['id']), data: formData);
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return FilesListingModel.fromJobProposalJson(jsonData);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<FilesListingModel> saveAsEditedImage(Map<String, dynamic> params) async {
    try {
      final formData = FormData.fromMap(params);
      final response = await dio.post(Urls.proposalsFile, data: formData);
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return FilesListingModel.fromJobProposalJson(jsonData['data']);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<EmailTemplateListingModel> getEmailTemplate(String id, Map<String,dynamic> params ) async {
    try {
      final response = await dio.get(Urls.proposalShareEmail(id), queryParameters:params);
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return EmailTemplateListingModel.fromJson(jsonData["data"]);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<String> fetchCumulativeInvoiceNote(int jobId) async {
  try {
    final response = await dio.get(Urls.cumulativeInvoiceNote(jobId));
    final jsonData = json.decode(response.toString());
    // Converting api data to model
    return jsonData["data"]?["note"] ?? "";
  } catch (e) {
    //Handle error
    rethrow;
  }
  }

  static Future<bool> saveCumulativeInvoiceNote(int jobId, Map<String, dynamic> params,) async {
    try {
      final response = await dio.post(Urls.cumulativeInvoiceNote(jobId), queryParameters: params);
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return jsonData["status"] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> signProposal(Map<String, dynamic> params) async {
    try {
      final response = await dio.put(Urls.signProposal(params['id'].toString()), data: params);
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return jsonData["status"] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

}