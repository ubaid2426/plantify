import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:plant_app/components/my_bottom_nav_bar.dart';
import 'package:plant_app/constants.dart';
import 'package:plant_app/screens/Notification/Screen/notification.dart';
import 'package:plant_app/screens/home/components/body.dart';
import 'package:plant_app/widgets/drawers_main.dart';
import 'package:badges/badges.dart' as badges;

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Body(),
      drawer: MainDrawer(),
    );
  }

  // AppBar buildAppBar() {
  //   return AppBar(
  //     elevation: 0,
  //     backgroundColor: kPrimaryColor,
  //     leading: Builder(
  //       builder: (context) => IconButton(
  //         icon: SvgPicture.asset("assets/icons/menu.svg"),
  //         onPressed: () {
  //           Scaffold.of(context).openDrawer(); // 👈 opens the drawer
  //         },
  //       ),
  //     ),
  //   );
  // }

  AppBar buildAppBar(BuildContext context, {int Count = 0}) {
    return AppBar(
      elevation: 0,
      backgroundColor: kPrimaryColor,
      leading: Builder(
        builder: (context) => IconButton(
          icon: SvgPicture.asset("assets/icons/menu.svg"),
          onPressed: () {
            Scaffold.of(context).openDrawer(); // opens the drawer
          },
        ),
      ),
      actions: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.20,
          child: badges.Badge(
            badgeContent: Count > 0
                ? Text(
                    '$Count',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    textAlign: TextAlign.center,
                  )
                : null, // No badge if the count is 0
            badgeStyle: const badges.BadgeStyle(
              shape: badges.BadgeShape.circle,
              badgeColor: Colors.red,
              borderSide: BorderSide(color: Colors.white, width: 2),
              elevation: 0,
            ),
            position: badges.BadgePosition.topEnd(top: 5, end: 5),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white, // Border color
                  width: 2.0,
                ),
              ),
              child: IconButton(
                onPressed: () {
                  // Reset count if needed
                  // Count = 0; // optional: update state
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  FontAwesomeIcons.bell,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10), // optional spacing
      ],
    );
  }
}
