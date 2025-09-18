import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/html_viewer/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class AnnouncementDetail extends StatelessWidget {
  const AnnouncementDetail({
    super.key,
    required this.title,
    required this.description
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return JPSafeArea(
      child: AlertDialog(
        scrollable: true,
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: JPText(
                      text: 'announcement'.tr.toUpperCase(),
                      textAlign: TextAlign.start,
                      textSize: JPTextSize.heading3,
                      fontWeight: JPFontWeight.medium,
                    ),
                  ),
                  JPTextButton(
                    icon: Icons.clear,
                    color: JPAppTheme.themeColors.text,
                    iconSize: 24,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              const SizedBox(height: 10),
              JPText(
                text: title.capitalize!,
                textSize: JPTextSize.heading3,
                textAlign: TextAlign.start,
                textColor: JPAppTheme.themeColors.text,
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: Get.height*0.60,
                  minWidth: Get.width
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: JPHtmlViewer(htmlContent: Helper.removeHtmlAttributes(description, ['id', 'name'])),  
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}