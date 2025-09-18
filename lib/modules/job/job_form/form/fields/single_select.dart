import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jp_mobile_flutter_ui/IconButton/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

/// [JobFormSingleSelect] is a common widget which can be used to render all the
/// single select inputs of job form
class JobFormSingleSelect extends StatelessWidget {

  const JobFormSingleSelect({
    required this.field,
    this.isDisabled = false,
    required this.textController,
    this.selectionId,
    this.onTap,
    this.showInsuranceClaim = false,
    this.onTapInsuranceClaim,
    this.otherController,

    super.key,
  });

  FormUiHelper get uiHelper => FormUiHelper();

  /// [field] holds data of field coming from company settings
  final InputFieldParams field;

  /// [textController] holds controller for single select selector
  final JPInputBoxController textController;

  final JPInputBoxController ? otherController;

  /// [selectionId] helps is displaying fields for additional data
  final String? selectionId;

  /// [isDisabled] helps is disabling field
  final bool isDisabled;

  /// [onTap] handles tap on single select
  final VoidCallback? onTap;

  /// [showInsuranceClaim] helps in show hide insurance claim icon
  final bool showInsuranceClaim;

  /// [onTapInsuranceClaim] handles tap on navigate to insurance claim form page
  final VoidCallback? onTapInsuranceClaim;

  /// [isOtherOption] helps is displaying fields for additional data
  bool get isOtherOption => selectionId == CommonConstants.otherOptionId;

  @override
  Widget build(BuildContext context) {
    return 
    Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///   Single Select
            Expanded(
              child: JPInputBox(
                key: Key(field.key),
                inputBoxController: textController,
                type: JPInputBoxType.withLabel,
                label: field.name,
                fillColor: JPAppTheme.themeColors.base,
                disabled: isDisabled,
                isRequired: field.isRequired,
                readOnly: true,
                onPressed: onTap,
                validator: (val) {
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
            ),
            ///   Insurance Claim Button
            if (showInsuranceClaim) ...{
              const SizedBox(width: 12),
              Opacity(
                  opacity: isDisabled ? 0.7 : 1,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 14
                    ),
                    child: JPIconButton(
                      icon: Icons.assignment_outlined,
                      backgroundColor: JPAppTheme.themeColors.lightBlue,
                      iconColor: JPAppTheme.themeColors.primary,
                      iconSize: 22,
                      onTap: onTapInsuranceClaim,
                    ),
                  )
              )
            }, 
          ],
        ),
        if (isOtherOption) ...{
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
