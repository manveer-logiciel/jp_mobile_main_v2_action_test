import 'package:flutter/material.dart';

//Using this widget to add safe area in whole app accoring to requirements
class JPSafeArea extends StatelessWidget {
  final Widget child;
  final bool top;
  final bool right;
  final bool bottom;
  final bool left;
  final BoxDecoration? containerDecoration;

  const JPSafeArea({
    required this.child,
    super.key,
    this.top = true,
    this.right = true,
    this.bottom = true,
    this.left = true,
    this.containerDecoration
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: containerDecoration,
      child: SafeArea(
        top: top,
        bottom: bottom,
        right: right,
        child: child,
      ),
    );
  }
}