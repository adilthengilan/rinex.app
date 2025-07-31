
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rinex/src/view/screens/editprofile.dart';
import 'package:rinex/src/view/screens/favourites.dart';
import 'package:rinex/src/view/screens/notifications.dart';
import 'package:rinex/src/view/screens/profile.dart';
import 'package:rinex/src/view/screens/propertylist.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _currentLocation = 'Getting Location...';
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _favoriteProperties = [];

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
    },
  ];

  final List<Map<String, String>> _mockLocations = [
    {'name': 'Bali', 'image': 'lib/assets/property2.jpg'},
    {'name': 'Jakarta', 'image': 'lib/assets/building.jpg'},
    {'name': 'Yogyakarta', 'image': 'lib/assets/property4.jpg'},
    {'name': 'Bandung', 'image': 'lib/assets/property2.jpg'},
    {'name': 'Surabaya', 'image': 'lib/assets/building.jpg'},
  ];

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.home_outlined, 'label': 'Home'},
    {'icon': Icons.apartment_outlined, 'label': 'Apartments'},
    {'icon': Icons.business_outlined, 'label': 'Commercial'},
    {'icon': Icons.villa_outlined, 'label': 'Villas'},
    {'icon': Icons.home_outlined, 'label': 'Home'},
    {'icon': Icons.apartment_outlined, 'label': 'Apartments'},
    {'icon': Icons.business_outlined, 'label': 'Commercial'},
    {'icon': Icons.villa_outlined, 'label': 'Villas'},
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
    },
    {
      'id': 5,
      'image': 'lib/assets/property4.jpg',
      'name': 'Ocean View Tower',
      'rating': 4.8,
      'location': 'Bali, Indonesia',
      'price': '\$ 320',
      'period': '/month',
      'isFavorite': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  @override
  void dispose() {
    _searchController.dispose();
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
      await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
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
      case 0: break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Propertylist()));
        break;
      case 2:
        _showAddListingOptions();
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => Editprofile()));
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
        break;
    }
  }

  void _showAddListingOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Add New Listing', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ...[
              {'icon': Icons.camera_alt, 'title': 'Take Photo'},
              {'icon': Icons.photo_library, 'title': 'Choose from Gallery'},
              {'icon': Icons.edit, 'title': 'Manual Entry'},
            ].map((item) => ListTile(
              leading: Icon(item['icon'] as IconData, color: Colors.blue),
              title: Text(item['title'] as String),
              onTap: () => Navigator.pop(context),
            )).toList(),
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
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopSection(size, padding),
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
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

 
  Widget _buildTopSection(Size size, EdgeInsets padding) {
    return Container(
      width: size.width,
      height: size.height * 0.32,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1976D2), Color(0xFF2196F3), Color(0xFF42A5F5)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Row(
            children: [
              // Left Content
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Navigation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildTopNavIcon(Icons.notifications_outlined, () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen()));
                        }),
                        const SizedBox(width: 8),
                        _buildTopNavIcon(Icons.favorite_outline, () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => FavoriteScreen(favoriteProperties: [],),
                          ));
                        }),
                      ],
                    ),
                    const Spacer(),
                    
                    // Main Heading
                    Text(
                      '"Find the best\nclients anytime,\nanywhere."',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.045,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: size.height * 0.015),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.03,
                                vertical: size.height * 0.012,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(color: Colors.white.withOpacity(0.3)),
                              ),
                              child: Text(
                                'Enter your account',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width * 0.03,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: size.width * 0.02),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: const Color(0xFF1976D2),
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.04,
                              vertical: size.height * 0.012,
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            elevation: 0,
                          ),
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.03,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              
              // Right Content - Agent Image
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox(
                        height: size.height * 0.15,
                        width: size.width * 0.25,
                        child: Image.asset(
                          'lib/assets/agent.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.white.withOpacity(0.1),
                            child: Icon(
                              Icons.person,
                              size: size.width * 0.12,
                              color: Colors.white,
                            ),
                          ),
                        ),
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


  Widget _buildTopNavIcon(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 22),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildSearchBar(Size size) {
    return Container(
      margin: EdgeInsets.all(size.width * 0.045),
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.035),
      height: size.height * 0.065,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 4))],
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(fontSize: size.width * 0.038),
        decoration: InputDecoration(
          hintText: 'Search House, Apartment, etc',
          prefixIcon: Icon(Icons.search, color: Colors.grey, size: size.width * 0.055),
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.grey, fontSize: size.width * 0.035),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.045,
        vertical: size.height * 0.01,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: size.width * 0.02,
          mainAxisSpacing: size.height * 0.015,
          childAspectRatio: 0.85,
        ),
        itemCount: _categories.length,
        itemBuilder: (context, index) => _buildCategoryItem(_categories[index], size),
      ),
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
                  'Featured Properties',
                  style: TextStyle(
                    fontSize: size.width * 0.042,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Propertylist()));
                  },
                  child: Text(
                    'view all',
                    style: TextStyle(
                      color: const Color(0xFF1976D2),
                      fontSize: size.width * 0.032,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.015),
          SizedBox(
            height: size.height * 0.29,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
              itemCount: _mockProperties.length,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.only(right: size.width * 0.035),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Propertylist()));
                  },
                  child: _buildPropertyCard(_mockProperties[index], size),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyCard(Map<String, dynamic> property, Size size) {
    return Container(
      width: size.width * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: SizedBox(
                  height: size.height * 0.14,
                  width: double.infinity,
                  child: Image.asset(
                    property['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.apartment, size: size.width * 0.12, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFF1976D2), borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    'renex assured',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.022,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () => _toggleFavorite(property),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                    child: Icon(
                      property['isFavorite'] ? Icons.favorite : Icons.favorite_outline,
                      color: property['isFavorite'] ? Colors.red : const Color(0xFF1976D2),
                      size: size.width * 0.04,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.035),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    property['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.width * 0.037,
                      color: const Color(0xFF1A1A1A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: size.width * 0.035),
                      SizedBox(width: size.width * 0.01),
                      Text(
                        '${property['rating']}',
                        style: TextStyle(
                          fontSize: size.width * 0.03,
                          color: const Color(0xFF666666),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: size.width * 0.02),
                      Icon(Icons.location_on_outlined, color: const Color(0xFF666666), size: size.width * 0.032),
                      SizedBox(width: size.width * 0.005),
                      Expanded(
                        child: Text(
                          property['location'],
                          style: TextStyle(
                            fontSize: size.width * 0.03,
                            color: const Color(0xFF666666),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.bed_outlined, color: const Color(0xFF666666), size: size.width * 0.035),
                          SizedBox(width: size.width * 0.01),
                          Text(
                            property['rooms'],
                            style: TextStyle(
                              fontSize: size.width * 0.03,
                              color: const Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: property['price'],
                              style: TextStyle(
                                fontSize: size.width * 0.037,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1976D2),
                              ),
                            ),
                            TextSpan(
                              text: property['period'],
                              style: TextStyle(
                                fontSize: size.width * 0.028,
                                color: const Color(0xFF666666),
                              ),
                            ),
                          ],
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

  Widget _buildRequirementCard(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: size.width * 0.045,
        vertical: size.height * 0.01,
      ),
      padding: EdgeInsets.all(size.width * 0.035),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFF1976D2), borderRadius: BorderRadius.circular(8)),
            child: Text(
              'REQUIREMENT',
              style: TextStyle(
                color: Colors.white,
                fontSize: size.width * 0.022,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: size.width * 0.025),
          Container(
            width: size.width * 0.07,
            height: size.width * 0.07,
            decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
            child: Icon(Icons.person, size: size.width * 0.04, color: Colors.grey),
          ),
          SizedBox(width: size.width * 0.025),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name Example',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.width * 0.032,
                  ),
                ),
                SizedBox(height: size.height * 0.002),
                Text(
                  'Looking for a 2 BHK apartment for rent in Kakkanad, Kochi.',
                  style: TextStyle(
                    fontSize: size.width * 0.028,
                    color: const Color(0xFF666666),
                  ),
                ),
                SizedBox(height: size.height * 0.005),
                Text(
                  'You can enter your requirements and click the arrow to post your wants',
                  style: TextStyle(
                    fontSize: size.width * 0.025,
                    color: const Color(0xFF888888),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Icon(Icons.location_on, color: const Color(0xFF1976D2), size: size.width * 0.035),
              SizedBox(width: size.width * 0.01),
              Text(
                _currentLocation,
                style: TextStyle(
                  fontSize: size.width * 0.028,
                  color: const Color(0xFF1976D2),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(width: size.width * 0.015),
          Icon(Icons.arrow_forward, color: const Color(0xFF1976D2), size: size.width * 0.045),
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
                    fontSize: size.width * 0.042,
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
            height: size.height * 0.12,
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
    return SizedBox(
      width: size.width * 0.18,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: size.width * 0.15,
            height: size.width * 0.15,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                location['image']!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.location_city,
                  size: size.width * 0.07,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.008),
          Text(
            location['name']!,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: size.width * 0.028,
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
      padding: EdgeInsets.symmetric(vertical: size.height * 0.025),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
            child: Text(
              'Explore Nearby Estates',
              style: TextStyle(
                fontSize: size.width * 0.042,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.015),
          SizedBox(
            height: size.height * 0.22,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
              itemCount: _nearbyEstates.length,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.only(right: size.width * 0.035),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Propertylist()));
                  },
                  child: _buildNearbyEstateCard(_nearbyEstates[index], size),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyEstateCard(Map<String, dynamic> estate, Size size) {
    return Container(
      width: size.width * 0.42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: SizedBox(
                  height: size.height * 0.12,
                  width: double.infinity,
                  child: Image.asset(
                    estate['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.apartment, size: size.width * 0.1, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFF1976D2), borderRadius: BorderRadius.circular(6)),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: estate['price'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.028,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: estate['period'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.022,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => _toggleFavorite(estate),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                    child: Icon(
                      estate['isFavorite'] ? Icons.favorite : Icons.favorite_outline,
                      color: estate['isFavorite'] ? Colors.red : const Color(0xFF1976D2),
                      size: size.width * 0.035,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.025),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    estate['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.width * 0.032,
                      color: const Color(0xFF1A1A1A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: size.width * 0.032),
                      SizedBox(width: size.width * 0.01),
                      Text(
                        '${estate['rating']}',
                        style: TextStyle(
                          fontSize: size.width * 0.028,
                          color: const Color(0xFF666666),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: size.width * 0.015),
                      Icon(Icons.location_on_outlined, color: const Color(0xFF666666), size: size.width * 0.028),
                      SizedBox(width: size.width * 0.005),
                      Expanded(
                        child: Text(
                          estate['location'],
                          style: TextStyle(
                            fontSize: size.width * 0.028,
                            color: const Color(0xFF666666),
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
        'image': 'lib/assets/property4.jpg',
        'icon': Icons.handshake_outlined,
        'color': Colors.orange,
      },
      {
        'title': 'Post your property for FREE',
        'subtitle': 'Find your ideal home',
        'image': 'lib/assets/building.jpg',
        'icon': Icons.add_home_outlined,
        'color': const Color(0xFF1976D2),
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.025),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
            child: Text(
              "What's new on Renex",
              style: TextStyle(
                fontSize: size.width * 0.042,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.015),
          SizedBox(
            height: size.height * 0.2,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
              itemCount: whatsNewItems.length,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.only(right: size.width * 0.035),
                child: _buildWhatsNewCard(whatsNewItems[index], size),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatsNewCard(Map<String, dynamic> item, Size size) {
    return Container(
      width: size.width * 0.48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Container(
            height: size.height * 0.11,
            decoration: BoxDecoration(
              color: item['color'].withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Stack(
              children: [
                if (item['image'] != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(
                      item['image'],
                      width: double.infinity,
                      height: size.height * 0.11,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: item['color'].withOpacity(0.1),
                        child: Center(child: Icon(item['icon'], size: size.width * 0.08, color: item['color'])),
                      ),
                    ),
                  )
                else
                  Center(child: Icon(item['icon'], size: size.width * 0.08, color: item['color'])),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.035),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    item['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.width * 0.032,
                      color: const Color(0xFF1A1A1A),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    item['subtitle'],
                    style: TextStyle(
                      fontSize: size.width * 0.028,
                      color: const Color(0xFF666666),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.arrow_forward,
                      size: size.width * 0.035,
                      color: const Color(0xFF1976D2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        elevation: 0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildBottomNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
              _buildBottomNavItem(1, Icons.apartment_outlined, Icons.apartment, 'Properties'),
              const SizedBox(width: 48),
              _buildBottomNavItem(3, Icons.videocam_outlined, Icons.videocam, 'Video'),
              _buildBottomNavItem(4, Icons.person_outline, Icons.person, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(int index, IconData outlineIcon, IconData filledIcon, String label) {
    final bool isSelected = _selectedIndex == index;
    final size = MediaQuery.of(context).size;
    
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onItemTapped(index),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF1976D2).withOpacity(0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isSelected ? filledIcon : outlineIcon,
                    color: isSelected ? const Color(0xFF1976D2) : Colors.grey[600],
                    size: size.width * 0.055,
                  ),
                ),
                SizedBox(height: size.height * 0.003),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF1976D2) : Colors.grey[600],
                    fontSize: size.width * 0.025,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    final size = MediaQuery.of(context).size;
    
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: const Color(0xFF1976D2).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: FloatingActionButton(
        backgroundColor: const Color(0xFF1976D2),
        onPressed: () => _onItemTapped(2),
        shape: const CircleBorder(),
        elevation: 0,
        child: Icon(Icons.add, color: Colors.white, size: size.width * 0.065),
      ),
    );
  }
}