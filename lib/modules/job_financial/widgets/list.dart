import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/Text/index.dart';
import 'package:jp_mobile_flutter_ui/Toggle/index.dart';

class JobFinancialOptionsList extends StatelessWidget {

  const JobFinancialOptionsList({
    super.key,
    required this.value,
    this.toggleValue,
    this.onToggle,
    this.isDisabled = false,
  });

  final String value;
  final bool? toggleValue;
  final void Function(bool)? onToggle;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isDisabled,
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: JPText(
                  textAlign: TextAlign.left,
                  text: value,
                ),
              ),
              if (toggleValue != null)
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: JPToggle(
                    value: toggleValue!,
                    onToggle: onToggle!,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
