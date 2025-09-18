import 'package:jobprogress/common/enums/calendars.dart';
import 'package:jobprogress/common/enums/cj_list_type.dart';
import 'package:jobprogress/common/enums/event_form_type.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/job_financial_listing.dart';
import 'package:jobprogress/common/enums/snippet_trade_script.dart';
import 'package:jobprogress/common/enums/task_form_type.dart';
import 'package:jobprogress/common/models/mix_panel/index.dart';
import 'package:jobprogress/core/constants/mix_panel/event/view_events.dart';
import 'package:jobprogress/core/constants/mix_panel/titles.dart';
import 'package:jobprogress/core/utils/firebase/firestore.dart';

class MixPanelHelperSubModuleHandler {

  /// [args] is of dynamic type and helps in getting sub module details
  dynamic args;

  /// [event] takes in the existing MixPanel event and processed
  /// further to add useful information
  MixPanelModel event;

  /// [currentPath] used to hold current routing path
  String currentPath;

  MixPanelHelperSubModuleHandler(this.args, this.event, this.currentPath);

  MixPanelModel getFilesListingEvent() {
    FLModule? module = (args?['type'] as FLModule?);
    String? tempPath = module?.toString().split(".")[1];

    switch (module) {
      case FLModule.companyFiles:
        event = MixPanelViewEvent.companyFilesListing;
        break;

      case FLModule.estimate:
        event = MixPanelViewEvent.estimationsFilesListing;
        break;

      case FLModule.jobPhotos:
        event = MixPanelViewEvent.photosDocumentsFilesListing;
        break;

      case FLModule.jobProposal:
        event = MixPanelViewEvent.formProposalFilesListing;
        break;

      case FLModule.measurements:
        event = MixPanelViewEvent.measurementsFilesListing;
        break;

      case FLModule.materialLists:
        event = MixPanelViewEvent.materialsFilesListing;
        break;

      case FLModule.workOrder:
        event = MixPanelViewEvent.workOrderFilesListing;
        break;

      case FLModule.stageResources:
        event = MixPanelViewEvent.stageResourcesFilesListing;
        break;

      case FLModule.userDocuments:
        event = MixPanelViewEvent.userDocumentsFilesListing;
        break;

      case FLModule.customerFiles:
        event = MixPanelViewEvent.customerFilesListing;
        break;

      case FLModule.instantPhotoGallery:
        event = MixPanelViewEvent.instantPhotoFilesListing;
        break;

      case FLModule.dropBoxListing:
        event = MixPanelViewEvent.dropBoxFilesListing;
        break;

      case FLModule.financialInvoice:
        event = MixPanelViewEvent.financialInvoiceFilesListing;
        break;

      case FLModule.companyCamProjects:
        event = MixPanelViewEvent.companyCamProjectsListing;
        break;

      case FLModule.companyCamProjectImages:
        event = MixPanelViewEvent.companyCamProjectImagesListing;
        break;

      default:
        break;
    }

    event.path = currentPath;
    if (tempPath != null) event.path += "-$tempPath";

    return event;
  }

  MixPanelModel getSnippetListingEvent() {
    STArg? module = (args?['type'] as STArg?);
    String? tempPath = module?.toString().split(".")[1];

    switch (module) {
      case STArg.snippet:
        event = MixPanelViewEvent.snippetsListing;
        break;

      case STArg.tradeScript:
        event = MixPanelViewEvent.tradeScriptListing;
        break;

      default:
        break;
    }

    event.path = currentPath;
    if (tempPath != null) event.path += "-$tempPath";

    return event;
  }

  MixPanelModel getEventFormEvent() {
    EventFormType? module = (args?['page_type'] as EventFormType?);
    String? tempPath = module?.toString().split(".")[1];

    switch (module) {
      case EventFormType.createForm:
        event = MixPanelViewEvent.createEventForm;
        break;

      case EventFormType.editForm:
        event = MixPanelViewEvent.editEventForm;
        break;

      case EventFormType.createScheduleForm:
        event = MixPanelViewEvent.createScheduleForm;
        break;

      case EventFormType.editScheduleForm:
        event = MixPanelViewEvent.editScheduleForm;
        break;

      default:
        break;
    }

    event.path = currentPath;
    if (tempPath != null) event.path += "-$tempPath";

    return event;
  }

  MixPanelModel getCalendarEvent() {
    CalendarType? module = (args?['type'] as CalendarType?);
    module ??= CalendarType.staff;
    String? tempPath = module.toString().split(".")[1];

    event = MixPanelViewEvent.staffCalendarView;

    switch (module) {
      case CalendarType.staff:
        event = MixPanelViewEvent.staffCalendarView;
        break;

      case CalendarType.production:
        event = MixPanelViewEvent.productionCalendarView;
        break;
    }

    event.path = "$currentPath-$tempPath";

    return event;
  }

  MixPanelModel getJobListingEvent() {
    CJListType? module = (args?['page_type'] as CJListType?);
    module ??= CJListType.job;
    String? tempPath = module.toString().split(".")[1];
    //
    switch (module) {

      case CJListType.customer:
        event = MixPanelViewEvent.customerListing;
        break;

      case CJListType.job:
        event = MixPanelViewEvent.jobsListing;
        break;

      case CJListType.projectJobs:
        event = MixPanelViewEvent.projectsListing;
        break;

      case CJListType.scheduledJobs:
        event = MixPanelViewEvent.jobsScheduleListing;
        break;

      case CJListType.nearByJobs:
        event = MixPanelViewEvent.nearByJobsListing;
        break;
    }

    event.path = "$currentPath-$tempPath";

    return event;
  }

  MixPanelModel getTaskFormEvent() {

    TaskFormType? module = (args?['page_type'] as TaskFormType?);
    String? tempPath = module?.toString().split(".")[1];

    switch (module) {
      case TaskFormType.createForm:
      case TaskFormType.progressBoardCreate:
        event = MixPanelViewEvent.createTaskForm;
        break;

      case TaskFormType.editForm:
      case TaskFormType.salesAutomation:
      case TaskFormType.progressBoardEdit:
        event = MixPanelViewEvent.editTaskForm;
        break;

      default:
        break;
    }

    event.path = currentPath;
    if (tempPath != null) event.path += "-$tempPath";

    return event;
  }

  MixPanelModel getChatsListingEvent() {

    int? jobId = int.tryParse((args?['jobId']?.toString()) ?? "");

    if(FirestoreHelpers.instance.isMessagingEnabled) {
      event = MixPanelViewEvent.chatsListingFirebase;
    } else {
      event = MixPanelViewEvent.chatsListingApi;
    }

    if(jobId != null) {
      event.title = "${MixPanelEventTitle.jobFilter} ${event.title}";
    }

    event.path = currentPath;
    return event;
  }

  MixPanelModel getFinancialListingEvent() {

    JFListingType? module = (args?['listing'] as JFListingType?);
    String? tempPath = module?.toString().split(".")[1];

    switch (module) {

      case JFListingType.jobPriceHistory:
        event = MixPanelViewEvent.jobPriceHistoryListView;
        break;

      case JFListingType.changeOrders:
        event = MixPanelViewEvent.jobChangeOrderListView;
        break;

      case JFListingType.paymentsReceived:
        event = MixPanelViewEvent.jobPaymentReceivedListView;
        break;

      case JFListingType.credits:
        event = MixPanelViewEvent.jobCreditListView;
        break;

      case JFListingType.refunds:
        event = MixPanelViewEvent.jobRefundHistoryListView;
        break;

      case JFListingType.accountspayable:
        event = MixPanelViewEvent.jobAccountsPayableListView;
        break;

      case JFListingType.jobInvoicesWithoutThumb:
      case JFListingType.jobInvoices:
        event = MixPanelViewEvent.financialInvoiceFilesListing;
        break;

      case JFListingType.commission:
        event = MixPanelViewEvent.jobCommissionListing;
        break;

      case JFListingType.commissionPayment:
        event = MixPanelViewEvent.jobCommissionPaymentListing;
        break;

      case JFListingType.cumulativeInvoices:
        event = MixPanelViewEvent.jobCumulativeInvoiceListing;
        break;

      default:
        break;
    }

    event.path = currentPath;
    if (tempPath != null) event.path += "-$tempPath";

    return event;
  }

}
