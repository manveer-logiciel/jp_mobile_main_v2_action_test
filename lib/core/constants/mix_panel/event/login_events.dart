
import 'package:jobprogress/common/enums/mix_panel_events.dart';
import 'package:jobprogress/common/models/mix_panel/index.dart';
import 'package:jobprogress/core/constants/mix_panel/titles.dart';

class MixPanelLoginEvent {

  static MixPanelModel loginFailed = MixPanelModel(
      title: MixPanelEventTitle.loginFailed,
      action: MixPanelActionType.view
  );

  static MixPanelModel loginSuccess = MixPanelModel(
      title: MixPanelEventTitle.loginSuccess,
      action: MixPanelActionType.view
  );

  static MixPanelModel logOutFailed = MixPanelModel(
      title: MixPanelEventTitle.logOutFailed,
      action: MixPanelActionType.view
  );

  static MixPanelModel logOutSuccess = MixPanelModel(
      title: MixPanelEventTitle.logOutSuccess,
      action: MixPanelActionType.view
  );

  static MixPanelModel demoLoginFailed = MixPanelModel(
      title: MixPanelEventTitle.demoLoginFailed,
      action: MixPanelActionType.view
  );

  static MixPanelModel demoLoginSuccess = MixPanelModel(
      title: MixPanelEventTitle.demoLoginSuccess,
      action: MixPanelActionType.view
  );

}