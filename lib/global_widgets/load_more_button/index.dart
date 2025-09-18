import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JPLoadMoreButton extends StatelessWidget {
  const JPLoadMoreButton({super.key, this.isLoadMore = false, this.callback});

  final bool isLoadMore;

  final VoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
        child: JPButton(
          size: JPButtonSize.mediumWithIcon,
          text: 'load_more'.tr,
          onPressed: callback,
          iconWidget: isLoadMore
              ? FadingCircle(color: JPAppTheme.themeColors.base, size: 20)
              : null,
          colorType: JPButtonColorType.tertiary,
          fontFamily: JPFontFamily.montserrat,
        ));
  }
}
