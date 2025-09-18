import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class MyProfileSignatureButtons extends StatelessWidget {
  const MyProfileSignatureButtons({
    super.key,
    this.onTapAddSignature,
    this.onTapViewSignature,
  });

  final VoidCallback? onTapAddSignature;

  final VoidCallback? onTapViewSignature;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: JPResponsiveDesign.popOverButtonFlex,
            child: JPButton(
              size: JPButtonSize.small,
              colorType: JPButtonColorType.tertiary,
              text: 'view_signature'.tr.toUpperCase(),
              onPressed: onTapViewSignature,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            flex: JPResponsiveDesign.popOverButtonFlex,
            child: JPButton(
              size: JPButtonSize.small,
              text: 'add_signature'.tr.toUpperCase(),
              onPressed: onTapAddSignature,
            ),
          ),
        ],
      ),
    );
  }
}
