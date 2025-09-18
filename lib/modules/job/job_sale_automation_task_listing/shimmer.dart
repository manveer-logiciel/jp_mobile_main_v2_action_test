import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class  JobSaleAutomationTaskListingShimmer extends StatelessWidget {
  const  JobSaleAutomationTaskListingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JPAppTheme.themeColors.inverse, 
      body:Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right:16, bottom: 10),
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 8),
                  child: Column(
                    children: [
                     for(int i=0; i< 3; i++)
                      tileShimmer((i != 2))
                    ],
                  ),
                ),
              ),
            ),
          ),                        
        ],     
      ) 
    );
  }

   Widget tileShimmer(bool showBorder) {
    return Container(
      
      padding: const EdgeInsets.only(top: 16,),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 15),
            child: JPCheckbox(
              disabled: true,
              padding: EdgeInsets.zero,
              selected: true
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(bottom: 12),
              decoration: showBorder? BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: JPAppTheme.themeColors.inverse),
                ),
              ) : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  shimmerBox(height: 10, width: 60),
                  const SizedBox(
                    height: 10,
                  ),
                  shimmerBox(height: 6, width: 150),
                  const SizedBox(
                    height: 8,
                  ),
                  shimmerBox(height: 6, width: 120),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      shimmerBox(
                        height: 20,
                        width: 20,
                        borderRadius: 10,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      shimmerBox(height: 8, width: 60),
                    ],
                  ),
          
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget shimmerBox({
    required double height,
    required double width,
    double borderRadius = 3
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: JPAppTheme.themeColors.dimGray,
      ),
    );
  }

    }
       
