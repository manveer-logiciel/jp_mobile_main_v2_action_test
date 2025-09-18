
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/global_widgets/add_remove_icon/index.dart';
import 'package:jobprogress/global_widgets/forms/email/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class EmailFormField extends StatelessWidget {
  const EmailFormField({
    super.key,
    required this.index,
    required this.controller,
    this.isDisabled = false,
    this.isRequired = false,
    this.onDataChange
  });

  final int index;
  final EmailFormController controller;
  final bool isDisabled;
  final bool isRequired;
  final Function(String)? onDataChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: JPInputBox(
            inputBoxController: controller.emailControllers[index],
            type: JPInputBoxType.withLabel,
            textCapitalization: TextCapitalization.none,
            label: index == 0 ? 'email'.tr : 'additional_email'.tr,
            fillColor: JPAppTheme.themeColors.base,
            disabled: isDisabled,
            isRequired: isRequired,
            validator: (val) => FormValidator.validateEmail(val),
            onChanged: onDataChange,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: getSuffixIcon(index),
        ),
      ],
    );
  }

  Widget getSuffixIcon(int index) {

    final addBtn = FormAddRemoveButton(onTap: controller.addField, isDisabled: isDisabled,);
    final removeBtn = FormAddRemoveButton(onTap: () => controller.removeField(index), isDisabled: isDisabled, isAddBtn: false,);

    bool doShowAddBtn = index == controller.displayingEmailField - 1 && index < controller.maxEmails - 1;
    bool doShowRemoveBtn = index != 0 && index < controller.displayingEmailField;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if(doShowRemoveBtn) removeBtn,
        if(doShowAddBtn)  addBtn
      ],
    );
  }
}
