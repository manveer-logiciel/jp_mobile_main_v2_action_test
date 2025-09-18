import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JPAnimatedClock extends StatefulWidget {
  const JPAnimatedClock({
    super.key,
    required this.size,
    required this.handHeight,
  });

  /// size is used to give size to clock icon
  final double size;

  /// handHeight is used to set length of clock rotating hand
  final double handHeight;

  @override
  State<JPAnimatedClock> createState() => _JPAnimatedClockState();
}

class _JPAnimatedClockState extends State<JPAnimatedClock>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
      value: 0,
      lowerBound: 0,
      upperBound: 1,
    )..repeat();

    animation = CurvedAnimation(parent: controller, curve: Curves.linear);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// clock icon
        JPIcon(
          Icons.timer,
          color: JPAppTheme.themeColors.primary,
          size: widget.size,
        ),

        /// animated hand
        Positioned.fill(
          top: widget.size / 8,
          child: Center(
            child: RotationTransition(
              turns: animation,
              child: Transform.translate(
                offset: Offset(0, -(widget.handHeight / 2)),
                child: Container(
                  height: widget.handHeight,
                  width: widget.handHeight / 3.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: JPAppTheme.themeColors.lightBlue,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
