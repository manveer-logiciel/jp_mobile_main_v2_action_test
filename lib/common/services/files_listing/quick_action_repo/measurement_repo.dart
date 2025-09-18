import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/repositories/measurements.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/Thumb/type.dart';

class FileListingMeasurementRepoQuickActionRepo {

  static Future<FilesListingModel> renameMeasurement(FilesListingModel model, String newName) async {

    bool success = false;

    if (model.isDir == 1) {
      Map<String, dynamic> params = {
        'id': model.id,
        'name': newName.trim(),
      };
      success = await MeasurementsRepository.folderRename(params);
    } else {
      Map<String, dynamic> params = {
        'id': model.id,
        'title': newName.trim(),
      };
      success = await MeasurementsRepository.fileRename(params);
    }

    FilesListingModel data = model;

    if (success) {
      data.name = newName;
    }

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.rename, null, model.isDir == 1));

    return data;
  }

  static Future<dynamic> rotateMeasurement(FilesListingQuickActionParams params, String angle) async {

    Map<String, dynamic> requestParams = {
      'id': '',
      'rotation_angle': angle,
    };

    for (var element in params.fileList) {
      requestParams['id'] = element.id;
      final data = await MeasurementsRepository.rotateImage(element.id!, requestParams);
      data.jpThumbType = JPThumbType.image;
      data.showThumbImage = true;
      data.parentId = int.tryParse(element.parentId.toString());
      params.onActionComplete(data, FLQuickActions.rotate);
    }

    await Future<void>.delayed(const Duration(seconds: 1));

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.rotate, params));
  }

  static Future<void> moveMeasurement(FilesListingQuickActionParams params, {required int dirId}) async {

    Map<String, dynamic> requestParams = {
      if (dirId != -1) 'parent_id': dirId,
      'job_id': params.fileList.first.jobId,
      for (int i = 0; i < params.fileList.length; i++)
        'ids[$i]': params.fileList[i].id
    };

    await MeasurementsRepository.moveFiles(requestParams);
    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.move, params));
    params.onActionComplete(params.fileList.first, FLQuickActions.move);
  }

  static Future<void> deleteMeasurement(FilesListingQuickActionParams params) async {
    if (params.fileList.first.isDir == 1) {
      await MeasurementsRepository.removeDirectory(params.fileList.first.id!);
    } else {
      await MeasurementsRepository.removeFile(params.fileList.first.id!);
    }

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.delete, params));
    params.onActionComplete(params.fileList.first, FLQuickActions.delete);
  }

  static Future<void> changeDeliverableStatus(FilesListingQuickActionParams params, int deliverableId) async{

    Map<String, dynamic> param = {
      "job_id": params.jobModel?.id,
      "new_deliverable_id": deliverableId,
    };

    bool response = await MeasurementsRepository.changeDeliverableStatus(param);

    params.fileList.first.hoverJob?.deliverableId = deliverableId;
    params.fileList.first.isUpgradeToHoverRoofOnlyVisible = !(deliverableId == 2 || deliverableId == 3);
    params.fileList.first.isUpgradeToHoverRoofCompleteVisible = !(deliverableId == 3);

    if(response){
      params.onActionComplete(params.fileList.first, FLQuickActions.upgradeToHoverRoofOnly);
      Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.upgradeToHoverRoofOnly, params));
    }
  }
}