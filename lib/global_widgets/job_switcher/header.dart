import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/IconButton/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobSwitcherListingHeader extends StatelessWidget {
  final String title;
  final bool isBackArrowVisible;
  final VoidCallback? onBackPress;
  const JobSwitcherListingHeader({ super.key, required this.title , this.isBackArrowVisible = false, this.onBackPress});

  @override
  Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 17, bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Visibility(
                  visible: isBackArrowVisible,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: JPIconButton(
                      backgroundColor: JPAppTheme.themeColors.base,
                      icon: Icons.arrow_back,
                      iconColor: JPAppTheme.themeColors.text,
                      iconSize: 24,
                      onTap: onBackPress,
                    ),
                  ),
                ),
                JPText(
                  text: title,
                  fontWeight: JPFontWeight.medium,
                  textSize: JPTextSize.heading3,
                ),
              ],
            ),
            Row(
              children: [
                Material(
                  shape: const CircleBorder(),
                  color: JPAppTheme.themeColors.base,
                  clipBehavior: Clip.hardEdge,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minHeight: 30, minWidth: 30),
                    icon: const Icon(
                      Icons.close,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
