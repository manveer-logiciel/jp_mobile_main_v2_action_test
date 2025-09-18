import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jp_mobile_flutter_ui/Button/color_type.dart';
import 'package:jp_mobile_flutter_ui/Button/index.dart';
import 'package:jp_mobile_flutter_ui/Button/size.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

import '../../../../../core/constants/assets_files.dart';
import '../../../../../global_widgets/attachments_detail/index.dart';
import '../controller.dart';

class AttachmentTile extends StatelessWidget {
  final BillFormController controller;
  const AttachmentTile({
    super.key,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(18.0)),
          color: JPAppTheme.themeColors.base,
        ),
        child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: JPAttachmentDetail(
          titleTextColor: JPAppTheme.themeColors.darkGray,
          attachments: controller.service.attachments,
          disabled: controller.isSavingForm,
          addCallback: controller.service.showFileAttachmentSheet,
          onTapCancelIcon: controller.service.removeAttachedItem,
          isEdit: true,
          headerActions: [
            JPButton(
              onPressed: controller.service.showFileAttachmentSheet,
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
        ));
  }
}
