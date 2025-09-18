
import 'package:jobprogress/common/enums/mix_panel_events.dart';
import 'package:jobprogress/common/models/mix_panel/index.dart';
import 'package:jobprogress/core/constants/mix_panel/titles.dart';

class MixPanelFilterEvent {

  static MixPanelModel customer = MixPanelModel(
      title: MixPanelEventTitle.filterSuccess(name: MixPanelEventTitle.customerFilter),
      action: MixPanelActionType.filter
  );

  static MixPanelModel job = MixPanelModel(
      title: MixPanelEventTitle.filterSuccess(name: MixPanelEventTitle.jobFilter),
      action: MixPanelActionType.filter
  );

  static MixPanelModel chats = MixPanelModel(
      title: MixPanelEventTitle.filterSuccess(name: MixPanelEventTitle.chats),
      action: MixPanelActionType.filter
  );

}