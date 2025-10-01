import 'package:flutter/material.dart';

// Your existing SharedFavoriteManager class
class SharedFavoriteManager {
  static final SharedFavoriteManager _instance = SharedFavoriteManager._internal();
  factory SharedFavoriteManager() => _instance;
  SharedFavoriteManager._internal();

  final Set<String> _favoriteProperties = <String>{};

  Set<String> get favoriteProperties => _favoriteProperties;

  bool isFavorite(String propertyId) => _favoriteProperties.contains(propertyId);

  void addFavorite(String propertyId) => _favoriteProperties.add(propertyId);

  void removeFavorite(String propertyId) => _favoriteProperties.remove(propertyId);

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
    return allProperties.where((prop) => _favoriteProperties.contains(prop['id'])).toList();
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
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header with Search and Sort
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Search House, Apartment, etc',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A90E2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.tune,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Sort by',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Property List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: properties.length,
                itemBuilder: (context, index) {
                  final property = properties[index];
                  return PropertyCard(
                    property: property,
                    onFavoriteToggle: () {
                      setState(() {
                        _favoriteManager.toggleFavorite(property['id']);
                      });
                    },
                    isFavorite: _favoriteManager.isFavorite(property['id']),
                  );
                },
              ),
            ),
          ],
        ),
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
          // Property Image with badges and favorite button
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue[200]!,
                  Colors.blue[300]!,
                ],
              ),
            ),
            child: Stack(
              children: [
                // Property Image Placeholder
                Container(
                  width: double.infinity,
                  height: double.infinity,
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
                  child: Container(
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
                ),
                
                // Top badges and favorite button
                Positioned(
                  top: 12,
                  left: 12,
                  right: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    
                      GestureDetector(
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
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Property Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Property name and location
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
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 14,
                              ),
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
                
                // Area and furnishing details
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chair,
                            color: Colors.blue[600],
                            size: 14,
                          ),
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
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.blue[600],
                        size: 18,
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
