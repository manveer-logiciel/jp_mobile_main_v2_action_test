
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/drawing_tool/drawing_tool_quick_action_params.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/common/repositories/estimations.dart';
import 'package:jobprogress/common/repositories/templates.dart';
import 'package:jobprogress/core/constants/urls.dart';

import '../../repositories/job_photos.dart';
import '../../repositories/job_proposal.dart';
import 'index.dart';

class DrawingToolRepo {

  static Future<String?> getBase64String({
    required FLModule type,
    required int id,
  }) async {
    try {
      Map<String, dynamic> params = {
        "base64_encoded": 1,
        "id": id
      };

      String url = "";

      switch (type) {

        case FLModule.estimate:
          url = "${Urls.estimationsFile}/$id";
          break;

        case FLModule.jobPhotos:
          url = Urls.resourcesGetFile;
          break;

        case FLModule.jobProposal:
          url = "${Urls.proposalsFile}/$id";
          break;

        default:
          return null;
      }

      final response = await dio.get(url, queryParameters: params);
      final json = response.data;

      return DrawingToolService.removeExtrasFromBase64String(json['data']?.toString() ?? "").trim();
    } catch(e) {
      rethrow;
    }
  }

  static Future<FilesListingModel> saveEstimate(DrawingToolQuickActionParams actionParams) async {

    try {
      Map<String, dynamic> params = {
        "base64_string": actionParams.base64String,
        "id": actionParams.id.toString(),
        "rotation_angle": actionParams.rotationAngle,
      };

      FilesListingModel response = await EstimatesRepository.saveEditedImage(params);

      return response;
    } catch(e) {
      rethrow;
    }

  }

  static Future<FilesListingModel> saveAsEstimate(DrawingToolQuickActionParams actionParams) async {

    try {
      Map<String, dynamic> params = {
        "file": actionParams.base64String,
        "rotation_angle": actionParams.rotationAngle,
        "image_base_64": 1,
        "job_id": actionParams.jobId,
        "title": actionParams.title,
      };

      FilesListingModel response = await EstimatesRepository.saveAsEditedImage(params);
      return response;
    } catch(e) {
      rethrow;
    }

  }

  ///////////////////////////////    JOB PHOTOS   ///////////////////////////////

  static Future<FilesListingModel> saveJobPhotos(DrawingToolQuickActionParams actionParams) async {
    try {
      Map<String, dynamic> params = {
        "base64_string": actionParams.base64String,
        "id": actionParams.id.toString(),
        "rotation_angle": actionParams.rotationAngle,
      };
      FilesListingModel response = await JobPhotosRepository.saveEditedImage(params);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  static Future<FilesListingModel> saveAsJobPhotos(DrawingToolQuickActionParams actionParams) async {
    try {
      Map<String, dynamic> params = {
        "name": actionParams.title,
        "file": actionParams.base64String,
        "parent_id": actionParams.parentId.toString(),
        "rotation_angle": actionParams.rotationAngle,
        "image_base_64": 1,
        "job_id": actionParams.jobId,
      };
      FilesListingModel response = await JobPhotosRepository.saveAsEditedImage(params);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  //////////////////////////////    JOB PROPOSAL   //////////////////////////////

  static Future<FilesListingModel> saveJobProposal(DrawingToolQuickActionParams actionParams) async {
    try {
      Map<String, dynamic> params = {
        "base64_string": actionParams.base64String,
        "id": actionParams.id.toString(),
        "rotation_angle": actionParams.rotationAngle,
      };
      FilesListingModel response = await JobProposalRepository.saveEditedImage(params);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  static Future<FilesListingModel> saveAsJobProposal(DrawingToolQuickActionParams actionParams) async {
    try {
      Map<String, dynamic> params = {
        "title": actionParams.title,
        "file": actionParams.base64String,
        "rotation_angle": actionParams.rotationAngle,
        "image_base_64": 1,
        "job_id": actionParams.jobId,
      };
      FilesListingModel response = await JobProposalRepository.saveAsEditedImage(params);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  //////////////////////////////   ESTIMATE TEMPLATE   //////////////////////////////

  static Future<FilesListingModel> saveJobImage(DrawingToolQuickActionParams actionParams) async {
    try {
      Map<String, dynamic> params = {
        "base64_string": actionParams.base64String,
        "job_id": actionParams.jobId.toString(),
        "rotation_angle": actionParams.rotationAngle,
      };
      FilesListingModel response = await TemplatesRepository.saveEditedImage(params);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  static Future<FilesListingModel> saveAsResource(DrawingToolQuickActionParams actionParams) async {
    try {
      Map<String, dynamic> params = {
        "name": actionParams.title,
        "file": actionParams.base64String,
        "rotation_angle": actionParams.rotationAngle,
        "image_base_64": 1,
        "job_id": actionParams.jobId,
        "parent_id": actionParams.parentId
      };
      FilesListingModel response = await TemplatesRepository.saveAsResource(params);
      return response;
    } catch(e) {
      rethrow;
    }
  }

}