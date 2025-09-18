import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class JobFinancialCommanTileShimmer extends StatelessWidget {
  const JobFinancialCommanTileShimmer({
    super.key, 
    required this.circleAvtarBackgroundColor, 
    required this.circleAvtarIcon, 
    required this.circleAvtarIconColor, 
    required this.title, this.amountColor, 
    this.showInfoButton = false,
  });
  
  final Color circleAvtarBackgroundColor; 
  final IconData circleAvtarIcon;
  final Color circleAvtarIconColor;
  final String title;
  final Color? amountColor;
  final bool showInfoButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
      decoration: BoxDecoration(color: JPAppTheme.themeColors.base, borderRadius: BorderRadius.circular(18)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          CircleAvatar(
            radius: 25,
            backgroundColor: circleAvtarBackgroundColor,
            child: JPIcon(circleAvtarIcon,size: 24,color:circleAvtarIconColor),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Wrap(
                children: [
                  JPText(
                    text: title, 
                    textColor: JPAppTheme.themeColors.tertiary,
                    textAlign: TextAlign.left,
                  ),
                  if(showInfoButton)
                  JPTextButton(onPressed: (){}, icon: Icons.info_outlined, color: JPAppTheme.themeColors.primary,),
                ],
              ),
               const SizedBox(height: 5),  
                Shimmer.fromColors(
                  baseColor: JPAppTheme.themeColors.dimGray,
                  highlightColor: JPAppTheme.themeColors.inverse,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:BorderRadius.circular(5),
                      color: JPAppTheme.themeColors.inverse,
                    ),
                    margin: const EdgeInsets.only(top: 6, bottom: 6),
                    height: 8,
                    width: 100,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
