
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/repositories/customer_files.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/Thumb/type.dart';

class FileListingCustomerFilesQuickActionRepo{

  static Future<FilesListingModel> renameCustomerFile(FilesListingModel model, String newName) async {

    Map<String, dynamic> params = {
      'id': model.id,
      'name': newName.trim(),
    };

    FilesListingModel data = await CustomerFilesRepository.renameResource(params);

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.rename, null, model.isDir == 1));

    return data;
  }

  static Future<dynamic> rotateCustomerFile(FilesListingQuickActionParams params, String angle,) async {

    Map<String, dynamic> requestParams = {
      'rotation_angle': angle,
    };

    for (var element in params.fileList) {
      final data = await CustomerFilesRepository.rotateImage(element.id!, requestParams);
      data.jpThumbType = JPThumbType.image;
      data.showThumbImage = true;
      data.isShownOnCustomerWebPage = element.isShownOnCustomerWebPage;
      params.onActionComplete(data, FLQuickActions.rotate);
    }

    await Future<void>.delayed(const Duration(seconds: 1));

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.rotate, params));
  }

  static Future<void> moveCustomerFiles(FilesListingQuickActionParams params, {required int dirId}) async {

    Map<String, dynamic> requestParams = {
      'move_to': dirId,
      for (int i = 0; i < params.fileList.length; i++)
        'resource_ids[$i]': params.fileList[i].id
    };

    await CustomerFilesRepository.moveMultipleResource(requestParams);
    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.move, params));
    params.onActionComplete(params.fileList.first, FLQuickActions.move);
  }

  static Future<void> deleteCustomerFile(FilesListingQuickActionParams params) async {
    if (params.fileList.first.isDir == 1) {
      await CustomerFilesRepository.removeDirectory(params.fileList.first.id!);
    } else {
      Map<String, dynamic> requestParams = {
        for (int i = 0; i < params.fileList.length; i++)
          'resource_ids[$i]': params.fileList[i].id
      };

      await CustomerFilesRepository.removeMultipleResource(requestParams);
    }

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.delete, params));
    params.onActionComplete(params.fileList.first, FLQuickActions.delete);
  }

  static Future<void> showHideOnCustomerWebPageCustomerFile(FilesListingQuickActionParams params) async {
    Map<String, dynamic> param = {
      'id': params.fileList.first.id,
      'share': params.fileList.first.isShownOnCustomerWebPage! ? 0 : 1,
    };

    await CustomerFilesRepository.showHideOnCustomerWebPage(param);

    final result = !params.fileList.first.isShownOnCustomerWebPage!;

    params.fileList.first.isShownOnCustomerWebPage = result;

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(
        result
            ? FLQuickActions.showOnCustomerWebPage
            : FLQuickActions.removeFromCustomerWebPage,
        params));
    params.onActionComplete(
        params.fileList.first, FLQuickActions.showOnCustomerWebPage);
  }

}
