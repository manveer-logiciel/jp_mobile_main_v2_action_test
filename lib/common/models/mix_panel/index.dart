
import 'package:jobprogress/common/enums/mix_panel_events.dart';

class MixPanelModel {

  /// [title] is used to store title of the event
  String title;

  /// [path] is used to store path of currently active page/screen
  String path;

  /// [action] is used to define the action-type of event
  MixPanelActionType action;

  /// [arguments] are used to store additional info. about current route
  dynamic arguments;

  MixPanelModel({
    this.title = '',
    this.path = '',
    this.action = MixPanelActionType.view,
    this.arguments
  });

  bool get doAllowEvent => title.isNotEmpty && path.isNotEmpty;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['path'] = path;
    data['type'] = action;
    data['arguments'] = arguments;
    return data;
  }

}