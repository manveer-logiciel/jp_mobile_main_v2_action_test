import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/location/background_location_service.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/background_location/controller.dart';
import 'package:jobprogress/global_widgets/from_launch_darkly/index.dart';

/// [JPBackgroundLocationListener] can be used a wrapper over widgets that
/// require to listen background location updates
class JPBackgroundLocationListener extends StatelessWidget {

  const JPBackgroundLocationListener({
    super.key,
    required this.child,
    this.setUpAddress = false,
  });

  final bool setUpAddress;
  final Widget Function(JPBackgroundLocationController) child;

  @override
  Widget build(BuildContext context) {
    if (Helper.isValueNullOrEmpty(BackgroundLocationService.controller)) {
      return const SizedBox();
    }

    return GetBuilder<JPBackgroundLocationController>(
        init: BackgroundLocationService.controller,
        initState: (state) {
          if (setUpAddress && Helper.isTrue(BackgroundLocationService.controller?.doShowLastTracking)) {
            BackgroundLocationService.controller?.addLastTrackedAddress();
          }
        },
        builder: (controller) {
          return FromLaunchDarkly(
            flagKey: LDFlagKeyConstants.userLocationTracking,
            showHideOnly: true,
            child: (_) => child(controller),
          );
        },
    );
  }
}
