import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconly/iconly.dart';
import 'package:rinex/src/view/screens/addproperty.dart';
import 'package:rinex/src/view/screens/editprofile.dart';
import 'package:rinex/src/view/screens/favourites.dart';
import 'package:rinex/src/view/screens/notifications.dart';
import 'package:rinex/src/view/screens/profile.dart';
import 'package:rinex/src/view/screens/propertylist.dart';
import 'package:rinex/src/view/screens/requirements.dart';
import 'package:rinex/src/view/screens/searchpage.dart';
import 'package:rinex/src/view/screens/settings.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  String _currentLocation = 'Getting Location...';
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _favoriteProperties = [];

  // Carousel controllers
  final CarouselController _featuredCarouselController = CarouselController();
  final CarouselController _nearbyCarouselController = CarouselController();
  final PageController _bannerPageController = PageController();

  // Current page indices for indicators
  int _currentFeaturedIndex = 0;
  int _currentNearbyIndex = 0;
  int _currentBannerIndex = 0;

  // Animation controllers
  late AnimationController _fadeAnimationController;
  late AnimationController _slideAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _mockProperties = [
    {
      'id': 1,
      'image': 'lib/assets/building.jpg',
      'name': 'Sky Dandelions Apartment',
      'rating': 4.9,
      'location': 'Jakarta, Indonesia',
      'rooms': '3 BHK',
      'price': '\$ 290',
      'period': '/month',
      'isFavorite': false,
      'isNew': true,
      'isVerified': true,
    },
    {
      'id': 2,
      'image': 'lib/assets/property4.jpg',
      'name': 'Green Lake Residence',
      'rating': 4.7,
      'location': 'Bali, Indonesia',
      'rooms': '2 BHK',
      'price': '\$ 250',
      'period': '/month',
      'isFavorite': false,
      'isNew': false,
      'isVerified': true,
    },
    {
      'id': 3,
      'image': 'lib/assets/property2.jpg',
      'name': 'City View Apartment',
      'rating': 4.5,
      'location': 'Yogyakarta, Indonesia',
      'rooms': '1 BHK',
      'price': '\$ 180',
      'period': '/month',
      'isFavorite': false,
      'isNew': true,
      'isVerified': false,
    },
    {
      'id': 4,
      'image': 'lib/assets/building.jpg',
      'name': 'Modern Loft Downtown',
      'rating': 4.8,
      'location': 'Jakarta, Indonesia',
      'rooms': '2 BHK',
      'price': '\$ 320',
      'period': '/month',
      'isFavorite': false,
      'isNew': false,
      'isVerified': true,
    },
  ];

  final List<Map<String, String>> _mockLocations = [
    {'name': 'Bali', 'image': 'lib/assets/bali.jpg', 'properties': '120+'},
    {'name': 'Jakarta', 'image': 'lib/assets/jakarta.jpg', 'properties': '85+'},
    {
      'name': 'Yogyakarta',
      'image': 'lib/assets/yogyakarta.jpg',
      'properties': '45+',
    },
    {
      'name': 'Bandung',
      'image': 'lib/assets/building.jpg',
      'properties': '67+',
    },
  ];

  final List<Map<String, dynamic>> _categories = [
    {'icon': HugeIcons.strokeRoundedHome09, 'label': 'Home'},
    {'icon': HugeIcons.strokeRoundedBuilding05, 'label': 'Apartments'},
    {'icon': HugeIcons.strokeRoundedStore01, 'label': 'Commercial'},
    {'icon': HugeIcons.strokeRoundedOffice, 'label': 'Offices'},
    {'icon': HugeIcons.strokeRoundedBuilding01, 'label': 'Resorts'},
  ];

  final List<Map<String, dynamic>> _nearbyEstates = [
    {
      'id': 4,
      'image': 'lib/assets/building.jpg',
      'name': 'Wings Tower',
      'rating': 4.9,
      'location': 'Jakarta, Indonesia',
      'price': '\$ 220',
      'period': '/month',
      'isFavorite': false,
      'distance': '0.8 km',
      'type': 'Apartment',
    },
    {
      'id': 5,
      'image': 'lib/assets/property4.jpg',
      'name': 'Sunset Villa',
      'rating': 4.7,
      'location': 'Bali, Indonesia',
      'price': '\$ 180',
      'period': '/month',
      'isFavorite': false,
      'distance': '1.2 km',
      'type': 'Villa',
    },
    {
      'id': 6,
      'image': 'lib/assets/property2.jpg',
      'name': 'Urban Residences',
      'rating': 4.6,
      'location': 'Jakarta, Indonesia',
      'price': '\$ 195',
      'period': '/month',
      'isFavorite': false,
      'distance': '2.1 km',
      'type': 'Condo',
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _initAnimations();
  }

  void _initAnimations() {
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _slideAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _fadeAnimationController.forward();
    _slideAnimationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeAnimationController.dispose();
    _slideAnimationController.dispose();
    _bannerPageController.dispose();
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() => _currentLocation = 'Kochi');
        return;
      }
      _getCurrentLocation();
    } catch (e) {
      setState(() => _currentLocation = 'Kochi');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() => _currentLocation = 'Kochi');
    } catch (e) {
      setState(() => _currentLocation = 'Kochi');
    }
  }

  void _toggleFavorite(Map<String, dynamic> property) {
    setState(() {
      property['isFavorite'] = !property['isFavorite'];
      if (property['isFavorite']) {
        _favoriteProperties.add(Map<String, dynamic>.from(property));
      } else {
        _favoriteProperties.removeWhere((item) => item['id'] == property['id']);
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Propertylist()),
        );
        break;
      case 2:
        _showAddListingOptions();
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Editprofile()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
  }

  void _showAddListingOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 30),

            // Two main action buttons

            // Two main action buttons
            Row(
              children: [
                // Post your property button (Blue/Filled)
                Expanded(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A90E2), // Blue color
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4A90E2).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddPropertyPage(),
                            ),
                          );
                        },
                        child: const Center(
                          child: Text(
                            'Post your property',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                // Post your Wants button (White/Outlined)
                Expanded(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: const Color(0xFF4A90E2).withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RequirementsForm(),
                            ),
                          );
                        },
                        child: const Center(
                          child: Text(
                            'Post your Wants',
                            style: TextStyle(
                              color: Color(0xFF4A90E2),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  // Property posting options
  void _showPropertyOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 25),

            const Text(
              'Post Your Property',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 25),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Wants posting options
  void _showWantsOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 25),

            const Text(
              'Post Your Wants',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildEnhancedTopSection(size, padding),
                _buildSearchBar(size),
                _buildCategoriesSection(size),
                _buildFeaturedPropertiesSection(size),
                _buildRequirementCard(size),
                _buildTopLocationsSection(size),
                _buildNearbyEstatesSection(size),
                _buildWhatsNewSection(size),
                SizedBox(height: size.height * 0.12),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildEnhancedTopSection(Size size, EdgeInsets padding) {
    final List<String> imgList = [
      'assets/add-image/img-1.png',
      'assets/add-image/img-2.jpg',
    ];
    return CarouselSlider(
      options: CarouselOptions(
        height: size.height / 3.2,
        viewportFraction: 1.0, // full width
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        enableInfiniteScroll: true,
      ),
      items: imgList.map((item) {
        return Container(
          width: size.width,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(item), fit: BoxFit.cover),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTopNavIcon(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _buildSearchBar(Size size) {
    return Transform.translate(
      offset: const Offset(0, -30),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchPage()),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(27),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Color(0xFF1976D2), size: 24),
              const SizedBox(width: 15),
              Expanded(
                child: AbsorbPointer(
                  child: TextField(
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Search House, Apartment, etc',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(Size size) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _categories.map<Widget>((course) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: size.width / 12,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min, // <- important
            children: [
              HugeIcon(icon: course['icon'], color: Colors.blue, size: 20),
              const SizedBox(width: 10),
              Text(
                course['label'],
                style: GoogleFonts.poppins(fontSize: size.width / 28),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> category, Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(size.width * 0.035),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F7FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue.withOpacity(0.1)),
          ),
          child: Icon(
            category['icon'],
            color: const Color(0xFF1976D2),
            size: size.width * 0.055,
          ),
        ),
        SizedBox(height: size.height * 0.008),
        Flexible(
          child: Text(
            category['label'],
            style: TextStyle(
              color: Colors.grey,
              fontSize: size.width * 0.028,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedPropertiesSection(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Featured Properties',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Propertylist(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1976D2).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: Color(0xFF1976D2),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildEnhancedPropertyCard(_mockProperties, size),
          // SizedBox(
          //   child: CarouselSlider.builder(
          //     // carouselController: _featuredCarouselController,
          //     itemCount: _mockProperties.length,
          //     itemBuilder: (context, index, realIndex) {
          //       return Container(
          //         margin: const EdgeInsets.only(right: 15),
          //         child: GestureDetector(
          //           onTap: () {
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                 builder: (context) => const Propertylist(),
          //               ),
          //             );
          //           },
          //           child: _buildEnhancedPropertyCard(
          //             _mockProperties[index],
          //             size,
          //           ),
          //         ),
          //       );
          //     },
          //     options: CarouselOptions(
          //       height: 320,
          //       viewportFraction: 0.65,
          //       enableInfiniteScroll: true,
          //       autoPlay: true,
          //       autoPlayInterval: const Duration(seconds: 4),
          //       autoPlayAnimationDuration: const Duration(milliseconds: 800),
          //       autoPlayCurve: Curves.fastOutSlowIn,
          //       enlargeCenterPage: false,
          //       scrollDirection: Axis.horizontal,
          //       onPageChanged: (index, reason) {
          //         setState(() {
          //           _currentFeaturedIndex = index;
          //         });
          //       },
          //     ),
          //   ),
          //),
          const SizedBox(height: 15),
          Center(
            child: SmoothPageIndicator(
              controller: PageController(initialPage: _currentFeaturedIndex),
              count: _mockProperties.length,
              effect: WormEffect(
                dotWidth: 8,
                dotHeight: 8,
                activeDotColor: const Color(0xFF1976D2),
                dotColor: Colors.grey.withOpacity(0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedPropertyCard(
    List<Map<String, dynamic>> property,
    Size size,
  ) {
    return Container(
      margin: EdgeInsets.all(15),
      width: size.width / 1.3,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size.width / 3,
            height: 150,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          Column(
            children: [
              SizedBox(height: 14),
              SizedBox(
                width: 120,
                child: Text(
                  'jdskjkjfkdfdkjjkf',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementCard(Size size) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1976D2).withOpacity(0.1),
            const Color(0xFF1976D2).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1976D2).withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'REQUIREMENT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _currentLocation,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF1976D2).withOpacity(0.2),
                      const Color(0xFF1976D2).withOpacity(0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  size: 28,
                  color: Color(0xFF1976D2),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Looking for a 2 BHK apartment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Budget: ₹15,000 - ₹25,000/month',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopLocationsSection(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.025),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Locations',
                  style: TextStyle(
                    fontSize: size.width * 0.055,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                Text(
                  'explore',
                  style: TextStyle(
                    color: const Color(0xFF1976D2),
                    fontSize: size.width * 0.032,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.015),
          SizedBox(
            height: size.height * 0.14,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
              itemCount: _mockLocations.length,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.only(right: size.width * 0.025),
                child: _buildLocationCard(_mockLocations[index], size),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(Map<String, String> location, Size size) {
    return Container(
      width: size.width * 0.25,
      child: Column(
        children: [
          Container(
            width: size.width * 0.2,
            height: size.width * 0.2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipOval(
              child: Stack(
                children: [
                  Image.asset(
                    location['image']!,
                    fit: BoxFit.cover,
                    width: size.width * 0.2,
                    height: size.width * 0.2,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.location_city,
                        size: size.width * 0.08,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.4),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 0,
                    right: 0,
                    child: Text(
                      location['properties']!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.025,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: size.height * 0.008),
          Text(
            location['name']!,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: size.width * 0.035,
              color: const Color(0xFF1A1A1A),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyEstatesSection(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Explore Nearby Estates',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: CarouselSlider.builder(
              // carouselController: _nearbyCarouselController,
              itemCount: _nearbyEstates.length,
              itemBuilder: (context, index, realIndex) {
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: _buildEnhancedNearbyEstateCard(_nearbyEstates[index]),
                );
              },
              options: CarouselOptions(
                height: 220,
                viewportFraction: 0.45,
                enableInfiniteScroll: true,
                autoPlay: false,
                enlargeCenterPage: false,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentNearbyIndex = index;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedNearbyEstateCard(Map<String, dynamic> estate) {
    return Container(
      width: 170,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: SizedBox(
                  height: 130,
                  width: double.infinity,
                  child: Image.asset(
                    estate['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.apartment,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    estate['distance'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1976D2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: estate['price'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: estate['period'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () => _toggleFavorite(estate),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      estate['isFavorite']
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      color: estate['isFavorite']
                          ? Colors.red
                          : const Color(0xFF1976D2),
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        estate['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF1A1A1A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        estate['type'],
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${estate['rating']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF666666),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.location_on_outlined,
                        color: Color(0xFF666666),
                        size: 12,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          estate['location'],
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF666666),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatsNewSection(Size size) {
    final List<Map<String, dynamic>> whatsNewItems = [
      {
        'title': 'Connect with Agents',
        'subtitle': 'Find your ideal home',
        'image': 'lib/assets/agents.jpg',
        'tag': 'PROPERTY',
        'tagColor': Colors.orange,
      },
      {
        'title': 'Post your property\nfor FREE',
        'subtitle': 'Find your ideal home',
        'image': 'lib/assets/postdemo.jpg',
        'tag': 'Register to post your\nPROPERTY for FREE',
        'tagColor': const Color(0xFF00BCD4),
        'isLarge': true,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "What's new on Renex",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160, // Reduced height to prevent overflow
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: whatsNewItems.length,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.only(right: 12),
                child: _buildWhatsNewCard(whatsNewItems[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatsNewCard(Map<String, dynamic> item) {
    final bool isLarge = item['isLarge'] ?? false;

    return Container(
      width: isLarge ? 220 : 160, // Reduced widths to prevent overflow
      height: 160, // Fixed height
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section - Fixed height
          Container(
            height: 85,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 85,
                    child: Image.asset(
                      item['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: item['color'].withOpacity(0.1),
                        child: Center(
                          child: Icon(
                            item['icon'],
                            size: 30,
                            color: item['color'],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Tag overlay for first card only
                if (item['tag'] != null && !isLarge)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: item['tagColor'],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'PROPERTY',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Content section - Fixed height
          Container(
            height: 75,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Content area
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // For large card, show tag text
                      if (isLarge && item['tag'] != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: item['tagColor'],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Register to post your\nPROPERTY for FREE',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              height: 1.1,
                            ),
                            maxLines: 2,
                          ),
                        )
                      else
                        // Title and subtitle for regular cards
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Color(0xFF1A1A1A),
                                height: 1.1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item['subtitle'],
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF666666),
                                height: 1.1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                // Arrow icon
                Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    Icons.arrow_forward,
                    size: 12,
                    color: item['color'],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1976D2).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: FloatingActionButton(
        backgroundColor: const Color(0xFF1976D2),
        onPressed: () => _onItemTapped(2),
        shape: const CircleBorder(),
        elevation: 0,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
