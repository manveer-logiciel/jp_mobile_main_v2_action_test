import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JPCustomListBottomSheet extends StatelessWidget {

 const JPCustomListBottomSheet({
   super.key,
   required this.widgetList,
   this.title,
   this.isFilterSheet = false,
   this.canShowIconButton = false,
   this.iconButtonBackgroundColor,
   this.iconButtonBorderRadius,
   this.onIconButtonTap,
   this.iconButtonIcon,
   this.iconButtonIconSize,
   this.iconButtonIconColor,
   this.iconButtonIconWidget,
  });

  //Single select header title
  final String? title;

  //For showing single select as filter - Pass true to make it as fiter
  //This will add extra padding from bottom and change draggable scroll behaviour
  final bool isFilterSheet;

  ///   Icon Button Params
  final bool canShowIconButton;
  final Color? iconButtonBackgroundColor;
  final double? iconButtonBorderRadius;
  final VoidCallback? onIconButtonTap;
  final IconData? iconButtonIcon;
  final double? iconButtonIconSize;
  final Color? iconButtonIconColor;
  final Widget? iconButtonIconWidget;

 final List<Widget> widgetList;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 100),
        padding: JPResponsiveDesign.popOverBottomInsets,
        child: Padding(
          padding: EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: isFilterSheet && !JPScreen.hasBottomPadding ? 20 : 0),
          child: ClipRRect(
            borderRadius: getBorderRadius(),
              child: Material(
                borderRadius: getBorderRadius(),
                color: JPAppTheme.themeColors.base,
                  child: SafeArea(
                    bottom: !isFilterSheet,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        JPSingleSelectHeader(
                          title: title ?? "items".tr,
                          canShowIconButton: canShowIconButton,
                          iconButtonBackgroundColor: iconButtonBackgroundColor,
                          iconButtonBorderRadius: iconButtonBorderRadius,
                          onIconButtonTap: onIconButtonTap,
                          iconButtonIcon: iconButtonIcon,
                          iconButtonIconColor: iconButtonIconColor,
                          iconButtonIconSize: iconButtonIconSize,
                          iconButtonIconWidget: iconButtonIconWidget,
                        ),
                        ...widgetList,
                      ]
                    ),
                  )
              )
          )
        )
      )
    );
  }

  BorderRadius getBorderRadius() {
    if(isFilterSheet) {
      return BorderRadius.circular(20);
    } else {
      return JPResponsiveDesign.bottomSheetRadius;
    }
  }

}
