import 'package:get/get.dart';
import 'package:jobprogress/modules/company_contacts/listing/controller.dart';
import 'package:jobprogress/modules/daily_plan/controller.dart';
import 'package:jobprogress/modules/email/listing/controller.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';
import 'package:jobprogress/modules/follow_ups_notes/listing/controller.dart';
import 'package:jobprogress/modules/home/controller.dart';
import 'package:jobprogress/modules/job/job_summary/controller.dart';
import 'package:jobprogress/modules/job_note/listing/controller.dart';
import 'package:jobprogress/modules/snippets/listing/controller.dart';
import 'package:jobprogress/modules/task/listing/controller.dart';
import 'package:jobprogress/modules/third_party_tools/controller.dart';
import 'package:jobprogress/modules/work_crew_notes/listing/controller.dart';
import '../../modules/customer/listing/controller.dart';
import '../../routes/pages.dart';

class FindPageController {
  dynamic getFromRoute(String route, {String? tag}) {
    switch (route) {
      case Routes.home:
        return Get.find<HomeController>();
      case Routes.taskListing:
        return Get.find<TaskListingController>();
      case Routes.companyContacts:
        return Get.find<CompanyContactListingController>();
      case Routes.dailyPlan:
        return Get.find<DailyPlanController>();
      case Routes.customerListing:
        return Get.find<CustomerListingController>();
      case Routes.snippetsListing:
        return Get.find<SnippetsListingController>();
      case Routes.email:
        return Get.find<EmailListingController>();
      case Routes.workCrewNotesListing:
        return Get.find<WorkCrewNotesListingController>();
      case Routes.jobNoteListing:
        return Get.find<JobNoteListingController>();
      case Routes.followUpsNoteListing:
        return Get.find<FollowUpsNotesListingController>();
      case Routes.jobSummary:
        return Get.find<JobSummaryController>(tag: tag);
      case Routes.filesListing:
        return Get.find<FilesListingController>();
      case Routes.thirdPartyTools:
        return Get.find<ThirdPartyToolsController>();
      case '/FilesListingView' :
        return Get.find<FilesListingController>(tag: tag);
      case '/EmailListingView' :
        return Get.find<EmailListingController>(tag: tag);
      case Routes.companyCam:
        return Get.find<FilesListingController>();
    }
  }
}
