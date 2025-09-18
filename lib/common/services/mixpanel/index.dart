import 'package:jobprogress/common/models/mix_panel/index.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/mixpanel/view_observer.dart';
import 'package:jobprogress/core/config/app_env.dart';
import 'package:jobprogress/core/constants/mix_panel/index.dart';
import 'package:jobprogress/core/utils/mix_panel_helper/index.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixPanelService {

  /// [mixpanel] holds mix-panel instance to perform other actions
  static Mixpanel? mixpanel;

  /// [token] is unique identifier of mix-panel project
  static String token = AppEnv.config[MixPanelConstants.mixPanelTokenKey];

  /// [analyticsEnabled] helps is deciding whether events should be tracked or not
  static bool analyticsEnabled = AppEnv.config[MixPanelConstants.mixPanelAnalyticsEnabledKey] ?? false;

  /// [init] helps is setting up mix-panel (when app starts)
  static Future<void> init() async {

    if(!analyticsEnabled) return;

    try {
      mixpanel = await Mixpanel.init(
        token,
        optOutTrackingDefault: false,
        trackAutomaticEvents: true, // provides events like (Session Start, Session End, App Crash Etc.)
      );
    } catch (e) {
      rethrow;
    }
  }

  /// [setUser] helps in setting up current user info, helps in establishing a
  /// relation between events and users. (when user log-in)
  static void setUser() async {

    if(!analyticsEnabled || mixpanel == null) return;

    final user = AuthService.userDetails!;

    mixpanel!.identify(user.id.toString()); // setting up unique identity of user

    mixpanel!.getPeople()
      ..set(MixPanelConstants.name, user.fullName)
      ..set(MixPanelConstants.email, user.email)
      ..set(MixPanelConstants.firstName, user.firstName)
      ..set(MixPanelConstants.lastName, user.lastName ?? "");
  }

  /// [trackEvent] helps in tracking events (when app is running)
  /// As of mix panel documentation events can take up to 1 min. to reflect on
  /// mix-panel console
  static void trackEvent({required MixPanelModel event}) async {

    if(!analyticsEnabled || mixpanel == null) return;

    event.path = MixPanelViewObserver.formattedPath;

    mixpanel?.track(
      event.title,
      properties: MixPanelHelper.getEventProperties(event.action),
    );
  }

  /// [dispose] helps in clearing mix-panel default set-up eg. user info
  /// (when user log-out)
  static void dispose() async {

    if(!analyticsEnabled || mixpanel == null) return;

    mixpanel?.reset();
  }
}
