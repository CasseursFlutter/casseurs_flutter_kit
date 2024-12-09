import 'package:flutter/material.dart';

class FillRemainingContainer extends StatelessWidget {
  final bool hasScrollBody;
  
  final EdgeInsets? padding;
  final Widget child;
  
  final ScrollPhysics? physics;
  
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  const FillRemainingContainer({
    Key? key,
    required this.child,
    this.padding,
    this.hasScrollBody = false,    
    this.physics,    
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {        
    return CustomScrollView(
      keyboardDismissBehavior: keyboardDismissBehavior,
      physics: physics ?? const ClampingScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: hasScrollBody,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(0),
            child: child,
          ),
        )
      ],
    );
  }
}