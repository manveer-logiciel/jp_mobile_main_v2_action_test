
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/reminder/index.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class UserNotificationFormTile extends StatelessWidget {
  const UserNotificationFormTile({
    super.key,
    required this.data,
    this.onTapRemove,
    this.onTapNotificationType,
    this.onTapDurationType,
    this.onDataChanged,
    this.canShowError = false,
    this.isDisabled = false,
  });

  final ReminderFormData data;
  final VoidCallback? onTapRemove;
  final VoidCallback? onTapNotificationType;
  final VoidCallback? onTapDurationType;
  final VoidCallback? onDataChanged;
  final bool canShowError;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                flex: 35,
                child: JPInputBox(
                  inputBoxController: data.typeController,
                  onPressed: onTapNotificationType,
                  readOnly: true,
                  disabled: isDisabled,
                  suffixChild: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: JPIcon(Icons.expand_more, color: JPAppTheme.themeColors.darkGray,
                    ),
                  ),
                ),
            ),

            const SizedBox(
              width: 8,
            ),

            Expanded(
                flex: 30,
                child: JPInputBox(
                  inputBoxController: data.valueController,
                  keyboardType: TextInputType.number,
                  disabled: isDisabled,
                  onChanged: (_) {
                    onDataChanged?.call();
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.allow(FormValidator.typeToFrequencyValidator(data.durationType.id), replacementString: data.valueController.text),
                  ],
                  borderColor: error != null && canShowError ? JPAppTheme.themeColors.secondary : null,
                ),
            ),

            const SizedBox(
              width: 8,
            ),

            Expanded(
                flex: 40,
                child: JPInputBox(
                  inputBoxController: data.durationController,
                  onPressed: onTapDurationType,
                  disabled: isDisabled,
                  readOnly: true,
                  suffixChild: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: JPIcon(Icons.expand_more, color: JPAppTheme.themeColors.darkGray,
                    ),
                  ),
                ),
            ),

            Transform.translate(
              offset: const Offset(8, 0),
              transformHitTests: false,
              child: JPTextButton(
                icon: Icons.close,
                color: JPAppTheme.themeColors.secondary,
                iconSize: 20,
                onPressed: onTapRemove,
                isDisabled: isDisabled,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        if(error != null && canShowError)
          JPText(
          text: error!,
          textSize: JPTextSize.heading5,
          textColor: JPAppTheme.themeColors.secondary,
        ),
      ],
    );
  }

  String? get error => FormValidator.requiredFieldValidator(data.valueController.text, errorMsg: 'please_enter_valid_reminder_time'.tr);

}
