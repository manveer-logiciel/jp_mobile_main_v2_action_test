import 'dart:convert';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import '../../core/constants/urls.dart';
import '../providers/http/interceptor.dart';

class DocumentExpiredRepository {
  
  static Future<FilesListingModel> getResources(String id) async {
    try {
      final response = await dio.get(Urls.resourcesAttachment(id));
      final jsonData = json.decode(response.toString());
      return FilesListingModel.fromCompanyFilesJson(jsonData['data']);
    } catch (e) {
      rethrow;
    }
  }

  static Future<FilesListingModel> getEstimate(String id) async {
    try {
      final response = await dio.get(Urls.estimatorAttachment(id),queryParameters: {'id':id});
      final jsonData = json.decode(response.toString());
      return FilesListingModel.fromEstimatesJson(jsonData['data']);
    } catch (e) {
      rethrow;
    }
  }

  static Future<FilesListingModel> getProposal(String id) async {
    try {
      final response = await dio.get(Urls.getProposalsFile(id),queryParameters: {'id':id});
      final jsonData = json.decode(response.toString());
      return FilesListingModel.fromJobProposalJson(jsonData['data']);
    } catch (e) {
      rethrow;
    }
  }
}