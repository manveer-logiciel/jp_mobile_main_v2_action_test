import 'package:flutter/material.dart';
import 'package:jobprogress/common/extensions/color/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../core/constants/work_flow_stage_color.dart';
import '../../core/utils/color_helper.dart';
import '../network_image/index.dart';

class JPProfileImage extends StatelessWidget {

  const JPProfileImage({
    super.key,
    this.src,
    this.initial,
    this.textSize,
    this.enableBorder = true,
    this.color,
    this.size, 
    this.width, 
    this.height, 
    this.dynamicFontSize, 
    this.radius});

  final String? src;
  final String? color;
  final String? initial;
  final JPAvatarSize? size;
  final JPTextSize? textSize;
  final bool enableBorder;
  final double? width;
  final double? height;
  final double? radius;
  final double? dynamicFontSize;

  @override
  Widget build(BuildContext context) {

    return JPAvatar(
        height: height,
        width: width,
        radius: radius ?? 50.0,
        size: size ?? JPAvatarSize.small,
        backgroundColor: src == null || src == '' ?  color != null ? ColorHelper.getHexColor(color!.contains("cl") ? WorkFlowStageConstants.colors[color]!.toHex() : color!): JPAppTheme.themeColors.secondaryText :null,
        borderColor: enableBorder ? src != null && src!.isNotEmpty ? color != null ? ColorHelper.getHexColor(color!.contains("cl") ? WorkFlowStageConstants.colors[color]!.toHex() : color!): JPAppTheme.themeColors.inverse : JPAppTheme.themeColors.inverse : null,
        borderWidth: enableBorder ? src != null && src!.isNotEmpty ? 2 : 1 : 0,
        child: src != null && src!.isNotEmpty
          ? JPNetworkImage(
              src: src,
              placeHolder: JPAvatar(
                backgroundColor: ColorHelper.getHexColor(color ?? JPAppTheme.themeColors.secondaryText.toHex()),
                child: JPText(
                    text: initial ?? "",
                    textColor: JPAppTheme.themeColors.base,
                    textSize: textSize ?? JPTextSize.heading6
                ),
              ),
            )
          : JPText(
              text: initial ?? '',
              textColor: JPAppTheme.themeColors.base,
              textSize:  textSize ?? JPTextSize.heading6,
              dynamicFontSize: dynamicFontSize,
            )
    );
  }
}

