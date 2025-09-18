
import 'package:flutter/material.dart';
import 'package:jobprogress/common/extensions/indexed_iterable/index.dart';

class JPIndexedStack extends StatelessWidget {
  const JPIndexedStack({
    super.key, 
    required this.index, 
    required this.children
  });

  final List<Widget> children;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: children.mapIndexed((widget, i) => Offstage(offstage: index != i, child: widget)).toList(),
    );
  }
}

