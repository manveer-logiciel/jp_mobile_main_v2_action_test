import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class FormAddRemoveButton extends StatelessWidget {
  const FormAddRemoveButton({
    super.key,
    this.isAddBtn = true,
    this.onTap,
    this.iconSize = 20,
    this.isDisabled = false,
  });

  final bool isAddBtn;
  final VoidCallback? onTap;
  final double iconSize;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(4, 0),
      child: Padding(
        padding: const EdgeInsets.only(
          right: 4,
          left: 6,
          top: 6
        ),
        child: JPAddRemoveButton(
          isAddBtn: isAddBtn,
          isDisabled: isDisabled,
          onTap: onTap,
          iconSize: iconSize,
        ),
      ),
    );
  }
}