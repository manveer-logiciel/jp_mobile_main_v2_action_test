
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimatedSyncButtonController extends GetxController with GetSingleTickerProviderStateMixin {

  late AnimationController animationController;

  Duration rotationSpeed = const Duration(seconds: 1);

  @override
  void onInit() {
    ///   AnimationController Initialization
    animationController = AnimationController(
        vsync: this,
        duration: rotationSpeed
    );

    ///   AnimationController Listener
    animationController.addListener(() {
      if(animationController.isCompleted) {
        animationController.repeat();
        update();
      }
    });

    super.onInit();
  }

  void handleLoading(bool isLoading) {
    if(isLoading) {
      animationController.forward();
      update();
    } else {
      if(animationController.isAnimating) {
        animationController.stop();
        animationController.reset();
        update();
      }
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}