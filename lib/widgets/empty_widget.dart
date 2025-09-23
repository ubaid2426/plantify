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
   double width= MediaQuery.of(context).size.width;
   double height= MediaQuery.of(context).size.height;
    return condition
        ? child
        : Stack(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
                Image.asset("assets/images/empty_card.jpg", width: width, height: height,),
            const SizedBox(height: 10),
            Center(child: Text(title, style: Theme.of(context).textTheme.displayMedium))
          ],
        );
  }
}
