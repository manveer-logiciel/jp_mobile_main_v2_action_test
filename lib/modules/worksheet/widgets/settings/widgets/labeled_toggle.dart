import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class WorksheetSettingLabeledToggle extends StatelessWidget {

  const WorksheetSettingLabeledToggle({
    super.key,
    required this.value,
    required this.onToggle,
    required this.title,
    this.onTapEdit,
    this.forceOff = false,
    this.isDisabled = false
  });

  /// [value] set the value of the toggle
  final bool value;

  /// [forceOff] helps in forcefully disabling the toggles
  final bool forceOff;

  /// [title] can be used to display title of the item
  final String title;

  /// [onToggle] can be used to perform action toggle changed
  final Function(bool) onToggle;

  /// [isDisabled] helps in disabling item
  final bool isDisabled;

  /// [onTapEdit] handles tap on edit
  final VoidCallback? onTapEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: JPText(
                  text: title,
                  textAlign: TextAlign.start,
                  textColor: isDisabled
                      ? JPAppTheme.themeColors.secondaryText
                      : JPAppTheme.themeColors.text,
                ),
              ),
              if (onTapEdit != null)
                JPTextButton(
                key: Key(title),
                icon: Icons.edit_outlined,
                color: JPAppTheme.themeColors.primary,
                iconSize: 16,
                isDisabled: isDisabled || !value,
                onPressed: onTapEdit,
              )
            ],
          ),
        ),
        JPToggle(
          value: forceOff ? false : value,
          onToggle: onToggle,
          disabled: isDisabled,
        )
      ],
    );
  }
}
