import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../core/constants/assets_files.dart';

class CalendarEventShimmerTile extends StatelessWidget {
  const CalendarEventShimmerTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: JPAppTheme.themeColors.dimGray, width: 2.8),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              shimmerBox(height: 5, width: 100),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          shimmerBox(height: 10, width: double.maxFinite),
                          const SizedBox(height: 5,),
                          shimmerBox(height: 6, width: 100),
                        ],
                      ),
                    ),
                    Container(
                        height: 15,
                        width: 24,
                        margin: const EdgeInsets.only(left: 6.5),
                        child: const FittedBox(
                          fit: BoxFit.cover,
                          child: JPIcon(
                            Icons.attachment_outlined,
                            textDirection: TextDirection.ltr,
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Image.asset(AssetsFiles.recurringIcon, width: 13, height: 14),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              shimmerBox(height: 6, width: double.maxFinite),
              const SizedBox(
                height: 5,
              ),
              shimmerBox(height: 6, width: double.maxFinite),
              const SizedBox(
                height: 5,
              ),
              shimmerBox(height: 6, width: 150),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              shimmerBox(height: 22, width: 22, borderRadius: 11),
              const SizedBox(
                width: 10,
              ),
              shimmerBox(height: 8, width: 50),
            ],
          ),
        ],
      ),
    );
  }

  Widget shimmerBox(
      {required double height,
      required double width,
      double borderRadius = 3}) {
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
