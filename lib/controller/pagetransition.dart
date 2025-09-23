// import 'package:flutter/material.dart';
// import 'package:animations/animations.dart';

// class PageTransition extends StatelessWidget {
//   const PageTransition({
//     super.key,
//     required this.child,
//   });

//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     return PageTransitionSwitcher(
//       duration: const Duration(seconds: 1),
//       transitionBuilder: (
//         Widget child,
//         Animation<double> animation,
//         Animation<double> secondaryAnimation,
//       ) {
//         return FadeThroughTransition(
//           animation: animation,
//           secondaryAnimation: secondaryAnimation,
//           child: child,
//         );
//       },
//       child: child,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

/// Enum to define different animation types
enum AnimationType {
  fadeThrough,
  fadeScale,
  sharedAxis,
}

class PageTransition extends StatelessWidget {
  const PageTransition({
    super.key,
    required this.child,
    required this.animationType,
  });

  final Widget child;
  final AnimationType animationType;

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      duration: const Duration(seconds: 1),
      transitionBuilder: (
        Widget child,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        switch (animationType) {
          case AnimationType.fadeThrough:
            return FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          case AnimationType.fadeScale:
            return FadeScaleTransition(
              animation: animation,
              child: child,
            );
          case AnimationType.sharedAxis:
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          // ignore: unreachable_switch_default
          default:
            return child;
        }
      },
      child: child,
    );
  }
}
