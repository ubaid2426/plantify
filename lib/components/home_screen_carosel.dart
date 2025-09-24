// ignore: file_names
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomePageCarousel extends StatelessWidget {
  final List<String> imageList;
  final double carouselHeight; // Changed the name to be more descriptive

  // Accepting a list of image URLs or file paths via constructor
  const HomePageCarousel(
      {super.key, required this.imageList, required this.carouselHeight});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        
      ),
      home: HomePage(imageList: imageList, carouselHeight: carouselHeight),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<String> imageList;
  final double carouselHeight; // Accepting carouselHeight here

  // Constructor to accept imageList and carouselHeight in HomePage widget
  const HomePage(
      {super.key, required this.imageList, required this.carouselHeight});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CarouselSlider(
            items: imageList.map((imagePath) {
              return Container(
                margin: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              height: carouselHeight, // Using carouselHeight here
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              viewportFraction: 1,
            ),
          ),
        ],
      ),
    );
  }
}
