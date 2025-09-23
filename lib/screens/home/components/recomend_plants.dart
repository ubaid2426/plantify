import 'package:flutter/material.dart';
import 'package:plant_app/data/plant_data.dart';
import 'package:plant_app/screens/details/details_screen.dart';

import '../../../constants.dart';

// class RecomendsPlants extends StatelessWidget {
//   const RecomendsPlants({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: <Widget>[
//           RecomendPlantCard(
//             image: "assets/images/image_1.png",
//             title: "Samantha",
//             country: "Russia",
//             price: 440,
//             press: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => DetailsScreen(
//                        id: widget.id,
//                       name: widget.name,
//                       imagePath: widget.imagePath,
//                       category: widget.category,
//                       description: widget.description,
//                       price: widget.price,
//                       isFavorit: widget.isFavorit,
//                       height: widget.height,
//                       width: widget.width,
//                       size: widget.size,
//                       isPopular: widget.isPopular,
//                       isRecommended: widget.isRecommended,
//                       quantity: 1,
//                   ),
//                 ),
//               );
//             },
//           ),
//           RecomendPlantCard(
//             image: "assets/images/image_2.png",
//             title: "Angelica",
//             country: "Russia",
//             price: 440,
//             press: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => DetailsScreen(),
//                 ),
//               );
//             },
//           ),
//           RecomendPlantCard(
//             image: "assets/images/image_3.png",
//             title: "Samantha",
//             country: "Russia",
//             price: 440,
//             press: () {},
//           ),
//         ],
//       ),
//     );
//   }
// }
class RecomendsPlants extends StatelessWidget {
  const RecomendsPlants({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: recommendedPlants.map((plant) {
          return RecomendPlantCard(
            image: plant.imagePath,
            title: plant.name,
            country: plant.category, // or another field
            price: plant.price.toInt(),
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(
                    id: plant.id,
                    name: plant.name,
                    imagePath: plant.imagePath,
                    category: plant.category,
                    description: plant.description,
                    price: plant.price,
                    isFavorit: plant.isFavorit,
                    height: plant.height,
                    width: plant.width,
                    size: plant.size,
                    isPopular: plant.isPopular,
                    isRecommended: plant.isRecommended,
                    quantity: plant.quantity,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class RecomendPlantCard extends StatelessWidget {
  const RecomendPlantCard({
    Key? key,
    required this.image,
    required this.title,
    required this.country,
    required this.price,
    required this.press,
  }) : super(key: key);

  final String image, title, country;
  final int price;
  // final Function press;
final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        left: kDefaultPadding,
        top: kDefaultPadding / 2,
        bottom: kDefaultPadding * 2.5,
      ),
      width: size.width * 0.4,
      child: Column(
        children: <Widget>[
          Image.asset(image),
          GestureDetector(
            onTap: press,
            child: Container(
              padding: EdgeInsets.all(kDefaultPadding / 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: kPrimaryColor.withOpacity(0.23),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "$title\n".toUpperCase(),
                            style: Theme.of(context).textTheme.bodyMedium,
                            ),
                        TextSpan(
                          text: "$country".toUpperCase(),
                          style: TextStyle(
                            color: kPrimaryColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text(
                    '\$$price',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        // .copyWith(color: kPrimaryColor),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
