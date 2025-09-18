import 'package:flutter/material.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class JobFinancialListingCreditsShimmer extends StatelessWidget{
    const JobFinancialListingCreditsShimmer ({
      super.key,}); 
    
  @override
  Widget build(BuildContext context) { 
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics:  const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  for(int i = 0; i <= 10; i++)
                  Container(
                    decoration: BoxDecoration(
                      border:Border(
                        bottom: BorderSide(
                          width: 1,
                          color: JPAppTheme.themeColors.dimGray
                        )
                      ) 
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: 
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Shimmer.fromColors(
                                  baseColor: JPAppTheme.themeColors.dimGray,
                                  highlightColor: JPAppTheme.themeColors.inverse,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(vertical: 2),
                                    height: 10,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: JPAppTheme.themeColors.base,
                                    ),
                                    child: JPText(
                                      text: '05/25/2022',
                                      textColor: JPAppTheme.themeColors.base
                                    ),
                                  )
                                ),
                                const SizedBox(height: 7),
                                Shimmer.fromColors(
                                  baseColor: JPAppTheme.themeColors.dimGray,
                                  highlightColor: JPAppTheme.themeColors.inverse,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(vertical: 3),
                                      height: 10,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: JPAppTheme.themeColors.base,
                                      ),
                                    child: Row(
                                      children: [
                                        JPText(
                                          text: 'Applied : ',
                                          textSize: JPTextSize.heading5,
                                          textColor:JPAppTheme.themeColors.dimGray
                                        ),
                                        JPText(
                                          text:'0.0',
                                          textSize: JPTextSize.heading5,
                                          textColor:JPAppTheme.themeColors.dimGray,
                                        ),
                                        JPText(
                                          text: 'Applied : ',
                                          textSize: JPTextSize.heading5,
                                          textColor:JPAppTheme.themeColors.dimGray
                                        ),
                                        JPText(
                                          text:'0.0',
                                          textSize: JPTextSize.heading5,
                                          textColor:JPAppTheme.themeColors.dimGray,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                               
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Shimmer.fromColors(
                                  baseColor: JPAppTheme.themeColors.dimGray,
                                  highlightColor: JPAppTheme.themeColors.inverse,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(vertical: 3),
                                    height: 10,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: JPAppTheme.themeColors.base,
                                    ),
                                    child: JPText(
                                      text: JobFinancialHelper.getCurrencyFormattedValue(value: '346.25'),
                                      textSize: JPTextSize.heading3,
                                      textColor: JPAppTheme.themeColors.primary,
                                      fontWeight: JPFontWeight.medium,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )   
        ],
      ),
    );
  }
}



