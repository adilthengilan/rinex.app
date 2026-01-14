import 'dart:math' as math;
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons/styles/stroke_rounded.dart';
import 'package:iconly/iconly.dart';
import 'package:rinex/src/view/screens/favorites_Page/favourites.dart';
import 'package:rinex/src/view/screens/home.dart';
import 'package:rinex/src/view/screens/profile_Page/profile.dart';
import 'package:rinex/src/view/screens/reels.dart';
import 'package:rinex/src/view/screens/search_Page/searchpage.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showOptions = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  void _toggleOptions() {
    if (_showOptions) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() => _showOptions = !_showOptions);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final pages = [
    HomeScreen(),
    Searchpage(),
    FavoriteScreen(),
    ReelsScreen(),
    ProfilePage(),
  ];
  
  int selectedIndex = 0;
  final navigationName = ['Home', 'Properties', 'Favorites', 'Supreme', 'Profile'];
  final icons = [
    HugeIcons.strokeRoundedHome01,
    HugeIcons.strokeRoundedBuilding05,
    HugeIcons.strokeRoundedChart01,
    HugeIcons.strokeRoundedVideo01,
    HugeIcons.strokeRoundedUser,
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          MediaQuery.removePadding(
            context: context,
            removeBottom: true,
            removeLeft: true,
            child: pages[selectedIndex],
          ),

          // ✨ Floating Boxes (Post / Request)
          Positioned(
            bottom: 100,
            left: screenWidth / 30,
            child: FadeTransition(
              opacity: _controller,
              child: ScaleTransition(
                scale: _controller,
                child: Row(
                  children: [
                    _buildFloatingOption(
                      icon: Icons.post_add,
                      text: "Post Your Property",
                      color: Colors.blue,
                      textColor: Colors.white,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Post clicked')),
                        );
                      },
                    ),
                    const SizedBox(width: 20),
                    _buildFloatingOption(
                      icon: Icons.send,
                      text: "Post Your Wants",
                      color: const Color.fromARGB(255, 255, 255, 255),
                      textColor: Colors.black,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Request clicked')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // 🔹 Corrected Custom Bottom Navigation
      bottomNavigationBar: Container(
        height: 90,
        child: Stack(
          children: [
            // Background container
            Positioned(
              bottom: 0,
              left: 5,
              right: 5,
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),

            // Navigation items
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Left side items (0, 1)
                    _buildNavItem(0, screenWidth),
                    _buildNavItem(1, screenWidth),
                    
                    // Center spacer for the button
                    SizedBox(width: 60),
                    
                    // Right side items (3, 4)
                    _buildNavItem(3, screenWidth),
                    _buildNavItem(4, screenWidth),
                  ],
                ),
              ),
            ),

            // 🔘 Center Add Button
            Positioned(
              bottom: 25,
              left: screenWidth / 2 - 30,
              child: GestureDetector(
                onTap: _toggleOptions,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: RotationTransition(
                    turns: Tween(begin: 0.0, end: 0.5).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: Curves.easeInOut,
                      ),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, double screenWidth) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        width: (screenWidth - 120) / 4, // Subtract center button space and divide by 4 items
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HugeIcon(
              icon: icons[index],
              color: selectedIndex == index
                  ? Colors.blue
                  : const Color(0xFFB3B3B3),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              navigationName[index],
              style: GoogleFonts.poppins(
                color: selectedIndex == index
                    ? Colors.blue
                    : const Color(0xFFB3B3B3),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingOption({
    required IconData icon,
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        width: 160,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 8),
            Text(
              text,
              style: GoogleFonts.poppins(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}