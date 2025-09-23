import 'package:flutter/material.dart';

enum EmptyWidgetType { cart, favorite }

class EmptyWidget extends StatelessWidget {
  final EmptyWidgetType type;
  final String title;
  final bool condition;
  final Widget child;

  const EmptyWidget({
    super.key,
    this.type = EmptyWidgetType.cart,
    required this.title,
    this.condition = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return condition
        ? child
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              
                    Image.asset("Assests/images/screen1/empty_cart2.png", width: 300),
                const SizedBox(height: 10),
                Text(title, style: Theme.of(context).textTheme.displayMedium)
              ],
            ),
          );
  }
}
