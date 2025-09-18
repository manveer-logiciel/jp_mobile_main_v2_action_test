class LDFlagKeyConstants {
  static const testStaffCalendar = 'staff-calendar';
  static const testStaffCalendarButtonText = 'staff-calendar-button-text';
  static const testAppointmentFlag = 'flutter-appointment-flag-test';
  static const transactionalMessaging = 'transactional-messaging';
  static const metroBathFeature = 'metro-bath';
  /// [userLocationTracking] is responsible for completely enabling/disabling location
  /// tracking in both foreground and background
  static const userLocationTracking = 'user-location-tracking';

  /// [userLocationsTrackingPollingInterval] is responsible for setting the interval after which
  /// user location will be sent to server
  static const userLocationsTrackingPollingInterval = 'user-location-tracking-polling-interval';
  static const srsV2MaterialIntegration = 'srs-v2-material-integration';

  /// [userLocationsTrackingPollingInterval] is responsible for enabling/disabling the functionality
  /// for sales pro estimates with in LEAP
  static const salesProForEstimate = 'sales-pro-for-estimate';
  static const abcMaterialIntegration = 'abc-material-integration';
  static const leapPayFeePassOver = 'leap-pay-fee-passover';
  static const jobCanvaser = 'job-canvaser';
  static const workflowAutomationLogs = 'workflow-automation-logs';
  static const leapPayWithDivision = 'leap-pay-with-divisions';

  /// [allowMultipleLanguages] is responsible for enabling/disabling the functionality
  /// for users to select different languages in the app
  static const allowMultipleLanguages = 'allow-multiple-language';

  /// [enableLargerUploadSize] is responsible for enabling/disabling larger upload size feature
  static const enableLargerUploadSize = 'enable-larger-upload-size';

  /// [useMobileMapsSdk] is responsible for switching between HTTP API and native SDK
  /// for Google Maps/Places functionality. When true, uses native SDK (for mobile app restrictions).
  /// When false, uses HTTP API (for HTTP referrer restrictions).
  static const useMobileMapsSdk = 'use-mobile-maps-sdk';

  /// [allowTextSelection] is responsible for enabling/disabling text selection
  /// across all JPRichText and JPText components in the app
  static const allowTextSelection = 'allow-text-selection';

  /// [divisionBasedMultiWorkflows] is responsible for enabling/disabling the division-based
  /// multi-workflow feature that allows workflow stage updates when job division changes
  static const divisionBasedMultiWorkflows = 'division-based-multi-workflows';

  ////This flag will handle hide show of fee passover toggle in payment form
  static const leappayPaymentFeePassoverToggle = 'leappay-payment-fee-passover-toggle';

  /// [optimizeAppStorageUsage] is responsible for enabling/disabling automatic cache
  /// and uploads clearing when cookies are renewed on iOS to optimize storage usage
  static const optimizeAppStorageUsage = 'optimize-app-storage-usage';

  /// [workflowJobStageGrouping] is responsible for enabling/disabling the workflow
  /// job stage grouping feature that shows stages in hierarchical groups
  static const workflowJobStageGrouping = 'workflow-job-stage-grouping';

  /// [textNotificationsAutomation] is responsible for enabling/disabling the text automation
  /// filter feature that allows filtering between conversation and automated texts
  static const textNotificationsAutomation = 'text-notifications-automation';
}