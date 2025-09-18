
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jobprogress/common/services/task/create_task_form.dart';
import 'package:jobprogress/global_widgets/attachments_detail/index.dart';
import 'package:jobprogress/modules/task/create_task/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../core/constants/assets_files.dart';

class CreateTaskAttachmentSection extends StatelessWidget {
  const CreateTaskAttachmentSection({
    super.key,
    required this.controller
  });

  final CreateTaskFormController controller;

  CreateTaskFormService get service => controller.service;

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
              attachments: service.attachments,
              disabled: controller.isSavingForm,
              addCallback: service.showFileAttachmentSheet,
              onTapCancelIcon: service.removeAttachedItem,
              isEdit: true,
              headerActions: [
                JPButton(
                  onPressed: service.showFileAttachmentSheet,
                  colorType: JPButtonColorType.lightBlue,
                  size: JPButtonSize.smallIcon,
                  disabled: controller.isSavingForm,
                  iconWidget: SvgPicture.asset(
                      AssetsFiles.addIcon,
                      width: 10,
                      height: 10,
                      colorFilter: ColorFilter.mode(
                          JPAppTheme.themeColors.primary,
                          BlendMode.srcIn)
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
