import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/assets_files.dart';
import 'package:jobprogress/modules/job_financial/form/payment_forms/receive_payment_form/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class LeapPayPreferencesStatus extends StatelessWidget {
  const LeapPayPreferencesStatus({
    required this.controller,
    super.key
  });

  final ReceivePaymentFormController controller;

  (String, String) get preferenceMessages => controller.service.getLeapPayPreferenceStatusMessage();

  bool get isLeapPayEnabled => controller.service.isLeapPayEnabled &&
          !(controller.service.financialDetails?.isAcceptingLeapPay ?? false);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: JPAppTheme.themeColors.base
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              JPText(
                text: 'payment'.tr.capitalizeFirst!,
                textSize: JPTextSize.heading2,
                fontWeight: JPFontWeight.bold,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 5,),
              JPText(
                text: '${controller.financialDetails?.name}',
                textSize: JPTextSize.heading4,
                fontWeight: JPFontWeight.bold,
              ),
              const SizedBox(height: 40,),
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    JPText(
                      text: preferenceMessages.$1,
                      textSize: JPTextSize.heading3,
                      fontWeight: JPFontWeight.bold,
                    ),
                    const SizedBox(height: 10,),
                    if(isLeapPayEnabled)...{
                      GestureDetector(
                        onTap: controller.navigateToLeapPayPrefs,
                        child: JPText(
                          text: preferenceMessages.$2,
                          textSize: JPTextSize.heading4,
                          textColor: Colors.blue,
                          textDecoration: TextDecoration.underline,
                        ),
                      )
                      ,
                    } else
                      ...{
                        JPText(
                          text: preferenceMessages.$2,
                          textSize: JPTextSize.heading4,
                        ),
                      }

                  ],
                ),
              ),
              const SizedBox(height: 40,),
              SizedBox(
                //alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, top: 10),
                  child: SvgPicture.asset(
                    AssetsFiles.poweredByLeapPay,
                    height: 25,
                  ),
                ),
              )
            ]),
      ),
    );
  }
}