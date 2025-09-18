import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ConsentStatusButton extends StatelessWidget {
  const ConsentStatusButton({
    super.key, 
    this.color, 
    required this.onPressed, 
    required this.suffixIcon, 
    this.isPad = false, required this.suffixText, 
  });

 
  final Color? color;
  final  VoidCallback onPressed;
  final IconData suffixIcon;
  final String suffixText;
  final bool isPad;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      type: MaterialType.button,
      color: color ?? JPAppTheme.themeColors.royalBlue,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        highlightColor: color?.withValues(alpha: 0.2)?? JPAppTheme.themeColors.primary.withValues(alpha: 0.2),
        onTap: onPressed,
        child: Container(
            height: 19,
            constraints:  BoxConstraints(
              maxWidth: JPScreen.isMobile? 42:155,
              minWidth: 40
            ),
            padding: const EdgeInsets.only(
              left: 6,
            ),
            child: getContainerData()),
      ),
    );
  }
    /// Defines child widget of a container
  Widget getContainerData() {
    List<Widget> rowChildren = <Widget>[
      JPIcon(
        Icons.mail_outline,
        color: JPAppTheme.themeColors.base,
        size: 15,
      ),
      if(JPScreen.isMobile)...{
        JPIcon(
          suffixIcon,
          color: JPAppTheme.themeColors.base,
          size: 19,
        ),
      } else...{
        const SizedBox(width: 8,),
        JPText(
          text: suffixText,
          textColor: JPAppTheme.themeColors.base,
          textSize: JPTextSize.heading5,
        )
      }
    ];
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: rowChildren,
    );
  }
}
