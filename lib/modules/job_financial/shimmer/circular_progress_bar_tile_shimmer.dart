import 'package:flutter/material.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';

class JobFinancialCircularProgresBarTileShimmer extends StatelessWidget {
  
  const JobFinancialCircularProgresBarTileShimmer({
    super.key, 
    required this.title, 
    required this.amount, 
    required this.appliedAmount, 
    required this.unappliedAmount,
    this.showInfoButton = false, 
  });
  
  final String title;
  final String amount;
  final String appliedAmount;
  final String unappliedAmount;
  final bool showInfoButton; 
  
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
      decoration: BoxDecoration(color: JPAppTheme.themeColors.base, borderRadius: BorderRadius.circular(18)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    JPText(text: title, textColor: JPAppTheme.themeColors.tertiary),
                    if(showInfoButton)
                    JPTextButton(onPressed: (){}, icon: Icons.info_outlined, color: JPAppTheme.themeColors.primary,)
                  ],
                ),
                const SizedBox(height: 5),
                Shimmer.fromColors(
                  baseColor: JPAppTheme.themeColors.dimGray,
                  highlightColor: JPAppTheme.themeColors.inverse,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: JPAppTheme.themeColors.inverse,
                    ),
                    margin: const EdgeInsets.only(top: 13, bottom: 5),
                    height: 10,
                    width: 100,
                  ),
                ),             
                const SizedBox(height: 20),
                Row(
                  children:[
                    CircleAvatar(radius:17, backgroundColor: JPAppTheme.themeColors.success, child:Icon(JobFinancialHelper.getCurrencyIcon(), color: JPAppTheme.themeColors.base)),
                    const SizedBox(width: 10),
                    JPText(text: '${'applied'.tr}: ', textColor: JPAppTheme.themeColors.tertiary,),
                    Shimmer.fromColors(
                      baseColor: JPAppTheme.themeColors.dimGray,
                      highlightColor: JPAppTheme.themeColors.inverse,
                      child: Container(
                        margin: const EdgeInsets.only(top: 3, bottom: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: JPAppTheme.themeColors.inverse,
                        ),
                        height: 8,
                        width: 50,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CircleAvatar(radius:17, backgroundColor: JPAppTheme.themeColors.warning, child:Icon(JobFinancialHelper.getCurrencyIcon(), color: JPAppTheme.themeColors.base)),
                    const SizedBox(width: 10),
                    Row(
                      children: [
                        JPText(text: '${'unapplied'.tr}: ', textColor: JPAppTheme.themeColors.tertiary),
                        Shimmer.fromColors(
                          baseColor: JPAppTheme.themeColors.dimGray,
                          highlightColor: JPAppTheme.themeColors.inverse,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: JPAppTheme.themeColors.inverse,
                            ),
                            margin: const EdgeInsets.only(top: 3, bottom: 3),
                            height: 8,
                            width: 40,
                          ),
                        ),
                      ],
                    )
                  ] ,
                )
              ],
            ),
          ),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 0.0),
            duration: const Duration(milliseconds: 2500),
            builder: (context, value, _) => Stack(
              alignment: Alignment.center,
              children: [
                const JPText(
                  text: '0 %',
                  textSize: JPTextSize.heading2,
                  fontWeight: JPFontWeight.bold,
                ),                      
                SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    value: value,
                    backgroundColor:value == 0.0 ? JPAppTheme.themeColors.inverse : JPAppTheme.themeColors.warning,
                    color: JPAppTheme.themeColors.success,
                    strokeWidth: 9.0,
                  ),
                ),
              ],
            ),
          )   
        ],
      )
    );   
  }
}
