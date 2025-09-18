import 'dart:async';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/appointment_form_type.dart';
import 'package:jobprogress/common/enums/calendars.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/job.dart';
import 'package:jobprogress/common/enums/parent_form_type.dart';
import 'package:jobprogress/common/enums/snippet_trade_script.dart';
import 'package:jobprogress/common/extensions/get_navigation/extension.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/uploader/file_uploader_params.dart';
import 'package:jobprogress/common/services/upload.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/modules/recent_jobs/index.dart';
import 'package:jobprogress/routes/pages.dart';

import '../../common/enums/cj_list_type.dart';

class JPMainDrawerTapHandler {
  static void onItemTap(String action, {JobModel? currentJob}) {
    Timer(
      const Duration(milliseconds: 100), () async {
        Get.back();
        switch (action) {
          case 'add_appointment':
            Get.toNamed(Routes.createAppointmentForm, arguments: {
              NavigationParams.pageType: AppointmentFormType.createForm ,
            });
            break;
          
          case 'logout':
            Helper.logOut();
            break;
          case 'demo':
            Get.toNamed(Routes.demo);
            break;
          case 'notifications':
            Get.offCurrentToNamed(Routes.notificationListing);
            break;
          case 'company_contacts':
            Get.offCurrentToNamed(Routes.companyContacts);
            break;
          case 'emails':
            Get.toNamed(Routes.email, preventDuplicates: false);
            break;
          case 'home':
            await Future<void>.delayed(const Duration(milliseconds: 200));
            Get.offAllToFirst();
            break;
          case 'company_files':
            Get.toNamed(Routes.filesListing, arguments: {'type': FLModule.companyFiles}, preventDuplicates: false);
            break;
          case 'take_instant_photo':
            FileUploaderParams params = FileUploaderParams(type: FileUploadType.instantPhoto);
            UploadService.takePictureAndAddToQueue(params);
            break;
          case 'instant_photo_gallery':
            Get.toNamed(Routes.filesListing, arguments: {'type': FLModule.instantPhotoGallery}, preventDuplicates: false);
            break;
          case 'tasks':
            Get.toNamed(Routes.taskListing, preventDuplicates: false);
            break;
          case 'sql':
            Get.toNamed(Routes.sql); 
            break;
          case 'clock_summary':
            Get.toNamed(Routes.clockSummary, preventDuplicates: false);
            break;
          case 'snippets':
            Get.offCurrentToNamed(Routes.snippetsListing, arguments: {'type': STArg.snippet});
            break;
          case 'uploads':
            Get.toNamed(Routes.uploadsListing);
            break;
          case 'draw':
            Get.toNamed(Routes.imageEditor);
            break;
          case 'recent_jobs':
            showJPBottomSheet(child: (_) => RecentJobBottomSheet(currentJob: currentJob), isScrollControlled: true);
            break;
          case 'near_by_jobs':
            Get.toNamed(Routes.jobListing, arguments: {NavigationParams.pageType: CJListType.nearByJobs}, preventDuplicates: false);
            break;
          case 'my_daily_plans':
            Get.toNamed(Routes.dailyPlan, preventDuplicates: false);
            break;
          case 'staff_calender':
            Get.offCurrentToNamed(Routes.calendar);
            break;
          case 'production_calender':
            Get.offCurrentToNamed(Routes.calendar, arguments: {'type' : CalendarType.production});
            break;
          case 'progress_board':
            Get.toNamed(Routes.progressBoard, preventDuplicates: false);
            break;
          case 'appointments':
            Get.toNamed(Routes.appointmentListing);
            break;
            case 'workflow':
            Get.toNamed(Routes.workflow);
            break;
          case 'dropbox':
            Get.toNamed(Routes.filesListing, arguments: {'type': FLModule.dropBoxListing}, preventDuplicates: false);
            break;
          case 'my_profile':
            Get.toNamed(Routes.myProfile);
            break;
          case 'companycam':
            Get.toNamed(Routes.filesListing, arguments: {'type': FLModule.companyCamProjects}, preventDuplicates: false);
            break;
          case 'templates':
            Get.toNamed(Routes.filesListing, arguments: {NavigationParams.type: FLModule.templatesListing, "parent_module" : FLModule.estimate}, preventDuplicates: false);
            break;
          case 'third_party_tools':
            Get.toNamed(Routes.thirdPartyTools);
            break;
          case 'clock_in':
          case 'clock_out':
            Get.toNamed(Routes.clockInClockOut);
            break;
          case 'messages_text':
            if (Get.currentRoute != Routes.chatsListing) {
              Get.toNamed(Routes.chatsListing, preventDuplicates: false);
            }
            break;
          case 'settings':
            var result = await Get.toNamed(Routes.setting, preventDuplicates: false);
            if(result != null) Get.forceAppUpdate();
            break;
          case 'add_lead_prospect_customer':
            Get.toNamed(Routes.customerForm);
            break;
          case 'add_job':
            Get.toNamed(Routes.jobForm, arguments: {
              NavigationParams.jobModel: currentJob,
              NavigationParams.type: JobFormType.add,
              NavigationParams.parentFormType: ParentFormType.inherited
            });
            break;
          case 'edit_job':
            Get.toNamed(Routes.jobForm, arguments: {
              NavigationParams.jobModel: currentJob,
              NavigationParams.type: JobFormType.edit,
              NavigationParams.parentFormType: ParentFormType.inherited
            });
            break;
          case 'support':
            Get.toNamed(Routes.supportForm);
            break;
          case 'add_project':
            Get.toNamed(Routes.projectForm, arguments: {
              NavigationParams.jobModel: currentJob,
              NavigationParams.type: JobFormType.add,
              NavigationParams.parentFormType: ParentFormType.individual
            });
            break;
          case 'edit_project':
            Get.toNamed(Routes.projectForm, arguments: {
              NavigationParams.jobModel: currentJob,
              NavigationParams.type: JobFormType.edit,
              NavigationParams.parentFormType: ParentFormType.individual
            });
            break;  
          case 'edit_customer':
            Get.toNamed(Routes.customerForm, arguments: {
              NavigationParams.customerId: currentJob?.customerId,
            });
            break;
        }
      });
  }
}
