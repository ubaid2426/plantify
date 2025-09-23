// import 'package:flutter/material.dart';
// import 'package:flutter_animate_on_scroll/flutter_animate_on_scroll.dart';

// class FadeAnimation extends StatefulWidget {
//   final String animationType;
//   final int delay;
//   final Widget child;

//   const FadeAnimation({
//     super.key,
//     required this.animationType,
//     required this.delay,
//     required this.child,
//   });

//   @override
//   // ignore: library_private_types_in_public_api
//   _FadeAnimationState createState() => _FadeAnimationState();
// }

// class _FadeAnimationState extends State<FadeAnimation> {
//   GlobalKey _animationKey = GlobalKey(); // Initialize the GlobalKey to avoid errors

//   @override
//   void dispose() {
//     _animationKey = GlobalKey(); // Ensure key is safely disposed or recreated
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Switch statement to apply the correct animation based on the `animationType`
//     switch (widget.animationType) {
//       case 'FadeIn':
//         return FadeIn(
//           globalKey: _animationKey,
//           delay: Duration(milliseconds: widget.delay),
//           child: widget.child,
//         );
//       case 'FadeInDown':
//         return FadeInDown(
//           globalKey: _animationKey,
//           delay: Duration(milliseconds: widget.delay),
//           child: widget.child,
//         );
//       case 'FadeInUp':
//         return FadeInUp(
//           globalKey: _animationKey,
//           delay: Duration(milliseconds: widget.delay),
//           child: widget.child,
//         );
//       case 'FadeInLeft':
//         return FadeInLeft(
//           globalKey: _animationKey,
//           delay: Duration(milliseconds: widget.delay),
//           child: widget.child,
//         );
//       case 'FadeInRight':
//         return FadeInRight(
//           globalKey: _animationKey,
//           delay: Duration(milliseconds: widget.delay),
//           child: widget.child,
//         );
//       case 'FadeOut':
//         return FadeOut(
//           globalKey: _animationKey,
//           delay: Duration(milliseconds: widget.delay),
//           child: widget.child,
//         );
//       case 'SlideInDown':
//         return SlideInDown(
//           globalKey: _animationKey,
//           delay: Duration(milliseconds: widget.delay),
//           child: widget.child,
//         );
//       case 'FadeOutDown':
//         return FadeOutDown(
//           globalKey: _animationKey,
//           delay: Duration(milliseconds: widget.delay),
//           child: widget.child,
//         );
//       case 'ZoomIn':
//         return ZoomIn(
//           globalKey: _animationKey,
//           delay: Duration(milliseconds: widget.delay),
//           child: widget.child,
//         );
//       case 'ZoomOut':
//         return ZoomOut(
//           globalKey: _animationKey,
//           delay: Duration(milliseconds: widget.delay),
//           child: widget.child,
//         );
//       default:
//         return widget.child; // If no valid animationType is passed, just return the child widget
//     }
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:flutter_animate_on_scroll/flutter_animate_on_scroll.dart';

// class FadeAnimation extends StatefulWidget {
//   final String animationType;
//   final int delay;
//   final Widget child;

//   const FadeAnimation({
//     super.key,
//     required this.animationType,
//     required this.delay,
//     required this.child,
//   });

//   @override
//   _FadeAnimationState createState() => _FadeAnimationState();
// }

// class _FadeAnimationState extends State<FadeAnimation> {
//   final GlobalKey _animationKey = GlobalKey(); // Unique key for animation
//   bool _hasAnimated = false; // Track if animation played

//   @override
//   Widget build(BuildContext context) {
//     if (_hasAnimated) {
//       return widget.child; // If animation has played, return the static widget
//     }

//     Future.delayed(Duration(milliseconds: widget.delay), () {
//       if (mounted) {
//         setState(() {
//           _hasAnimated = true; // Mark animation as played
//         });
//       }
//     });

//     switch (widget.animationType) {
//       case 'FadeIn':
//         return FadeIn(
//           globalKey: _animationKey,
//           delay: Duration(milliseconds: widget.delay),
//           child: widget.child,
//         );
//       case 'FadeInDown':
//         return FadeInDown(
//           globalKey: _animationKey,
//           delay: Duration(milliseconds: widget.delay),
//           child: widget.child,
//         );
//       case 'FadeInUp':
//         return FadeInUp(
//           globalKey: _animationKey,
//           delay: Duration(milliseconds: widget.delay),
//           child: widget.child,
//         );
//       case 'FadeInLeft':
//         return FadeInLeft(
//           globalKey: _animationKey,
//           delay: Duration(milliseconds: widget.delay),
//           child: widget.child,
//         );
//       case 'FadeInRight':
//         return FadeInRight(
//           globalKey: _animationKey,
//           delay: Duration(milliseconds: widget.delay),
//           child: widget.child,
//         );
//       case 'ZoomIn':
//         return ZoomIn(
//           globalKey: _animationKey,
//           delay: Duration(milliseconds: widget.delay),
//           child: widget.child,
//         );
//       case 'ZoomOut':
//         return ZoomOut(
//           globalKey: _animationKey,
//           delay: Duration(milliseconds: widget.delay),
//           child: widget.child,
//         );
//       default:
//         return widget.child;
//     }
//   }
// }
