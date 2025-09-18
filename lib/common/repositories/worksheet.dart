import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/templates/form_proposal/template.dart';
import 'package:jobprogress/common/models/worksheet/response.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_detail_category_model.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_model.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';

import '../models/srs_smart_template/srs_smart_template_model.dart';

class WorksheetRepository {

  static Future<List<String>> getTiers(Map<String, dynamic> params) async {
    try {
      final List<String> list = [];
      final response = await dio.get(Urls.tiers, queryParameters: params);
      final jsonData = json.decode(response.toString());
      jsonData["data"].forEach((dynamic tier) {
        list.add(tier['name']);
      });
      return list;
    } catch (e) {
      rethrow;
    }
  }

  static Future<WorksheetResponseModel> getWorksheet(Map<String, dynamic> params) async {
    try {
      final response = await dio.get("${Urls.worksheet}/${params['id']}", queryParameters: params);
      final jsonData = json.decode(response.toString());
      return WorksheetResponseModel.fromJson(jsonData['data']);
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<WorksheetDetailCategoryModel>> fetchCategories(Map<String, dynamic> params) async {
    try {
      List<WorksheetDetailCategoryModel> list = [];
      final response = await dio.get(Urls.financialCategories, queryParameters: params);
      final jsonData = json.decode(response.toString());
      jsonData["data"].forEach((dynamic categories) {
        list.add(WorksheetDetailCategoryModel.fromJson(categories));
      });
      return list;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<WorksheetModel> saveWorksheet(Map<String, dynamic> params) async {
    try {
      final formData = FormData.fromMap(params);
      final response = await dio.post(Urls.worksheet, data: formData);
      final jsonData = json.decode(response.toString());
      WorksheetModel data = WorksheetModel.fromWorksheetJson(jsonData['data']);
      data.setWorksheetFile(jsonData['data']);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<String> previewWorksheet(Map<String,dynamic> params) async {
    try {
      final response = await dio.post(Urls.worksheetPdfPreview, data: params);
      final jsonData = json.decode(response.toString());
      return jsonData['data']['file_path'];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<FormProposalTemplateModel>> getCompanyWorksheetTemplates() async {
    try {
      final response = await dio.get(Urls.companyWorksheetTemplates);
      final jsonData = json.decode(response.toString());
      List<FormProposalTemplateModel> list = [];

      jsonData['data'].forEach((dynamic data) {
        list.add(FormProposalTemplateModel.fromJson(data));
      });

      return list;
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<JPMultiSelectModel>> getWorksheetCategories(String id) async {
    try {
      final response = await dio.get(Urls.worksheetCategories(id));
      final jsonData = json.decode(response.toString());
      List<JPMultiSelectModel> categories = [];
      jsonData['data'].forEach((dynamic category) {
        categories.add(JPMultiSelectModel(
            label: category['name'] ?? "",
            id: (category['id'] ?? "").toString(),
            isSelect: category['name'] == WorksheetConstants.categoryLabor,
          ),
        );
      });

      return categories;
    } catch (e) {
      rethrow;
    }
  }

  static Future<FormProposalTemplateModel> fetchTemplate(Map<String, dynamic> params, {
    bool isTemporaryTemplate = false,
    bool isWorksheet = false,
  }) async {
    try {

      String url = isWorksheet
          ? Urls.worksheetTemplatePage(params['page_id'].toString())
          : Urls.templatesPage(params['page_id'].toString());

      final response = await dio.get(url, queryParameters: params);
      final jsonData = json.decode(response.toString());
      return FormProposalTemplateModel.fromJson(jsonData["data"]);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<FilesListingModel> saveTemplate(Map<String, dynamic> params, {bool updateForm = false}) async {
    try {
      final formData = FormData.fromMap(params);
      Response<dynamic> response;
      if (updateForm) {
        response = await dio.put(Urls.worksheetTemplatePages(params['worksheet_id'].toString()), data: params, options: putRequestFormOptions);
      } else {
        response = await dio.post(Urls.createProposalByPages, data: formData);
      }

      final jsonData = json.decode(response.toString());
      List<FormProposalTemplateModel> templates = [];

      jsonData['data'].forEach((dynamic template) {
        templates.add(FormProposalTemplateModel.fromJson(template));
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

  static Future<SrsSmartTemplateModel?> fetchSrsSmartTemplates(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.srsSmartTemplate, queryParameters: params);

      final jsonData = json.decode(response.toString());
      if(jsonData['status'] == 200) {
        return SrsSmartTemplateModel.fromJson(jsonData['data']);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> getBeaconClient() async {
    try {
      final response = await dio.get(Urls.beaconClient);
      final jsonData = json.decode(response.toString());
      if(jsonData['status'] == 200) {
        return jsonData['data'];
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> setBeaconOAuthDetails(Map<String, dynamic> params) async {
    try {
      final response = await dio.post(Urls.beaconOauthDetails, data: params);
      final jsonData = json.decode(response.toString());
      return (jsonData['status'] == 200);
    } catch (e) {
      rethrow;
    }
  }
}