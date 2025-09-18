import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/launchdarkly/flag_model.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'controller.dart';

class FromLaunchDarkly extends StatelessWidget {
  const FromLaunchDarkly({
    required this.flagKey,
    required this.child,
    this.showHideOnly = true,
    super.key,
  });

  /// [flagKey] holds the key of the flag for listening changes on it
  final String flagKey;

  /// [showHideOnly] is used to either just show/hide or
  /// show the widget with data based on the flag value
  /// [True] - will show the widget only if the flag value is true (for internal display show/hide handling)
  /// [False] - will show the widget even if flag value is false (for external display data handling)
  final bool showHideOnly;

  /// [child] is used to render the widget based on the flag value
  final Widget Function(LDFlagModel) child;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FromLaunchDarklyController>(
      global: false,
      init: FromLaunchDarklyController(flagKey),
      dispose: (state) => state.controller?.onDispose(),
      builder: (controller) {
        if (controller.flagDetails == null) {
          return const SizedBox();
        } else if (showHideOnly && !Helper.isTrue(controller.flagDetails?.value)) {
          return const SizedBox();
        }
        return child(controller.flagDetails!);
      },
    );
  }
}
