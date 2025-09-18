
import 'package:jobprogress/common/models/sql/uploader/file_uploader_params.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';

class UploadFileTypeParams {

  static Map<String, dynamic> getParams(FileUploaderParams params) {

    switch (params.type) {
      case FileUploadType.measurements:
        return {
          'job_id': params.job!.id,
          'parent_id': params.parentId,
          'includes[]': 'created_by'
        };

      case FileUploadType.estimations:
        return {
          'job_id': params.job!.id,
          'parent_id': params.parentId,
          'includes[]': 'createdBy'
        };

      case FileUploadType.formProposals:
        return {
          'job_id': params.job!.id,
          'parent_id': params.parentId,
          'includes[]': 'createdBy'
        };

      case FileUploadType.materialList:
        return {
          'job_id': params.job!.id,
          'parent_id': params.parentId,
          'type' : 'material_list',
          'includes[]': 'created_by'
        };

      case FileUploadType.workOrder:
        return {
          'job_id': params.job!.id,
          'parent_id': params.parentId,
          'includes[]': 'created_by'
        };

      case FileUploadType.companyFiles:
        return {
          'parent_id': params.parentId,
        };

      case FileUploadType.photosAndDocs:
        return {
          'job_id': params.job!.id,
          'parent_id': params.parentId,
          'includes[]': 'multi_size_images'
        };

      default:
        return {};
    }

  }

  static Map<String,dynamic> getGoogleSheetParams(FileUploaderParams params,Map<String,dynamic> additionalParam) {
    switch(params.type){
      case FileUploadType.estimations:
        return {
          "title": additionalParam['file_name'],
          "job_id": additionalParam['job_id'],
        };

      case FileUploadType.formProposals:
         return {
          "title": additionalParam['file_name'],
          "job_id": additionalParam['job_id'],
        };

      default:
        return {};
    }
  }

  static Map<String, dynamic> getParamsFromOldExtraData(String type, Map<String, dynamic> extraData) {
      switch(type) {
        case FileUploadType.materialList:
          extraData['type'] = 'materialList';
          extraData['includes[]'] = 'created_by';
          break;

        case FileUploadType.measurements:
        case FileUploadType.estimations:
        case FileUploadType.workOrder:
        case FileUploadType.formProposals:
          extraData['includes[]'] = 'created_by';
          break;

        case FileUploadType.photosAndDocs:
          extraData['includes[]'] = 'multi_size_images';
          break;
      }
      return extraData;
  }

}