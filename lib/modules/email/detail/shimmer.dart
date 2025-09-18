import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class EmailDetailShimmer extends StatelessWidget {
  const EmailDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JPAppTheme.themeColors.inverse, 
      body:SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
              Padding(
              padding: const EdgeInsets.only(top: 16,left: 16,right:16,bottom: 10),
              child: Row(
                children:  [
                  Expanded(
                    child: Container(
                      height: 13,
                     
                      color: JPAppTheme.themeColors.dimGray,
                ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:16,right:16,bottom: 15),
              child: Row(
                children: [   
                  Container(
                    height: 13,
                    width: MediaQuery.of(context).size.width*0.50,
                  
                     color: JPAppTheme.themeColors.dimGray,
                  ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius:BorderRadius.all(Radius.circular(18)),
                color: Colors.white,  
                ),
              padding: const EdgeInsets.only(left:16,right: 16,bottom: 30),
              margin: EdgeInsets.symmetric(
                horizontal: JPScreen.isDesktop ? 16 : 0
              ),
              child: Shimmer.fromColors(
                baseColor:JPAppTheme.themeColors.dimGray,
                highlightColor:JPAppTheme.themeColors.inverse,
                child: Column(children: [
                    messageTile(),
                   messageTile(),
                   messageTile(),
                ],),
              ),
            ),                
              
          ],
        
        ),
      )
       
    );
   
  }

  Widget messageTile() {
    return Container(
      padding:  const EdgeInsets.only(top:16,bottom: 30),
      decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: JPAppTheme.themeColors.dimGray, width: 1)
        )
      ),
      child: Column(
      children: [
        Row( 
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child:JPAvatar(
                  size: JPAvatarSize.small,
            backgroundColor: JPAppTheme.themeColors.inverse,
                  child:JPText(
                    text:  '',
                    textSize: JPTextSize.heading3,
                    textColor: JPAppTheme.themeColors.inverse,
                    ),
          ),
        ),
            ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom:4),
                  child: Row(  
                    children: [
                        Expanded(
                        child: Container(
                        height: 10,  
                        color: JPAppTheme.themeColors.inverse,
                      )),  
                      Padding(
                        padding: const EdgeInsets.only(left: 5,right:15),
                        child: Container(
                        height: 10,  
                        width: 50,
                        color: JPAppTheme.themeColors.inverse,
                      )
                      )
                    ],
                  ),
                ),      
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Container(height: 10,color: JPAppTheme.themeColors.dimGray,)
                      ),
                    ),
                    JPTextButton(
                    onPressed: (){},
                    icon: Icons.expand_more_outlined,
                    color: JPAppTheme.themeColors.tertiary)
                  ],
                ),
              ],
            ),
          ),
        ),
      
        JPTextButton(
          onPressed: (){},
          icon: Icons.more_vert_outlined,
          color: JPAppTheme.themeColors.tertiary,
          iconSize: 24,
          )
        ],
        ),
        Container(height: 219,width: 343,color: JPColor.lightGray,)                          
        ],
),
);
  }

}