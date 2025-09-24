import 'package:flutter/material.dart';
import 'package:plant_app/constants.dart';
import 'package:plant_app/data/category_model.dart';
import 'package:plant_app/models/Plant.dart';
import 'package:plant_app/screens/details/details_screen.dart';

class ViewAll extends StatefulWidget {
  final List<Plant> plants; // 👈 now data comes from parent

  const ViewAll({Key? key, required this.plants}) : super(key: key);

  @override
  State<ViewAll> createState() => _ViewAllState();
}

class _ViewAllState extends State<ViewAll> {
  int selectId = 0;
  int activePage = 0;
  PageController controller =
      PageController(viewportFraction: 0.6, initialPage: 0);

  @override
  Widget build(BuildContext context) {
    // Apply category filter
    List<Plant> filteredPlants = selectId == 0
        ? widget.plants
        : widget.plants.where((p) {
            if (selectId == 1) return p.category.toLowerCase() == 'outdoor';
            if (selectId == 2) return p.category.toLowerCase() == 'indoor';
            if (selectId == 3) return p.name.toLowerCase().contains("office");
            if (selectId == 4) return p.name.toLowerCase().contains("garden");
            return true;
          }).toList();

    return Center(
      child: Column(
        children: [
          // Category Row
          SizedBox(
            height: 35.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (int i = 0; i < categories.length; i++)
                  GestureDetector(
                    onTap: () {
                      setState(() => selectId = categories[i].id);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          categories[i].name,
                          style: TextStyle(
                            color: selectId == i
                                ? kPrimaryColor
                                : black.withOpacity(0.7),
                            fontSize: 16.0,
                          ),
                        ),
                        if (selectId == i)
                          const CircleAvatar(
                            radius: 3,
                            backgroundColor: kPrimaryColor,
                          )
                      ],
                    ),
                  )
              ],
            ),
          ),
          // Plants List
          SizedBox(
            height: 320.0,
            child: PageView.builder(
              itemCount: filteredPlants.length,
              controller: controller,
              physics: const BouncingScrollPhysics(),
              padEnds: false,
              onPageChanged: (value) => setState(() => activePage = value),
              itemBuilder: (context, index) {
                bool active = index == activePage;
                return slider(active, filteredPlants[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  AnimatedContainer slider(bool active, Plant plant) {
    double margin = active ? 20 : 30;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      margin: EdgeInsets.all(margin),
      child: mainPlantsCard(plant),
    );
  }

  Widget mainPlantsCard(Plant plant) {
    return GestureDetector(
      onTap: () {
        // Navigate to DetailsScreen with plant object
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(plant: plant),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(5, 5),
            ),
          ],
          border: Border.all(color: kPrimaryColor, width: 2),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                image: DecorationImage(
                  image: NetworkImage(
                      plant.images.isNotEmpty ? plant.images.first.image : ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: CircleAvatar(
                backgroundColor: kPrimaryColor,
                radius: 15,
                child: Image.asset(
                  'assets/icons/add.png',
                  color: Colors.white,
                  height: 15,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  '${plant.name} - \$${plant.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: black.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
