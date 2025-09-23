import 'package:flutter/material.dart';
import 'package:plant_app/screens/details/components/body.dart';

class DetailsScreen extends StatefulWidget {
  final int id;
  final String name;
  final String imagePath;
  final String category;
  final String description;
  final double price;
  final double width;
  final double height;
  final String size;
  final bool isPopular;
  final bool isRecommended;
  final bool isFavorit;
  final double quantity;
  DetailsScreen(
      {super.key,
      required this.id,
      required this.name,
      required this.imagePath,
      required this.category,
      required this.description,
      required this.price,
      required this.width,
      required this.height,
      required this.size,
      required this.isPopular,
      required this.isRecommended,
      required this.isFavorit,
      required this.quantity});
  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        id: widget.id,
        name: widget.name,
        imagePath: widget.imagePath,
        category: widget.category,
        description: widget.description,
        price: widget.price,
        isFavorit: widget.isFavorit,
        height: widget.height,
        width: widget.width,
        size: widget.size,
        isPopular: widget.isPopular,
        isRecommended: widget.isRecommended,
        quantity: widget.quantity,
      ),
    );
  }
}
