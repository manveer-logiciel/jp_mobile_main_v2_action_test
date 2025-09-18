
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/firebase.dart';
import 'package:jobprogress/common/models/firebase/firebase_realtime.dart';
import 'package:jobprogress/common/repositories/appointment.dart';
import 'package:jobprogress/common/repositories/automation.dart';
import 'package:jobprogress/common/repositories/company_settings.dart';
import 'package:jobprogress/common/repositories/daily_plan.dart';
import 'package:jobprogress/common/repositories/permission.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/automation.dart';
import 'package:jobprogress/common/services/clock_in_clock_out.dart';
import 'package:jobprogress/common/services/sql.dart';
import 'package:jobprogress/common/services/workflow_stages/workflow_service.dart';
import 'package:jobprogress/common/services/worksheet/helpers.dart';
import 'package:jobprogress/core/constants/firebase/firebase_paths.dart';
import 'package:jobprogress/core/constants/firebase/firebase_realtime_keys.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/global_widgets/main_drawer/find_page_controller.dart';
import 'package:jobprogress/routes/pages.dart';

class RealtimeStreams {

  static List<FirebaseRealtimeStreamModel> streamsData(FirebasePaths firebasePaths) => [

    FirebaseRealtimeStreamModel(
        firebasePaths.userBasePath + FirebaseRealtimeKeys.job,
        RealTimeKeyType.job
    ), // FirebaseRealtimeKeys.job

    FirebaseRealtimeStreamModel(
        firebasePaths.companyBasePath + FirebaseRealtimeKeys.workflowUpdated,
        RealTimeKeyType.workflowUpdated,
        onValueChanged: () {
          WorkFlowService.get()?.fetchStages();
        }
    ), // FirebaseRealtimeKeys.workflowUpdated

    FirebaseRealtimeStreamModel(
        firebasePaths.userBasePath + FirebaseRealtimeKeys.taskTodayUpdated,
        RealTimeKeyType.taskTodayUpdated,
        onValueChanged: DailyPlanRepository.setDailyPlanCount,
    ), // FirebaseRealtimeKeys.taskTodayUpdated

    FirebaseRealtimeStreamModel(
      firebasePaths.userBasePath + FirebaseRealtimeKeys.taskUpcomingUpdated,
      RealTimeKeyType.taskUpcomingUpdated,
    ), // FirebaseRealtimeKeys.taskUpcomingUpdated

    FirebaseRealtimeStreamModel(
        firebasePaths.userBasePath + FirebaseRealtimeKeys.appointmentTodayUpdated,
        RealTimeKeyType.appointmentTodayUpdated,
        onValueChanged: DailyPlanRepository.setDailyPlanCount,
    ), // FirebaseRealtimeKeys.appointmentTodayUpdated

    FirebaseRealtimeStreamModel(
      firebasePaths.userBasePath + FirebaseRealtimeKeys.appointmentUpcomingUpdated,
      RealTimeKeyType.appointmentUpcomingUpdated,
      onValueChanged:AppointmentRepository().fetchAppointmentCount, 
    ), // FirebaseRealtimeKeys.appointmentUpcomingUpdated

    FirebaseRealtimeStreamModel(
        firebasePaths.userBasePath + FirebaseRealtimeKeys.eventTodayUpdated,
        RealTimeKeyType.eventTodayUpdated,
        onValueChanged: DailyPlanRepository.setDailyPlanCount,
    ), // FirebaseRealtimeKeys.eventTodayUpdated

    FirebaseRealtimeStreamModel(
        firebasePaths.userBasePath + FirebaseRealtimeKeys.scheduleTodayUpdated,
        RealTimeKeyType.scheduleTodayUpdated,
        onValueChanged: DailyPlanRepository.setDailyPlanCount,
    ), // FirebaseRealtimeKeys.scheduleTodayUpdated

    FirebaseRealtimeStreamModel(
      firebasePaths.userBasePath + FirebaseRealtimeKeys.permissionUpdated,
      RealTimeKeyType.permissionUpdated,
      onValueChanged: PermissionRepository.getPermissions,
    ), // FirebaseRealtimeKeys.permissionUpdated

    FirebaseRealtimeStreamModel(
        firebasePaths.countBasePath + FirebaseRealtimeKeys.taskPending,
        RealTimeKeyType.taskPending
    ), // FirebaseRealtimeKeys.taskPending

    FirebaseRealtimeStreamModel(
      firebasePaths.countBasePath + FirebaseRealtimeKeys.notificationUnread,
      RealTimeKeyType.notificationUnread,
    ), // FirebaseRealtimeKeys.notificationUnread

    FirebaseRealtimeStreamModel(
      firebasePaths.companyBasePath + FirebaseRealtimeKeys.automationFeedUpdated,
      RealTimeKeyType.automationFeedUpdated,
      onData: (val) => AutomationRepository().fetchNewAutomationCount(AutomationService.automationId.toString()),
    ),

    FirebaseRealtimeStreamModel(
      firebasePaths.countBasePath + FirebaseRealtimeKeys.textMessageUnread,
      RealTimeKeyType.textMessageUnread,
    ), // FirebaseRealtimeKeys.textMessageUnread

    FirebaseRealtimeStreamModel(
      firebasePaths.countBasePath + FirebaseRealtimeKeys.emailUnread,
      RealTimeKeyType.emailUnread,
      onValueChanged: () async {
        if(Get.currentRoute == Routes.email || Get.currentRoute == '/EmailListingView') {
          FindPageController().getFromRoute(Get.currentRoute).refreshList(
              doRefreshDetailList: false,
              showLoading: false
          );
        }
      }
    ), // FirebaseRealtimeKeys.emailUnread

    FirebaseRealtimeStreamModel(
      firebasePaths.countBasePath + FirebaseRealtimeKeys.messageUnread,
      RealTimeKeyType.messageUnread,
    ), // FirebaseRealtimeKeys.messageUnread

    FirebaseRealtimeStreamModel(
      firebasePaths.settingBasePath + FirebaseRealtimeKeys.isRestricted,
      RealTimeKeyType.isRestricted,
      onData: (val) {
        if(val is String) {
          val = val == 'true';
        }
        AuthService.saveRestriction(val);
      }
    ), // FirebaseRealtimeKeys.isRestricted

    FirebaseRealtimeStreamModel(
      firebasePaths.userBasePath + FirebaseRealtimeKeys.checkInCheckOutWithOutJob,
      RealTimeKeyType.checkInCheckOutWithOutJob,
      onData: (dynamic val) async {
        ClockInClockOutService.isCheckInWithoutJob = val == '1';
        await ClockInClockOutService.setUpCheckInDetails();
        Get.forceAppUpdate();
      }
    ), // FirebaseRealtimeKeys.checkInCheckOutWithOutJob

    FirebaseRealtimeStreamModel(
      firebasePaths.userBasePath + FirebaseRealtimeKeys.checkInJob,
      RealTimeKeyType.checkInJob,
      onData: (dynamic val) async {
        ClockInClockOutService.checkInJobId = val;
        await ClockInClockOutService.setUpCheckInDetails();
        Get.forceAppUpdate();
      }
    ), // FirebaseRealtimeKeys.checkInJob

    FirebaseRealtimeStreamModel(
        firebasePaths.companyBasePath + FirebaseRealtimeKeys.companySettingUpdated,
        RealTimeKeyType.companySettingUpdated,
        onValueChanged: () async {
          await CompanySettingRepository.fetchCompanySettings();
          DateTimeHelper.setUpTimeZone();
        }
    ), // FirebaseRealtimeKeys.companySettingUpdated

    FirebaseRealtimeStreamModel(
      firebasePaths.userBasePath + FirebaseRealtimeKeys.userSettingUpdated,
      RealTimeKeyType.userSettingUpdated,
      onValueChanged: CompanySettingRepository.fetchCompanySettings
    ), // FirebaseRealtimeKeys.userSettingUpdated

    FirebaseRealtimeStreamModel(
        firebasePaths.companyBasePath + FirebaseRealtimeKeys.companyStateLastUpdatedTime,
        RealTimeKeyType.companyStateLastUpdatedTime,
        doListenInitialRead: false,
        onData: (lastUpdateTime) => SqlService.syncCompanyState(dateTime: lastUpdateTime),
    ), // FirebaseRealtimeKeys.companyStateLastUpdatedTime

    FirebaseRealtimeStreamModel(
        firebasePaths.companyBasePath + FirebaseRealtimeKeys.userLastUpdatedTime,
        RealTimeKeyType.userLastUpdatedTime,
        doListenInitialRead: false,
        onData: (lastUpdateTime) => SqlService.syncUsers(dateTime: lastUpdateTime),
    ), // FirebaseRealtimeKeys.userLastUpdatedTime

    FirebaseRealtimeStreamModel(
        firebasePaths.companyBasePath + FirebaseRealtimeKeys.divisionLastUpdatedTime,
        RealTimeKeyType.divisionLastUpdatedTime,
        doListenInitialRead: false,
        onData: (lastUpdateTime) => SqlService.syncDivisions(dateTime: lastUpdateTime)
    ), // FirebaseRealtimeKeys.divisionLastUpdatedTime

    FirebaseRealtimeStreamModel(
        firebasePaths.companyBasePath + FirebaseRealtimeKeys.tagsLastUpdatedTime,
        RealTimeKeyType.tagsLastUpdatedTime,
        doListenInitialRead: false,
        onData: (lastUpdatedTime) => SqlService.syncTags(dateTime: lastUpdatedTime)
    ), // FirebaseRealtimeKeys.tagsLastUpdatedTime

    FirebaseRealtimeStreamModel(
        firebasePaths.companyBasePath + FirebaseRealtimeKeys.companyTradesLastUpdatedTime,
        RealTimeKeyType.companyTradesLastUpdatedTime,
        doListenInitialRead: false,
        onData: (lastUpdatedTime) => SqlService.syncTradeType(dateTime: lastUpdatedTime)
    ), // FirebaseRealtimeKeys.companyTradesLastUpdatedTime

    FirebaseRealtimeStreamModel(
        firebasePaths.companyBasePath + FirebaseRealtimeKeys.customerFlagsUpdatedTime,
        RealTimeKeyType.customerFlagsUpdatedTime,
        doListenInitialRead: false,
        onData: (lastUpdatedTime) => SqlService.syncFlags(dateTime: lastUpdatedTime)
    ), // FirebaseRealtimeKeys.customerFlagsUpdatedTime

    FirebaseRealtimeStreamModel(
        firebasePaths.companyBasePath + FirebaseRealtimeKeys.jobFlagsLastUpdatedTime,
        RealTimeKeyType.jobFlagsLastUpdatedTime,
        doListenInitialRead: false,
        onData: (lastUpdatedTime) => SqlService.syncFlags(dateTime: lastUpdatedTime)
    ), // FirebaseRealtimeKeys.jobFlagsLastUpdatedTime

    FirebaseRealtimeStreamModel(
        firebasePaths.companyBasePath + FirebaseRealtimeKeys.companyWorkflowLastUpdatedTime,
        RealTimeKeyType.companyWorkflowLastUpdatedTime,
        doListenInitialRead: false,
        onData: (lastUpdatedTime) => SqlService.syncWorkflowStages(dateTime: lastUpdatedTime)
    ), // FirebaseRealtimeKeys.companyWorkflowLastUpdatedTime

    FirebaseRealtimeStreamModel(
        firebasePaths.companyBasePath + FirebaseRealtimeKeys.referralsLastUpdatedTime,
        RealTimeKeyType.referralsLastUpdatedTime,
        doListenInitialRead: false,
        onData: (lastUpdatedTime) => SqlService.syncReferralSource(dateTime: lastUpdatedTime)
    ), // FirebaseRealtimeKeys.referralsLastUpdatedTime

    FirebaseRealtimeStreamModel(
        firebasePaths.userBasePath + FirebaseRealtimeKeys.beaconConnectionStatusUpdatedAt,
        RealTimeKeyType.beaconConnectionStatusUpdatedAt,
        doListenInitialRead: false,
        onValueChanged: WorksheetHelpers.updateUserBeaconClient
    ), // FirebaseRealtimeKeys.beaconConnectionStatusUpdatedAt

  ];

}