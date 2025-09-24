import 'package:flutter/material.dart';
import 'package:plant_app/models/Plant.dart';
import 'package:plant_app/screens/details/details_screen.dart';
import '../../../constants.dart';

class FeaturedPlants extends StatelessWidget {
  final List<Plant> plants; // 👈 dynamic list passed from parent
  const FeaturedPlants({Key? key, required this.plants}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: plants.map((plant) {
          return FeaturePlantCard(
            image: plant.images.isNotEmpty ? plant.images.first.image : "",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(plant: plant),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class FeaturePlantCard extends StatelessWidget {
  const FeaturePlantCard({
    Key? key,
    required this.image,
    required this.press,
  }) : super(key: key);

  final String image;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: const EdgeInsets.only(
          left: kDefaultPadding,
          top: kDefaultPadding / 2,
          bottom: kDefaultPadding / 2,
        ),
        width: size.width * 0.8,
        height: 185,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(image),
          ),
        ),
      ),
    );
  }
}
