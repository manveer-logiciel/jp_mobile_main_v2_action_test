import 'package:jobprogress/translations/en_US/common/index.dart';
import 'package:jobprogress/translations/en_US/core/constant/duration_type/index.dart';
import 'package:jobprogress/translations/en_US/core/utils/updgrade_plan_helper/index.dart';
import 'package:jobprogress/translations/en_US/global_widget/QuickBookError/index.dart';
import 'package:jobprogress/translations/en_US/global_widget/custom_date_dialog/index.dart';
import 'package:jobprogress/translations/en_US/global_widget/day_count_down_tile/index.dart';
import 'package:jobprogress/translations/en_US/global_widget/division_unmatch_dialog/index.dart';
import 'package:jobprogress/translations/en_US/global_widget/recurring_bottom_sheet/index.dart';
import 'package:jobprogress/translations/en_US/global_widget/share_via_text/index.dart';
import 'package:jobprogress/translations/en_US/messages/confirmation.dart';
import 'package:jobprogress/translations/en_US/messages/error.dart';
import 'package:jobprogress/translations/en_US/messages/validation.dart';
import 'package:jobprogress/translations/en_US/pages/appointment/index.dart';
import 'package:jobprogress/translations/en_US/pages/automation/index.dart';
import 'package:jobprogress/translations/en_US/pages/calendars/index.dart';
import 'package:jobprogress/translations/en_US/pages/call_log/index.dart';
import 'package:jobprogress/translations/en_US/pages/chats/index.dart';
import 'package:jobprogress/translations/en_US/pages/clock_summary/index.dart';
import 'package:jobprogress/translations/en_US/pages/contacts_view/index.dart';
import 'package:jobprogress/translations/en_US/pages/drawing_tool/index.dart';
import 'package:jobprogress/translations/en_US/pages/cutomer_job_search/index.dart';
import 'package:jobprogress/translations/en_US/pages/daily_plan/index.dart';
import 'package:jobprogress/translations/en_US/pages/email/index.dart';
import 'package:jobprogress/translations/en_US/pages/email_template/index.dart';
import 'package:jobprogress/translations/en_US/pages/files_listing/index.dart';
import 'package:jobprogress/translations/en_US/pages/forgot_password/index.dart';
import 'package:jobprogress/translations/en_US/pages/job/index.dart';
import 'package:jobprogress/translations/en_US/pages/follow_ups_notes/index.dart';
import 'package:jobprogress/translations/en_US/pages/job_financial/index.dart';
import 'package:jobprogress/translations/en_US/pages/job_notes/index.dart';
import 'package:jobprogress/translations/en_US/pages/login/index.dart';
import 'package:jobprogress/translations/en_US/pages/company_contact_listing/index.dart';
import 'package:jobprogress/translations/en_US/pages/my_profile/index.dart';
import 'package:jobprogress/translations/en_US/pages/project/index.dart';
import 'package:jobprogress/translations/en_US/pages/schedules/schedules.dart';
import 'package:jobprogress/translations/en_US/pages/snippets/index.dart';
import 'package:jobprogress/translations/en_US/pages/task/index.dart';
import 'package:jobprogress/translations/en_US/pages/notification/index.dart';
import 'package:jobprogress/translations/en_US/pages/third_party_tools/index.dart';
import 'package:jobprogress/translations/en_US/recent_jobs/index.dart';
import 'package:jobprogress/translations/en_US/schedule/details/index.dart';
import 'package:jobprogress/translations/en_US/task_detail/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'global_widget/consent_form/index.dart';
import 'global_widget/main_drawer/index.dart';
import 'global_widget/search_location/index.dart';
import 'pages/confirm_consent/index.dart';
import 'pages/home/index.dart';
import 'pages/local_db_settings/index.dart';
import 'pages/profit_loss_summary/inde.dart';
import 'pages/progress_board/index.dart';
import 'pages/settings/index.dart';
import 'pages/uploads/index.dart';
import 'pages/work_crew_note/index.dart';
import 'pages/customer_listing/index.dart';

class EnUsTranslationStrings {
  static Map<String, String> allStrings = {
    ...EnUsErrorMessageTranslations.strings,
    ...EnUsValidationMessageTranslations.strings,
    ...EnUsTaskMessageTranslations.strings,
    ...EnUsCompanyContactListingMessageTranslations.strings,
    ...EnUsMainDrawerTranslations.strings,
    ...EnUsCustomDialogTranslations.strings,
    ...EnUsConsentFormTranslations.strings,
    ...EnUsLoginTranslations.strings,
    ...EnUsHomeTranslations.strings,
    ...EnUsSnippetMessageTranslations.strings,
    ...EnUsJPTaskDetailBottomSheetTranslations.strings,
    ...EnUsConfirmatioMessageTranslations.strings,
    ...EnUsFilesListingTranslation.strings,
    ...EnUsCompanyContactViewMessageTranslations.strings,
    ...EnUsCommonTranslations.strings,
    ...EnUsCustomerMessageTranslations.strings,
    ...EnUsRecentJobsTranslations.strings,
    ...EnUsEmailTranslations.strings,
    ...EnUsSchedulesTranslations.strings,
    ...EnUsClockSummaryTranslations.strings,
    ...EnUsWorkCrewNotesTranslations.strings,
    ...EnUsJobNoteTranslations.strings,
    ...EnUsDrawingToolTranslations.strings,
    ...EnUsUploadsTranslations.strings,
    ...EnUsJobNoteTranslations.strings,
    ...EnUsJobMessageTranslations.strings,
    ...EnUsProjectTranslations.strings,
    ...EnUsCallLogMessageTranslations.strings,
    ...EnUsJPScheduleDetailTranslations.strings,
    ...EnUsFollowUpsNotesTranslations.strings,
    ...EnUsJobFinancialTranslations.strings,
    ...EnUsDailyPlanTranslations.strings,
    ...EnUsCustomerJobSearchMessageTranslations.strings,
    ...EnUsDurationTypeConstantsTranslations.strings,
    ...EnUsAppointmentTranslations.strings,
    ...EnUsNotificationsTranslations.strings,
    ...EnUsQuickBookErrorTranslations.strings,
    ...EnUsMyProfileTranslations.strings,
    ...EnUsThirdPartyToolsTranslations.strings,
    ...EnUsProfitLossSummaryMessageTranslations.strings,
    ...EnUsCalendarMessageTranslations.strings,
    ...EnUsLocalDBSettingsTranslations.strings,
    ...EnUsRecurringBottomSheetTranslations.strings,
    ...EnUsShareViaTextTranslations.strings,
    ...EnUsChatsTranslations.strings,
    ...EnUsProgressBoardTranslations.strings,
    ...EnUsSettingsTranslations.strings,
    ...EnUsDivisionUnMatchTranslations.strings,
    ...EnUsJPCollapsibleMapViewTranslations.strings,
    ...EnUsForgotPasswordTranslations.strings,
    ...EnUsEmailTemplateListingTranslation.strings,
    ...EnUsConfirmConsentMessageTranslations.strings,
    ...EnUsDayCountDownTranslations.strings,
    ...EnUsUpgradePlanHelperTranslations.strings,
    ...EnUsAutomationTranslations.strings,
    ...UiKitEnUS.translations,
  };
}
