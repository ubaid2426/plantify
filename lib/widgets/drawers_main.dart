
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plant_app/components/navigation.dart';
import 'package:plant_app/constants.dart';
import 'package:plant_app/screens/Login/Screen/splash_screen.dart';
import 'package:share_plus/share_plus.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String _appVersion = "Loading...";
  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = "Version ${packageInfo.version}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 230, 226, 226),
      child: Column(
        children: [
          DrawerHeader(
            // padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  kPrimaryColor,
                  lightGreen, // Second color (#B2EA50)
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: 260,
                  width: 260,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/login/applogo.png',
                      ), // Adjust the image path
                      fit: BoxFit.contain, // Adjust the fit as needed
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                const ManyOption(
                  menuTitle: "Home",
                  // ignore: deprecated_member_use
                  fontawesome: FontAwesomeIcons.home,
                  navigateTo: Navigation(),
                ),
                const ManyOption(
                  menuTitle: "Login",
                  // ignore: deprecated_member_use
                  fontawesome: FontAwesomeIcons.rightToBracket,
                  navigateTo: SplashPage(),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _appVersion,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
                // VerticalDivider(width: 500, color: Colors.red,),
                // const DonationMenu(
                //   menuTitle: 'Donation',
                //   subOptions: [
                //     "Single Donation",
                //     "Group Donation",
                //     "Individual Donation",
                //   ],
                //   fontawesome: FontAwesomeIcons.layerGroup,
                // ),
                // const ManyOption(
                //   menuTitle: "Need Support",
                //   fontawesome: FontAwesomeIcons.briefcase,
                //   navigateTo: NeedCategory(),
                // ),
                // const ManyOption(
                //   menuTitle: "Zakat Calculator",
                //   fontawesome: FontAwesomeIcons.briefcase,
                //   navigateTo: ZakatCalculator(),
                // ),
                // const ManyOption(
                //   menuTitle: "What We Do",
                //   fontawesome: FontAwesomeIcons.briefcase,
                //   navigateTo: WhatWeDo(),
                // ),
                // const ManyOption(
                //   menuTitle: "How My Donation Used?",
                //   fontawesome: FontAwesomeIcons.briefcase,
                //   navigateTo: DonationBreakdownScreen(),
                // ),
                // const ManyOption(
                //   menuTitle: "Become A Volunteer",
                //   // ignore: deprecated_member_use
                //   fontawesome: FontAwesomeIcons.handsHelping,
                //   navigateTo: Volunteer(),
                // ),
                // const ManyOption(
                //   menuTitle: "About Us",
                //   fontawesome: FontAwesomeIcons.info,
                //   navigateTo: AboutUs(),
                // ),
                // const DonationMenu(
                //   menuTitle: 'Contact Us',
                //   subOptions: [
                //     "Call US",
                //     'Working Hours',
                //     "Branches",
                //   ],
                //   // ignore: deprecated_member_use
                //   fontawesome: FontAwesomeIcons.donate,
                // ),
                // const ManyOption(
                //   menuTitle: "Share Site Detail",
                //   fontawesome: FontAwesomeIcons.moon,
                //   navigateTo: HolyDataUpload(),
                // ),
                ElevatedButton.icon(
                  onPressed: () {
                    const String appLink =
                        "https://play.google.com/store/apps/details?id=com.example.autobazzaar"; // Android link
                    // For iOS: "https://apps.apple.com/app/idYOUR_APP_ID"

                    Share.share(
                      "Check out this amazing app! Download it now: $appLink",
                    );
                  },
                  icon: const Icon(Icons.share),
                  label: const Text("Share App"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ManyOption extends StatelessWidget {
  final String menuTitle;
  final IconData fontawesome;
  final Widget navigateTo;
  const ManyOption({
    super.key,
    required this.menuTitle,
    required this.fontawesome,
    required this.navigateTo,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selectedColor: kPrimaryColor,
      leading: Icon(
        fontawesome,
        size: 18,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      title: Text(
        menuTitle,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 15,
        ),
      ),
      onTap: () {
        // Handle the tap event here
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => navigateTo,
            // builder: (context) => const QiblaApp(),
          ),
        );
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => navigateTo), // Navigate to the screen
        // );
      },
    );
  }
}

class DonationMenu extends StatefulWidget {
  final String menuTitle;
  final List<String> subOptions;
  final IconData fontawesome;
  // bool _isExpanded = false;
  const DonationMenu({
    super.key,
    required this.menuTitle,
    required this.subOptions,
    required this.fontawesome,
  });

  @override
  State<DonationMenu> createState() => _DonationMenuState();
}

class _DonationMenuState extends State<DonationMenu> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
        side: BorderSide.none,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
        side: BorderSide.none,
      ),
      showTrailingIcon: false,
      initiallyExpanded: _isExpanded,
      onExpansionChanged: (bool expanded) {
        setState(() {
          _isExpanded = expanded;
        });
      },

      //  selectedColor: Color(0xFF7fc23a),
      title: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        color: _isExpanded ? kPrimaryColor : const Color.fromARGB(255, 230, 226, 226),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              widget.fontawesome,
              size: 18,
              color:
                  _isExpanded
                      ? const Color.fromARGB(255, 247, 247, 247)
                      : const Color.fromARGB(255, 12, 12, 12),
            ),
            const SizedBox(width: 20),
            Row(
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  widget.menuTitle,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),
                Icon(
                  _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: _isExpanded ? Colors.white : Colors.black,
                ),
              ],
            ),
          ],
        ),
      ),

      // Customize the background color based on the expanded state
      children:
          widget.subOptions.map((option) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
              child: ListTile(
                title: Text(option),
                onTap: () {
                  // Action for each sub-option
                  switch (option) {
                    case 'Call US':
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const CallUs(),
                      //   ),
                      // );
                      break;
                    case 'Working Hours':
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const WorkingHour(),
                      //   ),
                      // );
                      break;
                    case 'Branches':
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const Branches(),
                      //   ),
                      // );
                      break;

                    case 'Single Donation':
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const SingleHeading(),
                      //   ),
                      // );
                      break;

                    case 'Group Donation':
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const GroupHeading(),
                      //   ),
                      // );
                      break;
                    case 'Zakat Calculator':
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const ZakatCalculator(),
                      //   ),
                      // );
                      break;
                    case 'Individual Donation':
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const IndividualHeading(),
                      //   ),
                      // );
                      break;
                    case 'Need Support':
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const NeedCategory(),
                      //   ),
                      // );
                      break;
                    // Add other cases for remaining options...
                    default:
                    // print('$option tapped');
                  }
                },
              ),
            );
          }).toList(),
    );
  }
}
