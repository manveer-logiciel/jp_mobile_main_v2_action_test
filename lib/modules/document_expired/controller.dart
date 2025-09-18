import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/photo_viewer_model.dart';
import 'package:jobprogress/common/repositories/document_expired.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/services/download.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/photo_viewer_dialog/index.dart';

class DocumentExpiredController extends GetxController {
 
final scaffoldKey = GlobalKey<ScaffoldState>();

int id = Get.arguments?['id'] ?? 0;
int jobId = Get.arguments?['job_id'] ?? 0;

String type  = Get.arguments?['type'] ?? '';

FilesListingModel? expiredDocument;

JobModel? job; 

bool isLoading = true;

Future<void> getExpiredDocumentDetailData() async {
  try {      
    expiredDocument = await getDocument();
    if(jobId != 0) {
      job =  (await JobRepository.fetchJob(jobId))['job'];
    }
  } catch (e) {
    rethrow;
  } finally {
    isLoading = false;
    update();
  }
}

Future<FilesListingModel> getDocument(){
  String documentId = id.toString();
  switch(type){
    case 'estimation':
      return DocumentExpiredRepository.getEstimate(documentId);
    case 'proposal': 
      return DocumentExpiredRepository.getProposal(documentId);
    default:
      return DocumentExpiredRepository.getResources(documentId);
  }
}

void openFile() async {
  FileHelper.checkIfImage(expiredDocument!.path!) ? openPhotoViewer() : await openOtherFile();  
}

Future<void> openOtherFile() async {
  try {
      showJPLoader(msg: 'downloading'.tr);
    await DownloadService.downloadFile(
      expiredDocument!.url.toString(),
      expiredDocument!.name!,
      action:'open',
      classType: expiredDocument!.classType
    );
    } catch(e) {
      rethrow;
    } finally {
      Get.back();
    }
}

void openPhotoViewer(){
  final data = PhotoViewerModel<DocumentExpiredController>(
    0, 
    [
      PhotoDetails(
        expiredDocument!.name ?? 'Photo.image',
        urls: [
          expiredDocument!.thumbUrl ?? '',
          expiredDocument!.url ?? '',
        ]
      )
    ]
  );
  showJPGeneralDialog(
    child: (_) {
      return PhotosViewerDialog(
          data: data,
      );
    },
    allowFullWidth: true
  );
}
    
void refreshPage() {
  isLoading = true;
  update();
  getExpiredDocumentDetailData();
}

@override
  void onInit() {
    super.onInit();
    getExpiredDocumentDetailData();
  }
}
