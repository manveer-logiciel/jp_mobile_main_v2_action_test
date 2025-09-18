
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/repositories/stage_resources.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/Thumb/type.dart';

class FileListingStageResourceRepoQuickActionRepo {

  static Future<FilesListingModel> renameStageResource(FilesListingModel model, String newName) async {

    Map<String, dynamic> params = {
      'id': model.id,
      'name': newName.trim(),
    };

    FilesListingModel data = await StageResourcesRepository.renameResource(params);

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.rename, null, model.isDir == 1));

    return data;
  }

  static Future<dynamic> rotateStageResource(FilesListingQuickActionParams params, String angle) async {
    Map<String, dynamic> requestParams = {
      'rotation_angle': angle,
    };

    for (var element in params.fileList) {
      final data = await StageResourcesRepository.rotateImage(
          element.id!, requestParams);
      data.jpThumbType = JPThumbType.image;
      data.showThumbImage = true;
      params.onActionComplete(data, FLQuickActions.rotate);
    }

    await Future<void>.delayed(const Duration(seconds: 1));

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(
        FLQuickActions.rotate, params));
  }

  static Future<void> deleteStageResource(FilesListingQuickActionParams params) async {
    Map<String, dynamic> requestParams = {
      for (int i = 0; i < params.fileList.length; i++)
        'resource_ids[$i]': params.fileList[i].id
    };

    await StageResourcesRepository.removeMultipleResource(requestParams);

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.delete, params));
    params.onActionComplete(params.fileList.first, FLQuickActions.delete);
  }


}