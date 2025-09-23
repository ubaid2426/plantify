
import 'package:flutter/material.dart';
import 'package:plant_app/constants.dart';
import 'package:plant_app/screens/PaymentMethod/payment_method.dart';
import 'package:plant_app/screens/Profile/edit_profile.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F1), // Light beige background
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ""),
      //     BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ""),
      //     BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ""),
      //     BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
      //   ],
      //   currentIndex: 3,
      //   selectedItemColor: Colors.brown,
      //   unselectedItemColor: Colors.grey,
      //   showSelectedLabels: false,
      //   showUnselectedLabels: false,
      //   backgroundColor: Colors.white,
      //   elevation: 10,
      //   type: BottomNavigationBarType.fixed,
      // ),
      body: Column(
        children: [
          SizedBox(
            height: 220,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                // Curved background
                    ClipPath(
                clipper: HeaderClipper(),
                child: Container(
                  height: 180,
                  color:  kPrimaryColor, // deep reddish
                ),
              ),

                // Profile image
                Positioned(
                  top: 100,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 46,
                      backgroundImage: AssetImage("assets/images/showroom/ava.jpeg"),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // const SizedBox(height: 70),
          const Text(
            "Ubaid Ur Rehman",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text("Lahore", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                ProfileMenuItem(
                  icon: Icons.person_outline,
                  title: "Edit profile", navigateTo: EditProfileScreen(),
                ),
                ProfileMenuItem(
                  icon: Icons.credit_card,
                  title: "Draft Listing",  navigateTo: Extra(title: "Draft Listing",),
                ),
                ProfileMenuItem(icon: Icons.wallet, title: "Payment Method", navigateTo: PaymentMethod() ),
                ProfileMenuItem(
                  icon: Icons.history,
                  title: "My History", navigateTo: Extra(title: "History",),
                ),
                ProfileMenuItem(
                  icon: 	Icons.bookmark_border,
                  title: "Save Ads", navigateTo: Extra(title: "Save Ads",),
                ),
                ProfileMenuItem(
                  icon: Icons.favorite,
                  title: "My Favorites", navigateTo: Extra(title: "Favorites",),
                ),
                ProfileMenuItem(
                  icon: Icons.notifications_none,
                  title: "Manage Notification", navigateTo: Extra(title: "Notification",),
                ),
                ProfileMenuItem(
                  icon: Icons.verified_user,
                  title: "Two factor Authentication", navigateTo: Extra(title: "Two factor Authentication",),
                ),
                ProfileMenuItem(
                  icon: 	Icons.language, navigateTo: Extra(title: "Language",),
                  title: "Language",
                ),
                ProfileMenuItem(
                  icon: Icons.help,
                  title: "Help & Support", navigateTo: Extra(title: "Help & Support",),
                ),
                ProfileMenuItem(
                  icon: Icons.logout,
                  title: "Log out",
                  isLogout: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Profile Menu Item
class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isLogout;
final Widget? navigateTo;
  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.isLogout = false,  this.navigateTo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 0.5,
      child: ListTile(
        leading: Icon(icon, color: isLogout ? kPrimaryColor : Colors.brown),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout ? kPrimaryColor : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Colors.grey,
        ),
        onTap: () {
               Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => navigateTo!,
            // builder: (context) => const QiblaApp(),
          ),
        );
        },
      ),
    );
  }
}
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);

    // Dip in the center
    path.quadraticBezierTo(
      size.width / 2, size.height,
      size.width, size.height - 40,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}



class Extra extends StatelessWidget {
  final String title;
  const Extra({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),),
      body: Center(child: Text(title)),
    );
  }
}