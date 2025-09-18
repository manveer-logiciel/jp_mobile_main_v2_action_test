
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/constants/urls.dart';

class UploadFileTypeApiUrl {

  static String getUrl(String type) {

    switch (type) {
      case FileUploadType.measurements:
        return Urls.measurementsFile;

      case FileUploadType.estimations:
        return Urls.estimationsFile;

      case FileUploadType.xactimate:
        return Urls.xactimatePdfParser;

      case FileUploadType.formProposals:
        return Urls.proposalsFile;

      case FileUploadType.materialList:
        return Urls.materialListUploadFile;

      case FileUploadType.workOrder:
        return Urls.workOrderUploadFile;

      case FileUploadType.companyFiles:
        return Urls.resourcesFile;

      case FileUploadType.photosAndDocs:
        return Urls.resourcesFile;

      case FileUploadType.instantPhoto:
        return Urls.instantPhoto;

      case FileUploadType.attachment:
        return Urls.attachmentUpload;

      case FileUploadType.template:
        return Urls.templateImage;
      
      case FileUploadType.srsOrder:
        return Urls.srsOrderAttachments;

      default:
        return '';
    }

  }

  static String getGoogleSheetUrl(String type){
    switch (type) {
      case FileUploadType.estimations:
        return Urls.createEstimatesGooglesheet;

      case FileUploadType.formProposals:
        return Urls.createProposalGooglesheet;

      default:
        return '';    
    }
  }

}