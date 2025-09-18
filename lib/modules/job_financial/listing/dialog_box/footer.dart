import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/job_financial/listing/dialog_box/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class PayCommissionDialogFooter extends StatelessWidget {
  const PayCommissionDialogFooter({
    super.key,
    required this.controller,
    required this.onApply});

  final PayCommissionDialogController controller;
  final void Function(FinancialListingModel model, String action) onApply;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: JPResponsiveDesign.popOverButtonFlex,
            child: JPButton(
              text: 'cancel'.tr.toUpperCase(),
              onPressed: () {
                Helper.hideKeyboard();
                Get.back();
              },
              disabled: controller.isLoading,
              fontWeight: JPFontWeight.medium,
              size: JPButtonSize.small,
              colorType: JPButtonColorType.lightGray,
              textColor: JPAppTheme.themeColors.tertiary,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            flex: JPResponsiveDesign.popOverButtonFlex,
            child: JPButton(
              onPressed: () => controller.onSave(onApply),
              text: controller.isLoading
                  ? ""
                  : "proceed".tr.toUpperCase(),
              fontWeight: JPFontWeight.medium,
              size: JPButtonSize.small,
              colorType: JPButtonColorType.primary,
              textColor: JPAppTheme.themeColors.base,
              iconWidget: showJPConfirmationLoader(show: controller.isLoading),
              disabled: controller.isLoading,
            ),
          )
        ]
      ),
    );
  }
}
