import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class JobSwitcherShimmer extends StatelessWidget {
  const JobSwitcherShimmer({ super.key });

  @override
  Widget build(BuildContext context) {

    Widget getJobTile(int index){
      return ClipRRect(
        borderRadius: JPResponsiveDesign.bottomSheetRadius,
        child: Container(
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1,color: JPAppTheme.themeColors.inverse))
                ),
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          width: 143,
                          height: 10,
                          color :JPAppTheme.themeColors.dimGray,
                        ),
                        Container(
                          margin : const EdgeInsets.only(bottom: 12),
                          width: 85,
                          height: 10,
                          color :JPAppTheme.themeColors.dimGray,
                        ),

                        Container(
                          margin: const EdgeInsets.only(bottom: 3),
                          width: 143,
                          height: 10,
                          color :JPAppTheme.themeColors.dimGray,
                          )
                       ],
                    ),
                    SizedBox(
                      height: 15,
                      child: JPBadge(
                        text: '      ',
                        backgroundColor: JPAppTheme.themeColors.warning,
                        textColor:JPAppTheme.themeColors.dimGray,
                      ),
                    )
                  ],

                ),
            ),
      );
    }
    
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.30,
      ),
      child:ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 3,
        itemBuilder: ((context, index)=>Shimmer.fromColors(
          baseColor: JPAppTheme.themeColors.dimGray,
          highlightColor:JPAppTheme.themeColors.inverse,
          child: getJobTile(index))
           ))
         );
 
  }
}