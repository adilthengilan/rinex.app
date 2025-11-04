import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconly/iconly.dart';
import 'package:rinex/src/view/screens/bottom_sheet/addProperty_Page/addproperty.dart';
import 'package:rinex/src/view/screens/bottom_sheet/requirementAdd_Page/requirements.dart';
import 'package:rinex/src/view/screens/favorites_Page/favourites.dart';
import 'package:rinex/src/view/screens/profile_Page/profile.dart';
import 'package:rinex/src/view/screens/propertyListing_Page/propertylist.dart';



import 'package:rinex/src/view/screens/search_Page/searchpage.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:rinex/src/view/screens/search_Page/shuffle.dart';
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
      'image': 'assets/building.jpg',
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
      'image': 'assets/property4.jpg',
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
      'image': 'assets/property2.jpg',
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
      'image': 'assets/building.jpg',
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
    {'name': 'Bali', 'image': 'assets/bali.jpg', 'properties': '120+'},
    {'name': 'Jakarta', 'image': 'assets/jakarta.jpg', 'properties': '85+'},
    {
      'name': 'Yogyakarta',
      'image': 'assets/yogyakarta.jpg',
      'properties': '45+',
    },
    {
      'name': 'Bandung',
      'image': 'assets/building.jpg',
      'properties': '67+',
    },
  ];

  final List<Map<String, dynamic>> _categories = [
    {'icon': HugeIcons.strokeRoundedHome09, 'label': 'Home'},
    {'icon': HugeIcons.strokeRoundedBuilding05, 'label': 'Apartments'},
    {'icon': HugeIcons.strokeRoundedStore01, 'label': 'Commercial'},
    {'icon': HugeIcons.strokeRoundedOffice, 'label': 'Offices'},
 
   
  ];

  final List<Map<String, dynamic>> _nearbyEstates = [
    {
      'id': 4,
      'image': 'assets/building.jpg',
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
      'image': 'assets/property4.jpg',
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
      'image': 'assets/property2.jpg',
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
          MaterialPageRoute(builder: (context) =>  Propertylist()),
        );
        break;
      case 2:
        _showAddListingOptions();
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FavoriteScreen()),
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
                          Navigator.pop(context);
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
                          Navigator.pop(context);
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

            const SizedBox(height: 20),
            
            // Example requirement card
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
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
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
Widget _buildTopLocationsSection(Size size) {
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
                'Top Locations',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2C3E50),
                ),
              ),
              Text(
                'explore',
                style: TextStyle(
                  color: const Color(0xFF1976D2),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _mockLocations.length,
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.only(right: 30),
              child: _buildLocationCard(_mockLocations[index], size),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildLocationCard(Map<String, String> location, Size size) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            location['image']!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: const Color(0xFFE3F2FD),
              child: const Icon(
                Icons.location_city,
                size: 40,
                color: Color(0xFF1976D2),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        width: 90,
        child: Text(
          location['name']!,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: const Color(0xFF2C3E50),
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
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
                          ? Colors.blue
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
        'image': 'assets/agents.jpg',
        'tag': 'PROPERTY',
        'tagColor': Colors.orange,
      },
      {
        'title': 'Post your property\nfor FREE',
        'subtitle': 'Find your ideal home',
        'image': 'assets/postdemo.jpg',
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
            height: 160,
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
      width: isLarge ? 220 : 160,
      height: 160,
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
                        color: item['tagColor'].withOpacity(0.1),
                        child: Center(
                          child: Icon(
                            Icons.image,
                            size: 30,
                            color: item['tagColor'],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
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
          Container(
            height: 75,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    Icons.arrow_forward,
                    size: 12,
                    color: item['tagColor'],
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
      // floatingActionButton: _buildFloatingActionButton(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    //   bottomNavigationBar: _buildBottomNavigationBar(),
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
        viewportFraction: 1.0,
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

  Widget _buildSearchBar(Size size) {
    return Transform.translate(
      offset: const Offset(0, -30),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShuffleScreen()),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(2, (rowIndex) {
          return Column(
            children: List.generate(2, (colIndex) {
              int index = rowIndex * 2 + colIndex;
              if (index >= _categories.length) return const SizedBox.shrink();
              
              final category = _categories[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: _buildCategoryCard(category, size),
              );
            }),
          );
        }),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category, Size size) {
    return Container(
      width: size.width * 0.4,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
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
        children: [
          HugeIcon(
            icon: category['icon'], 
            color: const Color(0xFF1976D2), 
            size: 20
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              category['label'],
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

Widget _buildFeaturedPropertiesSection(Size size) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Featured Properties",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Searchpage()),
                );
              },
              child: const Text(
                "view all",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Carousel Slider for Properties
        SizedBox(
          height: 220,
          child: CarouselSlider.builder(
            itemCount: _mockProperties.length,
            itemBuilder: (context, index, realIndex) {
              final property = _mockProperties[index];
              return Container(
                width: size.width * 0.8,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // First Column → Image + Overlays
                    Expanded(
                      flex: 2,
                      child: Stack(
                        children: [
                          Container(
                            height: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: AssetImage(property['image']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          
                         
                          // Bottom row with Favorite and Voice Player
                          Positioned(
                            bottom: 8,
                            left: 8,
                            right: 8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Voice Player button - bottom left
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      property['isPlaying'] = !(property['isPlaying'] ?? false);
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.95),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          (property['isPlaying'] ?? false) ? Icons.pause : Icons.play_arrow,
                                          color: Colors.blue,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        // Audio wave visualization
                                        if (property['isPlaying'] ?? false) ...[
                                          ...List.generate(4, (i) => Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 0.5),
                                            child: Container(
                                              width: 1.5,
                                              height: [6, 10, 8, 5][i].toDouble(),
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: BorderRadius.circular(1),
                                              ),
                                            ),
                                          )),
                                        ] else ...[
                                          Container(
                                            width: 15,
                                            height: 1.5,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[400],
                                              borderRadius: BorderRadius.circular(1),
                                            ),
                                          ),
                                        ]
                                      ],
                                    ),
                                  ),
                                ),
                                
                                // Favorite button - bottom right
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      property['isFavorite'] = !property['isFavorite'];
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.95),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      property['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                                      color: property['isFavorite'] ? Colors.blue : Colors.blue,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Second Column → Text details
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            property['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                "${property['rating']}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  property['location'],
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.bed, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                property['rooms'],
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Text(
                                property['price'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                property['period'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            options: CarouselOptions(
              height: 220,
              viewportFraction: 0.8,
              enableInfiniteScroll: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.2,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
      ],
    ),
  );
}
  
 Widget _buildRequirementCard(Size size) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row with Requirements tag and Location
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Requirements',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Color(0xFF2196F3),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  _currentLocation ?? 'Kochi',
                  style: const TextStyle(
                    color: Color(0xFF2196F3),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Main content row
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RequirementsForm(),
              ),
            );
          },
          child: Row(
            children: [
              // Profile avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  size: 24,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 12),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Name Example',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Looking for a 2 BHK apartment\nfor rent in Kakkanad, Kochi.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'You can enter your requirements and click the arrow to\npost your wants',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            height: 1.2,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.grey,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
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