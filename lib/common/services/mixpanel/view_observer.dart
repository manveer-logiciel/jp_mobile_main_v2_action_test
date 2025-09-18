import 'package:get/get.dart';
import 'package:jobprogress/common/models/mix_panel/index.dart';
import 'package:jobprogress/common/services/firebase_crashlytics.dart';
import 'package:jobprogress/core/utils/mix_panel_helper/index.dart';
import 'index.dart';

/// [MixPanelViewObserver] helps in tracking all view level events at root level
class MixPanelViewObserver {

  // used to store current path
  static String currentPath = "";

  // used to store current path along with additional data
  static String formattedPath = "";

  // holds title of the page so, some of events like (filter, edit) can be manage with page title easily
  static String currentPathName = "";

  static String? pathArguments;

  static void observe(Routing? routing) {

    // if routing is null no need to observe
    if(routing == null || (routing.current == currentPath) || routing.isBottomSheet! || routing.isDialog!) return;

    MixPanelModel event = MixPanelHelper.getViewEvent(routing);

    if(event.path == currentPath) return;

    currentPath = event.path;
    pathArguments = event.arguments;
    formattedPath = "${event.path}${(event.arguments ?? "")}";
    currentPathName = event.title;
    // updating route details to appear in crashlytics
    Crashlytics.setCustomKeys();

    if(event.doAllowEvent) {
      MixPanelService.trackEvent(event: event);
    }
  }

}