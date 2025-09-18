
import 'package:jobprogress/common/enums/mix_panel_events.dart';
import 'package:jobprogress/common/models/mix_panel/index.dart';
import 'package:jobprogress/core/constants/mix_panel/titles.dart';

class MixPanelSwitchEvent {

  static MixPanelModel companySwitchSuccess = MixPanelModel(
      title: MixPanelEventTitle.success(name: MixPanelEventTitle.companySwitched),
      action: MixPanelActionType.switchEvent
  );

  static MixPanelModel companySwitchFail = MixPanelModel(
      title: MixPanelEventTitle.failure(name: MixPanelEventTitle.companySwitched),
      action: MixPanelActionType.switchEvent
  );

}