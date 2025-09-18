import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/repositories/instant_photo_gallery.dart';
import 'package:jobprogress/common/repositories/job_financial.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/Thumb/type.dart';

import '../../../models/files_listing/files_listing_quick_action_params.dart';
import '../../auth.dart';

class FileListingInstantPhotoGalleryQuickActionRepo{

  static Future<FilesListingModel> renameInstantPhotoGallery(FilesListingModel model, String newName) async {

    Map<String, dynamic> params = {
      'id': model.id,
      'name': newName.trim(),
    };

    FilesListingModel data = await InstantPhotoGalleryRepository.renameResource(params);

    var loggedInUser = await AuthService.getLoggedInUser();
    data.createdByDetails = CreatedByDetails(id: loggedInUser.id, name: loggedInUser.fullName);

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.rename));
   
    return data;
  }
  
  static Future<void> deleteInstantPhotoGalleryResource(FilesListingQuickActionParams params) async {
      Map<String, dynamic> requestParams = {
        for (int i = 0; i < params.fileList.length; i++)
          'resource_ids[$i]': params.fileList[i].id
      };
      await InstantPhotoGalleryRepository.removeMultipleResource(requestParams);
    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.delete, params));
    params.onActionComplete(params.fileList.first, FLQuickActions.delete);
  }

  static Future<void> deleteFinancialInvoice(FilesListingQuickActionParams params, String password, String reason) async {     
      Map<String, dynamic> requestParams = {
      'invoice_id': params.fileList[0].id,
      'password':password,
      'reason':reason,
      };
    await JobFinancialRepository.removeFinancialInvoice(requestParams);
    Get.back();
    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.delete, params));
    params.onActionComplete(params.fileList.first, FLQuickActions.delete);
  }

  static Future<dynamic> rotateInstantPhotoGallery(FilesListingQuickActionParams params, String angle,) async {

    Map<String, dynamic> requestParams = {
      'rotation_angle': angle,
    };

    for (var element in params.fileList) {
      final data = await InstantPhotoGalleryRepository.rotateImage(element.id!, requestParams);
      data.jpThumbType = JPThumbType.image;
      data.showThumbImage = true;
      params.onActionComplete(data, FLQuickActions.rotate);
    }

    await Future<void>.delayed(const Duration(seconds: 1));

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.rotate, params));
  }
}