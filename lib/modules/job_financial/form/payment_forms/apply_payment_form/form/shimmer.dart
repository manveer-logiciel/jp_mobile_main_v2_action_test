import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
class ApplyPaymentFormShimmer extends StatelessWidget {
  const ApplyPaymentFormShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i <= 4; i++)...{
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Flexible(
                child: JPInputBox(
                  fillColor: JPColor.white,
                  type: JPInputBoxType.withLabel,
                  label: '',
                  hintText: "0.00",
                  maxLength: 9,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(width: 15),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    JPText(
                      text: '${'balance'.tr.capitalize!}: ',
                      textColor: JPAppTheme.themeColors.tertiary,
                      fontWeight: JPFontWeight.medium,
                    ),
                    const SizedBox(width: 20,)
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 20)
        }
      ],
    );
  }
}