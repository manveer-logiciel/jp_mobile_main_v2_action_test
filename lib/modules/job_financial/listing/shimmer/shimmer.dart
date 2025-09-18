import 'package:flutter/material.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class JobFinancialListingCommonShimmer extends StatelessWidget{
  const JobFinancialListingCommonShimmer ({
    super.key, required, 
    this.showInclusiveTax = false, 
    this.showIcon = false,
  });
    
  
  final bool showInclusiveTax;
  final bool showIcon;
 
  @override
  Widget build(BuildContext context) { 
    return  Expanded(
      child: SingleChildScrollView(
        physics:  const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top:16,left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: JPAppTheme.themeColors.dimGray,
                    highlightColor: JPAppTheme.themeColors.inverse,
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: JPAppTheme.themeColors.inverse 
                      ),
                      child: const JPText(text: '123456466566565656', textSize: JPTextSize.heading6,),
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Shimmer.fromColors(
                    baseColor: JPAppTheme.themeColors.dimGray,
                    highlightColor: JPAppTheme.themeColors.inverse,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: JPAppTheme.themeColors.inverse 
                      ),
                      child: const JPText(text: '1234564665665600005656', textSize: JPTextSize.heading6,),
                    ),
                  ),
                ],
              ),
            ),
            for(int i = 0; i <= 20; i++)
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: JPAppTheme.themeColors.dimGray
                  )
                ) 
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            color: JPAppTheme.themeColors.base
                          ),
                          child: JPText(
                            textSize: JPTextSize.heading5,
                            text: '05/25/2022 09:26 aM',
                            textColor: JPAppTheme.themeColors.base),
                        )
                      ),
                      const SizedBox(height: 7),
                      Shimmer.fromColors(
                        baseColor: JPAppTheme.themeColors.dimGray,
                        highlightColor: JPAppTheme.themeColors.inverse,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: JPAppTheme.themeColors.base 
                          ),
                          child: JPText(
                            text: 'Order #. 6',
                            textSize: JPTextSize.heading5,
                            textColor: JPAppTheme.themeColors.tertiary
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Shimmer.fromColors(
                        baseColor: JPAppTheme.themeColors.dimGray,
                        highlightColor: JPAppTheme.themeColors.inverse,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: JPAppTheme.themeColors.base,
                          ),
                          child: JPText(
                            textSize: JPTextSize.heading5,
                            text: JobFinancialHelper.getCurrencyFormattedValue(value: '346.25'),
                            textColor: JPAppTheme.themeColors.primary,
                            fontWeight: JPFontWeight.medium,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      if(i % 2 == 0 && showInclusiveTax)
                      Shimmer.fromColors(
                        baseColor: JPAppTheme.themeColors.dimGray,
                        highlightColor: JPAppTheme.themeColors.inverse,
                        child: Container(
                          height: 10,
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: JPAppTheme.themeColors.base
                          ),
                          child: JPText(
                          text: '(Inclusive Tax)',
                          textSize: JPTextSize.heading6,
                          textColor: JPAppTheme.themeColors.tertiary,
                          ),
                        ),
                      ),
                      if(i % 2 == 0 && showIcon)
                      Shimmer.fromColors(
                        baseColor: JPAppTheme.themeColors.dimGray,
                        highlightColor: JPAppTheme.themeColors.inverse,
                        child: JPAvatar(
                          backgroundColor: JPAppTheme.themeColors.dimGray,
                          size: JPAvatarSize.small,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
