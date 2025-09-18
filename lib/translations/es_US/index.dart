import 'package:jobprogress/translations/es_US/global_widget/share_via_text/index.dart';
import 'package:jobprogress/translations/es_US/core/constant/duration_type/index.dart';
import 'package:jobprogress/translations/es_US/core/utils/updgrade_plan_helper/index.dart';
import 'package:jobprogress/translations/es_US/common/index.dart';
import 'package:jobprogress/translations/es_US/global_widget/QuickBookError/index.dart';
import 'package:jobprogress/translations/es_US/global_widget/custom_date_dialog/index.dart';
import 'package:jobprogress/translations/es_US/global_widget/recurring_bottom_sheet/index.dart';
import 'package:jobprogress/translations/es_US/messages/confirmation.dart';
import 'package:jobprogress/translations/es_US/messages/error.dart';
import 'package:jobprogress/translations/es_US/messages/validation.dart';
import 'package:jobprogress/translations/es_US/pages/appointment/index.dart';
import 'package:jobprogress/translations/es_US/pages/call_log/index.dart';
import 'package:jobprogress/translations/es_US/pages/chats/index.dart';
import 'package:jobprogress/translations/es_US/pages/daily_plan/index.dart';
import 'package:jobprogress/translations/es_US/pages/document_expired/index.dart';
import 'package:jobprogress/translations/es_US/pages/email/index.dart';
import 'package:jobprogress/translations/es_US/pages/files_listing/index.dart';
import 'package:jobprogress/translations/es_US/pages/follow_ups_notes/index.dart';
import 'package:jobprogress/translations/es_US/pages/forgot_password/index.dart';
import 'package:jobprogress/translations/es_US/pages/company_contact_listing/index.dart';
import 'package:jobprogress/translations/es_US/pages/job_financial/index.dart';
import 'package:jobprogress/translations/es_US/pages/login/index.dart';
import 'package:jobprogress/translations/es_US/pages/notification/index.dart';
import 'package:jobprogress/translations/es_US/pages/task/index.dart';
import 'package:jobprogress/translations/es_US/pages/work_crew_note/index.dart';
import 'package:jobprogress/translations/es_US/recent_jobs/index.dart';
import 'package:jobprogress/translations/es_US/pages/snippets/index.dart';
import 'package:jobprogress/translations/es_US/task_detail/index.dart';
import 'package:jobprogress/translations/es_US/pages/job_notes/index.dart';
import 'package:jobprogress/translations/es_US/pages/clock_summary/index.dart';
import 'package:jp_mobile_flutter_ui/Translations/es_us.dart';
import 'schedule/details/index.dart';
import 'pages/schedules/schedules.dart';
import 'global_widget/consent_form/index.dart';
import 'global_widget/day_count_down_tile/index.dart';
import 'global_widget/division_unmatch_dialog/index.dart';
import 'global_widget/main_drawer/index.dart';
import 'global_widget/search_location/index.dart';
import 'pages/calendars/index.dart';
import 'pages/confirm_consent/index.dart';
import 'pages/contacts_view/index.dart';
import 'pages/customer_listing/index.dart';
import 'pages/cutomer_job_search/index.dart';
import 'pages/drawing_tool/index.dart';
import 'pages/email_template/index.dart';
import 'pages/home/index.dart';
import 'pages/job/index.dart';
import 'pages/local_db_settings/index.dart';
import 'pages/my_profile/index.dart';
import 'pages/profit_loss_summary/inde.dart';
import 'pages/progress_board/index.dart';
import 'pages/project/index.dart';
import 'pages/settings/index.dart';
import 'pages/third_party_tools/index.dart';
import 'pages/uploads/index.dart';
import 'pages/automation/index.dart';

class EsUsTranslationStrings {
  static Map<String, String> allStrings = {
    ...EsUsCommonTranslations.strings,
    ...EsUsErrorMessageTranslations.strings,
    ...EsUsValidationMessageTranslations.strings,
    ...EsUsCompanyContactListingMessageTranslations.strings,
    ...EsUsMainDrawerTranslations.strings,
    ...EsUsCustomDialogTranslations.strings,
    ...EsUsSnippetMessageTranslations.strings,
    ...EsUsConfirmatioMessageTranslations.strings,
    ...EsUsFilesListingTranslation.strings,
    ...EsUsRecentJobsTranslations.strings,
    ...EsUsNotificationsTranslations.strings,
    ...EsUsJPTaskDetailBottomSheetTranslations.strings,
    ...EsUsLoginTranslations.strings,
    ...EsUsTaskMessageTranslations.strings,
    ...EsUsWorkCrewNotesTranslations.strings,
    ...EsUsJobFinancialTranslations.strings,
    ...EsUsThirdPartyToolsTranslations.strings,
    ...EsUsEmailTranslations.strings,
    ...EsUsJPScheduleDetailTranslations.strings,
    ...EsUsCallLogMessageTranslations.strings,
    ...EsUsFollowUpsNotesTranslation.strings,
    ...EsUsJobNoteTranslations.strings,
    ...EsUsClockSummaryTranslations.strings,
    ...EsUsSchedulesTranslations.strings,
    ...EsUsDailyPlanTranslations.strings,
    ...EsUsDurationTypeConstantsTranslations.strings,
    ...EsUsQuickBookErrorTranslations.strings,
    ...EsUsRecurringBottomSheetTranslations.strings,
    ...EsUsShareViaTextTranslations.strings,
    ...EsUsDocumentExpiredTranslations.strings,
    ...EsUsForgotPasswordTranslations.strings,
    ...EsUsConsentFormTranslations.strings,
    ...EsUsDayCountDownTranslations.strings,
    ...EsUsDivisionUnMatchTranslations.strings,
    ...EsUsJPCollapsibleMapViewTranslations.strings,
    ...EsUsCalendarMessageTranslations.strings,
    ...EsUsChatsTranslations.strings,
    ...EsUsConfirmConsentMessageTranslations.strings,
    ...EsUsCompanyContactViewMessageTranslations.strings,
    ...EsUsCustomerMessageTranslations.strings,
    ...EsUsCustomerJobSearchMessageTranslations.strings,
    ...EsUsDrawingToolTranslations.strings,
    ...EsUsEmailTemplateListingTranslation.strings,
    ...EsUsHomeTranslations.strings,
    ...EsUsJobMessageTranslations.strings,
    ...EsUsLocalDBSettingsTranslations.strings,
    ...EsUsMyProfileTranslations.strings,
    ...EsUsProfitLossSummaryMessageTranslations.strings,
    ...EsUsProgressBoardTranslations.strings,
    ...EsUsProjectTranslations.strings,
    ...EsUsSettingsTranslations.strings,
    ...EsUsUploadsTranslations.strings,
    ...EsUsUpgradePlanHelperTranslations.strings,
    ...EsUsAutomationTranslations.strings,
    ...EsUsAppointmentTranslations.strings,
    ...UiKitEsUS.translations,
  };
}
