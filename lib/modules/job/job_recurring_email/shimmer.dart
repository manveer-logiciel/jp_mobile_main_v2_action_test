import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class JobRecurringEmailShimmer extends StatelessWidget{
    const JobRecurringEmailShimmer ({
      super.key,}); 
    
  @override
  Widget build(BuildContext context) { 
    return Column(
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
                    color: JPAppTheme.themeColors.base,
                  ),
                  padding: const EdgeInsets.only(left: 16, top: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8,right: 5),
                            padding: const EdgeInsets.all(6),
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: JPAppTheme.themeColors.lightBlue
                            ),
                            child: Icon(Icons.schedule_send_outlined,
                            color: JPAppTheme.themeColors.primary,
                            size: 18,
                            ),
                          ),                   
                        ],
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(right: 16,bottom: 12,top: 7),
                          decoration:BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                              width: 1,
                              color: JPAppTheme.themeColors.dimGray)
                            )  
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children:[
                                        Shimmer.fromColors(
                                          baseColor: JPAppTheme.themeColors.dimGray,
                                          highlightColor: JPAppTheme.themeColors.inverse,
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(vertical: 2),
                                            height: 8,
                                            width: 108,
                                            decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: JPAppTheme.themeColors.base,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Shimmer.fromColors(
                                      baseColor: JPAppTheme.themeColors.dimGray,
                                      highlightColor: JPAppTheme.themeColors.inverse,
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(vertical: 4),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: JPAppTheme.themeColors.base,
                                        ),
                                        height: 7,
                                      ),
                                    ),
                                    Shimmer.fromColors(
                                      baseColor: JPAppTheme.themeColors.dimGray,
                                      highlightColor: JPAppTheme.themeColors.inverse,
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(vertical: 4),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: JPAppTheme.themeColors.base,
                                        ),
                                        height: 7,
                                        width: 80,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Shimmer.fromColors(
                                      baseColor: JPAppTheme.themeColors.dimGray,
                                      highlightColor: JPAppTheme.themeColors.inverse,
                                      child: Container(
                                        height: 7,
                                        width: 50,
                                        padding: const EdgeInsets.only(top: 5.0),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: JPAppTheme.themeColors.base,
                                        ),
                                      ),
                                    ) ,
                                    const SizedBox(height: 11),
                                    Column(
                                      children: [ 
                                        for(int j = 0; j <= 1; j++)
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                               Stack(
                                                children: [
                                                  VerticalDivider(
                                                    color: JPAppTheme.themeColors.primary,
                                                    thickness: 2,
                                                    width: 12,
                                                    indent: 18,
                                                  ),
                                                  Transform.translate(
                                                    offset: const Offset(0, -2),
                                                    child: Container(
                                                      height: 12,
                                                      width: 12,
                                                      margin: const EdgeInsets.only(top: 5),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: JPAppTheme.themeColors.lightBlue, width: 2),
                                                          shape: BoxShape.circle,
                                                          color: JPAppTheme.themeColors.primary,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(width: 12),
                                              Shimmer.fromColors(
                                                baseColor: JPAppTheme.themeColors.dimGray,
                                                highlightColor: JPAppTheme.themeColors.inverse,
                                                child: Container(
                                                  height: 7,
                                                  width: 200,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: JPAppTheme.themeColors.base,
                                                  ),
                                                ),
                                              ),
                                            ],
                                            ),
                                            if( j == 0)
                                            Row(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(left: 5),
                                                  height: 12,
                                                  width: 2,
                                                  color: JPAppTheme.themeColors.lightBlue,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),   
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              JPIcon(
                                Icons.more_vert_outlined,
                                color: JPAppTheme.themeColors.tertiary,
                                size: 24,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )   
      ],
    );
  }
}



