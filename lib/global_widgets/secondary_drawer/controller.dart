import 'package:get/get.dart';
import 'package:jobprogress/common/enums/clock_summary.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/clock_summary/clock_summary_request_params.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/secondary_drawer_item.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/modules/clock_summary/listing/page.dart';
import 'package:jobprogress/modules/email/listing/page.dart';
import 'package:jobprogress/modules/files_listing/page.dart';
import 'package:jobprogress/modules/task/listing/page.dart';
import 'package:jobprogress/routes/pages.dart';

class JPSecondaryDrawerController extends GetxController {

  JPSecondaryDrawerController(this.job);

  JobModel? job;

  void handleRoute(JPSecondaryDrawerItem drawerItem, String slug) async {
    if (drawerItem.route == null) return;

    await Future<void>.delayed(const Duration(milliseconds: 200));

    switch (drawerItem.route) {
      case Routes.filesListing:
        if (slug != 'job_overview') {
          Get.back();
        }
        Get.to(() =>
          FilesListingView(
            refTag: "${drawerItem.slug}${(job?.id ?? "")}",
          ),
          arguments: {
            'type': slugToType(drawerItem.slug),
            'customerId': job!.customerId,
            'jobId': job!.id
          },
          preventDuplicates: slug != 'job_overview',
          transition: Transition.topLevel,
        );
        break;
      case Routes.jobSummary:
        if (slug != 'job_overview') {
          Get.back();
        }
        break;
      case Routes.email:
        if (slug != 'job_overview') {
          Get.back();
        }
        if (slug != 'email_history') {
          Get.to(() => EmailListingView(refTag: "${(job?.id ?? "")}",), arguments: {NavigationParams.jobId: job!.id, NavigationParams.customerId: job!.customerId}, transition: Transition.topLevel, preventDuplicates: slug != 'job_overview');
        }
        break;
      case Routes.taskListing:
        if (slug != 'job_overview') {
          Get.back();
        }
        if (slug != 'tasks') {
          Get.to(() => const TaskListingView(), arguments: {'jobId': job!.id, 'customerId': job!.customerId},  transition: Transition.topLevel, preventDuplicates: slug != 'job_overview');
        }
        break;
      case Routes.workCrewNotesListing:
        if (slug != 'job_overview') {
          Get.back();
        }
        if (slug != 'work_crew_notes') {
          Get.toNamed(Routes.workCrewNotesListing, arguments: {'jobId': job!.id, 'customerId': job!.customerId});
        }
        break;
      case Routes.jobNoteListing:
        if (slug != 'job_overview') {
          Get.back();
        }
        if (slug != 'job_notes') {
          Get.toNamed(Routes.jobNoteListing, arguments: {'jobId': job!.id, 'customerId': job!.customerId});
        }
        break;

      case Routes.followUpsNoteListing:
        if (slug != 'job_overview') {
          Get.back();
        }
        if (slug != 'follow_up') {
          Get.toNamed(Routes.followUpsNoteListing, arguments: {'jobId': job!.id, 'customerId': job!.customerId});
        }
        break;
      
      case Routes.jobfinancial:
        if (slug != 'job_overview') {
          Get.back();
        }
         if (slug != 'job_financial') {
          Get.toNamed(Routes.jobfinancial, arguments: {'jobId': job!.id,'customerId': job!.customerId});
        }
        break;

      case Routes.clockSummary:
        if (slug != 'clock_summary') {
          ClockSummaryRequestParams requestParams = ClockSummaryRequestParams(
            jobId: job!.id,
            jobModel: job,
            jobName: '${job!.customer!.fullNameMobile!} / ${Helper.getJobName(job!)}',
            sortBy: 'start_date_time',
            sortOrder: 'desc',
            title: '${job!.customer!.fullNameMobile!} / ${Helper.getJobName(job!)}',
          );

          Get.to(() => ClockSummaryView(tag: job!.id.toString()),
              arguments: {
                'listingType' : ClockSummaryListingType.sortBy,
                'defaultParams' : requestParams,
                'isOpenedFromSecondaryDrawer' : true,
              });
        }
        break;

      default:
        break;
    }
  }

  FLModule? slugToType(String slug) {
    switch (slug) {
      case FileUploadType.estimations:
        return FLModule.estimate;
      case FileUploadType.photosAndDocs:
        return FLModule.jobPhotos;
      case FileUploadType.formProposals:
        return FLModule.jobProposal;
      case FileUploadType.measurements:
        return FLModule.measurements;
      case FileUploadType.materialList:
        return FLModule.materialLists;
      case FileUploadType.workOrder:
        return FLModule.workOrder;
      case FileUploadType.contracts:
        return FLModule.jobContracts;
      case "FLModule.stageResources":
        return FLModule.stageResources;
    }
    return null;
  }

  int? getCount(String slug, JobModel? job){
    switch (slug) {
      case FileUploadType.measurements:
        return job?.count?.measurements?? 0;
      case FileUploadType.estimations:
        return job?.count?.estimates?? 0;
      case FileUploadType.formProposals:
        return job?.count?.proposals?? 0;
      case FileUploadType.materialList:
        return job?.count?.materialLists?? 0;
      case FileUploadType.workOrder:
        return job?.count?.workOrders?? 0;
      case FileUploadType.photosAndDocs:
        return job?.count?.jobResources?? 0;
      case "work_crew_notes":
        return job?.count?.workCrewNotes?? 0;
      case "FLModule.stageResources":
        return job?.count?.stageResources?? 0;
      case "job_notes":
        return job?.jobNoteCount?? 0;
      case "tasks":
        return job?.jobTaskCount?? 0;
      case FileUploadType.contracts:
        return job?.count?.contracts ?? 0;
      default:
        return null;
    }
  }

}