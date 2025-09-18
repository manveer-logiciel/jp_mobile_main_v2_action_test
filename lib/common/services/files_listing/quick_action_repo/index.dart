import 'package:flutter/material.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_model.dart';
import 'package:jobprogress/common/repositories/worksheet.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_helpers.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_repo/customer_files_repo.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_repo/instant_photo_gallery_repo.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_repo/job_contracts_repo.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_repo/job_photos_repo.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_repo/job_proposals_repo.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_repo/material_list_repo.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_repo/measurement_repo.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_repo/user_documents_repo.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_repo/work_order_repo.dart';
import 'package:jobprogress/common/services/worksheet/helpers.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'company_files_repo.dart';
import 'job_estimate_repo.dart';
import 'stage_resource_repo.dart';

// FileListingQuickActionRepo contains api calls for all quick actions
class FileListingQuickActionRepo {

  static Future<FilesListingModel?> rename(FLModule type, FilesListingModel model, String newName) async {
      switch (type) {
        case FLModule.companyFiles:
          return await FileListingCompanyFilesQuickActionRepo.renameCompanyFile(model, newName);
        case FLModule.estimate:
          return await FileListingJobEstimateQuickActionRepo.renameJobEstimate(model, newName);
        case FLModule.jobPhotos:
          return await FileListingPhotosQuickActionRepo.renameJobPhoto(model, newName);
        case FLModule.jobProposal :
          return await FileListingJobProposalQuickActionRepo.renameJobProposal(model, newName);
        case FLModule.measurements:
          return await FileListingMeasurementRepoQuickActionRepo.renameMeasurement(model, newName);
        case FLModule.materialLists:
          return await FileListingMaterialListQuickActionRepo.renameMaterialList(model, newName);
        case FLModule.workOrder:
          return await FileListingWorkOrderQuickActionRepo.renameWorkOrder(model, newName);
        case FLModule.stageResources:
          return await FileListingStageResourceRepoQuickActionRepo.renameStageResource(model, newName);
        case FLModule.userDocuments:
          return await FileListingUserDocumentsRepo.renameUserDocument(model, newName);
        case FLModule.customerFiles:
          return await FileListingCustomerFilesQuickActionRepo.renameCustomerFile(model, newName);
        case FLModule.instantPhotoGallery:
          return await FileListingInstantPhotoGalleryQuickActionRepo.renameInstantPhotoGallery(model, newName);
        case FLModule.jobContracts:
          return await FileListingJobContractsQuickActionRepo.renameJobContract(model, newName);
        default:
          return null;
      }
  }

  static Future<dynamic> rotate(FilesListingQuickActionParams params, String angle,) async {
      switch (params.type) {
        case FLModule.companyFiles:
          return await FileListingCompanyFilesQuickActionRepo.rotateCompanyFile(params, angle);
        case FLModule.estimate:
          return await FileListingJobEstimateQuickActionRepo.rotateJobEstimate(params, angle);
        case FLModule.jobPhotos:
          return await FileListingPhotosQuickActionRepo.rotateJobPhotos(params, angle);
        case FLModule.jobProposal:
          return await FileListingJobProposalQuickActionRepo.rotateJobProposal(params, angle);
        case FLModule.measurements:
          return await FileListingMeasurementRepoQuickActionRepo.rotateMeasurement(params, angle);
        case FLModule.materialLists:
          return await FileListingMaterialListQuickActionRepo.rotateMaterialList(params, angle);
        case FLModule.workOrder:
          return await FileListingWorkOrderQuickActionRepo.rotateWorkOrder(params, angle);
        case FLModule.stageResources:
          return await FileListingStageResourceRepoQuickActionRepo.rotateStageResource(params, angle);
        case FLModule.userDocuments:
          return await FileListingUserDocumentsRepo.rotateUserDocument(params, angle);
        case FLModule.customerFiles:
          return await FileListingCustomerFilesQuickActionRepo.rotateCustomerFile(params, angle);
        case FLModule.instantPhotoGallery:
          return await FileListingInstantPhotoGalleryQuickActionRepo.rotateInstantPhotoGallery(params, angle);
        default:
          break;
      }
  }

  static Future<dynamic> email({required FLModule type, required List<FilesListingModel> files, String? email, String? fullName, int? jobId, List<String>? pathList, VoidCallback? onEmailSent}) async {
    Map<String, dynamic>? arguments = {'jobId': jobId, 'action': type, NavigationParams.filePaths: pathList};
    if(files.isNotEmpty && files[0].path != null) {
      arguments['files'] = files;
    }
    return Helper.navigateToComposeScreen(arguments: arguments, onEmailSent: onEmailSent);
  }

  static Future<dynamic> move(FilesListingQuickActionParams params, {required int dirId}) async {
      switch (params.type) {
        case FLModule.companyFiles:
          return await FileListingCompanyFilesQuickActionRepo.moveCompanyFile(params, dirId: dirId);
        case FLModule.estimate:
          return await FileListingJobEstimateQuickActionRepo.moveJobEstimate(params, dirId: dirId);
        case FLModule.jobPhotos:
          return await FileListingPhotosQuickActionRepo.moveJobPhoto(params, dirId: dirId);
        case FLModule.jobProposal:
          return await FileListingJobProposalQuickActionRepo.moveJobProposal(params, dirId: dirId);
        case FLModule.measurements:
          return await FileListingMeasurementRepoQuickActionRepo.moveMeasurement(params, dirId: dirId);
        case FLModule.materialLists:
          return await FileListingMaterialListQuickActionRepo.moveMaterialList(params, dirId: dirId);
        case FLModule.workOrder:
          return await FileListingWorkOrderQuickActionRepo.moveWorkOrder(params, dirId: dirId);
        case FLModule.userDocuments:
          return await FileListingUserDocumentsRepo.moveUserDocument(params, dirId: dirId);
        case FLModule.customerFiles:
          return await FileListingCustomerFilesQuickActionRepo.moveCustomerFiles(params, dirId: dirId);
        default:
          break;
      }
  }

  static Future<dynamic> delete(FilesListingQuickActionParams params) async {
      switch (params.type) {
        case FLModule.companyFiles:
          return await FileListingCompanyFilesQuickActionRepo.deleteCompanyFile(params);
        case FLModule.estimate:
          return await FileListingJobEstimateQuickActionRepo.deleteJobEstimate(params);
        case FLModule.jobPhotos:
          return await FileListingPhotosQuickActionRepo.deleteJobPhoto(params);
        case FLModule.jobProposal:
          return await FileListingJobProposalQuickActionRepo.deleteJobProposal(params);
        case FLModule.measurements:
          return await FileListingMeasurementRepoQuickActionRepo.deleteMeasurement(params);
        case FLModule.materialLists:
          return await FileListingMaterialListQuickActionRepo.deleteMaterialList(params);
        case FLModule.workOrder:
          return await FileListingWorkOrderQuickActionRepo.deleteWorkOrder(params);
        case FLModule.stageResources:
          return await FileListingStageResourceRepoQuickActionRepo.deleteStageResource(params);
        case FLModule.userDocuments:
          return await FileListingUserDocumentsRepo.deleteUserDocument(params);
        case FLModule.customerFiles:
          return await FileListingCustomerFilesQuickActionRepo.deleteCustomerFile(params);
        case FLModule.instantPhotoGallery:
           return await FileListingInstantPhotoGalleryQuickActionRepo.deleteInstantPhotoGalleryResource(params);
         case FLModule.jobContracts:
           return await FileListingJobContractsQuickActionRepo.deleteJobContract(params);
        default:
          break;
      }
  }

  static Future<dynamic> showHideOnCustomerWebPage(FilesListingQuickActionParams params, FLQuickActions? action) async {
    switch (params.type) {
        case FLModule.estimate:
          return await FileListingJobEstimateQuickActionRepo.showHideOnCustomerWebPageJobEstimate(params);
        case FLModule.jobPhotos:
          return await FileListingPhotosQuickActionRepo.showHideOnCustomerWebPageJobPhotos(params, action!);
        case FLModule.jobProposal:
          return await FileListingJobProposalQuickActionRepo.showHideOnCustomerWebPageJobProposal(params);
        case FLModule.customerFiles:
          return await FileListingCustomerFilesQuickActionRepo.showHideOnCustomerWebPageCustomerFile(params);
        case FLModule.jobContracts:
          return await FileListingJobContractsQuickActionRepo.showHideOnCustomerWebPageCustomerFile(params);
        default:
          break;
      }
  }

  static Future<dynamic> unMarkAsFavourite(FilesListingQuickActionParams params) async {
      switch (params.type) {
        case FLModule.estimate:
        case FLModule.favouriteListing:
          return await FileListingJobEstimateQuickActionRepo.unMarkAsFavouriteJobEstimate(params);
        case FLModule.jobProposal:
          return await FileListingJobProposalQuickActionRepo.unMarkAsFavouriteJobProposal(params);
        case FLModule.workOrder:
          return await FileListingWorkOrderQuickActionRepo.unMarkAsFavouriteWorkOrder(params);
        case FLModule.materialLists:
          return await FileListingMaterialListQuickActionRepo.unMarkAsFavouriteMaterialList(params);
        default:
          break;
      }
  }

  static Future<dynamic> openPublicForm(FilesListingQuickActionParams params) async {
      switch (params.type) {
        case FLModule.jobProposal:
          return await FileListingJobProposalQuickActionRepo.openPublicFormJobProposal(params);
        default:
          break;
      }
  }

  static Future<dynamic> makeACopy(FilesListingQuickActionParams params, String newName) async{
      switch (params.type) {
        case FLModule.jobProposal:
          return await FileListingJobProposalQuickActionRepo.makeACopyJobProposal(params.fileList.first, newName);
        case FLModule.jobContracts:
          return await FileListingJobContractsQuickActionRepo.makeACopyJobContract(params.fileList.first, newName);
        default:
          break;
      }
  }

  static Future<dynamic> updateStatus(FilesListingQuickActionParams params, Map<String,dynamic> args) async{
      switch (params.type) {
        case FLModule.jobProposal:
          final result = await FileListingJobProposalQuickActionRepo.updateStatusJobProposal(params.fileList.first, args, params.doShowThankYouEmailToggle!);
          params.onActionComplete(result, FLQuickActions.updateStatus);
          return result;
        default:
          break;
      }
  }

  static Future<dynamic> formProposalNote(FilesListingQuickActionParams params, String newNote) async{
      switch (params.type) {
        case FLModule.jobProposal:
          return await FileListingJobProposalQuickActionRepo.updateNoteJobProposal(params.fileList.first, newNote);
        default:
          break;
      }
  }

  static Future<dynamic> updateDeliverableStatus(FilesListingQuickActionParams params, int status) async{
    switch (params.type) {
      case FLModule.measurements:
        return await FileListingMeasurementRepoQuickActionRepo.changeDeliverableStatus(params, status);
      default:
        break;
    }
  }

  static Future<dynamic> notes(int? jobId, FLModule type, String action, {String? note}) async {
    switch (type) {
      case FLModule.cumulativeInvoices:
        return await FileListingJobProposalQuickActionRepo.handleCumulativeInvoiceNote(jobId, note, action);
      default:
        break;
    }
  }

  static Future<int?> saveWorksheet(FilesListingQuickActionParams params, WorksheetModel worksheet, {bool includeIntegratedSuppliers = true}) async {

    final file = params.fileList.first;

    worksheet.linkId = int.tryParse(file.id.toString());
    worksheet.jobId = params.jobModel?.id;
    worksheet.linkType = FileListingQuickActionHelpers.flModuleToWorksheetLinkType(params.type);
    worksheet.id = null;

    final param = worksheet.toJson(fromWorkSheetJson: true, generateWorksheetType: worksheet.type, includeIntegratedSuppliers: includeIntegratedSuppliers);
    if(!includeIntegratedSuppliers && Helper.isValueNullOrEmpty(param['details'])) {
      WorksheetHelpers.emptyItemsToToastMessage(worksheet.type ?? '');
      return null;
    }
    final response = await WorksheetRepository.saveWorksheet(param);
    return response.id;
  }

  static Future<FilesListingModel?> signFile(FilesListingQuickActionParams params, String signature) async {
    switch (params.type) {
      case FLModule.jobProposal :
        return await FileListingJobProposalQuickActionRepo.signProposal(params, signature);
      default:
        return null;
    }
  }

  static Future<void> markAs(FilesListingQuickActionParams params, FLQuickActions action) async {
    switch (params.type) {
      case FLModule.workOrder :
        return await FileListingWorkOrderQuickActionRepo.markAs(params, action);
      case FLModule.materialLists :
        return await FileListingMaterialListQuickActionRepo.markAs(params, action);
      default:
        break;
    }
  }
}
