import 'dart:math' as math;
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/styles/stroke_rounded.dart';
import 'package:rinex/src/view/screens/home.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:iconly/iconly.dart';
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
    Searchpage(),
    ReelsScreen(),
    ProfilePage(),
  ];
  int selectedIndex = 0;
  final navigationName = ['Home', 'Properties', '', 'Supreme', 'Profile'];
  final icons = [
    HugeIcons.strokeRoundedHome01,
    HugeIcons.strokeRoundedBuilding05,
    HugeIcons.strokeRoundedAdd01,
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
                  spacing: 20,
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

      // 🔹 Custom Bottom Navigation
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
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
                height: 80,
                width: double.infinity,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 15,
                      right: 10,
                      bottom: 10,
                    ),
                    child: ListView.builder(
                      itemCount: navigationName.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final iconss = icons[index];
                        final name = navigationName[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 16,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Column(
                              children: [
                                HugeIcon(
                                  icon: iconss,
                                  color: selectedIndex == index
                                      ? Colors.blue
                                      : const Color(0xFFB3B3B3),
                                ),
                                Text(
                                  name,
                                  style: GoogleFonts.poppins(
                                    color: selectedIndex == index
                                        ? Colors.blue
                                        : const Color(0xFFB3B3B3),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // 🔘 Center Add Button
            Positioned(
              left: MediaQuery.of(context).size.width / 2.2,
              top: 22,
              child: GestureDetector(
                onTap: _toggleOptions,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue,
                  child: RotationTransition(
                    turns: Tween(begin: 0.0, end: 0.5).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: Curves.easeInOut,
                      ),
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
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
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}



//  Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(children: [Icon(IconlyBold.home), Text('Home')]),
//                     Column(
//                       children: [
//                         HugeIcon(
//                           icon: HugeIcons.strokeRoundedBuilding05,
//                           color: Colors.black,
//                         ),
//                       ],
//                     ),
//                     Column(
//                       children: [
//                         CircleAvatar(
//                           backgroundColor: Colors.blue,
//                           child: HugeIcon(
//                             icon: HugeIcons.strokeRoundedAdd01,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Column(children: [Icon(Icons.home)]),
//                     Column(children: [Icon(Icons.home)]),
//                   ],
//                 ),