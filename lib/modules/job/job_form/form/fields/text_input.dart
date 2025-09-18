
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

/// [JobFormTextInput] is a common widget which can be used to render all the
/// text inputs in job form
class JobFormTextInput extends StatelessWidget {

  const JobFormTextInput({
    super.key,
    required this.field,
    required this.textController,
    this.isDisabled = false,
    this.isMultiline = false,
    this.jobDivisionCode = "",
    this.maxLength,
    this.showTradeScript = false,
    this.onTapTradeScript
  });

  /// [field] holds data of field coming from company settings
  final InputFieldParams field;

  /// [textController] used to assign controller to field
  final JPInputBoxController textController;

  /// [isDisabled] helps is disabling field
  final bool isDisabled;

  /// [isMultiline] decides whether field is multiline or not
  final bool isMultiline;

  /// [jobDivisionCode] helps in displaying non-editable division code
  final String jobDivisionCode;

  /// [maxLength] helps in restricting number of words that text field can hold
  final int? maxLength;

  /// [showTradeScript] helps to show/hide trade-script button under input box
  final bool showTradeScript;

  /// [onTapTradeScript] used to handle trade-script click
  final VoidCallback? onTapTradeScript;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        ///   Input Field
        Padding(
          padding: EdgeInsets.only(
            bottom: showTradeScript ? 36 : 0
          ),
          child: JPInputBox(
            key: Key(field.key),
            inputBoxController: textController,
            type: JPInputBoxType.withLabel,
            label: field.name,
            fillColor: JPAppTheme.themeColors.base,
            disabled: isDisabled,
            maxLines: isMultiline ? 5 : 1,
            isRequired: field.isRequired,
            maxLength: maxLength,
            validator: (val) {
              if(field.isRequired) {
                final message = "${field.name.capitalizeFirst!} ${"is_required".tr}";
                return FormValidator.requiredFieldValidator(val, errorMsg: message);
              }
              return null;
            },
            onChanged: field.onDataChange,
            avoidPrefixConstraints: true,
            prefixIconConstraints: const BoxConstraints(
                maxHeight: 40
            ),
            prefixChild: getJobDivisionCode(),
          ),
        ),


        ///   Trade Script Button
        if (showTradeScript)
          Positioned.fill(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Transform.translate(
                  offset: const Offset(6, 0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5
                    ),
                    child: JPTextButton(
                      isExpanded: false,
                      text: 'trade_scripts'.tr,
                      textSize: JPTextSize.heading5,
                      color: JPAppTheme.themeColors.primary,
                      onPressed: onTapTradeScript,
                    ),
                  ),
                ),
              )
          ),
      ],
    );
  }

  // getJobDivisionCode(): displays division code as prefix of input box
  Widget? getJobDivisionCode() {

    if (jobDivisionCode.isEmpty) return null;

    return Container(
      margin: const EdgeInsets.only(
          left: 12,
          right: 6
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 2
      ),
      decoration: BoxDecoration(
          color: JPAppTheme.themeColors.lightestGray,
          borderRadius: BorderRadius.circular(4)
      ),
      child: JPText(
        text: "$jobDivisionCode -",
      ),
    );
  }

}
