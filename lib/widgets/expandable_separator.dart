import 'package:flutter/material.dart';

class ExpandableSeparator extends StatelessWidget {
  final int flex;
  final double minHeight;

  const ExpandableSeparator({
    Key? key,
    this.flex = 1,
    this.minHeight = 0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: minHeight
        ),
      )
    );
  }
}