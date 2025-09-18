
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/mix_panel_events.dart';
import 'package:jobprogress/common/models/mix_panel/index.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/mixpanel/view_observer.dart';
import 'package:jobprogress/core/constants/mix_panel/index.dart';

import '../../../common/models/sql/user/user.dart';
import 'route_to_view_event/index.dart';

class MixPanelHelper {

  /// getEventName() : helps in getting event name from event type
  static String getEventName(MixPanelActionType event) {

    switch (event) {

      case MixPanelActionType.view:
        return MixPanelConstants.actionView;

      case MixPanelActionType.add:
        return MixPanelConstants.actionAdd;

      case MixPanelActionType.archive:
        return MixPanelConstants.actionArchive;

      case MixPanelActionType.delete:
        return MixPanelConstants.actionDelete;

      case MixPanelActionType.edit:
        return MixPanelConstants.actionEdit;

      case MixPanelActionType.filter:
        return MixPanelConstants.actionFilter;

      case MixPanelActionType.print:
        return MixPanelConstants.actionPrint;

      case MixPanelActionType.reorder:
        return MixPanelConstants.actionReorder;

      case MixPanelActionType.update:
        return MixPanelConstants.actionUpdate;

      case MixPanelActionType.switchEvent:
        return MixPanelConstants.actionSwitch;

    }
  }

  /// getEventProperties() : helps in getting properties json to store
  ///                        custom properties on mix panel as additional data
  static Map<String, dynamic> getEventProperties(MixPanelActionType event) {

    UserModel? user = AuthService.userDetails;

    return {
       MixPanelConstants.propActionType : getEventName(event),
       MixPanelConstants.propPath : MixPanelViewObserver.formattedPath,
       MixPanelConstants.propCompanyId : (user?.companyDetails?.id ?? "").toString(),
       MixPanelConstants.propJPUserId : (user?.id ?? '').toString(),
    };
  }

  /// getViewEvent() : process the route data to extract useful information
  ///                  that can be stored on mix-panel
  static MixPanelModel getViewEvent(Routing routing) {

    final event = MixPanelHelperRouteToViewEvent.getViewEvent(routing);
    event.path = event.path.split("?").first;
    event.arguments = getPathArgs(routing.args);

    return event;
  }

  static String getPathArgs(dynamic args) {
    if(args is List) {
      return "?${args.join("/")}";
    } else if(args is Map) {
      return "?${args.entries.map((e) => "${e.key}=${e.value}").toList().join("&")}";
    } else {
      return "";
    }
  }

}