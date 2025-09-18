import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/worksheet/supplier_form_params.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/form_builder/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';
import 'shimmer.dart';
import 'widget/job_account/index.dart';

class MaterialSupplierForm extends StatelessWidget {
  const MaterialSupplierForm({
    super.key,
    required this.params,
  });

  final MaterialSupplierFormParams params;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MaterialSupplierFormController>(
      init: MaterialSupplierFormController(params: params),
      global: false,
      builder: (controller) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: JPFormBuilder(
          backgroundColor: JPAppTheme.themeColors.base,
          title: controller.getTitle,
          subTitle: controller.getSubtitle,
          inBottomSheet: true,
          isCancelIconVisible: false,
          form: Form(
            key: controller.formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: controller.formUiHelper.horizontalPadding,
                  vertical: params.isDefaultBranchSaved ? 0 : controller.formUiHelper.verticalPadding),
              child: controller.isLoading
                ? SelectSrsBranchShimmer(
                showThreeField: controller.showJobAccounts && controller.showSelectedBranchJobAccounts,
              )
                : params.isDefaultBranchSaved
                  ? Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisSize: MainAxisSize.min,
                     children: [
                      // Account Name
                      textWithLabel("account_name".tr.capitalize!, params.selectedAccountName),
                      const SizedBox(height: 20),
                      // Branch
                      textWithLabel("branch".tr.capitalize!, params.selectedBranchName),
                      const SizedBox(height: 20),

                      // Job Account
                      if(!Helper.isTrue(params.excludeJob) && params.beaconJob != null) ...{
                       textWithLabel("job_account".tr.capitalize!, params.beaconJob?.jobName ?? ''),
                       const SizedBox(height: 16),
                      },

                     // Choose Different Account/Branch
                     JPTextButton(
                      text: 'choose_different_branch'.tr.toUpperCase(),
                      color: JPAppTheme.themeColors.primary,
                      textSize: JPTextSize.heading4,
                      fontWeight: JPFontWeight.bold,
                      onPressed: () {
                        Get.back();
                        params.onChooseDifferentBranch?.call();
                      },
                     ),
                     const SizedBox(height: 16),
                    ],
                   )
                  : Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisSize: MainAxisSize.min,
                     children: [
                      // Account Address
                      JPInputBox(
                      inputBoxController: controller.accountController,
                      onPressed: controller.selectAccountAddress,
                      type: JPInputBoxType.withLabel,
                      label: "account_name".tr.capitalize,
                      hintText: "select".tr,
                      isRequired: true,
                      readOnly: true,
                      disabled: controller.disableForm,
                      fillColor: JPAppTheme.themeColors.base,
                      validator: (val) => FormValidator.requiredFieldValidator(val),
                      suffixChild: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.keyboard_arrow_down, color: JPAppTheme.themeColors.text),
                       ),
                      ),
                      const SizedBox(height: 20),
                      // Branch
                      controller.isBranchLoading
                          ? const SelectSrsBranchShimmer(showOneField: true)
                          : JPInputBox(
                          inputBoxController: controller.branchController,
                          onPressed: controller.selectBranch,
                          type: JPInputBoxType.withLabel,
                          label: "branch".tr.capitalize,
                          hintText: "select".tr,
                          isRequired: true,
                          readOnly: true,
                          disabled: controller.disableForm,
                          fillColor: JPAppTheme.themeColors.base,
                          validator: (val) => FormValidator.requiredFieldValidator(val),
                          suffixChild: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.keyboard_arrow_down, color: JPAppTheme.themeColors.text),
                          ),
                        ),

                    // Job Account
                    MaterialSupplierJobAccounts(
                      controller: controller,
                    ),
                    const SizedBox(height: 10),

                      JPCheckbox(
                        text: 'make_this_selection_my_default'.tr,
                        selected: controller.params.isBranchMakeDefault,
                        onTap: controller.onTapMakeDefault,
                        padding: const EdgeInsets.all(0),
                        separatorWidth: 0,
                        disabled: controller.disableForm,
                      )
                  ],
                 ),
            ),
          ),
          footer: Padding(
            padding: EdgeInsets.symmetric(horizontal: controller.formUiHelper.horizontalPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: JPResponsiveDesign.popOverButtonFlex,
                  child: JPButton(
                    text: 'cancel'.tr.toUpperCase(),
                    onPressed: () => Get.back(),
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
                    onPressed: controller.onDone,
                    text: controller.saveTitle,
                    fontWeight: JPFontWeight.medium,
                    disabled: controller.disableForm,
                    size: JPButtonSize.small,
                    colorType: JPButtonColorType.primary,
                    textColor: JPAppTheme.themeColors.base,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textWithLabel(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JPText(
          text: "$label: ",
          textColor: JPAppTheme.themeColors.secondaryText,
          textAlign: TextAlign.start,
        ),

        Expanded(
          child: JPText(
              text: value,
              textColor: JPAppTheme.themeColors.tertiary,
              textAlign: TextAlign.start,
              fontWeight: JPFontWeight.bold,
              textSize: JPTextSize.heading4
          ),
        )
      ],
    );
  }
}