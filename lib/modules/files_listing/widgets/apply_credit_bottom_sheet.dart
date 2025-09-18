import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ApplyCreditBottomSheet extends StatelessWidget {
  const ApplyCreditBottomSheet({
    super.key, 
    required this.title, 
    required this.openBalance, 
    required this.unappliedCredit, 
    required this.disableButtons, 
    required this.onTapPrefix, 
    required this.onTapSuffix, 
    required this.suffixBtnIcon,
  });
  
  final String title;
  final String openBalance;
  final String unappliedCredit;
  
  final bool disableButtons;
  
  final VoidCallback onTapPrefix;
  final VoidCallback onTapSuffix;
  
  final Widget? suffixBtnIcon;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          top: AppBar().preferredSize.height / 1.5,
          bottom: 10
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: JPAppTheme.themeColors.base),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Center(
                child: Container(
                 width: 30,
                 height: 4, 
                 color: JPAppTheme.themeColors.dimGray,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height - 180,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: JPText(
                          text: title.toUpperCase(),
                          textSize: JPTextSize.heading3,
                          fontWeight: JPFontWeight.medium,
                        ),
                      ),
                      JPText(text: 'open_balance'.tr.capitalize!),
                      const SizedBox(height: 5),
                      JPText(
                        text: openBalance,
                        textSize: JPTextSize.heading5,
                        textColor: JPAppTheme.themeColors.tertiary,
                      ),
                      const SizedBox(height: 15),
                      JPText(text: 'unapplied_credit'.tr.capitalize!),
                      const SizedBox(height: 5),
                      JPText(
                        text: unappliedCredit,
                        textSize: JPTextSize.heading5,
                        textColor: JPAppTheme.themeColors.tertiary,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: cancelConfirmBtn(),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Will return both buttons
  Widget cancelConfirmBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: JPResponsiveDesign.popOverButtonFlex,
          child: JPButton(
            text: 'cancel'.tr.toUpperCase(),
            textColor: JPAppTheme.themeColors.tertiary,
            size: JPButtonSize.small,
            disabled: disableButtons,
            colorType: JPButtonColorType.lightGray,
            onPressed: onTapPrefix
          ),
        ),
        const SizedBox(
          width: 14,
        ),
        Expanded(
          flex: JPResponsiveDesign.popOverButtonFlex,
          child: JPButton(
            text:  suffixBtnIcon == null
              ? 'apply_credit'.tr.toUpperCase()
              : '',
            textColor: JPAppTheme.themeColors.base,
            size: JPButtonSize.small,
            colorType: JPButtonColorType.primary,
            onPressed: onTapSuffix,
            iconWidget: suffixBtnIcon,
            disabled: disableButtons,
          ),
        ),
      ],
    );
  }
}
