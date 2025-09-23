import 'package:flutter/material.dart';
import 'package:plant_app/components/navigation.dart';
import 'package:plant_app/constants.dart';
import 'package:plant_app/screens/home/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plant App',
      color: kPrimaryColor,
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroundColor,
        primaryColor: Color(0xFF0C9869),
        textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(body : Navigation()),
    );
  }
}
