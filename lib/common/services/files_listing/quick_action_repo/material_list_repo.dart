
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/repositories/material_lists.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/Thumb/type.dart';

class FileListingMaterialListQuickActionRepo {

  static Future<FilesListingModel> renameMaterialList(FilesListingModel model, String newName) async {

    bool success = false;

    if (model.isDir == 1) {
      Map<String, dynamic> params = {
        'id': model.id,
        'name': newName.trim(),
      };
      success = await MaterialListsRepository.folderRename(params);
    } else {
      Map<String, dynamic> params = {
        'id': model.id,
        'title': newName.trim(),
      };
      success = await MaterialListsRepository.fileRename(params);
    }

    FilesListingModel data = model;

    if (success) {
      data.name = newName;
    }

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.rename, null, model.isDir == 1));

    return data;
  }

  static Future<dynamic> rotateMaterialList(FilesListingQuickActionParams params, String angle) async {
    Map<String, dynamic> requestParams = {
      'id': '',
      'rotation_angle': angle,
    };

    for (var element in params.fileList) {
      requestParams['id'] = element.id;
      final data = await MaterialListsRepository.rotateImage(element.id!, requestParams);
      data.jpThumbType = JPThumbType.image;
      data.showThumbImage = true;
      data.parentId = int.tryParse(element.parentId.toString());
      params.onActionComplete(data, FLQuickActions.rotate);
    }

    await Future<void>.delayed(const Duration(seconds: 1));

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.rotate, params));
  }

  static Future<void> moveMaterialList(FilesListingQuickActionParams params, {required int dirId}) async {

    Map<String, dynamic> requestParams = {
      if (dirId != -1) 'parent_id': dirId,
      'job_id': params.fileList.first.jobId,
      for (int i = 0; i < params.fileList.length; i++)
        'ids[$i]': params.fileList[i].id
    };

    await MaterialListsRepository.moveFiles(requestParams);
    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.move, params));
    params.onActionComplete(params.fileList.first, FLQuickActions.move);
  }

  static Future<void> deleteMaterialList(FilesListingQuickActionParams params) async {
    if (params.fileList.first.isDir == 1) {
      await MaterialListsRepository.removeDirectory(params.fileList.first.id!);
    } else {
      await MaterialListsRepository.removeFile(params.fileList.first.id!);
    }
    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.delete, params));
    params.onActionComplete(params.fileList.first, FLQuickActions.delete);
  }

  static Future<void> unMarkAsFavouriteMaterialList(FilesListingQuickActionParams params) async {
    await MaterialListsRepository.unMarkAsFavourite(
        params.fileList.first.myFavouriteEntity!.id!);

    params.fileList.first.myFavouriteEntity = null;

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(
        FLQuickActions.unMarkAsFavourite, params));
    params.onActionComplete(params.fileList.first, FLQuickActions.unMarkAsFavourite);
  }

  static Future<void> markAs(FilesListingQuickActionParams params, FLQuickActions action) async {
    bool success = false;
    Map<String, dynamic> requestedParams = {
      'status': action == FLQuickActions.markAsPending ? 'open' : 'completed',
    };
    success = await MaterialListsRepository.changeStatus(params.fileList.first.id!, requestedParams);
    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(action));
    if(success){
      params.fileList.first.status = action == FLQuickActions.markAsPending ? 'open' : 'completed';
    }
    params.onActionComplete(params.fileList.first, action);
  }
}