import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class WorkFlowStageCardPainter extends CustomPainter {
  final Color cardColor;

  final bool isActive;

  final PaintingStyle? style;

  WorkFlowStageCardPainter(this.cardColor, this.isActive, {this.style});

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();

    path.moveTo(size.width, size.height * 0.09090909);

    path.cubicTo(
        size.width,
        size.height * 0.04070136,
        size.width - 3,
        size.width * 0,
        size.width - 6,
        0.5);

    path.lineTo(size.width * 0.06593407, 0.5);

    path.cubicTo(
        3, 0, 0,
        size.height * 0.04070136, 0,
        size.height * 0.09090909);

    path.lineTo(0, size.height * 0.7272727);

    path.cubicTo(
        0,
        size.height * 0.7774803,
        3,
        size.height * 0.8181818,
        6,
        size.height * 0.8181818);

    double leftDropAt = (size.width * 0.5) - 17;
    path.lineTo(leftDropAt, size.height * 0.8181818);

    path.cubicTo(
        leftDropAt + 2,
        size.height * 0.8181818,
        leftDropAt + 4,
        size.height * 0.8294424,
        leftDropAt + 6,
        size.height * 0.8490894);

    double centerDropAt = (size.width * 0.5) - 2;
    path.lineTo(centerDropAt, size.height * 0.9892409);

    path.cubicTo(
        centerDropAt + 2,
        size.height * 1.002977,
        centerDropAt,
        size.height * 1.002977,
        centerDropAt + 2,
        size.height * 0.9892409);

    double rightDropAt = (size.width * 0.5) + 8;
    path.lineTo(rightDropAt, size.height * 0.8490894);

    path.cubicTo(
        rightDropAt + 2,
        size.height * 0.8294424,
        rightDropAt + 3,
        size.height * 0.8181818,
        rightDropAt + 4,
        size.height * 0.8181818);

    path.lineTo(size.width * 0.9340659, size.height * 0.8181818);

    path.cubicTo(
        size.width - 2,
        size.height * 0.8181818,
        size.width,
        size.height * 0.7774803,
        size.width,
        size.height * 0.7272727);

    path.lineTo(size.width, size.height * 0.09090909);

    path.close();

    Paint paint = Paint()
      ..style = style ?? (isActive ? PaintingStyle.fill : PaintingStyle.stroke);
    paint.strokeWidth = 1;
    paint.color = isActive ? cardColor : JPAppTheme.themeColors.dimGray;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
