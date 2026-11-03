import 'package:flutter/material.dart';

/// Clean, simple white background for the splash screen.
class CharmingSplashBackground extends StatelessWidget {
  final Widget child;
  final bool isAnimating;

  const CharmingSplashBackground({
    super.key,
    required this.child,
    this.isAnimating = true,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: child,
    );
  }
}
