import 'package:flutter/material.dart';

class WidgetDeadzone extends StatelessWidget {
  final Widget child;
  final EdgeInsets deadzone;

  /// A widget that creates a deadzone around a child widget. This is useful
  /// when you want to prevent gestures from being recognized in certain areas
  /// of the screen, like system gesture navigation (back, home, recent apps)
  const WidgetDeadzone({
    super.key,
    required this.child,
    required this.deadzone,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (deadzone.left > 0)
          Align(
            alignment: Alignment.centerLeft,
            child: AbsorbPointer(
              child: SizedBox(
                width: deadzone.left,
                height: double.infinity,
              ),
            ),
          ),
        if (deadzone.right > 0)
          Align(
            alignment: Alignment.centerRight,
            child: AbsorbPointer(
              child: SizedBox(
                width: deadzone.right,
                height: double.infinity,
              ),
            ),
          ),
        if (deadzone.top > 0)
          Align(
            alignment: Alignment.topCenter,
            child: AbsorbPointer(
              child: SizedBox(
                width: double.infinity,
                height: deadzone.top,
              ),
            ),
          ),
        if (deadzone.bottom > 0)
          Align(
            alignment: Alignment.bottomCenter,
            child: AbsorbPointer(
              child: SizedBox(
                width: double.infinity,
                height: deadzone.bottom,
              ),
            ),
          ),
      ],
    );
  }
}