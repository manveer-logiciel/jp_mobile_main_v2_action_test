import 'package:get/get.dart';
import 'package:jobprogress/common/models/mix_panel/index.dart';
import 'package:jobprogress/core/constants/mix_panel/event/view_events.dart';
import 'package:jobprogress/routes/pages.dart';
import 'sub_module_handler.dart';

class MixPanelHelperRouteToViewEvent {

  static MixPanelModel getViewEvent(Routing routing) {
    MixPanelModel event = MixPanelModel();

    final subModuleHandler = MixPanelHelperSubModuleHandler(routing.args, event, routing.current);

    String route = routing.current;

    switch (route) {
      case Routes.taskListing:
      case '/TaskListingView':
        event = MixPanelViewEvent.tasksListing;
        break;

      case Routes.notificationListing:
        event = MixPanelViewEvent.notificationListing;
        break;

      case Routes.companyContacts:
        event = MixPanelViewEvent.companyContactsListing;
        break;

      case Routes.snippetsListing:
      case '/SnippetsListingView':
        event = subModuleHandler.getSnippetListingEvent();
        break;

      case Routes.dailyPlan:
        event = MixPanelViewEvent.dailyPlanListing;
        break;

      case Routes.customerDetailing:
        event = MixPanelViewEvent.customerDetails;
        break;

      case Routes.email:
      case '/EmailListingView':
        event = MixPanelViewEvent.emailListing;
        break;

      case Routes.customerListing:
        event = MixPanelViewEvent.customerListing;
        break;

      case Routes.clockSummary:
      case '/ClockSummaryView':
        event = MixPanelViewEvent.clockSummaryListing;
        break;

      case Routes.workCrewNotesListing:
        event = MixPanelViewEvent.workCrewNotesListing;
        break;

      case Routes.jobNoteListing:
        event = MixPanelViewEvent.jobNotesListing;
        break;

      case Routes.followUpsNoteListing:
        event = MixPanelViewEvent.followUpNotesListing;
        break;

      case Routes.uploadsListing:
        event = MixPanelViewEvent.uploadsListing;
        break;

      case Routes.jobListing:
        event = subModuleHandler.getJobListingEvent();
        break;

      case Routes.emaiTemplateList:
        event = MixPanelViewEvent.emailTemplateListing;
        break;

      case Routes.jobfinancialListingModule:
        event = subModuleHandler.getFinancialListingEvent();
        break;

      case Routes.customerJobSearch:
        event = MixPanelViewEvent.customerJobSearchListing;
        break;

      case Routes.appointmentListing:
        event = MixPanelViewEvent.appointmentListing;
        break;

      case Routes.workflow:
        event = MixPanelViewEvent.workFlowStagesListing;
        break;

      case Routes.companyCam:
        event = MixPanelViewEvent.companyCamListing;
        break;

      case Routes.thirdPartyTools:
        event = MixPanelViewEvent.thirdPartyToolsListing;
        break;

      case Routes.jobRecurringEmail:
        event = MixPanelViewEvent.jobRecurringEmailListing;
        break;

      case Routes.jobSaleAutomationEmailListing:
        event = MixPanelViewEvent.jobSalesAutomationEmailListing;
        break;

      case Routes.jobSaleAutomationTaskListing:
        event = MixPanelViewEvent.jobSalesAutomationTaskListing;
        break;

      case Routes.chatsListing:
        event = subModuleHandler.getChatsListingEvent();
        break;

      case Routes.messages:
        event = MixPanelViewEvent.messagingListing;
        break;

      case Routes.filesListing:
      case '/FilesListingView':
        event = subModuleHandler.getFilesListingEvent();
        break;

      case Routes.jobSummary:
        event = MixPanelViewEvent.jobSummary;
        break;

      case Routes.jobfinancial:
        event = MixPanelViewEvent.jobFinancials;
        break;

      case Routes.jobProfitLossSummary:
        event = MixPanelViewEvent.jobPLSummary;
        break;

      case Routes.companyContactsView:
        event = MixPanelViewEvent.companyContactDetails;
        break;

      case Routes.timeLogDetails:
        event = MixPanelViewEvent.timeLogDetails;
        break;

      case Routes.jobDetailing:
        event = MixPanelViewEvent.jobDetails;
        break;

      case Routes.myProfile:
        event = MixPanelViewEvent.userProfileDetails;
        break;

      case Routes.documentExpired:
        event = MixPanelViewEvent.documentExpiredDetails;
        break;

      case Routes.insuranceDetails:
        event = MixPanelViewEvent.insuranceDetails;
        break;

      case Routes.createTaskForm:
        event = subModuleHandler.getTaskFormEvent();
        break;

      case Routes.jobScheduleListing:
        event = MixPanelViewEvent.jobsScheduleListing;
        break;

      case Routes.createEventForm:
        event = subModuleHandler.getEventFormEvent();
        break;

      case Routes.login:
        event = MixPanelViewEvent.loginView;
        break;

      case Routes.home:
        event = MixPanelViewEvent.homeView;
        break;

      case Routes.sql:
        event = MixPanelViewEvent.localDbSettingsView;
        break;

      case Routes.imageEditor:
        event = MixPanelViewEvent.drawingToolView;
        break;

      case Routes.calendar:
        event = subModuleHandler.getCalendarEvent();
        break;

      case Routes.composeEmail:
        event = MixPanelViewEvent.emailComposeView;
        break;

      case Routes.clockInClockOut:
        event = MixPanelViewEvent.clockInClockOutView;
        break;

      case Routes.progressBoard:
        event = MixPanelViewEvent.progressBoardView;
        break;

      case Routes.setting:
        event = MixPanelViewEvent.settingsView;
        break;
    }

    if (event.path.isEmpty) event.path = routing.current;

    return event;
  }
}
