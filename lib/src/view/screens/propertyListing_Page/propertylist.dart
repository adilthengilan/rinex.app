import 'package:flutter/material.dart';
import 'package:rinex/propert.dart';
import 'package:rinex/src/view/screens/agentList_Page/agentlist.dart';
import 'package:rinex/src/view/screens/favorites_Page/favourites.dart'
    show FavoriteScreen;
import 'package:rinex/src/view/screens/search_Page/searchpage.dart';

// Your existing SharedFavoriteManager class
class SharedFavoriteManager {
  static final SharedFavoriteManager _instance =
      SharedFavoriteManager._internal();
  factory SharedFavoriteManager() => _instance;
  SharedFavoriteManager._internal();

  final Set<String> _favoriteProperties = <String>{};

  Set<String> get favoriteProperties => _favoriteProperties;

  bool isFavorite(String propertyId) =>
      _favoriteProperties.contains(propertyId);

  void addFavorite(String propertyId) => _favoriteProperties.add(propertyId);

  void removeFavorite(String propertyId) =>
      _favoriteProperties.remove(propertyId);
  // bool isFavorite(String propertyId) => _favoriteProperties.contains(propertyId);

  // void addFavorite(String propertyId) => _favoriteProperties.add(propertyId);

  // void removeFavorite(String propertyId) => _favoriteProperties.remove(propertyId);

  void toggleFavorite(String propertyId) {
    if (_favoriteProperties.contains(propertyId)) {
      _favoriteProperties.remove(propertyId);
    } else {
      _favoriteProperties.add(propertyId);
    }
  }

  void clearAllFavorites() => _favoriteProperties.clear();

  int get favoriteCount => _favoriteProperties.length;

  // Get favorite properties with full data
  List<Map<String, dynamic>> getFavoriteProperties() {
    final allProperties = PropertyDataService.getAllProperties();
    return allProperties
        .where((prop) => _favoriteProperties.contains(prop['id']))
        .toList();
  }
}

// Property Data Service
class PropertyDataService {
  static List<Map<String, dynamic>> getAllProperties() {
    return [
      {
        'id': '1',
        'name': 'Sky Dandelions Apartment',
        'location': 'Jakarta, Indonesia',
        'price': '₹ 10,000 /month',
        'beds': '3 BHK',
        'area': 'Area: 1000 Sqft',
        'bedrooms': 'Bedrooms: 03',
        'bathrooms': 'Bathrooms: 03',
        'kitchen': 'Kitchen: 01',
        'parking': 'Parking Available',
        'furnished': 'Semi Furnished',
        'year': '2022',
        'rating': '4.9',
        'description':
            'Beautiful apartment with modern amenities in the heart of Jakarta.',
        'amenities': ['Swimming Pool', 'Gym', '24/7 Security', 'Elevator'],
        'price': '10,000',
        'bedrooms': 3,
        'rating': 4.9,
        'area': 1000,
        'furnishing': 'Semi Furnished',
        'image': 'assets/building.jpg',
        'isPremium': true,
        'isFeatured': true,
      },
      {
        'id': '2',
        'name': 'Sky Dandelions Apartment',
        'location': 'Jakarta, Indonesia',
        'price': '10,000',
        'bedrooms': 3,
        'rating': 4.9,
        'area': 1000,
        'furnishing': 'Semi Furnished',
        'image': 'assets/building.jpg',
        'isPremium': true,
        'isFeatured': true,
      },
      {
        'id': 'prop_4',
        'imageUrl': 'lib/assets/property4.jpg',
        'propertyName': 'Luxury Villa',
        'location': 'Mumbai, India',
        'price': '₹ 25,000 /month',
        'beds': '5 BHK',
        'area': 'Area: 2500 Sqft',
        'bedrooms': 'Bedrooms: 05',
        'bathrooms': 'Bathrooms: 04',
        'kitchen': 'Kitchen: 02',
        'parking': 'Parking Available',
        'furnished': 'Fully Furnished',
        'year': '2024',
        'rating': '4.8',
        'description':
            'Luxurious villa with premium amenities and stunning views.',
        'amenities': [
          'Private Pool',
          'Home Theater',
          'Wine Cellar',
          'Maid Service',
        ],
        'id': '3',
        'name': 'Sky Dandelions Apartment',
        'location': 'Jakarta, Indonesia',
        'price': '10,000',
        'bedrooms': 3,
        'rating': 4.9,
        'area': 1000,
        'furnishing': 'Semi Furnished',
        'image': 'assets/property2.jpg',
        'isPremium': true,
        'isFeatured': true,
      },
      {
        'id': '4',
        'name': 'Sky Dandelions Apartment',
        'location': 'Jakarta, Indonesia',
        'price': '10,000',
        'bedrooms': 3,
        'rating': 4.9,
        'area': 1000,
        'furnishing': 'Semi Furnished',
        'image': 'assets/apartment.jpg',
        'isPremium': true,
        'isFeatured': true,
      },
    ];
  }
}

class Propertylist extends StatefulWidget {
  @override
  _PropertylistState createState() => _PropertylistState();
}

class _PropertylistState extends State<Propertylist> {
  final SharedFavoriteManager _favoriteManager = SharedFavoriteManager();
  List<Map<String, dynamic>> properties = [];

  @override
  void initState() {
    super.initState();
    properties = PropertyDataService.getAllProperties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(color: Colors.transparent),
      extendBody: true,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: _buildSearchBar(),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.blue,
                  size: 28,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Agentscreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.blue, size: 28),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoriteScreen(),
                    ),
                  ).then((_) {
                    // Refresh the property list when returning from favorites
                    setState(() {});
                  });
                },
              ),
              if (_favoriteManager.favoriteCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${_favoriteManager.favoriteCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildLocationAndSortFilter(),
            _buildPropertyList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PropertySearchPage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 10),
            Text(
              "Search House, Apartment, etc",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationAndSortFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Row(
              children: [
                Icon(Icons.sort, size: 20, color: Colors.grey),
                SizedBox(width: 5),
                Text(
                  "Sort by",
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
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
                const Icon(Icons.location_on, size: 20, color: Colors.grey),
                const SizedBox(width: 5),
                Text(
                  " _currentLocation",
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyList() {
    final properties = PropertyDataService.getAllProperties();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        final property = properties[index];
        return _buildPropertyCard(property);
      },
    );
  }

  Widget _buildPropertyCard(Map<String, dynamic> property) {
    final bool isFavorite = _favoriteManager.isFavorite(property['id']);

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Stack(
              children: [
                Hero(
                  tag: 'property_${property['id']}',
                  child: Image.asset(
                    property['imageUrl'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        'https://placehold.co/400x200/E0E0E0/333333?text=Image+Error',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _favoriteManager.toggleFavorite(property['id']);
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: isFavorite
                          ? Colors.red.withOpacity(0.9)
                          : Colors.white.withOpacity(0.9),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.white : Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              property['title'] ?? 'Property Title',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final Map<String, dynamic> property;
  final VoidCallback onFavoriteToggle;
  final bool isFavorite;

  const PropertyCard({
    Key? key,
    required this.property,
    required this.onFavoriteToggle,
    required this.isFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          // Property Image Section
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              image: DecorationImage(
                image: AssetImage(property['image']),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {},
              ),
            ),
            child: Stack(
              children: [
                // Overlay gradient
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),

                // Badge
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF007BFF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Renex Assured",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),

                // Favorite Button
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey[600],
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Property Details Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Property title, price, and info
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            property['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.grey[400],
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                property['location'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.bed,
                                color: Colors.grey[400],
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${property['bedrooms']} BHK',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(Icons.star, color: Colors.amber, size: 14),
                              const SizedBox(width: 2),
                              Text(
                                '${property['rating']}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '₹${property['price']}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey[800],
                                ),
                              ),
                              TextSpan(
                                text: '/month',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Area and Furnishing
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.square_foot,
                            color: Colors.blue[600],
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Area: ${property['area']} Sqft',
                            style: TextStyle(
                              color: Colors.blue[600],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.chair, color: Colors.blue[600], size: 14),
                          const SizedBox(width: 4),
                          Text(
                            property['furnishing'],
                            style: TextStyle(
                              color: Colors.blue[600],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Agentscreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.phone, size: 16),
                      label: const Text(
                        "Contact Agent",
                        style: TextStyle(fontSize: 13),
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
}
