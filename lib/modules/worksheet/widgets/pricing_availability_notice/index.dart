import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class PricingAvailabilityNotice extends StatelessWidget {

  const PricingAvailabilityNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 10
      ),
      child: Material(
        color: JPAppTheme.themeColors.base,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              JPText(text: 'pricing_availability_notice'.tr.capitalize!,
                textSize: JPTextSize.heading3,
                fontWeight: JPFontWeight.medium,
              ),
              const SizedBox(height: 10,),
              JPText(text: 'pricing_availability_notice_desc'.tr,
                textSize: JPTextSize.heading5,
                textAlign: TextAlign.start,
                height: 1.3,
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: JPButton(
                  text: 'ok'.tr,
                  size: JPButtonSize.small,
                  onPressed: Get.back<void>,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
