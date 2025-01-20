import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedListItem extends StatelessWidget {
  final Widget child;
  final int index;
  final bool animate;

  const AnimatedListItem({
    super.key,
    required this.child,
    required this.index,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!animate) return child;

    return child
        .animate()
        .fadeIn(
          duration: const Duration(milliseconds: 300),
          delay: Duration(milliseconds: 50 * index),
        )
        .slideX(
          begin: 0.2,
          end: 0,
          duration: const Duration(milliseconds: 200),
          delay: Duration(milliseconds: 50 * index),
          curve: Curves.easeOut,
        );
  }
}
