import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/controller.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jp_mobile_flutter_ui/IconButton/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobCategoryEditDialog extends StatelessWidget {
  const JobCategoryEditDialog({
    required this.textController,
    this.onTap,
    this.showInsuranceClaim = false,
    this.onTapInsuranceClaim,
    required this.dialogController,
    required this.onSave,
    Key? key, required this.onCancel,
  }) : super(key: key);

  final JPInputBoxController textController;
  final VoidCallback? onTap;
  final bool showInsuranceClaim;
  final VoidCallback? onTapInsuranceClaim;
  final JPBottomSheetController dialogController;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0))
      ),
      content: SizedBox(
        width: Get.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            _buildContent(),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: JPText(
              text: 'category'.tr,
              textSize: JPTextSize.heading3,
              fontWeight: JPFontWeight.medium,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            splashRadius: 20,
            onPressed: onCancel,
            icon: const JPIcon(Icons.clear),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: JPInputBox(
            inputBoxController: textController,
            fillColor: JPAppTheme.themeColors.base,
            readOnly: true,
            onPressed: onTap,
            suffixChild: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: FormUiHelper().horizontalPadding,
              ),
              child: JPIcon(
                Icons.keyboard_arrow_down_outlined,
                color: JPAppTheme.themeColors.text,
              ),
            ),
          ),
        ),
        if (showInsuranceClaim) ...[
          const SizedBox(width: 12),
          _buildInsuranceClaimButton(),
        ],
      ],
    );
  }

  Widget _buildInsuranceClaimButton() {
    return Opacity(
      opacity: 1,
      child: JPIconButton(
        icon: Icons.assignment_outlined,
        backgroundColor: JPAppTheme.themeColors.lightBlue,
        iconColor: JPAppTheme.themeColors.primary,
        iconSize: 22,
        onTap: onTapInsuranceClaim,
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: JPButton(
        onPressed: onSave,
        iconWidget: showJPConfirmationLoader(show: dialogController.isLoading),
        disabled: dialogController.isLoading,
        size: JPButtonSize.small,
        text: dialogController.isLoading ?
        '' : 'save'.tr.toUpperCase()
      ),
    );
  }
}