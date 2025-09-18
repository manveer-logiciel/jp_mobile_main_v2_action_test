
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/uploader/file_uploader_params.dart';

import '../../../core/constants/file_uploder.dart';
import '../../../core/utils/helpers.dart';

class UploadFileTypeDisplayPath {

  static String path(FileUploaderParams params) {

    switch (params.type) {
      case FileUploadType.measurements:
        return getJobName(params.job) + '>' + 'measurements'.tr;

      case FileUploadType.estimations:
        return getJobName(params.job!) + '>' + 'estimatings'.tr;

      case FileUploadType.formProposals:
        return getJobName(params.job!) + '>' + 'forms_proposals'.tr;

      case FileUploadType.materialList:
        return getJobName(params.job!) + '>' + 'materials'.tr;

      case FileUploadType.workOrder:
        return getJobName(params.job!) + '>' + 'work_orders'.tr;

      case FileUploadType.companyFiles:
        return 'company_files'.tr;

      case FileUploadType.photosAndDocs:
        return 'photos_documents'.tr;

      case FileUploadType.instantPhoto:
        return 'instant_photo'.tr;

      default:
        return '';
    }
  }

  static getJobName(JobModel? job) {
    String? customerName = job?.customer?.fullName;
    return (customerName != null
        ? '$customerName/'
        : '') + Helper.getJobName(job!);
  }

}