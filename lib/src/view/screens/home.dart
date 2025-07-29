import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // For Bottom Navigation Bar
  String _currentLocation = 'Getting Location...';
  TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _mockProperties = [
    {
      'image': 'lib/assets/building.jpg',
      'name': 'Sky Dandelions Apartment',
      'rating': 4.9,
      'location': 'Jakarta, Indonesia',
      'rooms': '3 BHK',
      'price': '\$290/month',
    },
    {
      'image': 'lib/assets/property4.jpg',
      'name': 'Green Lake Residence',
      'rating': 4.7,
      'location': 'Bali, Indonesia',
      'rooms': '2 BHK',
      'price': '\$250/month',
    },
    {
      'image': 'lib/assets/property2.jpg',
      'name': 'City View Apartment',
      'rating': 4.5,
      'location': 'Yogyakarta, Indonesia',
      'rooms': '1 BHK',
      'price': '\$180/month',
    },
    {
      'image': 'lib/assets/property4.jpg',
      'name': 'Sunset Villa',
      'rating': 4.8,
      'location': 'Lombok, Indonesia',
      'rooms': '4 BHK',
      'price': '\$400/month',
    },
  ];

  final List<Map<String, String>> _mockLocations = [
    {'name': 'Bali', 'image': 'lib/assets/property2.jpg'},
    {'name': 'Jakarta', 'image': 'lib/assets/property2.jpg'},
    {'name': 'Yogyakarta', 'image': 'lib/assets/property2.jpg'},
    {'name': 'Surabaya', 'image': 'lib/assets/property2.jpg'},
  ];


  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _currentLocation = 'Location permissions are denied';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _currentLocation = 'Location permissions are permanently denied, we cannot request permissions.';
      });
      return;
    }

    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation = 'Lat: ${position.latitude}, Lon: ${position.longitude}';
        // In a real app, you would use a geocoding service here
        // to convert lat/lon to a readable address.
      });
    } catch (e) {
      setState(() {
        _currentLocation = 'Error getting location: $e';
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // In a real app, you would navigate to different pages here
    // based on the selected index.
    switch (index) {
      case 0:
      // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
        break;
      case 1:
      // Navigator.push(context, MaterialPageRoute(builder: (context) => ApartmentsPage()));
        break;
      case 2:
      // This is the FAB, typically handled separately or navigates to a new post screen
        break;
      case 3:
      // Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPage()));
        break;
      case 4:
      // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
        break;
    }
  }

  void _handleSearch(String query) {
    // Implement your search logic here
    print('Searching for: $query');
    // For a real app, this would filter properties, navigate to a search results page, etc.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Search function triggered for: "$query"')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopSection(screenSize),
            _buildSearchBar(screenSize),
            _buildCategoriesSection(),
            _buildFeaturedPropertiesSection(screenSize),
            _buildTopLocationsSection(screenSize),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Current Location: $_currentLocation',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 80), // Space for the bottom navigation bar
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildTopSection(Size screenSize) {
    return Container(
      width: screenSize.width,
      height: screenSize.height * 0.4, // Adjust height based on screen size
      decoration: const BoxDecoration(
        color: Color(0xFF2196F3), // Blue color
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                      onPressed: () {
                        print('Notifications tapped');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite_border, color: Colors.white, size: 28),
                      onPressed: () {
                        print('Favorites tapped');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '“Find the best\nclients anytime,\nanywhere.”',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenSize.width * 0.07, // Responsive font size
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "“Buy, Rent, Sell, or Lease –\nYour Easy Real Estate\nSolution.”",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: screenSize.width * 0.035,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () {
                          print('Enter your account tapped');
                        },
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Enter your account',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      print('Sign up tapped');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  print('Website URL tapped');
                  // Implement URL launcher here
                },
                child: const Text(
                  'www.renex.app',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: -screenSize.width * 0.1, // Adjusted for responsiveness
            bottom: -screenSize.height * 0.05, // Adjusted for responsiveness
            child: Image.asset(
              'lib/assets/agent.jpg',
              height: screenSize.height * 0.25, // Responsive height
              width: screenSize.width * 0.5, // Responsive width
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: screenSize.height * 0.08, // Responsive position
            left: screenSize.width * 0.02,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shield, color: Colors.blue, size: 24),
            ),
          ),
          Positioned(
            top: screenSize.height * 0.12, // Responsive position
            right: screenSize.width * 0.35,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: Colors.blue, size: 24),
            ),
          ),
          Positioned(
            bottom: screenSize.height * 0.03, // Responsive position
            left: screenSize.width * 0.05,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.description, color: Colors.blue, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(Size screenSize) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 50, // Fixed height for search bar
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: _searchController,
          onSubmitted: _handleSearch, // Call search function on submit
          decoration: InputDecoration(
            hintText: 'Search House, Apartment, etc',
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[600]),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                _searchController.clear();
                // Optionally trigger a new search with empty query
              },
            )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCategoryItem(Icons.home, 'Home', () => print('Home category tapped')),
              _buildCategoryItem(Icons.apartment, 'Apartments', () => print('Apartments category tapped')),
              _buildCategoryItem(Icons.business, 'Commercial', () => print('Commercial category tapped 1')),
              _buildCategoryItem(Icons.business, 'Commercial', () => print('Commercial category tapped 2')),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCategoryItem(Icons.home, 'Home', () => print('Home category tapped 2')),
              _buildCategoryItem(Icons.apartment, 'Apartments', () => print('Apartments category tapped 2')),
              _buildCategoryItem(Icons.business, 'Commercial', () => print('Commercial category tapped 3')),
              _buildCategoryItem(Icons.business, 'Commercial', () => print('Commercial category tapped 4')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.blue, size: 30),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(color: Colors.grey[700], fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedPropertiesSection(Size screenSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Featured Properties',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  print('View all featured properties tapped');
                },
                child: const Text(
                  'view all',
                  style: TextStyle(color: Colors.blue, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          CarouselSlider.builder(
            itemCount: _mockProperties.length,
            itemBuilder: (context, index, realIndex) {
              return _buildPropertyCard(_mockProperties[index]);
            },
            options: CarouselOptions(
              height: screenSize.height * 0.35, // Responsive height for carousel
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8, // Show part of next/previous item
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                // You can update an indicator here if needed
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyCard(Map<String, dynamic> property) {
    return Container(
      width: 250, // Fixed width for each card in carousel
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: CachedNetworkImage(
                  imageUrl: property['image'],
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    'renex assured',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 3),
                    Text(
                      '${property['rating']}',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.location_on, color: Colors.grey, size: 16),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        property['location'],
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.king_bed, color: Colors.grey, size: 16),
                    const SizedBox(width: 3),
                    Text(
                      property['rooms'],
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const Spacer(),
                    Text(
                      property['price'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
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
  }

  Widget _buildTopLocationsSection(Size screenSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top Locations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  print('Explore top locations tapped');
                },
                child: const Text(
                  'explore',
                  style: TextStyle(color: Colors.blue, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: screenSize.height * 0.15, // Responsive height for locations
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _mockLocations.length,
              itemBuilder: (context, index) {
                return _buildLocationCard(_mockLocations[index]['name']!, _mockLocations[index]['image']!);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(String locationName, String imageUrl) {
    return GestureDetector(
      onTap: () {
        print('$locationName location card tapped');
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                locationName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      elevation: 10.0,
      child: SizedBox(
        height: 60.0, // Height for the bottom bar
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildBottomNavItem(0, Icons.home, 'Home'),
            _buildBottomNavItem(1, Icons.apartment, 'Apartments'),
            const SizedBox(width: 48), // The space for the FAB
            _buildBottomNavItem(2, Icons.videocam, 'Video'),
            _buildBottomNavItem(3, Icons.person, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(int index, IconData icon, String label) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onItemTapped(index),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                color: _selectedIndex == index ? Colors.blue : Colors.grey[600],
                size: 26,
              ),
              Text(
                label,
                style: TextStyle(
                  color: _selectedIndex == index ? Colors.blue : Colors.grey[600],
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Colors.blue,
      onPressed: () {
        print('FAB tapped - Add new listing');
        _onItemTapped(2); // Set index to FAB's conceptual position if needed
        // Navigate to a "create new listing" page
      },
      shape: const CircleBorder(),
      elevation: 5.0,
      child: const Icon(Icons.add, color: Colors.white, size: 30),
    );
  }
}