import 'package:flutter/material.dart';

class EdgeInsetsUtils {
  static EdgeInsets buildVerticalSafeEdgeInsets(BuildContext context, { double? horizontal, double? vertical }) {
    final h = horizontal ?? 0;
    final v = vertical ?? 0;

    final mediaQuery = MediaQuery.of(context);
    final t = mediaQuery.padding.top + v;
    final b = mediaQuery.padding.bottom + v;

    return EdgeInsets.only(
      left: h, right: h,
      top: t,
      bottom: b
    );
  }

  static EdgeInsets buildBottomSafeEdgeInsets(BuildContext context, { double? horizontal, double? vertical }) {
    final h = horizontal ?? 0;
    final v = vertical ?? 0;

    final mediaQuery = MediaQuery.of(context);  
    final b = mediaQuery.padding.bottom + v;

    return EdgeInsets.only(
      left: h, right: h,
      top: v,
      bottom: b
    );
  }
}