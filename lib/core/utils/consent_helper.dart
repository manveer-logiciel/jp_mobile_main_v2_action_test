import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/twilio_text_status.dart';
import 'package:jobprogress/common/models/consent_status/consent_label_details_model.dart';
import 'package:jobprogress/common/models/consent_status/consent_status_params.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/models/phone_consents.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/repositories/consent.dart';
import 'package:jobprogress/common/repositories/sql/user.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/connectivity.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/consent_status_constants.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/consent_status/widgets/transactional_consent_status/badge_info.dart';
import 'package:jobprogress/global_widgets/customer_consent_form/index.dart';
import 'package:jobprogress/global_widgets/opted_out_dialog_box/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ConsentHelper {

  static TwilioTextStatus? lastTwilioTextStatus;
  static UserModel? lastSoleProprietorUser;
  static String? textingEnabledUserId;

  static Future<dynamic> openConsentFormDialog({
    String? email,
    List<String?>? additionalEmails,
    String? previousEmail,
    String? phoneNumber,
    int? customerId,
    int? contactPersonId,
    VoidCallback? updateScreen,
    String? obtainedConsent,
  }) async {
    List<String?>? emailList = [];
    if(!Helper.isValueNullOrEmpty(additionalEmails)){
      emailList.addAll(additionalEmails ?? []);
    }
    if(!Helper.isValueNullOrEmpty(email)){
      emailList.insert(0,email);
    }

    // loading sole proprietor user if active user can't send text messages
    await ConsentHelper.setSoleProprietorUser();

   return await showJPGeneralDialog(
      isDismissible: false,
      child: (dialogController) {
        return AbsorbPointer(
          absorbing: dialogController.isLoading,
          child:  ConsentFormDialog(
            previousEmail: previousEmail,
            emails: emailList,
            phoneNumber: phoneNumber,
            customerId: customerId,
            updateScreen: updateScreen,
            obtainedConsent: obtainedConsent,
          ),
        );
      }
    );
  }

  static bool isContactPersonSameAsCustomer(JobModel? jobModel) {
    if(jobModel != null) {
      return jobModel.isContactSameAsCustomer ?? false;
    }
    return true;
  }

  static PhoneModel? getSelectedContactInfo(List<PhoneModel> phoneList, String phoneNumber) {
    phoneNumber = PhoneMasking.unmaskPhoneNumber(phoneNumber);
    
    for (PhoneModel phone in phoneList) {
      if(phone.number == phoneNumber){
        return phone;
      }
    }
    return null;
  }

  static bool isStatusResendStatus(String? status, String? createdAt){
    DateTime currentTime = DateTime.now();
    Duration difference = currentTime.difference(DateTime.parse(createdAt ?? currentTime.toString()));
    switch (status) {
      case ConsentStatusConstants.pending:
      case ConsentStatusConstants.expressOptInPending:
        return difference.inHours >= 48;
      default:
        return false;
    }
  }

  static void openOptedOutDialog() {
    showJPGeneralDialog(
      isDismissible: false,
      child: (dialogController) {
        return AbsorbPointer(
          absorbing: dialogController.isLoading,
          child:  const OptedOutDialogBox()          
        );
      }
    );
  }

  /// [isTwilioTextingEnabled] Checks if Twilio texting is enabled.
  /// Returns `true` if Twilio texting is enabled, `false` otherwise.
  static bool isTwilioTextingEnabled() {
      // Get the value of the company setting for enabling Twilio testing setup
      final val = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.enableTwilioTestingSetup);
      // Convert the value to a boolean using the `Helper.isTrue` function
      return Helper.isTrue(val);
  }

  /// [canActiveUserSendConsent] Checks if the active user can send consent.
  /// Returns `true` if the active user can send consent, `false` otherwise.
  static bool canActiveUserSendConsent() {
    // Get the Twilio text settings from the company settings
    final val = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.twillioTextSettings);
    // Check if the active user is a sole proprietor
    bool isSoleProprietor = val is Map && Helper.isTrue(val['sole_proprietor']);
    if (isSoleProprietor) {
      // Get the texting enabled user ID for sole proprietor
      textingEnabledUserId = val['texting_enabled_user'];
      // Check if the active user is the sole proprietor
      bool isActiveUserSoleProprietor = textingEnabledUserId == AuthService.userDetails?.id.toString();
      return isActiveUserSoleProprietor;
    }
    // Return `true` if the active user is not a sole proprietor
    // or sole proprietor is not enabled
    return true;
  }

  /// [setSoleProprietorUser] Sets the sole proprietor user.
   static Future<void> setSoleProprietorUser() async {
      // Check if the active user can send consent
      // If yes, simply returning without searching for 
      // user details having permission to send consent
      if (canActiveUserSendConsent()) return;
      // Check if the sole proprietor user has already been loaded
      // No need to load it again and over
      // Only loading sole proprietor user if its ID is changed
      bool isSoleProprietorAlreadyLoaded = textingEnabledUserId == lastSoleProprietorUser?.id.toString();
      if (isSoleProprietorAlreadyLoaded) return;
      // retrieve the user from the local DB
      if (!Helper.isValueNullOrEmpty(textingEnabledUserId)) {
        lastSoleProprietorUser = await SqlUserRepository().getOne(int.parse(textingEnabledUserId!));
      } else {
        // clearing sole proprietor user
        lastSoleProprietorUser = null;
      }
  }

  /// Sends a support email.
  ///
  /// This method launches the email application with the support email address pre-filled.
  static void sendSupportEmail() {
      Helper.launchEmail(ConsentStatusConstants.supportEmail);
  }

  /// [getTwilioTextStatus] Retrieves the Twilio text status.
  ///
  /// Returns the [TwilioTextStatus] of the Twilio text service.
  /// If there is no internet connection, returns [TwilioTextStatus.unknown].
  static Future<TwilioTextStatus?> getTwilioTextStatus() async {
      if (!ConnectivityService.isInternetConnected) return TwilioTextStatus.unknown;

      try {
        TwilioTextStatus status;
        if (!isTwilioTextingEnabled()) {
          // Twilio texting is disabled
          status = TwilioTextStatus.disabled;
        } else {
          bool isBrandCampaignVerified = await checkBrandCampaignVerification();
          if (isBrandCampaignVerified) {
            // Checking whether user can send consent otherwise
            // setting sole proprietor user
            if (canActiveUserSendConsent()) {
              // Twilio texting is enabled
              status = TwilioTextStatus.enabled;
            } else {
              await setSoleProprietorUser();
              status = TwilioTextStatus.notPermitted;
            }
          } else {
            // Twilio verification is in progress
            status = TwilioTextStatus.inProgress;
          }
        }
        // Setting the last know text service status
        lastTwilioTextStatus = status;
        return status;
      } catch (e) {
        return TwilioTextStatus.unknown;
      }
  }

  /// [checkBrandCampaignVerification] Checks the Twilio verification status.
  ///
  /// Returns `true` if the Twilio status is 'VERIFIED', otherwise returns `false`.
  static Future<bool> checkBrandCampaignVerification() async {
    try {
      final result = await ConsentRepository.getTwilioStatus();
      return result.brandCampaignStatus == 'VERIFIED';
    } catch (e) {
      rethrow;
    }
  }

  /// [setTwilioTextStatus] Sets the Twilio text status.
  ///
  /// This method retrieves the Twilio text status and assigns it to the [lastTwilioTextStatus] variable.
  /// If an error occurs during the retrieval process, the error is rethrown.
  static Future<void> setTwilioTextStatus() async {
    try {
      lastTwilioTextStatus = await getTwilioTextStatus();
    } catch (e) {
      rethrow;
    }
  }

  /// [clearLastTextStatus] Clears the last text status.
  static void clearLastTextStatus() {
      lastTwilioTextStatus = null;
      lastSoleProprietorUser = null;
      textingEnabledUserId = null;
  }

  /// [getConsentDetails] Gets the consent details based on the status in
  /// the form of [ConsentLabelDetailsModel] that can be used to display data in
  /// the UI.
  static ConsentLabelDetailsModel? getConsentDetails(String? status) {
    switch (status) {
      case ConsentStatusConstants.expressConsent:
        return ConsentLabelDetailsModel(
            color: JPAppTheme.themeColors.success,
          icon: Icons.sms,
          label: 'express_consent',
          toolTip: 'express_consent_tooltip',
          composeLabel: 'express_consent_compose_label',
          composeMessage: 'express_consent_compose_message'
        );

      case ConsentStatusConstants.expressOptInPending:
        return ConsentLabelDetailsModel(
          color: JPAppTheme.themeColors.tertiary,
          icon: Icons.access_time_filled,
          label: 'express_consent_opt_in_pending',
          toolTip: 'express_consent_opt_in_pending_tooltip',
          composeLabel: 'express_consent_opt_in_pending_compose_label',
          composeMessage: 'express_consent_opt_in_pending_compose_message'
        );

      case ConsentStatusConstants.pendingConsent:
        return ConsentLabelDetailsModel(
          color: JPAppTheme.themeColors.tertiary,
          icon: Icons.access_time_filled,
          label:'consent_pending',
          toolTip: 'consent_pending_tooltip',
          composeLabel: 'consent_pending_compose_label',
          composeMessage: 'consent_pending_compose_message'
        );

      case ConsentStatusConstants.optedIn:
        return ConsentLabelDetailsModel(
          color: JPAppTheme.themeColors.success,
            icon: Icons.sms,
          label:'express_written_consent',
          toolTip: 'express_written_consent_tooltip',
          composeLabel: 'express_written_consent_compose_label',
          composeMessage: 'express_written_consent_compose_message'
        );

      case ConsentStatusConstants.noMessage:
        return ConsentLabelDetailsModel(
          color: JPAppTheme.themeColors.warning,
          icon: Icons.sms,
          label:'no_consent_obtained',
          toolTip: 'no_consent_obtained_tooltip',
          composeLabel: 'no_consent_obtained_compose_label',
          composeMessage: 'no_consent_obtained_compose_message',
        );

      case ConsentStatusConstants.optedOut:
        return ConsentLabelDetailsModel(
          color: JPAppTheme.themeColors.red,
          icon: Icons.do_not_disturb_on,
          label:'consent_denied',
          toolTip: 'consent_denied_tooltip',
          composeLabel: 'consent_denied_compose_label',
          composeMessage: 'consent_denied_compose_message'
        );

      case ConsentStatusConstants.resend:
        return ConsentLabelDetailsModel(
            color: JPAppTheme.themeColors.warning,
            icon: Icons.access_time_filled,
            label:'consent_pending',
            toolTip: 'consent_pending_tooltip',
            composeLabel: 'consent_pending_compose_label',
            composeMessage: 'consent_pending_compose_message',
            composeMessageButtonText: 'resend_consent',
            composeMessageButtonColor: JPButtonColorType.primary,
            composeMessageButtonTextColor: JPAppTheme.themeColors.base
        );

      case ConsentStatusConstants.byPass:
        return ConsentLabelDetailsModel(
            color: JPAppTheme.themeColors.success,
            icon: Icons.sms,
            label: 'express_consent',
            toolTip: 'bypass_tooltip',
            composeLabel: 'bypass_compose_label',
            composeMessage: 'bypass_tooltip');

      default:
        return ConsentLabelDetailsModel(
            color: JPAppTheme.themeColors.tertiary,
            icon: Icons.edit,
          label:'confirm_consent',
          toolTip: 'no_consent_obtained_tooltip',
          composeLabel: 'no_consent_obtained_compose_label',
          composeMessage: 'no_consent_obtained_compose_message',
          composeMessageButtonText: 'confirm_consent',
          composeMessageButtonColor: JPButtonColorType.primary,
          composeMessageButtonTextColor: JPAppTheme.themeColors.base
        );
    }
  }

  /// [isTransactionalConsent] helps in deciding which consent functionality is to
  /// be executed, It also helps in managing UI as well as logics
  static bool isTransactionalConsent() {
    return LDService.hasFeatureEnabled(LDFlagKeyConstants.transactionalMessaging);
  }

  /// [showConsentBadgeInfo] helps in displaying the consent details on tap of consent badge
  ///
  /// This method shows a bottom sheet with consent details when a user taps on the consent
  /// badge. It now supports updating consent directly from the tooltip.
  ///
  /// [details] - The consent label details to display
  /// [params] - Optional ConsentStatusParams that allows updating consent from within the tooltip
  static void showConsentBadgeInfo(ConsentLabelDetailsModel details, {
    ConsentStatusParams? params
  }) {
    params?.setToolTip(true);
    showJPBottomSheet(
      child: (_) => TransactionalConsentBadgeInfo(
        consentDetails: details,
        params: params,
      ),
      ignoreSafeArea: false
    );
  }

  /// [navigateToObtainConsent] opens the consent form for obtaining consent
  static Future<void> navigateToObtainConsent(ConsentStatusParams? params) async {
    if (params?.phoneConsentDetail?.consentStatus == ConsentStatusConstants.resend) {
      return ConsentHelper.resendConsent(params);
    }
    String consent = getConsentStatus(params?.phoneConsentDetail?.consentStatus);

    var result = await Get.toNamed(Routes.confirmConsent, arguments: {
      NavigationParams.phone: params?.phoneConsentDetail,
      NavigationParams.customer: params?.customer,
      NavigationParams.contactPerson: params?.contact,
      NavigationParams.jobModel: params?.job,
      NavigationParams.consentStatusConstants: consent,
      NavigationParams.consentStatusParams: params,
    }, preventDuplicates: false);
    // Updating the consent status of the badge and banner
    if(result is PhoneConsentModel && !Helper.isValueNullOrEmpty(result.status)) {
      if (Helper.isTrue(params?.isToolTip)) {
        Get.back();
      }
      
      params?.phoneConsentDetail?.consentStatus = result.status;
      params?.onConsentChanged?.call(result.status!);
      params?.updateConsentStatus();
    }
  }

  static String getConsentStatus(String? consentStatus) {
    switch(consentStatus) {
      case ConsentStatusConstants.expressOptInPending:
      case ConsentStatusConstants.optedIn:
      case ConsentStatusConstants.optedOut:
        return ConsentStatusConstants.promotionalMessage;
      case ConsentStatusConstants.expressConsent:
      case ConsentStatusConstants.byPass:
        return ConsentStatusConstants.transactionalMessage;
      case ConsentStatusConstants.noMessage:
        return ConsentStatusConstants.noMessage;
      default:
        return "";
    }
  }

  /// [resendConsent] opens up the consent form for resending the consent
  static Future<void> resendConsent(ConsentStatusParams? params) async {
    final emails = params?.getEmails() ?? [];
    final additionalEmails = emails.length > 1 ? emails.sublist(1) : <String>[];
    final result = await ConsentHelper.openConsentFormDialog(
      email: emails.firstOrNull,
      additionalEmails: additionalEmails,
      phoneNumber: params?.phoneConsentDetail?.number,
      customerId: params?.customerId,
      contactPersonId: params?.contactPersonId,
      updateScreen: params?.updateScreen,
    );
    // Updating the consent status of the badge and banner
    if(result is PhoneConsentModel && !Helper.isValueNullOrEmpty(result.status)) {
      params?.phoneConsentDetail?.consentStatus = result.status;
      params?.onConsentChanged?.call(result.status!);
      params?.updateConsentStatus();
    }
  }
}
  