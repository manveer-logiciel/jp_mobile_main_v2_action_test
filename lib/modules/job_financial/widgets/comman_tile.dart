import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/ToolTip/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobFinancialTile extends StatelessWidget {
  const JobFinancialTile({
    super.key,
    required this.circleAvtarBackgroundColor, 
    required this.circleAvtarIcon, 
    required this.circleAvtarIconColor, 
    required this.title,
    this.amount, 
    this.amountColor,
    this.showInfoButton = false, 
    this.isShimmer = false,
    this.onTap, 
    this.canBlockFinancials = false,
    this.refundAdjustedAmount,
  });
  
  final Color circleAvtarBackgroundColor; 
  final IconData circleAvtarIcon;
  final Color circleAvtarIconColor;
  final String title;
  final String? amount;
  final Color? amountColor;
  final bool showInfoButton;
  final bool isShimmer;
  final Callback? onTap;
  final bool canBlockFinancials;
  final String? refundAdjustedAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Material(  
        color: JPAppTheme.themeColors.base,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius:BorderRadius.circular(18) ,
          onTap: canBlockFinancials ? null : onTap,
          child: Container(
            padding: const EdgeInsets.all(20), 
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                CircleAvatar(
                  radius: 25,
                  backgroundColor: circleAvtarBackgroundColor,
                  child: JPIcon(circleAvtarIcon, size: 24, color: circleAvtarIconColor),
                ),
                const SizedBox(width: 15),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        children: [
                          JPText(
                            text: title,
                            textColor: canBlockFinancials ? 
                            JPAppTheme.themeColors.tertiary.withValues(alpha: 0.5) :
                            JPAppTheme.themeColors.tertiary,
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(width: 6.5),
                          if(showInfoButton)
                          JPToolTip(
                            message: '${'total_job_price'.tr} + ${'change_orders'.tr} - \n${'payments_received'.tr} - ${'credits'.tr}',
                            child: JPIcon(
                              Icons.info_outlined,
                              size: 18,
                              color: canBlockFinancials ? JPAppTheme.themeColors.primary.withValues(alpha: 0.5) : JPAppTheme.themeColors.primary,
                            ),
                          ),
                        ],
                      ),    
                      const SizedBox(height: 6),
                      JPText(
                        textAlign: TextAlign.left,
                        text: canBlockFinancials ? '--' : amount!,
                        fontWeight: JPFontWeight.bold,
                        textSize: JPTextSize.heading1,
                        textColor:canBlockFinancials  ?
                          amountColor ?? JPAppTheme.themeColors.text.withValues(alpha: 0.5) :
                          amountColor ?? JPAppTheme.themeColors.text,
                      ), 
                      if(!Helper.isValueNullOrEmpty(refundAdjustedAmount))
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: JPRichText(
                                text: JPTextSpan.getSpan(
                                '(${'refund_ajusted'.tr}): ',
                                textColor: JPAppTheme.themeColors.tertiary,
                                  children: [
                                    JPTextSpan.getSpan(
                                      refundAdjustedAmount!,
                                      textColor : JPAppTheme.themeColors.tertiary
                                    ),
                                    WidgetSpan(
                                      child: Visibility(
                                        visible: showInfoButton,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 5),
                                          child: JPToolTip(
                                            message: '${'total_job_price'.tr} + ${'change_orders'.tr} - \n${'payments_received'.tr} - ${'credits'.tr} + \n${'refunds'.tr}',
                                            child: JPIcon(
                                              Icons.info_outline,
                                              color:canBlockFinancials ? JPAppTheme.themeColors.primary.withValues(alpha: 0.5) : JPAppTheme.themeColors.primary,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      )
                                    )
                                  ]
                                )
                              ),
                            ),
                          ],
                        ),
                      ),    
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
