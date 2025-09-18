import 'package:flutter/material.dart';
import 'package:jobprogress/global_widgets/network_image/index.dart';
import 'package:jp_mobile_flutter_ui/Thumb/image_thumb.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';


class DocumentExpiredShimmer extends StatelessWidget {

  const DocumentExpiredShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 16,bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: JPAppTheme.themeColors.dimGray,
                    width: 1
                  )
                ),
                padding: const EdgeInsets.all(10) ,
                child:const SizedBox(
                  width: 125,
                  height: 125,
                  child: 
                  JPThumbImage(
                    borderRadius: BorderRadius.zero,
                    thumbImage: 
                    JPNetworkImage(
                      borderRadius: 4,
                      src: '',
                      boxFit: BoxFit.cover,
                    ),
                  ) 
                )
              ),
              Container(
                padding: const EdgeInsets.only(top: 10,left: 16),
                child: Shimmer.fromColors(
                  baseColor: JPAppTheme.themeColors.dimGray,
                  highlightColor: JPAppTheme.themeColors.inverse,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      shimmerBox(height: 8, width: 100, verticalPadding: 20),
                      const SizedBox(height: 9),
                      shimmerBox(height: 8, width: 56, verticalPadding: 4),
                      const SizedBox(height: 15),
                      const JPButton(
                        colorType: JPButtonColorType.lightGray,
                        size: JPButtonSize.extraSmall,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
       
        const Divider(),
        Container(
            padding: const EdgeInsets.all(16),
            child: Shimmer.fromColors(
              baseColor: JPAppTheme.themeColors.dimGray,
              highlightColor: JPAppTheme.themeColors.inverse,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerBox(height: 10, width: 40,verticalPadding: 8),
                  const DateDescriptionTileShimmer(),
                  const DateDescriptionTileShimmer(
                    
                  ),
                  const DateDescriptionTileShimmer(
                  ),
                ],  
              ),
            ),
          ),
      ],
    ); 
  }
}

class DateDescriptionTileShimmer extends StatelessWidget {
  const DateDescriptionTileShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          shimmerBox(height: 8, width: 60,),
          shimmerBox(height: 8, width: 60,)
       ],
     ),
    );
  }
}

Widget shimmerBox({
    required double height,
    required double width,
    double verticalPadding =20,
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
