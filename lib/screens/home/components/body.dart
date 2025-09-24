import 'package:flutter/material.dart';
import 'package:plant_app/components/home_screen_carosel.dart';
import 'package:plant_app/constants.dart';
import 'package:plant_app/core/service/api_service.dart';
import 'package:plant_app/models/Plant.dart';
import 'package:plant_app/screens/home/components/featurred_plants.dart';
import 'package:plant_app/screens/home/components/header_with_seachbox.dart';
import 'package:plant_app/screens/home/components/recomend_plants.dart';
import 'package:plant_app/screens/home/components/title_with_more_bbtn.dart';
import 'package:plant_app/screens/home/components/viewall.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Future<List<Plant>> futurePlants;
  @override
  void initState() {
    super.initState();
    futurePlants = ApiService.fetchPlants();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder<List<Plant>>(
      future: futurePlants,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        List<Plant> allPlants = snapshot.data ?? [];

        // 👇 filter lists
        List<Plant> recommendedPlants =
            allPlants.where((plant) => plant.recommended).toList();

        List<Plant> featuredPlants =
            allPlants.where((plant) => plant.popular).toList();

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              HeaderWithSearchBox(size: size),
              CarouselHome1(),
              // All plants
              TitleWithMoreBtn(title: "View All", press: () {}),
              ViewAll(plants: allPlants),

              // Recommended plants only
              TitleWithMoreBtn(title: "Recommended", press: () {}),
              RecomendsPlants(plants: recommendedPlants),

              // Featured plants only
              TitleWithMoreBtn(title: "Featured Plants", press: () {}),
              FeaturedPlants(plants: featuredPlants),

              SizedBox(height: kDefaultPadding),
            ],
          ),
        );
      },
    );
  }
}

class CarouselHome1 extends StatelessWidget {
  const CarouselHome1({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 200,
        // color: Colors.red,
        child: const HomePageCarousel(
          imageList: [
            "assets/images/banner1.jpeg",
            "assets/images/banner2.jpg",
            "assets/images/banner3.jpg",
          ],
          carouselHeight: 200,
        ),
      ),
    );
  }
}
