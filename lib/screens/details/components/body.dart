import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:plant_app/constants.dart';
import 'package:plant_app/data/plant_data.dart';
import 'package:plant_app/models/Plant.dart';
import 'package:plant_app/models/plant_model.dart';
import 'package:plant_app/screens/cart/cartScreen.dart';

import 'image_and_icons.dart';
import 'title_and_price.dart';

class Body extends StatefulWidget {
  final Plant plant;
  Body({
    super.key,
    required this.plant,
  });
  @override
  _BodyState createState() => _BodyState();

}

class _BodyState extends State<Body> {
     double totalPrice = 0;
     int quantity = 1;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ImageAndIcons(
            size: size,
            imagePath: widget.plant.images.first.image,
          ),
          TitleAndPrice(
            title: widget.plant.name,
            country: "Russia",
            price: widget.plant.price,
            description: widget.plant.description,
            onTotalPriceChanged: (newTotal, qty) {
              setState(() {
                totalPrice = newTotal;
                quantity = qty;
              });
            },
          ),
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
                      id: widget.plant.id,
                      name: widget.plant.name,
                      imagePath: widget.plant.images.first.image,
                      category: widget.plant.category,
                      description: widget.plant.description,
                      price: totalPrice,
                      isFavorit: widget.plant.heart,
                      height: widget.plant.height,
                      width: widget.plant.width,
                      size: widget.plant.size,
                      isPopular: widget.plant.popular,
                      isRecommended: widget.plant.recommended,
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
