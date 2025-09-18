
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/three_bounce.dart';
import 'package:jp_mobile_flutter_ui/animations/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

showJPLoader({String? msg}) {
  Get.generalDialog(
    barrierDismissible: false,
    barrierLabel: '',
    transitionDuration: const Duration(milliseconds: CommonConstants.transitionDuration),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return Animations.grow(animation, secondaryAnimation, child);
    },
    pageBuilder: (animation, secondaryAnimation, child) {
      return JPLoader(
        text: msg,
      );
    },
  );
}

/// showJPConfirmationLoader can be used to show loading animation on buttons
/// parameters: show[optional]
/// show:- it is a bool variable which can be used to show or hide loader
///        default value is [false]
Widget? showJPConfirmationLoader({bool? show = false, double size = 20}){
  return show!
      ? SpinKitThreeBounce(color: JPColor.white, size: size)
      : null;
}