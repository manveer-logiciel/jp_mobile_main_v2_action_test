import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/templates/handwritten/template.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_detail_category_model.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

import '../enums/file_listing.dart';
import '../models/attachment.dart';
import '../models/files_listing/my_favourite_entity.dart';

class EstimatesRepository {

  static Future<Map<String, dynamic>> fetchFiles(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.estimations, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<FilesListingModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": jsonData?["meta"]?["pagination"]
      };

      //Converting api data to model
      jsonData["data"].forEach((dynamic estimate) =>
      {dataToReturn['list'].add(FilesListingModel.fromEstimatesJson(estimate))});

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> estimatesRename(Map<String, dynamic> params) async {
    try {
      final response =
      await dio.put('${Urls.estimationsRename}/${params['id']}', queryParameters: params);
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> estimateFolderRename(Map<String, dynamic> params) async {
    try {
      final response =
      await dio.put(Urls.estimationsFolderRename(params['id']), queryParameters: params);
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
      await dio.put(Urls.estimationsShareOnHop(int.parse(params['id'])), queryParameters: params);
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
      await dio.post(Urls.estimationsRotateImage(id), queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return FilesListingModel.fromEstimatesJson(jsonData["data"]);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<FilesListingModel> fetchWorksheet(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.financialWorksheetDetail(params['id']), queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return FilesListingModel.fromEstimatesJson(jsonData["data"], isInsurance: true);
    } catch (e) {
      //Handle error
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

  static Future<FilesListingModel> fetchEstimateFile(
    String id, Map<String, dynamic> params) async {
    try {
      final response =
      await dio.post(Urls.estimationsRotateImage(id), queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return FilesListingModel.fromEstimatesJson(jsonData["data"]);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<AttachmentResourceModel> getAttachment(String id)async{
    try {
      final response =
      await dio.get(Urls.estimatorAttachment(id));
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return AttachmentResourceModel.fromEmailJson(jsonData["data"], FLModule.estimate);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> moveFiles(
      Map<String, dynamic> params) async {
    try {
      final response =
      await dio.put(Urls.estimationsMoveFiles, queryParameters: params);
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
      final response = await dio.delete(Urls.deleteEstimationsFile(id));
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
      await dio.delete(Urls.deleteEstimationsFolder(id));
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
      await dio.post(Urls.estimationsFolder, queryParameters: params);
      final jsonData = json.decode(response.toString());

      jsonData["data"]['is_dir'] = 1;
      // Converting api data to model
      return FilesListingModel.fromEstimatesJson(jsonData["data"]);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<MyFavouriteEntity> markAsFavourite(Map<String, dynamic> params) async {
    try {
      final response = await dio.post(Urls.markFavouriteEntities, data: params);
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return MyFavouriteEntity.fromJson(jsonData["data"]);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<FilesListingModel> saveEditedImage(Map<String, dynamic> params) async {
    try {
      final formData = FormData.fromMap(params);
      final response =
      await dio.post(Urls.estimatesEditImage(params['id']), data: formData);
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return FilesListingModel.fromEstimatesJson(jsonData);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<FilesListingModel> saveAsEditedImage(Map<String, dynamic> params) async {
    try {
      final formData = FormData.fromMap(params);
      final response =
      await dio.post(Urls.estimationsFiles, data: formData);
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return FilesListingModel.fromEstimatesJson(jsonData['data']);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> createInsurance(Map<String,dynamic> params) async {
    try {
      final response = await dio.post(Urls.worksheet, data: params);
      final jsonData = json.decode(response.toString());
     
      return jsonData['status'] == 200;
    } catch (e) {
      rethrow;
    }
  }

  static Future<String> previewInsurance(Map<String,dynamic> params) async {
    try {
      final response = await dio.post(Urls.worksheetPdfPreview, data: params);
      final jsonData = json.decode(response.toString());
      return jsonData['data']['file_path'];
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> updateInsurance(Map<String,dynamic> params) async {
    try {
      final response = await dio.post(Urls.worksheet, data: params);
      final jsonData = json.decode(response.toString());
     
      return jsonData['status'] == 200;
    } catch (e) {
      rethrow;
    }
  }

  static Future<HandwrittenTemplateModel> fetchHandwrittenTemplate(Map<String,dynamic> params, {
    bool forEdit = false
  }) async {

    String url = forEdit ? Urls.estimations : Urls.templates;

    try {
      final response = await dio.get("$url/${params['id']}", queryParameters: params);
      final jsonData = json.decode(response.toString());
      return HandwrittenTemplateModel.fromJson(jsonData['data']);
    } catch (e) {
      rethrow;
    }
  }

  static Future<FilesListingModel> saveHandwrittenTemplate(Map<String, dynamic> params, {
    bool forEdit = false
  }) async {
    try {
      Response<dynamic> response;
      final formData = FormData.fromMap(params);
      if (forEdit) {
        response = await dio.put("${Urls.estimations}/${params['id']}", data: params, options: putRequestFormOptions);
      } else {
        response = await dio.post(Urls.estimations, data: formData);
      }
      final jsonData = json.decode(response.toString());
      return FilesListingModel.fromEstimatesJson(jsonData['data']);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }


}