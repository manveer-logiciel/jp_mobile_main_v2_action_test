import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:launchdarkly_flutter_client_sdk/launchdarkly_flutter_client_sdk.dart';
import 'flag_model.dart';

/// [LDFlags] holds all the flags defined in Launch Darkly
/// so they can be handled in application accordingly
class LDFlags {

  /// [allFlags] contains all the flags in a Map<> making it to
  /// access any flag in no time
  /// Example:
  /// 1. LDFlags.allFlags[LDFlagKeyConstants.testStaffCalendar]?.value
  ///   - Will give the value of the flag [LDFlagKeyConstants.testStaffCalendar] if it is defined in Launch Darkly
  /// 2. LDFlags.allFlags[LDFlagKeyConstants.testStaffCalendar]
  ///   - Will give the entire flag details
  static Map<String, LDFlagModel> allFlags = {
    LDFlagKeyConstants.testStaffCalendar: testStaffCalendar,
    LDFlagKeyConstants.testStaffCalendarButtonText: testStaffCalendarButtonText,
    LDFlagKeyConstants.transactionalMessaging: transactionalMessaging,
    LDFlagKeyConstants.metroBathFeature: metroBathFeature,
    LDFlagKeyConstants.userLocationTracking: userLocationTracking,
    LDFlagKeyConstants.userLocationsTrackingPollingInterval: userLocationsTrackingPollingInterval,
    LDFlagKeyConstants.srsV2MaterialIntegration: srsV2MaterialIntegration,
    LDFlagKeyConstants.salesProForEstimate: salesProForEstimate,
    LDFlagKeyConstants.abcMaterialIntegration: abcMaterialIntegration,
    LDFlagKeyConstants.leapPayFeePassOver: leapPayFeePassOver,
    LDFlagKeyConstants.leapPayWithDivision: leapPayWithDivision,
    LDFlagKeyConstants.jobCanvaser: jobCanvaser,
    LDFlagKeyConstants.workflowAutomationLogs: workflowAutomationLogs,
    LDFlagKeyConstants.allowMultipleLanguages: allowMultipleLanguages,
    LDFlagKeyConstants.enableLargerUploadSize: enableLargerUploadSize,
    LDFlagKeyConstants.useMobileMapsSdk: useMobileMapsSdk,
    LDFlagKeyConstants.allowTextSelection: allowTextSelection,
    LDFlagKeyConstants.divisionBasedMultiWorkflows: divisionBasedMultiWorkflows,
    LDFlagKeyConstants.leappayPaymentFeePassoverToggle: leappayPaymentFeePassoverToggle,
    LDFlagKeyConstants.optimizeAppStorageUsage: optimizeIosStorageUsage,
    LDFlagKeyConstants.workflowJobStageGrouping: workflowJobStageGrouping,
    LDFlagKeyConstants.textNotificationsAutomation: textNotificationsAutomation,
  };

  /// NOTE: This is an example flag
  /// [testStaffCalendar] flags helps in show/hide staff calendar button in demo page
  static LDFlagModel testStaffCalendar = LDFlagModel(
    key: LDFlagKeyConstants.testStaffCalendar,
    type: LDValueType.boolean,
    defaultValue: false,
  );

  /// NOTE: This is an example flag
  /// [testStaffCalendar] flags helps in updating text of staff calendar button in demo page
  static LDFlagModel testStaffCalendarButtonText = LDFlagModel(
    key: LDFlagKeyConstants.testStaffCalendarButtonText,
    type: LDValueType.string,
    defaultValue: 'DEFAULT VALUE',
  );

  /// [transactionalMessaging] flags helps in enable
  static LDFlagModel transactionalMessaging = LDFlagModel(
    key: LDFlagKeyConstants.transactionalMessaging,
    type: LDValueType.boolean,
    defaultValue: false,
  );

  /// [userLocationTracking] is responsible for completely enabling/disabling
  /// location tracking in both foreground and background
  static LDFlagModel userLocationTracking = LDFlagModel(
    key: LDFlagKeyConstants.userLocationTracking,
    type: LDValueType.boolean,
    defaultValue: false,
  );

  /// NOTE: This is an example flag
  /// [metroBathFeature] flags helps in show/hide Transactional Messaging button in demo page
  static LDFlagModel metroBathFeature = LDFlagModel(
    key: LDFlagKeyConstants.metroBathFeature,
    type: LDValueType.boolean,
    defaultValue: true,
  );
  
  /// [userLocationsTrackingPollingInterval] is responsible for setting the
  /// interval after which user location will be sent to server
  static LDFlagModel userLocationsTrackingPollingInterval = LDFlagModel(
    key: LDFlagKeyConstants.userLocationsTrackingPollingInterval,
    type: LDValueType.number,
    defaultValue: 15,
  );

  /// [srsV2MaterialIntegration] flags helps in show/hide SRS v2 button in demo page
  static LDFlagModel srsV2MaterialIntegration = LDFlagModel(
    key: LDFlagKeyConstants.srsV2MaterialIntegration,
    type: LDValueType.boolean,
    defaultValue: false,
  );

  /// [salesProForEstimate] is responsible for enabling/disabling the functionality
  /// for sales pro estimates with in LEAP
  static LDFlagModel salesProForEstimate = LDFlagModel(
    key: LDFlagKeyConstants.salesProForEstimate,
    type: LDValueType.boolean,
    defaultValue: false,
  );

  /// [abc] is responsible for enabling/disabling the functionality
  static LDFlagModel abcMaterialIntegration = LDFlagModel(
    key: LDFlagKeyConstants.abcMaterialIntegration,
    type: LDValueType.boolean,
    defaultValue: false,
  );

  static LDFlagModel leapPayFeePassOver = LDFlagModel(
    key: LDFlagKeyConstants.leapPayFeePassOver,
    type: LDValueType.boolean,
    defaultValue: false,
  );

  static LDFlagModel leapPayWithDivision = LDFlagModel(
    key: LDFlagKeyConstants.leapPayWithDivision,
    type: LDValueType.boolean,
    defaultValue: false,
  );

  /// [jobCanvaser] is responsible for enabling/disabling the functionality
  static LDFlagModel jobCanvaser = LDFlagModel(
    key: LDFlagKeyConstants.jobCanvaser,
    type: LDValueType.boolean,
    defaultValue: false,
  );

  /// [workflowAutomationLogs] is responsible for enabling/disabling the functionality
  static LDFlagModel workflowAutomationLogs = LDFlagModel(
    key: LDFlagKeyConstants.workflowAutomationLogs,
    type: LDValueType.boolean,
    defaultValue: false,
  );

  /// [allowMultipleLanguages] is responsible for enabling/disabling the functionality
  /// for users to select different languages in the app
  static LDFlagModel allowMultipleLanguages = LDFlagModel(
    key: LDFlagKeyConstants.allowMultipleLanguages,
    type: LDValueType.boolean,
    defaultValue: false,
  );

  /// [enableLargerUploadSize] is responsible for enabling/disabling larger upload size feature
  static LDFlagModel enableLargerUploadSize = LDFlagModel(
    key: LDFlagKeyConstants.enableLargerUploadSize,
    type: LDValueType.boolean,
    defaultValue: false,
  );

  /// [useMobileMapsSdk] is responsible for switching between HTTP API and native SDK
  /// for Google Maps/Places functionality. When true, uses native SDK (for mobile app restrictions).
  /// When false, uses HTTP API (for HTTP referrer restrictions).
  static LDFlagModel useMobileMapsSdk = LDFlagModel(
    key: LDFlagKeyConstants.useMobileMapsSdk,
    type: LDValueType.boolean,
    defaultValue: true,
  );

  /// [allowTextSelection] is responsible for enabling/disabling text selection
  /// across all JPRichText and JPText components in the app
  static LDFlagModel allowTextSelection = LDFlagModel(
    key: LDFlagKeyConstants.allowTextSelection,
    type: LDValueType.boolean,
    defaultValue: false,
  );

  /// [divisionBasedMultiWorkflows] is responsible for enabling/disabling the division-based
  /// multi-workflow feature that allows workflow stage updates when job division changes
  static LDFlagModel divisionBasedMultiWorkflows = LDFlagModel(
    key: LDFlagKeyConstants.divisionBasedMultiWorkflows,
    type: LDValueType.boolean,
    defaultValue: false,
  );

  /// [leappayPaymentFeePassoverToggle] is responsible for enabling/disabling the fee passover toggle in payment form
  static LDFlagModel leappayPaymentFeePassoverToggle = LDFlagModel(
    key: LDFlagKeyConstants.leappayPaymentFeePassoverToggle,
    type: LDValueType.boolean,
    defaultValue: false,
  );

  /// [optimizeIosStorageUsage] is responsible for enabling/disabling automatic cache
  /// and uploads clearing when cookies are renewed on iOS to optimize storage usage
  static LDFlagModel optimizeIosStorageUsage = LDFlagModel(
    key: LDFlagKeyConstants.optimizeAppStorageUsage,
    type: LDValueType.boolean,
    defaultValue: false,
  );

  /// [workflowJobStageGrouping] is responsible for enabling/disabling the workflow
  /// job stage grouping feature that shows stages in hierarchical groups
  static LDFlagModel workflowJobStageGrouping = LDFlagModel(
    key: LDFlagKeyConstants.workflowJobStageGrouping,
    type: LDValueType.boolean,
    defaultValue: false,
  );

  /// [textNotificationsAutomation] is responsible for enabling/disabling the text automation
  /// filter feature that allows filtering between conversation and automated texts
  static LDFlagModel textNotificationsAutomation = LDFlagModel(
    key: LDFlagKeyConstants.textNotificationsAutomation,
    type: LDValueType.boolean,
    defaultValue: false,
  );
}