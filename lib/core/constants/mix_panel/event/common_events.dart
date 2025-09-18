
import 'package:jobprogress/common/enums/mix_panel_events.dart';
import 'package:jobprogress/common/models/mix_panel/index.dart';
import 'package:jobprogress/core/constants/mix_panel/titles.dart';

class MixPanelCommonEvent {

  static MixPanelModel get showQuickAction => MixPanelModel(
      title: MixPanelEventTitle.showQuickAction(),
      action: MixPanelActionType.view
  );

  static MixPanelModel get hideQuickAction => MixPanelModel(
      title: MixPanelEventTitle.hideQuickAction(),
      action: MixPanelActionType.view
  );

  static MixPanelModel get filterSuccess => MixPanelModel(
      title: MixPanelEventTitle.filterSuccess(),
      action: MixPanelActionType.filter
  );

  static MixPanelModel get filterFailure => MixPanelModel(
      title: MixPanelEventTitle.filterFailure(),
      action: MixPanelActionType.filter
  );

  static MixPanelModel get sortFilterSuccess => MixPanelModel(
      title: MixPanelEventTitle.sortFilterSuccess(),
      action: MixPanelActionType.filter
  );

  static MixPanelModel get sortFilterFailure => MixPanelModel(
      title: MixPanelEventTitle.sortFilterFailure(),
      action: MixPanelActionType.filter
  );

  static MixPanelModel get attachmentView => MixPanelModel(
      title: MixPanelEventTitle.attachment(),
      action: MixPanelActionType.add
  );

  static MixPanelModel get createDirectory => MixPanelModel(
      title: MixPanelEventTitle.attachment(),
      action: MixPanelActionType.add
  );

  static MixPanelModel get print => MixPanelModel(
      title: MixPanelEventTitle.print(),
      action: MixPanelActionType.print
  );

  static MixPanelModel deleteSuccess(String name) => MixPanelModel(
      title: MixPanelEventTitle.success(name: name),
      action: MixPanelActionType.delete
  );

  static MixPanelModel deleteFailure(String name) => MixPanelModel(
      title: MixPanelEventTitle.failure(name: name),
      action: MixPanelActionType.delete
  );

  static MixPanelModel archiveSuccess(String name) => MixPanelModel(
      title: MixPanelEventTitle.success(name: name),
      action: MixPanelActionType.archive
  );

  static MixPanelModel archiveFailure(String name) => MixPanelModel(
      title: MixPanelEventTitle.failure(name: name),
      action: MixPanelActionType.archive
  );

  static MixPanelModel updateSuccess(String name) => MixPanelModel(
      title: MixPanelEventTitle.success(name: name),
      action: MixPanelActionType.update
  );

  static MixPanelModel updateFailure(String name) => MixPanelModel(
      title: MixPanelEventTitle.failure(name: name),
      action: MixPanelActionType.update
  );

  static MixPanelModel get deviceRegisterFailure => MixPanelModel(
      title: MixPanelEventTitle.failure(name: MixPanelEventTitle.deviceRegistration),
      action: MixPanelActionType.update
  );
}