import 'package:flutter/material.dart';

class FillRemainingContainer extends StatelessWidget {
  final bool hasScrollBody;
  final Widget child;
  
  final double horizontalPadding;
  final double verticalPadding;

  final ScrollPhysics? physics;

  const FillRemainingContainer({
    Key? key,
    required this.child,
    this.hasScrollBody = false,
    this.horizontalPadding = 16,
    this.verticalPadding = 16,
    this.physics
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {        
    return CustomScrollView(
      physics: physics ?? const ClampingScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: hasScrollBody,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: horizontalPadding,
                right: horizontalPadding,
                top: verticalPadding,
                bottom: verticalPadding
              ),
              child: child,
            ),
          ),
        )
      ],
    );
  }
}