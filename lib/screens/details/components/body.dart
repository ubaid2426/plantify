import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:plant_app/constants.dart';
import 'package:plant_app/data/plant_data.dart';
import 'package:plant_app/models/plant_model.dart';
import 'package:plant_app/screens/cart/cartScreen.dart';

import 'image_and_icons.dart';
import 'title_and_price.dart';

class Body extends StatefulWidget {
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
  Body(
      {super.key,
      required this.id,
      required this.price,
      required this.name,
      required this.imagePath,
      required this.category,
      required this.description,
      required this.width,
      required this.height,
      required this.size,
      required this.isPopular,
      required this.isRecommended,
      required this.isFavorit,
      required this.quantity});
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ImageAndIcons(size: size, imagePath: widget.imagePath,),
          TitleAndPrice(title: widget.name, country: "Russia", price: widget.price, description: widget.description,),
          SizedBox(height: kDefaultPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                  width: size.width / 2 - 30,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                        ),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Buy Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  )),
              SizedBox(
                height: 60,
                width: size.width / 2 - 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor, // button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                      ),
                    ),
                  ),
                  onPressed: () {
                    PlantModel plant = PlantModel(
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
                      quantity: 1,
                    );
                    controller.addToCart(plant); // <-- Call controller method
                    Get.snackbar(
                      "Cart Updated",
                      "${plant.name} added to cart",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  child: Text(
                    "Add to Cart",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
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
