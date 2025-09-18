
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/repositories/job_proposal.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/Thumb/type.dart';

class FileListingJobProposalQuickActionRepo {

  static Future<FilesListingModel> renameJobProposal(FilesListingModel model, String newName) async {

    bool success = false;

    if (model.isDir == 1) {
      Map<String, dynamic> params = {
        'id': model.id,
        'name': newName.trim(),
      };
      success = await JobProposalRepository.folderRename(params);
    } else {
      Map<String, dynamic> params = {
        'id': model.id,
        'title': newName.trim(),
      };
      success = await JobProposalRepository.fileRename(params);
    }

    FilesListingModel data = model;

    if (success) {
      data.name = newName;
    }

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.rename, null, model.isDir == 1));

    return data;
  }

  static Future<dynamic> rotateJobProposal(FilesListingQuickActionParams params, String angle) async {

    Map<String, dynamic> requestParams = {
      'id': '',
      'rotation_angle': angle,
    };

    for (var element in params.fileList) {
      requestParams['id'] = element.id;
      final data = await JobProposalRepository.rotateImage(element.id!, requestParams);
      data.jpThumbType = JPThumbType.image;
      data.showThumbImage = true;
      data.parentId = int.tryParse(element.parentId.toString());
      params.onActionComplete(data, FLQuickActions.rotate);
    }

    await Future<void>.delayed(const Duration(seconds: 1));

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.rotate, params));
  }

  static Future<void> moveJobProposal(FilesListingQuickActionParams params, {required int dirId}) async {

    Map<String, dynamic> requestParams = {
      if (dirId != -1) 'parent_id': dirId,
      'job_id': params.fileList.first.jobId,
      for (int i = 0; i < params.fileList.length; i++)
        'ids[$i]': params.fileList[i].id
    };

    await JobProposalRepository.moveFiles(requestParams);
    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.move, params));
    params.onActionComplete(params.fileList.first, FLQuickActions.move);
  }

  static Future<void> deleteJobProposal(FilesListingQuickActionParams params) async {
    if (params.fileList.first.isDir == 1) {
      await JobProposalRepository.removeDirectory(params.fileList.first.id!);
    } else {
      await JobProposalRepository.removeFile(params.fileList.first.id!);
    }

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.delete, params));
    params.onActionComplete(params.fileList.first, FLQuickActions.delete);
  }

  static Future<void> showHideOnCustomerWebPageJobProposal(FilesListingQuickActionParams params) async {
    Map<String, dynamic> param = {
      'id': params.fileList.first.id,
      'share': params.fileList.first.isShownOnCustomerWebPage! ? 0 : 1,
    };

    await JobProposalRepository.showHideOnCustomerWebPage(param);

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

  static Future<void> unMarkAsFavouriteJobProposal(FilesListingQuickActionParams params) async {
    await JobProposalRepository.unMarkAsFavourite(
        params.fileList.first.myFavouriteEntity!.id!);

    params.fileList.first.myFavouriteEntity = null;

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(
        FLQuickActions.unMarkAsFavourite, params));
    params.onActionComplete(params.fileList.first, FLQuickActions.unMarkAsFavourite);
  }

  static Future<dynamic> openPublicFormJobProposal(FilesListingQuickActionParams params,) async {
    String url = await JobProposalRepository.getShareUrl(params.fileList.first.id!);
    Helper.launchUrl(url);
  }

  static Future<FilesListingModel> makeACopyJobProposal(FilesListingModel model, String newName) async {

    bool success = false;

    Map<String, dynamic> params = {
      "job_id": model.jobId,
      "parent_id": model.parentId,
      "proposal_id": model.id,
      "title": newName,
    };

    success = await JobProposalRepository.makeACopy(params);

    FilesListingModel data = model;

    if (success) {
      data.name = newName;
    }

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.makeACopy));

    return data;
  }

  static Future<FilesListingModel> updateStatusJobProposal(FilesListingModel model, Map<String,dynamic> args, bool doShowThankYouEmailToggle) async {

    bool success = false;

    Map<String, dynamic> param = {
      "id": model.id,
      "status": args['newStatusId'],
    };
    if(doShowThankYouEmailToggle){
      param.addAll({'thank_you_email' : args['switch_value']});
    }
    success = await JobProposalRepository.updateStatus(param);

    FilesListingModel data = model;

    if (success) {
      data.status = args['newStatusId'];
    }

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.updateStatus));

    return data;
  }

  static Future<FilesListingModel> updateNoteJobProposal(FilesListingModel model, String newNote) async {

    bool success = false;

    Map<String, dynamic> params = {
      "id": model.id,
      "note": newNote,
    };

    success = await JobProposalRepository.updateProposalNote(params);

    FilesListingModel data = model;

    if (success) {
      data.note = newNote;
    }

    Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.formProposalNote));

    return data;
  }

  static Future<dynamic> handleCumulativeInvoiceNote(int? jobId, String? note, String action) async {
    switch(action) {
      case "fetch":
        return await JobProposalRepository.fetchCumulativeInvoiceNote(jobId!);
      case "save":
        Map<String, dynamic> params = {
          "note": note,
        };
        return await JobProposalRepository.saveCumulativeInvoiceNote(jobId!, params);
    }
  }

  static Future<FilesListingModel> signProposal(FilesListingQuickActionParams params, String signature) async {

    final file = params.fileList.first;

    Map<String, dynamic> param = {
      'id': file.id,
      'signature': signature,
    };
    final response = await JobProposalRepository.signProposal(param);
    if (response) {
      file.status = 'accepted';
      file.digitalSignStatus = 'completed';
      params.onActionComplete(file, FLQuickActions.worksheetSignFormProposal);
    }

    return file;
  }


}