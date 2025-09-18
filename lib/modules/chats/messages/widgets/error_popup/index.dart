import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/extensions/get_navigation/extension.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class MessageErrorPopUp extends StatelessWidget {
  const MessageErrorPopUp({
    super.key,
    required this.error,
  });

  final String error;

  @override
  Widget build(BuildContext context) {

    Helper.showKeyboard();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: JPText(
                  text: 'error_message'.tr.toUpperCase(),
                  fontWeight: JPFontWeight.medium,
                  textAlign: TextAlign.start,
                ),
              ),
              Transform.translate(
                offset: const Offset(10, 0),
                child: IconTheme(
                  data: IconThemeData(
                    color: JPAppTheme.themeColors.text
                  ),
                  child: JPTextButton(
                    icon: Icons.close,
                    onPressed: Get.splitDialogPop,
                    padding: 2,
                    iconSize: 24,
                    color: JPAppTheme.themeColors.text,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          JPText(
            text: error,
            textColor: JPAppTheme.themeColors.tertiary,
            fontWeight: JPFontWeight.medium,
            textSize: JPTextSize.heading5,
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
