import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class QuickBookErrorBottomSheetHeader extends StatelessWidget {
  final String title;
  const QuickBookErrorBottomSheetHeader({ super.key, required this.title });

  @override
  Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: JPText(
                      text: title,
                      fontWeight: JPFontWeight.medium,
                      textSize: JPTextSize.heading3,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
            Material(
              color: JPAppTheme.themeColors.base,
              child: JPTextButton(
                onPressed: (){
                   Get.back();
                },
                icon: Icons.close,
                iconSize: 24,
              ),
            )
          ],
        ),
      );
    }
  }
