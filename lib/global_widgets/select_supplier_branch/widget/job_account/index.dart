import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/global_widgets/select_supplier_branch/controller.dart';
import 'package:jobprogress/global_widgets/select_supplier_branch/shimmer.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class MaterialSupplierJobAccounts extends StatelessWidget {
  const MaterialSupplierJobAccounts({
    required this.controller,
    super.key,
  });

  final MaterialSupplierFormController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.isLoadingJobAccount) {
      return const SelectSrsBranchShimmer(
        showOneField: true,
      );
    } else if (controller.showJobAccounts && controller.showSelectedBranchJobAccounts) {
      return Column(
        children: [
          const SizedBox(height: 20),
          JPInputBox(
            key: const ValueKey(WidgetKeys.jobAccount),
            inputBoxController: controller.jobAccountController,
            onPressed: controller.selectJobAccount,
            type: JPInputBoxType.withLabel,
            label: "job_account".tr.capitalize,
            hintText: "select".tr,
            isRequired: controller.isJobAccountRequired,
            readOnly: true,
            fillColor: JPAppTheme.themeColors.base,
            validator: (val) {
              if (controller.isJobAccountRequired) {
                return FormValidator.requiredFieldValidator(val);
              }
              return null;
            },
            suffixChild: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.keyboard_arrow_down,
                  color: JPAppTheme.themeColors.text),
            ),
          ),
        ],
      );
    }
    return const SizedBox();
  }
}
