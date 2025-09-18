
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_request_param.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/photo_viewer_model.dart';
import 'package:jobprogress/common/repositories/estimations.dart';
import 'package:jobprogress/common/repositories/job_photos.dart';
import 'package:jobprogress/common/repositories/job_proposal.dart';
import 'package:jobprogress/common/services/drawing_tool/index.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_handlers.dart';
import 'package:jobprogress/common/services/files_listing/quick_actions.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/photo_viewer_dialog/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/modules/files_listing/page.dart';
import 'package:jobprogress/modules/job/job_summary/controller.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/Thumb/type.dart';

class RecentFilesController extends GetxController {

  RecentFilesController(this.job, this.type, this.jobSummaryController);

  final JobModel job; // stores job data
  final FLModule type; // type to differentiate listing
  final JobSummaryController jobSummaryController;

  int totalCount = 0;

  List<FilesListingModel> resourceList = []; // used to store files list

  bool isLoading = false; // helps in managing loading state

  FilesListingRequestParam? fileListingRequestParam; // params for requesting apis

  @override
  void onInit() {
    fetchFiles();
    super.onInit();
  }

  // initParam() is called before calling any api to set parent id and
  // to initialize fileListingRequestParam only when these values are null
  Future<void> initParam() async {
    if (fileListingRequestParam != null) return;

    switch (type) {
      case FLModule.estimate:
        return await getJobEstimateParams();

      case FLModule.jobPhotos:
        return await getJobPhotosParams();

      case FLModule.jobProposal:
        return await getJobProposalParams();

      default:
        break;
    }

  }

  Future<void> getJobPhotosParams() async {

    if(job.meta?.resourceId == null) return;

    fileListingRequestParam = FilesListingRequestParam(parentId: int.parse(job.meta!.resourceId!));
    fileListingRequestParam?.limit = '5';

    update();
  }

  Future<void> getJobEstimateParams() async {
    fileListingRequestParam = FilesListingRequestParam(parentId: null);
    fileListingRequestParam?.limit = '5';
    update();
  }

  Future<void> getJobProposalParams() async {
    fileListingRequestParam = FilesListingRequestParam(parentId: null);
    fileListingRequestParam?.limit = '5';
    update();
  }

  Future<void> fetchFiles({bool showLoading = true}) async {
    try {
      if(showLoading) toggleIsLoading();

      await initParam();
      final response = await typeToApi();

      resourceList = response['list'];
      if(response['list'] != null) {
        if(response['pagination'] != null) {
          totalCount = response['pagination']['total'];
          onIncreaseCount(controller: jobSummaryController, totalCount: totalCount);
        }
        jobSummaryController.update();
      }
      
    } catch(e) {
      rethrow;
    } finally {
      if(showLoading) toggleIsLoading();
      if(!showLoading) update();
    }

  }

  void toggleIsLoading() {
    isLoading = !isLoading;
    update();
  }

  void onIncreaseCount({JobSummaryController? controller,int? totalCount}) async {
    switch (type) {
      case FLModule.jobPhotos:
        controller?.job?.count?.jobResources = totalCount;

      case FLModule.estimate:
        controller?.job?.count?.estimates = totalCount;

      case FLModule.jobProposal:
        controller?.job?.count?.proposals = totalCount;
      default:
        return;
    }
  }

  Future<dynamic> typeToApi() async {
    switch (type) {
      case FLModule.jobPhotos:
        return await jobPhotosApiCall();

      case FLModule.estimate:
        return await estimatesApiCall();

      case FLModule.jobProposal:
        return await jobProposalApiCall();

      default:
        return;
    }
  }

  Future<dynamic> jobPhotosApiCall() async {

    Map<String, dynamic> params = {
      ...FilesListingRequestParam.getJobPhotosParams(false),
      ...fileListingRequestParam!.toJson(),
    };

    return await JobPhotosRepository.fetchRecentFiles(params);

  }

  Future<dynamic> estimatesApiCall() async {
    Map<String, dynamic> params = {
      ...FilesListingRequestParam.getJobEstimateParams(false, job.id, filesOnly: true),
      ...fileListingRequestParam!.toJson(),
    };
    Map<String, dynamic> response = await EstimatesRepository.fetchFiles(params);
    return response;
  }

  Future<dynamic> jobProposalApiCall() async {

    Map<String, dynamic> params = {
      ...FilesListingRequestParam.getJobProposalParams(false, job.id, filesOnly: true),
      ...fileListingRequestParam!.toJson(),
    };

    Map<String, dynamic> response = await JobProposalRepository.fetchFiles(params);

    return response;
  }

  void onTapResource(int index) {
    switch (resourceList[index].jpThumbType) {
      case JPThumbType.image:
        goToPhotoViewer(index);
        break;
      case JPThumbType.icon:
        FileListQuickActionHandlers.downloadAndOpenFile(
            resourceList[index].originalFilePath ?? '',
            classType: resourceList[index].classType,
        );
        break;
      default:
        break;
    }
  }

  // goToPhotoViewer() will fetches only images from displayed documents and
  // send them to PhotoViewer()
  void goToPhotoViewer(int index) async {
    DrawingToolService.fileList = [];
    List<FilesListingModel> tempList = resourceList
        .where((element) => element.jpThumbType == JPThumbType.image)
        .toList();

    List<PhotoDetails> imageList = [];

    for (FilesListingModel file in tempList) {
      imageList.add(
          PhotoDetails(
           file.name ?? 'photos'.tr,
           urls: file.multiSizeImages ?? (file.originalFilePath != null ? [file.originalFilePath!] : null),
           base64Image: file.base64Image,
           id: file.id.toString(),
           parentId: file.parentId.toString(),
          )
      );
      imageList.last.urls!.insert(0, file.thumbUrl!);
    }

    int scrollToIndex = tempList
        .indexWhere((element) => element.id == resourceList[index].id);

    final data = PhotoViewerModel<RecentFilesController>(scrollToIndex, imageList);

    dynamic result = await showJPBottomSheet(
      child: (_) {
        return JPSafeArea(
          child: PhotosViewerDialog(
            data: data,
            jobId: job.id,
            type: type,
          ),
        );
      },
      isScrollControlled: true,
      ignoreSafeArea: false,
      allowFullWidth: true,
    );
    if(!Helper.isValueNullOrEmpty(result)){
      if(Helper.isTrue(result['save_as'])){
        onRefresh(showLoading: true);
      } else {
        for(FilesListingModel file in result['file']){
          int position = resourceList.indexWhere((element) => element.id == file.id);
          resourceList[position] = file;
          update();
        }

      }  
    }
    
  }

  void viewAllFiles({String? tag}) {
    Get.to(() =>
        FilesListingView(
          refTag: tag ?? '$type${(job.id)}',
        ),
      arguments: {
        'type': type,
        'customerId': job.customerId,
        'jobId': job.id
      },
      preventDuplicates: Get.currentRoute != Routes.jobSummary,
    );
  }

  void showQuickAction({int? index}) {

    List<FilesListingModel> selectedItems = index != null
        ? <FilesListingModel>[resourceList[index]]
        : resourceList.where((element) => element.isSelected ?? false).toList(); // Filtering selected items from all items

    FilesListingService.openQuickAction(FilesListingQuickActionParams(
      type: type,
      fileList: selectedItems,
      jobModel: job,
      isInSelectionMode: selectedItems.length > 1,
      onActionComplete: (FilesListingModel model, action) async {
        switch (action) {
          case FLQuickActions.rename:
            int position =
            resourceList.indexWhere((element) => element.id == model.id);
            resourceList[position] = model;
            update();
            break;
          case FLQuickActions.delete:
            fetchFiles();
            break;
          case FLQuickActions.edit:
          case FLQuickActions.rotate:
            int position =
            resourceList.indexWhere((element) => element.id == model.id);
            resourceList[position] = model;
            update();
            break;
          case FLQuickActions.move:
            fetchFiles();
            break;
          case FLQuickActions.unMarkAsFavourite:
            int position =
            resourceList.indexWhere((element) => element.id == model.id);
            resourceList[position] = model;
            update();
            break;
          case FLQuickActions.markAsFavourite:
            int position =
            resourceList.indexWhere((element) => element.id == model.id);
            resourceList[position] = model;
            update();
            break;
          case FLQuickActions.showOnCustomerWebPage:
            int position =
            resourceList.indexWhere((element) => element.id == model.id);
            resourceList[position] = model;
            resourceList[position].isSelected = false;
            update();
            break;
          case FLQuickActions.makeACopy:
            fetchFiles();
            break;
          case FLQuickActions.updateStatus:
            int position =
            resourceList.indexWhere((element) => element.id == model.id);
            resourceList[position] = model;
            update();
            break;
          case FLQuickActions.expireOn:
            int position =
            resourceList.indexWhere((element) => element.id == model.id);
            resourceList[position] = model;
            update();
            break;
          case FLQuickActions.setDeliveryDate:
            int position =
            resourceList.indexWhere((element) => element.id == model.id);
            resourceList[position] = model;
            update();
            break;
          case FLQuickActions.upgradeToHoverRoofOnly:
            int position =
            resourceList.indexWhere((element) => element.id == model.id);
            resourceList[position] = model;
            update();
            break;
          
          case FLQuickActions.email:
            if(type == FLModule.jobProposal) {
              onRefresh(showLoading: true);
            }
          case FLQuickActions.editMeasurement:
          case FLQuickActions.placeSRSOrder:
          case FLQuickActions.editInsurance:
          case FLQuickActions.editProposalTemplate:
          case FLQuickActions.handwrittenTemplate:
          case FLQuickActions.worksheet:
          case FLQuickActions.schedule:
          case FLQuickActions.emailCumulativeInvoice:
          case FLQuickActions.generateWorkSheet:
          case FLQuickActions.editWorksheet:
          case FLQuickActions.worksheetSignFormProposal:
            onRefresh(showLoading: true);
            break;

          default:
            break;
        }
      },
    ),
    );
  }

  Future<void> onRefresh({bool showLoading = false}) async {
    await fetchFiles(showLoading: showLoading);
    
  }

  IconData getRecentFilesPlaceHolderIcon(FLModule type) {
    switch(type) {
      case FLModule.jobPhotos:
        return Icons.perm_media_outlined;
      case FLModule.estimate:
      case FLModule.jobProposal:
        return Icons.description_outlined;
      default:
        return Icons.folder;
    }
  }

  String getRecentFilesPlaceTitle(FLModule type) {
    switch(type) {
      case FLModule.jobPhotos:
        return 'no_photo_document_found'.tr;
      case FLModule.estimate:
        return 'no_estimating_found'.tr;
      case FLModule.jobProposal:
        return 'no_form_proposal_found'.tr;
      default:
        return 'no_file_found'.tr;
    }
  }

}