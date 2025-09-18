import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CallLogListingHeader extends StatelessWidget {
  const CallLogListingHeader({ super.key });

  @override
  Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                JPText(
                  text: 'call_logs'.tr.toUpperCase(),
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
                    icon: const JPIcon(
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
