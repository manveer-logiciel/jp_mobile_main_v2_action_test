import 'package:flutter/material.dart';

class CustomFieldTile extends StatelessWidget {
  final Widget? group;
  final Widget? label;
  final Widget? description;

  const CustomFieldTile({
    super.key, 
    this.group, 
    this.label, 
    this.description
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          group ?? const SizedBox.shrink(),
          Visibility(
            visible: group != null,
            child: const SizedBox(height: 9),
          ),
          label ?? const SizedBox.shrink(),
          const SizedBox(height: 6),
          description ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
