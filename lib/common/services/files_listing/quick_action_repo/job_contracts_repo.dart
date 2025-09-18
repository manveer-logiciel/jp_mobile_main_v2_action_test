import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/repositories/contracts.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';

/// [FileListingJobContractsQuickActionRepo] act as intermediate link among quick actions and api calls
class FileListingJobContractsQuickActionRepo {

  static Future<FilesListingModel> renameJobContract(FilesListingModel model, String newName) async {
    Map<String, dynamic> params = {
      'id': model.id,
      'title': newName.trim(),
    };

    bool success = await JobContractsRepository.fileRename(params);
    FilesListingModel data = model;

    if (success) data.name = newName;
    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.rename, null, model.isDir == 1));

    return data;
  }

  static Future<void> deleteJobContract(FilesListingQuickActionParams params) async {
    await JobContractsRepository.removeFile(params.fileList.first.id!);
    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.delete, params));
    params.onActionComplete(params.fileList.first, FLQuickActions.delete);
  }

  static Future<FilesListingModel> makeACopyJobContract(FilesListingModel model, String newName) async {
    bool success = false;
    Map<String, dynamic> params = {
      "job_id": model.jobId,
      "contract_id": model.id,
      "title": newName,
    };

    success = await JobContractsRepository.makeACopy(params);
    FilesListingModel data = model;
    if (success) data.name = newName;

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.makeACopy));
    return data;
  }

  /// [showHideOnCustomerWebPageCustomerFile] show/hide file on customer web page
  static Future<void> showHideOnCustomerWebPageCustomerFile(FilesListingQuickActionParams params) async {
    Map<String, dynamic> param = {
      'id': params.fileList.first.id,
      'share': params.fileList.first.isShownOnCustomerWebPage! ? 0 : 1,
    };
    // Api call to show/hide file on customer web page
    await JobContractsRepository.showHideOnCustomerWebPage(param);
    // Updating file status as per api response
    final result = !params.fileList.first.isShownOnCustomerWebPage!;
    params.fileList.first.isShownOnCustomerWebPage = result;
    // displaying toast message
    Helper.showToastMessage(
      FileListingQuickActionHelpers.getToastMessage(
        result ? FLQuickActions.showOnCustomerWebPage : FLQuickActions.removeFromCustomerWebPage,
        params,
      ),
    );
    params.onActionComplete(params.fileList.first, FLQuickActions.showOnCustomerWebPage);
  }
}