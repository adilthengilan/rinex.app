import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rinex/src/view/screens/home.dart';

import 'package:iconly/iconly.dart';
import 'package:rinex/src/view/screens/profile_Page/profile.dart';
import 'package:rinex/src/view/screens/propertyListing_Page/propertylist.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final pages = [HomeScreen(), Propertylist(), ProfilePage(), ProfilePage()];
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: pages[index],
      bottomNavigationBar: Container(
        height: 120,
        width: 230,
        child: CrystalNavigationBar(
          // enableFloatingNavBar: true,
          height: 85, // 🔼 Increased height (default was 25)
          currentIndex: index,
          unselectedItemColor: Colors.black54, // 🔼 visible on white bg
          backgroundColor: Colors.white, // 🔼 solid white background
          borderWidth: 1,
          outlineBorderColor: Colors.grey.withOpacity(0.3),
          onTap: (num) {
            setState(() {
              index = num;
            });
          },
          items: [
            /// Home
            CrystalNavigationBarItem(
              icon: IconlyBold.home,
              unselectedIcon: IconlyLight.home,
              selectedColor: Colors.blue,
            ),

            /// Favourite
            CrystalNavigationBarItem(
              icon: IconlyBold.heart,
              unselectedIcon: IconlyLight.heart,
              selectedColor: Colors.blue,
            ),
            CrystalNavigationBarItem(
              unselectedColor: const Color.fromARGB(0, 255, 255, 255),
              icon: IconlyBold.activity,
              unselectedIcon: IconlyLight.activity,
              selectedColor: const Color.fromARGB(0, 33, 149, 243),
            ),

            /// Add
            CrystalNavigationBarItem(
              icon: IconlyBold.plus,
              unselectedIcon: IconlyLight.plus,
              selectedColor: Colors.blue,
            ),

            /// Search
            CrystalNavigationBarItem(
              icon: IconlyBold.search,
              unselectedIcon: IconlyLight.search,
              selectedColor: Colors.blue,
            ),

            /// Profile
            // CrystalNavigationBarItem(
            //   icon: IconlyBold.user_2,
            //   unselectedIcon: IconlyLight.user,
            //   selectedColor: Colors.orange,
            // ),
          ],
        ),
      ),
    );
  }
}
