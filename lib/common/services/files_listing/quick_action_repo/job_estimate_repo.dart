import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/repositories/company_files.dart';
import 'package:jobprogress/common/repositories/estimations.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/Thumb/type.dart';

class FileListingJobEstimateQuickActionRepo {
  static Future<FilesListingModel> renameJobEstimate(FilesListingModel model, String newName) async {
    bool success = false;

    if (model.isDir == 1) {
      Map<String, dynamic> params = {
        'id': model.id,
        'name': newName.trim(),
      };
      success = await EstimatesRepository.estimateFolderRename(params);
    } else {
      Map<String, dynamic> params = {
        'id': model.id,
        'title': newName.trim(),
      };
      success = await EstimatesRepository.estimatesRename(params);
    }

    FilesListingModel data = model;

    if (success) {
      data.name = newName;
    }

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.rename, null, model.isDir == 1));

    return data;
  }

  static Future<dynamic> rotateJobEstimate(FilesListingQuickActionParams params, String angle) async {
    Map<String, dynamic> requestParams = {
      'id': '',
      'rotation_angle': angle,
    };

    for (var element in params.fileList) {
      requestParams['id'] = element.id;
      final data =
          await EstimatesRepository.rotateImage(element.id!, requestParams);
      data.jpThumbType = JPThumbType.image;
      data.showThumbImage = true;
      data.parentId = int.tryParse(element.parentId.toString());
      params.onActionComplete(data, FLQuickActions.rotate);
    }

    await Future<void>.delayed(const Duration(seconds: 1));

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.rotate, params));
  }

  static Future<void> uploadFile(List<FilesListingModel> selectedFiles,int jobId,FLModule type, String saveAs) async {
    for (var file in selectedFiles) {
      Map<String, dynamic> param = {
        "file_id": file.id,
        "job_id": jobId,
        "save_as": saveAs, // save as define where file must be store in database.
      };
      await CompanyFilesRepository.resourceCopyTo(param, type).then((value) {
        if (!value) {
          Get.back();
          Helper.showToastMessage("upload_failed".tr);
        }
      });
    } 
  }

  static Future<void> moveJobEstimate(FilesListingQuickActionParams params,
      {required int dirId}) async {
    Map<String, dynamic> requestParams = {
      if (dirId != -1) 'parent_id': dirId,
      'job_id': params.fileList.first.jobId,
      for (int i = 0; i < params.fileList.length; i++)
        'ids[$i]': params.fileList[i].id
    };

    await EstimatesRepository.moveFiles(requestParams);
    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.move, params));
    params.onActionComplete(params.fileList.first, FLQuickActions.move);
  }

  static Future<void> deleteJobEstimate(FilesListingQuickActionParams params) async {
    if (params.fileList.first.isDir == 1) {
      await EstimatesRepository.removeDirectory(params.fileList.first.id!);
    } else {
      await EstimatesRepository.removeFile(params.fileList.first.id!);
    }

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.delete, params));
    params.onActionComplete(params.fileList.first, FLQuickActions.delete);
  }

  static Future<void> showHideOnCustomerWebPageJobEstimate(FilesListingQuickActionParams params) async {
    Map<String, dynamic> param = {
      'id': params.fileList.first.id,
      'share': params.fileList.first.isShownOnCustomerWebPage! ? 0 : 1,
    };

    await EstimatesRepository.showHideOnCustomerWebPage(param);

    final result = !params.fileList.first.isShownOnCustomerWebPage!;

    params.fileList.first.isShownOnCustomerWebPage = result;

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(
        result
            ? FLQuickActions.showOnCustomerWebPage
            : FLQuickActions.removeFromCustomerWebPage,
        params));
    params.onActionComplete(params.fileList.first, FLQuickActions.showOnCustomerWebPage);
  }

  static Future<void> unMarkAsFavouriteJobEstimate(FilesListingQuickActionParams params) async {
    
    int id = params.type == FLModule.favouriteListing ? int.parse(params.fileList.first.id!) :params.fileList.first.myFavouriteEntity!.id!;
  
    await EstimatesRepository.unMarkAsFavourite(id);
    
    if(params.type != FLModule.favouriteListing){
      params.fileList.first.myFavouriteEntity = null;
    }

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.unMarkAsFavourite, params));
    params.onActionComplete(params.fileList.first, FLQuickActions.unMarkAsFavourite);
  }
}
