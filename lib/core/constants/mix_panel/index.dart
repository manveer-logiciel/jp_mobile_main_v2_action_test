
class MixPanelConstants {

  /// [mixPanelTokenKey] helps in easily getting token from env-config
  static const String mixPanelTokenKey = 'MIX_PANEL_TOKEN';

  /// [mixPanelAnalyticsEnabledKey] helps in easily getting analytics-enabled from env-config
  static const String mixPanelAnalyticsEnabledKey = 'ANALYTICS_ENABLED';

  /// [name] used to store name of current user on mix panel
  static const String name = '\$name';

  /// [email] used to store email of current user on mix panel
  static const String email = '\$email';

  /// [firstName] used to store first-name of current user on mix panel
  static const String firstName = '\$first_name';

  /// [firstName] used to store first-name of current user on mix panel
  static const String lastName = '\$last_name';

  /// [propActionType] is a custom-property used to store action as additional data
  static const String propActionType = "Action Type";

  /// [propPath] is a custom-property used to store route-path as additional data
  static const String propPath = "Path";

  /// [propCompanyId] is a custom-property used to store company-id as additional data
  static const String propCompanyId = "Company ID";

  /// [propJPUserId] is a custom-property used to store user-id as additional data
  static const String propJPUserId = "JP User ID";

  /// Name of actions that can help in analytics
  static const String actionView = 'view';
  static const String actionAdd = 'add';
  static const String actionArchive = 'archive';
  static const String actionDelete = 'delete';
  static const String actionEdit = 'edit';
  static const String actionFilter = 'filter';
  static const String actionPrint = 'print';
  static const String actionReorder = 'reorder';
  static const String actionUpdate = 'update';
  static const String actionSwitch = 'switch';

}