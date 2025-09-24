import 'package:flutter/material.dart';
import 'package:plant_app/models/Plant.dart';
import 'package:plant_app/screens/details/components/body.dart';

class DetailsScreen extends StatefulWidget {
  final Plant plant;
  DetailsScreen(
      {super.key, required this.plant,
      });
  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        plant: widget.plant,
      ),
    );
  }
}
