import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/external_template_web_view/index.dart';
import 'package:jobprogress/modules/appointments/create_appointment/index.dart';
import 'package:jobprogress/modules/calendar/page.dart';
import 'package:jobprogress/modules/appointments/listing/binding.dart';
import 'package:jobprogress/modules/appointments/listing/page.dart';
import 'package:jobprogress/modules/appointment_details/binding.dart';
import 'package:jobprogress/modules/appointment_details/page.dart';
import 'package:jobprogress/modules/chats/groups_listing/page.dart';
import 'package:jobprogress/modules/chats/messages/page.dart';
import 'package:jobprogress/modules/clock_in_clock_out/page.dart';
import 'package:jobprogress/modules/clock_summary/listing/binding.dart';
import 'package:jobprogress/modules/clock_summary/listing/page.dart';
import 'package:jobprogress/modules/clock_summary/timelog_details/binding.dart';
import 'package:jobprogress/modules/clock_summary/timelog_details/page.dart';
import 'package:jobprogress/modules/company_contacts/listing/page.dart';
import 'package:jobprogress/modules/company_contacts/detail/binding.dart';
import 'package:jobprogress/modules/company_contacts/detail/page.dart';
import 'package:jobprogress/modules/customer/customer_form/index.dart';
import 'package:jobprogress/modules/customer_job_search/page.dart';
import 'package:jobprogress/modules/daily_plan/binding.dart';
import 'package:jobprogress/modules/daily_plan/page.dart';
import 'package:jobprogress/modules/demo/binding.dart';
import 'package:jobprogress/modules/demo/page.dart';
import 'package:jobprogress/modules/dev_console/index.dart';
import 'package:jobprogress/modules/document_expired/page.dart';
import 'package:jobprogress/modules/email/compose/binding.dart';
import 'package:jobprogress/modules/email/compose/page.dart';
import 'package:jobprogress/modules/drawing_tool/page.dart';
import 'package:jobprogress/modules/email/detail/binding.dart';
import 'package:jobprogress/modules/email/detail/page.dart';
import 'package:jobprogress/modules/email/listing/binding.dart';
import 'package:jobprogress/modules/email/listing/page.dart';
import 'package:jobprogress/modules/email/template_listing/binding.dart';
import 'package:jobprogress/modules/email/template_listing/page.dart';
import 'package:jobprogress/modules/files_listing/binding.dart';
import 'package:jobprogress/modules/files_listing/forms/insurance/page.dart';
import 'package:jobprogress/modules/files_listing/forms/custom_measurement/add_multiple_measurement/index.dart';
import 'package:jobprogress/modules/files_listing/forms/hover_order_form/index.dart';
import 'package:jobprogress/modules/files_listing/forms/custom_measurement/measurement_form/index.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/index.dart';
import 'package:jobprogress/modules/files_listing/page.dart';
import 'package:jobprogress/modules/files_listing/templates/form_proposal/index.dart';
import 'package:jobprogress/modules/files_listing/templates/handwritten/index.dart';
import 'package:jobprogress/modules/files_listing/templates/merge/index.dart';
import 'package:jobprogress/modules/follow_ups_notes/listing/binding.dart';
import 'package:jobprogress/modules/follow_ups_notes/listing/page.dart';
import 'package:jobprogress/modules/home/binding.dart';
import 'package:jobprogress/modules/home/page.dart';
import 'package:jobprogress/modules/job/job_detail/insurence_details/index.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/insurance_details/index.dart';
import 'package:jobprogress/modules/job/job_form/index.dart';
import 'package:jobprogress/modules/job/job_recurring_email/binding.dart';
import 'package:jobprogress/modules/job/job_recurring_email/page.dart';
import 'package:jobprogress/modules/job/job_sale_automation_email_listing/binding.dart';
import 'package:jobprogress/modules/job/job_sale_automation_email_listing/page.dart';
import 'package:jobprogress/modules/job/job_sale_automation_task_listing/binding.dart';
import 'package:jobprogress/modules/job/job_sale_automation_task_listing/page.dart';
import 'package:jobprogress/modules/job/job_summary/binding.dart';
import 'package:jobprogress/modules/job/job_summary/page.dart';
import 'package:jobprogress/modules/job_financial/form/apply_credit_form/index.dart';
import 'package:jobprogress/modules/job_financial/binding.dart';
import 'package:jobprogress/modules/job_financial/form/leappay_preferences/index.dart';
import 'package:jobprogress/modules/job_financial/form/payment_forms/apply_payment_form/index.dart';
import 'package:jobprogress/modules/job_financial/form/payment_forms/receive_payment_form/index.dart';
import 'package:jobprogress/modules/job_financial/form/payment_forms/receive_payment_form/review_payment/index.dart';
import 'package:jobprogress/modules/job_financial/listing/page.dart';
import 'package:jobprogress/modules/job_financial/page.dart';
import 'package:jobprogress/modules/job_note/listing/binding.dart';
import 'package:jobprogress/modules/job_note/listing/page.dart';
import 'package:jobprogress/modules/login/binding.dart';
import 'package:jobprogress/modules/login/page.dart';
import 'package:jobprogress/modules/my_profile/page.dart';
import 'package:jobprogress/modules/project/project_form/index.dart';
import 'package:jobprogress/modules/schedule/lisitng/page.dart';
import 'package:jobprogress/modules/snippets/listing/binding.dart';
import 'package:jobprogress/modules/snippets/listing/page.dart';
import 'package:jobprogress/modules/sql/binding.dart';
import 'package:jobprogress/modules/sql/page.dart';
import 'package:jobprogress/modules/srs_smart_template/page.dart';
import 'package:jobprogress/modules/supplier_order_details/binding.dart';
import 'package:jobprogress/modules/supplier_order_details/index.dart';
import 'package:jobprogress/modules/support/index.dart';
import 'package:jobprogress/modules/task/create_task/index.dart';
import 'package:jobprogress/modules/task/template_listing/binding.dart';
import 'package:jobprogress/modules/task/template_listing/page.dart';
import 'package:jobprogress/modules/third_party_tools/binding.dart';
import 'package:jobprogress/modules/third_party_tools/page.dart';
import 'package:jobprogress/modules/workflow/page.dart';
import 'package:jobprogress/modules/worksheet/page.dart';
import 'package:jobprogress/modules/worksheet/widgets/settings/page.dart';
import 'package:jobprogress/modules/worksheet/widgets/tiers_search/page.dart';
import '../global_widgets/macros/listing/binding.dart';
import '../global_widgets/macros/listing/page.dart';
import '../global_widgets/macros/macro_detail/binding.dart';
import '../global_widgets/macros/macro_detail/index.dart';
import '../global_widgets/search_location/search_screen/index.dart';
import '../modules/beacon_login/page.dart';
import '../modules/confirm_consent/index.dart';
import '../modules/eagle_view_connect/page.dart';
import '../modules/forgot_password/page.dart';
import '../modules/reset_password_link_sent/page.dart';
import '../modules/calendar/event/page.dart';
import '../modules/calendar/job_schedule/listing/page.dart';
import '../modules/company_contacts/create_company_contacts/index.dart';
import '../modules/customer/details/binding.dart';
import '../modules/customer/details/page.dart';
import '../modules/customer/listing/binding.dart';
import '../modules/customer/listing/page.dart';
import 'package:jobprogress/modules/task/listing/binding.dart';
import 'package:jobprogress/modules/task/listing/page.dart';
import 'package:jobprogress/modules/uploads/binding.dart';
import 'package:jobprogress/modules/uploads/page.dart';
import 'package:jobprogress/modules/work_crew_notes/listing/binding.dart';
import 'package:jobprogress/modules/work_crew_notes/listing/page.dart';
import '../modules/demo/Maps/index.dart';
import '../modules/financial_product_search/page.dart';
import '../modules/job_financial/form/bill_form/index.dart';
import '../modules/job_financial/form/invoice_form/index.dart';
import '../modules/job_financial/form/refund_form/index.dart';
import '../modules/files_listing/forms/eagle_view_form/page.dart';
import '../modules/files_listing/forms/quick_measure/page.dart';
import '../modules/customer_job_search/binding.dart';
import '../modules/job/job_detail/page.dart';
import '../modules/job/job_detail/binding.dart';
import '../modules/job/listing/page.dart';
import '../modules/job_financial/profit_loss_summary/binding.dart';
import '../modules/job_financial/profit_loss_summary/page.dart';
import '../modules/notification_listing/binding.dart';
import '../modules/notification_listing/page.dart';
import '../modules/progress_board/page.dart';
import '../modules/progress_board/reordering_job_listing/page.dart';
import '../modules/schedule/details/binding.dart';
import '../modules/schedule/details/page.dart';
import '../modules/settings/index.dart';
part './routes.dart';

abstract class AppPages {
  static final List<GetPage<dynamic>> pages = [
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.sql,
      page: () => const SqlView(),
      binding: SqlBinding(),
    ),
    GetPage(
        name: Routes.demo,
        page: () => const DemoView(),
        binding: DemoBinding()),
    GetPage(
        name: Routes.taskListing,
        page: () => const TaskListingView(),
        binding: TaskListingBinding()),
    GetPage(
        name: Routes.notificationListing,
        page: () => const NotificationListingView(),
        binding: NotificationListingBinding()),
    GetPage(
        name: Routes.companyContacts,
        page: () => const CompanyContactListingView()
    ),
    GetPage(
        name: Routes.filesListing,
        page: () => const FilesListingView(),
        binding: FilesListingBinding()),
    GetPage(
        name: Routes.companyContactsView,
        page: () => const CompanyContactListingViews(),
        binding: CompanyContactListingViewBinding()),
    GetPage(
        name: Routes.email,
        page: () => const EmailListingView(),
        binding: EmailListingBinding()),
    GetPage(
        name: Routes.emailDetailView,
        page: () => const EmailDetailView(),
        binding: EmailDetailBinding()),
    GetPage(
      name: Routes.snippetsListing,
      page: () => const SnippetsListingView(),
      binding: SnippetsListingBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: Routes.dailyPlan,
      page: () => const DailyTask(),
      binding: DailyTaskBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: Routes.customerListing,
      page: () => const CustomerListingView(),
      binding: CustomerListingBinding(),
    ),
    GetPage(
      name: Routes.jobSummary,
      page: () => const JobSummaryView(),
      binding: JobSummaryBinding(),
    ),
    GetPage(
      name: Routes.workCrewNotesListing,
      page: () => const WorkCrewNotesListingView(),
      binding: WorkCrewNotesListingBinding(),
    ),
    GetPage(
      name: Routes.scheduleDetail,
      page: () => const ScheduleDetail(),
      binding: ScheduleDetailBinding(),
    ),
    GetPage(
      name: Routes.uploadsListing,
      page: () => const UploadsListingView(),
      binding: UploadsListingBinding(),
    ),
    GetPage(
      name: Routes.customerDetailing,
      page: () => const CustomerDetailView(),
      binding: CustomerDetailingBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: Routes.clockSummary,
      page: () => const ClockSummaryView(),
      binding: ClockSummaryBinding(),
    ),
    GetPage(
      name: Routes.timeLogDetails,
      page: () => const TimeLogDetailsView(),
      binding: TimeLogDetailsBinding(),
    ),
    GetPage(
      name: Routes.jobNoteListing,
      page: () => const JobNoteListingView(),
      binding: JobNoteListingBinding(),
    ),
    GetPage(
      name: Routes.imageEditor,
      page: () => const DrawingTool(),
    ),
    GetPage(
      name: Routes.jobListing,
      page: () => const JobListingView(),
      preventDuplicates: true,
    ),
    GetPage(
      name: Routes.jobDetailing,
      page: () => const JobDetailView(),
      binding: JobDetailingBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: Routes.followUpsNoteListing,
      page: () => const FollowUpsNoteListingView(),
      binding: FollowUpsNotesListingBinding(),
    ),
    GetPage(
      name: Routes.composeEmail,
      page: () => const EmailComposeView(),
      binding: EmailComposeBinding(),
    ),
    GetPage(
      name: Routes.emaiTemplateList,
      page: () => const EmailTemplateListingView(),
      binding: EmailTemplateListBinding(),
    ),
    GetPage(
      name: Routes.calendar,
      page: () => const CalendarPageView(),
    ),
    GetPage(
      name: Routes.jobfinancial,
      page: () => const JobFinancialView(),
      binding: JobFinancialBinding(),
    ),
    GetPage(
        name: Routes.jobfinancialListingModule,
        page: () => const JobFinancialListingView(),
    ),
    GetPage(
      name: Routes.customerJobSearch,
      page: () => const CustomerJobSearchView(),
      binding: CustomerJobSearchBinding(),
    ),
    GetPage(
      name: Routes.appointmentListing,
      page: () => const AppointmentListingView(),
      binding: AppointmentListingBinding(),
    ),
    GetPage(
      name: Routes.appointmentDetails,
      page: () => const AppointmentDetailsView(),
      binding: AppointmentDetailsBinding(),
    ),
    GetPage(
      name: Routes.myProfile,
      page: () => const MyProfileView()
    ),
    GetPage(
      name: Routes.workflow,
      page: () => const WorkflowList()
    ),
    GetPage(
      name: Routes.thirdPartyTools,
      page: () => const ThirdPartyTools(),
      binding: ThirdPartyToolsBinding(),
    ),
    GetPage(
      name: Routes.clockInClockOut,
      page: () => const ClockInClockOutView(),
    ),
    GetPage(
      name: Routes.jobProfitLossSummary,
      page: () => const JobProfitLossSummaryView(),
      binding: JobProfitLossSummaryBinding(),
    ),
    GetPage(
      name: Routes.jobRecurringEmail,
      page: () => const JobRecurringEmailView(),
      binding: JobRecurringEmailBinding()
    ),
    GetPage(
      name: Routes.jobSaleAutomationEmailListing,
      page: () => const JobSaleAutomationEmailListing(),
      binding: JobSaleAutomationEmailLisitngBinding()
    ),
    GetPage(
      name: Routes.jobSaleAutomationTaskListing,
      page: () => const JobSaleAutomationTaskListing(),
      binding: JobSaleAutomationTaskListingBinding()
    ),
    GetPage(
      name: Routes.chatsListing,
      page: () => const GroupsListingPage(),
    ),
    GetPage(
      name: Routes.messages,
      page: () => const MessagesPage(),
    ),
    GetPage(
      name: Routes.progressBoard,
      page: () => const ProgressBoardView()
    ),
    GetPage(
      name: Routes.setting,
      page: () => const SettingView()
    ),
    GetPage(
      name: Routes.createEventForm,
      page: () => const EventFormView()
    ),
    GetPage(
      name: Routes.applyCreditForm,
      page: () => const ApplyCreditFormView()
    ),
    GetPage(
      name: Routes.jobScheduleListing,
      page: () => const JobScheduleListingView()
    ),
    GetPage(
      name: Routes.createTaskForm,
      page: () => const CreateTaskFormView()
    ),
    GetPage(
      name: Routes.createAppointmentForm,
      page: () => const CreateAppointmentFormView()
    ),
    GetPage(
      name: Routes.insuranceDetails,
      page: () => const InsuranceDetails()
    ),
    GetPage(
      name: Routes.documentExpired,
      page: () => const DocumentExpiredView()
    ),
    GetPage(
      name: Routes.receivePaymentForm,
      page: () => const ReceivePaymentFormView()
    ),
    GetPage(
      name: Routes.applyPaymentForm,
      page: () => const ApplyPaymentFormView()
    ),
    GetPage(
      name: Routes.reorderAbleJobListing,
      page: () => const ReorderAbleJobListingView()
    ),
    GetPage(
      name: Routes.mapSection,
      page: () => const MapSections()
    ),
    GetPage(
      name: Routes.quickMeasureForm,
      page: () => const QuickMeasureFormView()
    ),
    GetPage(
        name: Routes.searchLocation,
        page: () => const SearchLocationView()
    ),
    GetPage(
        name: Routes.hoverOrderForm,
        page: () => const HoverOrderFormView()
    ),
    GetPage(
      name: Routes.refundForm,
      page: () => const RefundFormView(),
    ),
    GetPage(
      name: Routes.financialProductSearch,
      page: () => const FinancialProductSearchView(),
    ),
    GetPage(
      name: Routes.measurementForm,
      page:() => const MeasurementFormView()
    ),
    GetPage(
      name: Routes.addMultipleMeasurement,
      page:() => const AddMultipleMeasurementView()
    ),
    GetPage(
      name: Routes.eagleViewForm,
      page: () => const EagleViewFormView()
    ),
    GetPage(
      name: Routes.createCompanyContact,
      page: () => const CreateCompanyContactFormView()
    ),
    GetPage(
      name: Routes.billForm,
      page: () => const BillFormView()
    ),
    GetPage(
      name: Routes.customerForm,
      page: () => const CustomerFormView()
    ),
    GetPage(
      name: Routes.jobForm,
      page: () => const JobFormView()
    ),
    GetPage(
      name: Routes.invoiceForm,
      page: () => const InvoiceForm()
    ),
    GetPage(
      name: Routes.insuranceForm,
      page: () => const InsuranceFormView()
    ),
    GetPage(
      name: Routes.insuranceDetailsForm,
      page: () => const InsuranceDetailsFormView(),
    ),
    GetPage(
      name: Routes.projectForm,
      page: () => const ProjectFormView()
    ),  
    GetPage(
      name: Routes.macroListing,
      page: () => const MacroListingView(),
      binding: MacroListingBinding(),
    ),
    GetPage(
      name: Routes.macroListDetail,
      page: () =>  const MacroListDetail(),
      binding: MacroProductBinding(),
    ),
    GetPage(
      name: Routes.formProposalTemplate,
      page: () => const FormProposalTemplateView()
    ),
    GetPage(
      name: Routes.worksheetForm,
      page: () => const WorksheetFormView()
    ),
    GetPage(
     name: Routes.placeSupplierOrderForm,
     page: () => const PlaceSupplierOrderFormView()
    ),
    GetPage(
      name: Routes.worksheetSetting,
      page: () => const WorksheetSettingsView()
    ),
    GetPage(
      name: Routes.supplierOrderDetail,
      page: () =>  const SupplierOrderDetail(),
      binding: SrsOrderDetailBinding(), 
    ),
    GetPage(
      name: Routes.formProposalMergeTemplate,
      page: () => const FormProposalMergeTemplateView()
    ),
    GetPage(
      name: Routes.handWrittenTemplate,
      page: () => const HandwrittenTemplatePage()
    ),
    GetPage(
      name: Routes.supportForm,
      page: () => const SupportFormView()
    ),
    GetPage(
      name: Routes.tierSearch,
      page: () => const TiersSearchView(),
    ),
    GetPage(
      name: Routes.srsSmartTemplate,
      page: () => const SrsSmartTemplateView()
    ),
    GetPage(
      name: Routes.schedulesListing,
      page: () => const SchedulesListingView(),
    ),
    GetPage(
      name: Routes.externalTemplateWebView,
      page: () => const JPExternalTemplateWebView(),
    ),
    GetPage(
      name: Routes.reviewPaymentDetails,
      page: () => const ReviewPaymentDetails(),
    ),
    GetPage(
      name: Routes.forgotPassword,
      page: () => const ForgotPasswordView(),
    ),
    GetPage(
        name: Routes.resetPasswordLinkSent,
        page: () => const ResetPasswordLinkSentView()
    ),
    GetPage(
        name: Routes.devConsole,
        page: () => const DevConsolePage()
    ),
    GetPage(
        name: Routes.beaconLoginWebView,
        page: () => const BeaconLoginWebView()
    ),
  GetPage(
      name: Routes.taskTemplateList,
      page: () => const TaskTemplateListingView(),
      binding: TaskTemplateListingBinding(),  
    ),
    GetPage(
        name: Routes.leapPayPreferences,
        page: () => const LeapPayPreferencesPage()
    ),
    GetPage(
        name: Routes.confirmConsent,
        page: () => const ConfirmConsentPage()
    ),
    GetPage(
        name: Routes.eagleViewConnectWebView,
        page: () => const EVConnectWebView()
    )
  ];
}
