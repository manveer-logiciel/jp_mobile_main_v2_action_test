
import 'package:jobprogress/common/enums/mix_panel_events.dart';
import 'package:jobprogress/common/models/mix_panel/index.dart';
import 'package:jobprogress/core/constants/mix_panel/titles.dart';

class MixPanelEditEvent {

  static MixPanelModel profileSignature = MixPanelModel(
      title: MixPanelEventTitle.edit(name: MixPanelEventTitle.profileSignature),
      action: MixPanelActionType.edit
  );

  static MixPanelModel jobNote = MixPanelModel(
      title: MixPanelEventTitle.edit(name: MixPanelEventTitle.jobNote),
      action: MixPanelActionType.edit
  );

  static MixPanelModel workCrewNote = MixPanelModel(
      title: MixPanelEventTitle.edit(name: MixPanelEventTitle.workCrewNote),
      action: MixPanelActionType.edit
  );

  static MixPanelModel form = MixPanelModel(
      title: MixPanelEventTitle.edit(),
      action: MixPanelActionType.edit
  );

}