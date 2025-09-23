import 'package:flutter/material.dart';
import 'package:plant_app/constants.dart';
import 'package:plant_app/data/category_model.dart';
import 'package:plant_app/data/plant_data.dart';
import 'package:plant_app/screens/details/details_screen.dart';

class ViewAll extends StatefulWidget {
  const ViewAll({Key? key}) : super(key: key);

  @override
  State<ViewAll> createState() => _ViewAllState();
}

class _ViewAllState extends State<ViewAll> {
    PageController controller = PageController();
      @override
  void initState() {
    controller = PageController(viewportFraction: 0.6, initialPage: 0);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return 
    // Scaffold(
      Center(
        child:  Column(
          children: [
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
                 SizedBox(
              height: 320.0,
              child: PageView.builder(
                itemCount: plants.length,
                controller: controller,
                physics: const BouncingScrollPhysics(),
                padEnds: false,
                pageSnapping: true,
                onPageChanged: (value) => setState(() => activePage = value),
                itemBuilder: (itemBuilder, index) {
                  bool active = index == activePage;
                  return slider(active, index);
                },
              ),
            ),
          ],
        ),
      
           
      // )
    );
  }
   AnimatedContainer slider(active, index) {
    double margin = active ? 20 : 30;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      margin: EdgeInsets.all(margin),
      child: mainPlantsCard(index),
    );
  }
    Widget mainPlantsCard(index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (builder) => DetailsScreen(),
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
                color: lightGreen,
                boxShadow: [
                  BoxShadow(
                    color: black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(5, 5),
                  ),
                ],
                borderRadius: BorderRadius.circular(25.0),
                image: DecorationImage(
                  image: AssetImage(plants[index].imagePath),
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
                  '${plants[index].name} - \$${plants[index].price.toStringAsFixed(0)}',
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
    int selectId = 0;
  int activePage = 0;
}