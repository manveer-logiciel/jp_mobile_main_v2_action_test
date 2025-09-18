import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/templates/form_proposal/template.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class TemplatesRepository {

  static Future<FormProposalTemplateModel> fetchTemplate(Map<String, dynamic> params, {
    bool isMergeTemplate = false,
    bool isTemporaryTemplate = false,
    bool isProposalPage = false,
  }) async {
    try {
      
      String getPageUrl = isProposalPage
          ? Urls.proposalsPage(params['page_id'].toString())
          : Urls.templatesPage(params['page_id'].toString());
      
      String url = isMergeTemplate
          ? isTemporaryTemplate ? "${Urls.proposalTempPage}/${params['id']}" : getPageUrl
          : Urls.getTemplate(params['id'].toString());

      final response = await dio.get(url, queryParameters: params);
      final jsonData = json.decode(response.toString());
      return FormProposalTemplateModel.fromJson(jsonData["data"]);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<List<FilesListingModel>> getTemplatesByGroups(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.templatesByGroups, queryParameters: params);
      final jsonData = json.decode(response.toString());

      List<FilesListingModel> templates = [];


      if (jsonData["data"] != null) {
        params['group_ids[]'].forEach((dynamic id) {
          jsonData["data"]?[id]?.forEach((dynamic page) {
            templates.add(FilesListingModel.fromTemplateListingJson(page));
          });
        });
      }

      return templates;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<List<String?>> getAttachmentUrl(List<AttachmentResourceModel> attachments) async {
    try {
      final params = {
        "attachments" : attachments.map((attachment) => {
          "type": attachment.type,
          "value": attachment.id,
        }).toList()
      };

      List<String> urls = [];

      final response = await dio.post(Urls.templateImage, data: params);
      final jsonData = json.decode(response.toString());

      //Converting api data to model
      jsonData["data"].forEach((dynamic data) {
        urls.add(data['url']);
      });

      return urls;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> saveTemplate(Map<String, dynamic> params, {bool updateForm = false}) async {
    try {
      final formData = FormData.fromMap(params);
      Response<dynamic> response;
      if (updateForm) {
        response = await dio.put("${Urls.proposals}/${params['id']}", data: params, options: putRequestFormOptions);
      } else {
        response = await dio.post(Urls.proposals, data: formData);
      }
      final jsonData = json.decode(response.toString());
      return jsonData["status"] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<FilesListingModel> saveMergeTemplate(Map<String, dynamic> params, {bool updateForm = false}) async {
    try {
      final formData = FormData.fromMap(params);
      Response<dynamic> response;
      if (updateForm) {
        response = await dio.put(Urls.updateProposalByPages(params['proposal_id'].toString()), data: params, options: putRequestFormOptions);
      } else {
        response = await dio.post(Urls.createProposalByPages, data: formData);
      }
      final jsonData = json.decode(response.toString());
      return FilesListingModel.fromJobProposalJson(jsonData?['data']);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<int?> temporarySaveMergeTemplate(Map<String, dynamic> params, {bool updateForm = false}) async {
    try {
      Response<dynamic> response;
      if (updateForm) {
        response = await dio.put("${Urls.proposalTempPage}/${params['temp_id']}", data: params, options: putRequestFormOptions);
      } else {
        response = await dio.post(Urls.proposalTempPage, data: params, options: putRequestFormOptions);
      }
      final jsonData = json.decode(response.toString());
      return jsonData["data"]?['id'];
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<List<AttachmentResourceModel>> uploadImages(List<FilesListingModel> files, FLModule moduleType) async {
    try {
      Map<String, dynamic> params = {
        "attachments": files.map((file) => {
          "type": Helper.resourceType(moduleType),
          "value": file.id
        }).toList()
      };
      List<AttachmentResourceModel> attachments = [];
      Response<dynamic> response = await dio.post(Urls.templateImage, queryParameters: params);
      final jsonData = json.decode(response.toString());
      jsonData["data"]?.forEach((dynamic data) {
        attachments.add(AttachmentResourceModel.fromJson(data)..moduleType = moduleType);
      });

      return attachments;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> deleteImage(Map<String, dynamic> params) async {
    try {
      Response<dynamic> response = await dio.delete(Urls.templateImage, queryParameters: params);
      final jsonData = json.decode(response.toString());
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<FilesListingModel> saveEditedImage(Map<String, dynamic> params) async {
    try {
      final formData = FormData.fromMap(params);
      final response = await dio.post(Urls.jobsSaveImage, data: formData);
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return FilesListingModel.fromEstimatesJson(jsonData);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<FilesListingModel> saveAsResource(Map<String, dynamic> params) async {
    try {
      final formData = FormData.fromMap(params);
      final response = await dio.post(Urls.resourcesFile, data: formData);
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return FilesListingModel.fromCompanyFilesJson(jsonData);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

}