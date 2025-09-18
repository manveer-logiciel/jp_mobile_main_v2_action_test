import 'package:flutter/material.dart';
import 'package:jobprogress/global_widgets/attachments_detail/index.dart';
import 'package:jobprogress/modules/support/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class SupportAttachmentSection extends StatelessWidget {
  const SupportAttachmentSection({
    super.key,
    required this.controller
  });

  final SupportFormController controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JPAppTheme.themeColors.base,
      borderRadius: BorderRadius.circular(controller.formUiHelper.sectionBorderRadius),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: controller.formUiHelper.verticalPadding
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            JPAttachmentDetail(
              titleTextColor: JPAppTheme.themeColors.darkGray,
              attachments: controller.attachments,
              disabled: controller.isSavingForm,
              addCallback: controller.showFileAttachmentSheet,
              onTapCancelIcon: controller.removeAttachedItem,
              isEdit: true,
            ),
          ],
        ),
      ),
    );
  }
}