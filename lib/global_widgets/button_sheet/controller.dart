import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/home/quick_actions.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/core/constants/mix_panel/event/common_events.dart';
import 'dart:math' as math;

import 'widgets/index.dart';

class JPButtonSheetController extends GetxController with GetTickerProviderStateMixin {

  JPButtonSheetController(
    this.onTapOption,
    this.initialAlignment,
  );

  final Function(String) onTapOption; // helps in handling action tap

  final Alignment initialAlignment; // helps in deciding animation behaviour

  late AnimationController rotationController; // used to rotate child widged

  OverlayState? overlayState; // helps in displaying top-level widget
  OverlayEntry? overlayEntry; // used to hold top-level widget

  bool isOpened = false; // helps in managing show/hide state of top-level widget

  @override
  void onInit() {
    // setting up rotation controller
    rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0,
      upperBound: math.pi / 4,
    );
    super.onInit();
  }

  // showOptions(): will animation child and displays options, child context is required here
  //                as overlay doesn't works with global context i.e Get.context
  Future<void> showOptions(BuildContext context) async {
    removeOverlayEntry();

    overlayState = Overlay.of(context); // setting up state with current context

    // updating entry with widget to be displayed
    overlayEntry = OverlayEntry(builder: (_) {
      return JPButtonSheet(
        isOpened: isOpened,
        initialAlignment: initialAlignment,
        onTapOption: (id) async {
          await hideOptions(context);
          onTapOption(id);
        },
        onTapOutSide: () {
          hideOptions(context);
        },
        options: HomeQuickActionsService().quickActions,
      );
    });

    // displaying widget on top-level
    overlayState?.insert(overlayEntry!);

    // rotating child widget
    await rotationController.forward();

    isOpened = true;

    overlayEntry?.markNeedsBuild(); // updating overlay to perform animation

    MixPanelService.trackEvent(event: MixPanelCommonEvent.showQuickAction);

  }

  // hideOptions() : will remove top-level widget if displayed any
  Future<void> hideOptions(BuildContext context) async {
    isOpened = false;
    rotationController.reverse(); // rotating to initial state
    overlayEntry?.markNeedsBuild(); // updating overlay to perform reverse animation
    await Future<void>.delayed(const Duration(milliseconds: 300));
    removeOverlayEntry(); // removing overlay

    MixPanelService.trackEvent(event: MixPanelCommonEvent.hideQuickAction);

  }

  // onTapChild() : Will show/hide options
  void onTapChild(BuildContext context) {
    if (isOpened) {
      hideOptions(context);
    } else {
      showOptions(context);
    }
  }

  void removeOverlayEntry() {
    if (overlayEntry != null) {
      overlayEntry?.remove();
      overlayEntry = null;
    }
  }
}
