import 'package:flutter/material.dart';
import 'package:jobprogress/global_widgets/customer_consent_form/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ConsentFormHeader extends StatelessWidget {
  const ConsentFormHeader({
    super.key,
    required this.controller});

  final ConsentFormDialogController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: !controller.showEmailField ? 5 : 16),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: JPText(
                text: controller.title,
                textSize: JPTextSize.heading3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              transform: Matrix4.translationValues(8, 0, 0),
              child: JPTextButton(
                isDisabled: controller.isLoading,
                onPressed: controller.onPressedBackButton,
                color: JPAppTheme.themeColors.text,
                icon: Icons.clear,
                iconSize: 24,
              ),
            )
          ]),
    );
  }
}
