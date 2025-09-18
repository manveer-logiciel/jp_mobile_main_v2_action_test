
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/repositories/job_photos.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/Thumb/type.dart';

class FileListingPhotosQuickActionRepo {

  static Future<FilesListingModel> renameJobPhoto(FilesListingModel model, String newName) async {

    Map<String, dynamic> params = {
      'id': model.id,
      'name': newName.trim(),
    };

    FilesListingModel data = await JobPhotosRepository.renameResource(params);

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.rename, null, model.isDir == 1));

    return data;
  }

  static Future<dynamic> rotateJobPhotos(FilesListingQuickActionParams params, String angle) async {

    Map<String, dynamic> requestParams = {
      'rotation_angle': angle,
    };

    for (var element in params.fileList) {
      final data = await JobPhotosRepository.rotateImage(element.id!, requestParams);
      data.jpThumbType = JPThumbType.image;
      data.showThumbImage = true;
      params.onActionComplete(data, FLQuickActions.rotate);
    }

    await Future<void>.delayed(const Duration(seconds: 1));

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.rotate, params));
  }

  static Future<void> moveJobPhoto(FilesListingQuickActionParams params, {required int dirId}) async {

    Map<String, dynamic> requestParams = {
      'move_to': dirId,
      for (int i = 0; i < params.fileList.length; i++)
        'resource_ids[$i]': params.fileList[i].id
    };

    await JobPhotosRepository.moveMultipleResource(requestParams);
    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.move, params));
    params.onActionComplete(params.fileList.first, FLQuickActions.move);
  }

  static Future<void> deleteJobPhoto(FilesListingQuickActionParams params) async {
    if (params.fileList.first.isDir == 1) {
      await JobPhotosRepository.removeDirectory(params.fileList.first.id!);
    } else {
      Map<String, dynamic> requestParams = {
        for (int i = 0; i < params.fileList.length; i++)
          'resource_ids[$i]': params.fileList[i].id
      };

      await JobPhotosRepository.removeMultipleResource(requestParams);
    }

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.delete, params));
    params.onActionComplete(params.fileList.first, FLQuickActions.delete);
  }

  static Future<void> showHideOnCustomerWebPageJobPhotos(FilesListingQuickActionParams params, FLQuickActions action) async {
    List<String> selectedFileIds = [];
    if (params.isInSelectionMode!) {
      for (FilesListingModel element in params.fileList) {
        selectedFileIds.add(element.id.toString());
      }
    }
    Map<String, dynamic> param = {
      if(!params.isInSelectionMode!) 'id': params.fileList.first.id,
      if(params.isInSelectionMode!) 'resource_ids[]' : selectedFileIds,
      'share': action == FLQuickActions.showOnCustomerWebPage ? 1 : 0,
    };

    await JobPhotosRepository.showHideOnCustomerWebPage(params.isInSelectionMode!, param);
    if(params.isInSelectionMode!){
      for(int i=0; i<params.fileList.length; i++) {
        if(action == FLQuickActions.showOnCustomerWebPage){
          params.fileList[i].isShownOnCustomerWebPage = true;
        }
        else{
          params.fileList[i].isShownOnCustomerWebPage = false;
        }
        params.onActionComplete(params.fileList[i], FLQuickActions.showOnCustomerWebPage);
      }
    }
    else{
      final result = !params.fileList.first.isShownOnCustomerWebPage!;
      params.fileList.first.isShownOnCustomerWebPage = result;
      params.onActionComplete(params.fileList.first, FLQuickActions.showOnCustomerWebPage);
    }
    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(
          action == FLQuickActions.showOnCustomerWebPage
              ? FLQuickActions.showOnCustomerWebPage
              : FLQuickActions.removeFromCustomerWebPage,
          params));
    
  }

  static Future<void> copyFile(List<FilesListingModel> selectedFiles,int jobId,FLModule type, String saveAs,{required int dirId}) async {
    for (var file in selectedFiles) {
      Map<String, dynamic> param = {
        "file_id": file.id,
        "job_id": jobId,
        "save_as": saveAs,
        if (dirId != -1) 'parent_id': dirId,
      };
      await JobPhotosRepository.resourceCopyTo(param);
    } 
  }
}