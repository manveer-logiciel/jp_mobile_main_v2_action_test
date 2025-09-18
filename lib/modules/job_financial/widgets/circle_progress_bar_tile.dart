import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/modules/job_financial/controller.dart';
import 'package:jp_mobile_flutter_ui/ToolTip/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobFinancialCircularProgresBarTile extends StatelessWidget {
  
  const JobFinancialCircularProgresBarTile({
    super.key, 
    required this.title, 
    required this.amount,
    required this.controller, 
    this.appliedAmount,
    required this.progressBarValue,
    this.unappliedAmount, 
    this.showInfoButton = false, 
    this.isShimmer = false,
    required this.onTap,
    this.canBlockFinancial = false,
  });
  
  final String title;
  final num amount;
  final num? appliedAmount;
  final num? unappliedAmount;
  final double progressBarValue;
  final bool showInfoButton; 
  final bool isShimmer;
  final bool canBlockFinancial;
  final VoidCallback onTap;
  final JobFinancialController controller;
 
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16,bottom: 20),
      child: Material(
        color: JPAppTheme.themeColors.base,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: canBlockFinancial ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row( 
                  children: [
                    JPText(text: title, textColor: JPAppTheme.themeColors.tertiary),
                    const SizedBox(width: 5),
                    if(showInfoButton)
                    InkWell(
                      highlightColor: JPColor.transparent,
                      splashColor: JPColor.transparent,
                      onLongPress: (){},
                      child: JPToolTip(
                        message: 'applying_credit_will_effect_amount_owed'.tr,
                        child: JPIcon(
                        Icons.info_outlined,
                        size: 18,
                        color: canBlockFinancial ? JPAppTheme.themeColors.primary.withValues(alpha: 0.5) : JPAppTheme.themeColors.primary
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                JPText(
                  textAlign: TextAlign.left,
                  text: canBlockFinancial ? '--' : JobFinancialHelper.getCurrencyFormattedValue(value: amount),
                  textSize: JPTextSize.size28, 
                  textColor: canBlockFinancial ? JPAppTheme.themeColors.text.withValues(alpha: 0.5) : JPAppTheme.themeColors.text,
                  fontWeight: JPFontWeight.bold,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 17, 
                                backgroundColor: canBlockFinancial ? JPAppTheme.themeColors.success.withValues(alpha: 0.5) : JPAppTheme.themeColors.success,
                                child: Icon(JobFinancialHelper.getCurrencyIcon(), color: JPAppTheme.themeColors.base)
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: JPRichText(
                                  text: JPTextSpan.getSpan('${'applied'.tr}: ',
                                    textColor: JPAppTheme.themeColors.tertiary,    
                                    children: [
                                      JPTextSpan.getSpan(JobFinancialHelper.getCurrencyFormattedValue(value: appliedAmount), 
                                      textColor: canBlockFinancial ? 
                                      JPAppTheme.themeColors.tertiary.withValues(alpha: 0.5) :
                                      JPAppTheme.themeColors.tertiary)
                                    ]
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children:[
                              CircleAvatar(
                                radius: 17, 
                                backgroundColor: canBlockFinancial ? JPAppTheme.themeColors.warning.withValues(alpha: 0.5) : JPAppTheme.themeColors.warning,
                                child: Icon(JobFinancialHelper.getCurrencyIcon(), color: JPAppTheme.themeColors.base)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: JPRichText(
                                  text: JPTextSpan.getSpan('${'unapplied'.tr}: ',
                                    textColor: JPAppTheme.themeColors.tertiary,    
                                    children: [
                                      JPTextSpan.getSpan(JobFinancialHelper.getCurrencyFormattedValue(value: unappliedAmount), 
                                      textColor: canBlockFinancial ? 
                                      JPAppTheme.themeColors.tertiary.withValues(alpha: 0.5) :
                                      JPAppTheme.themeColors.tertiary)
                                    ]
                                  ),
                                ),
                              ), 
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: isShimmer ? 0.0:amount != 0 ? progressBarValue : 0.0),
                      duration: const Duration(milliseconds: 500),
                      builder: (context, value, _) => Stack(
                        alignment: Alignment.center,
                        children: [
                          JPText(
                            text: controller.getCircularProgressBarPercentageValue(value),
                            textSize: JPTextSize.heading2,
                            fontWeight: JPFontWeight.bold,
                            textColor: canBlockFinancial ? JPAppTheme.themeColors.text.withValues(alpha: 0.5) : JPAppTheme.themeColors.text,
                          ),                      
                          Container(
                            margin: const EdgeInsets.only(right: 4,bottom: 4),
                            height: 100,
                            width: 100,
                            child: CircularProgressIndicator(
                              value: value,
                              backgroundColor : value == 0.0 ?
                              canBlockFinancial ? JPAppTheme.themeColors.inverse.withValues(alpha: 0.5) : JPAppTheme.themeColors.inverse
                              : JPAppTheme.themeColors.warning,
                              color: JPAppTheme.themeColors.success,
                              strokeWidth: 9.0,
                            ),
                          ),
                        ],
                      ),
                    ) 
                  ],
                ),
              ],
            )
          ),
        ),
      ),
    );              
  }
}
