import 'package:flutter/material.dart';
class JPWillPopScope extends StatelessWidget {
  final Widget child;
  final Future<bool> Function() onWillPop;

  const JPWillPopScope({
    super.key,
    required this.child,
    required this.onWillPop,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: onWillPop,
      child: child,
    );
  }
}