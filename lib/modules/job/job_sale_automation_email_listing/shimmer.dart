import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class  JobSaleAutomationEmailListingShimmer extends StatelessWidget {
  const  JobSaleAutomationEmailListingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16,left: 16,right:16,bottom: 10),
          child: Row(
            children:  [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: JPAppTheme.themeColors.dimGray
                ),
                height: 13,
                width: Get.width * 0.50,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left:16,right:16,bottom: 15),
          child: Row(
            children: [   
              Shimmer.fromColors(
                baseColor: JPAppTheme.themeColors.dimGray,
                highlightColor:JPAppTheme.themeColors.inverse ,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: JPAppTheme.themeColors.inverse
                  ),
                  height: 13,
                  width: Get.width * 0.30,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius:BorderRadius.all(Radius.circular(18)),
                color: Colors.white,  
                ),
              padding: const EdgeInsets.symmetric(),
              child: Column(
                children: [
                  for(int i=0; i< 3; i++)
                  messageTile(i)  
                ],
              ),
            ),
          ),
        ),                        
      ],     
    ); 
  }
   Widget messageTile(int i) {
      return Padding(
        padding: const EdgeInsets.only(top:12,left: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 9),
              child: JPCheckbox(
                disabled: true,
                padding: EdgeInsets.zero,
                selected: true,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(bottom: 12, right: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom:BorderSide(
                    color:  i == 2  ?  JPAppTheme.themeColors.base: JPAppTheme.themeColors.dimGray
                    ),
                  )
                ),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Row(
                      children: [
                        Shimmer.fromColors(
                          baseColor: JPAppTheme.themeColors.dimGray,
                          highlightColor: JPAppTheme.themeColors.inverse,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: JPAppTheme.themeColors.dimGray,
                            ),
                            height:8,
                            width: Get.width * 0.30,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const JPIcon(Icons.attachment_outlined)
                      ],
                    ),
                    const SizedBox(height: 7),
                    Shimmer.fromColors(
                      baseColor: JPAppTheme.themeColors.dimGray,
                      highlightColor: JPAppTheme.themeColors.inverse,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: JPAppTheme.themeColors.dimGray,
                        ),
                        height:8,
                        width: Get.width * 0.20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(   
                      borderRadius:BorderRadius.circular(8),
                      color: JPAppTheme.themeColors.inverse.withValues(alpha: 0.4),
                      ),  
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Shimmer.fromColors(
                                baseColor: JPAppTheme.themeColors.dimGray,
                                highlightColor: JPAppTheme.themeColors.inverse,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: JPAppTheme.themeColors.dimGray,
                                  ),
                                  height:8,
                                  width: 50,
                                ),
                              ),
                              JPToggle(
                                disabled: true,
                                value: false, 
                                onToggle: (value){ 
                                }
                              ), 
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
       