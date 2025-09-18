import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/third_party_tools/all_trades.dart';
import 'package:jobprogress/global_widgets/network_image/index.dart';
import 'package:jp_mobile_flutter_ui/Avatar/index.dart';
import 'package:jp_mobile_flutter_ui/Avatar/size.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/color.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/font_weight.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/text_size.dart';
import 'package:jp_mobile_flutter_ui/ReadMoreText/index.dart';
import 'package:jp_mobile_flutter_ui/Text/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

class ThirdPartyToolsTiles extends StatelessWidget {
  const ThirdPartyToolsTiles({
    super.key,
    required this.thirdPartyTools,
    required this.index,
    this.onTap,
  });

  final List<ThirdPartyToolsModel> thirdPartyTools;
  final int index;
  final Function(int currentIndex)? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JPColor.transparent,
      child: InkWell(
        onTap: onTap != null ? () => onTap!.call(index) : null,
        child: Padding(
          padding: const EdgeInsets.only(right: 10, left: 16, top: 10),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  JPAvatar(
                    size: JPAvatarSize.large,
                    child: JPNetworkImage(
                      src: thirdPartyTools[index].thumb.toString(),
                      boxFit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  JPText(
                                    text: thirdPartyTools[index].title?.capitalize.toString() ?? "",
                                    fontWeight: JPFontWeight.medium,
                                    textSize: JPTextSize.heading4,
                                    textAlign: TextAlign.start,
                                    maxLine: 1,
                                    overflow: TextOverflow.clip,
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  JPReadMoreText(
                                    thirdPartyTools[index].description?.capitalizeFirst ?? '',
                                    textColor: JPAppTheme.themeColors.tertiary,
                                    textSize: JPTextSize.heading5,
                                    textAlign: TextAlign.start,
                                    trimLines: 1,
                                    dialogTitle: thirdPartyTools[index].title ?? '',
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: JPAppTheme.themeColors.dimGray,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
