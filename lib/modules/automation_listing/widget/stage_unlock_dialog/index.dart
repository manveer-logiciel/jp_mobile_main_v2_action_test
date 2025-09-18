import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class StageUnlockDialog extends StatelessWidget {
  const StageUnlockDialog({super.key, });

  @override
  Widget build(BuildContext context) {
    return JPSafeArea(
      child: AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0))),
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: JPText(
                      text: 'stage_unlock'.tr.toUpperCase(),
                      textAlign: TextAlign.start,
                      textSize: JPTextSize.heading1,
                      fontWeight: JPFontWeight.medium,
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(10, 0),
                    child: JPTextButton(
                      icon: Icons.clear,
                      color: JPAppTheme.themeColors.text,
                      iconSize: 24,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10,),
              JPText(
                text: 'stage_unlock_description'.tr,
                textSize: JPTextSize.heading3,
                textAlign: TextAlign.start,
                textColor: JPAppTheme.themeColors.text,
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}
