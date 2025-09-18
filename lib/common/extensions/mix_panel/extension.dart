
import 'dart:async';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/core/constants/mix_panel/event/common_events.dart';

/// [MixPanelFutureEventHandler] is an extension over future functions
/// which helps in tracking various mix-panel events with ease of code
extension MixPanelFutureEventHandler<T> on Future<T> {

  Future<T> trackFilterEvents() {
    then((value) {
      MixPanelService.trackEvent(event: MixPanelCommonEvent.filterSuccess);
    }).catchError((e) {
      MixPanelService.trackEvent(event: MixPanelCommonEvent.filterFailure);
    });
    return this;
  }

  Future<T> trackSortFilterEvents() {
    then((value) {
      MixPanelService.trackEvent(event: MixPanelCommonEvent.sortFilterSuccess);
    }).catchError((e) {
      MixPanelService.trackEvent(event: MixPanelCommonEvent.sortFilterFailure);
    });

    return this;
  }

  Future<T> trackDeleteEvent(String title) {
    then((value) {
      MixPanelService.trackEvent(event: MixPanelCommonEvent.deleteSuccess(title));
    }).catchError((e) {
      MixPanelService.trackEvent(event: MixPanelCommonEvent.deleteFailure(title));
    });

    return this;
  }

  Future<T> trackArchiveEvent(String title) {
    then((value) {
      MixPanelService.trackEvent(event: MixPanelCommonEvent.archiveSuccess(title));
    }).catchError((e) {
      MixPanelService.trackEvent(event: MixPanelCommonEvent.archiveFailure(title));
    });

    return this;
  }

  Future<T> trackUpdateEvent(String title) {
    then((value) {}).then((value) {
      MixPanelService.trackEvent(event: MixPanelCommonEvent.updateSuccess(title));
    }).catchError((e) {
      MixPanelService.trackEvent(event: MixPanelCommonEvent.updateFailure(title));
    });

    return this;
  }


}