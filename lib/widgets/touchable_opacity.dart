import 'package:flutter/material.dart';

class TouchableOpacity extends StatefulWidget {
  final Widget child;
  final Function? onPressed;
  final double activeOpacity;

  const TouchableOpacity({
    Key? key,
    required this.child,
    this.onPressed,
    this.activeOpacity = 0.7
  }) : super(key: key);

  @override
  _TouchableOpacityState createState() => _TouchableOpacityState();
}

class _TouchableOpacityState extends State<TouchableOpacity> {
  late double _opacity;

  @override
  void initState() {
    _opacity = 1.0;
    super.initState();
  }

  void _handleOnTap() {
    if (widget.onPressed != null) widget.onPressed!();
  } 

  @override
  Widget build(BuildContext context) {
    
    return widget.onPressed != null
      ?  GestureDetector(
          onTapDown: (_) => setState((){ _opacity = widget.activeOpacity;}),
          onTapUp: (_) => setState((){ _opacity = 1.0;}),
          onTapCancel: () => setState((){ _opacity = 1.0;}),
          onTap:  _handleOnTap,
          child: Opacity(
            opacity: _opacity,
            child: widget.child
          ),
        )
      : widget.child;
  }
}