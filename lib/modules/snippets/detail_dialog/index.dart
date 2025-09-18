import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/snippet_trade_script.dart';
import 'package:jobprogress/common/models/snippet_listing/snippet_listing.dart';
import 'package:jobprogress/global_widgets/html_viewer/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import 'controller.dart';

class SnippetDetailsDialog extends StatelessWidget {
  final SnippetListModel data;
  final STArg type;
  const SnippetDetailsDialog({super.key, required this.data, required this.type});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SnippetDetailDialogController());

    return JPSafeArea(
      child: AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        contentPadding: EdgeInsets.zero,
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
                      text: type == STArg.snippet
                          ? 'snippet_detail'.tr.toUpperCase()
                          : 'trade_script_detail'.tr.toUpperCase(),
                      textAlign: TextAlign.start,
                      textSize: JPTextSize.heading3,
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
                text: data.title!.capitalize!,
                textSize: JPTextSize.heading3,
                fontWeight: JPFontWeight.medium,
                textAlign: TextAlign.start,
                textColor: JPAppTheme.themeColors.text,
              ),
              const SizedBox(height: 8),
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: Get.height * 0.60),
                  child: SingleChildScrollView(
                    child: JPHtmlViewer(htmlContent: data.description!),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Center(
                child: JPButton(
                  size: JPButtonSize.small,
                  type: JPButtonType.solid,
                  colorType: JPButtonColorType.tertiary,
                  text: 'copy'.tr.toUpperCase(),
                  onPressed: () {
                    controller.copyText(
                      type == STArg.snippet
                          ? 'description_copied'.tr
                          : 'job_description_copied'.tr,
                      data.description ?? "",
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
