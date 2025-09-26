import 'package:flutter/material.dart';
import 'package:plant_app/constants.dart';

class TitleAndPrice extends StatefulWidget {
  const TitleAndPrice({
    Key? key,
    required this.title,
    required this.country,
    required this.price,
    required this.description,
    required this.onTotalPriceChanged, // 👈 callback
  }) : super(key: key);

  final String title, country;
  final double price; // unit price
  final String description;
  final Function(double totalPrice, int quantity)
      onTotalPriceChanged; // 👈 send total & qty

  @override
  State<TitleAndPrice> createState() => _TitleAndPriceState();
}

class _TitleAndPriceState extends State<TitleAndPrice> {
  int quantity = 1;
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: "PKR ${(widget.price * quantity).toStringAsFixed(2)}",
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTotal();
    });
  }

  void _increment() {
    setState(() {
      quantity++;
      _updateTotal();
    });
  }

  void _decrement() {
    if (quantity > 1) {
      setState(() {
        quantity--;
        // _notifyParent();
        _updateTotal();
      });
    }
  }

  void _updateTotal() {
    final total = widget.price * quantity;
    _controller.text = "PKR ${total.toStringAsFixed(2)}";
    widget.onTotalPriceChanged(total, quantity);
  }

  // void _notifyParent() {
  //   double totalPrice = widget.price * quantity;
  //   widget.onTotalPriceChanged(totalPrice, quantity); // 👈 notify Body
  // }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double totalPrice = widget.price * quantity;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Country
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "${widget.title}\n",
                  style: const TextStyle(
                    fontSize: 25,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: widget.country,
                  style: const TextStyle(
                    fontSize: 20,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Description
          Text(
            widget.description,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: null,
            softWrap: true,
          ),

          const SizedBox(height: 16),

          // Price + Counter
          Row(
            children: [
              // Decrement button
              IconButton(
                icon: const Icon(Icons.remove, color: kPrimaryColor),
                onPressed: quantity > 1 ? _decrement : null,
              ),

              // Quantity display
              Text(
                "$quantity",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Increment button
              IconButton(
                icon: const Icon(Icons.add, color: kPrimaryColor),
                onPressed: _increment,
              ),

              const SizedBox(width: 20),

              // Final Price
              Expanded(
                child: TextField(
                  readOnly: true,
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: "Total Price",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
