
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

/// [CustomerFormSingleSelect] is a common widget which can be used to render all the
/// single select inputs of customer form
class CustomerFormSingleSelect extends StatelessWidget {

  const CustomerFormSingleSelect({
    required this.field,
    this.isDisabled = false,
    required this.textController,
    this.selectionId,
    this.customerSelectionId,
    this.customerController,
    this.otherController,
    this.onTapCustomer,
    this.onTap,
    this.onTapRemoveCustomer,
    this.validator,
    super.key,
  });

  FormUiHelper get uiHelper => FormUiHelper();

  /// [field] holds data of field coming from company settings
  final InputFieldParams field;

  /// [textController] holds controller for single select selector
  final JPInputBoxController textController;

  /// [customerController] holds controller for customer selector
  final JPInputBoxController? customerController;

  /// [otherController] holds controller for other field
  final JPInputBoxController? otherController;

  /// [selectionId] helps is displaying fields for additional data
  final String? selectionId;

  /// [customerSelectionId] helps is displaying select/close icon
  final String? customerSelectionId;

  /// [isDisabled] helps is disabling field
  final bool isDisabled;

  /// [onTap] handles tap on single select
  final VoidCallback? onTap;

  /// [onTapCustomer] handles tap on customer select
  final VoidCallback? onTapCustomer;

  /// [onTapRemoveCustomer] handles tap on customer select
  final VoidCallback? onTapRemoveCustomer;

  /// [validator] holds validation function
  final Function(String)? validator;

  bool get isOtherOption => selectionId == CommonConstants.otherOptionId;

  bool get isCustomerOption => selectionId == CommonConstants.customerOptionId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        JPInputBox(
          inputBoxController: textController,
          type: JPInputBoxType.withLabel,
          label: field.name,
          fillColor: JPAppTheme.themeColors.base,
          disabled: isDisabled,
          isRequired: field.isRequired,
          readOnly: true,
          onPressed: onTap,
          validator: (val) {
            if(validator != null) {
              return validator!(val);
            }

            if(field.isRequired) {
              return FormValidator.requiredFieldValidator(val);
            }
            return null;
          },
          onChanged: field.onDataChange,
          suffixChild: Padding(
            padding: EdgeInsets.symmetric(horizontal: uiHelper.horizontalPadding),
            child: JPIcon(
              Icons.keyboard_arrow_down_outlined,
              color: JPAppTheme.themeColors.text,
            ),
          ),
        ),

        if (isCustomerOption) ...{

          SizedBox(
            height: uiHelper.verticalPadding,
          ),

          JPInputBox(
            key: UniqueKey(),
            inputBoxController: customerController,
            type: JPInputBoxType.withLabel,
            label: 'existing_customer'.tr,
            fillColor: JPAppTheme.themeColors.base,
            readOnly: true,
            onPressed: onTapCustomer,
            disabled: isDisabled,
            validator: (val) {
              final message = "${('existing_customer'.tr).capitalizeFirst!} ${'is_required'.tr}";
              return FormValidator.requiredFieldValidator(val, errorMsg: message);
            },
            suffixChild: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (customerSelectionId?.isEmpty ?? true) ...{
                  JPTextButton(
                    text: 'select'.tr.toUpperCase(),
                    textSize: JPTextSize.heading5,
                    color: JPAppTheme.themeColors.primary,
                    onPressed: onTapCustomer,
                    padding: 0,
                  ),
                } else ...{
                  JPTextButton(
                    icon: Icons.close,
                    iconSize: 22,
                    color: JPAppTheme.themeColors.secondary,
                    onPressed: onTapRemoveCustomer,
                    padding: 0,
                  ),
                },

                SizedBox(
                  width: uiHelper.suffixPadding,
                ),
              ],
            ),
            onChanged: field.onDataChange,
          ),
        },

        if (isOtherOption || isCustomerOption) ...{

          SizedBox(
            height: uiHelper.verticalPadding,
          ),

          JPInputBox(
            inputBoxController: otherController,
            type: JPInputBoxType.withLabel,
            label: "${field.name} ${"note".tr}",
            fillColor: JPAppTheme.themeColors.base,
            disabled: isDisabled,
            validator: (val) {
              final message = "${("${field.name} ${"note".tr}").capitalizeFirst!} ${'is_required'.tr}";
              return FormValidator.requiredFieldValidator(val, errorMsg: message);
            },
            onChanged: field.onDataChange,
          ),
        }
      ],
    );
  }
}
