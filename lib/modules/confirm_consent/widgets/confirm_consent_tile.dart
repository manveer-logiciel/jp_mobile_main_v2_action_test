import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../global_widgets/link_text/index.dart';

class ConfirmConsentTile extends StatelessWidget {
  const ConfirmConsentTile({
    super.key,
    this.title,
    this.description,
    this.isDisable,
    this.isSelected = false,
    this.onTap,
  });

  final String? title;
  final String? description;
  final bool? isDisable;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Material(
        color: isDisable ?? false ? JPAppTheme.themeColors.base.withValues(alpha: 0.4) : JPAppTheme.themeColors.base,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: isDisable ?? false ? null : onTap,
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              border: isSelected ? Border.all(color: JPAppTheme.themeColors.primary, width: 1) : null,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 JPText(
                  text: title ?? "",
                  textSize: JPTextSize.heading4,
                  textAlign: TextAlign.start,
                  fontWeight: JPFontWeight.medium,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: JPLinkText(
                    text: description ?? "",
                    textSize: JPTextSize.heading5,
                    textColor: JPAppTheme.themeColors.text,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }
}
