import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:plant_app/components/my_bottom_nav_bar.dart';
import 'package:plant_app/constants.dart';
import 'package:plant_app/screens/home/components/body.dart';
import 'package:plant_app/widgets/drawers_main.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(),
        drawer: MainDrawer(),
    );
  }


  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: kPrimaryColor,
      leading: Builder(
        builder: (context) => IconButton(
          icon: SvgPicture.asset("assets/icons/menu.svg"),
          onPressed: () {
            Scaffold.of(context).openDrawer(); // 👈 opens the drawer
          },
        ),
      ),
    );
  }
}
