

import 'package:flutter/material.dart';
import 'package:rinex/src/view/login.dart';
import 'package:rinex/src/view/register.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPageIndex = 0;
  final PageController _pageController = PageController();

  // Define your onboarding data
  final List<Map<String, String>> onboardingData = [
    {
      'image':
          'lib/assets/property.jpg', // Using your provided image for the map illustration
      'title_part1': 'Lorem ',
      'title_part2': 'Ipsum is simply',
      'title_part3': '\ndummy text printing',
      'description':
          'Lorem Ipsum is simply dummy text of the\nprinting and typesetting industry.',
    },
    {
      'image':
          'lib/assets/onboard2.jpg', // Using your provided image for the calendar illustration
      'title_part1': 'Lorem ',
      'title_part2': 'Ipsum is simply',
      'title_part3': '\ndummy text printing',
      'description':
          'Lorem Ipsum is simply dummy text of the\nprinting and typesetting industry.',
    },
    // The last page will have the Register and Log In buttons
    {
      'image':
          'lib/assets/property3.jpg', // Re-using 4th.jpg or use a different one if you have it for the last page
      'title_part1': 'Lorem ',
      'title_part2': 'Ipsum is simply',
      'title_part3': '\ndummy text printing',
      'description':
          'Lorem Ipsum is simply dummy text of the\nprinting and typesetting industry.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:
          Colors.black, // Background color outside the rounded container
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white, // White background for the main content area
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: onboardingData.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentPageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight:
                                  constraints.maxHeight -
                                  (currentPageIndex == onboardingData.length - 1
                                      ? (screenHeight * 0.015 +
                                            screenHeight * 0.03 +
                                            screenHeight * 0.025 +
                                            (screenWidth * 0.13 * 2 +
                                                screenHeight *
                                                    0.02)) // Adjusted for two buttons and spacing
                                      : (screenHeight * 0.015 +
                                            screenHeight * 0.03 +
                                            screenHeight * 0.025 +
                                            (screenWidth *
                                                0.13))), // Original for navigation buttons
                            ),
                            child: IntrinsicHeight(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      screenWidth * 0.08, // 8% of screen width
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: screenHeight * 0.02),

                                    // Illustration
                                    Container(
                                      height:
                                          screenHeight *
                                          0.35, // 35% of screen height
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors
                                            .grey[50], // Light grey background for image area
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          onboardingData[index]['image']!,
                                          height:
                                              screenHeight *
                                              0.28, // 28% of screen height
                                          width:
                                              screenWidth *
                                              0.7, // 70% of screen width
                                          fit: BoxFit.contain,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                // Fallback if image is not found
                                                return Container(
                                                  height: screenHeight * 0.28,
                                                  width: screenWidth * 0.7,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.image,
                                                    size: 80,
                                                    color: Colors.grey,
                                                  ),
                                                );
                                              },
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      height: screenHeight * 0.04,
                                    ), // 4% of screen height
                                    // Title
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize:
                                              screenWidth *
                                              0.075, // 7.5% of screen width
                                          fontWeight: FontWeight.bold,
                                          height: 1.2,
                                          color: const Color(
                                            0xFF2D3748,
                                          ), // Dark text color
                                        ),
                                        children: [
                                          TextSpan(
                                            text:
                                                onboardingData[index]['title_part1']!,
                                          ),
                                          TextSpan(
                                            text:
                                                onboardingData[index]['title_part2']!,
                                            style: const TextStyle(
                                              color: Color(
                                                0xFF3B82F6,
                                              ), // Blue text for "Ipsum is simply"
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                onboardingData[index]['title_part3']!,
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: screenHeight * 0.02,
                                    ), // 2% of screen height
                                    // Description
                                    Text(
                                      onboardingData[index]['description']!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize:
                                            screenWidth *
                                            0.035, // 3.5% of screen width
                                        color: const Color(
                                          0xFF9CA3AF,
                                        ), // Grey text color
                                        height: 1.5,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),

                                    SizedBox(height: screenHeight * 0.02),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Bottom section with indicators and buttons
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.08, // 8% left
                      screenHeight * 0.015, // 1.5% top
                      screenWidth * 0.08, // 8% right
                      screenHeight * 0.03, // 3% bottom
                    ),
                    child: Column(
                      children: [
                        // Page indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(onboardingData.length, (
                            index,
                          ) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 8,
                              width: index == currentPageIndex ? 24 : 8,
                              decoration: BoxDecoration(
                                color: index == currentPageIndex
                                    ? const Color(0xFF3B82F6) // Blue for active
                                    : const Color(
                                        0xFFE5E7EB,
                                      ), // Light grey for inactive
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          }),
                        ),

                        SizedBox(
                          height: screenHeight * 0.025,
                        ), // 2.5% of screen height
                        // Conditional rendering of navigation or login/register buttons
                        if (currentPageIndex < onboardingData.length - 1)
                          // Navigation buttons for all pages except the last one
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Back button
                              if (currentPageIndex > 0)
                                Container(
                                  width:
                                      screenWidth * 0.13, // 13% of screen width
                                  height: screenWidth * 0.13, // Keep it square
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFE5E7EB,
                                    ), // Light grey background
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF3B82F6),
                                      width: 2,
                                    ), // Blue border
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      _pageController.previousPage(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeIn,
                                      );
                                    },
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: const Color(
                                        0xFF3B82F6,
                                      ), // Blue icon color
                                      size: screenWidth * 0.05,
                                    ),
                                  ),
                                )
                              else
                                SizedBox(
                                  width: screenWidth * 0.13,
                                ), // Placeholder for alignment
                              // Skip button
                              TextButton(
                                onPressed: () {
                                  print('Skip pressed');
                                  // Navigate to the last onboarding page to show login/register
                                  _pageController.animateToPage(
                                    onboardingData.length - 1,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn,
                                  );
                                },
                                child: Text(
                                  'Skip',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    color: const Color(
                                      0xFF3B82F6,
                                    ), // Blue text color
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              // Next button
                              Container(
                                width:
                                    screenWidth * 0.13, // 13% of screen width
                                height: screenWidth * 0.13, // Keep it square
                                decoration: const BoxDecoration(
                                  color: Color(0xFF3B82F6), // Blue background
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    _pageController.nextPage(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeIn,
                                    );
                                  },
                                  icon: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white, // White icon color
                                    size: screenWidth * 0.05,
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          // Register and Login buttons for the last page
                          Column(
                            children: [
                              // Register Button
                              SizedBox(
                                width: double.infinity,
                                height:
                                    screenWidth *
                                    0.13, // Same height as circular buttons for consistency
                                child: OutlinedButton(
                                  onPressed: () {
                                    print(
                                      'Register pressed, navigating to RegisterScreen',
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterScreen(),
                                      ),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(
                                      0xFF3B82F6,
                                    ), // Text color
                                    side: const BorderSide(
                                      color: Color(0xFF3B82F6),
                                      width: 2,
                                    ), // Border color and width
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        screenWidth * 0.13 / 2,
                                      ), // Half of height for fully rounded corners
                                    ),
                                  ),
                                  child: Text(
                                    'Register',
                                    style: TextStyle(
                                      fontSize:
                                          screenWidth *
                                          0.045, // Slightly larger font for buttons
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.02,
                              ), // Spacing between buttons
                              // Log In Button
                              SizedBox(
                                width: double.infinity,
                                height: screenWidth * 0.13,
                                child: ElevatedButton(
                                  onPressed: () {
                                    print(
                                      'Log In pressed, navigating to LoginScreen',
                                    );
                                    // Navigate to the LoginScreen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                      0xFF3B82F6,
                                    ), // Background color
                                    foregroundColor: Colors.white, // Text color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        screenWidth * 0.13 / 2,
                                      ), // Half of height for fully rounded corners
                                    ),
                                    elevation: 0, // No shadow
                                  ),
                                  child: Text(
                                    'Log In',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
