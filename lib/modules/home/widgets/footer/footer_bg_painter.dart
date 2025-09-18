import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class HomePageFooterPainter extends CustomPainter {

  HomePageFooterPainter(this.hasResponsiveConstraints);

  bool hasResponsiveConstraints;


  @override
  void paint(Canvas canvas, Size size) {

    Path path = Path();

    if(hasResponsiveConstraints) {
      path.moveTo(size.width*0.4064681,size.height*0.1834386);
      path.cubicTo(size.width*0.4017181,size.height*0.09409971,size.width*0.3893351,size.height*0.02857143,size.width*0.3724787,size.height*0.02857143);
      path.lineTo(size.width*-0.007978723,size.height*0.02857143);
      path.lineTo(size.width*-0.007978723,size.height);
      path.lineTo(size.width*1.002660,size.height);
      path.lineTo(size.width*1.002660,size.height*0.02857143);
      path.lineTo(size.width*0.6222021,size.height*0.02857143);
      path.cubicTo(size.width*0.6053457,size.height*0.02857143,size.width*0.5909628,size.height*0.09409986,size.width*0.5882128,size.height*0.1834386);
      path.lineTo(size.width*0.5808617,size.height*0.4223557);
      path.cubicTo(size.width*0.5741037,size.height*0.6418843,size.width*0.5387660,size.height*0.8029057,size.width*0.4973404,size.height*0.8029057);
      path.cubicTo(size.width*0.4559149,size.height*0.8029057,size.width*0.4205771,size.height*0.6418843,size.width*0.4138191,size.height*0.4223557);
      path.lineTo(size.width*0.4064681,size.height*0.1834386);
    } else {
      path.moveTo(size.width*0.4115000,size.height*0.1787448);
      path.cubicTo(size.width*0.4088169,size.height*0.08871138,size.width*0.3954331,size.height*0.02298851,size.width*0.3797815,size.height*0.02298851);
      path.lineTo(size.width*0.04724409,size.height*0.02298851);
      path.cubicTo(size.width*0.02550059,size.height*0.02298851,size.width*0.007874016,size.height*0.1259115,size.width*0.007874016,size.height*0.2528736);
      path.lineTo(size.width*0.007874016,size.height);
      path.lineTo(size.width*0.9921260,size.height);
      path.lineTo(size.width*0.9921260,size.height*0.2528736);
      path.cubicTo(size.width*0.9921260,size.height*0.1259115,size.width*0.9744724,size.height*0.02298851,size.width*0.9527283,size.height*0.02298851);
      path.cubicTo(size.width*0.8291240,size.height*0.02298851,size.width*0.7466280,size.height*0.02298851,size.width*0.6202343,size.height*0.02298851);
      path.cubicTo(size.width*0.6045827,size.height*0.02298851,size.width*0.5911850,size.height*0.08871149,size.width*0.5885000,size.height*0.1787460);
      path.lineTo(size.width*0.5819232,size.height*0.3994701);
      path.cubicTo(size.width*0.5749921,size.height*0.6320184,size.width*0.5404252,size.height*0.8017724,size.width*0.5000000,size.height*0.8017724);
      path.cubicTo(size.width*0.4595748,size.height*0.8017724,size.width*0.4250079,size.height*0.6320172,size.width*0.4180768,size.height*0.3994701);
      path.lineTo(size.width*0.4115000,size.height*0.1787448);
    }

    path.close();

    Paint paint = Paint()..style=PaintingStyle.fill;
    paint.color = JPAppTheme.themeColors.base.withValues(alpha: 0.2);
    canvas.drawPath(path,paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}