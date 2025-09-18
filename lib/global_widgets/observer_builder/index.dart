import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobprogress/main.dart';

/// GetObserverBuilder is a wrapper around get builder with helps in managing
/// screen/page life-cycle
class GetObserverBuilder<T extends GetxController> extends StatefulWidget {
  const GetObserverBuilder({
    super.key,
    required this.init,
    required this.builder,
    this.onPause,
    this.onResume, 
    this.global = false, 
  });

  final T init;
  final Widget Function(T) builder;
  final Function(T)? onResume;
  final Function(T)? onPause;
  final bool global;

  @override
  State<GetObserverBuilder<T>> createState() => _GetObserverBuilderState<T>();
}

class _GetObserverBuilderState<T extends GetxController>
    extends State<GetObserverBuilder<T>> with RouteAware {
  late T controller;
  String currentRoute = Get.currentRoute;
  bool isPushedOnSameRoute = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
      global: widget.global,
      init: widget.init,
      builder: (T controller) {
        this.controller = controller;
        return widget.builder(controller);
      },
    );
  }

  @override
  void didChangeDependencies() {
    JobProgressApp.routeObserver.subscribe(this, ModalRoute.of(context)!);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    JobProgressApp.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    if (widget.onResume != null
        && !isPushedOnSameRoute) {
      widget.onResume!(controller);
    }
  }

  @override
  void didPushNext() {
    isPushedOnSameRoute = currentRoute == Get.currentRoute;
    if (widget.onPause != null) widget.onPause!(controller);
  }
}
