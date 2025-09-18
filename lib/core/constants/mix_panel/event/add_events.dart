
import 'package:jobprogress/common/enums/mix_panel_events.dart';
import 'package:jobprogress/common/models/mix_panel/index.dart';
import 'package:jobprogress/core/constants/mix_panel/titles.dart';

class MixPanelAddEvent {

  static MixPanelModel profileSignature = MixPanelModel(
      title: MixPanelEventTitle.add(name: MixPanelEventTitle.profileSignature),
      action: MixPanelActionType.add
  );

  static MixPanelModel createDirectorySuccess = MixPanelModel(
      title: MixPanelEventTitle.success(name: MixPanelEventTitle.createDirectory),
      action: MixPanelActionType.add
  );

  static MixPanelModel createDirectoryFailure = MixPanelModel(
      title: MixPanelEventTitle.failure(name: MixPanelEventTitle.createDirectory),
      action: MixPanelActionType.add
  );

  static MixPanelModel emailComposeSuccess = MixPanelModel(
      title: MixPanelEventTitle.success(name: MixPanelEventTitle.emailCompose),
      action: MixPanelActionType.add
  );

  static MixPanelModel emailComposeFailure = MixPanelModel(
      title: MixPanelEventTitle.failure(name: MixPanelEventTitle.emailCompose),
      action: MixPanelActionType.add
  );

  static MixPanelModel documentExpiresSuccess = MixPanelModel(
      title: MixPanelEventTitle.success(name: MixPanelEventTitle.documentExpired),
      action: MixPanelActionType.add
  );

  static MixPanelModel followUpNote = MixPanelModel(
      title: MixPanelEventTitle.add(name: MixPanelEventTitle.followUpNote),
      action: MixPanelActionType.add
  );

  static MixPanelModel jobNote = MixPanelModel(
      title: MixPanelEventTitle.add(name: MixPanelEventTitle.jobNote),
      action: MixPanelActionType.add
  );

  static MixPanelModel workCrewNote = MixPanelModel(
      title: MixPanelEventTitle.add(name: MixPanelEventTitle.workCrewNote),
      action: MixPanelActionType.add
  );

  static MixPanelModel workCrew = MixPanelModel(
      title: MixPanelEventTitle.add(name: MixPanelEventTitle.workCrew),
      action: MixPanelActionType.add
  );

  static MixPanelModel form = MixPanelModel(
      title: MixPanelEventTitle.add(),
      action: MixPanelActionType.add
  );

}