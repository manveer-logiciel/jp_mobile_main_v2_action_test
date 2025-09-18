import 'dart:convert';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/templates/files.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/core/constants/urls.dart';

class ProposalTemplateRepository {

  static Future<Map<String, dynamic>> fetchFiles(Map<String, dynamic> params, {bool includeMergeTemplates = false}) async {
    try {
      final response = await dio.get(Urls.templates, queryParameters: params);
      final jsonData = json.decode(response.toString());

      List<FilesListingModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": jsonData["meta"]["pagination"]
      };

      if (includeMergeTemplates) {
        (dataToReturn['list'] as List).add(FilesListingTemplateFiles.imageTemplate);
        if(FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.financeAndAccounting])) {
          (dataToReturn['list'] as List).add(FilesListingTemplateFiles.sellingPriceSheet);
        }
      }

      //Converting api data to model
      jsonData["data"].forEach((dynamic task) =>
      {dataToReturn['list'].add(FilesListingModel.fromTemplateListingJson(task))});

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
  static Future<Map<String, dynamic>> searchTemplateListingFile(
      Map<String, dynamic> params,) async {
    try {
      final response = await dio.get(Urls.templates, queryParameters: params);
      final jsonData = json.decode(response.toString());

      List<FilesListingModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": jsonData["meta"]["pagination"]
      };

      //Converting api data to model
      jsonData["data"].forEach((dynamic task) =>
      {dataToReturn['list'].add(FilesListingModel.fromTemplateListingJson(task))});

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
}