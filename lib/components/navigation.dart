import 'dart:ui';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
}
