import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class LabelValueTile extends StatelessWidget {

  const LabelValueTile({
    super.key,
    this.visibility,
    this.label,
    this.value,
    this.valueColor,
    this.sourceType,
    this.textAlign = TextAlign.start,
    this.textSize = JPTextSize.heading4,
    this.fontWeight = JPFontWeight.regular,
    this.enablePadding = false,
    this.isLabelPadding = false,
    this.extraContent
  });

  final bool? visibility;
  final String? label;
  final bool enablePadding;
  final String? value;
  final Color? valueColor;
  final String? sourceType;
  final TextAlign? textAlign;
  final JPTextSize textSize;
  final JPFontWeight fontWeight;
  final Widget? extraContent;
  final bool isLabelPadding;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visibility ?? true,
      child: Padding(
        padding: enablePadding ? const EdgeInsets.only(top: 5, left: 7): EdgeInsets.zero,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Padding(
                padding: isLabelPadding ? const EdgeInsets.only(top: 5) : EdgeInsets.zero,
                child: JPRichText(
                  text: JPTextSpan.getSpan(
                    label ?? "",
                    textColor: JPAppTheme.themeColors.secondaryText,
                    textAlign: textAlign ?? TextAlign.right,
                    textSize: textSize,
                    fontWeight: fontWeight,
                    children: [
                      JPTextSpan.getSpan(
                        " $value",
                        maxLine: 3,
                        height: 1.2,
                        overflow: TextOverflow.ellipsis,
                        textSize: textSize,
                        fontWeight: fontWeight,
                        textColor: valueColor ?? JPAppTheme.themeColors.tertiary
                      )
                    ]
                  )
                ),
              ),
            ),
            if(extraContent != null)
              extraContent!
          ],
        ),
      ),
    );
  }

  Widget space() => const SizedBox(
    height: 5,
    width: 5,
  );
}
