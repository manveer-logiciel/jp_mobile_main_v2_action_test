
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobSinceDateConfirmation extends StatelessWidget {
  const JobSinceDateConfirmation({
    super.key,
    required this.stageName,
    required this.stageColor,
    this.onConfirm,
    this.isLoading = false
  });

  final String stageName;

  final Color? stageColor;

  final VoidCallback? onConfirm;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return JPConfirmationDialog(
      title: 'confirmation'.tr,
      icon: Icons.warning_amber,
      content: JPRichText(
        textAlign: TextAlign.center,
        text: JPTextSpan.getSpan("", children: [
          JPTextSpan.getSpan(
            'job_since_date_confirmation_desc_1'.tr,
            textSize: JPTextSize.heading5,
            textColor: JPAppTheme.themeColors.darkGray,
            height: 1.5,
          ),
          JPTextSpan.getSpan(
            ' $stageName ',
            textSize: JPTextSize.heading5,
            fontWeight: JPFontWeight.medium,
            textColor: stageColor,
            height: 1.5,
          ),
          JPTextSpan.getSpan(
            'job_since_date_confirmation_desc_2'.tr,
            textSize: JPTextSize.heading5,
            textColor: JPAppTheme.themeColors.darkGray,
            height: 1.5,
          ),
        ],
        ),
      ),
      suffixBtnIcon: showJPConfirmationLoader(
        show: isLoading
      ),
      suffixBtnText: isLoading ? '' : 'confirm'.tr,
      onTapSuffix: onConfirm,
      disableButtons: isLoading,
    );
  }
}
