
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// GlobalValueListener is a common widget which can be used to listen value
/// of global controllers (registered one's).

/// Here T is the type of controller which is going to be your controller
/// class name basically

class GlobalValueListener<T extends GetxController> extends StatelessWidget {
  const GlobalValueListener({
    super.key,
    required this.child,
    this.init,
  });

  /// child is a widget function which returns controller instance
  /// to access/listen changes to any controller[GetxController] value
  final Widget Function(T controller) child;

  ///[init] can be used to assign an instance to listen on
  final T? init;

  @override
  Widget build(BuildContext context) {

    /// access to controller is allowed only when it is registered to avoid error
    if(Get.isRegistered<T>()) {
      return GetBuilder<T>(
        builder: (controller) {
          return child(controller);
        },
      );
    } else if(init != null) {
      return GetBuilder<T>(
        init: init,
        builder: (controller) {
          return child(controller);
        },
      );
    } else {
      /// sized box will be returned in case controller doesn't exists or not registered
      return const SizedBox();
    }
  }
}
