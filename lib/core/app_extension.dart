// import 'package:flutter/material.dart';
// import 'package:mainpage/src/controller/fadeanimation.dart';
// import 'package:zakat_app/controller/fade_animation.dart';
// import 'package:get/get.dart';

extension IterableWithIndex<T> on Iterable<T> {
  Iterable<E> mapWithIndex<E>(E Function(int index, T value) f) {
    return Iterable.generate(length).map((i) => f(i, elementAt(i)));
  }

  Iterable<T> distinctBy(Object Function(T e) getCompareValue) {
    // remove duplicate item from the list
    var result = <T>[];
    forEach(
      (element) {
        if (!result
            .any((x) => getCompareValue(x) == getCompareValue(element))) {
          result.add(element);
        }
      },
    );
    return result;
  }
}

extension StringExtension on String {
  // capitalize first letter
  String get toCapital => this[0].toUpperCase() + substring(1, length);
}

// extension WidgetExtension on Widget {
//   // add fade animation
//   Widget fadeAnimation(double delay) {
//     return FadeAnimation(delay: delay, child: this);
//   }
// }
