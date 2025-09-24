import 'dart:ui';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plant_app/constants.dart';
import 'package:plant_app/screens/Message/message.dart';
import 'package:plant_app/screens/Profile/profile_main.dart';
import 'package:plant_app/screens/cart/cartScreen.dart';
import 'package:plant_app/screens/home/home_screen.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> with TickerProviderStateMixin {
  int _bottomNavIndex = 0; // Default index
  bool _isFabVisible = true; // To control FAB visibility
  late TutorialCoachMark tutorialCoachMark;

  final GlobalKey navigationButton = GlobalKey();

  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;
  late AnimationController _hideBottomBarAnimationController;
  final ScrollController _scrollController = ScrollController();

  // ... (other code remains the same)
  final List<Widget> screens = [
    HomeScreen(),
    // const Message(),
    const Message(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  final List<IconData> iconList = [
    Icons.home,
    Icons.message,
    Icons.shopping_cart,
    Icons.person,
  ];

  final List<String> itemLabels = [
    'Home',
    'Message',
    'Cart',
    'Profile',
  ];
  void _showLoginDialog() {
    //  _checkAndShowTutorial1();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // key: navigationButton1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: double.infinity,
            height: 310,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                colors: [kPrimaryColor, lightGreen],
                begin: Alignment.topRight,
                end: Alignment.topLeft,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title Section
                  const Text(
                    'Donation',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          color: Colors.black38,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Subtitle Section
                  Text(
                    'Which type of donation would you like to perform?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Button Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //  _buildDonationButton(
                      //   // key1: navigationButton2,
                      //   context: context,
                      //   label: 'Individual\nDonation',
                      //   icon: Icons.person,
                      //   color: Colors.grey.shade700,
                      //   navigateTo: const IndividualHeading(),
                      // ),
                      // _buildDonationButton(
                      //   // key1: navigationButton1,
                      //   context: context,
                      //   label: 'Group\nDonation',
                      //   icon: Icons.group,
                      //   color: Color.fromARGB(255, 163, 200, 100),
                      //   navigateTo: const GroupHeading(),
                      // ),
                    ],
                  ),
                  SizedBox(height: 15),

                  // Single Donation Button (Newly Added)
                  // _buildDonationButton(
                  //   context: context,
                  //   label: 'Single\nDonation',
                  //   icon: Icons.volunteer_activism,
                  //   color: Color(0xFF33A248),
                  //   navigateTo: const SingleHeading(), // Change to actual page
                  //   ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// A reusable method to create styled donation buttons
  Widget _buildDonationButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required Widget navigateTo,
    // required Key key1,
  }) {
    return ElevatedButton.icon(
      // key: key1,
      // key: navigationButton3,
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => navigateTo),
        );
      },
      icon: Icon(icon, size: 20, color: Colors.white),
      label: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  void initState() {
    // _checkAndShowTutorial();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _checkAndShowTutorial();
    });
    super.initState();
    _bottomNavIndex = 0;
    // Initialize Animation Controllers
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _borderRadiusAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    fabCurve = CurvedAnimation(
      parent: _fabAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
    borderRadiusCurve = CurvedAnimation(
      parent: _borderRadiusAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );

    fabAnimation = Tween<double>(begin: 0, end: 1).animate(fabCurve);
    borderRadiusAnimation =
        Tween<double>(begin: 0, end: 1).animate(borderRadiusCurve);

    _hideBottomBarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Start animations after a delay
    Future.delayed(
        const Duration(seconds: 1), () => _fabAnimationController.forward());
    Future.delayed(const Duration(seconds: 1),
        () => _borderRadiusAnimationController.forward());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification &&
        notification.metrics.axis == Axis.vertical) {
      if (notification.direction == ScrollDirection.forward) {
        if (!_isFabVisible) {
          setState(() {
            _isFabVisible = true;
          });
        }
      } else if (notification.direction == ScrollDirection.reverse) {
        if (_isFabVisible) {
          setState(() {
            _isFabVisible = false;
          });
        }
      }
      switch (notification.direction) {
        case ScrollDirection.forward:
          _hideBottomBarAnimationController.reverse();
          _fabAnimationController.forward(from: 0);
          break;
        case ScrollDirection.reverse:
          _hideBottomBarAnimationController.forward();
          _fabAnimationController.reverse(from: 1);
          break;
        case ScrollDirection.idle:
          break;
      }
    }
    return false;
  }

  // Future<void> _checkAndShowTutorial() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool isTutorialShown = prefs.getBool('istutorialShown') ?? false;

  //   if (!isTutorialShown) {
  //     createTutorial();
  //     Future.delayed(Duration.zero, () {
  //       // ignore: use_build_context_synchronously
  //       tutorialCoachMark.show(context: context);
  //     });
  //     // Mark the tutorial as shown
  //     prefs.setBool('istutorialShown', true);
  //   }
  // }

  bool _showBadge(int index) {
    // Show badge for the "Message" tab or "Cart" tab based on conditions.
    if (index == 2) {
      return controller.cartFood.isNotEmpty; // Show badge if cart is not empty.
    }
    return false;
  }

  String _getBadgeText(int index) {
    if (index == 2) {
      return controller.cartFood.length.toString(); // Cart items count.
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: ValueKey("Navigation Screen"),
      extendBody: true,
      body: NotificationListener<ScrollNotification>(
        onNotification: onScrollNotification,
        child: screens[_bottomNavIndex], // Show selected screen
      ),
      floatingActionButton: (_bottomNavIndex != 0 &&
              _bottomNavIndex != 1 &&
              _bottomNavIndex != 2 &&
              _bottomNavIndex != 3)
          ? null
          : _isFabVisible // Show FAB only if it's visible
              ? FloatingActionButton(
                  key: navigationButton,
                  backgroundColor: kPrimaryColor,
                  shape: const CircleBorder(),
                  onPressed: () {
                    _showLoginDialog();
                    // _checkAndShowTutorial1();
                    _fabAnimationController.reset();
                    _borderRadiusAnimationController.reset();
                    _borderRadiusAnimationController.forward();
                    _fabAnimationController.forward();
                  },
                  child: const Icon(
                    Icons.eco,
                    size: 30,
                  ),
                )
              : null,
      floatingActionButtonLocation: (_bottomNavIndex != 0 &&
              _bottomNavIndex != 1 &&
              _bottomNavIndex != 2 &&
              _bottomNavIndex != 3)
          ? null
          : (_isFabVisible // Set FAB location only if it's visible
              ? FloatingActionButtonLocation.centerDocked
              : null),
      bottomNavigationBar: (_bottomNavIndex != 0 &&
              _bottomNavIndex != 1 &&
              _bottomNavIndex != 2 &&
              _bottomNavIndex != 3)
          ? null
          : AnimatedBottomNavigationBar.builder(
              itemCount: iconList.length,
              tabBuilder: (int index, bool isActive) {
                final color = isActive ? kPrimaryColor : Colors.grey;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          iconList[index],
                          size: 24,
                          color: color,
                        ),
                        if (_showBadge(index)) // Show badge conditionally
                          Positioned(
                            top: -5,
                            right: -5,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Text(
                                _getBadgeText(
                                    index), // Get the badge value for this icon
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: AutoSizeText(
                        itemLabels[index],
                        maxLines: 1,
                        style: TextStyle(color: color),
                      ),
                    ),
                  ],
                );
              },
              backgroundColor: Colors.black87,
              activeIndex: _bottomNavIndex,
              splashColor: kPrimaryColor,
              notchAndCornersAnimation: borderRadiusAnimation,
              splashSpeedInMilliseconds: 300,
              notchSmoothness: NotchSmoothness.defaultEdge,
              gapLocation: GapLocation.center,
              leftCornerRadius: 32,
              rightCornerRadius: 32,
              onTap: (index) {
                setState(() {
                  _bottomNavIndex = index;
                });
              },
              hideAnimationController: _hideBottomBarAnimationController,
              shadow: const BoxShadow(
                offset: Offset(0, 1),
                blurRadius: 12,
                spreadRadius: 0.5,
                color: kPrimaryColor,
              ),
            ),
    );
  }

  // void createTutorial() {
  //   tutorialCoachMark = TutorialCoachMark(
  //     targets: _createTargets(),
  //     colorShadow: const Color.fromARGB(0, 19, 203, 56),
  //     textSkip: "SKIP",
  //     paddingFocus: 10,
  //     opacityShadow: 0.5,
  //     imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
  //     onFinish: () {
  //       // print("finish");
  //       // _checkAndShowTutorialhome();
  //     },
  //     onClickTarget: (target) {
  //       // print('onClickTarget: $target');
  //     },
  //     onClickTargetWithTapPosition: (target, tapDetails) {
  //       // print("target: $target");
  //       // print(
  //       // "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
  //     },
  //     onClickOverlay: (target) {
  //       // print('onClickOverlay: $target');
  //     },
  //     onSkip: () {
  //       // print("skip");
  //       return true;
  //     },
  //   );
  // }

  // List<TargetFocus> _createTargets() {
  //   List<TargetFocus> targets = [];

  // targets.add(
  //   TargetFocus(
  //     keyTarget: navigationButton,
  //     contents: [
  //       TargetContent(
  //         align: ContentAlign.top,
  //         child: const Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           // mainAxisSize: MainAxisSize.max,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: <Widget>[
  //             Text(
  //               "Three Types of Donation You perform here",
  //               style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.white,
  //                 fontSize: 20.0,
  //               ),
  //             ),
  //             Text(
  //               "1.Sadqah",
  //               style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.white,
  //                   fontSize: 18.0),
  //             ),
  //             Padding(
  //               padding: EdgeInsets.only(top: 10.0),
  //               child: AutoSizeText(
  //                 "One Donation, Infinite Blessings! A single act of generosity can brighten someone’s life. Whether it's food, medical aid, or education, your donation creates a lasting impact. Give today and be a source of hope! ",
  //                 style: TextStyle(color: Colors.white, fontSize: 14),
  //               ),
  //             ),
  //             Text(
  //               "2.Contributed Donation",
  //               style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.white,
  //                   fontSize: 18.0),
  //             ),
  //             Padding(
  //               padding: EdgeInsets.only(top: 10.0),
  //               child: AutoSizeText(
  //                 "Join hands with others to create a lasting impact! Group donations allow multiple people to contribute towards a shared cause, whether it be building water wells, providing shelter, or supporting orphans. Together, we can complete projects faster and maximize the reward!",
  //                 style: TextStyle(color: Colors.white, fontSize: 14),
  //               ),
  //             ),
  //             Text(
  //               "3.Individual Donation",
  //               style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.white,
  //                   fontSize: 18.0),
  //             ),
  //             Padding(
  //               padding: EdgeInsets.only(top: 10.0),
  //               child: AutoSizeText(
  //                 "Be the reason someone’s prayers are answered! Complete an entire donation project on your own. Whether it’s gifting a wheelchair, sponsoring a child’s education, or funding an emergency medical procedure. Your generosity can change lives.",
  //                 style: TextStyle(color: Colors.white, fontSize: 14),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //     shape: ShapeLightFocus.Circle,
  //   ),
  // );
  //   return targets;
  // }
}
